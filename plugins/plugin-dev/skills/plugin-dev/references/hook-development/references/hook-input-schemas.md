# Hook Input Schemas

Comprehensive reference for all hook input schemas. Every hook receives JSON via stdin containing common fields plus event-specific fields.

## Common Fields (All Hooks)

Every hook receives these fields:

| Field             | Type   | Description                                                                   |
| ----------------- | ------ | ----------------------------------------------------------------------------- |
| `session_id`      | string | Unique session identifier                                                     |
| `transcript_path` | string | Path to conversation JSON                                                     |
| `cwd`             | string | Current working directory                                                     |
| `permission_mode` | string | Current permission mode                                                       |
| `hook_event_name` | string | Event that triggered this hook                                                |
| `effort.level`    | string | Active effort level (CC 2.1.133). Also available as `$CLAUDE_EFFORT` env var. |

## Event-Specific Input Fields

### PreToolUse / PostToolUse / PostToolUseFailure / PermissionRequest

| Field                    | Type    | Events             | Description                                   |
| ------------------------ | ------- | ------------------ | --------------------------------------------- |
| `tool_name`              | string  | All four           | Name of the tool                              |
| `tool_input`             | object  | All four           | Arguments sent to the tool (see tool schemas) |
| `tool_result`            | string  | PostToolUse        | Tool execution result                         |
| `tool_use_id`            | string  | PostToolUse        | Unique tool use identifier                    |
| `error`                  | string  | PostToolUseFailure | Error message from the failed tool            |
| `is_interrupt`           | boolean | PostToolUseFailure | Whether failure was caused by user interrupt  |
| `permission_suggestions` | array   | PermissionRequest  | Suggested permission decisions                |

### PostToolBatch

| Field        | Type  | Description                                                                                                |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------- |
| `tool_calls` | array | One entry per tool call in the batch: `tool_name`, `tool_input`, `tool_use_id`, `tool_response` (optional) |

### UserPromptSubmit

| Field    | Type   | Description                    |
| -------- | ------ | ------------------------------ |
| `prompt` | string | The user-submitted prompt text |

### UserPromptExpansion

| Field            | Type   | Description                                       |
| ---------------- | ------ | ------------------------------------------------- |
| `expansion_type` | string | `slash_command` or `mcp_prompt`                   |
| `command_name`   | string | Name of the command being expanded; matcher field |
| `command_args`   | string | Arguments typed after the command                 |
| `command_source` | string | Where the command is defined (optional)           |
| `prompt`         | string | The expanded prompt text                          |

### Stop / SubagentStop

| Field                   | Type    | Events       | Description                                     |
| ----------------------- | ------- | ------------ | ----------------------------------------------- |
| `stop_hook_active`      | boolean | Both         | Whether hook is already continuing (loop guard) |
| `background_tasks`      | array   | Both         | In-flight background work in this session       |
| `session_crons`         | array   | Both         | Cron tasks that will wake this session later    |
| `agent_id`              | string  | SubagentStop | Unique subagent identifier                      |
| `agent_type`            | string  | SubagentStop | Agent name                                      |
| `agent_transcript_path` | string  | SubagentStop | Path to subagent transcript                     |

`background_tasks` and `session_crons` are both optional and both empty when there is nothing to report. Together they let a hook tell "the session is done" apart from "the session is paused waiting for background work or a scheduled wakeup". Element fields for each are in `event-schemas.md` (Stop).

### SubagentStart

| Field        | Type   | Description                |
| ------------ | ------ | -------------------------- |
| `agent_id`   | string | Unique subagent identifier |
| `agent_type` | string | Agent name                 |

### SessionStart

| Field        | Type   | Description                                              |
| ------------ | ------ | -------------------------------------------------------- |
| `source`     | string | Matcher: `startup`, `resume`, `clear`, `compact`, `fork` |
| `model`      | string | Model identifier                                         |
| `agent_type` | string | If running as an agent (optional)                        |

### Setup

| Field     | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| `trigger` | string | Matcher: `init` or `maintenance` |

### SessionEnd

| Field    | Type   | Description                                                       |
| -------- | ------ | ----------------------------------------------------------------- |
| `reason` | string | Values: `clear`, `resume`, `logout`, `prompt_input_exit`, `other` |

### PreCompact

| Field                 | Type   | Description                                |
| --------------------- | ------ | ------------------------------------------ |
| `trigger`             | string | `manual` or `auto`                         |
| `custom_instructions` | string | User instructions (manual) or empty (auto) |

