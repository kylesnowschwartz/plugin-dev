
# Hook Development for Claude Code Plugins

## Overview

Hooks are event-driven automation that execute in response to Claude Code events — use them to validate operations, enforce policies, add context, and integrate external tools. Claude Code has **28 hook events** (categorized in the [reference table](#hook-events-reference) below).

This overview is the concept map and quick reference; complete per-event input/output schemas live in **`references/event-schemas.md`**, per-event matcher values in `references/advanced.md` (Event-Specific Matchers).

## Hook Types

Five hook types are available. Not all events support all types (see the [event reference table](#hook-events-reference)).

| Type       | Best for                                                        | Notes                                                                 |
| ---------- | --------------------------------------------------------------- | --------------------------------------------------------------------- |
| `prompt`   | Context-aware, flexible validation (recommended default)        | LLM-driven; supports `model` and `timeout`                            |
| `agent`    | Multi-step verification needing tool access                     | Reads files, runs commands; higher cost/latency, so best on decision-control events |
| `command`  | Fast deterministic checks, file ops, external tool integration  | Runs a bash command; the only type supporting `async`                 |
| `mcp_tool` | Validation via MCP tools without agent overhead (CC 2.1.118)    | `server` + `tool`; same event support as command                      |
| `http`     | External service integration, logging, webhooks                 | Posts event data to `url`; non-2xx treated as non-blocking            |

**Event support:** Prompt/agent/HTTP work on most events; SessionStart, PostSession, and WorktreeRemove are command-only; WorktreeCreate is command + HTTP. Prompt and agent hooks return the standard hook output JSON, adding `hookSpecificOutput` for event-specific behavior (PreToolUse, PermissionRequest, Elicitation).

## Configuration Formats

**Plugin hooks** in `hooks/hooks.json` use a required `hooks` wrapper: `{"description": "...(optional)", "hooks": {"PreToolUse": [...], "Stop": [...]}}`.

**User settings** in `.claude/settings.json` place events directly inside the settings `"hooks"` key with no wrapper.

Each event holds matcher groups; each group holds hook entries. An entry has a `type` plus type-specific fields (`command`/`args`, `url`/`headers`/`allowedEnvVars`, `prompt`/`model`) and shared options:

- `args`: exec-form spawning (CC 2.1.139) — the command runs without shell interpolation and `command` becomes the executable path.
- `if`: conditional execution using permission rule syntax, e.g. `Bash(git *)` fires only for git commands (CC 2.1.85). Combines with `matcher` (matcher selects the event, `if` filters within it). See `references/advanced.md` for compound-command handling (CC 2.1.88) and tool-parameter matching like `Agent(model:opus)` (CC 2.1.178).
- `timeout` (defaults: command/http/mcp_tool 600s, prompt 30s, agent 60s; UserPromptSubmit and MessageDisplay lower the 600s types to 30s/10s), `statusMessage` (UI text while running), `once` (run once per session), `async` (fire-and-forget, command hooks only). Full entry schema: `references/advanced.md` (Handler Configuration Fields).

**Scoped hooks in frontmatter:** Skills and agents can declare `hooks:` in YAML frontmatter (events `PreToolUse`, `PostToolUse`, `Stop`), lifecycle-bound to run only while the skill/agent is active. **Caveat:** `${CLAUDE_PLUGIN_ROOT}` resolves only under plugin discovery; agents loaded via the `--agent` CLI flag see it unbound — use `${CLAUDE_PROJECT_DIR}` with a project-relative path. Full diagnostic and related issues: `references/advanced.md` (Scoped Hooks section).

## Hook Output

Standard output (all fields optional):

```json
{
  "continue": true,
  "stopReason": "Why processing should halt",
  "suppressOutput": false,
  "decision": "block",
  "reason": "Feedback for Claude when blocking",
  "systemMessage": "Warning shown to user",
  "terminalSequence": "\u001b]9;Task completed\u0007",
  "hookSpecificOutput": { "hookEventName": "PreToolUse", "additionalContext": "Extra context for Claude" }
}
```

All fields optional. `continue` (default true) halts processing when false and displays `stopReason`; `suppressOutput` (default false) hides output from the transcript; `decision: "block"` blocks with the required `reason` fed back to Claude; `systemMessage` warns the user; `hookSpecificOutput` carries event-specific fields (`references/event-schemas.md`).

- `terminalSequence` (CC 2.1.141): escape sequence written directly to the terminal for desktop notifications, window titles, or bells — e.g. desktop notification `"\u001b]9;Message\u0007"`, window title `"\u001b]0;Title\u0007"`, bell `"\u0007"`.

Exit codes:

| Code  | Behavior                                       |
| ----- | ---------------------------------------------- |
| 0     | Success. JSON on stdout parsed if present      |
| 2     | Blocking error. stderr fed to Claude/user      |
| Other | Non-blocking. Shown in verbose/debug mode only |

Async command hooks (`"async": true`) cannot block (exit 2 ignored) or return decisions — useful for logging, metrics, and notifications. See `references/advanced.md`.

## Hook Input

All hooks receive JSON via stdin with common fields:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/working/dir",
  "hook_event_name": "PreToolUse",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions"
}
```

Inside a subagent, `agent_id` and `agent_type` are also present. Event-specific fields vary — per-event and per-tool input fields are in `references/hook-input-schemas.md`; complete schemas in `references/event-schemas.md`. Prompt hooks access input via `$TOOL_INPUT`, `$TOOL_NAME`, `$USER_PROMPT`, etc.

**Environment variables** in command hooks:

- `$CLAUDE_PROJECT_DIR` — project root path.
- `$CLAUDE_PLUGIN_ROOT` — plugin directory; use for portable paths. Loader-bound in frontmatter hooks (see the Scoped hooks caveat above).
- `$CLAUDE_ENV_FILE` — write `export VAR=value` lines to persist env vars (SessionStart, CwdChanged, FileChanged).
- `$CLAUDE_CODE_REMOTE` — set if running in remote context.
- `$CLAUDE_CODE_SESSION_ID` — current session identifier (CC 2.1.132), for correlating events.
- `$CLAUDE_EFFORT` — current effort level (CC 2.1.133); also in hook input JSON as `effort.level`.
- `$TMPDIR` — sandbox-writable temp directory. **CC 2.1.154:** set to the same sandbox-writable directory for both sandboxed and unsandboxed Bash commands, so scripts can rely on it regardless of sandbox mode.

**Windows PowerShell (CC 2.1.126):** When the PowerShell tool is enabled on Windows, Claude treats PowerShell as the primary shell, so Bash-specific hook scripts may not run — consider cross-platform implementations.

## Matchers

Matchers filter which hooks run for an event; each event defines the values it accepts. An entry without a `matcher` matches all occurrences.

**Tool-name matching** (PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure) uses full regex, case-sensitive — not glob: exact `"Write"`, OR `"Read|Write|Edit"`, patterns like `"mcp__.*__delete.*"`. MCP tools appear as `mcp__<server>__<tool>`.

- **Hyphenated matchers require exact matches (CC 2.1.195, breaking change).** Matchers with hyphens (e.g. `code-reviewer`, `mcp__brave-search`) no longer substring-match — use a wildcard for partial matches: `"mcp__brave-search__.*"`. Affects custom agent names, MCP server names, and any hyphenated identifier.
- **Use pipe, not comma, for multiple matchers (CC 2.1.191).** Comma-separated matchers silently never fired before CC 2.1.191. Correct: `"Bash|PowerShell"`. Wrong: `"Bash,PowerShell"`.
- **Single-segment `dir/**` conditions now match only `<cwd>/dir` (CC 2.1.214, breaking change).** Hook `if:` conditions using patterns like `dir/**` now match only the immediate directory under cwd. Use `**/dir/**` for any-depth matching. This may break existing hooks that relied on the previous broader matching behavior.

Other events match on source/category values, agent type names, MCP server name, or pipe-separated basenames; several events (UserPromptSubmit, Stop, and others) ignore `matcher` entirely. Per-event matcher values are documented in `references/event-schemas.md` and `references/advanced.md` (Event-Specific Matchers).

## Hook Events Reference

Category, decision control, and hook types for all 28 events. "All" = Command, HTTP, Prompt, Agent. Full schemas: `references/event-schemas.md`; per-event matcher values: `references/advanced.md` (Event-Specific Matchers).

| Event                  | Category    | Decision control                   | Types         |
| ---------------------- | ----------- | ---------------------------------- | ------------- |
| SessionStart           | Lifecycle   | continue, env vars                 | Command       |
| InstructionsLoaded     | Lifecycle   | None (observability)               | All           |
| SessionEnd             | Lifecycle   | None (observability)               | All           |
| PostSession            | Lifecycle   | None (cleanup only)                | Command       |
| UserPromptSubmit       | Input       | Block prompt                       | All           |
| PreToolUse             | Tool        | Allow/deny/ask/defer, modify input | All           |
| PermissionRequest      | Tool        | Allow/deny, modify input           | All           |
| PermissionDenied       | Tool        | Request retry                      | All           |
| PostToolUse            | Tool        | Block, modify tool output          | All           |
| PostToolUseFailure     | Tool        | Context injection                  | All           |
| Stop                   | Turn        | Block stop                         | All           |
| StopFailure            | Turn        | None (observability)               | All           |
| SubagentStart          | Subagent    | Context injection                  | All           |
| SubagentStop           | Subagent    | Block stop                         | All           |
| TeammateIdle           | Teams       | Reject idle (exit 2), stop         | All           |
| TaskCompleted          | Teams       | Reject completion (exit 2)         | All           |
| PreCompact             | Context     | Block compaction (exit 2)          | All           |
| PostCompact            | Context     | None (observability)               | All           |
| ConfigChange           | Config      | Block (except policy)              | All           |
| CwdChanged             | Environment | None (env vars, watchPaths)        | All           |
| FileChanged            | Environment | None (env vars, watchPaths)        | All           |
| WorktreeCreate         | Worktree    | Return path, exit code             | Command, HTTP |
| WorktreeRemove         | Worktree    | None (cleanup)                     | Command       |
| Elicitation            | MCP         | Accept/decline/cancel              | All           |
| ElicitationResult      | MCP         | Override response                  | All           |
| MessageDisplay         | Display     | Display content replacement        | All           |
| Notification           | Notification| None (observability)               | All           |
| BackgroundTasksChanged | Background  | None (observability)               | All           |

## Configuration Locations

| Location                      | Scope          | Shareable            |
| ----------------------------- | -------------- | -------------------- |
| `~/.claude/settings.json`     | All projects   | No                   |
| `.claude/settings.json`       | Single project | Yes (commit to repo) |
| `.claude/settings.local.json` | Single project | No                   |
| Managed policy settings       | Organization   | Yes (admin-managed)  |
| Plugin `hooks/hooks.json`     | Plugin-scoped  | Yes (with plugin)    |

Plugin hooks merge with user hooks and run in parallel. Duplicates are deduplicated (command hooks by command string, HTTP hooks by URL). `disableAllHooks` cannot disable managed policy hooks.

## Performance

All matching hooks run **in parallel** — they don't see each other's output and ordering is non-deterministic, so design them to be independent. Use command hooks for quick checks, prompt hooks for complex reasoning, cache results in temp files, `async: true` for logging, and `once: true` for one-time setup. See `references/advanced.md` for caching, hook-chaining-via-state, and parallel-optimization patterns.

## Security

**Shell-injection prevention (CC 2.1.207):** `${user_config.*}` interpolation in shell-form hook commands is now rejected to prevent injection when user-configurable plugin options contain malicious input. Fix by using exec form (`args` array) or reading values inside the script via `$CLAUDE_PLUGIN_OPTION_<KEY>`; the same restriction applies to monitors and headersHelper. Full migration guidance: `references/advanced.md` (Security Patterns).

Other essentials: validate inputs, block path traversal (`..`) and sensitive files (`.env`), quote every variable, set appropriate timeouts. Examples: `examples/validate-write.sh`, `examples/validate-bash.sh`.

## Lifecycle, Limitations, and Debugging

**Hooks load at session start and cannot be hot-swapped.** Editing `hooks/hooks.json` or adding scripts has no effect on the current session — exit and restart `claude`. Hooks are validated at startup (invalid JSON fails loading, missing scripts warn, syntax errors show in debug mode). Use `/hooks` to review loaded hooks.

Debug with `claude --debug` (shows registration, execution logs, input/output JSON, timing). Test command hooks by piping sample JSON on stdin (`echo '{...}' | bash script.sh`) and validating output with `jq`.

## Critical Gotchas

1. **No "Setup" event.** Use `SessionStart` with matcher `startup` for initialization.
2. **Shell profile noise breaks JSON parsing.** If `.bashrc`/`.zshrc` prints to stdout it contaminates output — redirect profile output to stderr.
3. **SessionEnd has a 1.5 second timeout.** Set `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` for longer cleanup.
4. **Duplicate hooks are deduplicated.** Command hooks by command string, HTTP hooks by URL.
5. **PreToolUse deprecated fields.** Old `decision: "approve|block"` replaced by `hookSpecificOutput.permissionDecision`.
6. **Policy settings cannot be blocked.** ConfigChange for `policy_settings` silently ignores block decisions.
7. **Async hooks cannot block.** Exit code 2 is ignored for `async: true` hooks.
8. **Subagent Stop hooks auto-convert.** Stop hooks in subagent context become SubagentStop.
9. **HTTP hooks need 2xx for decisions.** Non-2xx status codes are treated as non-blocking errors.
10. **`disableAllHooks` cannot disable managed hooks.** Policy-managed hooks always run.
11. **`${CLAUDE_PLUGIN_ROOT}` is loader-bound in frontmatter hooks.** Resolves only under plugin discovery; agents loaded via `--agent` see it unbound — use `${CLAUDE_PROJECT_DIR}`. Full caveat: `references/advanced.md` (Scoped Hooks section).

## References and Examples

| Reference                          | When to read                                                                                          |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `references/event-schemas.md`      | Need the exact input/output JSON or version notes for a specific event; SDK parity (matcher values: `advanced.md`) |
| `references/hook-input-schemas.md` | Need per-event input fields or the `tool_input` schema for a specific tool (Bash, Write, Edit, etc.)  |
| `references/advanced.md`           | Multi-stage validation, full hook-entry schema, `if`/agent/async/scoped hooks, `${CLAUDE_PLUGIN_ROOT}` loader caveat, security patterns, shell-injection migration |
| `references/patterns.md`           | Ready-made pattern for a common goal (security validation, test enforcement, worktree mgmt, elicitation, config auditing) |
| `references/migration.md`          | Converting command hooks to prompt hooks, or when to keep command hooks                               |
| `examples/validate-write.sh`       | PreToolUse file write validation                                                                      |
| `examples/validate-bash.sh`        | PreToolUse bash command validation                                                                    |
| `examples/load-context.sh`         | SessionStart context loading and `$CLAUDE_ENV_FILE` usage                                             |
| `examples/stop-failure-alert.sh`   | StopFailure API error alerting                                                                        |
| `examples/validate-task.sh`        | TaskCompleted deliverable verification                                                                |
| `examples/teammate-quality-gate.sh`| TeammateIdle quality gate                                                                             |
| `examples/create-worktree.sh`      | WorktreeCreate custom worktree setup                                                                  |
| `examples/cleanup-worktree.sh`     | WorktreeRemove resource cleanup                                                                        |
| `examples/audit-config-change.sh`  | ConfigChange security monitoring                                                                      |
| `examples/handle-elicitation.sh`   | Elicitation auto-response                                                                              |
| `examples/log-observability.sh`    | Unified logging for InstructionsLoaded, PreCompact, PostCompact, Notification                         |
| `scripts/validate-hook-schema.sh`  | Validate `hooks.json` structure and syntax                                                             |
| `scripts/test-hook.sh`             | Test a hook with sample input before deployment                                                       |
| `scripts/hook-linter.sh`           | Check hook scripts for common issues and best practices                                               |

> **Note:** After copying example scripts, make them executable (`chmod +x`). Utility scripts require `jq`. Official docs: <https://code.claude.com/docs/en/hooks>.

## Implementation Workflow

Identify the events to hook into (see the table above) and choose a hook type. Write the configuration in `hooks/hooks.json` (plugin wrapper format), and for command hooks create scripts using `${CLAUDE_PLUGIN_ROOT}` for file references. Validate with `scripts/validate-hook-schema.sh`, test with `scripts/test-hook.sh` and `claude --debug` before deployment, then document the hooks in the plugin README.
