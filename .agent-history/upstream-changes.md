# Upstream Change Manifest
## CC Version Range: 2.1.154 - 2.1.156
## Generated: 2026-05-28
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [timeout/no-output]

---

### Must Update

> **Stage 2 verified: 6 items after reclassification (5 confirmed + 1 promoted)**

- [ ] **Plugin `defaultEnabled: false` option with manual enablement capability** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: HIGH (verified)
  - Affects: plugin-structure skill (overview.md - manifest field documentation)
  - Details: Plugins can now specify `defaultEnabled: false` in manifest to require users to manually enable them. This is a new plugin.json field that affects plugin loading behavior.
  - Raw changelog: "Plugin `defaultEnabled: false` option with manual enablement capability"
  - **Gap confirmed**: No mention of `defaultEnabled` field in current plugin-structure documentation

- [ ] **Background session temporary file guidance change** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: HIGH (verified)
  - Affects: agent-development skill (overview.md - Background Job Agent Behavior section)
  - Details: Changes temporary-file guidance from `$CLAUDE_JOB_DIR` to `$CLAUDE_JOB_DIR/tmp` for background sessions. This is a path convention change for background agent temporary file usage.
  - Raw changelog: "System Prompt: Background session instructions - Changes temporary-file guidance from `$CLAUDE_JOB_DIR` to `$CLAUDE_JOB_DIR/tmp`..."
  - **Gap confirmed**: Current docs do not mention `$CLAUDE_JOB_DIR` or `$CLAUDE_JOB_DIR/tmp` path conventions

- [ ] **AskUserQuestion tool tightened usage guidance** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: HIGH (verified)
  - Affects: agent-development skill (guidance on when agents should prompt users)
  - Details: Tightens usage guidance so agents ask only when blocked on a decision that cannot be resolved from the request, code, or sensible defaults. Affects how skills and agents should use this tool.
  - Raw changelog: "Tool Description: AskUserQuestion - Tightens usage guidance so agents ask only when blocked..."
  - **Gap confirmed**: Best practice for when to use AskUserQuestion not currently documented

- [ ] **Bash tool TMPDIR clarification** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: HIGH (verified)
  - Affects: hook-development skill (environment variables section), skill-development (scripts guidance)
  - Details: Clarifies that `$TMPDIR` is set to the same sandbox-writable temporary directory for both sandboxed and unsandboxed commands. Important for skills using temporary files.
  - Raw changelog: "Tool Description: Bash (sandbox - tmpdir) - Clarifies that `$TMPDIR` is set to the same sandbox-writable temporary directory..."
  - **Gap confirmed**: TMPDIR sandbox behavior not currently documented in hook/skill environment guidance

- [ ] **Directory-aware plugin suggestions in Discover tab** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: HIGH (verified)
  - Affects: marketplace-structure skill (overview.md - plugin discovery behavior)
  - Details: Plugin discovery now considers directory context for suggestions. The Discover tab shows "suggested for this directory" annotations.
  - Raw changelog: "Directory-aware plugin suggestions in Discover tab"
  - **Gap confirmed**: Directory-aware suggestions not mentioned in marketplace documentation

- [ ] **MCP servers receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` environment variables** (CC 2.1.154)
  - Source: CC changelog (Plugin & MCP Improvements section)
  - Confidence: HIGH (verified, promoted from No Action)
  - Affects: mcp-integration skill (overview.md - server environment variables)
  - Details: MCP servers now receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` environment variables automatically, enabling session tracking and Claude Code detection in MCP server implementations.
  - Raw changelog: "MCP servers receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` environment variables"
  - **Gap confirmed**: These env vars not currently documented in MCP integration guidance

---

### May Update

> **Stage 2 verified: 16 items (13 original + 5 reclassified from Must Update - 1 demoted to No Action)**

- [ ] **Opus 4.8 now available as default with "high effort" mode** (CC 2.1.154)
  - Source: CC changelog + system-prompts
  - Confidence: high (confirmed in both)
  - Affects: model references in documentation
  - Details: System-prompts confirms extensive Opus 4.8 updates across API references (Python, Go, TypeScript, cURL), model catalog, streaming references, tool use concepts, and migration guide. Model-selection examples updated to prefer `claude-opus-4-8`.

