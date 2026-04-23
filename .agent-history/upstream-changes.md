# Upstream Change Manifest
## CC Version Range: 2.1.115 - 2.1.117
## Generated: 2026-04-22
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - MCP unavailable in CI environment]

---

### Must Update

- [ ] **Native bfs/ugrep tools replace Glob/Grep on macOS/Linux** (CC 2.1.117)
  - Source: changelog only
  - Confidence: medium
  - Affects: agent-creator skill, plugin-validator agent, tool documentation
  - Details: Embedded `bfs` and `ugrep` tools now replace separate Glob/Grep tools on macOS/Linux. This is a significant change to built-in tools that may affect how we document tool usage in skills and agent prompts. Need to verify if tool names change or if this is transparent to users.
  - Raw: "Native builds: Embedded `bfs` and `ugrep` tools replace separate Glob/Grep tools on macOS/Linux"

- [ ] **MCP server loading from agent frontmatter with --agent** (CC 2.1.117)
  - Source: changelog only
  - Confidence: medium
  - Affects: agent-creator skill, plugin.json documentation
  - Details: Agent frontmatter `mcpServers` now load for main-thread sessions with `--agent`. This extends MCP configuration capabilities for agents and may require documentation updates for agent frontmatter fields.
  - Raw: "MCP server loading: Agent frontmatter `mcpServers` load for main-thread sessions with `--agent`"

- [ ] **Plugin improvements - install handles dependencies, marketplace blocking enforced** (CC 2.1.117)
  - Source: changelog only
  - Confidence: medium
  - Affects: plugin.json documentation, marketplace.json documentation
  - Details: `plugin install` now handles missing dependencies; marketplace blocking is enforced. May require updates to plugin installation documentation and marketplace manifest documentation.
  - Raw: "Plugin improvements: `plugin install` now handles missing dependencies; marketplace blocking is enforced"

- [ ] **Background job behavior - new system prompt** (CC 2.1.117)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent-creator skill (for background/fork agents)
  - Details: New system prompt instructs background job agents to narrate progress, restate final results in message text (not just tool calls) so classifiers can extract them, and explicitly signal done/blocked/failed status. This is guidance for writing agents that run as background jobs.
  - Raw: "NEW: System Prompt: Background job behavior - Instructs background job agents to narrate progress, restate final results in message text (not just in tool calls) so classifiers can extract them, and explicitly signal done/blocked/failed status."

- [ ] **SendMessageTool attachments format expansion** (CC 2.1.116)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-creator skill (for team agents using SendMessageTool)
  - Details: `attachments` now accepts either a file path string (for files on working filesystem) or the exact `{file_uuid, file_name, size, is_image}` object returned by device tools like `attach_file`. This is a format expansion for agent teams.
  - Raw: "Tool Description: SendMessageTool (non-agent-teams) - Expanded `attachments` documentation: entries now accept either a file path string (for files on the working filesystem) or the exact `{file_uuid, file_name, size, is_image}` object returned by a device tool like `attach_file`"

- [ ] **Agent frontmatter hooks fire with --agent** (CC 2.1.116)
  - Source: CC changelog (missed by Stage 1)
  - Confidence: high
  - Affects: agent-development skill (agent frontmatter hooks section)
  - Details: Agent frontmatter `hooks:` now fire when running as a main-thread agent via `--agent`. Previously, agent frontmatter hooks only fired when the agent ran as a subagent. This extends hook functionality to main-session agents.
  - Raw: "Agent frontmatter `hooks:` now fires during main-thread agent execution via `--agent`"

- [ ] **Plugin auto-update installs missing dependencies** (CC 2.1.116)
  - Source: CC changelog (missed by Stage 1)
  - Confidence: medium
  - Affects: plugin-structure skill (plugin caching/updates section)
  - Details: `/reload-plugins` and background plugin auto-update now auto-install missing plugin dependencies from marketplaces you've already added. Related to CC 2.1.117's `plugin install` dependency handling.
  - Raw: "`/reload-plugins` and background plugin auto-update now auto-install missing plugin dependencies from marketplaces you've already added"

---

### May Update

- [ ] **Forked subagents work on external builds** (CC 2.1.117)
  - Source: changelog only
  - Confidence: low
  - Affects: agent documentation
  - Details: Forked subagents now work on external builds via `CLAUDE_CODE_FORK_SUBAGENT=1` environment variable.

- [ ] **Concurrent MCP server connections now default** (CC 2.1.117)
  - Source: changelog only
  - Confidence: low
  - Affects: MCP documentation
  - Details: Faster startup with concurrent MCP server connections (now default behavior).

