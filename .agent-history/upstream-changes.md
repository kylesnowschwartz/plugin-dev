# Upstream Change Manifest
## CC Version Range: 2.1.157 - 2.1.158
## Generated: 2026-05-31
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - small change set]

---

### Must Update

- [ ] **`claude plugin init <name>` command to scaffold new plugins** (CC 2.1.157)
  - Source: CC changelog
  - Confidence: HIGH
  - Affects: `plugin-structure/overview.md` (Plugin CLI section)
  - Details: New CLI command that scaffolds a new plugin structure in `.claude/skills`. This is a significant addition for plugin developers as it provides an official way to create new plugins with proper structure.
  - Raw changelog: "Added `claude plugin init <name>` command to scaffold new plugins"

- [ ] **Plugins in `.claude/skills` directories automatically load without marketplace requirement** (CC 2.1.157)
  - Source: CC changelog
  - Confidence: HIGH
  - Affects: `skill-development/overview.md` (Skill Precedence section), `plugin-structure/overview.md`
  - Details: Skills placed in `.claude/skills/` now load automatically without needing to be published to the marketplace or installed. This changes the development workflow significantly - local skills are now first-class citizens.
  - Raw changelog: "Plugins in `.claude/skills` directories automatically load without marketplace requirement"

- [ ] **EnterWorktree tool can switch between Claude-managed worktrees mid-session** (CC 2.1.157)
  - Source: CC changelog, system-prompts
  - Confidence: HIGH
  - Affects: `agent-development/overview.md` (Worktree Base Reference section at line ~678)
  - Details: The EnterWorktree tool now allows switching by `path` from an existing worktree session or pinned agent into another registered `.claude/worktrees/` worktree, with cleanup and writability limits clarified.
  - Raw changelog: "`EnterWorktree` can switch between Claude-managed worktrees mid-session"
  - System-prompts: "Tool Description: EnterWorktree - Allows switching by `path` from an existing worktree session or pinned agent into another registered `.claude/worktrees/` worktree, with cleanup and writability limits clarified."

- [ ] **Agent field in `settings.json` now honored for dispatched sessions** (CC 2.1.157)
  - Source: CC changelog
  - Confidence: HIGH
  - Affects: `agent-development/overview.md` (new section needed for agent dispatch configuration)
  - Details: When dispatching agent sessions via `claude agents`, the `agent` field in settings.json is now respected. This affects how dispatched sessions select which agent to run.
  - Raw changelog: "Agent field in `settings.json` now honored for dispatched sessions"

---

### May Update

- [ ] **Autocomplete enhancements for `/plugin` arguments** (CC 2.1.157)
  - Source: CC changelog
  - Confidence: medium
  - Affects: plugin command documentation
  - Details: Improved autocomplete for plugin-related slash commands. May warrant mention in usage documentation.

- [ ] **Auto mode available on Bedrock, Vertex, and Foundry for Opus 4.7 and 4.8** (CC 2.1.158)
  - Source: CC changelog
  - Confidence: high
  - Affects: deployment/provider documentation if plugin-dev covers it
  - Details: Auto mode can now be enabled on non-Anthropic providers via `CLAUDE_CODE_ENABLE_AUTO_MODE=1`. This is primarily relevant for enterprise deployments.

- [ ] **Tool use concepts - guidance on tool descriptions prescribing when to call each tool** (CC 2.1.157)
  - Source: system-prompts
  - Confidence: medium
  - Affects: skill-authoring best practices
  - Details: New guidance that tool descriptions should prescribe when to call each tool, especially to improve should-call behavior on recent Opus models. May be relevant for skill description best practices.

- [ ] **Opus 4.8 migration guidance in Model migration guide** (CC 2.1.157)
  - Source: system-prompts
  - Confidence: low
  - Affects: model compatibility notes if any
  - Details: Adds Opus 4.8 migration guidance to put tool-triggering instructions in each tool's own description, not only in the system prompt.

- [ ] **Security monitor for autonomous agent actions expansion** (CC 2.1.157)
  - Source: system-prompts
  - Confidence: low
  - Affects: agent security documentation if present
  - Details: Expands high-severity review for persistent configuration changes, outbound submissions, novel destinations, and low-information actions whose intent is clarified by the agent's narration.

---

### No Action

- Bug fixes: unprocessable images no longer crash requests (CC 2.1.157) - internal bug fix
- Sandbox network permission prompts fixed in auto mode (CC 2.1.157) - internal bug fix
- Background session retirement improved (CC 2.1.157) - internal improvement
- Enhanced worktree management and clipboard functionality (CC 2.1.157) - internal improvement
- Terminal UI improvements and performance optimizations (CC 2.1.157) - internal improvement
- Version 2.1.158: No changes to system prompts

---

## Summary

Two versions were released after the last audit (2.1.156):