### Notification

| Field               | Type   | Description                                                              |
| ------------------- | ------ | ------------------------------------------------------------------------ |
| `message`           | string | Notification text                                                        |
| `title`             | string | Notification title (optional)                                            |
| `notification_type` | string | `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog` |

### TeammateIdle

| Field           | Type   | Description   |
| --------------- | ------ | ------------- |
| `teammate_name` | string | Teammate name |
| `team_name`     | string | Team name     |

### TaskCreated / TaskCompleted

| Field              | Type   | Description                 |
| ------------------ | ------ | --------------------------- |
| `task_id`          | string | Task identifier             |
| `task_subject`     | string | Task subject line           |
| `task_description` | string | Task description (optional) |
| `teammate_name`    | string | Teammate name (optional)    |
| `team_name`        | string | Team name (optional)        |

## Tool Input Schemas (for PreToolUse/PostToolUse)

The `tool_input` object varies by tool. Common tool schemas:

> **CC 2.1.88:** The `file_path` field in PreToolUse/PostToolUse hooks for Write, Edit, and Read tools now provides **absolute paths**. Previously, paths could be relative. Hook scripts that process file paths should expect absolute paths.

> **CC 2.1.236 (Path-Sensitive Read-Before-Edit):** Claude Code's read-before-edit guidance is now path-sensitive. Files inside the current working directory no longer require a prior Read call before Edit or Write operations. However, files **outside** the working directory still require reading first to ensure the model has current content context. Hook developers should note this distinction when validating file modification patterns — blocking edits to files without prior reads is now only necessary for out-of-working-directory paths.

> **CC 2.1.267 (Bash Description Requirement):** The Bash tool's `description` parameter now requires **plain-language command summaries** rather than repeating command text, flags, or file paths. This is because users may not see the command itself in some display modes. Hook developers processing Bash tool input should note that descriptions are now expected to be human-readable explanations of what the command does, not technical command strings. Example: "List files in the project directory" rather than "ls -la /path/to/project".

| Tool         | `tool_input` Fields                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bash         | `command` (string), `description` (string, required for clarity), `timeout` (number, optional), `run_in_background` (boolean, optional)                                                                                                                                                                                                                                                              |
| Write        | `file_path` (string), `content` (string)                                                                                                                                                                                                                                                                                                                                                             |
| Edit         | `file_path` (string), `old_string` (string), `new_string` (string), `replace_all` (boolean, optional)                                                                                                                                                                                                                                                                                                |
| Read         | `file_path` (string), `offset` (number, optional), `limit` (number, optional)                                                                                                                                                                                                                                                                                                                        |
| Glob         | `pattern` (string), `path` (string, optional)                                                                                                                                                                                                                                                                                                                                                        |
| Grep         | `pattern` (string), `path` (string, optional), `glob` (string, optional), `output_mode` (string, optional), `-i` (boolean, optional), `multiline` (boolean, optional)                                                                                                                                                                                                                                |
| WebFetch     | `url` (string), `prompt` (string)                                                                                                                                                                                                                                                                                                                                                                    |
| WebSearch    | `query` (string), `allowed_domains` (array, optional), `blocked_domains` (array, optional)                                                                                                                                                                                                                                                                                                           |
| Task         | `prompt` (string), `description` (string), `subagent_type` (string), `model` (string, optional)                                                                                                                                                                                                                                                                                                      |
| Skill        | `skill` (string), `args` (string, optional)                                                                                                                                                                                                                                                                                                                                                          |
| NotebookEdit | `notebook_path` (string), `new_source` (string), `cell_id` (string, optional), `cell_number` (number, optional, deprecated), `cell_type` (string, optional), `edit_mode` (string, optional). **CC 2.1.162:** Editing uses `cell_id` from prior Read output; notebooks must be read before editing. Insert mode adds cells after the target cell or at the notebook start if no cell_id is specified. |

## Practical Example

Extracting fields in a bash hook script using `jq`:

```bash
#!/bin/bash
set -euo pipefail

# Read full input from stdin
input=$(cat)

# Extract common fields
session_id=$(echo "$input" | jq -r '.session_id')
hook_event=$(echo "$input" | jq -r '.hook_event_name')

# Extract tool-specific fields (PreToolUse/PostToolUse)
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Example: block writes to sensitive paths
if [[ "$tool_name" == "Write" && "$file_path" == *".env"* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Cannot write to .env files"}}'
  exit 0
fi

# Allow by default
exit 0
```
