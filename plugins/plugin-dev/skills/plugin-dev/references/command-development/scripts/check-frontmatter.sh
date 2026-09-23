#!/bin/bash
# Command Frontmatter Validator
# Validates YAML frontmatter fields in command files

set -euo pipefail

# Usage
if [ $# -eq 0 ]; then
  echo "Usage: $0 <path/to/command.md> [command2.md ...]"
  echo ""
  echo "Validates frontmatter fields for:"
  echo "  - 'model' field (sonnet, opus, haiku, or full model ID)"
  echo "  - 'description' length (warns if > 60 chars)"
  echo "  - 'allowed-tools' format"
  echo "  - 'disallowed-tools' format"
  echo "  - 'argument-hint' format"
  echo "  - 'disable-model-invocation' boolean"
  echo "  - Unknown fields (warning)"
  echo ""
  echo "Examples:"
  echo "  $0 .claude/commands/review.md"
  echo "  $0 commands/*.md"
  exit 1
fi

# Known frontmatter fields for commands
KNOWN_FIELDS="description model allowed-tools disallowed-tools argument-hint disable-model-invocation"

total_errors=0
total_warnings=0

# Validates a tool-list field (allowed-tools / disallowed-tools).
# Strips surrounding single or double quotes before comparing, so a
# YAML-quoted bare star ("*" or '*') is still flagged.
# Args: field-name value empty-message broad-message
# Echoes the result line(s) and returns 0 if a warning was emitted, 1 otherwise.
check_tool_list_field() {
  local field_name="$1"
  local raw_value="$2"
  local empty_message="$3"
  local broad_message="$4"
  local value="$raw_value"

  # Strip one layer of surrounding single or double quotes.
  if [[ "$value" =~ ^\"(.*)\"$ ]] || [[ "$value" =~ ^\'(.*)\'$ ]]; then
    value="${BASH_REMATCH[1]}"
  fi

  if [ -z "$value" ]; then
    echo "⚠️  Warning: $empty_message"
    return 0
  elif [[ "$value" == "*" ]]; then
    echo "⚠️  Warning: $field_name: $raw_value $broad_message"
    return 0
  elif [[ "$value" =~ Bash\(\*\) ]]; then
    echo "⚠️  Warning: Bash(*) is very permissive (consider Bash(git *) or similar)"
    return 0
  else
    echo "✅ $field_name: $raw_value"
    return 1
  fi
}

check_frontmatter() {
  local COMMAND_FILE="$1"
  local error_count=0
  local warning_count=0

  echo "🔍 Checking frontmatter: $COMMAND_FILE"
  echo ""

  # Check file exists
  if [ ! -f "$COMMAND_FILE" ]; then
    echo "❌ Error: File not found: $COMMAND_FILE"
    return 1
  fi

  # Check for frontmatter
  if ! head -n 1 "$COMMAND_FILE" | grep -q "^---"; then
    echo "ℹ️  No frontmatter found (frontmatter is optional)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ $COMMAND_FILE: No frontmatter to validate"
    echo ""
    return 0
  fi

  # Extract frontmatter - only the first block between lines 1 and the second ---
  # Use awk to get content between first and second --- markers only
  local frontmatter
  frontmatter=$(awk '
    /^---$/ { count++; if (count == 2) exit; next }
    count == 1 { print }
  ' "$COMMAND_FILE")

  if [ -z "$frontmatter" ]; then
    echo "⚠️  Warning: Empty frontmatter block"
    warning_count=$((warning_count + 1))
    total_warnings=$((total_warnings + warning_count))
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  $COMMAND_FILE: Passed with $warning_count warning(s)"
    echo ""
    return 0
  fi

  echo "Frontmatter found. Validating fields..."
  echo ""

  # Check 'model' field
  if echo "$frontmatter" | grep -q "^model:"; then
    local model
    model=$(echo "$frontmatter" | grep "^model:" | cut -d: -f2 | tr -d ' ')

    # Valid values: sonnet, opus, haiku, or full model ID (claude-*)
    if [[ "$model" =~ ^(sonnet|opus|haiku)$ ]]; then
      echo "✅ model: $model (shorthand)"
    elif [[ "$model" =~ ^claude- ]]; then
      echo "✅ model: $model (full model ID)"
    else
      echo "❌ Error: Invalid model '$model'"
      echo "   Valid: sonnet, opus, haiku, or full model ID (e.g., claude-sonnet-4-5-20250929)"
      error_count=$((error_count + 1))
    fi
  fi

  # Check 'description' field
  if echo "$frontmatter" | grep -q "^description:"; then
    local desc
    desc=$(echo "$frontmatter" | grep "^description:" | cut -d: -f2- | sed 's/^ *//')
    local length=${#desc}

    if [ "$length" -eq 0 ]; then
      echo "⚠️  Warning: Empty description"
      warning_count=$((warning_count + 1))
    elif [ "$length" -gt 80 ]; then
      echo "⚠️  Warning: Description too long ($length chars, recommend < 60)"
      warning_count=$((warning_count + 1))
    elif [ "$length" -gt 60 ]; then
      echo "⚠️  Warning: Description length $length (recommend < 60 chars)"
      warning_count=$((warning_count + 1))
    else
      echo "✅ description: $length chars"
    fi
  fi

  # Check 'allowed-tools' field
  if echo "$frontmatter" | grep -q "^allowed-tools:"; then
    local tools
    tools=$(echo "$frontmatter" | grep "^allowed-tools:" | cut -d: -f2- | sed 's/^ *//')

    local result
    result=$(check_tool_list_field "allowed-tools" "$tools" "Empty allowed-tools field" "grants all tools (consider restricting)")
    echo "$result"
    if [[ "$result" == ⚠️* ]]; then
      warning_count=$((warning_count + 1))
    fi
  fi

  # Check 'disallowed-tools' field
  if echo "$frontmatter" | grep -q "^disallowed-tools:"; then
    local disallowed_tools
    disallowed_tools=$(echo "$frontmatter" | grep "^disallowed-tools:" | cut -d: -f2- | sed 's/^ *//')

    local disallowed_result
    disallowed_result=$(check_tool_list_field "disallowed-tools" "$disallowed_tools" "Empty disallowed-tools field" "blocks all tools (consider restricting)")
    echo "$disallowed_result"
    if [[ "$disallowed_result" == ⚠️* ]]; then
      warning_count=$((warning_count + 1))
    fi
  fi

  # Check 'argument-hint' field
  if echo "$frontmatter" | grep -q "^argument-hint:"; then
    local hint
    hint=$(echo "$frontmatter" | grep "^argument-hint:" | cut -d: -f2- | sed 's/^ *//')

    if [ -z "$hint" ]; then
      echo "⚠️  Warning: Empty argument-hint field"
      warning_count=$((warning_count + 1))
    else
      # Check for bracket convention
      if [[ ! "$hint" =~ \[.*\] ]]; then
        echo "⚠️  Warning: argument-hint missing bracket convention (e.g., [arg-name])"
        warning_count=$((warning_count + 1))
      else
        echo "✅ argument-hint: $hint"
      fi
    fi
  fi

  # Check 'disable-model-invocation' field
  if echo "$frontmatter" | grep -q "^disable-model-invocation:"; then
    local value
    value=$(echo "$frontmatter" | grep "^disable-model-invocation:" | cut -d: -f2 | tr -d ' ')

    if [[ "$value" =~ ^(true|false)$ ]]; then
      echo "✅ disable-model-invocation: $value"
    else
      echo "❌ Error: disable-model-invocation must be true or false (got '$value')"
      error_count=$((error_count + 1))
    fi
  fi

  # Check for unknown fields
  echo ""
  echo "Checking for unknown fields..."
  local unknown_found=false

  while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Extract field name (everything before the colon)
    local field
    field=$(echo "$line" | grep -oE "^[a-z-]+" || true)

    if [ -n "$field" ]; then
      local known=false
      for known_field in $KNOWN_FIELDS; do
        if [ "$field" = "$known_field" ]; then
          known=true
          break
        fi
      done

      if [ "$known" = false ]; then
        echo "⚠️  Warning: Unknown field '$field'"
        warning_count=$((warning_count + 1))
        unknown_found=true
      fi
    fi
  done <<<"$frontmatter"

  if [ "$unknown_found" = false ]; then
    echo "✅ No unknown fields"
  fi

  # Summary
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
    echo "✅ $COMMAND_FILE: All frontmatter checks passed!"
  elif [ $error_count -eq 0 ]; then
    echo "⚠️  $COMMAND_FILE: Passed with $warning_count warning(s)"
  else
    echo "❌ $COMMAND_FILE: Failed with $error_count error(s) and $warning_count warning(s)"
  fi
  echo ""

  total_errors=$((total_errors + error_count))
  total_warnings=$((total_warnings + warning_count))

  return $error_count
}

# Process all provided files
for file in "$@"; do
  check_frontmatter "$file" || true
done

# Final summary for multiple files
if [ $# -gt 1 ]; then
  echo "═══════════════════════════════════════"
  echo "Total: $# files checked"
  echo "Errors: $total_errors"
  echo "Warnings: $total_warnings"
fi

if [ $total_errors -gt 0 ]; then
  exit 1
fi
exit 0