---

### No Action

**Bug fixes, UI enhancements, internal changes (CC 2.1.115-2.1.117):**
- Advisor Tool experimental feature with clear labeling (CC 2.1.117) - internal feature
- OpenTelemetry enhancements for user prompts (CC 2.1.117) - internal telemetry
- Windows cached executable lookups (CC 2.1.117) - platform optimization
- OAuth token refresh fixes (CC 2.1.117) - auth bugfix
- WebFetch large HTML truncation fix (CC 2.1.117) - tool bugfix
- Proxy HTTP 204 response fix (CC 2.1.117) - network bugfix
- Opus 4.7 context window calculation fix (CC 2.1.117) - model bugfix
- Subagent model mismatch malware warning fix (CC 2.1.117) - bugfix

**Demoted from Must Update (no plugin relevance):**
- REMOVED: Verify skill /runtime-verification alias (CC 2.1.117) - plugin-dev has no references
- /schedule slash command routines rename (CC 2.1.117) - plugin-dev doesn't document /schedule
- Post-turn session summary (CC 2.1.116) - internal system reminder, not plugin-related

**Demoted from May Update (no plugin relevance or upstream-only):**
- Default effort level now "high" (CC 2.1.117) - API behavior, not plugin system
- /resume offers to summarize large stale sessions (CC 2.1.117) - UI feature
- cleanupPeriodDays expanded coverage (CC 2.1.117) - settings feature
- /model selections persist across restarts (CC 2.1.117) - UI feature
- Simplify skill - Nested conditionals pattern (CC 2.1.116) - upstream skill
- Dream memory consolidation - daily logs prefix (CC 2.1.116) - internal agent behavior
- Connector management URL change (CC 2.1.116) - not plugin-related
- Build with Claude API skill - migration routing (CC 2.1.116) - upstream skill
- Model migration guide - /claude-api migrate callout (CC 2.1.116) - upstream skill

---

## Token Delta Summary (from system-prompts)

| Version | Delta | Key Changes |
|---------|-------|-------------|
| 2.1.117 | -2,003 | Background job behavior NEW, /runtime-verification REMOVED, /schedule routines rename |
| 2.1.116 | +1,136 | Post-turn session summary NEW, SendMessageTool attachments, Dream memory prefix |

**Net change since 2.1.114**: -867 tokens (removal of /runtime-verification alias offset gains)

---

## Summary

| Category | Count |
|----------|-------|
| Must Update | 7 |
| May Update | 2 |
| No Action | 20 |

**Version Range**: 2.1.115 through 2.1.117 (3 versions since last audit at 2.1.114)

**Stage 2 Corrections**: 2 items added to Must Update (missed from CC changelog), 3 demoted from Must Update to No Action, 9 demoted from May Update to No Action.

**Key Themes**:
1. **Agent frontmatter enhancements** - mcpServers and hooks now fire when running as main-thread agent via `--agent` (major agent capability expansion)
2. **Plugin install improvements** - dependency handling via install, reload, and auto-update; marketplace blocking enforced (affects plugin distribution)
3. **Background job behavior** - new guidance for fork/background agents (affects agent authoring)
4. **Native tool replacement** - bfs/ugrep replacing Glob/Grep on macOS/Linux (transparent to users - tool names unchanged)

**Priority items for Stage 3:**
1. Agent frontmatter hooks with --agent (CC 2.1.116) - update agent-development/overview.md hooks section
2. MCP server loading from agent frontmatter (CC 2.1.117) - update agent-development mcpServers section
3. Plugin install/auto-update dependency handling (CC 2.1.116+2.1.117) - update plugin-structure documentation
4. Background job behavior (CC 2.1.117) - add guidance for background agents
5. SendMessageTool attachments format (CC 2.1.116) - update advanced-agent-fields.md

**Data Quality Notes**:
- Two-source triangulation (CC changelog + system-prompts changelog)
- claude-code-guide agent dispatch skipped (MCP tool unavailable in CI environment)
- System-prompts changelog provides structured detail with token counts and NEW/REMOVED markers
- Note: CC 2.1.115 had no changelog entry in either source (version may have been skipped or internal-only)

---

## Stage 2: Verification Results
### Verified: 2026-04-22

