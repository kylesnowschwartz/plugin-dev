# Upstream Change Manifest
## CC Version Range: 2.1.89 - 2.1.89
## Generated: 2026-04-01
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped]

Note: Only one new version (2.1.89) since last audit at 2.1.88.

---

### Must Update

- [ ] **PreToolUse hooks: "defer" permission decision** (CC 2.1.89)
  - Source: CC changelog
  - Confidence: high
  - Affects: hooks skill
  - Details: PreToolUse hooks can now return "defer" to pause tool calls for later decision in headless sessions. This is a new permissionDecision value that plugin developers need to know about. Previously hooks could return "allow", "deny", or "ask" -- "defer" is a fourth option.
  - Raw changelog: `Added "defer" permission decision to PreToolUse hooks for paused tool calls`
  - Gap: hook-development/SKILL.md PreToolUse section (lines 292-333) lists "allow|deny|ask" but not "defer"

- [ ] **Hook output >50K saved to disk with preview** (CC 2.1.89)
  - Source: CC changelog
  - Confidence: high
  - Affects: hooks skill
  - Details: Large hook outputs (>50K characters) are now automatically saved to disk with a preview shown. This affects how hooks behave with large outputs and should be documented as a hook output limit/behavior.
  - Raw changelog: `Changed hook output >50K characters saved to disk with preview`
  - Gap: hook-development/SKILL.md does not document this output limit behavior

- [ ] **TaskCreated hook event** (CC 2.1.84, undocumented in plugin-dev)
  - Source: CC changelog 2.1.84 (original addition)
  - Confidence: high
  - Affects: hooks skill (hook events list)
  - Details: The TaskCreated hook event was added in CC 2.1.84. Plugin-dev's hook-development skill lists 25 events but does NOT include TaskCreated -- only TeammateIdle and TaskCompleted are in the Teams category. This is a gap that needs to be filled.
  - Gap: hook-development/SKILL.md lists 25 events but TaskCreated is missing from the Teams category and event list

- [ ] **MCP Tool Result Truncation guidance** (CC 2.1.89)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: mcp-integration skill
  - Details: Added guidelines for handling long outputs from MCP tools, including when to use direct file queries vs subagents for analysis. Relevant for plugin MCP server developers.
  - Raw changelog: `**NEW:** System Prompt: MCP Tool Result Truncation -- Added guidelines for handling long outputs from MCP tools, including when to use direct file queries vs subagents for analysis.`
  - Gap: mcp-integration/SKILL.md has "MCP Output Limits" section but not truncation handling guidance

- [ ] **Security monitor expanded: new blocked categories** (CC 2.1.89)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: agent-development skill (auto mode / permissionMode guidance)
  - Details: Significant expansion of blocked categories for autonomous agents:
    - "Irreversible Local Destruction" now blocks mv/cp/Write/Edit onto existing untracked or out-of-repo paths (no git recovery)
    - NEW "Create Public Surface" blocks creating public repos, changing repo visibility, or publishing to public registries
    - "Expose Local Services" expanded to cover mounting host paths into containers
    - "Credential Leakage" note: committing credentials to public repo counts even if trusted
    - "Unauthorized Persistence" now includes git hooks
  - Raw changelog: `Agent Prompt: Security monitor for autonomous agent actions (second part) -- Expanded...`
  - Gap: agent-development/SKILL.md has permissionMode documentation but does not detail security monitor restrictions for autonomous agents

---

### May Update

- [ ] **NEW: Buddy Mode (April Fools)** (CC 2.1.89)
  - Source: CC changelog + system-prompts changelog
  - Confidence: high
  - Affects: slash commands documentation (low priority - seasonal/novelty feature)
  - Details: /buddy command for April 1st easter egg. Generates coding companions that live in the terminal and comment on developer's work, with focus on creating memorable, distinct personalities based on stats and inspiration words.
  - Raw changelog: `/buddy added for April 1st easter egg`

- [ ] **Named subagents in @mention typeahead** (CC 2.1.89)
  - Source: CC changelog
  - Confidence: medium
  - Affects: agent documentation
  - Details: Named subagents now appear in @mention typeahead for easier reference. UX improvement for agent users.
  - Raw changelog: `Added named subagents to @mention typeahead`

- [ ] **Prompt Caching documentation updates** (CC 2.1.89)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: claude-api skill (reference material)
  - Details: Added model-specific minimum cacheable prefix table (ranging from 1024 to 4096 tokens by model). Updated cache write economics to distinguish 5-minute TTL (1.25x) from 1-hour TTL (2x) pricing with break-even analysis. Added clarification that input_tokens is the uncached remainder only. Added new sections on invalidation hierarchy (three cache tiers), 20-block lookback window limit, and concurrent-request timing with fan-out workaround.
  - Raw changelog: `Data: Prompt Caching -- Design & Optimization -- Added model-specific minimum cacheable prefix table (ranging from 1024 to 4096 tokens by model). Updated cache write economics to distinguish 5-minute TTL (1.25x) from 1-hour TTL (2x) pricing with break-even analysis...`

