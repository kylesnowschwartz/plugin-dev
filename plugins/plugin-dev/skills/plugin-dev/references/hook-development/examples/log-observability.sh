#!/bin/bash
# Observability hook example: unified logging for multiple event types
#
# A single script that handles InstructionsLoaded, PreCompact, PostCompact,
# and Notification events. Use the hook_event_name field to distinguish.
#
# Hook config (add entries for each event):
# {
#   "InstructionsLoaded": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/log-observability.sh",
#           "async": true
#         }
#       ]
#     }
#   ],
#   "PreCompact": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/log-observability.sh",
#           "async": true
#         }
#       ]
#     }
#   ],
#   "PostCompact": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/log-observability.sh",
#           "async": true
#         }
#       ]
#     }
#   ],
#   "Notification": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/log-observability.sh",
#           "async": true
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
event=$(echo "$input" | jq -r '.hook_event_name')
timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

log_dir="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$log_dir"
log_file="$log_dir/session-events.log"

case "$event" in
InstructionsLoaded)
  file_path=$(echo "$input" | jq -r '.file_path')
  memory_type=$(echo "$input" | jq -r '.memory_type')
  load_reason=$(echo "$input" | jq -r '.load_reason')
  echo "[$timestamp] INSTRUCTIONS type=$memory_type reason=$load_reason path=$file_path" >>"$log_file"
  ;;

PreCompact)
  trigger=$(echo "$input" | jq -r '.trigger')
  echo "[$timestamp] COMPACT_START trigger=$trigger" >>"$log_file"
  ;;

PostCompact)
  trigger=$(echo "$input" | jq -r '.trigger')
  summary_len=$(echo "$input" | jq -r '.compact_summary | length')
  echo "[$timestamp] COMPACT_END trigger=$trigger summary_chars=$summary_len" >>"$log_file"
  ;;

Notification)
  notification_type=$(echo "$input" | jq -r '.notification_type')
  # Truncate and flatten to single line for log parsing
  message=$(echo "$input" | jq -r '.message' | tr '\n' ' ' | head -c 200)
  echo "[$timestamp] NOTIFICATION type=$notification_type msg=$message" >>"$log_file"
  ;;

*)
  echo "[$timestamp] UNKNOWN event=$event" >>"$log_file"
  ;;
esac

# All observability events: no decision control, output is ignored
