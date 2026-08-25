# Upstream Change Manifest
## CC Version Range: 2.1.240 - 2.1.245
## Generated: 2026-08-25
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - no output]

---

### Must Update

- [ ] **Hook `if` condition command substitution fix** (CC 2.1.243)
  - Source: CC changelog
  - Confidence: high
  - Affects: hook-development (references/advanced.md, Conditional Hook Execution section)
  - Details: Fixed hook `if` conditions like `Bash(cat *)` firing on unrelated Bash commands when the command contained `$()` or backtick command substitution. This is a significant bug fix affecting hook reliability.
  - Target file: `plugins/plugin-dev/skills/plugin-dev/references/hook-development/references/advanced.md`
  - Add after CC 2.1.218 breaking change note (around line 80)

- [ ] **Plugin dependency resolution with marketplace field** (CC 2.1.243)
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-structure (references/advanced-topics.md, dependency handling section)
  - Details: Plugin dependencies declared with `marketplace` field now properly resolve when plugins load together via `--plugin-dir`. Previously, marketplace-sourced dependencies could fail to resolve in local testing scenarios.
  - Target file: `plugins/plugin-dev/skills/plugin-dev/references/plugin-structure/references/advanced-topics.md`
  - Add after "Dependency Auto-Install (CC 2.1.116)" section (around line 411)

- [ ] **LSP plugin reload warning** (CC 2.1.243)
  - Source: CC changelog
  - Confidence: high
  - Affects: lsp-integration (overview.md or references section)
  - Details: Fixed `/reload-plugins` keeping the LSP tool after the last LSP plugin is disabled; it now also warns before an LSP plugin change. Important behavior change for LSP plugin lifecycle management.
  - Target file: `plugins/plugin-dev/skills/plugin-dev/references/lsp-integration/overview.md`
  - Add new section or update existing reload/lifecycle guidance

- [ ] **Agent definition validation with --agents** (CC 2.1.243)
  - Source: CC changelog
  - Confidence: high
  - Affects: agent-development (overview.md, Testing Agents section; references/advanced-agent-fields.md)
  - Details: `--agents` CLI flag now exits with a clear error when given invalid JSON or invalid agent definitions, similar to `--mcp-config` behavior. Previously it silently ignored invalid definitions.
  - Target file: `plugins/plugin-dev/skills/plugin-dev/references/agent-development/overview.md`
  - Update "Testing Agents" section (around line 181)

---

### May Update

- [ ] **Write tool read-before-edit clarification** (CC 2.1.240)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: plugin-dev skill (tool behavior section)
  - Details: Clarifies that Write is for creating files or fully replacing previously read files, while partial modifications should use Edit. This is a refinement of existing guidance, not a breaking change.
  - Note: Already documented at CC 2.1.236 in hook-development (Edit/Write path-sensitive guidance); verify if any delta exists

- [ ] **Snooze tool polling prohibition and heartbeat guidance** (CC 2.1.240)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent-development (background agent guidance)
  - Details: Prohibits short-interval polling for harness-tracked background work, recommends a 1200-second-or-longer fallback heartbeat, and reserves short cache-preserving delays for external state such as CI runs, deployments, and remote queues. Relevant for plugins creating background monitoring workflows.
  - Note: Not currently documented; lower priority specialized use case

- [ ] **Agent tool simple usage notes review** (CC 2.1.240)
  - Source: system-prompts only
  - Confidence: low
  - Affects: agent-development (references/orchestration-and-tools.md)
  - Details: Existing documentation at CC 2.1.140 covers the same topics (when to delegate, fork behavior, resuming agents, worktree isolation, background execution, parallel launches, context restrictions). Review for any nuance differences in the v2.1.240 "concise" version.
  - Note: Reclassified from Must Update; likely no gap but worth verifying

---

### No Action

