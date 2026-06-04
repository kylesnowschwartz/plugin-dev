# Upstream Change Manifest
## CC Version Range: 2.1.159 - 2.1.162
## Generated: 2026-06-04
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - empty output]

---

### Must Update

- [ ] **LSP workspaceSymbol query parameter** (CC 2.1.162)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: lsp-integration/overview.md
  - Details: LSP `workspaceSymbol` operation now accepts `query` parameter for language server pass-through. System-prompts clarify agents should always provide a query because many language servers return no results for an empty one.
  - Raw changelog: "LSP `workspaceSymbol` operation now accepts `query` parameter for language server pass-through"
  - Stage 2 verified: Gap exists in lsp-integration/overview.md

- [ ] **NotebookEdit reworked around cell IDs** (CC 2.1.162)
  - Source: system-prompts
  - Confidence: high (verified)
  - Affects: hook-development/references/hook-input-schemas.md
  - Details: Notebook editing guidance reworked around cell IDs from prior Read output. Requires notebook to be read before editing. Insert behavior changed to add cells after a target cell or at notebook start.
  - Raw changelog: "Reworks notebook editing guidance around cell IDs from prior `Read` output, requiring the notebook to be read before editing and changing insert behavior to add cells after a target cell or at the notebook start."
  - Stage 2 verified: Hook-input-schemas.md line 118 needs cell_id/cell_number parameters added

### May Update

