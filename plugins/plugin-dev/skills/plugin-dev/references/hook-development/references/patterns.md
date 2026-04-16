# Common Hook Patterns

This reference provides common, proven patterns for implementing Claude Code hooks. Use these patterns as starting points for typical hook use cases.

## Pattern 1: Security Validation

Block dangerous file writes using prompt-based hooks:

```json
{
  "PreToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "File path: $TOOL_INPUT.file_path. Verify: 1) Not in /etc or system directories 2) Not .env or credentials 3) Path doesn't contain '..' traversal. Return 'approve' or 'deny'."
        }
      ]
    }
  ]
}
```

**Use for:** Preventing writes to sensitive files or system directories.

## Pattern 2: Test Enforcement

Ensure tests run before stopping:

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Review transcript. If code was modified (Write/Edit tools used), verify tests were executed. If no tests were run, block with reason 'Tests must be run after code changes'."
        }
      ]
    }
  ]
}
```

**Use for:** Enforcing quality standards and preventing incomplete work.

## Pattern 3: Context Loading

Load project-specific context at session start:

```json
{
  "SessionStart": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/load-context.sh"
        }
      ]
    }
  ]
}
```

**Example script (load-context.sh):**

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# Detect project type
if [ -f "package.json" ]; then
  echo "📦 Node.js project detected"
  echo "export PROJECT_TYPE=nodejs" >> "$CLAUDE_ENV_FILE"
elif [ -f "Cargo.toml" ]; then
  echo "🦀 Rust project detected"
  echo "export PROJECT_TYPE=rust" >> "$CLAUDE_ENV_FILE"
fi
```

**Use for:** Automatically detecting and configuring project-specific settings.

## Pattern 4: Notification Logging

Log all notifications for audit or analysis:

```json
{
  "Notification": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-notification.sh"
        }
      ]
    }
  ]
}
```

**Use for:** Tracking user notifications or integration with external logging systems.

## Pattern 5: MCP Tool Monitoring

Monitor and validate MCP tool usage:

```json
{
  "PreToolUse": [
    {
      "matcher": "mcp__.*__delete.*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Deletion operation detected. Verify: Is this deletion intentional? Can it be undone? Are there backups? Return 'approve' only if safe."
        }
      ]
    }
  ]
}
```

**Use for:** Protecting against destructive MCP operations.

## Pattern 6: Build Verification

Ensure project builds after code changes:

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Check if code was modified. If Write/Edit tools were used, verify the project was built (npm run build, cargo build, etc). If not built, block and request build."
        }
      ]
    }
  ]
}
```

**Use for:** Catching build errors before committing or stopping work.

## Pattern 7: Permission Confirmation

Ask user before dangerous operations:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Command: $TOOL_INPUT.command. If command contains 'rm', 'delete', 'drop', or other destructive operations, return 'ask' to confirm with user. Otherwise 'approve'."
        }
      ]
    }
  ]
}
```

**Use for:** User confirmation on potentially destructive commands.

## Pattern 8: Code Quality Checks

Run linters or formatters on file edits:

```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-quality.sh"
        }
      ]
    }
  ]
}
```

**Example script (check-quality.sh):**

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Run linter if applicable
if [[ "$file_path" == *.js ]] || [[ "$file_path" == *.ts ]]; then
  npx eslint "$file_path" 2>&1 || true
fi
```

**Use for:** Automatic code quality enforcement.

## Pattern Combinations

Combine multiple patterns for comprehensive protection:

```json
{
  "PreToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Validate file write safety"
        }
      ]
    },
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Validate bash command safety"
        }
      ]
    }
  ],
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Verify tests run and build succeeded"
        }
      ]
    }
  ],
  "SessionStart": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/load-context.sh"
        }
      ]
    }
  ]
}
```

This provides multi-layered protection and automation.

## Pattern 9: Temporarily Active Hooks

Create hooks that only run when explicitly enabled via flag files:

```bash
#!/bin/bash
# Hook only active when flag file exists
FLAG_FILE="$CLAUDE_PROJECT_DIR/.enable-security-scan"

if [ ! -f "$FLAG_FILE" ]; then
  # Quick exit when disabled
  exit 0
fi

# Flag present, run validation
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Run security scan
security-scanner "$file_path"
```

**Activation:**

```bash
# Enable the hook
touch .enable-security-scan

