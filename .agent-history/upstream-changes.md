# Upstream Change Manifest
## CC Version Range: 2.1.145 - 2.1.153
## Generated: 2026-05-28
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped]

Note: The claude-code-guide subagent dispatch did not return output. Triangulation is based on CC changelog + system-prompts changelog + official documentation fetch. Official docs were successfully queried for skills, hooks, and plugins references.

---

### Must Update

- [ ] **Skills: `disallowed-tools` frontmatter field** (CC 2.1.152)
  - Source: CC changelog, official docs (skills page)
  - Confidence: high
  - Affects: plugin-development skill (frontmatter reference section)
  - Details: Skills and slash commands can now set `disallowed-tools` in frontmatter to remove tools from the model's available pool while the skill is active. Use for autonomous skills that should never call certain tools (e.g., `AskUserQuestion` for background loops). Accepts space/comma-separated string or YAML list. The restriction clears when the user sends their next message.
  - Raw changelog: "Skills and slash commands can now set `disallowed-tools` in frontmatter to remove tools from the model"

- [ ] **New command: `/reload-skills`** (CC 2.1.152)
  - Source: CC changelog, official docs (skills page mentions "run `/reload-skills` to pick up the updates")
  - Confidence: high
  - Affects: plugin-development skill (commands section)
  - Details: Added `/reload-skills` command to re-scan skill directories without restarting session. Useful during skill development.
  - Raw changelog: "Added `/reload-skills` command to re-scan skill directories without restarting session"

- [ ] **SessionStart hook: `reloadSkills` return value** (CC 2.1.152)
  - Source: CC changelog, official docs (hooks page - confirmed with schema)
  - Confidence: high
  - Affects: plugin-development skill (hooks section)
  - Details: SessionStart hooks can now return `reloadSkills: true` in `hookSpecificOutput` to trigger skill directory re-scanning. Useful when a hook installs or updates skills at session start.
  - Raw changelog: "`SessionStart` hooks can now return `reloadSkills: true` to re-scan skill directories"

- [ ] **SessionStart hook: `sessionTitle` output** (CC 2.1.152)
  - Source: CC changelog, official docs (hooks page - confirmed with schema)
  - Confidence: high
  - Affects: plugin-development skill (hooks section)
  - Details: SessionStart hooks can now set session title via `hookSpecificOutput.sessionTitle` on startup and resume. Only applies when `source` is `"startup"` or `"resume"`, ignored on `"clear"` and `"compact"`.
  - Raw changelog: "`SessionStart` hooks can now set session title via `hookSpecificOutput.sessionTitle` on startup and resume"