- [ ] **/init CLAUDE.md discovers .devin/rules/ and .windsurf/rules/** (CC 2.1.162)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: /init skill documentation, AI config discovery
  - Details: Expands AI coding tool config discovery to include `.devin/rules/` and `.windsurf/rules/` alongside existing AGENTS, Cursor, Copilot, Windsurf, and Cline files.
  - Stage 2: Kept as May Update - not directly plugin-relevant but useful context

- [ ] **Single-file grep satisfies read-before-edit verification** (CC 2.1.160)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: Edit tool documentation, read-before-edit guidance
  - Details: Single-file `grep` commands now satisfy read-before-edit verification requirements. This relaxes the previous requirement that files must be read with the Read tool before editing.
  - Stage 2: Kept as May Update - affects plugin documentation about Edit tool

- [ ] **Confirmation prompts before writing to shell startup files** (CC 2.1.160)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: Bash tool documentation, safety guidance
  - Details: Added confirmation prompts before writing to shell startup files and build-tool configs that enable code execution. This is a security enhancement.
  - Stage 2: Kept as May Update - security enhancement worth noting

- [ ] **Agent tool usage notes updated for subagent-type availability** (CC 2.1.161)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: agent-development/overview.md (minor clarification)
  - Details: Agent usage guidance now keys subagent-type instructions off subagent-type availability rather than message-continuation support, and scopes subagent-context restrictions to the actual subagent context check.
  - Stage 2: Demoted from Must Update - existing docs already cover subagent concepts

### No Action

- `claude agents --json` shows `waitingFor` field (CC 2.1.162) - CLI output format, not plugin-relevant
- Slash command autocomplete fills prompt instead of executing (CC 2.1.162) - UI behavior change
- Remote Control redesigned as persistent footer (CC 2.1.162) - UI change
- Windsurf rebranded to Devin Desktop (CC 2.1.162) - Branding change
- Session names use full terminal width (CC 2.1.162) - UI formatting
- OpenTelemetry metrics include OTEL_RESOURCE_ATTRIBUTES (CC 2.1.161) - Observability, not plugin-relevant
- `claude agents` shows done/total counts (CC 2.1.161) - CLI output format
- /mcp menu collapses unused claude.ai connectors (CC 2.1.161) - UI change
- Linux clipboard support (wl-copy/xclip/xsel) (CC 2.1.161) - Platform support
- Motion accessibility settings honored (CC 2.1.161) - Accessibility
- Managed settings policies fixed (CC 2.1.161) - Bug fix
- Background subagent output fixed (CC 2.1.161) - Bug fix
- /autofix-pr error handling improved (CC 2.1.161) - Bug fix
- Copy-on-select restored for Windows WSL (CC 2.1.160) - Bug fix
- Session restoration from `claude agents` fixed (CC 2.1.160) - Bug fix
- Background session reconnection improved (CC 2.1.160) - Bug fix
- Interrupt handling fixed (CC 2.1.160) - Bug fix
- MCP server timeout configuration corrected (CC 2.1.160) - Bug fix
- v2.1.159: Internal infrastructure updates only - No user-visible changes
- DesignSync legacy asset registration (CC 2.1.162) - Internal tool state, not plugin API
- WebFetch permission rules properly applied (CC 2.1.162) - Bug fix
- Windows permission matching improved (CC 2.1.162) - Bug fix
- Startup hang fix when config directory lacks write permissions (CC 2.1.162) - Bug fix
- **[Stage 2 demoted]** NEW DesignSync tool (CC 2.1.160) - claude.ai-specific, not plugin API
- **[Stage 2 demoted]** NEW /design-sync slash command (CC 2.1.160, 2.1.162) - claude.ai-specific, not plugin API
- **[Stage 2 demoted]** Durable approval context (CC 2.1.161) - Internal behavior change
- **[Stage 2 demoted]** Background monitor streaming-pipeline guidance (CC 2.1.161) - Internal guidance
- **[Stage 2 demoted]** Workflow tool ultracode keyword (CC 2.1.160) - Not plugin-relevant
- **[Stage 2 demoted]** /code-review changes (CC 2.1.160) - Built-in command internals
- **[Stage 2 demoted]** Parallel Bash execution error handling (CC 2.1.161) - Internal behavior
- **[Stage 2 demoted]** Bash PR instructions configurable slot (CC 2.1.162) - Not plugin-relevant

---

## Summary

Four versions were released after the last audit (2.1.158):

- **2.1.159**: Internal infrastructure updates only - no user-visible changes
- **2.1.160**: DesignSync tool (out of scope), /design-sync command (out of scope), read-before-edit relaxation, security prompts
- **2.1.161**: Agent tool usage updates (minor), durable approvals, parallel execution changes
- **2.1.162**: LSP query parameter, NotebookEdit cell IDs, /init config discovery expansion

**Must Update: 2 items** (Stage 2 verified)
1. LSP workspaceSymbol query parameter (high confidence - dual source) -- affects lsp-integration/overview.md
2. NotebookEdit cell ID changes (high confidence) -- affects hook-development/references/hook-input-schemas.md

**May Update: 4 items** (Stage 2 refined from 9)
- /init .devin/rules and .windsurf/rules discovery
- Single-file grep read-before-edit
- Shell startup file confirmation prompts
- Agent tool usage notes for subagent-type (demoted from Must Update)

**No Action: 31 items** (23 original + 8 Stage 2 demoted)
- UI/UX improvements, bug fixes, internal infrastructure, platform support
- claude.ai-specific features (DesignSync, /design-sync)
- Internal behavior changes (durable approval, streaming guidance, etc.)

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | Y | Retrieved via WebFetch from upstream |
| System-prompts | Y | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | skipped | Agent dispatch returned empty output |

---

## Recommendations for Stage 3 (Updated by Stage 2)

### MUST UPDATE (2 items)

1. **LSP workspaceSymbol query parameter (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/lsp-integration/overview.md`
   - Action: Add guidance that workspaceSymbol requires a query parameter; many language servers return no results for empty query
   - Location: Add to "What Claude Gains from LSP" or "Code Navigation" section

2. **NotebookEdit cell ID changes (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/hook-development/references/hook-input-schemas.md`
   - Action: Update NotebookEdit tool_input schema (line 118) to include cell_id and cell_number parameters
   - Note: Notebooks must be read before editing; insert adds cells after target cell or at start

### MAY UPDATE (4 items - evaluate as Stage 3 proceeds)

3. **Single-file grep read-before-edit (LOW PRIORITY)**:
   - Single-file grep now satisfies read-before-edit verification
   - Minor documentation update to Edit tool section in hook-input-schemas

4. **Shell startup file confirmation prompts (LOW PRIORITY)**:
   - Security enhancement for Bash tool
   - Consider noting in hook-development for security-aware plugin authors

5. **/init config discovery expansion (LOW PRIORITY)**:
   - .devin/rules/ and .windsurf/rules/ now discovered
   - Not directly plugin-relevant; skip unless documenting project config patterns

6. **Agent tool subagent-type guidance (LOW PRIORITY)**:
   - Internal guidance refinement
   - Existing docs already cover subagent concepts; minimal update if any

### OUT OF SCOPE (removed from scope)

- ~~DesignSync tool and /design-sync command~~ - claude.ai-specific, not plugin API

---

## Stage 2: Verification Results
### Verified: 2026-06-04

#### Must Update Verification

- [check] **LSP workspaceSymbol query parameter** (CC 2.1.162) -- confirmed in CC changelog ("Fixed the LSP tool's `workspaceSymbol` operation returning no results") and system-prompts (Tool Description: LSP clarifies query should always be provided). Gap exists: lsp-integration/overview.md does not document workspaceSymbol query parameter guidance.
  - Affects: lsp-integration/overview.md
  - Action: Add guidance that workspaceSymbol requires a query parameter

- [check] **Agent tool usage notes for subagent-type** (CC 2.1.161) -- confirmed in system-prompts. Minor internal guidance refinement. Agent-development reference already has "Agent Tool Usage Notes (CC 2.1.140)" section at lines 453-465. Low priority; existing documentation covers subagent concepts.
  - Affects: agent-development/overview.md (minor clarification only)
  - Action: Consider adding note about subagent-type availability check

