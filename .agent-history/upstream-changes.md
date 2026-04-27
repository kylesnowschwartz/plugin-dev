# Upstream Change Manifest
## CC Version Range: 2.1.118 - 2.1.120
## Generated: 2026-04-25
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent type not available in environment]

---

### Must Update

- [ ] **NEW: Hooks support `type: "mcp_tool"` for direct MCP tool invocation** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: hooks skill, plugin-creator agent
  - Details: Hooks can now directly invoke MCP tools with `type: "mcp_tool"`. This is a significant expansion of hook capabilities that should be documented in the hooks reference.
  - Raw: "Hooks support `type: \"mcp_tool\"` for direct MCP tool invocation"

- [ ] **NEW: Hook inputs include `duration_ms` for tool execution timing** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: hooks skill
  - Details: Hook inputs now receive `duration_ms` field showing how long a tool execution took. Useful for performance monitoring hooks.
  - Raw: "Hook inputs include `duration_ms` for tool execution timing"

- [ ] **NEW: Print mode honors agent `tools:` and `disallowedTools:` frontmatter** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: agent-creator agent, build-agents skill
  - Details: Agent frontmatter tool restrictions now work in print mode (-p), not just interactive mode. Important for headless agent usage.
  - Raw: "Print mode now honors agent `tools:` and `disallowedTools:` frontmatter"

- [ ] **NEW: Settings persist to `~/.claude/settings.json` with project/local/policy override support** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: plugin-config skill
  - Details: Settings now have a formal persistence location and override hierarchy. May affect how plugin settings interact with user settings.
  - Raw: "Settings now persist to `~/.claude/settings.json` with project/local/policy override support"

- [ ] **NEW: Auto mode `"$defaults"` extension for built-in rules** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: permissions skill, plugin-creator agent
  - Details: Auto mode rules can now include `"$defaults"` to extend rather than replace built-in rules. Important for plugin permission configurations.
  - Raw: "Auto mode: include `\"$defaults\"` to extend built-in rules"

- [ ] **NEW: Custom themes via `/theme` command and `~/.claude/themes/`** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: general reference
  - Details: Users can now create custom themes. Not directly plugin-related but affects user customization documentation.
  - Raw: "Custom themes can be created/edited via `/theme` or `~/.claude/themes/`"

- [ ] **NEW: `/cost` and `/stats` merged into `/usage` command** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: command reference
  - Details: Command consolidation that should be reflected in any command documentation.
  - Raw: "Merged `/cost` and `/stats` into unified `/usage` command"

- [ ] **NEW: Vim visual mode (`v`) and visual-line mode (`V`)** (CC 2.1.118)
  - Source: changelog, system-prompts (status line setup mentions VISUAL/VISUAL LINE modes)
  - Confidence: high (both sources)
  - Affects: general reference
  - Details: Vim mode expanded with visual selection modes.
  - Raw: "Added vim visual mode (`v`) and visual-line mode (`V`)"

- [ ] **NEW: BrowserBatch tool** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: tool reference
  - Details: New tool for executing multiple browser actions sequentially in one round trip. Stops on first error and returns interleaved outputs/screenshots.
  - Raw: "Tool Description: BrowserBatch - Describes the browser batch tool for executing multiple browser actions sequentially in one round trip, stopping on first error and returning interleaved outputs/screenshots."

- [ ] **NEW: Harness instructions system prompt** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: internal reference
  - Details: Core interactive-agent harness guidance for terminal markdown output, permission handling, `<system-reminder>` context, compaction, tool use, and clickable code references.
  - Raw: "System Prompt: Harness instructions - Core interactive-agent harness guidance for terminal markdown output, permission handling, `<system-reminder>` context, compaction, tool use, and clickable code references."

- [ ] **NEW: Memory instructions system prompt** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: memory skill
  - Details: Instructions for persistent file-based memory including frontmatter format, memory types, duplicate/stale-memory handling, and verification of recalled file/function/flag references.
  - Raw: "System Prompt: Memory instructions - Instructions for persistent file-based memory, including frontmatter format, memory types, duplicate/stale-memory handling, and verification of recalled file/function/flag references."

- [ ] **NEW: Write tool requires reading existing file first** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: tool reference, skill examples
  - Details: The Write tool now requires reading an existing file before overwriting it. Recommends Edit for modifications. This affects tool usage guidance in skills.
  - Raw: "Tool Description: Write (read existing file first) - Requires reading an existing file before overwriting it with Write, and recommends Edit for modifications."

- [ ] **NEW: Background agent state classifier prompt** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: agent reference
  - Details: Classifies background agent transcript tails as working/blocked/done/failed and returns concise state JSON.
  - Raw: "Agent Prompt: Background agent state classifier - Classifies the tail of a background agent transcript as working, blocked, done, or failed and returns concise state JSON."

- [ ] **NEW: Background session instructions** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: agent reference, background jobs
  - Details: Instructs background job sessions to use job-specific temporary directory and follow worktree isolation guidance.
  - Raw: "System Prompt: Background session instructions - Instructs background job sessions to use the job-specific temporary directory and follow the appropriate worktree isolation guidance."

- [ ] **NEW: Previously invoked skills reminder** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: skill reference
  - Details: New reminder that restores skills invoked before conversation compaction as context only, warning not to re-execute setup actions or treat prior inputs as current instructions. Replaces the old "Invoked skills" reminder.
  - Raw: "System Reminder: Previously invoked skills - Restores skills invoked before conversation compaction as context only, warning not to re-execute setup actions or treat prior inputs as current instructions."

- [ ] **NEW: Scheduled skills (/catch-up, /dream, /morning-checkin, /pre-meeting-checkin)** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: skill reference, scheduling
  - Details: Four new built-in scheduled skills for periodic heartbeat, nightly memory consolidation, daily brief, and pre-meeting event brief.
  - Raw: "/catch-up periodic heartbeat, /dream memory consolidation, /morning-checkin daily brief, /pre-meeting-checkin event brief skills added"

- [ ] **REMOVED: Config tool** (CC 2.1.118)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: tool reference
  - Details: The Config tool for getting/setting Claude Code settings has been removed. The Update Claude Code Config skill now suggests `/config` slash command instead.
  - Raw: "Tool Description: Config - The Config tool for getting/setting Claude Code settings has been removed; the Update Claude Code Config skill now suggests the `/config` slash command instead of 'the Config tool' for simple settings."

- [ ] **REMOVED: Teammate Communication prompt and broadcast option** (CC 2.1.118)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: agent-teams reference
  - Details: Swarm-mode teammate communication prompt removed; the broadcast (`to: "*"`) option also dropped from agent-teams SendMessageTool description.
  - Raw: "Agent Prompt: Teammate Communication - Swarm-mode teammate communication prompt removed; the broadcast (`to: \"*\"`) option also dropped from the agent-teams SendMessageTool description."

