#!/bin/bash
# TeammateIdle hook example: prevent idle until work meets standards
#
# Hook config:
# {
#   "TeammateIdle": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/teammate-quality-gate.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
teammate_name=$(echo "$input" | jq -r '.teammate_name')
# team_name available via: echo "$input" | jq -r '.team_name'

# Check for uncommitted changes that suggest incomplete work
if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
  # No uncommitted changes, allow idle
  exit 0
fi

# Check for common incomplete-work indicators
staged_files=$(git diff --cached --name-only 2>/dev/null || true)

# Reject if TODO/FIXME added in staged files
if [ -n "$staged_files" ]; then
  # shellcheck disable=SC2086
  if git diff --cached -- $staged_files 2>/dev/null | grep -qiE '^\+.*\b(TODO|FIXME|HACK|XXX)\b'; then
    echo "Teammate $teammate_name has TODO/FIXME markers in staged changes. Address these before going idle." >&2
    exit 2  # Reject idle, teammate keeps working
  fi
fi

# Allow idle
exit 0