- **2.1.157**: Major plugin-system changes including `claude plugin init`, automatic `.claude/skills` loading, EnterWorktree enhancements, and settings.json agent field support
- **2.1.158**: Auto mode expansion to additional providers (minimal plugin-dev impact)

**Must Update: 4 items**
1. `claude plugin init <name>` command - new plugin scaffolding command
2. Automatic `.claude/skills` loading - changes plugin development workflow
3. EnterWorktree mid-session switching - worktree tool enhancement
4. Settings.json agent field honored for dispatched sessions - agent configuration inheritance

**May Update: 5 items**
- `/plugin` autocomplete enhancements
- Auto mode on Bedrock/Vertex/Foundry
- Tool description guidance for should-call behavior
- Opus 4.8 migration guidance
- Security monitor expansion

**No Action: 6 items**
- Internal bug fixes and UI improvements
- No system prompt changes in 2.1.158

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | OK | Retrieved via WebFetch from upstream |
| System-prompts | OK | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | skipped | Small change set; single-source items flagged appropriately |

---

## Recommendations for Stage 3

1. **Plugin scaffolding command (HIGH PRIORITY)**:
   - Document `claude plugin init <name>` command in `plugin-structure/overview.md`
   - This is a major developer experience improvement

2. **Automatic skill loading (HIGH PRIORITY)**:
   - Document that `.claude/skills/` directories load automatically without marketplace
   - Update `skill-development/overview.md` and `plugin-structure/overview.md`
   - This fundamentally changes how local plugins are developed

3. **EnterWorktree enhancements (MEDIUM PRIORITY)**:
   - Document mid-session worktree switching capability in `agent-development/overview.md`
   - Add `path` parameter documentation to worktree section

4. **Settings agent field (MEDIUM PRIORITY)**:
   - Document that `agent` field in settings.json is now honored for dispatched sessions
   - Update `agent-development/overview.md` (agent dispatch section)

---

## Stage 2: Verification Results
### Verified: 2026-05-31

#### Must Update Verification
- [x] **`claude plugin init <name>` command** (CC 2.1.157) -- CONFIRMED in CC changelog; gap verified (no "plugin init" references in plugin-dev docs)
  - Topic mapping correction: "plugin-authoring skill" does not exist; target should be `plugin-structure/overview.md`
- [x] **Plugins in `.claude/skills` directories automatically load** (CC 2.1.157) -- CONFIRMED in CC changelog; gap verified (partial mention at skill-development/overview.md:42 mentions precedence but NOT automatic loading without marketplace)
  - Target: `skill-development/overview.md`, `plugin-structure/overview.md`
- [x] **EnterWorktree mid-session switching** (CC 2.1.157) -- CONFIRMED in both CC changelog and system-prompts changelog; gap verified (no "mid-session" or "switch.*worktree" in docs; existing worktree section at agent-development/overview.md:678-694 lacks this)
  - Target: `agent-development/overview.md` (worktree section)
- [x] **Agent field in settings.json honored for dispatched sessions** (CC 2.1.157) -- CONFIRMED in CC changelog; gap verified (no documentation of `agent` field for dispatch; only Task() restrictions documented)
  - Target: `agent-development/overview.md`

#### Missed Items (promoted from No Action)
- ! **Worktrees remain unlocked after agent completion** (CC 2.1.157) -- NOT promoted. This is a behavioral change for cleanup convenience, not a plugin API change. Keep in No Action.
- ! **`tool_decision` telemetry with OTEL_LOG_TOOL_DETAILS=1** (CC 2.1.157) -- NOT promoted. Telemetry/debugging feature, not plugin-relevant.

#### May Update Resolution
- = **`/plugin` autocomplete enhancements** (CC 2.1.157) -- kept as May Update. Nice-to-document UX improvement but not critical for plugin developers.
- = **Auto mode on Bedrock/Vertex/Foundry** (CC 2.1.158) -- kept as May Update. Enterprise deployment topic; plugin-dev does not cover provider deployment.
- = **Tool description guidance for should-call behavior** (CC 2.1.157 system-prompts) -- kept as May Update. Best practice guidance; could inform skill description writing but not directly actionable.
- = **Opus 4.8 migration guidance** (CC 2.1.157 system-prompts) -- kept as May Update. Model-specific guidance; low plugin relevance.
- = **Security monitor expansion** (CC 2.1.157 system-prompts) -- kept as May Update. Agent security topic; not directly plugin-authoring related.

#### Summary
- Must Update: 4 items (4 confirmed, 0 rejected, 0 added)
- May Update: 5 items remaining (0 promoted, 0 demoted)
- No Action: 6 items (no changes)
- Confidence: HIGH -- all Must Update items verified against primary sources; topic mappings corrected; no significant gaps found beyond those identified
