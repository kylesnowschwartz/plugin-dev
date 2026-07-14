#!/bin/bash
# Hook Schema Validator
# Validates hooks.json structure and checks for common issues
# Accepts both formats:
#   - Plugin format (hooks/hooks.json): {"description": "...", "hooks": {"PreToolUse": [...]}}
#   - Settings format (.claude/settings.json "hooks" value): {"PreToolUse": [...]}

set -euo pipefail

# Usage
if [ $# -eq 0 ]; then
  echo "Usage: $0 <path/to/hooks.json>"
  echo ""
  echo "Validates hook configuration file for:"
  echo "  - Valid JSON syntax"
  echo "  - Plugin wrapper or settings format"
  echo "  - Required fields"
  echo "  - Hook type validity"
  echo "  - Matcher patterns"
  echo "  - Timeout ranges"
  exit 1
fi

HOOKS_FILE="$1"

if [ ! -f "$HOOKS_FILE" ]; then
  echo "❌ Error: File not found: $HOOKS_FILE"
  exit 1
fi

echo "🔍 Validating hooks configuration: $HOOKS_FILE"
echo ""

# Check 1: Valid JSON
echo "Checking JSON syntax..."
if ! jq empty "$HOOKS_FILE" 2>/dev/null; then
  echo "❌ Invalid JSON syntax"
  exit 1
fi
echo "✅ Valid JSON"

# Check 2: Detect format. Plugin hooks/hooks.json wraps the event map in a
# "hooks" object with an optional "description" string; settings files put
# event names at the top level. Unwrap the plugin format before validating.
echo ""
echo "Checking format..."
if jq -e '(.hooks | type) == "object" and ((keys - ["description", "hooks"]) | length == 0)' "$HOOKS_FILE" >/dev/null 2>&1; then
  echo "✅ Plugin wrapper format (description + hooks)"
  UNWRAPPED=$(mktemp)
  trap 'rm -f "$UNWRAPPED"' EXIT
  jq '.hooks' "$HOOKS_FILE" >"$UNWRAPPED"
  HOOKS_FILE="$UNWRAPPED"
else
  echo "✅ Settings format (events at top level)"
fi

# Check 3: Root structure
echo ""
echo "Checking root structure..."
VALID_EVENTS=("SessionStart" "InstructionsLoaded" "SessionEnd" "PostSession" "UserPromptSubmit" "PreToolUse" "PermissionRequest" "PermissionDenied" "PostToolUse" "PostToolUseFailure" "Stop" "StopFailure" "MessageDisplay" "SubagentStart" "SubagentStop" "TeammateIdle" "TaskCompleted" "PreCompact" "PostCompact" "ConfigChange" "CwdChanged" "FileChanged" "WorktreeCreate" "WorktreeRemove" "Elicitation" "ElicitationResult" "Notification" "BackgroundTasksChanged")

for event in $(jq -r 'keys[]' "$HOOKS_FILE"); do
  found=false
  for valid_event in "${VALID_EVENTS[@]}"; do
    if [ "$event" = "$valid_event" ]; then
      found=true
      break
    fi
  done

  if [ "$found" = false ]; then
    echo "⚠️  Unknown event type: $event"
  fi
done
echo "✅ Root structure valid"

# Check 4: Validate each hook
echo ""
echo "Validating individual hooks..."

error_count=0
warning_count=0

for event in $(jq -r 'keys[]' "$HOOKS_FILE"); do
  if [ "$(jq -r ".\"$event\" | type" "$HOOKS_FILE")" != "array" ]; then
    echo "❌ ${event}: Value must be an array of matcher groups"
    error_count=$((error_count + 1))
    continue
  fi
  hook_count=$(jq -r ".\"$event\" | length" "$HOOKS_FILE")

  for ((i = 0; i < hook_count; i++)); do
    # Check matcher (optional -- some events don't support matchers)
    matcher=$(jq -r ".\"$event\"[$i].matcher // empty" "$HOOKS_FILE")
    NO_MATCHER_EVENTS=("UserPromptSubmit" "Stop" "TeammateIdle" "TaskCompleted" "CwdChanged" "WorktreeCreate" "WorktreeRemove" "PostSession" "MessageDisplay" "BackgroundTasksChanged")
    is_no_matcher=false
    for nm_event in "${NO_MATCHER_EVENTS[@]}"; do
      if [ "$event" = "$nm_event" ]; then
        is_no_matcher=true
        break
      fi
    done
    if [ -z "$matcher" ] && [ "$is_no_matcher" = false ]; then
      echo "⚠️  ${event}[$i]: No 'matcher' field (will match all occurrences)"
      warning_count=$((warning_count + 1))
    fi
    if [[ "$matcher" == *,* ]]; then
      echo "⚠️  ${event}[$i]: Matcher '$matcher' contains a comma. Comma-separated matcher lists silently never fire; use pipe-separated patterns (CC 2.1.191). Ignore if the comma is part of a regex quantifier or character class"
      warning_count=$((warning_count + 1))
    fi

    # Check hooks array exists
    hooks=$(jq -r ".\"$event\"[$i].hooks // empty" "$HOOKS_FILE")
    if [ -z "$hooks" ] || [ "$hooks" = "null" ]; then
      echo "❌ ${event}[$i]: Missing 'hooks' array"
      error_count=$((error_count + 1))
      continue
    fi

    # Validate each hook in the array
    hook_array_count=$(jq -r ".\"$event\"[$i].hooks | length" "$HOOKS_FILE")

    for ((j = 0; j < hook_array_count; j++)); do
      hook_type=$(jq -r ".\"$event\"[$i].hooks[$j].type // empty" "$HOOKS_FILE")

      if [ -z "$hook_type" ]; then
        echo "❌ ${event}[$i].hooks[$j]: Missing 'type' field"
        error_count=$((error_count + 1))
        continue
      fi

      case "$hook_type" in
      command | prompt | http | agent | mcp_tool) ;;
      *)
        echo "❌ ${event}[$i].hooks[$j]: Invalid type '$hook_type' (must be 'command', 'prompt', 'http', 'agent', or 'mcp_tool')"
        error_count=$((error_count + 1))
        continue
        ;;
      esac

      # Check type-specific required fields
      case "$hook_type" in
      command)
        command=$(jq -r ".\"$event\"[$i].hooks[$j].command // empty" "$HOOKS_FILE")
        if [ -z "$command" ]; then
          echo "❌ ${event}[$i].hooks[$j]: Command hooks must have 'command' field"
          error_count=$((error_count + 1))
        else
          # Check for hardcoded paths
          # Checking for literal ${CLAUDE_PLUGIN_ROOT} string, not expanding
          # shellcheck disable=SC2016
          if [[ "$command" == /* ]] && [[ "$command" != *'${CLAUDE_PLUGIN_ROOT}'* ]]; then
            echo "⚠️  ${event}[$i].hooks[$j]: Hardcoded absolute path detected. Consider using \${CLAUDE_PLUGIN_ROOT}"
            warning_count=$((warning_count + 1))
          fi
        fi
        ;;
      prompt | agent)
        prompt=$(jq -r ".\"$event\"[$i].hooks[$j].prompt // empty" "$HOOKS_FILE")
        if [ -z "$prompt" ]; then
          ht_label=$(echo "$hook_type" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
          echo "❌ ${event}[$i].hooks[$j]: $ht_label hooks must have 'prompt' field"
          error_count=$((error_count + 1))
        fi
        ;;
      http)
        url=$(jq -r ".\"$event\"[$i].hooks[$j].url // empty" "$HOOKS_FILE")
        if [ -z "$url" ]; then
          echo "❌ ${event}[$i].hooks[$j]: HTTP hooks must have 'url' field"
          error_count=$((error_count + 1))
        fi
        ;;
      mcp_tool)
        server=$(jq -r ".\"$event\"[$i].hooks[$j].server // empty" "$HOOKS_FILE")
        tool=$(jq -r ".\"$event\"[$i].hooks[$j].tool // empty" "$HOOKS_FILE")
        if [ -z "$server" ] || [ -z "$tool" ]; then
          echo "❌ ${event}[$i].hooks[$j]: MCP tool hooks must have 'server' and 'tool' fields"
          error_count=$((error_count + 1))
        fi
        ;;
      esac

      # Check hook type support by event (see overview.md support matrix)
      case "$event" in
      SessionStart | WorktreeRemove | PostSession)
        if [ "$hook_type" != "command" ]; then
          echo "❌ ${event}[$i].hooks[$j]: $event only supports 'command' hook type, not '$hook_type'"
          error_count=$((error_count + 1))
        fi
        ;;
      WorktreeCreate)
        if [ "$hook_type" != "command" ] && [ "$hook_type" != "http" ]; then
          echo "❌ ${event}[$i].hooks[$j]: $event only supports 'command' and 'http' hook types, not '$hook_type'"
          error_count=$((error_count + 1))
        fi
        ;;
      esac

      # Check timeout
      timeout=$(jq -r ".\"$event\"[$i].hooks[$j].timeout // empty" "$HOOKS_FILE")
      if [ -n "$timeout" ] && [ "$timeout" != "null" ]; then
        if ! [[ "$timeout" =~ ^[0-9]+$ ]]; then
          echo "❌ ${event}[$i].hooks[$j]: Timeout must be a number"
          error_count=$((error_count + 1))
        elif [ "$timeout" -gt 600 ]; then
          echo "⚠️  ${event}[$i].hooks[$j]: Timeout $timeout seconds is very high (max 600s)"
          warning_count=$((warning_count + 1))
        elif [ "$timeout" -lt 5 ]; then
          echo "⚠️  ${event}[$i].hooks[$j]: Timeout $timeout seconds is very low"
          warning_count=$((warning_count + 1))
        fi
      fi
    done
  done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
  echo "✅ All checks passed!"
  exit 0
elif [ $error_count -eq 0 ]; then
  echo "⚠️  Validation passed with $warning_count warning(s)"
  exit 0
else
  echo "❌ Validation failed with $error_count error(s) and $warning_count warning(s)"
  exit 1
fi