# Disable the hook
rm .enable-security-scan
```

**Use for:**

- Temporary debugging hooks
- Feature flags for development
- Project-specific validation that's opt-in
- Performance-intensive checks only when needed

**Note:** Must restart Claude Code after creating/removing flag files for hooks to recognize changes.

## Pattern 10: Configuration-Driven Hooks

Use JSON configuration to control hook behavior:

```bash
#!/bin/bash
CONFIG_FILE="$CLAUDE_PROJECT_DIR/.claude/my-plugin.local.json"

# Read configuration
if [ -f "$CONFIG_FILE" ]; then
  strict_mode=$(jq -r '.strictMode // false' "$CONFIG_FILE")
  max_file_size=$(jq -r '.maxFileSize // 1000000' "$CONFIG_FILE")
else
  # Defaults
  strict_mode=false
  max_file_size=1000000
fi

# Skip if not in strict mode
if [ "$strict_mode" != "true" ]; then
  exit 0
fi

# Apply configured limits
input=$(cat)
file_size=$(echo "$input" | jq -r '.tool_input.content | length')

if [ "$file_size" -gt "$max_file_size" ]; then
  echo '{"decision": "deny", "reason": "File exceeds configured size limit"}' >&2
  exit 2
fi
```

**Configuration file (.claude/my-plugin.local.json):**

```json
{
  "strictMode": true,
  "maxFileSize": 500000,
  "allowedPaths": ["/tmp", "/home/user/projects"]
}
```

**Use for:**

- User-configurable hook behavior
- Per-project settings
- Team-specific rules
- Dynamic validation criteria

## Pattern 11: API Error Alerting (StopFailure)

Send alerts when Claude encounters API errors:

```json
{
  "StopFailure": [
    {
      "matcher": "rate_limit|authentication_failed|billing_error",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/alert-api-error.sh"
        }
      ]
    }
  ]
}
```

**Example script (alert-api-error.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
error=$(echo "$input" | jq -r '.error')
details=$(echo "$input" | jq -r '.error_details // "none"')
session_id=$(echo "$input" | jq -r '.session_id')

# Log to file
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ERROR=$error DETAILS=$details SESSION=$session_id" \
  >> "$CLAUDE_PROJECT_DIR/.claude/api-errors.log"

# Send notification (adapt to your alerting system)
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$error: $details\" with title \"Claude Code API Error\""
fi
```

**Use for:** Monitoring rate limits, detecting auth expiry, tracking billing issues.

## Pattern 12: Task Completion Validation (TaskCompleted)

Verify task deliverables before marking complete:

```json
{
  "TaskCompleted": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate-task.sh"
        }
      ]
    }
  ]
}
```

**Example script (validate-task.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
task_subject=$(echo "$input" | jq -r '.task_subject')
task_description=$(echo "$input" | jq -r '.task_description // ""')

# Check if tests pass for code-related tasks
if echo "$task_subject" | grep -qiE 'implement|fix|refactor|add|create'; then
  if ! make test 2>/dev/null && ! npm test 2>/dev/null; then
    echo "Tests must pass before completing task: $task_subject" >&2
    exit 2  # Reject completion, agent continues
  fi
fi
```

**Use for:** Enforcing quality gates on agent team output, requiring tests before task completion.

## Pattern 13: Teammate Quality Gate (TeammateIdle)

Prevent teammates from going idle until their work meets standards:

```json
{
  "TeammateIdle": [
    {
      "hooks": [
        {
          "type": "prompt",
          "prompt": "A teammate is about to go idle. Review their last message to verify work was completed to a high standard. If there are obvious gaps (missing tests, incomplete implementation, TODOs left), reject with specific feedback."
        }
      ]
    }
  ]
}
```

**Use for:** Quality assurance in multi-agent workflows, preventing premature completion.

## Pattern 14: Custom Worktree Management (WorktreeCreate/Remove)

Manage worktrees with custom setup and cleanup:

```json
{
  "WorktreeCreate": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/create-worktree.sh"
        }
      ]
    }
  ],
  "WorktreeRemove": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/cleanup-worktree.sh"
        }
      ]
    }
  ]
}
```

**Example script (create-worktree.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
name=$(echo "$input" | jq -r '.name')

# Create worktree in a custom location
worktree_dir="/tmp/claude-worktrees/$name"
git worktree add "$worktree_dir" -b "worktree/$name" HEAD

# Install dependencies in the new worktree
cd "$worktree_dir"
if [ -f "package.json" ]; then
  npm ci --silent 2>/dev/null || true
fi

# Print the path -- this is the return value
echo "$worktree_dir"
```