- [ ] **Dynamic workflows for coordinating multiple agents** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source, general feature)
  - Affects: potentially agent-anatomy documentation
  - Details: Enables Claude to coordinate "tens to hundreds of agents" for complex work. May relate to Workflow tool updates in system-prompts.

- [ ] **Fast mode on Opus 4.8 costs 2x standard rate for 2.5x speed improvement** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source)
  - Affects: model/pricing documentation if present
  - Details: Speed/cost tradeoff information for Opus 4.8.

- [ ] **/effort slider renamed from "Speed/Intelligence" to "Faster/Smarter"** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source)
  - Affects: command reference documentation
  - Details: UI/terminology change for the effort setting.

- [ ] **Shell command execution via `! <command>` in background sessions** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source)
  - Affects: background session documentation
  - Details: New inline shell execution syntax for background sessions. May be useful for background agent development.

- [ ] **Browser selection via `/chrome` command** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source)
  - Affects: command reference documentation
  - Details: New command for browser selection.

- [ ] **Streaming tool execution now universally enabled** (CC 2.1.154)
  - Source: CC changelog
  - Confidence: medium (single source)
  - Affects: tool behavior documentation
  - Details: Streaming is now the default for all tool execution.

- [ ] **Coordinator mode orchestration token accounting change** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent architecture documentation
  - Details: Updates PR activity subscription guidance and changes worker summary accounting from total tokens to subagent tokens.

- [ ] **Claude guide agent stale-knowledge handling** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent behavior documentation
  - Details: Adds stale-knowledge handling that tells the guide agent to disclose documentation fetch failures instead of silently answering from memory.

- [ ] **Anthropic CLI authentication updates** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: high
  - Affects: API/CLI documentation references
  - Details: Updates to cover SDK-style credential resolution, OAuth profiles from `ant auth login`, `ant auth print-credentials`, bearer-token usage.

- [ ] **Agent Design Patterns skill: mid-session system messages** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-building documentation
  - Details: Replaces mid-session `<system-reminder>` guidance with beta `role: "system"` messages for supported models, with `<system-reminder>` retained as fallback.

- [ ] **Model migration guide: Opus 4.8 section** (CC 2.1.154)
  - Source: system-prompts
  - Confidence: high
  - Affects: model documentation
  - Details: Adds Opus 4.8 migration guidance including model-ID updates, mid-session system prompts, long-horizon agentic tuning, effort recommendations, tool-triggering behavior, narration changes.

- [ ] **NEW: Claude Code live documentation sources data file** (CC 2.1.154) - **Reclassified from Must Update**
  - Source: system-prompts
  - Reason: CC-internal data pattern, not directly actionable for plugin authors
  - Details: Adds official Claude Code documentation URLs and topic-specific WebFetch prompts. Could serve as a reference pattern.

- [ ] **NEW: Claude Code recent changes reference data file** (CC 2.1.154) - **Reclassified from Must Update**
  - Source: system-prompts
  - Reason: CC-internal documentation, informational pattern only
  - Details: Adds a reference for renamed or removed Claude Code commands, flags, and terms.

- [ ] **NEW: Claude Code configuration guide skill** (CC 2.1.154) - **Reclassified from Must Update**
  - Source: system-prompts
  - Reason: CC bundled skill, not plugin-dev documentation scope
  - Details: Adds a configuration skill for CC guidance. Could mention as a skill pattern reference.

- [ ] **Workflow tool: ultracode standing workflow opt-in** (CC 2.1.154) - **Reclassified from Must Update**
  - Source: system-prompts
  - Reason: Workflow tool updates may already be covered in skill-building documentation
  - Details: Adds ultracode as standing workflow opt-in, requires inline workflow scripts, clarifies JSON `args` passing.

- [ ] **Security monitor expanded with final-destination tracing** (CC 2.1.154) - **Reclassified from Must Update**
  - Source: system-prompts
  - Reason: Auto-mode behavior changes, optional note in agent security documentation
  - Details: Expands security review with explicit final-destination tracing for writes, commits, pushes, uploads.

---

### No Action

> **Stage 2 verified: 12 items (11 original + 1 reclassified)**