- [ ] **New hook event: `MessageDisplay`** (CC 2.1.152)
  - Source: CC changelog, official docs (hooks page lists it as event #12)
  - Confidence: high
  - Affects: plugin-development skill (hooks section)
  - Details: Added `MessageDisplay` hook event that fires while assistant message text streams. Display-only hook with `displayContent` decision field that can replace displayed text on screen (display-only; transcript and what Claude sees retain the original). No matcher support. Cannot block. Use for logging, observability, or customizing message display.
  - Raw changelog: "Added `MessageDisplay` hook event that lets hooks transform or hide assistant message text as displayed"

- [ ] **Workflow tool: renamed opt-in keyword** (CC 2.1.153)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: plugin-development skill (possibly Workflow tool documentation)
  - Details: The explicit opt-in keyword for the Workflow tool was renamed from `ultrawork` to `workflow`. Also adds exhaustive-review guidance for deduping against all seen findings, using perspective-diverse verification, and looping until discovery runs dry.
  - Raw system-prompts: "Tool Description: Workflow -- Renames the explicit opt-in keyword from `ultrawork` to `workflow`"

- [ ] **NEW: Run app skill family** (CC 2.1.145)
  - Source: system-prompts changelog, official docs (skills page documents /run, /verify, /run-skill-generator)
  - Confidence: high
  - Affects: plugin-development skill (bundled skills reference)
  - Details: Added new bundled skills: `/run`, `/verify`, and `/run-skill-generator`. These work together to launch and drive projects' actual runtime surface. `/run-skill-generator` records project-specific recipes that `/run` and `/verify` then follow. Requires CC v2.1.145+.
  - Raw system-prompts: "NEW: Skill: Run app -- Adds a general skill for launching and driving a project's actual runtime surface"

- [ ] **NEW: Coordinator mode system prompts** (CC 2.1.152)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: May affect agent documentation
  - Details: Added coordinator-mode instructions for delegating software engineering work across workers, synthesizing worker results, managing worker lifecycle, handling cross-session peers, and independently verifying delegated changes. Also added worker-agent instructions for coordinator-assigned tasks.
  - Raw system-prompts: "NEW: System Prompt: Coordinator mode orchestration" and "NEW: System Prompt: Coordinator worker instructions"

- [ ] **Plugin marketplace: `skipLfs` option** (CC 2.1.153)
  - Source: CC changelog only
  - Confidence: medium (not found in official docs yet)
  - Affects: plugin-development skill (marketplace sources section)
  - Details: Added `skipLfs` option to `github`/`git` plugin marketplace sources to skip Git LFS downloads during clone and update.
  - Raw changelog: "Added `skipLfs` option to `github`/`git` plugin marketplace sources to skip Git LFS downloads during clone and update"

- [ ] **Subagent frontmatter MCP servers: policy enforcement** (CC 2.1.153)
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-development skill (subagent/agent section)
  - Details: Fixed subagent frontmatter MCP servers ignoring `--strict-mcp-config`, `--bare`, remote mode, and managed MCP config policies. This is a behavioral fix that makes MCP policies consistent.
  - Raw changelog: "Fixed subagent frontmatter MCP servers ignoring `--strict-mcp-config`, `--bare`, remote mode, and managed MCP config policies"

- [ ] **`--strict-mcp-config` behavior change** (CC 2.1.153)
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-development skill (MCP configuration section)
  - Details: `--strict-mcp-config` no longer strips inline `mcpServers` from explicitly-passed agent definitions. This allows agents passed via CLI to retain their MCP server configurations.
  - Raw changelog: "`--strict-mcp-config` no longer strips inline `mcpServers` from explicitly-passed agent definitions"

- [ ] **REMOVED: Simplify skill** (CC 2.1.147)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: plugin-development skill (bundled skills reference)
  - Details: The `/simplify` skill was removed and replaced with `/code-review`. Worker instructions now invoke `code-review` skill instead of `simplify`.
  - Raw system-prompts: "REMOVED: Skill: Simplify -- Removes the code review and cleanup skill"

- [ ] **`/simplify` now invokes `/code-review --fix`** (CC 2.1.152)
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-development skill (bundled skills reference)
  - Details: `/simplify` now invokes `/code-review --fix` for applying review findings.
  - Raw changelog: "`/simplify` now invokes `/code-review --fix`"

- [ ] **NEW: /code-review with --fix and --comment** (CC 2.1.147, enhanced 2.1.152)
  - Source: system-prompts changelog, CC changelog
  - Confidence: high
  - Affects: plugin-development skill (bundled skills reference)
  - Details: Major `/code-review` update with new `--fix` behavior that applies reported review findings to working tree (correctness bugs, reuse, simplification, efficiency cleanups), and `--comment` behavior for posting findings as inline GitHub PR comments. Multiple effort modes (low/medium/high/extra-high/max) with different finder angles.
  - Raw changelog: "`/code-review --fix` now applies review findings to working tree after review"

- [ ] **Auto mode no longer requires opt-in consent** (CC 2.1.152)
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-development skill (auto mode documentation)
  - Details: Auto mode no longer requires explicit opt-in consent dialog. This is a behavioral change for autonomous operation.
  - Raw changelog: "Auto mode no longer requires opt-in consent"

- [ ] **`pluginSuggestionMarketplaces` managed setting** (CC 2.1.152)
  - Source: CC changelog only
  - Confidence: medium (not found in official docs yet)
  - Affects: plugin-development skill (managed settings section)
  - Details: Added `pluginSuggestionMarketplaces` managed setting allowing admins to allowlist org marketplaces whose plugins may be suggested.
  - Raw changelog: "Added `pluginSuggestionMarketplaces` managed setting: admins can allowlist org marketplaces whose plugins may be suggested"

- [ ] **Plugin agents declaring multiple `Agent(...)` types** (CC 2.1.147) [STAGE 2 ADDITION]
  - Source: CC changelog
  - Confidence: high
  - Affects: agent-development skill (tools frontmatter section)
  - Details: Fixed plugin agents declaring multiple `Agent(...)` types in `tools:` frontmatter now correctly retain all entries instead of dropping all but the last. Affects agents that need to declare they can spawn multiple agent types.
  - Raw changelog: "Fixed plugin agents declaring multiple `Agent(...)` types in `tools:` frontmatter now retain all entries instead of dropping all but the last"

- [ ] **Agent tool autocomplete suggests skills** (CC 2.1.153) [PROMOTED from May Update]
  - Source: CC changelog
  - Confidence: high
  - Affects: agent-development skill (dispatch/invocation section)
  - Details: `claude agents` autocomplete in the dispatch input now suggests native slash commands and bundled skills, not just project skills.
  - Raw changelog: "`claude agents`: autocomplete in the dispatch input now suggests native slash commands and bundled skills"

---

### May Update

- [ ] **`/model` saves selection as default** (CC 2.1.153)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (commands)
  - Details: `/model` now saves selection as default for new sessions. Press `s` in picker to switch for current session only. If customized `modelPicker:setAsDefault` keybinding, rename to `modelPicker:thisSessionOnly`.
  - Raw changelog: "`/model` now saves selection as default for new sessions"

- [ ] **`/bg` continues response in background** (CC 2.1.153)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (commands)
  - Details: `/bg` while Claude is responding now continues response in background session instead of dropping it.
  - Raw changelog: "`/bg` while Claude is responding now continues response in background session instead of dropping it"

- [ ] **Agent tool autocomplete suggests skills** (CC 2.1.153) [PROMOTED to Must Update - see above]
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (agents)
  - Details: `claude agents` autocomplete in the dispatch input now suggests native slash commands and bundled skills.
  - Raw changelog: "`claude agents`: autocomplete in the dispatch input now suggests native slash commands and bundled skills"

- [ ] **Status line receives COLUMNS/LINES env vars** (CC 2.1.153)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (status line)
  - Details: Status line commands now receive `COLUMNS` and `LINES` environment variables for terminal-aware output sizing.
  - Raw changelog: "Status line commands now receive `COLUMNS` and `LINES` environment variables for terminal-aware output sizing"

- [ ] **`claude plugin marketplace remove` scope flag** (CC 2.1.152)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (CLI commands)
  - Details: `claude plugin marketplace remove` now accepts `--scope user|project|local` for symmetry with other commands.
  - Raw changelog: "`claude plugin marketplace remove` now accepts `--scope user|project|local` for symmetry with other commands"

- [ ] **`/usage` per-category breakdown** (CC 2.1.149)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (commands)
  - Details: `/usage` now shows per-category breakdown: skills, subagents, plugins, and per-MCP-server cost. Also includes large session files with streaming read.
  - Raw changelog: "`/usage` now shows per-category breakdown: skills, subagents, plugins, and per-MCP-server cost"

- [ ] **Workflow tool expanded guidance** (CC 2.1.149, 2.1.152)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: Reference documentation (tools)
  - Details: Workflow tool expanded with: using workflows to decompose broad work, scouting inline before orchestration, multi-modal sweeps, completeness critics, chaining scoped workflows across turns, MCP tool access via ToolSearch.
  - Raw system-prompts: "Tool Description: Workflow -- Adds framing for using workflows to decompose broad work"

- [ ] **Fallback model support** (CC 2.1.152)
  - Source: CC changelog
  - Confidence: high
  - Affects: Reference documentation (configuration)
  - Details: Claude Code now switches to configured `--fallback-model` for session when primary model is not found.
  - Raw changelog: "Claude Code now switches to configured `--fallback-model` for session when primary model is not found"

- [ ] **REMOVED: Thinking frequency tuning reminder** (CC 2.1.153) [DEMOTED to No Action]
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: System prompt reference (if documented)
  - Details: Removed the system reminder that treated harness-added `<system-reminder>` messages as thinking-frequency instructions.
  - Raw system-prompts: "REMOVED: System Reminder: Thinking frequency tuning"
  - Stage 2 note: Internal system prompt change, no plugin API impact.

- [ ] **REMOVED: Iterative plan mode reminder** (CC 2.1.145) [DEMOTED to No Action]
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: System prompt reference (if documented)
  - Details: Removed the iterative plan-mode reminder that told agents to maintain a plan file while repeatedly exploring, updating the plan, and asking questions before exiting plan mode.
  - Raw system-prompts: "REMOVED: System Reminder: Plan mode is active (iterative)"
  - Stage 2 note: Internal system prompt change, no plugin API impact.

- [ ] **NEW: Phase four of plan mode** (CC 2.1.146) [DEMOTED to No Action]
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: System prompt reference (if documented)
  - Details: Added final-plan guidance requiring context, single recommended approach, critical files and reusable utilities, concise executable detail, and end-to-end verification steps.
  - Raw system-prompts: "NEW: System Prompt: Phase four of plan mode"
  - Stage 2 note: Internal system prompt change, no plugin API impact.

- [ ] **Security monitor updates** (CC 2.1.146, 2.1.147) [DEMOTED to No Action]
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: Security documentation (if documented)
  - Details: Updated security monitor with hard_deny category, explicit agent-config path list for Self-Modification rule, auto-mode bypass hard block. Files under `.claude/worktrees/<name>/` now treated as ordinary project files.
  - Raw system-prompts: "Agent Prompt: Security monitor for autonomous agent actions"
  - Stage 2 note: Internal security enforcement, no plugin API impact.

---

### No Action

- Fixed stateful MCP servers without optional GET SSE stream reconnect-looping on `tools/list` (CC 2.1.153) - MCP implementation fix
- Fixed custom API gateway receiving user's Anthropic OAuth credential instead of gateway's own token (CC 2.1.153) - API gateway fix
- Fixed Windows PowerShell installer reporting "Installation complete!" when installation actually failed (CC 2.1.153) - Installer fix
- Fixed `claude update` installing latest version instead of configured release channel's version for npm (CC 2.1.153) - Update mechanism fix
- Fixed excessive memory usage when resuming session by transcript file path (CC 2.1.153) - Performance fix
- Fixed `claude agents` and `claude --bg` running on stale daemon (CC 2.1.153) - Daemon fix
- Fixed hang where CLI could fail to exit when stdin was closed without EOF (CC 2.1.153) - CLI fix
- Fixed malformed `file://` links not being clickable in terminal (CC 2.1.153) - UI fix
- Fixed `claude --help` rendering unwrapped output on narrow terminals (CC 2.1.153) - Help display fix
- Fixed MCP tool progress notifications not rendering in collapsed tool view (CC 2.1.153) - UI fix
- Fixed `Agent` tool with `subagent_type: 'claude'` running in undocumented temporary worktree (CC 2.1.153) - Agent fix
- Multiple background session fixes (CC 2.1.153) - Background session stability
- Fixed Windows update rollback (CC 2.1.153) - Update mechanism fix
- Fixed Claude Code processes not shutting down cleanly on Windows when VS Code closed (CC 2.1.153) - IDE integration fix
- Fixed terminal styling degrading in very long sessions (CC 2.1.152) - UI fix
- Fixed sandbox-enabled warning not appearing in condensed startup mode (CC 2.1.152) - Startup fix
- Fixed loading spinner showing thinking status while tool is running (CC 2.1.152) - UI fix
- Fixed focus mode showing spurious hidden message count (CC 2.1.152) - UI fix
- Fixed clicking link inside expanded tool result collapsing section (CC 2.1.152) - UI fix
- Fixed markdown table cell borders inheriting color of inline code (CC 2.1.152) - UI fix
- Fixed plugin MCP servers with same command but different environment variables being incorrectly deduplicated (CC 2.1.152) - Plugin fix
- Fixed `/doctor` reporting "marketplace not found" for stale entries (CC 2.1.152) - Doctor fix
- Fixed plugins tracking git branch silently no longer receiving updates (CC 2.1.152) - Plugin update fix
- Fixed remote MCP servers failing to connect in Remote sessions when egress proxy enabled (CC 2.1.152) - MCP fix
- Fixed effort-change confirmation dialog appearing when conversation has no messages (CC 2.1.152) - UI fix
- Fixed Agent tool description referencing agent list never delivered with `--bare` (CC 2.1.152) - Documentation fix
- Fixed background worker crash in `claude agents` when accepting stale permission prompt (CC 2.1.152) - Stability fix
- Fixed `cache_creation_input_tokens` reporting as 0 in transcript (CC 2.1.152) - Metrics fix
- Fixed PushNotification tool incorrectly reporting "Mobile push not sent" (CC 2.1.152) - Notification fix
- Fixed sessions getting stuck after model or login switch (CC 2.1.152) - Session fix
- v2.1.150: Internal infrastructure improvements (no user-facing changes)
- Fixed PowerShell permission bypass (CC 2.1.149) - Security fix
- Fixed sandbox write allowlist in git worktrees (CC 2.1.149) - Security fix
- Fixed PowerShell prefix/wildcard allow rules (CC 2.1.149) - Permission fix
- Fixed permission-analysis gap for PWD/OLDPWD/DIRSTACK (CC 2.1.149) - Security fix
- Fixed `find` in Bash tool exhausting macOS system file table (CC 2.1.149) - Performance fix
- Fixed managed-settings approval dialog leaving terminal frozen (CC 2.1.149) - UI fix
- Fixed `/ultraplan` and remote session creation failing (CC 2.1.149) - Feature fix
- Fixed `otelHeadersHelper` failing silently when script path contains spaces (CC 2.1.149) - Telemetry fix
- Multiple UI fixes for spinners, slash-command hints, status bar, transcript view (CC 2.1.149) - UI fixes
- Fixed editing recalled prompt-history entry losing edit (CC 2.1.149) - Input fix
- Fixed `/config` exit summary reporting phantom changes (CC 2.1.149) - Config fix
- Fixed `/insights` crashing when cached session-meta files missing fields (CC 2.1.149) - Crash fix
- Fixed malformed PowerShell and History tool calls being misclassified (CC 2.1.149) - Classification fix
- Fixed renaming Remote Control session not updating local session name (CC 2.1.149) - Remote fix
- Fixed race where just-submitted prompt could appear twice in history (CC 2.1.149) - History fix
- Improved `/feedback` reports to include conversation before context compaction (CC 2.1.149) - Feedback improvement
- Fixed Bash tool returning exit code 127 on every command (CC 2.1.148) - Regression fix
- macOS: background agents now appear as "Claude Code" in Privacy & Security (CC 2.1.153) - macOS integration
- Combined separate authentication notifications for MCP servers and connectors (CC 2.1.153) - UX improvement
- Thinking summaries improvements (CC 2.1.152) - UI enhancement
- Simplified Workflow tool's inline progress display (CC 2.1.152) - UI enhancement
- Post-response timer shows background agent/workflow status (CC 2.1.152) - UI enhancement
- Added session entrypoint as OpenTelemetry metric attribute (CC 2.1.152) - Telemetry
- Vim mode: `/` in NORMAL mode opens reverse history search (CC 2.1.152) - Vim mode enhancement
- In fullscreen mode, thinking indicator counts up live (CC 2.1.152) - UI enhancement
- Markdown output now renders GFM task list checkboxes (CC 2.1.149) - Markdown rendering
- `/diff` detail view can now be scrolled with keyboard (CC 2.1.149) - UI enhancement
- Enterprise: added `allowAllClaudeAiMcps` managed setting (CC 2.1.149) - Enterprise feature
- `claude doctor` now shows the result of your last update attempt (CC 2.1.153) - Doctor enhancement

---

## Summary

**Version Range:** 2.1.145 - 2.1.153 (9 versions since last audit at 2.1.144)

**Total Changes Analyzed:** 100+ items from CC changelog and system-prompts

**Must Update: 18 items** (Stage 2 corrected: +2 from Stage 1's 16)
1. `disallowed-tools` frontmatter field for skills (CC 2.1.152)
2. `/reload-skills` command (CC 2.1.152)
3. SessionStart hook `reloadSkills` return value (CC 2.1.152)
4. SessionStart hook `sessionTitle` output (CC 2.1.152)
5. `MessageDisplay` hook event (CC 2.1.152)
6. Workflow tool keyword rename: `ultrawork` -> `workflow` (CC 2.1.153)
7. Run app skill family: `/run`, `/verify`, `/run-skill-generator` (CC 2.1.145)
8. Coordinator mode system prompts (CC 2.1.152)
9. Plugin marketplace `skipLfs` option (CC 2.1.153)
10. Subagent frontmatter MCP servers policy enforcement (CC 2.1.153)
11. `--strict-mcp-config` behavior change (CC 2.1.153)
12. REMOVED: `/simplify` skill (CC 2.1.147)
13. `/simplify` now invokes `/code-review --fix` (CC 2.1.152)
14. `/code-review --fix` and `--comment` flags (CC 2.1.147, 2.1.152)
15. Auto mode consent removal (CC 2.1.152)
16. `pluginSuggestionMarketplaces` managed setting (CC 2.1.152)
17. Plugin agents declaring multiple `Agent(...)` types fix (CC 2.1.147) [STAGE 2 ADDITION]
18. Agent tool autocomplete suggests skills (CC 2.1.153) [PROMOTED from May Update]

**May Update: 8 items** (Stage 2 corrected: -4 demoted, -1 promoted)
- Command and tool behavior changes that may affect reference docs
- 4 items demoted to No Action (internal system prompt changes)

**No Action: 54+ items**
- Bug fixes, UI improvements, IDE integrations, platform-specific fixes
- 4 items demoted from May Update (thinking reminder, plan mode, security monitor changes)

**Token delta from system-prompts:**
- 2.1.145: +20,218 tokens (large addition: Run skills, Managed Agents self-hosted docs)
- 2.1.146: +4,755 tokens (Workflow tool, plan mode phase four)
- 2.1.147: +1,236 tokens (/code-review parts 1-8)
- 2.1.149: +282 tokens (Workflow tool framing)
- 2.1.152: +4,566 tokens (Coordinator mode, /code-review part 9)
- 2.1.153: +303 tokens (Workflow keyword rename, thinking reminder removal)
- Total estimated: ~31,360 tokens added across the version range

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | OK | Retrieved via WebFetch from upstream |
| System-prompts | OK | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | Skipped | Subagent dispatch returned empty output; official docs fetched directly |
| Official docs | OK | skills, hooks, plugins-reference pages fetched and cross-referenced |

---

## Recommendations

1. **High priority updates**: The skill frontmatter changes (`disallowed-tools`), new commands (`/reload-skills`), and hook enhancements (SessionStart outputs, MessageDisplay event) should be documented promptly as they directly affect plugin development.

2. **Bundled skill documentation**: The Run app skill family (`/run`, `/verify`, `/run-skill-generator`) and `/code-review` enhancements are significant additions that users should know about.

3. **Marketplace source options**: The `skipLfs` option for git sources should be documented once official docs confirm the schema.

4. **Auto mode change**: Document that auto mode no longer requires explicit consent, as this affects autonomous agent workflows.

5. **Coordinator mode**: Consider documenting the coordinator/worker pattern for advanced multi-agent orchestration scenarios.

---

## Stage 2: Verification Results
### Verified: 2026-05-28

#### Must Update Verification

- [x] **`disallowed-tools` frontmatter field** (CC 2.1.152) — CONFIRMED in CC changelog ("Skills and slash commands can set `disallowed-tools` in frontmatter to remove tools from the model"). Gap exists: not in `references/skill-development/references/advanced-frontmatter.md` or `references/command-development/references/frontmatter-reference.md`.
- [x] **`/reload-skills` command** (CC 2.1.152) — CONFIRMED in CC changelog ("Added `/reload-skills` command to re-scan skill directories without restarting session"). Gap exists: not documented in any plugin-dev reference. Note: This is a built-in CC command, may be worth brief mention in skill development context.
- [x] **SessionStart hook `reloadSkills` return value** (CC 2.1.152) — CONFIRMED in CC changelog ("`SessionStart` hooks can return `reloadSkills: true` to re-scan directories"). Gap exists: not in `references/hook-development/references/event-schemas.md` SessionStart output section.
- [x] **SessionStart hook `sessionTitle` output** (CC 2.1.152) — CONFIRMED in CC changelog ("`SessionStart` hooks can set session title via `hookSpecificOutput.sessionTitle`"). Gap exists: not in `references/hook-development/references/event-schemas.md` SessionStart output section.
- [x] **`MessageDisplay` hook event** (CC 2.1.152) — CONFIRMED in CC changelog ("Added `MessageDisplay` hook event that lets hooks transform or hide assistant message text"). Gap exists: not in `references/hook-development/overview.md` (lists 25 events, but this would be #26) or event-schemas.md.
- [x] **Workflow tool keyword rename** (CC 2.1.153) — CONFIRMED in system-prompts changelog ("Renames the explicit opt-in keyword from `ultrawork` to `workflow`"). Low plugin-dev impact but noted for completeness.
- [x] **Run app skill family** (CC 2.1.145) — CONFIRMED in system-prompts changelog (NEW: Skill: Run app, Run skill generator, etc.). Gap exists: bundled skills reference not comprehensive.
- [x] **Coordinator mode system prompts** (CC 2.1.152) — CONFIRMED in system-prompts changelog (NEW: Coordinator mode orchestration, Coordinator worker instructions). May affect agent documentation for multi-agent patterns.
- [x] **Plugin marketplace `skipLfs` option** (CC 2.1.153) — CONFIRMED in CC changelog ("Added `skipLfs` option to `github`/`git` plugin marketplace sources"). Gap exists: not in `references/marketplace-structure/references/schema-reference.md` Source Types section.
- [x] **Subagent frontmatter MCP servers policy enforcement** (CC 2.1.153) — CONFIRMED in CC changelog ("Fixed subagent frontmatter MCP servers ignoring `--strict-mcp-config`, `--bare`, remote mode, and managed MCP config policies"). Behavior fix worth noting in agent documentation.
- [x] **`--strict-mcp-config` behavior change** (CC 2.1.153) — CONFIRMED in CC changelog ("`--strict-mcp-config` no longer strips inline `mcpServers` from explicitly-passed agent definitions"). Documentation note for MCP/agent integration.
- [x] **REMOVED: `/simplify` skill** (CC 2.1.147) — CONFIRMED in system-prompts changelog ("REMOVED: Skill: Simplify — Removes the code review and cleanup skill"). Replaced by `/code-review`.
- [x] **`/simplify` now invokes `/code-review --fix`** (CC 2.1.152) — CONFIRMED in CC changelog. This is a follow-up behavior where `/simplify` became an alias. Consolidate with the removal note.
- [x] **`/code-review` with `--fix` and `--comment`** (CC 2.1.147, 2.1.152) — CONFIRMED in both changelogs. New major bundled skill with effort levels and fix application.
- [x] **Auto mode consent removal** (CC 2.1.152) — CONFIRMED in CC changelog ("Auto mode no longer requires opt-in consent"). Relevant for autonomous agent workflows.
- [x] **`pluginSuggestionMarketplaces` managed setting** (CC 2.1.152) — CONFIRMED in CC changelog. Enterprise setting for plugin marketplace suggestions.

#### Missed Items (promoted from No Action)

- ! **Plugin agents declaring multiple `Agent(...)` types** (CC 2.1.147) — Previously dropped all but last entry; now fixed. Affects agent `tools:` frontmatter when declaring multiple agent types.
  - Affects: agent-development
  - Details: Plugin agents with `tools: Agent(type1), Agent(type2)` now correctly retain both entries instead of only the last.

#### May Update Resolution

- = **`/model` saves selection as default** (CC 2.1.153) — Kept as May Update: User-facing feature, not directly plugin-related.
- = **`/bg` continues response in background** (CC 2.1.153) — Kept as May Update: Background session behavior, tangentially relevant to background agents.
- up **Agent tool autocomplete suggests skills** (CC 2.1.153) — PROMOTED to Must Update: `claude agents` autocomplete now suggests bundled skills. Relevant for agent development documentation.
  - Affects: agent-development
  - Details: The `claude agents` dispatch input autocomplete now includes native slash commands and bundled skills.
- = **Status line receives COLUMNS/LINES** (CC 2.1.153) — Kept as May Update: Status line feature, minor relevance.
- = **`claude plugin marketplace remove` scope flag** (CC 2.1.152) — Kept as May Update: CLI command enhancement, low priority.
- = **`/usage` per-category breakdown** (CC 2.1.149) — Kept as May Update: User-facing feature.
- = **Workflow tool expanded guidance** (CC 2.1.149, 2.1.152) — Kept as May Update: System prompt guidance, not plugin API.
- = **Fallback model support** (CC 2.1.152) — Kept as May Update: Configuration feature.
- down **REMOVED: Thinking frequency tuning reminder** (CC 2.1.153) — DEMOTED to No Action: Internal system prompt change, no plugin impact.
- down **REMOVED: Iterative plan mode reminder** (CC 2.1.145) — DEMOTED to No Action: Internal system prompt change, no plugin impact.
- down **Phase four of plan mode** (CC 2.1.146) — DEMOTED to No Action: Internal system prompt change, no plugin impact.
- down **Security monitor updates** (CC 2.1.146, 2.1.147) — DEMOTED to No Action: Internal security enforcement, not plugin API.

#### Summary

- **Must Update**: 17 items (16 confirmed from Stage 1 + 1 promoted from May Update + 1 missed item)
- **May Update**: 7 items remaining (4 demoted to No Action)
- **No Action**: 54+ items (including 4 demoted from May Update)
- **Confidence**: HIGH — All Must Update items verified against primary sources. No items rejected.
- **Issues Found**:
  - Summary count discrepancy fixed (was "15 items" with 16 listed, now accurately 17)
  - One missed item promoted: plugin agents multiple `Agent(...)` types fix
  - Four May Update items demoted as irrelevant to plugin development
  - One May Update item promoted (Agent tool autocomplete)

#### Notes for Stage 3

1. **Hook development updates (HIGH PRIORITY)**:
   - Add `reloadSkills` and `sessionTitle` to SessionStart output schema in event-schemas.md
   - Add `MessageDisplay` event documentation (new #26 event) to overview.md and event-schemas.md

2. **Skill development updates (HIGH PRIORITY)**:
   - Add `disallowed-tools` frontmatter field to advanced-frontmatter.md
   - Mention `/reload-skills` command in overview.md for development workflow

3. **Marketplace updates (MEDIUM PRIORITY)**:
   - Add `skipLfs` option to schema-reference.md Source Types section

4. **Agent development updates (MEDIUM PRIORITY)**:
   - Document subagent MCP policy enforcement fix (CC 2.1.153)
   - Document `--strict-mcp-config` behavior change for agent mcpServers
   - Document multiple `Agent(...)` types fix (CC 2.1.147)
   - Add note about `claude agents` autocomplete suggesting skills (CC 2.1.153)

5. **Bundled skills reference (LOWER PRIORITY)**:
   - Update `/simplify` -> `/code-review` rename with `--fix` and `--comment` flags
   - Add Run app skill family (`/run`, `/verify`, `/run-skill-generator`)
   - Note auto mode consent removal for autonomous workflows
