# Hook Event Schemas Reference

Complete input and output JSON schemas for all 29 Claude Code hook events.

**Last verified:** 2026-05-28 against official docs, Python SDK (`claude-agent-sdk`), and TypeScript SDK.

## Common Fields

### Base Input (all events)

```json
{
  "session_id": "string",
  "transcript_path": "string (path to transcript JSONL)",
  "cwd": "string (current working directory)",
  "hook_event_name": "string (event discriminant)",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions",
  "effort": {
    "level": "string (CC 2.1.133)"
  }
}
```

`permission_mode` is present on most events but not all (notably absent from SessionStart and InstructionsLoaded).

> **CC 2.1.133:** Hooks now receive the active effort level via the `effort.level` JSON input field and `$CLAUDE_EFFORT` environment variable. Enables hooks to adapt behavior based on effort settings.

When running inside a subagent, these additional fields are present:

```json
{
  "agent_id": "string",
  "agent_type": "string"
}
```

### Base Output (all events)

All fields are optional. Omitted fields use defaults.

```json
{
  "continue": true,
  "stopReason": "string (shown when continue is false)",
  "suppressOutput": false,
  "decision": "block",
  "reason": "string (feedback to Claude when decision is block)",
  "systemMessage": "string (warning displayed to user)",
  "hookSpecificOutput": {
    "hookEventName": "string",
    "additionalContext": "string (injected into Claude's context)"
  }
}
```

### Exit Code Semantics

| Code  | Behavior                                                 |
| ----- | -------------------------------------------------------- |
| 0     | Success. stdout parsed as JSON if present                |
| 2     | Blocking error. stderr content fed to Claude or user     |
| Other | Non-blocking error. Shown in verbose/debug mode only     |

**SessionStart/Setup/SubagentStart stderr fix (CC 2.1.199):** These hooks now properly show stderr in the transcript when exiting with code 2. Previously, stderr was silently hidden for these specific hooks, making debugging difficult. Error messages now appear correctly in the transcript.

---

## Session Lifecycle

### SessionStart

