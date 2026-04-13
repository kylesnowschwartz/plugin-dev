# Claude Code Compatibility

Last audited: Claude Code 2.1.104 (2026-04-13)
Plugin-dev version: 0.10.3

## Audit Log

| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.10.3 | 2.1.99-2.1.104 | 2026-04-13 | Fork output restriction change, hook resilience/enterprise fixes, skill context:fork fix, subagent MCP inheritance fix, worktree access fix, permissions.deny override fix |
| v0.10.2 | 2.1.94-2.1.98 | 2026-04-10 | Monitor tool for background events, agent absolute path requirement, skill invocation name change, plugin skill hook/CLAUDE_PLUGIN_ROOT fixes |
| v0.10.0 | 2.1.89-2.1.92 | 2026-04-04 | PreToolUse `defer` decision, MCP maxResultSizeChars (500K), disableSkillShellExecution setting, plugin bin/ directory |
| v0.9.0 | 2.1.87-2.1.88 | 2026-03-31 | PermissionDenied hook (25th event), file_path absolute paths, `if` compound command fix, partial compaction, Config tool |
| v0.8.0 | 2.1.85-2.1.86 | 2026-03-29 | Hook `if` field, AskUserQuestion via updatedInput, skill 250-char cap, alphabetical /skills, org plugin blocking, MCP env vars, agent prompt change, fork naming, Production Reads |
| v0.5.0 | ≤2.1.84 | 2026-03-27 | Initial compatibility baseline (initialPrompt, CwdChanged, FileChanged, userConfig, paths) |
