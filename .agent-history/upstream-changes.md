# Upstream Change Manifest
## CC Version Range: 2.1.251 - 2.1.251
## Generated: 2026-08-31
## Sources: changelog [x], system-prompts [x], claude-code-guide [x]

---

### Must Update

- [ ] **PreModelSwitch and PostModelSwitch hook events** (CC 2.1.251) [VERIFIED]
  - Source: changelog ("Added `PreModelSwitch` and `PostModelSwitch` hook events (block, confirm, or annotate a model switch)")
  - Confidence: high
  - Affects: hook-development/overview.md, hook-development/references/event-schemas.md
  - Details: Two new hook events for model switching. PreModelSwitch fires before a model switch and can block it; PostModelSwitch fires after the switch completes. These are the 30th and 31st hook events. Update event count from "29" to "31" in overview.md and event-schemas.md. Add event schemas for both new events.
  - Gap confirmed: overview.md line 6 says "29 hook events", event-schemas.md line 3 says "all 29 Claude Code hook events"

- [ ] **Remote Control subagent tool call streaming** (CC 2.1.251) [VERIFIED]
  - Source: changelog ("Added live streaming of a foreground subagent's tool calls and results to Remote Control clients")
  - Confidence: high
  - Affects: agent-development/references/orchestration-and-tools.md, plugin-structure/references/headless-ci-mode.md
  - Details: Foreground subagent tool calls and results can now be streamed live to Remote Control clients. Extends --forward-subagent-text (CC 2.1.211) with Remote Control integration.
  - Gap confirmed: headless-ci-mode.md documents --forward-subagent-text but not Remote Control streaming

- [ ] **Plugin path traversal security fix** (CC 2.1.251) [VERIFIED]
  - Source: changelog ("Fixed plugin commands declared in a marketplace entry being able to point outside the plugin directory; such paths are now rejected with a path-traversal error")
  - Confidence: high
  - Affects: plugin-structure/references/advanced-topics.md, marketplace-structure/overview.md
  - Details: Plugin commands in marketplace entries that point outside the plugin directory are now rejected with a path-traversal error. Plugin developers must ensure all command paths are within the plugin directory.
  - Gap confirmed: advanced-topics.md mentions security boundary but not specific rejection behavior

- [ ] **Symlink vulnerability fix in file tools** (CC 2.1.251) [VERIFIED]
  - Source: changelog ("Fixed file tools (Read, Write, Edit) following a symlink swapped inside the working directory after the permission check")
  - Confidence: high
  - Affects: hook-development/references/advanced.md (security patterns)
  - Details: File tools no longer follow symlinks swapped after permission check. Affects hooks that validate file operations - document that Claude Code now has stricter symlink handling so hook-based symlink validation may be redundant for some cases.
  - Gap confirmed: hook validation examples mention symlink limitations but not Claude Code's built-in protections

- [ ] **Large documentation removal: Admin API, Claude API, Artifact bundle, Plugin/design-sync bundle** (CC 2.1.251) [VERIFIED]
  - Source: system-prompts CHANGELOG (-743,949 tokens)
  - Confidence: high
  - Affects: skill-development/references/skill-loading-and-runtime.md (lines 317-409)
  - Details: Massive removal of bundled documentation. The following are NO LONGER available as built-in Claude Code resources:
    - Plugin Eval (`claude plugin eval`) and Skill Doctor (`/skill-doctor`)
    - Cost Optimization skill
    - Admin API Reference
    - Claude API references and model catalog
    - Artifact and visual-authoring bundle
    - Design sync and variants
  - Gap confirmed: skill-loading-and-runtime.md documents these as "Built-in Skill Patterns (CC 2.1.247-2.1.248)" - needs update to note removal

- [ ] **Schedule local MCP server limitation** (CC 2.1.251) [PROMOTED from May Update]
  - Source: system-prompts ("Agent Prompt: Schedule local MCP server limitation")
  - Confidence: high
  - Affects: mcp-integration/overview.md
  - Details: MCP servers configured directly in Claude Code cannot be attached to cloud routines. Routines are limited to Claude.ai connectors only. Plugin developers integrating MCP servers should be aware of this limitation.
  - Gap confirmed: mcp-integration docs do not mention cloud routine/schedule limitations

- [ ] **Grep and Glob symlink deny rule fix** (CC 2.1.251) [ADDED - missed by Stage 1]
  - Source: changelog ("Fixed Grep and Glob not applying `Read(...)` deny rules to files reached through a symlinked search path")
  - Confidence: high
  - Affects: hook-development (permission rule patterns), agent-development/references/permission-modes-rules.md
  - Details: Grep and Glob tools now properly apply Read deny rules to files accessed through symlinked search paths. Plugins using permission rules should be aware of this behavior change.

