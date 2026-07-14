# Advanced Hook Use Cases

This reference covers advanced hook patterns and techniques for sophisticated automation workflows.

## Multi-Stage Validation

Combine command and prompt hooks for layered validation:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/quick-check.sh",
          "timeout": 5
        },
        {
          "type": "prompt",
          "prompt": "Deep analysis of bash command: $TOOL_INPUT",
          "timeout": 15
        }
      ]
    }
  ]
}
```

**Use case:** Fast deterministic checks followed by intelligent analysis

**Example quick-check.sh:**

```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Immediate approval for safe commands
if [[ "$command" =~ ^(ls|pwd|echo|date|whoami)$ ]]; then
  exit 0
fi

# Let prompt hook handle complex cases
exit 0
```

The command hook quickly approves obviously safe commands, while the prompt hook analyzes everything else.

## Conditional Hook Execution

### Declarative `if` Field (CC 2.1.85)

Hooks support a declarative `if` field using permission rule syntax to filter when they run:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate-git.sh",
          "if": "Bash(git *)"
        }
      ]
    }
  ]
}
```

This hook fires only for Bash commands starting with `git`. The `if` field uses the same permission rule syntax as `settings.json` allow/deny rules (e.g., `Bash(npm *)`, `Edit(src/**)`, `Write(tests/**)`). Combine with `matcher` for two-level filtering: `matcher` selects the event type, `if` narrows to specific invocations.

> **CC 2.1.88:** Fixed `if` field filtering to properly match compound commands (e.g., `ls && git push`) and commands with environment variable prefixes (e.g., `FOO=bar git push`). Previously, such commands could bypass `if` patterns.
>
> **CC 2.1.178:** Added tool parameter matching syntax (e.g., `Agent(model:opus)`) for granular permission control based on tool input parameters using wildcards.

### Script-Level Conditionals

Execute hooks based on environment or context in the script itself:

```bash
#!/bin/bash
# Only run in CI environment
if [ -z "$CI" ]; then
  echo '{"continue": true}' # Skip in non-CI
  exit 0
fi

# Run validation logic in CI
input=$(cat)
# ... validation code ...
```

**Use cases:**

- Different behavior in CI vs local development
- Project-specific validation
- User-specific rules

**Example: Skip certain checks for trusted users:**

```bash
#!/bin/bash
# Skip detailed checks for admin users
if [ "$USER" = "admin" ]; then
  exit 0
fi

# Full validation for other users
input=$(cat)
# ... validation code ...
```

## Hook Chaining via State

Share state between hooks using temporary files:

```bash
# Hook 1: Analyze and save state
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Analyze command
risk_level=$(calculate_risk "$command")
echo "$risk_level" > /tmp/hook-state-$$

exit 0
```

```bash
# Hook 2: Use saved state
#!/bin/bash
risk_level=$(cat /tmp/hook-state-$$ 2>/dev/null || echo "unknown")

if [ "$risk_level" = "high" ]; then
  echo "High risk operation detected" >&2
  exit 2
fi
```

**Important:** This only works for sequential hook events (e.g., PreToolUse then PostToolUse), not parallel hooks.

## Dynamic Hook Configuration

Modify hook behavior based on project configuration:

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# Read project-specific config
if [ -f ".claude-hooks-config.json" ]; then
  strict_mode=$(jq -r '.strict_mode' .claude-hooks-config.json)

  if [ "$strict_mode" = "true" ]; then
    # Apply strict validation
    # ...
  else
    # Apply lenient validation
    # ...
  fi
fi
```

**Example .claude-hooks-config.json:**

```json
{
  "strict_mode": true,
  "allowed_commands": ["ls", "pwd", "grep"],
  "forbidden_paths": ["/etc", "/sys"]
}
```

## Context-Aware Prompt Hooks

Use transcript and session context for intelligent decisions:

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Review the full transcript at $TRANSCRIPT_PATH. Check: 1) Were tests run after code changes? 2) Did the build succeed? 3) Were all user questions answered? 4) Is there any unfinished work? Return 'approve' only if everything is complete."
        }
      ]
    }
  ]
}
```

The LLM can read the transcript file and make context-aware decisions.

**Response format:** Agent hooks use the same response schema as prompt hooks:

```json
{ "ok": true, "reason": "Explanation of decision" }
```

Agent hooks can also use tool access for multi-turn verification (up to 50 turns). Default timeout: 60 seconds.