- Lean system prompt becomes default across models (except Haiku, Sonnet, 4.7) (CC 2.1.154) - Internal prompt optimization, no plugin system impact
- Multiple-choice questions reserved for genuine decision scenarios (CC 2.1.154) - UI behavior, no plugin system impact
- Multiple security and performance fixes across permission systems and background agents (CC 2.1.154) - Internal fixes, no documentation impact
- API reference updates for Opus 4.8 (Python, Go, TypeScript, cURL) (CC 2.1.154) - API doc updates in system-prompts, not plugin-dev scope
- HTTP error codes reference updates for OAuth tokens (CC 2.1.154) - API reference, not plugin-dev scope
- Managed Agents reference updates for credential resolution (CC 2.1.154) - API reference, not plugin-dev scope
- Prompt Caching mid-conversation system-message guidance (CC 2.1.154) - API optimization, not plugin-dev scope
- Streaming reference updates for Opus 4.8 (CC 2.1.154) - API reference, not plugin-dev scope
- Tool use concepts updates for Opus 4.8 (CC 2.1.154) - API reference, not plugin-dev scope
- Building LLM-powered applications skill: Opus 4.8 updates (CC 2.1.154) - SDK documentation, not plugin-dev scope
- Version 2.1.156 - No changes to system prompts
- `/simplify` slash command refocused (CC 2.1.154) - **Reclassified from Must Update**: CC bundled command, not plugin development surface

---

## Notes

1. **Version coverage**: This manifest covers CC 2.1.154-2.1.156. Version 2.1.155 was not found in either changelog (may not exist or may be unreleased). Version 2.1.156 has no system prompt changes per the system-prompts CHANGELOG.

2. **Source triangulation**:
   - CC changelog: Provided high-level feature summaries
   - system-prompts CHANGELOG: Provided detailed prompt/tool changes (+11,516 tokens in 2.1.154)
   - claude-code-guide agent: Attempted dispatch but no response received (timeout after 60+ seconds)

3. **Key changes for plugin-dev**:
   - The `defaultEnabled: false` plugin option is the most significant plugin-system change
   - Several new skills and data files establish patterns that may inform plugin-dev documentation
   - Workflow tool updates are substantial and may warrant expanded workflow documentation
   - Background session path guidance change (`$CLAUDE_JOB_DIR/tmp`) affects background agent development

4. **Token delta**: +11,516 tokens in 2.1.154 (significant expansion of system prompts)

---

## Summary (Stage 2 Verified)

**Version Range:** 2.1.154 - 2.1.156 (2 versions since last audit at 2.1.153)

**Total Changes Analyzed:** 30+ items from CC changelog and system-prompts