#### Must Update Verification
- ✓ **Native bfs/ugrep tools** (CC 2.1.117) — confirmed in CC changelog ("Native builds: Embedded `bfs` and `ugrep` tools replace separate Glob/Grep tools on macOS/Linux"), gap exists: no mention of bfs/ugrep in plugin-dev docs. Affects: tool documentation is low priority since this is transparent to tool users (Glob/Grep names unchanged).
- ✓ **MCP server loading from agent frontmatter** (CC 2.1.117) — confirmed in CC changelog, gap exists in `agent-development/overview.md` line 340-349: documents mcpServers field but does not mention `--agent` main-thread loading behavior.
- ✓ **Plugin improvements** (CC 2.1.117) — confirmed in CC changelog ("plugin install now handles missing dependencies; marketplace blocking is enforced"), partial gap: `strictKnownMarketplaces` documented at marketplace-structure/overview.md:217 but `blockedMarketplaces` enforcement not explicitly mentioned as enforced at install time.
- ✓ **Background job behavior** (CC 2.1.117) — confirmed in system-prompts changelog, gap exists: no guidance for background agents in agent-development about narrating progress/signaling status.
- ✓ **REMOVED: Verify skill /runtime-verification alias** (CC 2.1.117) — confirmed in system-prompts changelog, no action needed: plugin-dev has no references to /runtime-verification alias (grep verified).
- ✓ **/schedule routines rename** (CC 2.1.117) — confirmed in system-prompts changelog, no action needed: plugin-dev does not document /schedule command. Demote to No Action.
- ✓ **SendMessageTool attachments** (CC 2.1.116) — confirmed in system-prompts changelog, gap exists: `advanced-agent-fields.md` mentions SendMessage tool at line 209 and 265 but not the expanded attachments format (file path string OR object).
- ✓ **Post-turn session summary** (CC 2.1.116) — confirmed in system-prompts changelog, no action needed: this is an internal system reminder feature, not plugin-related. Demote to No Action.

#### Missed Items (promoted from No Action)
- ! **Agent frontmatter hooks fire with --agent** (CC 2.1.116) — missed from CC changelog: "Agent frontmatter `hooks:` now fire when running as a main-thread agent via `--agent`"
  - Affects: agent-development skill (hooks in agent frontmatter section)
  - Details: Previously, agent frontmatter hooks only fired when the agent ran as a subagent. Now they also fire when running as the main session agent via `--agent` flag.
  - Confidence: high

- ! **Plugin auto-update installs missing dependencies** (CC 2.1.116) — missed from CC changelog: "`/reload-plugins` and background plugin auto-update now auto-install missing plugin dependencies from marketplaces you've already added"
  - Affects: plugin-structure skill (plugin caching/updates section)
  - Details: Plugin auto-update mechanism now handles dependencies, similar to CC 2.1.117's `plugin install` improvement.
  - Confidence: medium (may overlap with CC 2.1.117 item)

#### May Update Resolution
- ↓ **Default effort level now "high"** (CC 2.1.117) — demoted to No Action: affects API behavior not plugin system
- ↓ **/resume offers to summarize large stale sessions** (CC 2.1.117) — demoted to No Action: UI feature, not plugin-related
- ↓ **cleanupPeriodDays expanded coverage** (CC 2.1.117) — demoted to No Action: settings feature, not plugin-related
- ↓ **/model selections persist across restarts** (CC 2.1.117) — demoted to No Action: UI feature, not plugin-related
- = **Forked subagents work on external builds** (CC 2.1.117) — kept as May Update: `CLAUDE_CODE_FORK_SUBAGENT=1` could be relevant for agent documentation but low priority
- = **Concurrent MCP server connections now default** (CC 2.1.117) — kept as May Update: performance improvement could be noted in MCP documentation
- ↓ **Simplify skill - Nested conditionals** (CC 2.1.116) — demoted to No Action: upstream skill, not our docs
- ↓ **Dream memory consolidation** (CC 2.1.116) — demoted to No Action: internal agent behavior
- ↓ **Connector management URL change** (CC 2.1.116) — demoted to No Action: not plugin-related
- ↓ **Build with Claude API skill** (CC 2.1.116) — demoted to No Action: upstream skill
- ↓ **Model migration guide** (CC 2.1.116) — demoted to No Action: upstream skill

#### Summary
- Must Update: 7 items (5 from Stage 1 confirmed with gaps, 2 added from missed CC changelog items)
- May Update: 2 items remaining (down from 11)
- No Action: 20 items (8 original + 3 demoted from Must Update + 9 demoted from May Update)
- Confidence: high — two-source verification with independent WebFetch confirms all items