---

### May Update

_All items resolved by Stage 2 verification. See Stage 2 Verification Results for disposition._

- Schedule local MCP server limitation - **PROMOTED to Must Update**
- Reporting outcomes system prompt - **DEMOTED to No Action** (internal Claude behavior)
- Memory updates system reminder - **DEMOTED to No Action** (internal memory system)
- Session context system reminder - **DEMOTED to No Action** (internal session handling)
- Cross-session peer message authority warning - **DEMOTED to No Action** (existing docs sufficient)
- Artifact editor thread follow-up - **DEMOTED to No Action** (Artifact internal)
- Multiplayer whiteboard skill - **DEMOTED to No Action** (not in official docs)
- SDK Remote Control availability field - **DEMOTED to No Action** (SDK internal)
- Interactive agent intro variant - **DEMOTED to No Action** (UI change)
- Web fetch usage guidance - **DEMOTED to No Action** (tool internal)
- Files API references updates - **DEMOTED to No Action** (external API)

---

### No Action

**Original No Action items:**
- Security monitor autonomous agent actions removal (partial) (CC 2.1.251) - Internal security policy changes
- Permission prompt auto-denied timeout reminder removal (CC 2.1.251) - Internal behavior change
- Managed Agents documentation removal (CC 2.1.251) - Claude.ai Managed Agents is separate product, not plugin-dev scope
- SDK plugin warnings field (CC 2.1.251) - SDK internal detail
- SDK footer indicator schema (CC 2.1.251) - SDK internal detail
- Artifact nested runtime cleanup error tool description (CC 2.1.251) - Artifact-specific internal guidance
- Agent Skills marked as GA (CC 2.1.251) - Platform availability note only
- REPL tool usage prompt updates (CC 2.1.251) - REPL-specific, not plugin system
- Conversation stability fixes ("text content blocks must be non-empty") (CC 2.1.251) - Bug fix, no doc impact
- Opus 5 effort level incompatibilities fix (CC 2.1.251) - Bug fix, no doc impact
- TUI performance with parallel subagents (CC 2.1.251) - Performance fix, no doc impact
- Claude Code agent proxy troubleshooting guide update (CC 2.1.251) - Internal diagnostics
- Plugin eval authoring interview MCP mock updates (CC 2.1.251) - Plugin eval internals (already removed)
- Artifact document/report connector routing (CC 2.1.251) - Artifact system internals
- Artifact comments guidance updates (CC 2.1.251) - Artifact system internals
- Artifact publishing post-publish handoff (CC 2.1.251) - Artifact system internals
- Artifact HTML reset and hidden behavior (CC 2.1.251) - Artifact system internals
- Artifact live room guidance updates (CC 2.1.251) - Artifact system internals
- Artifact database guidance updates (CC 2.1.251) - Artifact system internals
- Claude Code configuration guide feedback routing (CC 2.1.251) - Internal guidance

**Demoted from Must Update (Stage 2):**
- Spend limit bar for Claude apps gateway users (CC 2.1.251) - Gateway UI feature, not plugin development

**Demoted from May Update (Stage 2):**
- Reporting outcomes system prompt (CC 2.1.251) - Internal Claude behavior, not plugin-controllable
- Memory updates system reminder (CC 2.1.251) - Internal memory system behavior
- Session context system reminder (CC 2.1.251) - Internal session handling
- Cross-session peer message authority warning (CC 2.1.251) - Existing agent-development docs sufficient
- Artifact editor thread follow-up (CC 2.1.251) - Artifact system internal
- Multiplayer whiteboard skill (CC 2.1.251) - Not in official docs, experimental/internal
- SDK Remote Control availability field (CC 2.1.251) - SDK internal for IDE hosts
- Interactive agent intro variant (CC 2.1.251) - Output style UI change
- Web fetch usage guidance (CC 2.1.251) - WebFetch tool internal behavior
- Files API references updates (CC 2.1.251) - External API platform availability

---

## Summary

**Version range**: 2.1.251 (single version since last audit on 2026-08-28)

**Token delta** (from system-prompts):
- 2.1.251: -743,949 tokens (massive documentation removal)

