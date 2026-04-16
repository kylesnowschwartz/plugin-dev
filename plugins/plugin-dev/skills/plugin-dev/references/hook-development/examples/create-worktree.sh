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

# Sanitize name: reject path traversal and restrict to safe characters
if [[ "$name" == *".."* ]] || [[ "$name" == /* ]] || [[ ! "$name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "Invalid worktree name: $name" >&2
  exit 1
fi

# Create worktree in a designated directory
worktree_base="/tmp/claude-worktrees"
mkdir -p "$worktree_base"
worktree_dir="$worktree_base/$name"

# Create the git worktree
if ! git worktree add "$worktree_dir" -b "worktree/$name" HEAD 2>&1; then
  echo "Failed to create worktree: $worktree_dir" >&2
  exit 1
fi

# Install dependencies in the new worktree (best-effort, log failures)
cd "$worktree_dir"
if [ -f "package.json" ]; then
  npm ci --silent 2>&1 || npm install --silent 2>&1 || echo "Warning: npm install failed" >&2
elif [ -f "Gemfile" ]; then
  bundle install --quiet 2>&1 || echo "Warning: bundle install failed" >&2
elif [ -f "requirements.txt" ]; then
  pip install -q -r requirements.txt 2>&1 || echo "Warning: pip install failed" >&2
fi

# Print the absolute path -- this IS the return value
echo "$worktree_dir"
