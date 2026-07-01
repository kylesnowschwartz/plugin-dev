# Claude Code Compatibility

Last audited: Claude Code 2.1.197 (2026-07-01)
Plugin-dev version: 0.26.0

## Audit Log

| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.26.0 | 2.1.196-2.1.197 | 2026-07-01 | Claude Sonnet 5 as default model with 1M-token context (CC 2.1.197), Invoke skill tool for programmatic skill loading (CC 2.1.196), SendUserFile `display` parameter for inline/attachment rendering (CC 2.1.196) |
| v0.25.0 | 2.1.184-2.1.195 | 2026-06-28 | **Breaking:** Hook matchers with hyphens now require exact matches (CC 2.1.195), comma-separated matchers fix (CC 2.1.191). External plugins via project settings no longer re-prompt (CC 2.1.195), `autoMode.classifyAllShell` setting (CC 2.1.193), `sandbox.credentials` setting (CC 2.1.187), `claude mcp login/logout` commands (CC 2.1.186), Monitor tool WebSocket source (CC 2.1.195), Agent(type) deny rules enforcement (CC 2.1.186), skill frontmatter case acceptance (CC 2.1.186), MCP headersHelper auth retry (CC 2.1.193), plugin auto-rename with marketplace mapping (CC 2.1.193), ReadMcpResourceDirTool (CC 2.1.186) |
| v0.24.0 | 2.1.179-2.1.183 | 2026-06-19 | `/config key=value` command syntax, `tool_use_meta` MCP display metadata field, auto mode blocked commands (git stash/restore/clean, terraform destroy), read-only authorization inheritance |
| v0.23.0 | 2.1.177-2.1.178 | 2026-06-16 | Tool parameter matching syntax (`Agent(model:opus)`), nested skill directories with collision handling, directory-scoped skills (`apps/web:deploy`), agent `isolation: "remote"` option, Workflow `effort` option, SendMessageTool `"main"` recipient, nested `.claude/` directory precedence, TeamDelete/TeammateTool removed |
| v0.22.0 | 2.1.171-2.1.176 | 2026-06-13 | Fork `subagent_type: "fork"` explicit requirement, sub-agent 5-level nesting capability, skill hot-reload optimization (only changed skills re-announced) |
| v0.21.0 | 2.1.163-2.1.170 | 2026-06-10 | `/cd` command, `--safe-mode` flag, PostSession hook, `requiredMinimumVersion`/`requiredMaximumVersion` settings, `/plugin list` command, worker fork no-subagent rule, autonomous operation guidelines, background worktree isolation, cross-session peer message security, Cowork plugin schemas, Workflow 4096 item limit, Browser file upload tool, `disableBundledSkills` setting, MCP policy enforcement fix, Stop/SubagentStop `additionalContext`, `\$` escape syntax, `CLAUDE_CODE_SESSION_ID` on resume |
| v0.20.1 | 2.1.159-2.1.162 | 2026-06-04 | LSP `workspaceSymbol` query parameter guidance, NotebookEdit `cell_id` parameter and read-before-edit requirement |
| v0.20.0 | 2.1.157-2.1.158 | 2026-05-31 | `claude plugin init <name>` scaffolding command, automatic `.claude/skills` loading without marketplace, EnterWorktree mid-session switching, settings.json `agent` field honored for dispatched sessions |
| v0.19.0 | 2.1.154-2.1.156 | 2026-05-28 | Plugin `defaultEnabled: false` option, background session `$CLAUDE_JOB_DIR/tmp` path, AskUserQuestion tightened guidance, Bash `$TMPDIR` sandbox clarification, directory-aware plugin suggestions, MCP server `CLAUDE_CODE_SESSION_ID`/`CLAUDECODE=1` env vars |
| v0.17.0 | 2.1.145-2.1.153 | 2026-05-28 | MessageDisplay hook (26th event), SessionStart `reloadSkills`/`sessionTitle` outputs, `/reload-skills` command, `disallowed-tools` frontmatter, `skipLfs` marketplace option, MCP policy enforcement for subagent frontmatter, `--strict-mcp-config` behavior change, Agent tool autocomplete, multiple `Agent(...)` types fix |
| v0.16.1 | 2.1.144 | 2026-05-19 | Bug fixes only — no plugin-system changes |
| v0.16.0 | 2.1.139-2.1.143 | 2026-05-16 | SendUserFile tool, Agent tool usage notes, Self-Modification protected paths, `worktree.bgIsolation` setting, hook `args` field, `continueOnBlock` for PostToolUse, `terminalSequence` output, Stop hook `impossible` response + 8-block cap |
| v0.15.0 | 2.1.133-2.1.138 | 2026-05-10 | `effort.level` hook input + `$CLAUDE_EFFORT` env var, `worktree.baseRef` setting, subagent skill discovery fix, Bash tool dedicated tools guidance |
| v0.14.0 | 2.1.127-2.1.132 | 2026-05-07 | `--plugin-url` flag, `--plugin-dir` accepts .zip, `themes`/`monitors` under `experimental` key, `skillOverrides` setting, MCP `workspace` reserved name, `CLAUDE_CODE_SESSION_ID` env var, `CLAUDE_CODE_LOOP_PERSISTENT` guidance, background job agent built-in instructions |
| v0.13.1 | 2.1.122-2.1.126 | 2026-05-01 | `claude project purge` command, file modification budget-exceeded reminder, deferred tools fix for `context:fork` skills, PowerShell primary shell on Windows |
| v0.13.0 | 2.1.121 | 2026-04-28 | MCP `alwaysLoad` option, `claude plugin prune` command, PostToolUse `updatedToolOutput` for any tool, `CLAUDE_CODE_FORK_SUBAGENT=1` for headless subagents, MCP auto-retry on transient errors |
| v0.12.0 | 2.1.118-2.1.120 | 2026-04-25 | Hooks `type: mcp_tool`, hook `duration_ms` input, print mode frontmatter enforcement, Config tool removed, auto mode `$defaults`, previously invoked skills compaction, plugin version constraint auto-update, agent `--agent` honors permissionMode |
| v0.11.2 | 2.1.115-2.1.117 | 2026-04-22 | Agent frontmatter mcpServers/hooks fire with --agent, background job behavior guidance, SendMessageTool attachments format, plugin install dependency handling, auto-update dependency install |
| v0.11.1 | 2.1.111-2.1.114 | 2026-04-19 | Skill tool strict invocation rules, memory synthesis retrieval-only directive, Bash cd+git guidance, /skills token sort |
| v0.10.3 | 2.1.99-2.1.110 | 2026-04-16 | Allowed-tools syntax change (colon to space), PreCompact hook blocking capability, monitors manifest key |
| v0.10.2 | 2.1.94-2.1.98 | 2026-04-10 | Monitor tool for background events, agent absolute path requirement, skill invocation name change, plugin skill hook/CLAUDE_PLUGIN_ROOT fixes |
| v0.10.0 | 2.1.89-2.1.92 | 2026-04-04 | PreToolUse `defer` decision, MCP maxResultSizeChars (500K), disableSkillShellExecution setting, plugin bin/ directory |
| v0.9.0 | 2.1.87-2.1.88 | 2026-03-31 | PermissionDenied hook (25th event), file_path absolute paths, `if` compound command fix, partial compaction, Config tool |
| v0.8.0 | 2.1.85-2.1.86 | 2026-03-29 | Hook `if` field, AskUserQuestion via updatedInput, skill 250-char cap, alphabetical /skills, org plugin blocking, MCP env vars, agent prompt change, fork naming, Production Reads |
| v0.5.0 | ≤2.1.84 | 2026-03-27 | Initial compatibility baseline (initialPrompt, CwdChanged, FileChanged, userConfig, paths) |
