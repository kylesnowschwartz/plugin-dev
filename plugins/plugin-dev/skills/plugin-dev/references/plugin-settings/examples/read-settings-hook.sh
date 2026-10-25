#!/bin/bash
# Example hook that reads plugin settings from .claude/<plugin>.local.md
# Demonstrates the complete pattern for settings-driven hook behavior

set -euo pipefail

# Define settings file path using environment variable with default
# This allows the plugin name to be configured externally if needed
PLUGIN_NAME="${PLUGIN_NAME:-my-plugin}"
SETTINGS_FILE=".claude/${PLUGIN_NAME}.local.md"

# Quick exit if settings file doesn't exist
if [[ ! -f "$SETTINGS_FILE" ]]; then
  # Plugin not configured - use defaults or skip
  exit 0
fi

# Parse YAML frontmatter (everything between --- markers)
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$SETTINGS_FILE")

# Extract configuration fields
ENABLED=$(echo "$FRONTMATTER" | grep '^enabled:' | sed 's/enabled: *//' | sed 's/^"\(.*\)"$/\1/')
STRICT_MODE=$(echo "$FRONTMATTER" | grep '^strict_mode:' | sed 's/strict_mode: *//' | sed 's/^"\(.*\)"$/\1/')
MAX_SIZE=$(echo "$FRONTMATTER" | grep '^max_file_size:' | sed 's/max_file_size: *//')

# Quick exit if disabled
if [[ "$ENABLED" != "true" ]]; then
  exit 0
fi

# Read hook input
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Deny the tool call. The decision JSON goes to stdout with exit 0:
# Claude Code parses JSON only from stdout on exit 0. (Exit 2 would also
# block, but then stderr reaches Claude as plain text and the JSON fields,
# including systemMessage, are ignored.)
deny() {
  jq -n --arg reason "$1" \
    '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $reason}, "systemMessage": $reason}'
  exit 0
}

# Apply configured validation
if [[ "$STRICT_MODE" == "true" ]]; then
  # Strict mode: apply all checks
  if [[ "$file_path" == *".."* ]]; then
    deny "Path traversal blocked (strict mode)"
  fi

  if [[ "$file_path" == *".env"* ]] || [[ "$file_path" == *"secret"* ]]; then
    deny "Sensitive file blocked (strict mode)"
  fi
else
  # Standard mode: basic checks only
  if [[ "$file_path" == "/etc/"* ]] || [[ "$file_path" == "/sys/"* ]]; then
    deny "System path blocked"
  fi
fi

# Check file size if configured
if [[ -n "$MAX_SIZE" ]] && [[ "$MAX_SIZE" =~ ^[0-9]+$ ]]; then
  content=$(echo "$input" | jq -r '.tool_input.content // empty')
  content_size=${#content}

  if [[ $content_size -gt $MAX_SIZE ]]; then
    deny "File exceeds configured max size: ${MAX_SIZE} bytes"
  fi
fi

# All checks passed
exit 0