**Example script (cleanup-worktree.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
worktree_path=$(echo "$input" | jq -r '.worktree_path')

# Custom cleanup before removal
if [ -d "$worktree_path/node_modules" ]; then
  rm -rf "$worktree_path/node_modules"
fi

# Remove the git worktree
git worktree remove "$worktree_path" --force 2>/dev/null || true
```

**Use for:** Custom worktree locations, dependency installation, cleanup of build artifacts.

## Pattern 15: Config Change Monitoring (ConfigChange)

Monitor and validate configuration changes for security:

```json
{
  "ConfigChange": [
    {
      "matcher": "project_settings|local_settings",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/audit-config-change.sh"
        }
      ]
    }
  ]
}
```

**Example script (audit-config-change.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
source=$(echo "$input" | jq -r '.source')
file_path=$(echo "$input" | jq -r '.file_path // "unknown"')

# Log the change
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] CONFIG_CHANGE source=$source file=$file_path" \
  >> "$CLAUDE_PROJECT_DIR/.claude/config-audit.log"

# Block permission escalations in project settings
if [ "$source" = "project_settings" ] && [ -f "$file_path" ]; then
  if jq -e '.permissions' "$file_path" >/dev/null 2>&1; then
    echo "Permission changes in project settings require manual review" >&2
    exit 2
  fi
fi
```

**Use for:** Security auditing, preventing unauthorized permission changes, change tracking.

## Pattern 16: MCP Elicitation Auto-Response (Elicitation)

Auto-respond to known MCP server prompts:

```json
{
  "Elicitation": [
    {
      "matcher": "my-auth-server",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/handle-auth-elicitation.sh"
        }
      ]
    }
  ]
}
```

**Example script (handle-auth-elicitation.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
message=$(echo "$input" | jq -r '.message')
mode=$(echo "$input" | jq -r '.mode // "form"')

# Auto-handle URL-based auth flows
if [ "$mode" = "url" ]; then
  url=$(echo "$input" | jq -r '.url // ""')
  if [ -n "$url" ]; then
    # Open in browser for the user
    open "$url" 2>/dev/null || xdg-open "$url" 2>/dev/null || true
  fi
  # Decline -- user will complete auth in browser
  echo '{"hookSpecificOutput": {"hookEventName": "Elicitation", "action": "decline"}}'
  exit 0
fi

# Auto-respond to known form prompts
if echo "$message" | grep -qi "confirm"; then
  echo '{"hookSpecificOutput": {"hookEventName": "Elicitation", "action": "accept", "content": {"confirmed": true}}}'
  exit 0
fi

# Unknown prompt -- let user handle it
exit 0
```

**Use for:** Automating auth flows, auto-confirming known prompts, filtering elicitation requests.

## Pattern 17: Compaction Monitoring (PreCompact/PostCompact)

Track what happens during context compaction:

```json
{
  "PreCompact": [
    {
      "matcher": "auto",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-compact.sh pre"
        }
      ]
    }
  ],
  "PostCompact": [
    {
      "matcher": "auto",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-compact.sh post"
        }
      ]
    }
  ]
}
```

**Example script (log-compact.sh):**

```bash
#!/bin/bash
set -euo pipefail

phase="$1"  # "pre" or "post"
input=$(cat)
trigger=$(echo "$input" | jq -r '.trigger')

log_file="$CLAUDE_PROJECT_DIR/.claude/compaction.log"

if [ "$phase" = "pre" ]; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPACT_START trigger=$trigger" >> "$log_file"
elif [ "$phase" = "post" ]; then
  summary_length=$(echo "$input" | jq -r '.compact_summary | length')
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPACT_END trigger=$trigger summary_chars=$summary_length" >> "$log_file"
fi
```

**Use for:** Debugging context loss, monitoring compaction frequency, auditing what information survives.

## Pattern 18: Instruction Loading Audit (InstructionsLoaded)

Track which instruction files Claude loads and when:

```json
{
  "InstructionsLoaded": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-instructions.sh",
          "async": true
        }
      ]
    }
  ]
}
```

**Example script (log-instructions.sh):**

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.file_path')
memory_type=$(echo "$input" | jq -r '.memory_type')
load_reason=$(echo "$input" | jq -r '.load_reason')

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] LOADED type=$memory_type reason=$load_reason path=$file_path" \
  >> "$CLAUDE_PROJECT_DIR/.claude/instructions-audit.log"
```

**Use for:** Understanding which instructions Claude sees, debugging instruction loading order, verifying that rules files are picked up correctly.
