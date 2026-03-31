# Upstream Change Manifest
## CC Version Range: 2.1.87 - 2.1.88
## Generated: 2026-03-31
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped]

Note: claude-code-guide subagent not available in this environment. Triangulation degraded to two sources.

---

### Must Update

- [ ] **NEW: Config tool added** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development skill (tool references)
  - Details: New tool for getting and setting Claude Code configuration settings. Plugin-dev documentation should be updated to include this new tool in tool references and agent toolset descriptions.
  - Raw: "**NEW:** Tool Description: Config - Added tool for getting and setting Claude Code configuration settings."

- [ ] **TeammateTool path changed** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development skill (teams section)
  - Details: Team file path changed from `~/.claude/teams/{team-name}.json` to `~/.claude/teams/{team-name}/config.json`. Any documentation referencing team file locations needs updating.
  - Raw: "Tool Description: TeammateTool - Updated the team file path from `~/.claude/teams/{team-name}.json` to `~/.claude/teams/{team-name}/config.json`."

- [ ] **NEW: Partial compaction instructions** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: high
  - Affects: hook-development skill (PreCompact/PostCompact), skill-development skill (context management)
  - Details: Added instructions for compacting only a portion of the conversation with a structured summary format. This is a new capability that may warrant documentation.
  - Raw: "**NEW:** System Prompt: Partial compaction instructions - Added instructions for compacting only a portion of the conversation, with a structured summary format and analysis process."

- [ ] **REMOVED: System section (tool permission mode)** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: high
  - Affects: hook-development skill (terminology review)
  - Details: Removed the system section describing tool permission mode behavior and denied tool call guidance. Any references to this in plugin-dev docs should be reviewed.
  - Raw: "**REMOVED:** System Prompt: System section - Removed the system section describing tool permission mode behavior and denied tool call guidance."

- [ ] **PreToolUse/PostToolUse file_path now absolute** (CC 2.1.88)
  - Source: CC changelog (PROMOTED from No Action)
  - Confidence: high
  - Affects: hook-development skill (event-schemas.md, hook-input-schemas.md)
  - Details: Fixed PreToolUse/PostToolUse hooks not providing `file_path` as an absolute path for Write/Edit/Read tools. Hook scripts that process file_path now receive absolute paths. This is a behavior change affecting hook script logic.
  - Raw: "Fixed PreToolUse/PostToolUse hooks not providing `file_path` as an absolute path for Write/Edit/Read tools"

- [ ] **NEW: PermissionDenied hook introduced** (CC 2.1.88)
  - Source: CC changelog (PROMOTED from No Action)
  - Confidence: high
  - Affects: hook-development skill (new hook event to document)
  - Details: Introduced `PermissionDenied` hook that activates following auto mode classifier denials, allowing models to request retry via `{retry: true}` response. This is a NEW hook event (25th event) that must be added to hook-development documentation.
  - Raw: "Introduced `PermissionDenied` hook that activates following auto mode classifier denials, allowing models to request retry via `{retry: true}` response"

- [ ] **Hook `if` filtering fix for compound commands** (CC 2.1.88)
  - Source: CC changelog (PROMOTED from No Action)
  - Confidence: high
  - Affects: hook-development skill (advanced.md, `if` field documentation)
  - Details: Fixed hooks' `if` condition filtering to properly match compound commands like `ls && git push` and commands with environment variable prefixes such as `FOO=bar git push`. Existing documentation should note this behavior.
  - Raw: "Fixed hooks' `if` condition filtering to properly match compound commands like `ls && git push` and commands with environment variable prefixes such as `FOO=bar git push`"

---

### May Update

- [ ] **Git status prompt simplified** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: medium
  - Affects: git-related skill examples
  - Details: Stripped inline variable template (branch, status, recent commits); now contains only the introductory note that git status is a point-in-time snapshot.
  - Raw: "System Prompt: Git status - Stripped the inline variable template (branch, status, recent commits); now contains only the introductory note that git status is a point-in-time snapshot."

- [ ] **Fork usage guidelines updated** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent documentation
  - Details: Incorporated fork-specific prompt-writing guidance about writing directives that specify scope rather than re-explaining background.
  - Raw: "System Prompt: Fork usage guidelines - Incorporated fork-specific prompt-writing guidance (previously in the subagent prompts section) about writing directives that specify scope rather than re-explaining background."

- [ ] **Writing subagent prompts collapsed** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent-creator skill
  - Details: Collapsed separate context-inheriting vs fresh-agent sections into a single flow that defaults to fresh-agent briefing style with conditional notes for subagent types.
  - Raw: "System Prompt: Writing subagent prompts - Collapsed the separate context-inheriting vs fresh-agent sections into a single flow that defaults to the fresh-agent briefing style, with conditional notes when a subagent type is present."

