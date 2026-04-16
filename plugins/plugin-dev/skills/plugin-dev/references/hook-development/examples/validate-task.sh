#!/bin/bash
# TaskCompleted hook example: verify task deliverables before marking complete
#
# Hook config:
# {
#   "TaskCompleted": [
#     {
#       "hooks": [
#         {
#           "type": "command",
#           "command": "bash ${CLAUDE_PLUGIN_ROOT}/examples/validate-task.sh"
#         }
#       ]
#     }
#   ]
# }

set -euo pipefail

input=$(cat)
task_subject=$(echo "$input" | jq -r '.task_subject')
# task_description available via: echo "$input" | jq -r '.task_description // ""'

# Check if this is a code-related task
if ! echo "$task_subject" | grep -qiE 'implement|fix|refactor|add|create|update|remove|delete'; then
  # Non-code task, allow completion
  exit 0
fi

# Verify tests pass (try common test runners)
test_passed=false
if [ -f "Makefile" ] && grep -q '^test:' Makefile; then
  make test >/dev/null 2>&1 && test_passed=true
elif [ -f "package.json" ] && jq -e '.scripts.test' package.json >/dev/null 2>&1; then
  npm test >/dev/null 2>&1 && test_passed=true
elif [ -f "Cargo.toml" ]; then
  cargo test >/dev/null 2>&1 && test_passed=true
elif [ -f "go.mod" ]; then
  go test ./... >/dev/null 2>&1 && test_passed=true
else
  # No recognizable test runner, allow completion
  exit 0
fi

if [ "$test_passed" = false ]; then
  echo "Tests must pass before completing task: $task_subject" >&2
  exit 2 # Reject completion, agent continues working
fi
