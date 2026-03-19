# Hook Event Schemas Reference

Complete input and output JSON schemas for all 22 Claude Code hook events.

**Last verified:** 2026-03-20 against official docs, Python SDK (`claude-agent-sdk`), and TypeScript SDK.

## Common Fields

### Base Input (all events)

```json
{
  "session_id": "string",
  "transcript_path": "string (path to transcript JSONL)",
  "cwd": "string (current working directory)",
  "hook_event_name": "string (event discriminant)",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions"
}
```

`permission_mode` is present on most events but not all (notably absent from SessionStart and InstructionsLoaded).

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

---

## Session Lifecycle

### SessionStart

**When:** New session, resume (`--resume`/`--continue`/`/resume`), `/clear`, or after compaction.

**Input:**

```json
{
  "session_id": "string",
  "transcript_path": "string",
  "cwd": "string",
  "hook_event_name": "SessionStart",
  "source": "startup|resume|clear|compact",
  "model": "string (model ID)",
  "agent_type": "string (optional, present with --agent)"
}
```

Note: `permission_mode` is not present on SessionStart.

**Output:**

```json
{
  "continue": true,
  "stopReason": "string (optional)",
  "suppressOutput": false,
  "systemMessage": "string (optional)",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "string (optional)"
  }
}
```

**Special behavior:** The `CLAUDE_ENV_FILE` environment variable points to a file where you can write `export VAR=value` lines. These persist as environment variables for subsequent Bash tool calls in the session.

**Matchers:** `startup`, `resume`, `clear`, `compact`
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

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "string (optional)",
    "updatedInput": {
      "command": "string (modified tool input)"
    },
    "additionalContext": "string (optional)"
  }
}
```

- `permissionDecision`: `"allow"` approves without prompting, `"deny"` blocks execution, `"ask"` shows permission dialog
- `permissionDecisionReason`: Explanation logged for the decision
- `updatedInput`: Replace specific tool_input fields (merged, not replaced wholesale)
- `additionalContext`: Injected into Claude's context for this tool call

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

**Known issue:** `additionalContext` is parsed but silently dropped ([anthropics/claude-code#28035](https://github.com/anthropics/claude-code/issues/28035)).

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
  "tool_use_id": "string"
}
```

**Output:**

```json
{
  "decision": "block",
  "reason": "string (when blocking)",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "string (optional)",
    "updatedMCPToolOutput": "any (MCP tools only)"
  }
}
```

- `updatedMCPToolOutput`: For MCP tools, replaces the tool's response before Claude sees it

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
  "is_interrupt": false
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

**Output:** Observability only. No decision control.

Use `additionalContext` to inject information that should be considered during compaction.

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

**Output:** This event is unique -- stdout is the return value, not JSON.

- **stdout:** Must print the **absolute path** to the created worktree directory
- **Exit code 0:** Worktree creation succeeds using the printed path
- **Non-zero exit code:** Worktree creation fails

This is the only hook where the output is a plain path string rather than JSON.

**Matchers:** Not supported.
**Hook types:** Command only.

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

**Matchers:** `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`
**Hook types:** Command, HTTP, Prompt, Agent

---

## SDK Parity Notes

Not all events are typed in both SDKs. As of March 2026:

**Python SDK** (`claude-agent-sdk`) types 10 of 22 events: PreToolUse, PostToolUse, PostToolUseFailure, UserPromptSubmit, Stop, SubagentStop, PreCompact, Notification, SubagentStart, PermissionRequest.

**TypeScript SDK** (`@anthropic-ai/claude-agent-sdk`) is closer to parity with the CLI. Events added over time: TeammateIdle and TaskCompleted (v2.1.34), ConfigChange (v0.2.49), Elicitation and ElicitationResult (v0.2.76).

**CLI** supports all 22 events.

Events only available in CLI (not yet in either SDK): WorktreeCreate, WorktreeRemove, PostCompact, InstructionsLoaded, StopFailure.