- [ ] **Plan mode reminder conditional on agent availability** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: medium
  - Affects: plan-mode documentation
  - Details: Subagent exploration suggestion is now conditional on whether agents are actually available.
  - Raw: "System Reminder: Plan mode is active (iterative) - Made the subagent exploration suggestion conditional on whether agents are actually available, instead of always appending it."

- [ ] **Agent tool prompt guidance moved** (CC 2.1.88)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent-creator skill
  - Details: Removed instruction to provide clear, detailed prompts for agents without subagent types (guidance now lives in fork/subagent prompt-writing sections).
  - Raw: "Tool Description: Agent (usage notes) - Removed the instruction to provide clear, detailed prompts for agents without subagent types (guidance now lives in the fork/subagent prompt-writing sections)."

- [ ] **PowerShell tool description expanded** (CC 2.1.88)
  - Source: system-prompts (DEMOTED from Must Update)
  - Confidence: medium
  - Affects: Windows-specific documentation (none exists in plugin-dev)
  - Details: Significantly expanded PowerShell syntax guidance. Windows-specific; no existing PowerShell documentation in plugin-dev to update.
  - Raw: "Tool Description: PowerShell - Significantly expanded syntax guidance..."

- [ ] **NEW: PowerShell 5.1 system prompt** (CC 2.1.88)
  - Source: system-prompts (DEMOTED from Must Update)
  - Confidence: medium
  - Affects: Windows-specific documentation (none exists in plugin-dev)
  - Details: Added system prompt for Windows PowerShell 5.1. Windows-specific; no existing PowerShell documentation in plugin-dev.
  - Raw: "**NEW:** System Prompt: PowerShell edition for 5.1..."

---

### No Action