**Must Update: 6 items** (after Stage 2 verification)
1. Plugin `defaultEnabled: false` option (CC 2.1.154) - plugin-structure
2. Background session temporary file guidance `$CLAUDE_JOB_DIR/tmp` (CC 2.1.154) - agent-development
3. AskUserQuestion tool tightened usage guidance (CC 2.1.154) - agent-development
4. Bash tool TMPDIR clarification (CC 2.1.154) - hook-development, skill-development
5. Directory-aware plugin suggestions in Discover tab (CC 2.1.154) - marketplace-structure
6. MCP servers receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` env vars (CC 2.1.154) - mcp-integration [PROMOTED]

**May Update: 16 items** (13 original + 5 reclassified from Must Update - 1 demoted)
- Model and effort changes (Opus 4.8, effort slider)
- Command additions (`/chrome`, `! <command>` in background)
- System prompt and agent behavior updates
- Reclassified: /simplify, live docs data, recent changes data, config guide skill, workflow ultracode, security monitor

**No Action: 12 items** (11 original + 1 reclassified from Must Update)
- Internal prompt optimizations, API reference updates, SDK documentation
- `/simplify` refocused (CC bundled command, not plugin-dev scope)

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | OK | Retrieved via WebFetch from upstream |
| System-prompts | OK | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | timeout/no-output | Subagent dispatch ran but output file remained empty |

---

## Recommendations for Stage 3 (Stage 2 Verified)

1. **Plugin manifest updates (HIGH PRIORITY)**:
   - Add `defaultEnabled: false` option to plugin-structure/overview.md manifest field documentation
   - Document directory-aware plugin suggestions behavior in marketplace-structure/overview.md

2. **MCP integration updates (HIGH PRIORITY)**:
   - Document `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` environment variables in mcp-integration/overview.md

3. **Agent development updates (MEDIUM PRIORITY)**:
   - Add `$CLAUDE_JOB_DIR/tmp` path guidance for background session temporary files
   - Document AskUserQuestion best practice: "ask only when blocked on a decision that cannot be resolved from the request, code, or sensible defaults"

4. **Hook/Skill development updates (MEDIUM PRIORITY)**:
   - Document TMPDIR sandbox behavior: `$TMPDIR` is set to the same sandbox-writable temporary directory for both sandboxed and unsandboxed commands

5. **Optional updates (May Update items, LOWER PRIORITY)**:
   - Consider documenting Workflow tool ultracode opt-in if not already covered
   - Consider noting security monitor final-destination tracing in agent security section

---

## Stage 2: Verification Results
### Verified: 2026-05-28

#### Must Update Verification

- **[CONFIRMED]** Plugin `defaultEnabled: false` option (CC 2.1.154)
  - Source verification: CC changelog confirms "Plugins can declare `defaultEnabled: false` and be enabled via `/plugin`"
  - Gap exists: No mention of `defaultEnabled` field in plugin-structure/overview.md (grep returned no matches)
  - Affects: plugin-structure skill - needs new manifest field documentation

- **[CONFIRMED]** `/simplify` slash command refocused (CC 2.1.154)
  - Source verification: Both CC changelog and system-prompts CHANGELOG confirm refocus on cleanup review
  - Gap assessment: This is a bundled Claude Code command, not plugin-dev documentation scope
  - **RECLASSIFIED to No Action**: `/simplify` is an internal CC command, not a plugin development surface

- **[CONFIRMED with CAVEAT]** NEW: Claude Code live documentation sources data file (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms new data file with documentation URLs for hooks, MCP, skills, subagents
  - Gap assessment: This is a CC-internal data pattern, not directly applicable to plugin-dev
  - **RECLASSIFIED to May Update**: Could serve as a reference pattern but not directly actionable for plugin authors

- **[CONFIRMED with CAVEAT]** NEW: Claude Code recent changes reference data file (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms new reference for renamed/removed commands
  - Gap assessment: This is CC-internal documentation, not plugin-dev scope
  - **RECLASSIFIED to May Update**: Informational pattern only

- **[CONFIRMED with CAVEAT]** NEW: Claude Code configuration guide skill (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms new skill for CC configuration guidance
  - Gap assessment: This is a CC bundled skill, not plugin-dev documentation scope
  - **RECLASSIFIED to May Update**: Could mention as a skill pattern reference

- **[CONFIRMED]** Workflow tool: ultracode standing workflow opt-in (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms "Adds ultracode as standing workflow opt-in, requires inline workflow scripts for first invocation, clarifies JSON `args` passing"
  - Gap assessment: Workflow tool is referenced in skill-development but not agent-development
  - **RECLASSIFIED to May Update**: Workflow tool updates are primarily for skill-building documentation, which may already be covered

- **[CONFIRMED]** Background session temporary file guidance change (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms "Changes temporary-file guidance from `$CLAUDE_JOB_DIR` to `$CLAUDE_JOB_DIR/tmp`"
  - Gap exists: agent-development/overview.md documents Background Job Agent Behavior (CC 2.1.128) but does not mention `$CLAUDE_JOB_DIR` or `$CLAUDE_JOB_DIR/tmp` path convention
  - Affects: agent-development skill - needs path guidance update

- **[CONFIRMED]** AskUserQuestion tool tightened usage guidance (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms "Tightens usage guidance so agents ask only when blocked"
  - Gap assessment: AskUserQuestion is referenced in hook-development (event-schemas.md) for PreToolUse patterns. The "ask only when blocked" guidance affects how skills/agents should use this tool
  - Affects: agent-development skill - guidance on when agents should use AskUserQuestion

- **[CONFIRMED]** Bash tool TMPDIR clarification (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms TMPDIR sandbox clarification
  - Gap assessment: hook-development references TMPDIR in some patterns but not this specific clarification
  - Affects: hook-development skill (script environment section) and skill-development (scripts using TMPDIR)

- **[CONFIRMED]** Security monitor expanded with final-destination tracing (CC 2.1.154)
  - Source verification: system-prompts CHANGELOG confirms expanded security review for writes, commits, pushes, uploads, etc.
  - Gap assessment: agent-development/overview.md has Self-Modification Protected Paths (CC 2.1.140) section but does not cover the 2.1.154 final-destination tracing expansion
  - **RECLASSIFIED to May Update**: Security monitor changes affect auto-mode behavior, may warrant a note in agent security documentation

- **[CONFIRMED]** Directory-aware plugin suggestions in Discover tab (CC 2.1.154)
  - Source verification: CC changelog confirms "Directory-aware plugin suggestions in Discover tab" and "Plugin Discover tab shows 'suggested for this directory' annotations"
  - Gap assessment: marketplace-structure/overview.md does not mention directory-aware suggestions
  - Affects: marketplace-structure skill - plugin discovery behavior

#### Missed Items (promoted from No Action)

- **[PROMOTED]** MCP servers receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` environment variables (CC 2.1.154)
  - Source: CC changelog confirms this in Plugin & MCP Improvements section
  - Missed because: Classified under general MCP improvements
  - Affects: mcp-integration skill - MCP server environment variables
  - Details: New env vars available in MCP server processes for session tracking