**Reclassified from original Must Update (already documented):**
- v2.1.240: Self-Modification protection expanded for agent configuration paths - Already documented at CC 2.1.140 in advanced-agent-fields.md
- v2.1.240: Worker fork clarification (parent guidance and direct execution) - Already documented at CC 2.1.169 in advanced-agent-fields.md

**Reclassified from original May Update (not plugin-relevant):**
- v2.1.243: modelPicker setting for organizational model selectors - Organization UI, not plugin-relevant
- v2.1.243: promptCacheTtl and subagentPromptCacheTtl settings - API holder settings, not plugin-relevant
- v2.1.243: Managed markers in /mcp and /plugins - Display only, informational
- v2.1.243: Model and effort level in /tasks - UI enhancement only

**Original No Action items:**
- v2.1.245: Startup crash fix on Linux glibc 2.44 (Arch Linux, CachyOS, Fedora Rawhide) - Platform bug fix, not plugin-related
- v2.1.243: Loops breakdown in `/usage` - UI enhancement for usage tracking
- v2.1.243: modelPricing managed setting - Organization billing, not plugin-related
- v2.1.243: Keyless sign-in via Anthropic Console - Authentication change, not plugin-related
- v2.1.243: GitHub connection status in `/status` - Web feature, not plugin-related
- v2.1.243: `/web-setup` guidance for GitHub configuration - Web feature
- v2.1.243: Auto reconnection for remote MCP servers - Internal reliability improvement
- v2.1.243: MCP OAuth sign-in fixes - Bug fix
- v2.1.243: Auto mode availability and tool call denial fixes - Bug fixes
- v2.1.243: `/resume` picker improvements (loads more than 50 sessions) - UI fix
- v2.1.243: Cloud session message handling fixes - Bug fix
- v2.1.243: Cross-session messaging fixes in user namespaces - Bug fix
- v2.1.243: Text rendering and spellcheck fixes - UI bug fixes
- v2.1.243: Background subagent wake behavior fix - Bug fix
- v2.1.243: API timeout (~3 minutes) with retry logic - Internal reliability
- v2.1.243: Performance optimizations (startup, binary size reduction, memory usage) - Internal improvements
- v2.1.243: `/login` improvements over SSH - UX improvement
- v2.1.243: Sonnet 5 pricing update - Pricing change
- v2.1.243: macOS computer use Finder access grants - Platform-specific
- v2.1.243: VSCode feature flag and Remote Control fixes - IDE extension fixes
- v2.1.241: SDK set_max_thinking_tokens (SDK-specific, not plugin development relevant)
- v2.1.241: No other changes in official changelog
- v2.1.240: No changes in official changelog (details from system-prompts only)

---

## Summary

**Version Range**: 2.1.240 - 2.1.245 (4 versions after last audit at 2.1.239)

**Source Analysis**:
- The official Claude Code changelog for versions 2.1.240 and 2.1.241 only shows "Bug fixes and reliability improvements" with no specific details
- The system-prompts changelog provides detailed information for these versions
- Version 2.1.243 has detailed changelog entries
- Version 2.1.245 has a specific fix documented
- claude-code-guide cross-reference was skipped (no output from dispatch)

**Token delta** (from system-prompts):
- 2.1.240: -1,911 tokens (net reduction due to prompt consolidation)
- 2.1.241: +182 tokens
- **Total**: -1,729 tokens

**Key Findings for Plugin-Dev**:

1. **Agent Tool Guidance Changes**: The new simplified Agent tool usage notes (CC 2.1.240) consolidates delegation guidance into a more concise form. This should be reviewed for alignment with plugin-dev's agent creation guidance.

2. **Self-Modification Path Protection**: The expanded protection for agent configuration paths (CC 2.1.240) affects what paths plugins and hooks can safely modify. The `.claude/worktrees/<name>/` exception is notable.

3. **Fork Behavior Clarification**: The worker fork guidance clarification (CC 2.1.240) about parent vs. fork responsibilities should be reflected in plugin-dev's fork-related documentation.