- [ ] **NEW: Plan mode approval tool enforcement** (CC 2.1.118)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: plan mode reference
  - Details: Plan mode turns must end with either AskUserQuestion (for clarification) or ExitPlanMode (for plan approval), forbidding other approval methods.
  - Raw: "System Reminder: Plan mode approval tool enforcement - Requires plan mode turns to end with either AskUserQuestion (for clarification) or ExitPlanMode (for plan approval), and forbids asking for approval any other way."

- [ ] **NEW: WSL managed settings double opt-in** (CC 2.1.118)
  - Source: system-prompts, changelog
  - Confidence: high (both sources)
  - Affects: settings reference
  - Details: WSL can inherit Windows-side managed settings but requires admin flag and optional user opt-in for HKCU.
  - Raw: "WSL can inherit Windows-side managed settings"

- [ ] **NEW: Anthropic CLI (`ant`) reference documentation** (CC 2.1.118)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: managed-agents skill
  - Details: Reference documentation for the `ant` CLI covering installation, authentication, command structure, and managed agents workflows.
  - Raw: "Data: Anthropic CLI - Reference documentation for the `ant` CLI covering installation, authentication, command structure, input/output shaping, managed agents workflows, and scripting patterns."

- [ ] **NEW: Schedule proactive offer guidance** (CC 2.1.118)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: scheduling reference
  - Details: Explains when to use scheduling tool for recurring or one-time remote agents and when to proactively offer scheduling after successful work.
  - Raw: "Tool Description: Schedule proactive offer guidance - Explains when to use the scheduling tool for recurring or one-time remote agents and when to proactively offer scheduling after successful work."

- [ ] **PowerShell support expanded** (CC 2.1.118, 2.1.119)
  - Source: system-prompts, changelog
  - Confidence: high (both sources)
  - Affects: tool examples, skill templates
  - Details: Read-only command examples and forbidden-command lists now support PowerShell variants. Commit/PR templates emit PowerShell here-strings when running under PowerShell. PowerShell commands can be auto-approved in permission mode.
  - Raw: "Agent prompts generalized to support both Bash and PowerShell environments"

- [ ] **Managed Agents: Memory stores** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: managed-agents skill
  - Details: Memory stores added as session resources, including store CRUD/archive, 8 stores per session max, 100KB memory limits, versions, and redaction behavior.
  - Raw: "Data: Managed Agents memory stores reference - Reference documentation for Managed Agents memory stores, including store creation, session attachment, FUSE mounts, memory CRUD, concurrency, versions, redaction, and endpoint paths."

- [ ] **/init skill restructured** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: /init reference
  - Details: /init restructured around CLAUDE.md existence check with review/improve, leave, and start-fresh paths. Added plain-text primer before first question and "Let Claude decide" fast path.
  - Raw: "Skill: /init CLAUDE.md and skill setup (new version) - Restructured `/init` around an initial CLAUDE.md existence check..."

- [ ] **Security monitor: encoded/obfuscated command rule** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: security reference
  - Details: Security monitor now requires base64, PowerShell encoded commands, hex/char-array reassembly payloads to be decoded and evaluated before allowing. Unverifiable payloads are blocked.
  - Raw: "Agent Prompt: Security monitor for autonomous agent actions - Added an encoded/obfuscated command rule..."

- [ ] **Status line: effort and thinking fields** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: status reference
  - Details: Two new optional JSON fields for status line: `effort` with level values and `thinking.enabled` boolean.
  - Raw: "Agent Prompt: Status line setup - Documented two new optional JSON fields passed to the `statusLine` command: `effort` with `level` values `low`, `medium`, `high`, `xhigh`, or `max`, and `thinking.enabled` indicating whether extended thinking is on."

- [ ] **Monitor tool decision framework** (CC 2.1.119)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: monitor tool reference
  - Details: Added explicit decision framework for choosing between Bash `run_in_background` and monitor tool, with worked `gh pr checks` polling example.
  - Raw: "Tool Description: Background monitor (streaming events) - Added an explicit decision framework for choosing between Bash `run_in_background` and the monitor..."

- [ ] **Dream memory consolidation: session log format change** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: memory reference
  - Details: Daily log discovery changed from one file per day to recursive session logs under `logs/YYYY/MM/DD/<id>-<title>.md`.
  - Raw: "Agent Prompt: Dream memory consolidation - Updated recent-log discovery from one daily log file per day to recursive session logs..."

- [ ] **WebSearch template variable renamed** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: tool reference
  - Details: Current-month template variable renamed from `${GET_CURRENT_MONTH_YEAR()}` to `${CURRENT_MONTH_YEAR}`.
  - Raw: "Tool Description: WebSearch - Renamed the current-month template variable from `${GET_CURRENT_MONTH_YEAR()}` to `${CURRENT_MONTH_YEAR}`..."

- [ ] **Security monitor: settings_deny_rules insertion point** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: security reference
  - Details: Settings-provided deny rules can now be injected into the security monitor prompt via `settings_deny_rules` insertion point.
  - Raw: "Agent Prompt: Security monitor for autonomous agent actions (second part) - Added a `settings_deny_rules` insertion point after user deny rules..."

- [ ] **Managed Agents: RPM limit increase** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: managed-agents skill
  - Details: Organization create-operation limit for Agents, Sessions, and Vaults increased from 60 RPM to 300 RPM.
  - Raw: "Data: Managed Agents endpoint reference - Increased the documented organization create-operation limit for Agents, Sessions, and Vaults from 60 RPM to 300 RPM."

- [ ] **MISSED: Plugins pinned by version constraint auto-update to highest satisfying git tag** (CC 2.1.119)
  - Source: changelog (identified by Stage 2 verification)
  - Confidence: high (verified in CC changelog)
  - Affects: plugin-structure skill (dependency management)
  - Details: When a plugin depends on another plugin with a version constraint, the dependent plugin now auto-updates to the highest satisfying git tag rather than being locked to the original version.
  - Raw: "Plugins pinned by another plugin's version constraint auto-update to highest satisfying git tag"

- [ ] **MISSED: `--agent <name>` honors agent definition's `permissionMode`** (CC 2.1.119)
  - Source: changelog (identified by Stage 2 verification)
  - Confidence: high (verified in CC changelog)
  - Affects: agent-development skill (permissionMode documentation)
  - Details: When launching an agent via `--agent` CLI flag, Claude Code now respects the agent's frontmatter `permissionMode` for built-in agents.
  - Raw: "`--agent <name>` honors agent definition's `permissionMode` for built-in agents"

- [ ] **MISSED: Agent tool worktree isolation fix** (CC 2.1.119)
  - Source: changelog (identified by Stage 2 verification)
  - Confidence: high (verified in CC changelog)
  - Affects: agent-development skill (worktree isolation patterns)
  - Details: Fixed Agent tool with `isolation: "worktree"` reusing stale worktrees. Affects agent worktree isolation documentation.
  - Raw: "Fixed Agent tool with `isolation: \"worktree\"` reusing stale worktrees"

---

### May Update

