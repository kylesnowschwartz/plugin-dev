---
name: hook-development
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse/PostToolUse/Stop hook", "validate tool use", "implement prompt-based hooks", "use ${CLAUDE_PLUGIN_ROOT}", "set up event-driven automation", "block dangerous commands", "scoped hooks", "frontmatter hooks", "hook in skill", "hook in agent", "agent hook type", "async hooks", "once handler", "statusMessage", "hook decision control", or mentions hook events (PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure, Stop, StopFailure, SubagentStop, SubagentStart, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, PostCompact, Notification, ConfigChange, TeammateIdle, TaskCompleted, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, InstructionsLoaded, Elicitation, ElicitationResult). Provides comprehensive guidance for creating and implementing Claude Code plugin hooks with focus on advanced prompt-based hooks API.
---

# Hook Development for Claude Code Plugins

## Overview

Hooks are event-driven automation that execute in response to Claude Code events. Use hooks to validate operations, enforce policies, add context, and integrate external tools into workflows.

Claude Code has **24 hook events** across these categories:

- **Session Lifecycle** -- SessionStart, InstructionsLoaded, SessionEnd
- **User Input** -- UserPromptSubmit
- **Tool Lifecycle** -- PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure
- **Turn Control** -- Stop, StopFailure
- **Subagents** -- SubagentStart, SubagentStop
- **Teams** -- TeammateIdle, TaskCompleted
- **Context Management** -- PreCompact, PostCompact
- **Configuration** -- ConfigChange
- **Environment** -- CwdChanged, FileChanged
- **Worktrees** -- WorktreeCreate, WorktreeRemove
- **MCP Elicitation** -- Elicitation, ElicitationResult
- **Notifications** -- Notification

For complete input/output JSON schemas for every event, see **`references/event-schemas.md`**.

## Hook Types

Four hook types are available. Not all events support all types.

### Prompt-Based Hooks (Recommended)

LLM-driven decision making for context-aware validation:

```json
{
  "type": "prompt",
  "prompt": "Evaluate if this tool use is appropriate: $TOOL_INPUT",
  "model": "haiku",
  "timeout": 30
}
```

**Benefits:** Context-aware decisions, flexible evaluation, better edge case handling, easier to maintain.

### Agent Hooks

Like prompt hooks but with tool access for multi-step validation:

```json
{
  "type": "agent",
  "prompt": "Review the code change and run tests to verify correctness.",
  "model": "sonnet",
  "timeout": 60
}
```

**Benefits:** Can read files, run commands, and reason across multiple steps. Higher cost and latency than prompt hooks.

### Command Hooks

Execute bash commands for deterministic checks:

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh",
  "timeout": 60
}
```

**Use for:** Fast deterministic validations, file system operations, external tool integrations.

### HTTP Hooks

Send event data to an HTTP endpoint:

```json
{
  "type": "http",
  "url": "https://hooks.example.com/claude",
  "headers": { "Authorization": "Bearer $API_TOKEN" },
  "allowedEnvVars": ["API_TOKEN"],
  "timeout": 30
}
```

**Use for:** External service integration, centralized logging, webhook-driven workflows.

**Prompt hooks** work on most events (see [Hook Type Support by Event](#hook-type-support-by-event) for the full matrix). SessionStart and WorktreeRemove are restricted to command hooks only. WorktreeCreate supports command and HTTP hooks.

**Response format:** Prompt hooks return the standard hook output JSON (`decision`, `reason`, `systemMessage`). For events with event-specific behavior (PreToolUse, PermissionRequest, Elicitation), include `hookSpecificOutput` with event-appropriate fields — see each event's documentation below and `references/event-schemas.md`.

## Hook Configuration Formats

### Plugin hooks.json Format

**For plugin hooks** in `hooks/hooks.json`, use wrapper format:

```json
{
  "description": "Brief explanation of hooks (optional)",
  "hooks": {
    "PreToolUse": [...],
    "Stop": [...],
    "SessionStart": [...]
  }
}
```

- `description` field is optional
- `hooks` field is required wrapper containing actual hook events
- This is the **plugin-specific format**

### Settings Format (Direct)

**For user settings** in `.claude/settings.json`, use direct format:

```json
{
  "PreToolUse": [...],
  "Stop": [...],
  "SessionStart": [...]
}
```

- No wrapper -- events directly at top level inside the `"hooks"` key of settings
- Plugin hooks merge with user hooks and run in parallel

### Hook Entry Schema

Each hook entry in a matcher group supports these fields:

```json
{
  "type": "command|http|prompt|agent",
  "command": "string (command type only)",
  "url": "string (http type only)",
  "headers": { "X-Key": "$ENV_VAR" },
  "allowedEnvVars": ["ENV_VAR"],
  "prompt": "string (prompt/agent type only)",
  "model": "string (prompt/agent, optional)",
  "timeout": 600,
  "statusMessage": "Validating...",
  "once": false,
  "async": false
}
```

- `timeout`: Max execution time in seconds. Defaults vary by type (command: 60s, prompt: 30s, http: 30s, agent: 60s)
- `statusMessage`: Shown in the UI while the hook runs
- `once`: Run only once per session (not per event occurrence)
- `async`: Fire-and-forget, cannot block (command hooks only)

**Important:** The examples below show the hook event structure that goes inside either format. For plugin hooks.json, wrap these in `{"hooks": {...}}`.

### Plugin Hook Configuration

Define hooks in `hooks/hooks.json` using the plugin wrapper format:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate-bash.sh"
          }
        ]
      }
    ]
  }
}
```

