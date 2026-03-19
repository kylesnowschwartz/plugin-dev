#!/bin/bash
# WorktreeRemove hook example: clean up worktree resources
#
# Output and exit code are ignored for WorktreeRemove -- this is cleanup only.
#
# Hook config:
# {
#   "WorktreeRemove": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/cleanup-worktree.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
worktree_path=$(echo "$input" | jq -r '.worktree_path')

if [ -z "$worktree_path" ] || [ ! -d "$worktree_path" ]; then
  exit 0
fi

# Clean up heavy directories before git worktree removal
for dir in node_modules .venv __pycache__ target dist build; do
  if [ -d "$worktree_path/$dir" ]; then
    rm -rf "${worktree_path:?}/$dir"
  fi
done

# Remove the git worktree
git worktree remove "$worktree_path" --force 2>/dev/null || true

# Clean up the branch if it exists
branch_name=$(basename "$worktree_path")
git branch -D "worktree/$branch_name" 2>/dev/null || true
