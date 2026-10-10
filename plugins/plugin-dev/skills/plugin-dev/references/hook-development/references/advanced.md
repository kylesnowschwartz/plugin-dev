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
          "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/quick-check.sh\"",
          "timeout": 5
        },
        {
          "type": "prompt",
          "prompt": "Deep analysis of the bash command in this tool input: $ARGUMENTS",
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
          "command": "\"${CLAUDE_PLUGIN_ROOT}/scripts/validate-git.sh\"",
          "if": "Bash(git *)"
        }
      ]
    }
  ]
}
```

This hook fires only for Bash commands starting with `git`. The `if` field uses the same permission rule syntax as `settings.json` allow/deny rules (e.g., `Bash(npm *)`, `Edit(src/**)`, `Write(tests/**)`). Combine with `matcher` for two-level filtering: `matcher` selects the event type, `if` narrows to specific invocations.

An `if` condition names each tool by its own name, so `Write(tests/**)` matches Write calls under `tests/`. That is not true of `permissions` path rules in `settings.json`. There, `Edit(path)` covers every file-writing tool, and `Write(path)` rules are never matched (see `../../agent-development/references/permission-modes-rules.md`).

> **CC 2.1.88:** Fixed `if` field filtering to properly match compound commands (e.g., `ls && git push`) and commands with environment variable prefixes (e.g., `FOO=bar git push`). Previously, such commands could bypass `if` patterns.
>
> **CC 2.1.178:** Added tool parameter matching syntax (e.g., `Agent(model:opus)`) for granular permission control based on tool input parameters using wildcards.
>
> **CC 2.1.218 (breaking change):** Single-segment `dir/**` hook `if:` conditions now match only `<cwd>/dir`; write `**/dir/**` for any-depth matching. Previously, `dir/**` would match at any depth, which could lead to unintended matches. Update existing hooks that rely on the old behavior.

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
          "prompt": "Review the full transcript at $TRANSCRIPT_PATH. Check: 1) Were tests run after code changes? 2) Did the build succeed? 3) Were all user questions answered? 4) Is there any unfinished work? Answer ok only if everything is complete; otherwise give the reason."
        }
      ]
    }
  ]
}
```

The LLM can read the transcript file and make context-aware decisions.

**Response format:** Prompt and agent hooks share one response schema, and it is not the standard hook output:

```json
{ "ok": false, "reason": "Explanation of why the condition was not met" }
```

`ok` (boolean) is required. `reason` is optional and explains a not-ok verdict. `impossible` (boolean, meaningful only with `ok: false`) is what a Stop evaluator returns for a condition that can never be satisfied. Claude Code validates the reply against this schema and reports `Schema validation failed` for anything else, including `{"decision": ...}` shapes. Write prompts that ask for a verdict and a reason, not for a particular JSON shape.

**Wording prompts as conditions (CC 2.1.294).** Before CC 2.1.294, a prompt or agent hook written as an instruction ("Block commands that delete files") could allow what it was meant to block. Stop and SubagentStop prompts written as instructions ("Carry on if the build is broken") were also judged loosely, so Claude stopped early more often. CC 2.1.294 judges both correctly. The evaluator now frames every hook as an allow-or-block decision and treats the event JSON as data, so instructions embedded in a tool input or transcript do not steer it. The agent hook prompt also asks for a reason with every result (system prompts 2.1.294). For hooks that also run on older versions, phrase the prompt as a condition with an explicit verdict:

| Instead of | Write |
| --- | --- |
| "Block commands that delete files." | "Answer not ok if the command deletes files; otherwise answer ok." |
| "Carry on if the build is broken." | "Answer not ok, with the failing step as the reason, if the build is broken; otherwise answer ok." |

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
  command=$(echo "$input" | jq -r '.tool_response')
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
  echo '{"decision": "block", "reason": "No tests were run"}'
  exit 0
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

echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Blocked by hook policy"}}'
exit 0
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
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Invalid tool name"}}'
  exit 0
fi
```

### Path Safety

Check for path traversal and sensitive files:

```bash
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Deny path traversal
if [[ "$file_path" == *".."* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Path traversal detected"}}'
  exit 0
fi

# Deny sensitive files
if [[ "$file_path" == *".env"* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Sensitive file"}}'
  exit 0
fi
```

See `../examples/validate-write.sh` and `../examples/validate-bash.sh` for complete examples.

### Symlink Vulnerability Fix in File Tools (CC 2.1.251)

Claude Code's Read, Write, and Edit tools now enforce stricter symlink handling to prevent unauthorized file access:

**Behavior:**

- Symlinks that resolve outside the permitted sandbox paths are rejected
- Applies to both explicit symlink targets and symlinks within path components
- Tool calls with symlink-based path escapes fail with a permission error

**Implications for hooks:**

- PostToolUse hooks for file tools may see fewer successful calls that previously succeeded via symlink traversal
- PreToolUse hooks validating file paths should be aware that symlink validation happens after the hook
- Hooks cannot override the symlink security policy

**Hook pattern for detecting symlink issues:**

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Resolve symlinks and check if path escapes project
resolved=$(realpath -m "$file_path" 2>/dev/null || echo "$file_path")
if [[ ! "$resolved" =~ ^"$CLAUDE_PROJECT_DIR" ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Path resolves outside project"}}'
  exit 0
fi
```

### Grep/Glob Symlink Deny Rule Fix (CC 2.1.251)

Permission rules for Grep and Glob tools now correctly apply symlink deny rules:

- Previously, symlink deny rules could be bypassed in certain Grep/Glob operations
- Now, deny rules for symlinked paths are enforced consistently across all file tools

**Implications for plugin developers:**

- If your hooks assume certain paths are blocked via deny rules, this fix ensures those rules apply to Grep/Glob as well
- No hook changes needed; the fix is in the tool permission system itself

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
      echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Rate limit exceeded"}}'
      exit 0
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
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Potential secret detected in content"}}'
  exit 0
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

All 33 hook events are accepted in frontmatter scope — the loader registers every event it finds, with no allowlist. What limits frontmatter hooks is **lifetime**, not the event list: a frontmatter hook is registered when the component becomes active and torn down when it finishes, so an event that fires outside that window never reaches it.

In practice three events do the work:

| Event         | Purpose in Frontmatter                                                                             |
| ------------- | -------------------------------------------------------------------------------------------------- |
| `PreToolUse`  | Validate or block tool calls during skill execution                                                |
| `PostToolUse` | Run checks after tool execution during skill use                                                   |
| `Stop`        | Verify completion criteria before skill/agent finishes (auto-converted to SubagentStop for agents) |

Session-lifecycle events (`SessionStart`, `SessionEnd`, `UserPromptSubmit`, `Notification`) register without error but usually have no chance to fire, because the session event happens before the skill is dispatched or after the agent has exited. The exception is an agent run as the main session agent via `--agent`, whose lifetime *is* the session's — agent frontmatter hooks fire in that configuration as of CC 2.1.116, so session-level events can reach them there. Declare a session-level hook in `hooks/hooks.json` instead whenever it must fire for the whole session regardless of which component is running.

### Comparison with hooks.json

| Aspect         | `hooks.json`                               | Frontmatter `hooks`                                      |
| -------------- | ------------------------------------------ | -------------------------------------------------------- |
| Scope          | Global (always active when plugin enabled) | Component-specific (active only during use)              |
| Events         | All 33 hook events                         | All 33; only ones firing during the component's lifetime |
| Location       | `hooks/hooks.json` file                    | YAML frontmatter in SKILL.md or agent .md                |
| Merge behavior | Merges with user/project hooks             | Merges with global hooks during component lifecycle      |

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
          prompt: 'Verify all generated code has tests. Answer ok if it does; if not, answer not ok with the missing tests as the reason.'
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

Agent hooks — like prompt hooks — need a live conversation to run in, and 20 of the 33 events are dispatched without one, leaving 13 that accept them. Registering an agent or prompt hook on one of those events fails at dispatch with either

- `agent-type hooks are not supported for <event> events (no conversation context is available). Use a command-type hook instead.`, or
- `Agent stop hooks are not yet supported outside REPL`

depending on which dispatcher the event uses. Which events those are, and what they accept instead, is in `../overview.md` (Hook Types and the Hook Events Reference table), which is authoritative.

PermissionRequest is the one conversation event that refuses agent hooks (CC 2.1.280). An agent hook answers ok or not ok, and a permission request needs an allow or deny decision, so the hook fails with `agent-type hooks are not supported for PermissionRequest events ... Use a command- or http-type hook instead.`

Among the events that do accept them, agent hooks are most useful on decision-control events like **Stop** and **SubagentStop**. Their multi-turn latency makes them a poor fit for hot-path events like PreToolUse. Before CC 2.1.295, agent hook evaluations also took much longer when the session ran at `xhigh` or `max` effort.

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
          "prompt": "Before approving task completion, verify: 1) All modified files have corresponding tests, 2) Tests pass (run them), 3) No linting errors exist. Answer ok if all three hold; otherwise answer not ok with the findings as the reason.",
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
  "async": false,
  "asyncRewake": false,
  "onFailure": "continue"
}
```

- `args`: Array of command arguments for exec-form spawning (CC 2.1.139). When provided, the command is executed directly without shell interpolation, which is safer for hooks that pass user-controlled data. Example: `"args": ["--file", "$FILE_PATH"]`. The `command` field becomes the executable path when `args` is present.
- `timeout`: Max execution time in seconds. Defaults vary by type — command/http/mcp_tool 600s, prompt 30s, agent 60s. UserPromptSubmit lowers the command/http/mcp_tool default to 30s; MessageDisplay lowers it to 10s.

For the `if` field, see the [Declarative `if` Field](#declarative-if-field-cc-2185) section above. Beyond these, hook handlers support additional fields:

### once

```json
{
  "type": "command",
  "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/init.sh\"",
  "once": true
}
```

When `true`, the hook runs only once per session and is then auto-removed. Useful for one-time initialization hooks in scoped contexts (skills/agents).

### statusMessage

```json
{
  "type": "command",
  "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh\"",
  "statusMessage": "Validating file write..."
}
```

Display text shown in the UI while the hook is executing. Helps users understand what's happening during longer hook operations.

### onFailure

```json
{
  "type": "command",
  "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/guard-bash.sh\"",
  "onFailure": "block"
}
```

Decides what a failure of the hook does (CC 2.1.295, command and HTTP hooks). A failure is a hook that could not start (a missing script or plugin directory), timed out, exited with a code other than 0 or 2, or printed JSON that is invalid or fails validation. The CC 2.1.296 binary reports an HTTP hook's non-2xx response as the same kind of non-blocking error, so `"block"` turns it into a block too.

- `"continue"` (default): the failure is reported and the action goes ahead. This is how hooks behaved before CC 2.1.295, so a guard hook fails open.
- `"block"`: the failure counts as exit code 2, so the action the event guards is blocked: a tool call, a permission request, or a prompt.
- Ignored for async hooks and on Stop, SubagentStop, TaskCompleted, and TeammateIdle.

Use `"block"` on security guards, such as a PreToolUse hook that vets Bash commands, where a broken or slow script should stop the call rather than wave it through. Keep the default for logging, formatting, and notification hooks, where a failure should not stop work. Older Claude Code versions do not have this field, so a guard that must fail closed there has to catch its own errors and exit 2.

## Event-Specific Matchers

Matchers filter which registered hooks run for an occurrence of an event. Each event names one input field to match against; **which field, and which values it accepts, is documented on that event's Matchers line in `event-schemas.md`**, which covers all 33 events. This section covers only the syntax that applies once you know what an event matches on.

- **Tool-name matching is a case-sensitive regular expression, not a glob.** `"Write"` matches exactly; `"mcp__.*__delete.*"` needs the `.*`, because `"mcp__*__delete*"` is not a pattern this accepts.
- **Alternate with a pipe, never a comma.** `"Bash|PowerShell"` matches either. `"Bash,PowerShell"` silently never fires (CC 2.1.191).
- **Hyphenated matchers require an exact match (CC 2.1.195).** A matcher containing a hyphen no longer substring-matches, so `"mcp__brave-search"` matches only that exact value — write `"mcp__brave-search__.*"` for partial matches. This affects custom agent names, MCP server names, and any hyphenated identifier.
- **`*` matches everything,** and so does omitting `matcher` altogether.
- **Some events ignore `matcher` entirely.** Their Matchers line reads "Not supported"; an entry's matcher is silently discarded rather than rejected.

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

- `permissionDecision`: `allow` (proceed), `deny` (block), `ask` (prompt user), `defer` (CC 2.1.89 — suspend the tool call rather than running it)
- Managed-settings PreToolUse hooks that deny a call with `"continue": false`, and managed `prompt` hooks that block one, end the turn since CC 2.1.296. Before that the call was refused but the turn went on
- `defer` is **not** a pass-through. The call does not run; it is recorded as deferred and the session can be resumed later with `-p --resume`. Deferral is unsupported for calls served to a cloud session, which fail with "deferred this call … so nothing ran". See [event-schemas.md](event-schemas.md) for the headless deferral flow
- `ask` depends on the session being interactive: an interactive session shows `Hook PreToolUse:<Tool> requires confirmation ... [plugin:<name>]`, while headless runs (`claude -p`) have no one to prompt and treat the same `ask` as a block, surfacing the reason to the model.
- `allow` does not skip every prompt. Since CC 2.1.292 (a security fix), a PreToolUse `allow`, like auto mode, no longer bypasses the permission prompt for file reads from network (UNC) paths
- `updatedInput`: Optionally modify tool parameters before execution. The rewritten input is checked against permission rules and safety checks; CC 2.1.290 fixed cases where some were not applied after a rewrite, so a rewrite cannot carry a call past a deny rule
- `additionalContext`: Injected into Claude's context. `<system-reminder>` tags in it, as in any hook output, are escaped before they reach Claude (CC 2.1.292)
- A failure to match the hook against a call, or tool input that cannot be serialized to JSON, blocks the call (CC 2.1.288). Before CC 2.1.288 the hook was skipped and the call ran. PermissionRequest behaves the same way

**`updatedInput` under auto mode (CC 2.1.287).** Auto mode is the default starting mode, when no permission mode is configured, since CC 2.1.284 for interactive terminal and VS Code sessions, and since CC 2.1.285 for `claude -p` and Python Agent SDK sessions on third-party providers or with telemetry off. Its classifier reviews the tool input the model wrote. When a PreToolUse hook (or a mod's `tool.call` hook) changes that input, the review covers different input from what would run, so the classifier gives no verdict. Claude retries the call once. If it is denied again, Claude stops trying and tells the user that a hook rewrites the call, that auto mode could not evaluate the rewritten call, and that they can turn the hook off or leave auto mode. In practice, an `updatedInput` hook can block its own tool in a default session. Prefer `deny` with a `permissionDecisionReason` that tells Claude how to fix the call, and keep `updatedInput` for sessions that run in another permission mode or for cases where blocking is acceptable.

### PermissionRequest Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow|deny",
      "updatedInput": {},
      "updatedPermissions": [
        {
          "type": "addRules|replaceRules",
          "rules": [],
          "destination": "session|localSettings|projectSettings|userSettings"
        }
      ],
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

This allows hooks to replace what Claude sees as the tool response before processing. `updatedToolOutput` (CC 2.1.121) works for any tool; the older `updatedMCPToolOutput` applies to MCP tools only. Before CC 2.1.296, PostToolUse hooks in managed settings did not apply `updatedMCPToolOutput` in some sessions. See `event-schemas.md` for the authoritative per-event schemas.

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
          "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/check-teammate.sh\""
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
          "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/verify-task.sh\""
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
  "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/log-event.sh\"",
  "async": true
}
```

**Key constraints:**

- Only available on `type: "command"` hooks (not prompt or agent)
- Cannot block or control behavior — the action proceeds immediately
- Response fields (`decision`, `hookSpecificOutput`) have no effect
- Useful for logging, metrics collection, and fire-and-forget notifications
- Uses the same `timeout` field (default: 600 seconds)
- `onFailure` is ignored, so an async hook cannot fail closed

**Async output fixes (CC 2.1.295):** an async hook's JSON output printed over several lines used to be ignored, and an async SessionStart hook's unchanged context was added to the conversation again on every resume. Both are fixed. On older versions, print an async hook's JSON on one line (`jq -c`).

### asyncRewake

```json
{
  "type": "command",
  "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/background-check.sh\"",
  "asyncRewake": true
}
```

`asyncRewake: true` runs the hook in the background like `async`, which it implies, but wakes Claude when the hook exits with code 2 (a blocking error). The hook's output is passed to Claude as "found issues" feedback. Use it for slow checks whose failures Claude should act on without holding up the turn. Since CC 2.1.287, a hook whose script file is missing is reported once as broken instead of waking Claude over and over with "found issues" notifications.

### Synchronous Hooks and Background Processes (CC 2.1.285)

A synchronous hook that starts a background process (for example `some-daemon &`) used to hang Claude Code for as long as that process kept the hook's output open. Since CC 2.1.285 the hook finishes shortly after its own process exits. On older versions, redirect the background process's output (`some-daemon >/dev/null 2>&1 &`) so the hook does not wait on it.

## Conclusion

Advanced hook patterns enable sophisticated automation while maintaining reliability and performance. Use these techniques when basic hooks are insufficient, but always prioritize simplicity and maintainability.
