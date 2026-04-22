# Claude Code Compatibility

Last audited: Claude Code 2.1.117 (2026-04-22)
Plugin-dev version: 0.11.2

## Audit Log

| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.11.2 | 2.1.115-2.1.117 | 2026-04-22 | Agent frontmatter mcpServers/hooks fire with --agent, background job behavior guidance, SendMessageTool attachments format, plugin install dependency handling, auto-update dependency install |
| v0.11.1 | 2.1.111-2.1.114 | 2026-04-19 | Skill tool strict invocation rules, memory synthesis retrieval-only directive, Bash cd+git guidance, /skills token sort |
| v0.10.3 | 2.1.99-2.1.110 | 2026-04-16 | Allowed-tools syntax change (colon to space), PreCompact hook blocking capability, monitors manifest key |
| v0.10.2 | 2.1.94-2.1.98 | 2026-04-10 | Monitor tool for background events, agent absolute path requirement, skill invocation name change, plugin skill hook/CLAUDE_PLUGIN_ROOT fixes |
| v0.10.0 | 2.1.89-2.1.92 | 2026-04-04 | PreToolUse `defer` decision, MCP maxResultSizeChars (500K), disableSkillShellExecution setting, plugin bin/ directory |
| v0.9.0 | 2.1.87-2.1.88 | 2026-03-31 | PermissionDenied hook (25th event), file_path absolute paths, `if` compound command fix, partial compaction, Config tool |
| v0.8.0 | 2.1.85-2.1.86 | 2026-03-29 | Hook `if` field, AskUserQuestion via updatedInput, skill 250-char cap, alphabetical /skills, org plugin blocking, MCP env vars, agent prompt change, fork naming, Production Reads |
| v0.5.0 | ≤2.1.84 | 2026-03-27 | Initial compatibility baseline (initialPrompt, CwdChanged, FileChanged, userConfig, paths) |