- [ ] **NEW: Remote plan mode (ultraplan) prompts** (CC 2.1.89)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: plan mode documentation
  - Details: New system prompts for remote planning sessions that instruct Claude to explore codebase, produce diagram-rich plans via ExitPlanMode, and implement with pull requests upon approval.
  - Raw changelog: `**NEW:** System Prompt: Remote plan mode (ultraplan)` + `**NEW:** System Prompt: Remote planning session`

---

### No Action

- NEW: Computer Use MCP skill (CC 2.1.89) - CC internal skill, not relevant to plugin development
- Agent tool: additional info block support (CC 2.1.89) - CC internal prompt structure, not plugin-facing
- Verification specialist agent substantially expanded (CC 2.1.89) - CC internal agent prompt, not plugin-dev's update-reviewer
- CLAUDE_CODE_NO_FLICKER environment variable (CC 2.1.89) - internal rendering option
- MCP_CONNECTION_NONBLOCKING=true for -p mode (CC 2.1.89) - internal optimization
- Auto mode denied commands notification in /permissions (CC 2.1.89) - UI feature
- PermissionDenied hook firing after auto mode classifier denials (CC 2.1.89) - already documented in 2.1.88 audit
- Fixed symlink target resolution in Edit/Read allow rules (CC 2.1.89) - bug fix
- Fixed voice push-to-talk activation and Windows WebSocket issues (CC 2.1.89) - voice feature bug fix
- Fixed Edit/Write tools handling of CRLF and Markdown line breaks (CC 2.1.89) - bug fix
- Fixed StructuredOutput schema cache bug ~50% failure rate (CC 2.1.89) - bug fix
- Fixed memory leak from large JSON inputs in LRU cache (CC 2.1.89) - performance fix
- Fixed crash removing messages from 50MB+ session files (CC 2.1.89) - bug fix
- Fixed LSP server zombie state after crashes (CC 2.1.89) - bug fix
- Fixed prompt history with CJK/emoji being dropped at boundaries (CC 2.1.89) - bug fix
- Fixed /stats undercounting tokens and losing data beyond 30 days (CC 2.1.89) - bug fix
- Fixed -p --resume hangs with >64KB deferred input (CC 2.1.89) - bug fix
- Fixed claude-cli:// deep links on macOS (CC 2.1.89) - bug fix
- Fixed MCP tool errors truncating multi-element content (CC 2.1.89) - bug fix
- Fixed skill reminders being dropped with image messages (CC 2.1.89) - bug fix
- Fixed PreToolUse/PostToolUse hooks receiving relative paths (CC 2.1.89) - already documented in 2.1.88 audit
- Fixed autocompact thrash loop with actionable error messages (CC 2.1.89) - bug fix
- Fixed prompt cache misses from tool schema changes mid-session (CC 2.1.89) - performance fix
- Fixed nested CLAUDE.md re-injection in long sessions (CC 2.1.89) - bug fix
- Fixed --resume crash with older tool results (CC 2.1.89) - bug fix
- Fixed "Rate limit reached" showing wrong error messages (CC 2.1.89) - bug fix
- Fixed hooks if condition filtering for compound commands (CC 2.1.89) - already documented in 2.1.88 audit
- Multiple UI/rendering fixes (CC 2.1.89) - bug fixes
- Improved collapsed tool summary for ls/tree/du commands (CC 2.1.89) - UI improvement
- Improved Bash tool warning about file modifications (CC 2.1.89) - minor UX
- Improved @-mention typeahead ranking (CC 2.1.89) - UI improvement
- Improved PowerShell tool prompt with version-appropriate syntax (CC 2.1.89) - PowerShell-specific
- Changed Edit to work on files viewed via Bash sed/cat (CC 2.1.89) - minor behavior
- Changed cleanupPeriodDays: 0 rejected with validation error (CC 2.1.89) - config validation
- Changed thinking summaries to not generate by default (CC 2.1.89) - default change
- Preserved task notifications when backgrounding with Ctrl+B (CC 2.1.89) - UI feature
- PowerShell external-command arguments now prompt for safety (CC 2.1.89) - PowerShell-specific
- /env now applies to PowerShell tool commands (CC 2.1.89) - PowerShell-specific
- /usage hides redundant bars for Pro/Enterprise plans (CC 2.1.89) - UI feature
- Image paste no longer inserts trailing space (CC 2.1.89) - UX fix
- Pasting !command enters bash mode matching typed behavior (CC 2.1.89) - UX improvement