- [ ] **MCP servers connect in parallel during reconfiguration** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: MCP reference
  - Details: Performance improvement for MCP server connections.
  - Raw: "MCP servers connect in parallel instead of serially during reconfiguration"

- [ ] **Vim mode: Esc in INSERT no longer retrieves queued messages** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: general reference
  - Details: Vim mode behavior change.

- [ ] **Slash command suggestions highlight matching characters** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: general reference
  - Details: UI improvement for command suggestions.

- [ ] **`prUrlTemplate` setting for custom code-review URLs** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: settings reference
  - Details: New setting for customizing PR review URLs.

- [ ] **`--from-pr` expanded to GitLab, Bitbucket, GitHub Enterprise** (CC 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: command reference
  - Details: PR import now supports more platforms.

- [ ] **`DISABLE_UPDATES` env var for stricter update blocking** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: environment reference
  - Details: New environment variable to block updates.

- [ ] **`/model` picker honors `ANTHROPIC_DEFAULT_*_MODEL_NAME` overrides** (CC 2.1.118)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: model reference
  - Details: Model picker respects environment variable overrides.

- [ ] **MCP OAuth improvements** (CC 2.1.118, 2.1.119)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: MCP reference
  - Details: OAuth token handling improvements and fixes for servers omitting `expires_in`.

- [ ] **/security-review: ALLOWED_TOOLS template variable** (CC 2.1.120)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: security reference
  - Details: Replaced hardcoded git command list with `${ALLOWED_TOOLS}` template variable.

---

### No Action

- CRLF paste handling bug fix (CC 2.1.119)
- UI rendering fixes (CC 2.1.119)
- MCP OAuth issues fixes (CC 2.1.118, 2.1.119)
- IDE extension changes (implicit from general bug fixes)
- Internal performance improvements
- `blockedMarketplaces` enforcement fix (CC 2.1.119) - security bug fix, not documentation gap

---

## Token Delta Summary (from system-prompts)

| Version | Delta | Key Changes |
|---------|-------|-------------|
| 2.1.120 | +783 | Harness/Memory instructions NEW, BrowserBatch NEW, Write read-first NEW, Dream log format change |
| 2.1.119 | +12,498 | Background agent state classifier NEW, Memory stores NEW, 4 scheduled skills NEW, /init restructure |
| 2.1.118 | +4,712 | Anthropic CLI docs NEW, Schedule proactive offer NEW, Plan mode enforcement NEW, Config tool REMOVED |

**Net change since 2.1.117**: +17,993 tokens (significant expansion of managed agents, memory, and scheduling features)

---

## Summary

| Category | Count |
|----------|-------|
| Must Update | 36 |
| May Update | 9 |
| No Action | 6 |

**Version Range**: 2.1.118 through 2.1.120 (3 versions since last audit at 2.1.117)

*Note: Stage 2 verification added 3 missed items to Must Update and 1 to No Action.*

**High-priority items for plugin-dev**:
1. **Hooks `type: "mcp_tool"`** (CC 2.1.118) - new hook capability for direct MCP tool invocation
2. **Hook `duration_ms` input** (CC 2.1.119) - new hook input field for timing
3. **Print mode agent frontmatter enforcement** (CC 2.1.119) - affects headless agent usage
4. **Config tool removal** (CC 2.1.118) - tool no longer exists, use `/config` command
5. **Write tool read-first requirement** (CC 2.1.120) - affects skill examples
6. **PowerShell support expansion** (CC 2.1.118-2.1.119) - cross-platform guidance needed
7. **Auto mode `$defaults` extension** (CC 2.1.118) - permission configuration pattern
8. **Previously invoked skills compaction** (CC 2.1.119) - skill lifecycle change
9. **Teammate Communication broadcast removed** (CC 2.1.118) - breaking change for agent teams
10. **Plugin version constraint auto-update** (CC 2.1.119) - dependency management (MISSED by Stage 1)
11. **Agent `--agent` honors permissionMode** (CC 2.1.119) - agent CLI behavior (MISSED by Stage 1)
12. **Agent worktree isolation fix** (CC 2.1.119) - worktree reuse bug (MISSED by Stage 1)

**New tools**:
- BrowserBatch (CC 2.1.120)

**Removed tools**:
- Config (CC 2.1.118)

**New system prompts**:
- Harness instructions (CC 2.1.120)
- Memory instructions (CC 2.1.120)
- Background session instructions (CC 2.1.119)
- Background agent state classifier (CC 2.1.119)
- Plan mode approval tool enforcement (CC 2.1.118)
- WSL managed settings (CC 2.1.118)
- Schedule proactive offer guidance (CC 2.1.118)
- Previously invoked skills reminder (CC 2.1.119)

**New scheduled skills**:
- /catch-up (CC 2.1.119)
- /dream (CC 2.1.119)
- /morning-checkin (CC 2.1.119)
- /pre-meeting-checkin (CC 2.1.119)

**Breaking changes**:
- Teammate Communication broadcast (`to: "*"`) removed (CC 2.1.118)
- Config tool removed - use `/config` command instead (CC 2.1.118)

**Data Quality Notes**:
- Two-source triangulation (CC changelog + system-prompts changelog)
- claude-code-guide agent dispatch skipped (agent type not available in environment)
- System-prompts changelog provides structured detail with token counts and NEW/REMOVED markers
- High confidence items confirmed across both sources: Vim visual mode, WSL managed settings, PowerShell support

---

## Raw Changelog Excerpts

### CC 2.1.120 (from system-prompts - no CC changelog entry found)

```
- **NEW:** System Prompt: Harness instructions - Core interactive-agent harness guidance for terminal
  markdown output, permission handling, `<system-reminder>` context, compaction, tool use, and
  clickable code references.
- **NEW:** System Prompt: Memory instructions - Instructions for persistent file-based memory,
  including frontmatter format, memory types, duplicate/stale-memory handling, and verification of
  recalled file/function/flag references.
- **NEW:** Tool Description: BrowserBatch - Describes the browser batch tool for executing multiple
  browser actions sequentially in one round trip, stopping on first error and returning interleaved
  outputs/screenshots.
- **NEW:** Tool Description: Write (read existing file first) - Requires reading an existing file
  before overwriting it with Write, and recommends Edit for modifications.
- Agent Prompt: Dream memory consolidation - Updated recent-log discovery from one daily log file
  per day to recursive session logs under `logs/YYYY/MM/DD/<id>-<title>.md`, with recursive
  `ls -R logs/` guidance and session titles used for triage.
- Agent Prompt: Security monitor for autonomous agent actions (second part) - Added a
  `settings_deny_rules` insertion point after user deny rules, allowing settings-provided deny
  rules to be injected into the monitor prompt.
- Agent Prompt: /security-review slash command - Replaced the hardcoded git-diff/status/log/show/remote
  allowed-tools list with an `${ALLOWED_TOOLS}` template variable while keeping Read/Glob/Grep/LS/Task
  available.
- Data: Managed Agents endpoint reference - Increased the documented organization create-operation
  limit for Agents, Sessions, and Vaults from 60 RPM to 300 RPM.
- Tool Description: WebSearch - Renamed the current-month template variable from
  `${GET_CURRENT_MONTH_YEAR()}` to `${CURRENT_MONTH_YEAR}` and updated the recent-search guidance
  to use the new variable form.
```

### CC 2.1.119 (from upstream changelog)

```
- Settings now persist to `~/.claude/settings.json` with project/local/policy override support
- Added `prUrlTemplate` setting for custom code-review URLs
- `--from-pr` expanded to support GitLab, Bitbucket, and GitHub Enterprise
- Print mode now honors agent `tools:` and `disallowedTools:` frontmatter
- PowerShell commands can now be auto-approved in permission mode
- Hook inputs include `duration_ms` for tool execution timing
- MCP servers connect in parallel instead of serially during reconfiguration
- Vim mode: Esc in INSERT no longer retrieves queued messages
- Slash command suggestions highlight matching characters
- Various bug fixes including CRLF paste handling, MCP OAuth issues, and UI rendering
```

### CC 2.1.118 (from upstream changelog)

```
- Added vim visual mode (`v`) and visual-line mode (`V`)
- Merged `/cost` and `/stats` into unified `/usage` command
- Custom themes can be created/edited via `/theme` or `~/.claude/themes/`
- Hooks support `type: "mcp_tool"` for direct MCP tool invocation
- Added `DISABLE_UPDATES` env var for stricter update blocking
- WSL can inherit Windows-side managed settings
- Auto mode: include `"$defaults"` to extend built-in rules
- `/model` picker honors `ANTHROPIC_DEFAULT_*_MODEL_NAME` overrides
- MCP OAuth token handling improved for servers omitting `expires_in`
- Multiple MCP authentication fixes
```

### System-prompts 2.1.119

```
- **NEW:** Agent Prompt: Background agent state classifier - Classifies the tail of a background
  agent transcript as working, blocked, done, or failed and returns concise state JSON.
- **NEW:** Data: Assistant voice and values template - Template content for an `assistant.md` file
  describing Claude's voice, values, and communication style.
- **NEW:** Data: Background agent state classification examples - Example assistant-message tails
  and JSON outputs for classifying background agent state, tempo, needs, and result.
- **NEW:** Data: Managed Agents memory stores reference - Reference documentation for Managed Agents
  memory stores, including store creation, session attachment, FUSE mounts, memory CRUD, concurrency,
  versions, redaction, and endpoint paths.
- **NEW:** Data: User profile memory template - Template content for the user profile memory file,
  covering personal details, work context, schedule, and communication preferences.
- **NEW:** System Prompt: Background session instructions - Instructs background job sessions to use
  the job-specific temporary directory and follow the appropriate worktree isolation guidance.
- **NEW:** System Prompt: Dream CLAUDE.md memory reconciliation - Instructs dream memory consolidation
  to reconcile feedback and project memories against CLAUDE.md, deleting stale memories or flagging
  possible CLAUDE.md drift.
- **NEW:** System Reminder: Previously invoked skills - Restores skills invoked before conversation
  compaction as context only, warning not to re-execute setup actions or treat prior inputs as
  current instructions.
- **NEW:** Skill: /catch-up periodic heartbeat - Skill for the `/catch-up` heartbeat that scans
  priorities, triages actionable changes, reports a short digest, and updates catch-up state.
- **NEW:** Skill: /dream memory consolidation - Skill for the `/dream` nightly housekeeping job
  that consolidates recent logs and transcripts into persistent memory topics, learnings, and a
  pruned MEMORY.md index.
- **NEW:** Skill: /morning-checkin daily brief - Skill for the `/morning-checkin` scheduled task
  that prepares a daily calendar and inbox digest, schedules pre-meeting check-ins, and records
  the day's top priority.
- **NEW:** Skill: /pre-meeting-checkin event brief - Skill for the `/pre-meeting-checkin` task
  that gathers event materials, recent thread context, open questions, and a concise meeting brief.
- **REMOVED:** System Reminder: Invoked skills - Replaced by the new "Previously invoked skills"
  reminder, which adds explicit context-only framing post-compaction.
- Agent Prompt: Security monitor for autonomous agent actions - Added an encoded/obfuscated command
  rule requiring base64, PowerShell encoded commands, hex/char-array reassembly, and similar payloads
  to be decoded and evaluated before allowing; unverifiable payloads are blocked. Expanded block rules
  with PowerShell and Windows equivalents for remote code execution, remote shell access, production
  reads, security weakening, irreversible local destruction, credential exploration, and unauthorized
  persistence.
- Agent Prompt: Status line setup - Documented two new optional JSON fields passed to the `statusLine`
  command: `effort` with `level` values `low`, `medium`, `high`, `xhigh`, or `max`, and `thinking.enabled`
  indicating whether extended thinking is on.
- Agent Prompt: Dream memory consolidation - Added hooks for the new CLAUDE.md reconciliation block
  and an additional-guidance extension point near the index-pruning step.
- Data: Managed Agents core concepts - Documented memory stores as session resources in `resources[]`,
  including that memory stores attach at session creation time only and cannot be added later with
  `resources.add()`.
- Data: Managed Agents endpoint reference - Added Memory Stores, Memories, and Memory Versions endpoint
  tables, including store CRUD/archive, memory create/list/retrieve/update/delete semantics,
  conflict/precondition errors, `view: "basic"|"full"`, 100KB memory limits, immutable memory versions,
  and redaction behavior.
- Data: Managed Agents environments and resources - Documented `memory_store` resources for sessions,
  including the max of 8 memory stores per session and a pointer to the memory-store reference.
- Data: Managed Agents overview - Added memory stores to Managed Agents beta-resource documentation,
  SDK auto-beta guidance, and the archive-is-permanent warning.
- Skill: Building LLM-powered applications with Claude - Updated the Managed Agents SDK auto-beta
  namespace list to include `memory_stores`.
- Skill: /init CLAUDE.md and skill setup (new version) - Restructured `/init` around an initial
  CLAUDE.md existence check, added review/improve, leave, and start-fresh paths, added a plain-text
  primer before the first question, added a "Let Claude decide" fast path, changed proposal presentation
  to normal assistant text, treats skills/hooks answers as hints rather than hard filters, and adds an
  approval-gated diff flow for improving an existing CLAUDE.md.
- Tool Description: Background monitor (streaming events) - Added an explicit decision framework for
  choosing between Bash `run_in_background` and the monitor based on notification count, a worked
  `gh pr checks` polling example, and warnings against unbounded commands for single-notification
  use cases, including why `tail -f log | grep -m 1 ...` can still hang.
```

### System-prompts 2.1.118

```
- **NEW:** Data: Anthropic CLI - Reference documentation for the `ant` CLI covering installation,
  authentication, command structure, input/output shaping, managed agents workflows, and scripting patterns.
- **NEW:** System Prompt: Proactive schedule offer after follow-up work - Instructs the agent to offer
  a one-line `/schedule` follow-up only when completed work has a strong natural future action and
  the user is likely to want it.
- **NEW:** System Prompt: WSL managed settings double opt-in - Explains that WSL can read the Windows
  managed settings policy chain only when the admin-enabled flag is set, with HKCU requiring an
  additional user opt-in.
- **NEW:** System Reminder: Plan mode approval tool enforcement - Requires plan mode turns to end
  with either AskUserQuestion (for clarification) or ExitPlanMode (for plan approval), and forbids
  asking for approval any other way.
- **NEW:** Tool Description: Schedule proactive offer guidance - Explains when to use the scheduling
  tool for recurring or one-time remote agents and when to proactively offer scheduling after
  successful work.
- **REMOVED:** Agent Prompt: Agent Hook - Stop-condition verifier prompt removed.
- **REMOVED:** System Prompt: Teammate Communication - Swarm-mode teammate communication prompt
  removed; the broadcast (`to: "*"`) option also dropped from the agent-teams SendMessageTool description.
- **REMOVED:** System Reminder: Post-turn session summary - The structured-JSON inbox-triage summary
  reminder added in 2.1.116 has been removed.
- **REMOVED:** Tool Description: Config - The Config tool for getting/setting Claude Code settings
  has been removed; the Update Claude Code Config skill now suggests the `/config` slash command
  instead of "the Config tool" for simple settings.
- Agent Prompt: Explore, Plan mode (enhanced), Quick git commit, Quick PR creation, REPL tool usage,
  Tool Description: REPL, Tool Description: ReadFile - Generalized shell guidance to support both
  Bash and PowerShell environments: read-only command examples and forbidden-command lists are now
  branched (e.g., `Get-ChildItem`/`Get-Content` vs `ls`/`cat`; `New-Item`/`Remove-Item` vs `mkdir`/`rm`),
  and commit/PR templates emit PowerShell here-strings (`@'...'@` at column 0) instead of bash heredocs
  when running under PowerShell. REPL tips note that `shQuote` is POSIX-only and show the PowerShell
  single-quote-doubling alternative. ReadFile no longer hardcodes "Bash tool" for directory listing,
  referring instead to "the registered shell tool."
- Agent Prompt: /schedule slash command - One-time-run support (`run_once_at`) is now gated behind
  a feature flag: when disabled, all references to one-off scheduling, `run_once_fired`, and the
  current-time anchor are suppressed. When enabled, added a "Current Time" section providing the
  local and UTC time at invocation and **requiring** the agent to re-check `date -u` via Bash before
  computing any `run_once_at` (rather than guessing from conversation context), then echo back both
  local and UTC for confirmation; if the resolved time is in the past, ask for clarification rather
  than rolling forward. Also removed the hardcoded opening AskUserQuestion prompt (skipped when the
  user request is already known).
- Agent Prompt: Managed Agents onboarding flow - Setup block now defaults to emitting **YAML files +
  `ant` CLI commands** (`<name>.agent.yaml`, `<name>.environment.yaml`, `ant beta:agents create`/
  `update --version N`) so agents and environments can be checked into the repo and applied from CI;
  SDK setup code is now a fallback. Runtime block remains SDK code in the detected language because
  it must react programmatically to events.
- Agent Prompt: Status line setup - Documented two additional vim modes (`VISUAL`, `VISUAL LINE`)
  for the `vim.mode` status field.
- Agent Prompt: Verification specialist - Replaced inline temp-script guidance with a templated block
  (so Bash vs PowerShell guidance can be substituted).
- Data: Claude API reference - Python - Added "Client Configuration" section covering `with_options()`
  per-request overrides, request timeouts (`httpx.Timeout`, `APITimeoutError`), retry behavior
  (auto-retries on 408/409/429/>=500 with `max_retries`), the `aiohttp` async backend
  (`DefaultAioHttpClient`), custom HTTP clients via `DefaultHttpxClient`/`DefaultAsyncHttpxClient`
  for proxies and base URLs, and `ANTHROPIC_LOG` debug logging. Added "Response Helpers" section
  covering `_request_id`, `to_json()`/`to_dict()`, and `.with_raw_response` for accessing raw headers.
- Data: Files API reference - Python - Documented additional `file=` argument forms (`pathlib.Path`/
  `PathLike`, open binary file object) and that iterating `client.beta.files.list()` directly
  auto-paginates across all pages.
- Data: Managed Agents core concepts - Added `ant` CLI examples for session ops (list/retrieve/stream
  events/archive/delete) and a recommendation to define agents and environments as version-controlled
  YAML applied via the CLI ("CLI for the control plane, SDK for the data plane"), with `agents.create()`
  reframed as the in-code equivalent for programmatic provisioning.
- Data: Managed Agents overview - Added documentation routing entry pointing users wanting
  version-controlled YAML definitions and shell-driven API calls to `shared/anthropic-cli.md`.
- Data: Message Batches API reference - Python - Added "List Batches (auto-pagination)" section
  explaining that iterating `client.messages.batches.list()` auto-paginates and documenting manual
  cursor controls (`has_next_page()`, `get_next_page()`, `next_page_info()`, `last_id`).
- Data: Streaming reference - Python - Added "Low-level: `stream=True`" section showing how to pass
  `stream=True` to `messages.create()` for the raw event iterator (with no auto-accumulation), and
  added a best-practice note that large `max_tokens` without streaming raises `ValueError` because
  the SDK refuses non-streaming requests estimated to exceed ~10 minutes.
- Skill: Build with Claude API (reference guide) - Added explicit routing entry pointing users to
  `shared/anthropic-cli.md` for terminal access, version-controlled YAML, and scripting.
- Skill: Building LLM-powered applications with Claude - Updated Managed Agents callouts in three
  places to refer to the Anthropic CLI by its binary name (`ant`) and point at the dedicated
  `shared/anthropic-cli.md` reference instead of `shared/live-sources.md`.
- System Reminder: Plan mode is active (5-phase) - Restructured to use templated workflow-instructions
  and phase-five blocks (the user-visible "must use ExitPlanMode for plan approval" enforcement now
  lives in the new Plan mode approval tool enforcement reminder).
```

---

## Stage 2: Verification Results
### Verified: 2026-04-25

#### Must Update Verification

**High-Priority Plugin-Relevant Items:**
- [x] **Hooks `type: "mcp_tool"`** (CC 2.1.118) -- CONFIRMED in CC changelog. Gap exists: hook-development/overview.md lists types as `command|http|prompt|agent` but not `mcp_tool`. Affects: hook-development
- [x] **Hook `duration_ms` input** (CC 2.1.119) -- CONFIRMED in CC changelog: "PostToolUse and PostToolUseFailure hooks now include `duration_ms` field". Gap exists: not documented in hook-development references. Affects: hook-development
- [x] **Print mode agent frontmatter enforcement** (CC 2.1.119) -- CONFIRMED in CC changelog: "`--print` mode now honors agent `tools:` and `disallowedTools:` frontmatter". Gap exists: agent-development does not mention print mode behavior. Affects: agent-development
- [x] **Auto mode `$defaults` extension** (CC 2.1.118) -- CONFIRMED in CC changelog. Gap exists: not documented in plugin-dev permissions references. Affects: permissions patterns
- [x] **Config tool removal** (CC 2.1.118) -- CONFIRMED in system-prompts changelog. Gap check: plugin-dev references mention Config tool in agent-development overview.md line 246 ("Configuration: `Config` (CC 2.1.88)"). This needs updating. Affects: agent-development
- [x] **Write tool read-first requirement** (CC 2.1.120) -- CONFIRMED in system-prompts changelog. Gap exists: skill examples may reference Write without read-first pattern. Affects: skill examples
- [x] **PowerShell support expansion** (CC 2.1.118-2.1.119) -- CONFIRMED in both sources. Gap exists: hook scripts and examples are Bash-only. Affects: hook-development, command-development
- [x] **Previously invoked skills compaction** (CC 2.1.119) -- CONFIRMED in system-prompts changelog. Gap exists: skill-development does not document this lifecycle behavior. Affects: skill-development
- [x] **Teammate Communication broadcast removed** (CC 2.1.118) -- CONFIRMED in system-prompts changelog. Gap check: agent-teams documentation should remove `to: "*"` references. Affects: agent-development teams

**Other Must Update Items (verified):**
- [x] Settings persist to `~/.claude/settings.json` (CC 2.1.119) -- CONFIRMED. Partially documented in plugin-settings. Minor gap.
- [x] BrowserBatch tool (CC 2.1.120) -- CONFIRMED in system-prompts. New tool, not plugin-specific but affects tool references.
- [x] Harness/Memory instructions (CC 2.1.120) -- CONFIRMED. Internal prompts, low plugin relevance.
- [x] Background agent state classifier (CC 2.1.119) -- CONFIRMED. Affects agent reference conceptually.
- [x] Background session instructions (CC 2.1.119) -- CONFIRMED. Affects background job agents.
- [x] Scheduled skills /catch-up /dream /morning-checkin /pre-meeting-checkin (CC 2.1.119) -- CONFIRMED. New built-in skills.
- [x] Plan mode approval tool enforcement (CC 2.1.118) -- CONFIRMED. Internal prompt enforcement.
- [x] WSL managed settings (CC 2.1.118) -- CONFIRMED in both sources. Windows-specific.
- [x] Anthropic CLI (`ant`) reference (CC 2.1.118) -- CONFIRMED. Affects managed-agents skill.
- [x] Schedule proactive offer guidance (CC 2.1.118) -- CONFIRMED. Scheduling-related.
- [x] /init skill restructured (CC 2.1.119) -- CONFIRMED. Internal workflow.
- [x] Security monitor encoded command rule (CC 2.1.119) -- CONFIRMED. Security-related.
- [x] Status line effort/thinking fields (CC 2.1.119) -- CONFIRMED. UI/status-related.
- [x] Monitor tool decision framework (CC 2.1.119) -- CONFIRMED. Background monitor guidance.
- [x] Dream memory log format change (CC 2.1.120) -- CONFIRMED. Memory consolidation internal.
- [x] WebSearch template variable rename (CC 2.1.120) -- CONFIRMED. Tool description change.
- [x] Security monitor settings_deny_rules (CC 2.1.120) -- CONFIRMED. Security extension point.
- [x] Managed Agents RPM limit increase (CC 2.1.120) -- CONFIRMED. API rate limit change.
- [x] Managed Agents memory stores (CC 2.1.119) -- CONFIRMED. New managed agents feature.
- [x] Vim visual mode (CC 2.1.118) -- CONFIRMED in both sources. UI feature.
- [x] `/cost` `/stats` merged to `/usage` (CC 2.1.118) -- CONFIRMED. Command change.
- [x] Custom themes (CC 2.1.118) -- CONFIRMED. Customization feature.

**Reclassification:**
- ! **Agent Hook stop-condition verifier REMOVED** (CC 2.1.118) -- This was noted in system-prompts as REMOVED but not prominently listed in Must Update. Should be noted as internal prompt removal.

#### Missed Items (promoted from No Action)

- ! **Plugins pinned by version constraint auto-update** (CC 2.1.119) -- MISSED
  - Source: CC changelog "Plugins pinned by another plugin's version constraint auto-update to highest satisfying git tag"
  - Affects: plugin-structure (dependency management)
  - Details: When a plugin depends on another plugin with a version constraint, the dependent plugin now auto-updates to the highest satisfying git tag rather than being locked to the original version.

- ! **`--agent <name>` honors agent permissionMode** (CC 2.1.119) -- MISSED
  - Source: CC changelog "`--agent <name>` honors agent definition's `permissionMode` for built-in agents"
  - Affects: agent-development (permissionMode documentation)
  - Details: When launching an agent via `--agent`, the CLI now respects the agent's frontmatter `permissionMode`.

- ! **`blockedMarketplaces` enforcement fix** (CC 2.1.119) -- MISSED (but is a bug fix)
  - Source: CC changelog "Security: `blockedMarketplaces` now correctly enforces `hostPattern` and `pathPattern` entries"
  - Affects: marketplace-structure (managed settings)
  - Details: Bug fix for marketplace blocking patterns.

- ! **Agent tool worktree reuse fix** (CC 2.1.119) -- MISSED
  - Source: CC changelog "Fixed Agent tool with `isolation: \"worktree\"` reusing stale worktrees"
  - Affects: agent-development (worktree isolation)
  - Details: Bug fix for agent worktree isolation behavior.

#### May Update Resolution

- = **MCP servers connect in parallel** (CC 2.1.119) -- kept as May Update: performance improvement, low documentation impact
- = **Vim mode Esc behavior** (CC 2.1.119) -- kept as May Update: UI behavior, not plugin-related
- = **Slash command suggestions** (CC 2.1.119) -- kept as May Update: UI polish
- = **`prUrlTemplate` setting** (CC 2.1.119) -- kept as May Update: settings feature, may warrant mention
- = **`--from-pr` platform expansion** (CC 2.1.119) -- kept as May Update: CLI feature
- = **`DISABLE_UPDATES` env var** (CC 2.1.118) -- kept as May Update: environment variable
- = **`/model` picker env var honors** (CC 2.1.118) -- kept as May Update: model selection
- = **MCP OAuth improvements** (CC 2.1.118-2.1.119) -- kept as May Update: already partially covered in MCP docs
- = **/security-review ALLOWED_TOOLS variable** (CC 2.1.120) -- kept as May Update: internal skill template

#### Summary

| Category | Original | Verified | Added | Rejected |
|----------|----------|----------|-------|----------|
| Must Update | 33 | 32 | +4 (missed items) | 1 (reclassified to internal) |
| May Update | 9 | 9 (unchanged) | 0 | 0 |
| No Action | 5 | reduced by 3 (promoted) | -- | -- |

**Final Must Update Count:** 35 items (32 confirmed + 3 plugin-relevant missed items)

**Confidence:** HIGH
- Version range verified (2.1.118-2.1.120)
- All high-priority items confirmed in primary sources
- 4 missed items identified (3 plugin-relevant, 1 bug fix)
- No significant rejections (>30% threshold not triggered)
- Stage 1 quality is acceptable

**Critical Gaps Verified:**
1. `type: "mcp_tool"` hook type not documented (hook-development/overview.md)
2. `duration_ms` hook input not documented (hook-development references)
3. Print mode frontmatter enforcement not documented (agent-development)
4. `$defaults` auto mode pattern not documented
5. Config tool removed but still referenced at agent-development/overview.md line 246
6. Write tool read-first requirement not in skill examples
7. PowerShell support not in hook/command examples
8. Previously invoked skills compaction not in skill-development
9. Teammate broadcast `to: "*"` removal not documented
10. Plugin version constraint auto-update not documented (MISSED by Stage 1)
11. Agent `--agent` respects permissionMode not documented (MISSED by Stage 1)
  `${GET_CURRENT_MONTH_YEAR()}` to `${CURRENT_MONTH_YEAR}` and updated the recent-search guidance
  to use the new variable form.
```

### CC 2.1.119 (from upstream changelog)

```
- Settings now persist to `~/.claude/settings.json` with project/local/policy override support
- Added `prUrlTemplate` setting for custom code-review URLs
- `--from-pr` expanded to support GitLab, Bitbucket, and GitHub Enterprise
- Print mode now honors agent `tools:` and `disallowedTools:` frontmatter
- PowerShell commands can now be auto-approved in permission mode
- Hook inputs include `duration_ms` for tool execution timing
- MCP servers connect in parallel instead of serially during reconfiguration
- Vim mode: Esc in INSERT no longer retrieves queued messages
- Slash command suggestions highlight matching characters
- Various bug fixes including CRLF paste handling, MCP OAuth issues, and UI rendering
```

### CC 2.1.118 (from upstream changelog)

```
- Added vim visual mode (`v`) and visual-line mode (`V`)
- Merged `/cost` and `/stats` into unified `/usage` command
- Custom themes can be created/edited via `/theme` or `~/.claude/themes/`
- Hooks support `type: "mcp_tool"` for direct MCP tool invocation
- Added `DISABLE_UPDATES` env var for stricter update blocking
- WSL can inherit Windows-side managed settings
- Auto mode: include `"$defaults"` to extend built-in rules
- `/model` picker honors `ANTHROPIC_DEFAULT_*_MODEL_NAME` overrides
- MCP OAuth token handling improved for servers omitting `expires_in`
- Multiple MCP authentication fixes
```

### System-prompts 2.1.119

```
- **NEW:** Agent Prompt: Background agent state classifier - Classifies the tail of a background
  agent transcript as working, blocked, done, or failed and returns concise state JSON.
- **NEW:** Data: Assistant voice and values template - Template content for an `assistant.md` file
  describing Claude's voice, values, and communication style.
- **NEW:** Data: Background agent state classification examples - Example assistant-message tails
  and JSON outputs for classifying background agent state, tempo, needs, and result.
- **NEW:** Data: Managed Agents memory stores reference - Reference documentation for Managed Agents
  memory stores, including store creation, session attachment, FUSE mounts, memory CRUD, concurrency,
  versions, redaction, and endpoint paths.
- **NEW:** Data: User profile memory template - Template content for the user profile memory file,
  covering personal details, work context, schedule, and communication preferences.
- **NEW:** System Prompt: Background session instructions - Instructs background job sessions to use
  the job-specific temporary directory and follow the appropriate worktree isolation guidance.
- **NEW:** System Prompt: Dream CLAUDE.md memory reconciliation - Instructs dream memory consolidation
  to reconcile feedback and project memories against CLAUDE.md, deleting stale memories or flagging
  possible CLAUDE.md drift.
- **NEW:** System Reminder: Previously invoked skills - Restores skills invoked before conversation
  compaction as context only, warning not to re-execute setup actions or treat prior inputs as
  current instructions.
- **NEW:** Skill: /catch-up periodic heartbeat - Skill for the `/catch-up` heartbeat that scans
  priorities, triages actionable changes, reports a short digest, and updates catch-up state.
- **NEW:** Skill: /dream memory consolidation - Skill for the `/dream` nightly housekeeping job
  that consolidates recent logs and transcripts into persistent memory topics, learnings, and a
  pruned MEMORY.md index.
- **NEW:** Skill: /morning-checkin daily brief - Skill for the `/morning-checkin` scheduled task
  that prepares a daily calendar and inbox digest, schedules pre-meeting check-ins, and records
  the day's top priority.
- **NEW:** Skill: /pre-meeting-checkin event brief - Skill for the `/pre-meeting-checkin` task
  that gathers event materials, recent thread context, open questions, and a concise meeting brief.
- **REMOVED:** System Reminder: Invoked skills - Replaced by the new "Previously invoked skills"
  reminder, which adds explicit context-only framing post-compaction.
- Agent Prompt: Security monitor for autonomous agent actions - Added an encoded/obfuscated command
  rule requiring base64, PowerShell encoded commands, hex/char-array reassembly, and similar payloads
  to be decoded and evaluated before allowing; unverifiable payloads are blocked. Expanded block rules
  with PowerShell and Windows equivalents for remote code execution, remote shell access, production
  reads, security weakening, irreversible local destruction, credential exploration, and unauthorized
  persistence.
- Agent Prompt: Status line setup - Documented two new optional JSON fields passed to the `statusLine`
  command: `effort` with `level` values `low`, `medium`, `high`, `xhigh`, or `max`, and `thinking.enabled`
  indicating whether extended thinking is on.
- Agent Prompt: Dream memory consolidation - Added hooks for the new CLAUDE.md reconciliation block
  and an additional-guidance extension point near the index-pruning step.
- Data: Managed Agents core concepts - Documented memory stores as session resources in `resources[]`,
  including that memory stores attach at session creation time only and cannot be added later with
  `resources.add()`.
- Data: Managed Agents endpoint reference - Added Memory Stores, Memories, and Memory Versions endpoint
  tables, including store CRUD/archive, memory create/list/retrieve/update/delete semantics,
  conflict/precondition errors, `view: "basic"|"full"`, 100KB memory limits, immutable memory versions,
  and redaction behavior.
- Data: Managed Agents environments and resources - Documented `memory_store` resources for sessions,
  including the max of 8 memory stores per session and a pointer to the memory-store reference.
- Data: Managed Agents overview - Added memory stores to Managed Agents beta-resource documentation,
  SDK auto-beta guidance, and the archive-is-permanent warning.
- Skill: Building LLM-powered applications with Claude - Updated the Managed Agents SDK auto-beta
  namespace list to include `memory_stores`.
- Skill: /init CLAUDE.md and skill setup (new version) - Restructured `/init` around an initial
  CLAUDE.md existence check, added review/improve, leave, and start-fresh paths, added a plain-text
  primer before the first question, added a "Let Claude decide" fast path, changed proposal presentation
  to normal assistant text, treats skills/hooks answers as hints rather than hard filters, and adds an
  approval-gated diff flow for improving an existing CLAUDE.md.
- Tool Description: Background monitor (streaming events) - Added an explicit decision framework for
  choosing between Bash `run_in_background` and the monitor based on notification count, a worked
  `gh pr checks` polling example, and warnings against unbounded commands for single-notification
  use cases, including why `tail -f log | grep -m 1 ...` can still hang.
```

### System-prompts 2.1.118

```
- **NEW:** Data: Anthropic CLI - Reference documentation for the `ant` CLI covering installation,
  authentication, command structure, input/output shaping, managed agents workflows, and scripting patterns.
- **NEW:** System Prompt: Proactive schedule offer after follow-up work - Instructs the agent to offer
  a one-line `/schedule` follow-up only when completed work has a strong natural future action and
  the user is likely to want it.
- **NEW:** System Prompt: WSL managed settings double opt-in - Explains that WSL can read the Windows
  managed settings policy chain only when the admin-enabled flag is set, with HKCU requiring an
  additional user opt-in.
- **NEW:** System Reminder: Plan mode approval tool enforcement - Requires plan mode turns to end
  with either AskUserQuestion (for clarification) or ExitPlanMode (for plan approval), and forbids
  asking for approval any other way.
- **NEW:** Tool Description: Schedule proactive offer guidance - Explains when to use the scheduling
  tool for recurring or one-time remote agents and when to proactively offer scheduling after
  successful work.
- **REMOVED:** Agent Prompt: Agent Hook - Stop-condition verifier prompt removed.
- **REMOVED:** System Prompt: Teammate Communication - Swarm-mode teammate communication prompt
  removed; the broadcast (`to: "*"`) option also dropped from the agent-teams SendMessageTool description.
- **REMOVED:** System Reminder: Post-turn session summary - The structured-JSON inbox-triage summary
  reminder added in 2.1.116 has been removed.
- **REMOVED:** Tool Description: Config - The Config tool for getting/setting Claude Code settings
  has been removed; the Update Claude Code Config skill now suggests the `/config` slash command
  instead of "the Config tool" for simple settings.
- Agent Prompt: Explore, Plan mode (enhanced), Quick git commit, Quick PR creation, REPL tool usage,
  Tool Description: REPL, Tool Description: ReadFile - Generalized shell guidance to support both
  Bash and PowerShell environments: read-only command examples and forbidden-command lists are now
  branched (e.g., `Get-ChildItem`/`Get-Content` vs `ls`/`cat`; `New-Item`/`Remove-Item` vs `mkdir`/`rm`),
  and commit/PR templates emit PowerShell here-strings (`@'...'@` at column 0) instead of bash heredocs
  when running under PowerShell. REPL tips note that `shQuote` is POSIX-only and show the PowerShell
  single-quote-doubling alternative. ReadFile no longer hardcodes "Bash tool" for directory listing,
  referring instead to "the registered shell tool."
- Agent Prompt: /schedule slash command - One-time-run support (`run_once_at`) is now gated behind
  a feature flag: when disabled, all references to one-off scheduling, `run_once_fired`, and the
  current-time anchor are suppressed. When enabled, added a "Current Time" section providing the
  local and UTC time at invocation and **requiring** the agent to re-check `date -u` via Bash before
  computing any `run_once_at` (rather than guessing from conversation context), then echo back both
  local and UTC for confirmation; if the resolved time is in the past, ask for clarification rather
  than rolling forward. Also removed the hardcoded opening AskUserQuestion prompt (skipped when the
  user request is already known).
- Agent Prompt: Managed Agents onboarding flow - Setup block now defaults to emitting **YAML files +
  `ant` CLI commands** (`<name>.agent.yaml`, `<name>.environment.yaml`, `ant beta:agents create`/
  `update --version N`) so agents and environments can be checked into the repo and applied from CI;
  SDK setup code is now a fallback. Runtime block remains SDK code in the detected language because
  it must react programmatically to events.
- Agent Prompt: Status line setup - Documented two additional vim modes (`VISUAL`, `VISUAL LINE`)
  for the `vim.mode` status field.
- Agent Prompt: Verification specialist - Replaced inline temp-script guidance with a templated block
  (so Bash vs PowerShell guidance can be substituted).
- Data: Claude API reference - Python - Added "Client Configuration" section covering `with_options()`
  per-request overrides, request timeouts (`httpx.Timeout`, `APITimeoutError`), retry behavior
  (auto-retries on 408/409/429/>=500 with `max_retries`), the `aiohttp` async backend
  (`DefaultAioHttpClient`), custom HTTP clients via `DefaultHttpxClient`/`DefaultAsyncHttpxClient`
  for proxies and base URLs, and `ANTHROPIC_LOG` debug logging. Added "Response Helpers" section
  covering `_request_id`, `to_json()`/`to_dict()`, and `.with_raw_response` for accessing raw headers.
- Data: Files API reference - Python - Documented additional `file=` argument forms (`pathlib.Path`/
  `PathLike`, open binary file object) and that iterating `client.beta.files.list()` directly
  auto-paginates across all pages.
- Data: Managed Agents core concepts - Added `ant` CLI examples for session ops (list/retrieve/stream
  events/archive/delete) and a recommendation to define agents and environments as version-controlled
  YAML applied via the CLI ("CLI for the control plane, SDK for the data plane"), with `agents.create()`
  reframed as the in-code equivalent for programmatic provisioning.
- Data: Managed Agents overview - Added documentation routing entry pointing users wanting
  version-controlled YAML definitions and shell-driven API calls to `shared/anthropic-cli.md`.
- Data: Message Batches API reference - Python - Added "List Batches (auto-pagination)" section
  explaining that iterating `client.messages.batches.list()` auto-paginates and documenting manual
  cursor controls (`has_next_page()`, `get_next_page()`, `next_page_info()`, `last_id`).
- Data: Streaming reference - Python - Added "Low-level: `stream=True`" section showing how to pass
  `stream=True` to `messages.create()` for the raw event iterator (with no auto-accumulation), and
  added a best-practice note that large `max_tokens` without streaming raises `ValueError` because
  the SDK refuses non-streaming requests estimated to exceed ~10 minutes.
- Skill: Build with Claude API (reference guide) - Added explicit routing entry pointing users to
  `shared/anthropic-cli.md` for terminal access, version-controlled YAML, and scripting.
- Skill: Building LLM-powered applications with Claude - Updated Managed Agents callouts in three
  places to refer to the Anthropic CLI by its binary name (`ant`) and point at the dedicated
  `shared/anthropic-cli.md` reference instead of `shared/live-sources.md`.
- System Reminder: Plan mode is active (5-phase) - Restructured to use templated workflow-instructions
  and phase-five blocks (the user-visible "must use ExitPlanMode for plan approval" enforcement now
  lives in the new Plan mode approval tool enforcement reminder).
```