4. **Extended Thinking SDK Control**: The new `set_max_thinking_tokens` schema (CC 2.1.241) is relevant for advanced plugin development involving extended thinking.

5. **Write vs Edit Clarification**: The Write tool guidance refinement (CC 2.1.240) should be checked against plugin-dev's tool behavior documentation.

**Triangulation Notes**:
- Changes in 2.1.240-2.1.241 were only confirmed via system-prompts (changelog had no details)
- Changes in 2.1.243-2.1.245 were only confirmed via changelog (system-prompts not yet updated for these versions)
- claude-code-guide cross-reference was attempted but produced no output

**Priority Assessment**:
- 4 Must Update items (all medium confidence due to single-source confirmation)
- 6 May Update items (mixed confidence)
- 24 No Action items (bug fixes, UI changes, platform-specific features)

---

## Stage 2: Verification Results
### Verified: 2026-08-25

#### Must Update Verification

- ! **Agent tool simple usage notes** (CC 2.1.240) — RECLASSIFIED to May Update
  - Already documented at `references/agent-development/references/orchestration-and-tools.md` lines 5-16 as "Agent Tool Usage Notes (CC 2.1.140)"
  - The v2.1.240 changelog describes a "concise" form, but the existing documentation already covers: when to delegate, fork behavior, resuming agents, worktree isolation, background execution, parallel launches, and context restrictions
  - This appears to be upstream prompt consolidation (net -1,911 tokens in v2.1.240) rather than new functionality
  - May need review for any nuance differences, but not a documentation gap

- ! **Self-Modification protection expanded for agent configuration paths** (CC 2.1.240) — RECLASSIFIED to No Action (already documented)
  - Already fully documented at `references/agent-development/references/advanced-agent-fields.md` lines 629-643 as "Self-Modification Protected Paths (CC 2.1.140)"
  - Existing docs list all protected paths including the `.claude/worktrees/<name>/` exception
  - The v2.1.240 change "expands to explicit set" is a clarification of existing behavior, not new functionality

- ! **SDK set_max_thinking_tokens control request schema** (CC 2.1.241) — RECLASSIFIED to May Update
  - This is SDK-specific, not plugin-specific
  - Affects SDK users who control Claude Code programmatically, not plugin developers
  - Could be documented in advanced-agent-fields.md if extended thinking is relevant to plugin development
  - Lower priority; does not affect typical plugin development workflows

- ! **Worker fork clarification: parent guidance and direct execution** (CC 2.1.240) — RECLASSIFIED to No Action (already documented)
  - Already documented at `references/agent-development/references/advanced-agent-fields.md` lines 420-436 as "Worker Fork Guidance (CC 2.1.169, updated 2.1.232)"
  - Line 422: "Forked worker agents receive explicit guidance that they should **not spawn further subagents**. Instead, they should execute their assigned directive directly."
  - The v2.1.240 change clarifies guidance ownership (parent vs fork) but the core behavior is documented

#### Missed Items (promoted from No Action)

- ! **Hook `if` condition command substitution fix** (CC 2.1.243) — PROMOTED TO Must Update
  - Source: CC changelog
  - Missed because changelog entry was buried in "various other bug fixes" classification
  - Details: "Fixed hook `if` conditions like `Bash(cat *)` firing on unrelated Bash commands when the command contained `$()` or backtick command substitution"
  - Affects: hook-development (references/advanced.md, Conditional Hook Execution section)
  - This is a significant bug fix that affects hook reliability; plugin developers should know about it

- ! **Plugin dependency resolution with marketplace field** (CC 2.1.243) — PROMOTED TO Must Update
  - Source: CC changelog
  - Missed because classified as generic bug fix
  - Details: "Plugin dependencies declared with `marketplace` field now properly resolve when plugins load together via `--plugin-dir`"
  - Affects: plugin-structure (references/advanced-topics.md, dependency handling section)
  - Important for plugins with marketplace-sourced dependencies

