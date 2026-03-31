# Hook Input Schemas

Comprehensive reference for all hook input schemas. Every hook receives JSON via stdin containing common fields plus event-specific fields.

## Common Fields (All Hooks)

Every hook receives these fields:

| Field             | Type   | Description                    |
| ----------------- | ------ | ------------------------------ |
| `session_id`      | string | Unique session identifier      |
| `transcript_path` | string | Path to conversation JSON      |
| `cwd`             | string | Current working directory      |
| `permission_mode` | string | Current permission mode        |
| `hook_event_name` | string | Event that triggered this hook |

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

### UserPromptSubmit

| Field    | Type   | Description                    |
| -------- | ------ | ------------------------------ |
| `prompt` | string | The user-submitted prompt text |

### Stop / SubagentStop

| Field                   | Type    | Events       | Description                                     |
| ----------------------- | ------- | ------------ | ----------------------------------------------- |
| `stop_hook_active`      | boolean | Both         | Whether hook is already continuing (loop guard) |
| `agent_id`              | string  | SubagentStop | Unique subagent identifier                      |
| `agent_type`            | string  | SubagentStop | Agent name                                      |
| `agent_transcript_path` | string  | SubagentStop | Path to subagent transcript                     |

### SubagentStart

| Field        | Type   | Description                |
| ------------ | ------ | -------------------------- |
| `agent_id`   | string | Unique subagent identifier |
| `agent_type` | string | Agent name                 |

### SessionStart

| Field        | Type   | Description                                      |
| ------------ | ------ | ------------------------------------------------ |
| `source`     | string | Matcher: `startup`, `resume`, `clear`, `compact` |
| `model`      | string | Model identifier                                 |
| `agent_type` | string | If running as an agent (optional)                |

### SessionEnd

| Field    | Type   | Description                                                                            |
| -------- | ------ | -------------------------------------------------------------------------------------- |
| `source` | string | Values: `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`, `other` |

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

### TaskCompleted

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

| Tool         | `tool_input` Fields                                                                                                                                                   |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bash         | `command` (string), `description` (string, optional), `timeout` (number, optional), `run_in_background` (boolean, optional)                                           |
| Write        | `file_path` (string), `content` (string)                                                                                                                              |
| Edit         | `file_path` (string), `old_string` (string), `new_string` (string), `replace_all` (boolean, optional)                                                                 |
| Read         | `file_path` (string), `offset` (number, optional), `limit` (number, optional)                                                                                         |
| Glob         | `pattern` (string), `path` (string, optional)                                                                                                                         |
| Grep         | `pattern` (string), `path` (string, optional), `glob` (string, optional), `output_mode` (string, optional), `-i` (boolean, optional), `multiline` (boolean, optional) |
| WebFetch     | `url` (string), `prompt` (string)                                                                                                                                     |
| WebSearch    | `query` (string), `allowed_domains` (array, optional), `blocked_domains` (array, optional)                                                                            |
| Task         | `prompt` (string), `description` (string), `subagent_type` (string), `model` (string, optional)                                                                       |
| Skill        | `skill` (string), `args` (string, optional)                                                                                                                           |
| NotebookEdit | `notebook_path` (string), `new_source` (string), `cell_type` (string, optional), `edit_mode` (string, optional)                                                       |

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
  echo '{"decision": "deny", "reason": "Cannot write to .env files"}' >&2
  exit 2
fi

# Allow by default
exit 0
```
