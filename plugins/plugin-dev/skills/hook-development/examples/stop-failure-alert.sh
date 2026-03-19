#!/bin/bash
# StopFailure hook example: alert on API errors
#
# Hook config:
# {
#   "StopFailure": [
#     {
#       "matcher": "rate_limit|authentication_failed|billing_error",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/stop-failure-alert.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
error=$(echo "$input" | jq -r '.error')
details=$(echo "$input" | jq -r '.error_details // "none"')
session_id=$(echo "$input" | jq -r '.session_id')
timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Log to file
log_dir="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$log_dir"
echo "[$timestamp] ERROR=$error DETAILS=$details SESSION=$session_id" \
  >> "$log_dir/api-errors.log"

# Desktop notification (macOS)
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$error: $details\" with title \"Claude Code API Error\"" 2>/dev/null || true
fi

# Desktop notification (Linux)
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code API Error" "$error: $details" 2>/dev/null || true
fi

# StopFailure output is ignored -- this is observability only