**When:** New session, resume (`--resume`/`--continue`/`/resume`), `/clear`, fork, or after compaction.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "SessionStart",
  "source": "startup|resume|clear|compact|fork",
  "model": "string (model ID)",
  "agent_type": "string (optional, present with --agent)"
}
```

Note: `permission_mode` is not present on SessionStart.

> **CC 2.1.214/2.1.218:** SessionStart hooks now report `source: "fork"` when the session begins as a fork (via `/fork` command or programmatic fork). Previously, forked sessions were reported as `"resume"`. This allows hooks to distinguish genuine session resumption from fork-initiated sessions.

**Output:**

```json
{
  "continue": true,
  "stopReason": "string (optional)",
  "suppressOutput": false,
  "systemMessage": "string (optional)",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "string (optional)",
    "reloadSkills": false,
    "sessionTitle": "string (optional)"
  }
}
```

- `reloadSkills` (CC 2.1.152): When `true`, triggers skill directory re-scanning. Useful when a hook installs or updates skills at session start.
- `sessionTitle` (CC 2.1.152): Sets the session title. Only applies when `source` is `"startup"` or `"resume"` — ignored on `"clear"`, `"compact"`, and `"fork"`.

**Special behavior:** The `CLAUDE_ENV_FILE` environment variable points to a file where you can write `export VAR=value` lines. These persist as environment variables for subsequent Bash tool calls in the session.

**Matchers:** `startup`, `resume`, `clear`, `compact`, `fork`
**Hook types:** Command only

---

### InstructionsLoaded

**When:** CLAUDE.md or `.claude/rules/*.md` files are loaded into context (at session start or lazily during traversal).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "InstructionsLoaded",
  "file_path": "string (path to the loaded file)",
  "memory_type": "User|Project|Local|Managed",
  "load_reason": "session_start|nested_traversal|path_glob_match|include|compact",
  "globs": ["string (optional, glob patterns that triggered the load)"],
  "trigger_file_path": "string (optional, file whose access triggered glob match)",
  "parent_file_path": "string (optional, file that included this one)"
}
```

**Output:** Observability only. No decision control. Runs asynchronously.

**Matchers:** `session_start`, `nested_traversal`, `path_glob_match`, `include`, `compact`
**Hook types:** Command, HTTP, Prompt, Agent

---

### SessionEnd

**When:** Session terminates.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "SessionEnd",
  "reason": "clear|logout|prompt_input_exit|bypass_permissions_disabled|resume|other"
}
```

**Output:** Observability only. No decision control.

**Default timeout:** 1.5 seconds. Override with `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` environment variable (set in milliseconds).

**Matchers:** `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`, `resume`, `other`
**Hook types:** Command, HTTP, Prompt, Agent

---

### PostSession (CC 2.1.169)

**When:** After session ends, before workspace deletion. Designed for self-hosted runners that need cleanup time.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "PostSession"
}
```

**Output:** Observability only. No decision control. Command hooks only.

**Key features:**

- Runs **after** SessionEnd, providing additional cleanup window
- Configurable SIGTERM→SIGKILL window for graceful shutdown
- Ideal for self-hosted runners that need to persist logs, artifacts, or state
- Workspace is still available during this hook (deleted after)

**Use cases:** Upload session artifacts to external storage, persist logs for debugging, clean up external resources created during the session, notify monitoring systems of session completion.

**Matchers:** Not supported
**Hook types:** Command only

---

## User Input

### UserPromptSubmit

**When:** User submits a prompt, before Claude processes it.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "string (the user's input)"
}
```

**Output:**

```json
{
  "decision": "block",
  "reason": "string (shown to user when blocking)",
  "continue": true,
  "stopReason": "string (optional)",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "string (optional)"
  }
}
```

**Matchers:** Not supported (matcher field is silently ignored).
**Hook types:** Command, HTTP, Prompt, Agent

---

## Tool Lifecycle

### PreToolUse

**When:** After Claude creates tool parameters, before execution.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "PreToolUse",
  "tool_name": "string",
  "tool_input": {
    "command": "string (Bash)",
    "file_path": "string (Write/Edit/Read)",
    "old_string": "string (Edit)",
    "new_string": "string (Edit)",
    "content": "string (Write)",
    "pattern": "string (Glob/Grep)",
    "url": "string (WebFetch)",
    "query": "string (WebSearch)",
    "prompt": "string (Agent)"
  },
  "tool_use_id": "string"
}
```

`tool_input` fields vary by tool. The above shows common fields; MCP tools have server-defined inputs.

> **CC 2.1.88:** The `file_path` field for Write, Edit, and Read tools now provides **absolute paths**.

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "string (optional)",
    "updatedInput": {
      "command": "string (modified tool input)"
    },
    "additionalContext": "string (optional)"
  }
}
```

- `permissionDecision`: `"allow"` approves without prompting, `"deny"` blocks execution, `"ask"` shows permission dialog, `"defer"` pauses execution
- `permissionDecisionReason`: Explanation logged for the decision
- `updatedInput`: Replace specific tool_input fields (merged, not replaced wholesale). For `AskUserQuestion` tool calls, return `updatedInput` alongside `permissionDecision: "allow"` to provide answers programmatically (CC 2.1.85), enabling headless integrations that collect answers via their own UI.
- `additionalContext`: Injected into Claude's context for this tool call

**Defer pattern (CC 2.1.89):** Return `permissionDecision: "defer"` to pause tool execution in headless sessions. The session can be resumed later with `-p --resume`. Use `defer` when you need external approval or want to batch decisions for later processing.

**Deprecated fields:** Top-level `decision: "approve|block"` still works but `hookSpecificOutput.permissionDecision` takes precedence.

**Matchers:** Tool names. Supports regex: `"Write|Edit"`, `"mcp__.*__delete.*"`
**Hook types:** Command, HTTP, Prompt, Agent

---

### PermissionRequest

**When:** A permission dialog is about to be shown to the user.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "PermissionRequest",
  "tool_name": "string",
  "tool_input": {},
  "permission_suggestions": [
    {
      "type": "addRules|replaceRules|removeRules|setMode|addDirectories|removeDirectories",
      "rules": [],
      "behavior": "allow|deny|ask",
      "destination": "session|localSettings|projectSettings|userSettings",
      "mode": "string (optional)"
    }
  ]
}
```

- `permission_suggestions`: The "always allow" options that would normally be shown to the user in the permission dialog

**Output:**

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
      "message": "string (deny only)",
      "interrupt": false
    }
  }
}
```

- `behavior`: `"allow"` approves, `"deny"` rejects
- `updatedInput`: Modify tool parameters (allow only)
- `updatedPermissions`: Apply permission changes so user isn't prompted again (allow only)
- `message`: Reason for denial, shown to user (deny only)
- `interrupt`: If true, stops Claude entirely (deny only)

**Difference from PreToolUse:** PreToolUse runs before every tool execution regardless of permission status. PermissionRequest runs only when a permission dialog would be shown to the user.

**Known issues:** `additionalContext` is parsed but silently dropped ([anthropics/claude-code#28035](https://github.com/anthropics/claude-code/issues/28035)) — it works in PreToolUse but not here. Race condition where the dialog may briefly show despite returning "allow" ([#12176](https://github.com/anthropics/claude-code/issues/12176)).

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent

---

### PermissionDenied

**When:** After auto mode classifier denies a tool call (CC 2.1.88).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "PermissionDenied",
  "tool_name": "string",
  "tool_input": {}
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionDenied",
    "retry": true
  }
}
```

- `retry`: If `true`, requests Claude to retry the denied operation

**Difference from PermissionRequest:** PermissionRequest fires when a dialog is about to show; PermissionDenied fires after auto mode has already denied the operation.

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent

---

### PostToolUse

**When:** After tool execution succeeds.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "PostToolUse",
  "tool_name": "string",
  "tool_input": {},
  "tool_response": "any (tool's return value)",
  "tool_use_id": "string",
  "duration_ms": "number (CC 2.1.119, how long the tool execution took)"
}
```

> **CC 2.1.119:** PostToolUse and PostToolUseFailure hooks now include a `duration_ms` field in the input, showing how long the tool execution took. Useful for performance monitoring hooks.

**Output:**

```json
{
  "decision": "block",
  "reason": "string (when blocking)",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "string (optional)",
    "updatedToolOutput": "any (CC 2.1.121, any tool)",
    "updatedMCPToolOutput": "any (MCP tools only, legacy)"
  }
}
```

- `updatedToolOutput`: Replace tool output for **any** tool (CC 2.1.121). Use this for general tool output modification.
- `updatedMCPToolOutput`: Replace tool output for **MCP tools only** (legacy, still works). Prefer `updatedToolOutput` for new hooks.

**Continue on block (CC 2.1.139):** PostToolUse hooks support a `continueOnBlock` option on the hook entry. When set and the hook returns `decision: "block"`, the rejection reason is fed back to Claude as context instead of stopping execution entirely. This lets the hook provide corrective feedback while letting Claude continue working.

```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-style.sh",
  "continueOnBlock": true
}
```

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent

---

### PostToolUseFailure

**When:** After tool execution fails.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "PostToolUseFailure",
  "tool_name": "string",
  "tool_input": {},
  "tool_use_id": "string",
  "error": "string (error message)",
  "is_interrupt": false,
  "duration_ms": "number (CC 2.1.119, how long the tool ran before failing)"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUseFailure",
    "additionalContext": "string (optional)"
  }
}
```

**Matchers:** Tool names (same as PreToolUse)
**Hook types:** Command, HTTP, Prompt, Agent

---

## Turn Control

### Stop

**When:** Main agent finishes responding (not fired on user interrupt).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "Stop",
  "stop_hook_active": true,
  "last_assistant_message": "string"
}
```

- `stop_hook_active`: Whether a Stop hook is currently processing (prevents infinite recursion)

**Output:**

```json
{
  "decision": "block",
  "reason": "string (required when blocking -- fed back to Claude as instructions)"
}
```

When `decision` is `"block"`, Claude receives `reason` as feedback and attempts another turn.

**Additional context return (CC 2.1.163):** Stop and SubagentStop hooks can return `hookSpecificOutput.additionalContext` to inject context into Claude's next turn without blocking:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "Remember to update the documentation after this change."
  }
}
```

**Impossible response (CC 2.1.143):** Stop condition evaluators can return a third response shape for conditions that can never be satisfied:

```json
{
  "ok": false,
  "impossible": true,
  "reason": "The required API endpoint does not exist in this codebase"
}
```

Use `impossible` when the goal is self-contradictory, requires a missing capability, or the assistant has exhausted all approaches. The evaluator independently verifies impossibility rather than trusting the assistant's self-assessment.

**Block cap (CC 2.1.143):** Stop hooks have an 8-block safety cap. Turns end with a warning after 8 consecutive blocks to prevent infinite loops. Override with the `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` environment variable if needed.

**Matchers:** Not supported.
**Hook types:** Command, HTTP, Prompt, Agent

---

### StopFailure

**When:** Turn ends due to an API error (rate limit, auth failure, billing, server error).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "StopFailure",
  "error": "string (error category)",
  "error_details": "string (optional, detailed error message)",
  "last_assistant_message": "string"
}
```

**Output:** Ignored. This is an observability-only event. Output and exit codes have no effect.

**Matchers:** `rate_limit`, `authentication_failed`, `billing_error`, `invalid_request`, `server_error`, `max_output_tokens`, `unknown`
**Hook types:** Command, HTTP, Prompt, Agent

---

## Subagents

### SubagentStart

**When:** A subagent is spawned via the Agent tool.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "SubagentStart",
  "agent_id": "string",
  "agent_type": "string"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SubagentStart",
    "additionalContext": "string (optional, injected into subagent context)"
  }
}
```

**Matchers:** Agent type names (`Bash`, `Explore`, `Plan`, or custom agent names from plugins)
**Hook types:** Command, HTTP, Prompt, Agent

---

### SubagentStop

**When:** A subagent finishes responding.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "SubagentStop",
  "stop_hook_active": true,
  "agent_id": "string",
  "agent_type": "string",
  "agent_transcript_path": "string (path to subagent's transcript)",
  "last_assistant_message": "string"
}
```

**Output:**

```json
{
  "decision": "block",
  "reason": "string (required when blocking -- fed back to subagent)"
}
```

Same semantics as Stop: blocking causes the subagent to continue working with `reason` as feedback.

**Note:** Stop hooks defined in a subagent context automatically convert to SubagentStop events.

**Matchers:** Agent type names (same as SubagentStart)
**Hook types:** Command, HTTP, Prompt, Agent

---

## Teams

### TeammateIdle

**When:** An agent team teammate is about to go idle.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "TeammateIdle",
  "teammate_name": "string",
  "team_name": "string"
}
```

**Output:** Two feedback mechanisms:

1. **Exit code 2:** Teammate receives stderr as feedback and continues working (does not go idle)
2. **JSON `{"continue": false, "stopReason": "..."}`:** Teammate stops entirely

Normal exit (code 0) with no blocking output allows the teammate to go idle.

**Matchers:** Not supported.
**Hook types:** Command, HTTP, Prompt, Agent

---

### TaskCompleted

**When:** A task is marked as completed (explicitly or at end-of-turn).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "TaskCompleted",
  "task_id": "string",
  "task_subject": "string",
  "task_description": "string (optional)",
  "teammate_name": "string (optional)",
  "team_name": "string (optional)"
}
```

**Output:** Two feedback mechanisms (same as TeammateIdle):

1. **Exit code 2:** Task NOT marked complete. stderr fed back as feedback; agent continues working
2. **JSON `{"continue": false, "stopReason": "..."}`:** Teammate stops entirely

Normal exit allows the task completion to proceed.

**Matchers:** Not supported.
**Hook types:** Command, HTTP, Prompt, Agent

---

## Context Management

### PreCompact

**When:** Before context compaction starts.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "PreCompact",
  "trigger": "manual|auto",
  "custom_instructions": "string (user-provided compaction instructions, if any)"
}
```

**Output:**

As of CC 2.1.105, PreCompact supports blocking compaction:

- Exit code 2 or `{"decision": "block"}` blocks compaction
- Use to preserve critical context when compaction would lose important state
- `additionalContext` injects information to be considered during compaction

> **CC 2.1.88:** Added partial compaction capability. Claude Code can now compact only a portion of the conversation rather than the entire context, with a structured summary format and analysis process.

**Matchers:** `manual`, `auto`
**Hook types:** Command, HTTP, Prompt, Agent

---

### PostCompact

**When:** After context compaction completes.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "PostCompact",
  "trigger": "manual|auto",
  "compact_summary": "string (the compaction result summary)"
}
```

**Output:** Observability only. No decision control.

Use to verify what survived compaction, log compaction results, or send alerts if critical context was lost.

**Matchers:** `manual`, `auto`
**Hook types:** Command, HTTP, Prompt, Agent

---

## Configuration

### ConfigChange

**When:** A configuration file changes during a session.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "ConfigChange",
  "source": "user_settings|project_settings|local_settings|policy_settings|skills",
  "file_path": "string (optional, path to the changed file)"
}
```

**Output:**

```json
{
  "decision": "block",
  "reason": "string (when blocking)"
}
```

**Important:** Block decisions for `policy_settings` source are silently ignored. Policy changes cannot be blocked.

**Matchers:** `user_settings`, `project_settings`, `local_settings`, `policy_settings`, `skills`
**Hook types:** Command, HTTP, Prompt, Agent

---

## Environment

### CwdChanged

**When:** The working directory changes during a session (e.g., Claude runs `cd`).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "CwdChanged",
  "old_cwd": "string",
  "new_cwd": "string"
}
```

**Output:** Cannot block directory changes. Special capabilities:

- Supports `$CLAUDE_ENV_FILE` — write `export VAR=value` to persist env vars into subsequent Bash commands
- Can return a `watchPaths` array to dynamically update file monitoring

**Use case:** Reactive environment management with tools like direnv — reload env vars, activate project-specific toolchains, or run setup scripts on directory change.

**Matchers:** Not supported (fires on every directory change).
**Hook types:** Command, HTTP, Prompt, Agent

---

### FileChanged

**When:** A watched file changes on disk.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "FileChanged",
  "file_path": "string (absolute)",
  "event": "change|add|unlink"
}
```

**Output:** Cannot block file changes. Special capabilities:

- Supports `$CLAUDE_ENV_FILE` for persisting environment variable changes
- Can return a `watchPaths` array to dynamically update monitored paths

**File modification budget-exceeded reminder (CC 2.1.124):** When a user or linter changes a file but the diff is omitted because other modified files exceeded the snippet budget, Claude receives a system reminder directing it to read the file if current content is needed. Hooks processing FileChanged events should be aware that detailed diff content may not always be available in Claude's context.

**Use case:** Reloading environment variables when config files change, triggering rebuilds on config modifications.

**Matchers:** Pipe-separated basenames (filenames without directory paths), e.g. `".envrc|.env"`.
**Hook types:** Command, HTTP, Prompt, Agent

---

## Worktrees

### WorktreeCreate

**When:** A git worktree is created via `--worktree` flag or subagent with `isolation: "worktree"`.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "WorktreeCreate",
  "name": "string (worktree identifier)"
}
```

**Output:** The hook must return the **absolute path** to the created worktree directory.

- **Command hooks:** print the path on stdout. Exit code 0 succeeds using the printed path; non-zero exit code fails. This is the only command hook where stdout is a plain path string rather than JSON.
- **HTTP hooks:** return the path via `hookSpecificOutput.worktreePath`:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "WorktreeCreate",
    "worktreePath": "/absolute/path/to/worktree"
  }
}
```

> **worktree.baseRef setting (CC 2.1.133):** The `worktree.baseRef` setting controls the base reference for new worktrees. Options are `fresh` (default, branch from `origin/<default-branch>`) and `head` (branch from current local HEAD). Hooks processing WorktreeCreate events can check this setting to understand the worktree's origin point.

**Matchers:** Not supported.
**Hook types:** Command, HTTP.

---

### WorktreeRemove

**When:** A worktree is being removed (session exit or subagent finish).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "WorktreeRemove",
  "worktree_path": "string (absolute path to worktree being removed)"
}
```

**Output:** Cleanup only. Output and exit code are ignored.

**Matchers:** Not supported.
**Hook types:** Command only.

---

## MCP Elicitation

### Elicitation

**When:** An MCP server requests user input mid-task via the elicitation protocol.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "Elicitation",
  "mcp_server_name": "string",
  "message": "string (prompt from the MCP server)",
  "mode": "form|url (optional)",
  "url": "string (optional, for URL-mode elicitations)",
  "elicitation_id": "string (optional)",
  "requested_schema": {
    "type": "object",
    "properties": {},
    "required": []
  }
}
```

- `mode`: `"form"` for structured input, `"url"` for URL-based authentication flows
- `requested_schema`: JSON Schema describing what the MCP server expects back

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Elicitation",
    "action": "accept|decline|cancel",
    "content": {
      "field_name": "value"
    }
  }
}
```

- `accept`: Provide response matching `requested_schema` via `content`
- `decline`: Reject the elicitation request
- `cancel`: Cancel the entire MCP operation

**Matchers:** MCP server name
**Hook types:** Command, HTTP, Prompt, Agent

---

### ElicitationResult

**When:** After a user responds to an MCP elicitation, before the response is sent back to the MCP server.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "permission_mode": "string",
  "hook_event_name": "ElicitationResult",
  "mcp_server_name": "string",
  "elicitation_id": "string",
  "user_response": {
    "field_name": "value"
  }
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "ElicitationResult",
    "action": "accept|decline|cancel",
    "content": {
      "field_name": "overridden value"
    }
  }
}
```

- `accept` with `content`: Override the user's response
- `accept` without `content`: Pass through user's response unchanged
- `decline` or `cancel`: Reject or cancel the operation

**Matchers:** MCP server name
**Hook types:** Command, HTTP, Prompt, Agent

---

## Notifications

### Notification

**When:** Claude Code sends a notification (permission prompt, idle prompt, auth event, elicitation dialog).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "Notification",
  "message": "string",
  "title": "string (optional)",
  "notification_type": "string"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Notification",
    "additionalContext": "string (optional)"
  }
}
```

Observability only. No decision control.

**Background Agent Notifications (CC 2.1.198):** Added matchers for background agent lifecycle events — `agent_needs_input` (background agent is blocked waiting for user input) and `agent_completed` (background agent has finished its work). These enable hooks to respond when background agents reach completion or need attention, facilitating automated workflows and external alerting for background agent status.

**Desktop/VS Code fix (CC 2.1.233):** Fixed Notification hooks not firing for permission prompts under Desktop and VS Code environments. Plugin developers using the `permission_prompt` matcher should now see consistent behavior across all Claude Code interfaces (CLI, Desktop, VS Code).

**Matchers:** `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`, `agent_needs_input` (CC 2.1.198), `agent_completed` (CC 2.1.198)
**Hook types:** Command, HTTP, Prompt, Agent

---

## Message Display

### MessageDisplay

**When:** While assistant message text streams (CC 2.1.152).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "MessageDisplay",
  "message_text": "string (current streamed text)"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "MessageDisplay",
    "displayContent": "string (replacement text to display)"
  }
}
```

- `displayContent`: Replaces displayed text on screen. This is display-only — the transcript and what Claude sees retain the original text.

**Key limitations:**

- Cannot block operations (display-only hook)
- Matchers are not supported
- Does not affect what Claude sees or the transcript record
- Fires during streaming, may be called multiple times per message

**Use cases:** Custom message formatting or styling, redacting sensitive information from display, logging assistant output in real-time, observability and monitoring.

**Matchers:** Not supported
**Hook types:** Command, HTTP, Prompt, Agent

---

## Background Tasks

### BackgroundTasksChanged (CC 2.1.203)

**When:** Background task state changes (tasks started, completed, or failed).

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "BackgroundTasksChanged",
  "tasks": [
    {
      "id": "string (task identifier)"
    }
  ]
}
```

**Key behaviors:**

- **Replace-set semantics:** The `tasks` array contains the complete current set of background tasks (not incremental updates). Compare against previous state to determine what changed.
- **Unspecified ordering:** Task changes may arrive out of order relative to bookend events (SubagentStart/SubagentStop). Do not assume ordering guarantees.
- **Id-only payloads:** Task entries contain only the `id` field. Use other mechanisms to query task details if needed.
- **Per-process reset:** Task state resets when the Claude Code process restarts.

**Output:** Observability only. No decision control.

**Use cases:**

- Track background agent progress for dashboards or monitoring
- Trigger notifications when tasks complete or fail
- Implement custom task coordination logic
- Log task state changes for debugging multi-agent workflows

**Matchers:** Not supported
**Hook types:** Command, HTTP, Prompt, Agent

---

## Directory Lifecycle

### DirectoryAdded (CC 2.1.219)

**When:** After a new directory is registered mid-session via `/add-dir` command or SDK `register_repo_root` requests.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "DirectoryAdded",
  "directory_path": "string (absolute path to newly added directory)",
  "source": "user_command|sdk_request"
}
```

**Output:** Observability only. No decision control.

**Key behaviors:**

- Fires **after** the directory is successfully registered and sandbox is refreshed
- `source` indicates whether the directory was added via user `/add-dir` command or programmatic SDK `register_repo_root` request
- Useful for loading project-specific context, triggering workspace indexing, or notifying external systems of new project scope

**Use cases:**

- Automatically load CLAUDE.md or project configuration from newly added directories
- Trigger LSP server initialization for new workspaces
- Update monitoring or logging systems with new project scope
- Run initialization scripts for newly added project directories

**Matchers:** `user_command`, `sdk_request`
**Hook types:** Command, HTTP, Prompt, Agent

---

## SDK Parity Notes

Not all events are typed in both SDKs. As of July 2026:

**Python SDK** (`claude-agent-sdk`) types 10 of 29 events: PreToolUse, PostToolUse, PostToolUseFailure, UserPromptSubmit, Stop, SubagentStop, PreCompact, Notification, SubagentStart, PermissionRequest.

**TypeScript SDK** (`@anthropic-ai/claude-agent-sdk`) is closer to parity with the CLI. Events added over time: TeammateIdle and TaskCompleted (v2.1.34), ConfigChange (v0.2.49), Elicitation and ElicitationResult (v0.2.76).

**CLI** supports all 29 events.

Events only available in CLI (not yet in either SDK): WorktreeCreate, WorktreeRemove, PostCompact, InstructionsLoaded, StopFailure, PermissionDenied (CC 2.1.88), MessageDisplay (CC 2.1.152), PostSession (CC 2.1.169), BackgroundTasksChanged (CC 2.1.203), DirectoryAdded (CC 2.1.219).