## Performance Optimization

### Caching Validation Results

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cache_key=$(echo -n "$file_path" | md5sum | cut -d' ' -f1)
cache_file="/tmp/hook-cache-$cache_key"

# Check cache
if [ -f "$cache_file" ]; then
  cache_age=$(($(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file")))
  if [ "$cache_age" -lt 300 ]; then  # 5 minute cache
    cat "$cache_file"
    exit 0
  fi
fi

# Perform validation
result='{"decision": "approve"}'

# Cache result
echo "$result" > "$cache_file"
echo "$result"
```

### Parallel Execution Optimization

Since hooks run in parallel, design them to be independent:

```json
{
  "PreToolUse": [
    {
      "matcher": "Write",
      "hooks": [
        {
          "type": "command",
          "command": "bash check-size.sh", // Independent
          "timeout": 2
        },
        {
          "type": "command",
          "command": "bash check-path.sh", // Independent
          "timeout": 2
        },
        {
          "type": "prompt",
          "prompt": "Check content safety", // Independent
          "timeout": 10
        }
      ]
    }
  ]
}
```

All three hooks run simultaneously, reducing total latency.

## Cross-Event Workflows

Coordinate hooks across different events:

**SessionStart - Set up tracking:**

```bash
#!/bin/bash
# Initialize session tracking
echo "0" > /tmp/test-count-$$
echo "0" > /tmp/build-count-$$
```

**PostToolUse - Track events:**

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

if [ "$tool_name" = "Bash" ]; then
  command=$(echo "$input" | jq -r '.tool_result')
  if [[ "$command" == *"test"* ]]; then
    count=$(cat /tmp/test-count-$$ 2>/dev/null || echo "0")
    echo $((count + 1)) > /tmp/test-count-$$
  fi
fi
```

**Stop - Verify based on tracking:**

```bash
#!/bin/bash
test_count=$(cat /tmp/test-count-$$ 2>/dev/null || echo "0")

if [ "$test_count" -eq 0 ]; then
  echo '{"decision": "block", "reason": "No tests were run"}' >&2
  exit 2
fi
```

## Integration with External Systems

### Slack Notifications

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
decision="blocked"

# Send notification to Slack
curl -X POST "$SLACK_WEBHOOK" \
  -H 'Content-Type: application/json' \
  -d "{\"text\": \"Hook ${decision} ${tool_name} operation\"}" \
  2>/dev/null

echo '{"decision": "deny"}' >&2
exit 2
```

### Database Logging

```bash
#!/bin/bash
input=$(cat)

# Log to database
psql "$DATABASE_URL" -c "INSERT INTO hook_logs (event, data) VALUES ('PreToolUse', '$input')" \
  2>/dev/null

exit 0
```

### Metrics Collection

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

# Send metrics to monitoring system
echo "hook.pretooluse.${tool_name}:1|c" | nc -u -w1 statsd.local 8125

exit 0
```

## Security Patterns

### Shell-Injection Prevention (CC 2.1.207)

**Critical security fix:** `${user_config.*}` interpolation in shell-form hook commands is now rejected. This prevents shell injection vulnerabilities when user-configurable plugin options contain malicious input.

**Affected hook types:** Command hooks using shell-form execution (plain `command` string without `args`).

**Resolution options:**

1. **Use exec form (`args` array)** — bypasses shell interpolation entirely:

   ```json
   {
     "type": "command",
     "command": "bash",
     "args": ["${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh", "--token", "$CLAUDE_PLUGIN_OPTION_API_TOKEN"]
   }
   ```

2. **Use `$CLAUDE_PLUGIN_OPTION_<KEY>` environment variables** — read values inside the script:

```bash
#!/bin/bash
# Script reads the env var instead of receiving shell-interpolated value
API_TOKEN="$CLAUDE_PLUGIN_OPTION_API_TOKEN"
# Use $API_TOKEN safely within the script
```

**Migration:** Audit any hooks using `${user_config.KEY}` in shell-form commands. Replace with exec form or read the value via the corresponding environment variable inside your script.

**Monitors and headersHelper:** The same restriction applies. Read configuration values inside the script (via config file path or `env` block) rather than using `${user_config.*}` interpolation.

### Input Validation

Always validate inputs in command hooks:

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

# Validate tool name format
if [[ ! "$tool_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
  echo '{"decision": "deny", "reason": "Invalid tool name"}' >&2
  exit 2
fi
```

### Path Safety

Check for path traversal and sensitive files:

```bash
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Deny path traversal
if [[ "$file_path" == *".."* ]]; then
  echo '{"decision": "deny", "reason": "Path traversal detected"}' >&2
  exit 2
fi

# Deny sensitive files
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Sensitive file"}' >&2
  exit 2
fi
```

See `examples/validate-write.sh` and `examples/validate-bash.sh` for complete examples.

### Quote All Variables

```bash
# GOOD: Quoted
echo "$file_path"
cd "$CLAUDE_PROJECT_DIR"

# BAD: Unquoted (injection risk)
echo $file_path
cd $CLAUDE_PROJECT_DIR
```

### Rate Limiting

```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Track command frequency
rate_file="/tmp/hook-rate-$$"
current_minute=$(date +%Y%m%d%H%M)

if [ -f "$rate_file" ]; then
  last_minute=$(head -1 "$rate_file")
  count=$(tail -1 "$rate_file")

  if [ "$current_minute" = "$last_minute" ]; then
    if [ "$count" -gt 10 ]; then
      echo '{"decision": "deny", "reason": "Rate limit exceeded"}' >&2
      exit 2
    fi
    count=$((count + 1))
  else
    count=1
  fi
else
  count=1
fi

echo "$current_minute" > "$rate_file"
echo "$count" >> "$rate_file"

exit 0
```

### Audit Logging

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
timestamp=$(date -Iseconds)

# Append to audit log
echo "$timestamp | $USER | $tool_name | $input" >> ~/.claude/audit.log

exit 0
```

### Secret Detection

```bash
#!/bin/bash
input=$(cat)
content=$(echo "$input" | jq -r '.tool_input.content')

# Check for common secret patterns
if echo "$content" | grep -qE "(api[_-]?key|password|secret|token).{0,20}['\"]?[A-Za-z0-9]{20,}"; then
  echo '{"decision": "deny", "reason": "Potential secret detected in content"}' >&2
  exit 2
fi

exit 0
```

## Testing Advanced Hooks

### Unit Testing Hook Scripts

```bash
# test-hook.sh
#!/bin/bash

# Test 1: Approve safe command
result=$(echo '{"tool_input": {"command": "ls"}}' | bash validate-bash.sh)
if [ $? -eq 0 ]; then
  echo "✓ Test 1 passed"
else
  echo "✗ Test 1 failed"
fi

# Test 2: Block dangerous command
result=$(echo '{"tool_input": {"command": "rm -rf /"}}' | bash validate-bash.sh)
if [ $? -eq 2 ]; then
  echo "✓ Test 2 passed"
else
  echo "✗ Test 2 failed"
fi
```

### Integration Testing

Create test scenarios that exercise the full hook workflow:

```bash
# integration-test.sh
#!/bin/bash

# Set up test environment
export CLAUDE_PROJECT_DIR="/tmp/test-project"
export CLAUDE_PLUGIN_ROOT="$(pwd)"
mkdir -p "$CLAUDE_PROJECT_DIR"

# Test SessionStart hook
echo '{}' | bash hooks/session-start.sh
if [ -f "/tmp/session-initialized" ]; then
  echo "✓ SessionStart hook works"
else
  echo "✗ SessionStart hook failed"
fi

# Clean up
rm -rf "$CLAUDE_PROJECT_DIR"
```

## Best Practices for Advanced Hooks

1. **Keep hooks independent**: Don't rely on execution order
2. **Use timeouts**: Set appropriate limits for each hook type
3. **Handle errors gracefully**: Provide clear error messages
4. **Document complexity**: Explain advanced patterns in README
5. **Test thoroughly**: Cover edge cases and failure modes
6. **Monitor performance**: Track hook execution time
7. **Version configuration**: Use version control for hook configs
8. **Provide escape hatches**: Allow users to bypass hooks when needed

## Common Pitfalls

### ❌ Assuming Hook Order

```bash
# BAD: Assumes hooks run in specific order
# Hook 1 saves state, Hook 2 reads it
# This can fail because hooks run in parallel!
```

### ❌ Long-Running Hooks

```bash
# BAD: Hook takes 2 minutes to run
sleep 120
# This will timeout and block the workflow
```

### ❌ Uncaught Exceptions

```bash
# BAD: Script crashes on unexpected input
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cat "$file_path"  # Fails if file doesn't exist
```

### ✅ Proper Error Handling

```bash
# GOOD: Handles errors gracefully
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
if [ ! -f "$file_path" ]; then
  echo '{"continue": true, "systemMessage": "File not found, skipping check"}' >&2
  exit 0
fi
```

## Scoped Hooks in Skill/Agent Frontmatter

Hooks can be defined directly in skill or agent YAML frontmatter, scoping them to activate only when that component is in use.

### Concept

Unlike `hooks.json` (global, always active when plugin enabled) or settings hooks (user-level), scoped hooks are lifecycle-bound to a specific skill or agent. They activate when the component loads and deactivate when it completes.

### Format

The `hooks` field in frontmatter uses the same event/matcher/hook structure as `hooks.json`:

```yaml
---
name: secure-writer
description: Write files with safety validation...
hooks:
  PreToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
          timeout: 10
  PostToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/post-write-check.sh"
---
```

#### Caveat: `${CLAUDE_PLUGIN_ROOT}` resolution depends on the loader

Frontmatter hooks resolve `${CLAUDE_PLUGIN_ROOT}` **only** when the host file is loaded through plugin discovery (i.e., the file Claude Code loads is the one declared by a plugin's `plugin.json`). When the same `.md` file is loaded via the `--agent` CLI flag from `.claude/agents/` or `~/.claude/agents/` -- a separate, non-plugin discovery path -- the variable is unbound at hook-exec time and Claude Code emits:

> Hook command references ${CLAUDE_PLUGIN_ROOT} but the hook is not associated with a plugin. This variable is only available in hooks defined in a plugin's hooks/hooks.json file...

This surface became newly reachable when CC 2.1.116 enabled main-thread agent frontmatter hooks via `--agent`. The behavior is observed at runtime; it is not specified in the official Claude Code documentation.

**Workaround.** For frontmatter hooks that may run under `--agent` (rather than only as plugin-discovered subagents), substitute `${CLAUDE_PROJECT_DIR}` and use a project-relative path:

```yaml
hooks:
  PreToolUse:
    - matcher: Agent
      hooks:
        - type: command
          command: "bash ${CLAUDE_PROJECT_DIR}/path/to/script.sh"
```

`${CLAUDE_PROJECT_DIR}` is bound regardless of which loader read the agent file.

**Related issues:** [#24529](https://github.com/anthropics/claude-code/issues/24529), [#27145](https://github.com/anthropics/claude-code/issues/27145), [#50357](https://github.com/anthropics/claude-code/issues/50357) (the last documents the same loader-divergence pattern for the `isolation: worktree` frontmatter field).

### Supported Events

Only a subset of hook events apply in frontmatter scope:

| Event         | Purpose in Frontmatter                                                                             |
| ------------- | -------------------------------------------------------------------------------------------------- |
| `PreToolUse`  | Validate or block tool calls during skill execution                                                |
| `PostToolUse` | Run checks after tool execution during skill use                                                   |
| `Stop`        | Verify completion criteria before skill/agent finishes (auto-converted to SubagentStop for agents) |

Session-level events (`SessionStart`, `UserPromptSubmit`, `Notification`, etc.) don't apply — they operate at a different lifecycle scope.

### Comparison with hooks.json

| Aspect         | `hooks.json`                               | Frontmatter `hooks`                                 |
| -------------- | ------------------------------------------ | --------------------------------------------------- |
| Scope          | Global (always active when plugin enabled) | Component-specific (active only during use)         |
| Events         | All 11+ hook events                        | PreToolUse, PostToolUse, Stop                       |
| Location       | `hooks/hooks.json` file                    | YAML frontmatter in SKILL.md or agent .md           |
| Merge behavior | Merges with user/project hooks             | Merges with global hooks during component lifecycle |

### Use Cases

- **Skill-specific validation:** A "database writer" skill that validates SQL before execution
- **Restricted workflows:** A "deploy" skill that checks branch and test status before allowing Bash commands
- **Quality gates:** A "code generator" skill that runs linting after every Write operation
- **Agent safety:** An autonomous agent that validates all Bash commands before execution

### Both Hook Types Work

**Command hook** (deterministic script execution):

```yaml
hooks:
  PreToolUse:
    - matcher: Bash
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/check-safety.sh"
```

**Prompt hook** (LLM evaluation):

```yaml
hooks:
  Stop:
    - hooks:
        - type: prompt
          prompt: 'Verify all generated code has tests. Return {"decision": "stop"} if satisfied or {"decision": "continue", "reason": "missing tests"} if not.'
```

## Agent Hook Type

The `agent` hook type spawns a subagent for complex, multi-step verification workflows that require tool access.

### Concept

While `command` hooks execute bash scripts and `prompt` hooks evaluate a single LLM prompt, `agent` hooks create a full subagent that can use tools (Read, Bash, Grep, etc.) to perform thorough verification. This is the most powerful but most expensive hook type.

### Configuration

```json
{
  "type": "agent",
  "prompt": "Verify that all generated code has tests and passes linting. Check each modified file.",
  "timeout": 120
}
```

### Supported Events

Agent hooks are supported on all hook events, but they're most useful on decision-control events like **Stop** and **SubagentStop**. Their multi-turn latency makes them a poor fit for hot-path events like PreToolUse.

### When to Use Agent Hooks

| Hook Type | Speed           | Capability            | Best For                                      |
| --------- | --------------- | --------------------- | --------------------------------------------- |
| `command` | Fast (~1-5s)    | Bash scripts only     | Deterministic checks, file validation         |
| `prompt`  | Medium (~5-15s) | Single LLM evaluation | Context-aware decisions, flexible logic       |
| `agent`   | Slow (~30-120s) | Multi-step with tools | Comprehensive verification, multi-file checks |

Use agent hooks when:

- Verification requires reading multiple files
- You need to run commands and analyze their output
- Single-prompt evaluation is insufficient
- Completion criteria are complex and multi-faceted

### Example: Comprehensive Completion Check

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "agent",
          "prompt": "Before approving task completion, verify: 1) All modified files have corresponding tests, 2) Tests pass (run them), 3) No linting errors exist. Report findings and return approve/block decision.",
          "timeout": 120
        }
      ]
    }
  ]
}
```

The agent will autonomously read files, run tests, check linting, and make a comprehensive decision about whether to allow the main agent to stop.

## Handler Configuration Fields

Each hook entry in a matcher group supports these fields:

```json
{
  "type": "command|http|prompt|agent|mcp_tool",
  "command": "string (command type only)",
  "args": ["arg1", "arg2"],
  "url": "string (http type only)",
  "headers": { "X-Key": "$ENV_VAR" },
  "allowedEnvVars": ["ENV_VAR"],
  "prompt": "string (prompt/agent type only)",
  "model": "string (prompt/agent, optional)",
  "if": "string (permission rule syntax, optional)",
  "timeout": 600,
  "statusMessage": "Validating...",
  "once": false,
  "async": false
}
```

- `args`: Array of command arguments for exec-form spawning (CC 2.1.139). When provided, the command is executed directly without shell interpolation, which is safer for hooks that pass user-controlled data. Example: `"args": ["--file", "$FILE_PATH"]`. The `command` field becomes the executable path when `args` is present.
- `timeout`: Max execution time in seconds. Defaults vary by type — command/http/mcp_tool 600s, prompt 30s, agent 60s. UserPromptSubmit lowers the command/http/mcp_tool default to 30s; MessageDisplay lowers it to 10s.

For the `if` field, see the [Declarative `if` Field](#declarative-if-field-cc-2185) section above. Beyond these, hook handlers support additional fields:

### once

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh",
  "once": true
}
```

When `true`, the hook runs only once per session and is then auto-removed. Useful for one-time initialization hooks in scoped contexts (skills/agents).

### statusMessage

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh",
  "statusMessage": "Validating file write..."
}
```

Display text shown in the UI while the hook is executing. Helps users understand what's happening during longer hook operations.

## Event-Specific Matchers

Some hook events support matcher values beyond tool names:

| Event         | Matcher Values                                                                 |
| ------------- | ------------------------------------------------------------------------------ |
| SessionStart  | `startup`, `resume`, `clear`, `compact`                                        |
| SessionEnd    | `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`, `other` |
| Notification  | `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`, `agent_needs_input`, `agent_completed` (CC 2.1.198) |
| PreCompact    | `manual`, `auto`                                                               |
| SubagentStart | Agent type name (e.g., `Bash`, `Explore`, `Plan`, or custom agent names)       |
| SubagentStop  | Agent type name (same as SubagentStart)                                        |
| PreToolUse    | Tool name (exact, regex, or `*` wildcard)                                      |

## Decision Control Output Schemas

Different hook events support different output formats for controlling Claude's behavior.

### PreToolUse Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "Explanation",
    "updatedInput": { "field": "modified_value" },
    "additionalContext": "Extra context for Claude"
  }
}
```

- `permissionDecision`: `allow` (proceed), `deny` (block), `ask` (prompt user), `defer` (CC 2.1.89 — fall through to the normal permission flow)
- `updatedInput`: Optionally modify tool parameters before execution
- `additionalContext`: Injected into Claude's context

### PermissionRequest Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow|deny",
      "updatedInput": {},
      "updatedPermissions": {},
      "message": "Reason for denial",
      "interrupt": false
    }
  }
}
```

- `behavior`: `allow` or `deny`
- `updatedInput`: Modified tool parameters (only with `allow`)
- `updatedPermissions`: Permission changes (only with `allow`)
- `message`: Shown to user (only with `deny`)
- `interrupt`: If true with `deny`, stops the current operation

### PostToolUse / Stop / UserPromptSubmit Decision Control

These events share a simpler top-level schema:

```json
{
  "decision": "block",
  "reason": "Explanation of why the action is blocked"
}
```

- `decision`: Set to `"block"` to prevent the action (stopping, prompt processing, etc.)
- `reason`: Required when blocking; fed back to Claude or shown to user

PostToolUse specifically supports additional fields for replacing tool output:

```json
{
  "updatedToolOutput": "Replacement output for the tool response",
  "updatedMCPToolOutput": "Replacement output for MCP tool response"
}
```

This allows hooks to replace what Claude sees as the tool response before processing. `updatedToolOutput` (CC 2.1.121) works for any tool; the older `updatedMCPToolOutput` applies to MCP tools only. See `event-schemas.md` for the authoritative per-event schemas.

### PostToolUseFailure Decision Control

PostToolUseFailure supports providing additional context to help Claude handle the failure:

```json
{
  "additionalContext": "Extra context to help Claude handle the failure"
}
```

### TeammateIdle and TaskCompleted

These events use **exit codes only** for decision control (no JSON output):

- Exit code `0`: Allow (teammate goes idle / task marked complete)
- Exit code `2`: Block — stderr is fed back to the teammate/model as feedback

### Common Output Fields (All Hooks)

These fields can be included in any hook's JSON output:

```json
{
  "continue": true,
  "stopReason": "Critical error, halting all processing",
  "suppressOutput": false,
  "systemMessage": "Warning message for the user"
}
```

- `continue`: If `false`, halts all processing (default: `true`)
- `stopReason`: Message when `continue` is `false`
- `suppressOutput`: Hide hook output from transcript (default: `false`)
- `systemMessage`: Warning/info message shown to the user

## TeammateIdle and TaskCompleted Events

These events support quality gates in agent team workflows.

### TeammateIdle

Fires when a teammate is about to go idle (stop processing). Use to keep teammates working or validate their output.

**Input schema:**

```json
{
  "session_id": "...",
  "teammate_name": "researcher",
  "team_name": "my-project"
}
```

**Example hook:**

```json
{
  "TeammateIdle": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-teammate.sh"
        }
      ]
    }
  ]
}
```

### TaskCompleted

Fires when a task is marked complete. Use to verify task quality before accepting completion.

**Input schema:**

```json
{
  "session_id": "...",
  "task_id": "123",
  "task_subject": "Implement feature X",
  "task_description": "...",
  "teammate_name": "implementer",
  "team_name": "my-project"
}
```

**Example hook:**

```json
{
  "TaskCompleted": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/verify-task.sh"
        }
      ]
    }
  ]
}
```

## Async Hooks

Command hooks can run asynchronously in the background without blocking the main flow:

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-event.sh",
  "async": true
}
```

**Key constraints:**

- Only available on `type: "command"` hooks (not prompt or agent)
- Cannot block or control behavior — the action proceeds immediately
- Response fields (`decision`, `hookSpecificOutput`) have no effect
- Useful for logging, metrics collection, and fire-and-forget notifications
- Uses the same `timeout` field (default: 600 seconds)

## Conclusion

Advanced hook patterns enable sophisticated automation while maintaining reliability and performance. Use these techniques when basic hooks are insufficient, but always prioritize simplicity and maintainability.
