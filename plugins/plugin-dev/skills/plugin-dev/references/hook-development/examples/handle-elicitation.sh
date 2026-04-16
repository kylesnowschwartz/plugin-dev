#!/bin/bash
# Elicitation hook example: auto-respond to MCP server prompts
#
# Hook config:
# {
#   "Elicitation": [
#     {
#       "matcher": "my-auth-server",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/handle-elicitation.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
message=$(echo "$input" | jq -r '.message')
mode=$(echo "$input" | jq -r '.mode // "form"')

# Handle URL-based auth flows (open browser for user)
if [ "$mode" = "url" ]; then
  url=$(echo "$input" | jq -r '.url // ""')
  # Only open https URLs to prevent file://, javascript:, or other dangerous schemes
  if [[ "$url" == https://* ]]; then
    if command -v open &>/dev/null; then
      open "$url" 2>/dev/null || true
    elif command -v xdg-open &>/dev/null; then
      xdg-open "$url" 2>/dev/null || true
    fi
  fi
  # Decline -- user will complete auth in browser
  echo '{"hookSpecificOutput": {"hookEventName": "Elicitation", "action": "decline"}}'
  exit 0
fi

# Auto-accept known confirmation prompts
if echo "$message" | grep -qi "confirm"; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "Elicitation",
      action: "accept",
      content: { confirmed: true }
    }
  }'
  exit 0
fi

# Unknown prompt -- let user handle it (no output = pass through)
exit 0