**Key themes** (updated after Stage 2 verification):
1. **New hook events**: PreModelSwitch and PostModelSwitch (30th and 31st events)
2. **Remote Control enhancement**: Live streaming of subagent tool calls
3. **Security fixes**: Plugin path traversal, file tool symlink vulnerabilities, Grep/Glob symlink deny rules
4. **Major documentation removal**: Plugin Eval, Skill Doctor, Cost Optimization, Admin API Reference all removed from bundled prompts
5. **MCP limitation**: Local MCP servers cannot be attached to cloud routines

**Priority items for plugin-dev** (after Stage 2 verification):
1. **PreModelSwitch/PostModelSwitch hooks** (CC 2.1.251) - new hook events need documentation, update event count 29->31
2. **Documentation removal** (CC 2.1.251) - skill-loading-and-runtime.md references removed features
3. **Security fixes** (CC 2.1.251) - plugin path traversal, symlink fixes, Grep/Glob deny rules
4. **MCP schedule limitation** (CC 2.1.251) - MCP servers cannot attach to cloud routines
5. **Remote Control streaming** (CC 2.1.251) - foreground subagent streaming to Remote Control

**Triangulation status**: All three sources independently verified by Stage 2:
- CC changelog: Confirmed exact wording for all items
- system-prompts CHANGELOG: Confirmed documentation removals
- plugin-dev docs: Confirmed gaps exist in hook-development, skill-development, mcp-integration

---

## Total changes requiring action (after Stage 2 verification)

- **Must Update**: 7 items (5 confirmed from original 6, 1 promoted from May Update, 1 missed item added, 1 demoted to No Action)
- **May Update**: 0 items (all resolved)
- **No Action**: 31 items (20 original + 1 demoted from Must Update + 10 demoted from May Update)

---

## Stage 2: Verification Results
### Verified: 2026-08-31

#### Must Update Verification

- **CONFIRMED** **PreModelSwitch and PostModelSwitch hook events** (CC 2.1.251)
  - Verified in CC changelog: "Added `PreModelSwitch` and `PostModelSwitch` hook events (block, confirm, or annotate a model switch)"
  - Gap exists: hook-development/overview.md documents "29 hook events" and event-schemas.md says "all 29 Claude Code hook events" - needs update to 31 events
  - Topic mapping correct: hooks-reference (hook-development/overview.md, hook-development/references/event-schemas.md)

- **CONFIRMED** **Remote Control subagent tool call streaming** (CC 2.1.251)
  - Verified in CC changelog: "Added live streaming of a foreground subagent's tool calls and results to Remote Control clients"
  - Gap exists: headless-ci-mode.md documents --forward-subagent-text (CC 2.1.211) but not Remote Control streaming
  - Topic mapping correct: agent-development (references/orchestration-and-tools.md already mentions Remote Control session kinds)

- **RECLASSIFIED** **Spend limit bar for Claude apps gateway users** (CC 2.1.251) - Demoted to No Action
  - Verified in CC changelog: "Added a Spend limit bar to `/usage` and a `rate_limits.spend_limit` status line field"
  - No gap: This is a UI/status feature for gateway users, not a plugin development concern
  - Original classification cited "cost-optimization skill documentation" but plugin-dev has no cost-optimization skill; this is a Claude Code built-in feature
  - Action: None required for plugin-dev

- **CONFIRMED** **Plugin path traversal security fix** (CC 2.1.251)
  - Verified in CC changelog: "Fixed plugin commands declared in a marketplace entry being able to point outside the plugin directory; such paths are now rejected with a path-traversal error"
  - Gap exists: plugin-structure/references/advanced-topics.md mentions security boundary but not specific path traversal rejection behavior
  - Topic mapping correct: plugin-structure (marketplace-structure for commands in marketplace entries)

- **CONFIRMED** **Symlink vulnerability fix in file tools** (CC 2.1.251)
  - Verified in CC changelog: "Fixed file tools (Read, Write, Edit) following a symlink swapped inside the working directory after the permission check"
  - Gap exists: hook-development docs mention symlink limitations in validation scripts but don't document Claude Code's symlink protections
  - Topic mapping slightly off: Primary relevance is to hooks that validate file operations, not direct "tool documentation"
  - Corrected affects: hook-development (security patterns in validation scripts)

- **CONFIRMED** **Large documentation removal** (CC 2.1.251)
  - Verified in system-prompts CHANGELOG: Four REMOVED entries confirm removal of Admin API, Claude API, Plugin bundle, Artifact bundle
  - Gap exists: skill-loading-and-runtime.md (lines 317-409) documents Plugin Eval, Skill Doctor, Cost Optimization skill, and Admin API Reference as "built-in Claude Code resources" - all now removed
  - Topic mapping correct: skill-development/references/skill-loading-and-runtime.md needs update