Plugin hooks merge with user hooks and run in parallel.

### Scoped Hooks in Skill/Agent Frontmatter

Hooks can be defined directly in YAML frontmatter of skills and agents:

```yaml
hooks:
  PreToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
```

**Supported events in frontmatter:** `PreToolUse`, `PostToolUse`, `Stop`

These hooks are lifecycle-bound -- they activate when the skill/agent loads and deactivate when it finishes. Use for skill-specific validation that shouldn't apply globally.

See `references/advanced.md` for details.

## Hook Events

### Session Lifecycle

#### SessionStart

Execute when a Claude Code session begins. Use to load context and set environment.

**Matchers:** `startup`, `resume`, `clear`, `compact`
**Hook types:** Command only
**Decision control:** Can halt with `continue: false`

```json
{
  "SessionStart": [
    {
      "matcher": "startup",
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

**Special capability:** Persist environment variables using `$CLAUDE_ENV_FILE`:

```bash
echo "export PROJECT_TYPE=nodejs" >> "$CLAUDE_ENV_FILE"
```

See `examples/load-context.sh` for a complete example.

#### InstructionsLoaded

Execute when CLAUDE.md or `.claude/rules/*.md` files are loaded into context.

**Matchers:** `session_start`, `nested_traversal`, `path_glob_match`, `include`, `compact`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (observability only, runs async)

**Input includes:** `file_path`, `memory_type` (User|Project|Local|Managed), `load_reason`

Use to track which instruction files are loaded, enforce policies on instruction content, or log instruction loading patterns.

#### SessionEnd

Execute when a session terminates. Use for cleanup, logging, and state preservation.

**Matchers:** `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`, `resume`, `other`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (observability only)

**Gotcha:** Default timeout is only **1.5 seconds**. Override with `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` environment variable for longer-running cleanup.

### User Input

#### UserPromptSubmit

Execute when a user submits a prompt, before Claude processes it.

**Matchers:** Not supported (silently ignored)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can block with `decision: "block"` and `reason`

```json
{
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Check if prompt requires security guidance. If discussing auth, permissions, or API security, return relevant warnings via additionalContext."
        }
      ]
    }
  ]
}
```

### Tool Lifecycle

#### PreToolUse

Execute before any tool runs. Use to approve, deny, or modify tool calls.

**Matchers:** Tool names -- `Bash`, `Edit`, `Write`, `Read`, `Glob`, `Grep`, `Agent`, `WebFetch`, `WebSearch`, MCP tools as `mcp__<server>__<tool>`. Regex supported.
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Full -- approve, deny, or modify tool input

```json
{
  "PreToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Validate file write safety. Check: system paths, credentials, path traversal, sensitive content."
        }
      ]
    }
  ]
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Explanation",
    "updatedInput": { "file_path": "/modified/path" },
    "additionalContext": "Extra context for Claude"
  }
}
```

> **Deprecated:** The old top-level `decision: "approve|block"` fields still work but are superseded by `hookSpecificOutput.permissionDecision`. Use `permissionDecision` for new hooks.

#### PermissionRequest

Execute when a permission dialog is about to display. Use to automatically allow or deny permissions without user interaction.

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Allow or deny the permission

```json
{
  "PermissionRequest": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-permission.sh"
        }
      ]
    }
  ]
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow|deny",
      "updatedInput": { "command": "modified command" },
      "updatedPermissions": [],
      "message": "Reason for denial",
      "interrupt": false
    }
  }
}
```

- `behavior`: "allow" to approve, "deny" to reject
- `updatedInput`: Modified tool parameters (only with "allow")
- `updatedPermissions`: Apply permission rules so user isn't prompted again (only with "allow")
- `message`: Explanation shown to user (only with "deny")
- `interrupt`: If true with "deny", stops the current operation entirely

**Difference from PreToolUse:** PreToolUse runs before every tool execution regardless of permission status. PermissionRequest runs only when a permission dialog would be shown to the user.

**Known issues:** `additionalContext` is parsed but silently dropped (works in PreToolUse but not here). Race condition where dialog may briefly show despite returning "allow" ([#12176](https://github.com/anthropics/claude-code/issues/12176)).

#### PostToolUse

Execute after a tool completes successfully. Use to react to results, provide feedback, or log.

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can block further processing with `decision: "block"` and `reason`

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Analyze edit result for potential issues: syntax errors, security vulnerabilities, breaking changes. Provide feedback."
        }
      ]
    }
  ]
}
```

**MCP-specific output:** For MCP tools, `hookSpecificOutput.updatedMCPToolOutput` lets you modify the tool's response before Claude sees it.

#### PostToolUseFailure

Execute when a tool fails. Use to handle errors, provide fallback actions, or add diagnostic context.

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Context injection via `additionalContext`

**Input includes:** `error` (string), `is_interrupt` (boolean, optional)

### Turn Control

#### Stop

Execute when the main agent finishes responding. Use to validate completeness before the turn ends.

**Matchers:** Not supported
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can block the stop, forcing Claude to continue

```json
{
  "Stop": [
    {
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Verify task completion: tests run, build succeeded, questions answered. Return 'block' with reason to continue working, or allow the stop."
        }
      ]
    }
  ]
}
```

**Output:**

```json
{
  "decision": "block",
  "reason": "Tests were not run after code changes. Please run the test suite."
}
```

When `decision` is `"block"`, `reason` is required and Claude receives it as feedback to continue working.

**Input includes:** `stop_hook_active` (boolean), `last_assistant_message` (string)

#### StopFailure

Execute when a turn ends due to an API error (not a normal stop). Use for alerting and diagnostics.

**Matchers:** `rate_limit`, `authentication_failed`, `billing_error`, `invalid_request`, `server_error`, `max_output_tokens`, `unknown`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (output and exit code are ignored)

**Input includes:** `error`, `error_details` (optional), `last_assistant_message`

Use to send alerts when rate limits hit, auth fails, or billing errors occur.

### Subagents

#### SubagentStart

Execute when a subagent is spawned via the Agent tool. Use to initialize state or inject context.

**Matchers:** Agent type names (`Bash`, `Explore`, `Plan`, custom agent names)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Context injection via `additionalContext`

```json
{
  "SubagentStart": [
    {
      "matcher": "code-reviewer",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/subagent-init.sh"
        }
      ]
    }
  ]
}
```

**Input includes:** `agent_id`, `agent_type`

#### SubagentStop

Execute when a subagent finishes responding. Use to validate subagent output before returning to the parent.

**Matchers:** Agent type names (same as SubagentStart)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can block the stop (same as Stop)

**Input includes:** `agent_id`, `agent_type`, `agent_transcript_path`, `last_assistant_message`, `stop_hook_active`

**Gotcha:** Stop hooks defined in a subagent's context automatically convert to SubagentStop events.

### Teams

#### TeammateIdle

Execute when an agent team teammate is about to go idle. Use as a quality gate before allowing idle.

**Matchers:** Not supported
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Exit code 2 sends stderr as feedback (teammate keeps working). JSON `{"continue": false, "stopReason": "..."}` stops the teammate entirely.

**Input includes:** `teammate_name`, `team_name`

```json
{
  "TeammateIdle": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-teammate-done.sh"
        }
      ]
    }
  ]
}
```

#### TaskCompleted

Execute when a task is marked as completed. Use to validate task output or enforce quality standards.

**Matchers:** Not supported
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Exit code 2 rejects completion (stderr fed back as feedback, agent continues). JSON `{"continue": false, "stopReason": "..."}` stops the teammate.

**Input includes:** `task_id`, `task_subject`, `task_description` (optional), `teammate_name` (optional), `team_name` (optional)

```json
{
  "TaskCompleted": [
    {
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Review the completed task. Verify the deliverable matches the task description. If incomplete, return exit code 2 with feedback."
        }
      ]
    }
  ]
}
```

### Context Management

#### PreCompact

Execute before context compaction. Use to inject critical information that should survive compaction.

**Matchers:** `manual`, `auto`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (observability only)

**Input includes:** `trigger` ("manual"|"auto"), `custom_instructions`

#### PostCompact

Execute after context compaction completes. Use to verify preserved state or log compaction results.

**Matchers:** `manual`, `auto`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (observability only)

**Input includes:** `trigger` ("manual"|"auto"), `compact_summary`

### Configuration

#### ConfigChange

Execute when a configuration file changes during a session. Use for security monitoring or config validation.

**Matchers:** `user_settings`, `project_settings`, `local_settings`, `policy_settings`, `skills`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can block with `decision: "block"` and `reason`

```json
{
  "ConfigChange": [
    {
      "matcher": "project_settings|local_settings",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate-config.sh"
        }
      ]
    }
  ]
}
```

**Input includes:** `source`, `file_path` (optional)

**Gotcha:** `policy_settings` changes cannot be blocked. The block decision is silently ignored.

### Environment

#### CwdChanged

Execute when the working directory changes during a session (e.g., when Claude runs `cd`).

**Matchers:** Not supported (fires on every directory change)
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (cannot block directory changes)

**Input includes:** `old_cwd`, `new_cwd`

```json
{
  "CwdChanged": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/env-setup.sh"
        }
      ]
    }
  ]
}
```

**Special capabilities:**

- Supports `$CLAUDE_ENV_FILE` — write `export VAR=value` to persist env vars into subsequent Bash commands
- Can return `watchPaths` array to dynamically update file monitoring

**Use case:** Reactive environment management with tools like direnv — reload env vars, activate project-specific toolchains, or run setup scripts on directory change.

#### FileChanged

Execute when a watched file changes on disk.

**Matchers:** Pipe-separated basenames (filenames without directory paths), e.g. `".envrc|.env"`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (cannot block file changes)

**Input includes:** `file_path` (absolute), `event` (`"change"`, `"add"`, or `"unlink"`)

```json
{
  "FileChanged": [
    {
      "matcher": ".envrc|.env",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/reload-env.sh"
        }
      ]
    }
  ]
}
```

**Special capabilities:**

- Supports `$CLAUDE_ENV_FILE` for persisting environment variable changes
- Can return `watchPaths` array to dynamically update monitored paths

**Use case:** Reloading environment variables when config files change, triggering rebuilds on config modifications.

### Worktrees

#### WorktreeCreate

Execute when a git worktree is created (via `--worktree` flag or subagent `isolation: "worktree"`).

**Matchers:** Not supported
**Hook types:** Command, HTTP
**Decision control:** Hook must return the **absolute path** to the created worktree directory. Command hooks print the path on stdout. HTTP hooks return it via `hookSpecificOutput.worktreePath`.

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
  ]
}
```

**Input includes:** `name` (worktree identifier)

**HTTP hook response format:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "WorktreeCreate",
    "worktreePath": "/absolute/path/to/worktree"
  }
}
```

For command hooks, stdout is the return value (a path), not JSON.

#### WorktreeRemove

Execute when a worktree is being removed (session exit or subagent finish).

**Matchers:** Not supported
**Hook types:** Command only
**Decision control:** None (cleanup only)

**Input includes:** `worktree_path`

### MCP Elicitation

#### Elicitation

Execute when an MCP server requests user input mid-task. Use to auto-respond or filter elicitation requests.

**Matchers:** MCP server name
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can accept, decline, or cancel the elicitation

```json
{
  "Elicitation": [
    {
      "matcher": "my-mcp-server",
      "hooks": [
        {
          "type": "command",
          "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/handle-elicitation.sh"
        }
      ]
    }
  ]
}
```

**Input includes:** `mcp_server_name`, `message`, `mode` ("form"|"url", optional), `url` (optional), `elicitation_id` (optional), `requested_schema` (optional)

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Elicitation",
    "action": "accept|decline|cancel",
    "content": { "field": "value" }
  }
}
```

- `accept`: Provide response via `content` (matching `requested_schema`)
- `decline`: Reject the elicitation request
- `cancel`: Cancel the entire MCP operation

#### ElicitationResult

Execute after a user responds to an MCP elicitation, before the response is sent back to the server. Use to modify, validate, or log user responses.

**Matchers:** MCP server name
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** Can override user response with `action` and `content`

**Input includes:** `mcp_server_name`, `elicitation_id`, `user_response`

### Notifications

#### Notification

Execute when Claude Code sends notifications. Use for logging, external alerting, or custom notification routing.

**Matchers:** `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`
**Hook types:** Command, HTTP, Prompt, Agent
**Decision control:** None (observability only)

**Input includes:** `message`, `title` (optional), `notification_type`

## Hook Output Format

### Standard Output (All Hooks)

```json
{
  "continue": true,
  "stopReason": "Why processing should halt",
  "suppressOutput": false,
  "decision": "block",
  "reason": "Feedback for Claude when blocking",
  "systemMessage": "Warning shown to user",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "Extra context injected for Claude"
  }
}
```

All fields are optional. Behavior by field:

- `continue`: If false, halt processing (default true)
- `stopReason`: Displayed when `continue` is false
- `suppressOutput`: Hide hook output from transcript (default false)
- `decision`: Set to `"block"` to block the operation
- `reason`: Required when `decision` is `"block"` -- fed back to Claude
- `systemMessage`: Warning displayed to the user
- `hookSpecificOutput`: Event-specific fields (see `references/event-schemas.md`)

### Exit Codes

| Code  | Behavior                                         |
| ----- | ------------------------------------------------ |
| 0     | Success. JSON on stdout parsed if present        |
| 2     | Blocking error. stderr fed to Claude/user        |
| Other | Non-blocking. Shown in verbose/debug mode only   |

**Gotcha:** If your shell profile (`.bashrc`/`.zshrc`) prints text, it contaminates stdout and breaks JSON parsing. Redirect profile output to stderr.

### Async Hooks

Command hooks can run fire-and-forget with `"async": true`. Async hooks:

- Cannot block (exit code 2 is ignored)
- Cannot return decisions
- Run without blocking Claude's workflow
- Useful for logging, metrics, external notifications

## Hook Input Format

All hooks receive JSON via stdin with these common fields:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/working/dir",
  "hook_event_name": "PreToolUse",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions"
}
```

When inside a subagent, `agent_id` and `agent_type` are also present.

**Event-specific fields vary.** See `references/event-schemas.md` for complete input schemas per event.

**Access in prompt hooks:** Use `$TOOL_INPUT`, `$TOOL_NAME`, `$USER_PROMPT`, etc. in prompt strings.

## Environment Variables

Available in all command hooks:

- `$CLAUDE_PROJECT_DIR` -- Project root path
- `$CLAUDE_PLUGIN_ROOT` -- Plugin directory (use for portable paths)
- `$CLAUDE_ENV_FILE` -- SessionStart only: write `export VAR=value` lines here to persist env vars
- `$CLAUDE_CODE_REMOTE` -- Set if running in remote context

**Always use `${CLAUDE_PLUGIN_ROOT}` in hook commands for portability:**

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
}
```

## Matchers

### How Matchers Work

Matchers filter which hooks run for a given event. Each event defines what values its matchers accept (tool names, source types, server names, etc.). A hook entry without a `matcher` field matches all occurrences of that event.

### Tool Name Matching (PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure)

**Exact match:**

```json
"matcher": "Write"
```

**Multiple tools (regex OR):**

```json
"matcher": "Read|Write|Edit"
```

**Regex patterns:**

```json
"matcher": "mcp__.*__delete.*"
```

**Common patterns:**

```json
"matcher": "mcp__.*"              // All MCP tools
"matcher": "mcp__plugin_asana_.*" // Specific plugin's MCP tools
"matcher": "Read|Write|Edit"      // All file operations
"matcher": "Bash"                 // Bash commands only
```

**Note:** Matchers are case-sensitive. Regex is full regex, not glob.

### Source Matching (SessionStart, SessionEnd, PreCompact, PostCompact, ConfigChange, StopFailure)

These events match on a `source` or category value, not tool names. See each event's documentation for valid matcher values.

### Agent Type Matching (SubagentStart, SubagentStop)

Match on agent type names: built-in types (`Bash`, `Explore`, `Plan`) or custom agent names from plugins.

### MCP Server Matching (Elicitation, ElicitationResult)

Match on MCP server name.

### Events Without Matcher Support

These events ignore the `matcher` field: UserPromptSubmit, Stop, TeammateIdle, TaskCompleted, CwdChanged, WorktreeCreate, WorktreeRemove.

## Hook Type Support by Event

Not all events support all four hook types:

| Event              | Command | HTTP | Prompt | Agent |
| ------------------ | ------- | ---- | ------ | ----- |
| SessionStart       | Yes     | --   | --     | --    |
| InstructionsLoaded | Yes     | Yes  | Yes    | Yes   |
| SessionEnd         | Yes     | Yes  | Yes    | Yes   |
| UserPromptSubmit   | Yes     | Yes  | Yes    | Yes   |
| PreToolUse         | Yes     | Yes  | Yes    | Yes   |
| PermissionRequest  | Yes     | Yes  | Yes    | Yes   |
| PostToolUse        | Yes     | Yes  | Yes    | Yes   |
| PostToolUseFailure | Yes     | Yes  | Yes    | Yes   |
| Stop               | Yes     | Yes  | Yes    | Yes   |
| StopFailure        | Yes     | Yes  | Yes    | Yes   |
| SubagentStart      | Yes     | Yes  | Yes    | Yes   |
| SubagentStop       | Yes     | Yes  | Yes    | Yes   |
| TeammateIdle       | Yes     | Yes  | Yes    | Yes   |
| TaskCompleted      | Yes     | Yes  | Yes    | Yes   |
| PreCompact         | Yes     | Yes  | Yes    | Yes   |
| PostCompact        | Yes     | Yes  | Yes    | Yes   |
| ConfigChange       | Yes     | Yes  | Yes    | Yes   |
| CwdChanged         | Yes     | Yes  | Yes    | Yes   |
| FileChanged        | Yes     | Yes  | Yes    | Yes   |
| WorktreeCreate     | Yes     | Yes  | --     | --    |
| WorktreeRemove     | Yes     | --   | --     | --    |
| Elicitation        | Yes     | Yes  | Yes    | Yes   |
| ElicitationResult  | Yes     | Yes  | Yes    | Yes   |
| Notification       | Yes     | Yes  | Yes    | Yes   |

## Hook Configuration Locations

| Location                        | Scope          | Shareable             |
| ------------------------------- | -------------- | --------------------- |
| `~/.claude/settings.json`       | All projects   | No                    |
| `.claude/settings.json`         | Single project | Yes (commit to repo)  |
| `.claude/settings.local.json`   | Single project | No                    |
| Managed policy settings         | Organization   | Yes (admin-managed)   |
| Plugin `hooks/hooks.json`       | Plugin-scoped  | Yes (with plugin)     |

Plugin hooks merge with user hooks. All matching hooks run in parallel. Duplicate hooks are deduplicated (command hooks by command string, HTTP hooks by URL).

**`disableAllHooks` in settings cannot disable managed policy hooks.**

## Security Best Practices

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

### Set Appropriate Timeouts

```json
{
  "type": "command",
  "command": "bash script.sh",
  "timeout": 10
}
```

**Defaults:** Command (60s), Prompt (30s), HTTP (30s), Agent (60s)

## Performance Considerations

### Parallel Execution

All matching hooks run **in parallel**:

```json
{
  "PreToolUse": [
    {
      "matcher": "Write",
      "hooks": [
        { "type": "command", "command": "check1.sh" },
        { "type": "command", "command": "check2.sh" },
        { "type": "prompt", "prompt": "Validate..." }
      ]
    }
  ]
}
```

**Design implications:**

- Hooks don't see each other's output
- Non-deterministic ordering
- Design for independence

### Optimization

1. Use command hooks for quick deterministic checks
2. Use prompt hooks for complex reasoning
3. Cache validation results in temp files
4. Minimize I/O in hot paths
5. Use `async: true` for logging hooks that don't need to block
6. Use `once: true` for one-time setup hooks

## Hook Lifecycle and Limitations

### Hooks Load at Session Start

**Important:** Hooks are loaded when Claude Code session starts. Changes to hook configuration require restarting Claude Code.

**Cannot hot-swap hooks:**

- Editing `hooks/hooks.json` won't affect the current session
- Adding new hook scripts won't be recognized
- Must restart Claude Code: exit and run `claude` again

**To test hook changes:**

1. Edit hook configuration or scripts
2. Exit Claude Code session
3. Restart: `claude`
4. New hook configuration loads
5. Test hooks with `claude --debug`

### Hook Validation at Startup

Hooks are validated when Claude Code starts:

- Invalid JSON in hooks.json causes loading failure
- Missing scripts cause warnings
- Syntax errors reported in debug mode

Use `/hooks` command to review loaded hooks in the current session.

## Debugging Hooks

### Enable Debug Mode

```bash
claude --debug
```

Look for hook registration, execution logs, input/output JSON, and timing information.

### Test Hook Scripts

Test command hooks directly:

```bash
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test"}}' | \
  bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh

echo "Exit code: $?"
```

### Validate JSON Output

Ensure hooks output valid JSON:

```bash
output=$(./your-hook.sh < test-input.json)
echo "$output" | jq .
```

## Quick Reference

### All 24 Hook Events

| Event              | Category      | Matchers                    | Decision Control              |
| ------------------ | ------------- | --------------------------- | ----------------------------- |
| SessionStart       | Lifecycle     | startup, resume, clear, compact | continue, env vars         |
| InstructionsLoaded | Lifecycle     | session_start, nested_traversal, path_glob_match, include, compact | None (observability) |
| SessionEnd         | Lifecycle     | clear, logout, prompt_input_exit, bypass_permissions_disabled, resume, other | None (observability) |
| UserPromptSubmit   | Input         | None                        | Block prompt                  |
| PreToolUse         | Tool          | Tool names (regex)          | Allow/deny/ask, modify input  |
| PermissionRequest  | Tool          | Tool names (regex)          | Allow/deny, modify input      |
| PostToolUse        | Tool          | Tool names (regex)          | Block, modify MCP output      |
| PostToolUseFailure | Tool          | Tool names (regex)          | Context injection             |
| Stop               | Turn          | None                        | Block stop                    |
| StopFailure        | Turn          | Error types                 | None (observability)          |
| SubagentStart      | Subagent      | Agent type names            | Context injection             |
| SubagentStop       | Subagent      | Agent type names            | Block stop                    |
| TeammateIdle       | Teams         | None                        | Reject idle (exit 2), stop    |
| TaskCompleted      | Teams         | None                        | Reject completion (exit 2)    |
| PreCompact         | Context       | manual, auto                | None (observability)          |
| PostCompact        | Context       | manual, auto                | None (observability)          |
| ConfigChange       | Config        | Settings sources            | Block (except policy)         |
| CwdChanged         | Environment   | None                        | None (env vars, watchPaths)   |
| FileChanged        | Environment   | Basenames (pipe-separated)  | None (env vars, watchPaths)   |
| WorktreeCreate     | Worktree      | None                        | Return path, exit code        |
| WorktreeRemove     | Worktree      | None                        | None (cleanup)                |
| Elicitation        | MCP           | MCP server name             | Accept/decline/cancel         |
| ElicitationResult  | MCP           | MCP server name             | Override response              |
| Notification       | Notification  | Notification types          | None (observability)          |

### Critical Gotchas

1. **No "Setup" event.** Use `SessionStart` with matcher `startup` for initialization.
2. **Shell profile noise breaks JSON parsing.** If `.bashrc`/`.zshrc` prints text, it contaminates stdout.
3. **SessionEnd has a 1.5s timeout.** Set `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` for longer cleanup.
4. **Duplicate hooks are deduplicated.** Command hooks by command string, HTTP hooks by URL.
5. **PreToolUse deprecated fields.** Old `decision: "approve|block"` replaced by `hookSpecificOutput.permissionDecision`.
6. **Policy settings cannot be blocked.** ConfigChange hooks for `policy_settings` silently ignore block decisions.
7. **Async hooks cannot block.** Exit code 2 is ignored for `async: true` hooks.
8. **Subagent Stop hooks auto-convert.** Stop hooks in subagent context become SubagentStop.
9. **HTTP hooks need 2xx for decisions.** Non-2xx status codes are treated as non-blocking errors.
10. **`disableAllHooks` cannot disable managed hooks.** Policy-managed hooks always run.

## Additional Resources

### Reference Files

For detailed patterns and advanced techniques, consult:

- **`references/event-schemas.md`** -- Complete input/output JSON schemas for all 24 events
- **`references/patterns.md`** -- Proven patterns including temporarily active and configuration-driven hooks
- **`references/migration.md`** -- Migrating from basic to advanced hooks
- **`references/advanced.md`** -- Advanced use cases and techniques
- **`references/hook-input-schemas.md`** -- Per-event and per-tool input field documentation

### Example Hook Scripts

Working examples in `examples/`:

> **Note:** After copying example scripts, make them executable: `chmod +x script.sh`

- **`validate-write.sh`** -- PreToolUse file write validation
- **`validate-bash.sh`** -- PreToolUse bash command validation
- **`load-context.sh`** -- SessionStart context loading
- **`stop-failure-alert.sh`** -- StopFailure API error alerting
- **`validate-task.sh`** -- TaskCompleted deliverable verification
- **`teammate-quality-gate.sh`** -- TeammateIdle quality gate
- **`create-worktree.sh`** -- WorktreeCreate custom worktree setup
- **`cleanup-worktree.sh`** -- WorktreeRemove resource cleanup
- **`audit-config-change.sh`** -- ConfigChange security monitoring
- **`handle-elicitation.sh`** -- Elicitation auto-response
- **`log-observability.sh`** -- Unified logging for InstructionsLoaded, PreCompact, PostCompact, Notification

### Utility Scripts

> **Prerequisites**: These scripts require `jq` for JSON validation. See the [main README](../../../../README.md#for-utility-scripts) for setup.

Development tools in `scripts/`:

- **`validate-hook-schema.sh`** -- Validate hooks.json structure and syntax
- **`test-hook.sh`** -- Test hooks with sample input before deployment
- **`hook-linter.sh`** -- Check hook scripts for common issues and best practices

### External Resources

- **Official Docs**: <https://code.claude.com/docs/en/hooks>
- **Testing**: Use `claude --debug` for detailed logs
- **Validation**: Use `jq` to validate hook JSON output

## Implementation Workflow

To implement hooks in a plugin:

1. Identify events to hook into (see [Quick Reference](#all-24-hook-events))
2. Decide hook type: prompt (flexible), agent (multi-step), command (deterministic), or HTTP (external)
3. Write hook configuration in `hooks/hooks.json`
4. For command hooks, create hook scripts
5. Use `${CLAUDE_PLUGIN_ROOT}` for all file references
6. Validate configuration with `scripts/validate-hook-schema.sh hooks/hooks.json`
7. Test hooks with `scripts/test-hook.sh` before deployment
8. Test in Claude Code with `claude --debug`
9. Document hooks in plugin README
