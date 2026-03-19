#!/bin/bash
# ConfigChange hook example: audit and optionally block config changes
#
# Hook config:
# {
#   "ConfigChange": [
#     {
#       "matcher": "project_settings|local_settings",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/audit-config-change.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
source_type=$(echo "$input" | jq -r '.source')
file_path=$(echo "$input" | jq -r '.file_path // "unknown"')
timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Log the change
log_dir="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$log_dir"
echo "[$timestamp] CONFIG_CHANGE source=$source_type file=$file_path" \
  >> "$log_dir/config-audit.log"

# Block permission changes in project settings (security measure)
if [ "$source_type" = "project_settings" ] && [ -f "$file_path" ]; then
  if jq -e '.permissions' "$file_path" >/dev/null 2>&1; then
    echo "Permission changes in project settings require manual review." >&2
    exit 2
  fi
fi

# Note: policy_settings changes cannot be blocked even if you try.
# The block decision is silently ignored for policy sources.