#### Missed Items (promoted from No Action)

- **MISSED** **Grep and Glob symlink deny rule fix** (CC 2.1.251)
  - Verified in CC changelog: "Fixed Grep and Glob not applying `Read(...)` deny rules to files reached through a symlinked search path"
  - Missed because: Classified under symlink security fixes, but this is a separate change affecting permission rule behavior
  - Affects: hook-development (permission rule patterns), plugin-settings (if documenting deny rules)
  - Action: Document that Grep/Glob now respect Read deny rules through symlinks

- **MISSED** **Schedule local MCP server limitation** (CC 2.1.251) - Already in May Update, but should be promoted
  - This is a significant limitation for plugin developers who integrate MCP servers
  - Affects: mcp-integration (MCP servers cannot be attached to cloud routines/schedules)
  - Action: Promote to Must Update

#### May Update Resolution

- **PROMOTED** **Schedule local MCP server limitation** (CC 2.1.251) - to Must Update
  - Reason: Material limitation for MCP server integration - plugins with MCP servers need to know they cannot be used in cloud routines

- **DEMOTED** **Reporting outcomes system prompt** (CC 2.1.251) - to No Action
  - Reason: Internal Claude behavior change, not something plugins can control or need to document

- **DEMOTED** **Memory updates system reminder** (CC 2.1.251) - to No Action
  - Reason: Internal memory system behavior, not plugin-relevant

- **DEMOTED** **Session context system reminder** (CC 2.1.251) - to No Action
  - Reason: Internal session handling, not plugin-relevant

- **DEMOTED** **Cross-session peer message authority warning note** (CC 2.1.251) - to No Action
  - Reason: Internal agent messaging rules; existing cross-session docs in agent-development are sufficient

- **DEMOTED** **Artifact editor thread follow-up agent prompt** (CC 2.1.251) - to No Action
  - Reason: Artifact system internal, not plugin-relevant

- **DEMOTED** **Multiplayer whiteboard skill description** (CC 2.1.251) - to No Action
  - Reason: Not in official docs (per Stage 1), experimental/internal feature

- **DEMOTED** **SDK Remote Control availability field** (CC 2.1.251) - to No Action
  - Reason: SDK internal for IDE hosts, not plugin development

- **DEMOTED** **Interactive agent intro variant** (CC 2.1.251) - to No Action
  - Reason: Output style UI change, not plugin-relevant

- **DEMOTED** **Web fetch usage guidance updates** (CC 2.1.251) - to No Action
  - Reason: WebFetch tool internal behavior, not plugin-relevant

- **DEMOTED** **Files API references updates** (CC 2.1.251) - to No Action
  - Reason: External API platform availability, not Claude Code plugin system

#### Summary

- Must Update: **6 items** (4 confirmed, 1 rejected/demoted, 1 promoted from May Update, 1 missed item added)
  - PreModelSwitch/PostModelSwitch hooks (CONFIRMED)
  - Remote Control subagent streaming (CONFIRMED)
  - Plugin path traversal security fix (CONFIRMED)
  - Symlink vulnerability fix (CONFIRMED, topic corrected)
  - Large documentation removal (CONFIRMED)
  - Schedule local MCP server limitation (PROMOTED from May Update)
  - Grep/Glob symlink deny rule fix (ADDED - missed item)
- May Update: **0 items** (all resolved - 1 promoted, 10 demoted)
- Confidence: **HIGH** - All major items verified against primary sources. The documentation removal is confirmed and affects skill-loading-and-runtime.md directly. New hook events require updating the event count from 29 to 31.

#### Verification Notes

1. **Changelog quote accuracy**: Stage 1 quoted "Major updates include hook events for model switching" but actual changelog says "Added `PreModelSwitch` and `PostModelSwitch` hook events (block, confirm, or annotate a model switch)" - more specific, confirmed correct
2. **Topic mappings validated**: Read overview.md files for hook-development, agent-development, mcp-integration, skill-development, plugin-structure - all mappings are appropriate
3. **Existing documentation checked**:
   - Hook count says "29" in two places - needs update to "31"
   - Skill-loading-and-runtime.md references Plugin Eval, Skill Doctor, Cost Optimization, Admin API Reference as built-in - all now removed
   - No existing documentation for PreModelSwitch/PostModelSwitch events
4. **Spend limit bar correctly demoted**: plugin-dev has no cost-optimization skill and gateway spend limits are not relevant to plugin development