- ! **LSP plugin reload warning** (CC 2.1.243) — PROMOTED TO Must Update
  - Source: CC changelog
  - Missed because classified as generic bug fix
  - Details: "Fixed `/reload-plugins` keeping the LSP tool after the last LSP plugin is disabled; it now also warns before an LSP plugin change"
  - Affects: lsp-integration (overview.md or new troubleshooting section)
  - Relevant behavior change for LSP plugin developers

- ! **Agent definition validation with --agents** (CC 2.1.243) — PROMOTED TO Must Update
  - Source: CC changelog
  - Missed because classified as generic bug fix
  - Details: "`--agents` silently ignoring invalid JSON or invalid agent definitions; it now exits with a clear error, like `--mcp-config`"
  - Affects: agent-development (overview.md, Testing Agents section)
  - Important debugging improvement for agent developers

#### May Update Resolution

- = **Write tool read-before-edit clarification** (CC 2.1.240) — Kept as May Update
  - Already documented at CC 2.1.236 in hook-development (Edit/Write path-sensitive read-before-edit guidance)
  - The v2.1.240 change may refine this; verify if any delta exists

- = **Snooze tool polling prohibition and heartbeat guidance** (CC 2.1.240) — Kept as May Update
  - Relevant for background monitoring plugins
  - Not currently documented in plugin-dev; could add to agent-development background sections
  - Lower priority; specialized use case

- ↓ **modelPicker setting** (CC 2.1.243) — DEMOTED to No Action
  - Organization-level setting for customizing `/model` picker
  - Not plugin-relevant; plugins cannot influence model picker UI

- ↓ **promptCacheTtl and subagentPromptCacheTtl settings** (CC 2.1.243) — DEMOTED to No Action
  - Performance tuning for API key holders
  - Not plugin-relevant; plugins don't control cache TTL

- ↓ **Managed markers in /mcp and /plugins** (CC 2.1.243) — DEMOTED to No Action
  - Display enhancement for managed environments
  - Informational only; no plugin development impact

- ↓ **Model and effort level in /tasks** (CC 2.1.243) — DEMOTED to No Action
  - UI enhancement for debugging
  - Informational only; no plugin development impact

#### Summary

- **Must Update**: 4 items (0 confirmed from original, 4 added from missed items)
  - Hook `if` condition command substitution fix (CC 2.1.243)
  - Plugin dependency marketplace field resolution (CC 2.1.243)
  - LSP plugin reload warning (CC 2.1.243)
  - Agent definition validation (CC 2.1.243)
- **May Update**: 3 items remaining (2 kept, 1 demoted from original Must Update)
  - Write tool read-before-edit clarification (CC 2.1.240)
  - Snooze tool polling prohibition (CC 2.1.240)
  - Agent tool simple usage notes (CC 2.1.240) — review for nuance differences
- **No Action**: All others (original 4 Must Update items reclassified + 4 May Update demoted)
- **Confidence**: HIGH — independent verification found original Must Update items were already documented; real gaps are in v2.1.243 bug fixes

#### Verification Notes

1. **Source discrepancy**: System-prompts CHANGELOG only goes up to v2.1.241; versions 2.1.242-2.1.245 have no system-prompts entries yet
2. **CC changelog gaps**: Versions 2.1.240-2.1.241 show only "Bug fixes and reliability improvements" in CC changelog; detailed changes come from system-prompts
3. **Token reduction explained**: The -1,911 token reduction in v2.1.240 represents prompt consolidation/simplification, not feature removal
4. **All original Must Update items were already documented**: This indicates Stage 1 may not have adequately checked existing plugin-dev documentation before classifying gaps

#### Significant Issues Flag

**> 30% rejection rate**: 4/4 (100%) of original Must Update items were rejected or reclassified. This suggests Stage 1 needs improvement in:
- Checking existing plugin-dev documentation before classifying as "Must Update"
- Distinguishing between upstream prompt changes and actual feature/behavior changes
- Better scanning of changelog bug fix sections for plugin-relevant items
