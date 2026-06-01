# Claude Code Compatibility

Last audited: Claude Code 2.1.159 (2026-06-01)
Plugin-dev version: 0.20.1

## Audit Log

| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.20.1 | 2.1.159 | 2026-06-01 | Internal infrastructure improvements only — no plugin-system changes |
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
