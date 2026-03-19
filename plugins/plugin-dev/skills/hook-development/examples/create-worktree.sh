#!/bin/bash
# WorktreeCreate hook example: custom worktree creation with dependency install
#
# This is the only hook where stdout is the return value (an absolute path),
# not JSON. The path printed to stdout becomes the worktree directory.
#
# Hook config:
# {
#   "WorktreeCreate": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/create-worktree.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
name=$(echo "$input" | jq -r '.name')

# Create worktree in a designated directory
worktree_base="/tmp/claude-worktrees"
mkdir -p "$worktree_base"
worktree_dir="$worktree_base/$name"

# Create the git worktree
git worktree add "$worktree_dir" -b "worktree/$name" HEAD 2>/dev/null

# Install dependencies in the new worktree
cd "$worktree_dir"
if [ -f "package.json" ]; then
  npm ci --silent 2>/dev/null || npm install --silent 2>/dev/null || true
elif [ -f "Gemfile" ]; then
  bundle install --quiet 2>/dev/null || true
elif [ -f "requirements.txt" ]; then
  pip install -q -r requirements.txt 2>/dev/null || true
fi

# Print the absolute path -- this IS the return value
echo "$worktree_dir"