- [x-mark] **NEW DesignSync tool** (CC 2.1.160) -- confirmed in system-prompts but OUT OF SCOPE. DesignSync is a claude.ai/design-specific tool, not a general plugin API. Plugin-dev focuses on plugin development, not claude.ai integration. This tool does not affect the plugin system.
  - Reclassified: No Action (out of scope)

- [x-mark] **NEW /design-sync slash command** (CC 2.1.160, 2.1.162) -- confirmed in system-prompts but OUT OF SCOPE. Same reasoning as DesignSync. This is a claude.ai-specific feature, not a plugin API or pattern that plugin developers need to know about.
  - Reclassified: No Action (out of scope)

- [check] **NotebookEdit reworked around cell IDs** (CC 2.1.162) -- confirmed in system-prompts. Hook-input-schemas.md at line 118 documents NotebookEdit but lacks cell_id and cell_number parameters. The change affects how NotebookEdit works and hooks that intercept it.
  - Affects: hook-development/references/hook-input-schemas.md
  - Action: Update NotebookEdit tool_input schema to include cell_id/cell_number parameters

#### Missed Items (promoted from No Action)

- None identified. Scanned changelog entries for plugin-relevant keywords (hook, plugin, MCP, skill, frontmatter, manifest, PreToolUse, PostToolUse, Stop). The "Fixed Windows hooks that invoke bash explicitly" (CC 2.1.161) is a bug fix that doesn't require documentation changes since existing Windows/PowerShell guidance at line 1076 already covers cross-platform considerations.

#### May Update Resolution

- [up-arrow] **/init CLAUDE.md discovers .devin/rules/ and .windsurf/rules/** (CC 2.1.162) -- kept as May Update. Not directly plugin-relevant but may be useful context for skill-development documentation regarding how Claude discovers project configuration.
  - Verdict: Keep as May Update

- [down-arrow] **Durable approval context** (CC 2.1.161) -- demoted to No Action. This is an internal system prompt change about permission persistence. Plugin developers don't need to know about this; it affects Claude's behavior, not plugin APIs.
  - Verdict: No Action (internal behavior)

- [down-arrow] **Background monitor streaming-pipeline guidance** (CC 2.1.161) -- demoted to No Action. Internal guidance refinement for the Monitor tool. Not plugin-API relevant.
  - Verdict: No Action (internal guidance)

- [down-arrow] **Workflow tool ultracode keyword** (CC 2.1.160) -- demoted to No Action. Workflow tool is not part of the plugin system; it's a separate Claude Code feature. Plugin-dev doesn't document Workflow usage.
  - Verdict: No Action (not plugin-relevant)

- [down-arrow] **/code-review changes** (CC 2.1.160) -- demoted to No Action. These are changes to a built-in slash command, not plugin APIs. Plugin-dev focuses on how to create plugins, not how built-in commands work internally.
  - Verdict: No Action (built-in command internals)

- [equals] **Single-file grep read-before-edit** (CC 2.1.160) -- kept as May Update. This affects plugin documentation about the Edit tool. The hook-input-schemas.md documents Edit tool input, and agent-development discusses tool restrictions. Worth considering.
  - Verdict: Keep as May Update

- [equals] **Shell startup file confirmation prompts** (CC 2.1.160) -- kept as May Update. Security enhancement that affects Bash tool behavior. May be worth noting in hook-development or agent-development for security-conscious plugin authors.
  - Verdict: Keep as May Update

- [down-arrow] **Parallel Bash execution error handling** (CC 2.1.161) -- demoted to No Action. Internal execution behavior change, not a plugin API change.
  - Verdict: No Action (internal behavior)

- [down-arrow] **Bash PR instructions configurable slot** (CC 2.1.162) -- demoted to No Action. This is about PR workflow guidance injection, not plugin APIs.
  - Verdict: No Action (not plugin-relevant)

#### Summary

- **Must Update: 2 items** (3 confirmed, 2 rejected/reclassified as out of scope)
  1. LSP workspaceSymbol query parameter -- affects lsp-integration
  2. NotebookEdit cell ID changes -- affects hook-development

- **May Update: 4 items remaining** (from original 9)
  1. /init .devin/rules and .windsurf/rules discovery
  2. Single-file grep read-before-edit
  3. Shell startup file confirmation prompts
  4. (Agent tool subagent-type -- demoted to May Update from Must Update)

- **No Action: 28 items** (original 23 + 5 demoted/reclassified)

- **Confidence: HIGH**
  - CC changelog and system-prompts both confirm the relevant changes
  - DesignSync/design-sync correctly identified as out of scope for plugin-dev (these are claude.ai-specific features, not plugin APIs)
  - No missed plugin-relevant items found in scan
  - Stage 1 was slightly over-inclusive (counted claude.ai features as plugin-relevant), but this is the correct conservative approach