- v2.1.88: Flicker-free rendering via CLAUDE_CODE_NO_FLICKER=1 environment variable (UI/rendering)
- v2.1.88: Named subagents in mention suggestions (UI feature)
- v2.1.88: Fixed prompt cache issues in extended sessions (bug fix)
- v2.1.88: Fixed nested file re-injection in long conversations (bug fix)
- v2.1.88: Line-ending handling for Edit/Write tools on Windows (bug fix)
- v2.1.88: Structured output schema caching improvements (performance)
- v2.1.88: Memory leaks related to large JSON inputs (bug fix)
- v2.1.88: Rate-limit error messaging improvements (UX)
- v2.1.88: LSP server recovery after crashes (bug fix)
- v2.1.88: Voice mode fixes on macOS/Windows (platform-specific bug fix)
- v2.1.88: UI rendering artifacts and text truncation fixes (UI bug fix)
- v2.1.88: Prompt history corruption at 4KB boundaries fix (bug fix)
- v2.1.88: Statistics tracking historical data fix (bug fix)
- v2.1.88: Notification clearing and message synchronization (bug fix)
- v2.1.88: Verify skill substantially condensed (CC's built-in verify skill, not plugin-dev)
- v2.1.88: Ultraplan same-session implementation (internal CC feature, not plugin-dev relevant)
- v2.1.88: Plugin permission fix on macOS/Linux since v2.1.83 (bug fix)
- v2.1.87: No system prompt changes

---

## Summary

**Versions analyzed:** 2.1.87, 2.1.88

**Token delta (2.1.88):** -1,627 tokens (net reduction due to verify skill condensing and removed system section)

**Key themes in 2.1.88:**
1. New Config tool for settings management
2. New PermissionDenied hook event (ADDED by verification)
3. Team file path restructuring
4. PreToolUse/PostToolUse file_path now absolute (ADDED by verification)
5. Partial compaction feature
6. Enhanced Windows/PowerShell support (May Update)
7. Removed tool permission mode system section

**Risk assessment:** The PermissionDenied hook and file_path absolute path fix are the highest priority items as they directly affect hook development documentation. The team file path change and Config tool addition also require updates.

---

## Stage 2: Verification Results
### Verified: 2026-03-31

#### Must Update Verification
- [x] **NEW: Config tool added** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 13. Gap exists: no mention of Config tool in plugin-dev tool documentation. Affects: agent-development (tool references).
- [x] **TeammateTool path changed** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 23. Gap exists: plugin-dev agent-development skill does not document team file paths. Affects: agent-development (teams section).
- [x] **NEW: Partial compaction instructions** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 11. Gap exists: no documentation of partial compaction. Affects: hook-development (PreCompact/PostCompact), skill-development (context management).
- [x] **REMOVED: System section (tool permission mode)** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 14. Gap exists: hook-development references "tool permission mode" terminology. Review needed.
- [x] **Verify skill substantially condensed** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 15. This is an internal CC change to CC's built-in verify skill, NOT the plugin-dev verify skill. No gap exists in plugin-dev. **Reclassified to No Action** -- plugin-dev has no "verify skill" to align with.
- [x] **PowerShell tool description expanded** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 22. No existing PowerShell documentation in plugin-dev (grep returned no matches). This is a Windows-specific addition. **May Update** level -- only relevant for Windows users.
- [x] **NEW: PowerShell 5.1 system prompt** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 12. Same as above -- no existing PowerShell docs. **May Update** level.
- [x] **Ultraplan can now implement in same session** (CC 2.1.88) -- confirmed in system-prompts CHANGELOG line 20. No existing ultraplan documentation in plugin-dev. Low impact for plugin developers. **Demoted to No Action** -- ultraplan is an internal CC feature, not directly affecting plugin development.

#### Missed Items (promoted from No Action)
- ! **PreToolUse/PostToolUse file_path now absolute** (CC 2.1.88) -- missed from changelog! CC changelog says "Fixed PreToolUse/PostToolUse hooks not providing `file_path` as an absolute path for Write/Edit/Read tools." This is directly relevant to hook-development docs.
  - Affects: hook-development (tool input schemas, event-schemas.md)
  - Details: Hook scripts that process file_path from Write/Edit/Read tools now receive absolute paths. This is a behavior change that affects hook script logic.

- ! **PermissionDenied hook introduced** (CC 2.1.88) -- partially captured but listed as "No Action". The CC changelog states "Introduced `PermissionDenied` hook that activates following auto mode classifier denials, allowing models to request retry via `{retry: true}` response." This is a NEW hook event that should be documented.
  - Affects: hook-development (new hook event)
  - Details: New hook event PermissionDenied was introduced. The current hook-development skill lists 24 events; this adds a 25th. Must be documented.

- ! **Plugin permission fix v2.1.83** (CC 2.1.86, 2.1.88) -- The CC changelog mentions "Official marketplace plugin scripts were failing with permission errors on macOS/Linux starting in v2.1.83; this is now resolved" in both 2.1.86 and 2.1.88. This is worth noting for compatibility but is a bug fix, not a documentation gap.
  - Affects: None (bug fix)
  - **Kept as No Action** -- bug fix, no docs needed

- ! **Hook `if` filtering for compound commands** (CC 2.1.88) -- CC changelog: "Fixed hooks' `if` condition filtering to properly match compound commands like `ls && git push` and commands with environment variable prefixes such as `FOO=bar git push`." This is relevant to hook-development.
  - Affects: hook-development (advanced.md, `if` field documentation)
  - Details: The `if` field now properly handles compound commands. Existing docs may need clarification.
  - **Promoted to Must Update** -- behavior clarification for existing feature

#### May Update Resolution
- = **Git status prompt simplified** (CC 2.1.88) -- kept as May Update. Internal CC change, no plugin-dev impact.
- = **Fork usage guidelines updated** (CC 2.1.88) -- kept as May Update. Could inform agent-development examples but not critical.
- = **Writing subagent prompts collapsed** (CC 2.1.88) -- kept as May Update. Could inform agent-creator agent but not critical.
- = **Plan mode reminder conditional** (CC 2.1.88) -- kept as May Update. Internal CC behavior.
- = **Agent tool prompt guidance moved** (CC 2.1.88) -- kept as May Update. Could inform agent-development but not critical.
- downarrow **PowerShell tool description expanded** -- demoted from Must Update to May Update. Windows-specific, no existing docs to update.
- downarrow **PowerShell 5.1 system prompt** -- demoted from Must Update to May Update. Windows-specific, no existing docs to update.

#### Summary
- Must Update: 7 items (4 confirmed original, 3 promoted from No Action, 2 demoted to May Update)
  - Config tool added
  - TeammateTool path changed
  - Partial compaction instructions
  - REMOVED: System section (tool permission mode)
  - PreToolUse/PostToolUse file_path now absolute (NEW)
  - PermissionDenied hook introduced (NEW)
  - Hook `if` filtering for compound commands (NEW)
- May Update: 7 items (5 original, 2 demoted from Must Update)
- Confidence: HIGH -- sources independently verified, all changelog entries cross-referenced

#### Notes
- The manifest correctly identified the version range 2.1.87-2.1.88
- v2.1.87 had no system prompt changes (confirmed)
- The "Verify skill" item was incorrectly classified -- it refers to CC's built-in verify skill, not a plugin-dev skill
- Two significant plugin-relevant changes were in the CC changelog "No Action" section that should have been flagged:
  1. PreToolUse/PostToolUse file_path absolute path fix
  2. PermissionDenied hook introduction
- The `if` field compound command fix enhances existing documented feature