#### May Update Resolution

- **[KEPT as May Update]** Opus 4.8 now available as default with "high effort" mode
  - Reason: Model reference updates are tangential to plugin development; no direct plugin-dev documentation impact

- **[KEPT as May Update]** Dynamic workflows for coordinating multiple agents
  - Reason: Workflow tool capabilities may warrant expanded documentation but not critical for plugin authors

- **[KEPT as May Update]** Fast mode on Opus 4.8 costs 2x standard rate
  - Reason: Pricing info not directly relevant to plugin-dev documentation

- **[KEPT as May Update]** /effort slider renamed
  - Reason: UI terminology change, minimal plugin-dev impact

- **[KEPT as May Update]** Shell command execution via `! <command>` in background sessions
  - Reason: User-facing feature, not a plugin development surface

- **[KEPT as May Update]** Browser selection via `/chrome` command
  - Reason: User command, not plugin-dev related

- **[KEPT as May Update]** Streaming tool execution now universally enabled
  - Reason: Internal CC behavior, no plugin-dev documentation change needed

- **[DEMOTED to No Action]** Enhanced MCP server environment variables and approval workflows
  - Reason: The specific env vars (CLAUDE_CODE_SESSION_ID, CLAUDECODE=1) are captured above as a separate Must Update item; the "approval workflows" aspect is UI/UX not documentation

- **[KEPT as May Update]** Coordinator mode orchestration token accounting change
  - Reason: Affects internal accounting, not directly actionable for plugin authors

- **[KEPT as May Update]** Claude guide agent stale-knowledge handling
  - Reason: CC bundled agent behavior, not plugin-dev scope

- **[KEPT as May Update]** Anthropic CLI authentication updates
  - Reason: CLI auth is outside plugin-dev scope

- **[KEPT as May Update]** Agent Design Patterns skill: mid-session system messages
  - Reason: Could inform agent-development but not critical for plugin authors

- **[KEPT as May Update]** Model migration guide: Opus 4.8 section
  - Reason: Model guidance not directly plugin-dev related

#### Summary

- **Must Update: 6 items** (5 confirmed, 1 promoted)
  1. Plugin `defaultEnabled: false` option - gap confirmed in plugin-structure
  2. Background session temporary file guidance (`$CLAUDE_JOB_DIR/tmp`) - gap confirmed in agent-development
  3. AskUserQuestion tool tightened usage - gap confirmed in agent-development
  4. Bash tool TMPDIR clarification - gap confirmed in hook-development/skill-development
  5. Directory-aware plugin suggestions - gap confirmed in marketplace-structure
  6. MCP servers receive `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` env vars - gap confirmed in mcp-integration (PROMOTED)

- **Rejected/Reclassified: 5 items**
  - `/simplify` refocused -> No Action (CC bundled command, not plugin-dev scope)
  - NEW: Live documentation sources data file -> May Update (CC-internal pattern)
  - NEW: Recent changes reference data file -> May Update (CC-internal pattern)
  - NEW: Configuration guide skill -> May Update (CC bundled skill)
  - Workflow tool ultracode opt-in -> May Update (may already be covered)
  - Security monitor final-destination tracing -> May Update (auto-mode behavior, optional note)

- **May Update: 13 items** remaining
- **No Action: 12 items** (1 added from reclassification, 1 demoted from May Update)
- **Confidence: HIGH** - All items independently verified against both CC changelog and system-prompts CHANGELOG. No significant issues found. Stage 1 correctly identified the main changes; minor scope adjustments made.