#### Issues Found
- 2 items missed from CC changelog for version 2.1.116 (hooks --agent firing, auto-update dependencies)
- 2 Must Update items demoted (no plugin relevance): /schedule routines, post-turn session summary
- 9 May Update items demoted (no plugin relevance or upstream-only)

---

## Raw Changelog Excerpts

### CC 2.1.117 (from upstream changelog)

```
- **Subagent enhancement**: Forked subagents now work on external builds via `CLAUDE_CODE_FORK_SUBAGENT=1`
- **MCP server loading**: Agent frontmatter `mcpServers` load for main-thread sessions with `--agent`
- **Model persistence**: `/model` selections now persist across restarts even when projects pin different models
- **Session management**: `/resume` offers to summarize large, stale sessions before re-reading
- **Performance**: Faster startup with concurrent MCP server connections (now default)
- **Plugin improvements**: `plugin install` now handles missing dependencies; marketplace blocking is enforced
- **Advisor Tool**: Experimental feature now displays with clear labeling and prevents processing errors
- **Cleanup expansion**: `cleanupPeriodDays` now covers tasks, shell snapshots, and backups
- **OpenTelemetry enhancements**: User prompts now include command metadata and effort attributes
- **Native builds**: Embedded `bfs` and `ugrep` tools replace separate Glob/Grep tools on macOS/Linux
- **Windows optimization**: Cached executable lookups improve subprocess performance
- **Default effort level**: Pro/Max subscribers on Opus/Sonnet 4.6 now use `high` effort (previously `medium`)
- **OAuth fixes**: Plain-CLI sessions no longer die on token expiration; tokens refresh reactively
- **WebFetch improvement**: Large HTML pages no longer hang via pre-conversion truncation
- **Bug fixes**: Proxy HTTP 204 responses, expired tokens, prompt undo issues, and various model-specific problems
```

### System-prompts 2.1.117

```
- **NEW:** System Prompt: Background job behavior - Instructs background job agents to narrate progress,
  restate final results in message text (not just in tool calls) so classifiers can extract them,
  and explicitly signal done/blocked/failed status.
- **REMOVED:** Skill: Verify skill (runtime-verification) - The duplicate alias of the Verify skill
  registered under the `/runtime-verification` slash command name has been removed; the primary
  Verify skill remains.
- Agent Prompt: /schedule slash command - Reframed "triggers" as "routines" throughout user-facing
  copy (API parameter `trigger_id` unchanged) and added support for one-time runs via `run_once_at`
  (RFC3339 UTC timestamp) as an alternative to `cron_expression`; updated deletion/management URLs
  from `claude.ai/code/scheduled` to `claude.ai/code/routines`; documented that
  `ended_reason: "run_once_fired"` indicates a fired one-shot that can be re-armed by updating
  with a new `run_once_at`; extended timezone-conversion guidance to cover one-time timestamps.
```

### System-prompts 2.1.116

```
- **NEW:** System Reminder: Post-turn session summary - Instructs Claude to produce a structured JSON
  summary of a Claude Code session for inbox-style triage across multiple sessions.
- Agent Prompt: Dream memory consolidation - Clarified that daily logs are always present (removed
  "if present" hedge) and documented their prefix coding (`>` user, `<` assistant, `.` tool call);
  added explicit `ls logs/` step and guidance to read the most recent 1-3 days.
- Agent Prompt: /schedule slash command - Updated connector management URL from
  `claude.ai/settings/connectors` to `claude.ai/customize/connectors`.
- Skill: Build with Claude API (reference guide) - Added an explicit routing entry pointing
  migrations and retired-model replacements to `shared/model-migration.md`.
- Skill: Building LLM-powered applications with Claude - Added `/claude-api migrate` subcommand
  that dispatches to the model migration guide, with instructions to execute (not summarize) the
  guide starting from the scope-confirmation step and to ask for the target model if not specified.
- Skill: Model migration guide - Added a top-of-file callout for users arriving via `/claude-api migrate`
  telling Claude to execute the steps in order rather than summarize them, and to start with
  Step 0 (confirm scope) before editing.
- Skill: Simplify - Added "Nested conditionals" as a new hacky-pattern category (ternary chains,
  nested if/else, nested switch 3+ levels deep) with guidance to flatten using early returns,
  guard clauses, lookup tables, or if/else-if cascades.
- Tool Description: SendMessageTool (non-agent-teams) - Expanded `attachments` documentation:
  entries now accept either a file path string (for files on the working filesystem) or the exact
  `{file_uuid, file_name, size, is_image}` object returned by a device tool like `attach_file`
  (passed through verbatim for user-uploaded files).
```