---

## Summary

**Version delta:** 2.1.88 -> 2.1.89 (1 version)

**Token impact from system-prompts:** +3,986 tokens (significant increase)

**Key themes in this release (plugin-dev relevant):**
1. **Hook system enhancements:** "defer" decision option, large output handling (>50K to disk), TaskCreated event gap
2. **Security monitor expansion:** New blocked categories for autonomous agents
3. **MCP truncation guidance:** New handling patterns for long MCP outputs

**Recommended priority for Stage 3:**
1. HIGH: Hook documentation updates (defer, output handling, TaskCreated event)
2. HIGH: Security monitor updates (new blocked categories in agent-development)
3. MEDIUM: MCP truncation guidance (in mcp-integration)

**Risk assessment:** The "defer" hook decision and security monitor expansion are highest priority as they directly affect how plugins interact with Claude Code's permission system and autonomous operation safety model.

---

## Stage 2: Verification Results
### Verified: 2026-04-01

#### Must Update Verification
- **PreToolUse hooks: "defer" permission decision** -- CONFIRMED in CC changelog (2.1.89). Gap exists: hook-development/SKILL.md does not document "defer" as a permissionDecision value. The PreToolUse section (lines 292-333) lists "allow|deny|ask" but not "defer".
- **Hook output >50K saved to disk with preview** -- CONFIRMED in CC changelog (2.1.89 Changed section). Gap exists: hook-development/SKILL.md does not document this output limit behavior.
- ! **TaskCreated hook event documented** -- RECLASSIFIED: The raw changelog entry "Documented TaskCreated hook event and blocking behavior" was NOT found in my independent CC changelog fetch for 2.1.89. However, TaskCreated WAS added in CC 2.1.84 (confirmed in my fetch). The hook-development SKILL.md does NOT list TaskCreated among its 25 events -- only TeammateIdle and TaskCompleted are in the Teams category. This is a legitimate gap regardless of the 2.1.89 claim. Item kept in Must Update but source corrected to CC 2.1.84 original addition.
- **NEW: Computer Use MCP skill** -- CONFIRMED in system-prompts changelog (2.1.89). This is an informational item about upstream capabilities; plugin-dev does not need to document this internal CC skill. Demoting to No Action.
- **NEW: MCP Tool Result Truncation guidance** -- CONFIRMED in system-prompts changelog (2.1.89). Gap check: mcp-integration/SKILL.md has "MCP Output Limits" section (lines 663-669) documenting token limits but not truncation handling guidance. May be relevant for plugin MCP server developers. Keeping as Must Update.
- **Agent tool: additional info block support** -- CONFIRMED in system-prompts changelog (2.1.89). This is an internal CC prompt structure change. agent-development/SKILL.md documents agent structure but not the Agent tool's internal description format. This affects CC internals, not plugin development. Demoting to No Action.
- **Verification specialist agent substantially expanded** -- CONFIRMED in system-prompts changelog (2.1.89). This is about CC's internal verification agent, not plugin-dev's update-reviewer agent. The update-reviewer is a plugin-dev agent with its own prompt. Demoting to No Action (CC internal).
- **Security monitor expanded: new blocked categories** -- CONFIRMED in system-prompts changelog (2.1.89). This affects auto mode behavior. agent-development/SKILL.md has permissionMode documentation (lines 293-311) but does not detail security monitor restrictions. Gap exists for autonomous agent developers who need to understand blocked categories. Keeping as Must Update.

#### Missed Items (promoted from No Action)
- None identified. The No Action items were correctly classified as bug fixes, UI improvements, or internal optimizations.

#### May Update Resolution
- = **NEW: Buddy Mode (April Fools)** -- kept as May Update. Seasonal feature, low relevance to plugin development.
- = **Named subagents in @mention typeahead** -- kept as May Update. UX feature, not directly affecting plugin development patterns.
- = **Prompt Caching documentation updates** -- kept as May Update. Reference material, not core plugin development guidance.
- = **NEW: Remote plan mode (ultraplan) prompts** -- kept as May Update. Internal CC planning feature, not directly plugin-relevant.

#### Summary
- Must Update: 8 items -> 5 items confirmed (3 demoted to No Action)
  - Confirmed: "defer" permission, hook output >50K, TaskCreated event (corrected source), MCP truncation guidance, Security monitor expansion
  - Demoted: Computer Use MCP (CC internal skill), Agent tool info block (CC internal), Verification specialist (CC internal)
- May Update: 4 items remaining (unchanged)
- Confidence: HIGH for hook-related items, MEDIUM for MCP truncation (scope unclear)

**Corrections applied to manifest body above.**
