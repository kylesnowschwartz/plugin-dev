# Upstream Change Manifest
## CC Version Range: 2.1.171 - 2.1.176
## Generated: 2026-06-13
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped]

Note: claude-code-guide agent dispatch was skipped as comprehensive data from two independent sources (official CC changelog and system-prompts changelog) provides sufficient triangulation.

---

### Must Update

- [ ] **Fork subagent_type explicit requirement** (CC 2.1.176)
  - Source: system-prompts changelog (2.1.176)
  - Confidence: high
  - Affects: agent-development reference documentation
  - Details: Creating a background fork now requires passing `subagent_type: "fork"` explicitly instead of omitting `subagent_type`. Omitting the type or using any other type now starts a fresh agent with no context. This is a behavioral change that affects how agents are documented and created.
  - Raw: "Fork usage guidelines - Updates the 'when to fork' instruction to fork by passing `subagent_type: \"fork\"` instead of omitting `subagent_type`."

- [ ] **Sub-agents can now spawn their own sub-agents (5 levels deep)** (CC 2.1.172)
  - Source: official changelog (2.1.172)
  - Confidence: high
  - Affects: agent-development reference documentation
  - Details: Previously sub-agents could not spawn further sub-agents. Now they can nest up to 5 levels deep. This enables more complex orchestration patterns. Must reconcile with CC 2.1.169 worker fork guidance that says forked workers should not spawn further subagents.
  - Raw: "Sub-agents can now spawn their own sub-agents (up to 5 levels deep)"

- [ ] **Skill hot-reload optimization** (CC 2.1.174)
  - Source: official changelog (2.1.174)
  - Confidence: high
  - Affects: skill-development reference documentation
  - Details: Skill hot-reload now only re-sends changed skills instead of the entire skill listing. Performance improvement for skill developers iterating on skills.
  - Raw: "Fixed skill hot-reload re-sending the entire skill listing when a single skill changed; only changed skills are now re-announced"

---

### May Update

- [ ] **footerLinksRegexes setting** (CC 2.1.176)
  - Source: official changelog (2.1.176)
  - Confidence: low
  - Affects: plugin-settings documentation (if managed settings are documented)
  - Details: New setting for regex-matched link badges in the footer row. Only relevant if plugin-settings documents user/managed settings.
  - Raw: "Added `footerLinksRegexes` setting for regex-matched link badges in the footer row"

- [ ] **Security monitor for autonomous agents expanded** (CC 2.1.172, 2.1.174)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development documentation (autonomous operation section)
  - Details: Multiple expansions to security monitor guidance for autonomous agent actions. Could affect guidance for designing autonomous plugin agents.

- [ ] **Hook if conditions bug fix** (CC 2.1.176)
  - Source: official changelog (2.1.176)
  - Confidence: low
  - Affects: hook-development documentation
  - Details: Patterns like `Edit(src/**)`, `Read(~/.ssh/**)`, and `Read(.env)` now match correctly. Existing documentation is correct; could add version note.
  - Raw: "Fixed hook `if` conditions for Read/Edit/Write tool paths"

---

### No Action

**Demoted from Must Update (Stage 2 verification):**
- claude.ai Project tool (CC 2.1.174) - New Claude capability, not plugin system documentation
- Artifact tool for HTML/Markdown deployment (CC 2.1.172) - New Claude capability, not plugin system documentation
- Claude Fable 5 model identity (CC 2.1.172) - Internal model identity, not plugin-dev scope
- Cowork onboarding role picker tool (CC 2.1.172) - Cowork is separate product, not documented in plugin-dev

**Demoted from May Update (Stage 2 verification):**
- enforceAvailableModels managed setting (CC 2.1.175) - Enterprise setting, not plugin-dev relevant
- wheelScrollAccelerationEnabled setting (CC 2.1.174) - UI setting, not plugin-dev relevant
- Workflow tool agent() returns null (CC 2.1.166) - Outside version range (pre-2.1.171)
- WebFetch Artifact URL exception (CC 2.1.176) - Claude tool capability, not plugin system
- Coordinator mode parallel worker guidance (CC 2.1.176) - Claude behavior, not plugin system
- Managed Agents scheduled deployments (CC 2.1.172) - Separate product from plugins

**Original No Action items:**
- Session titles generated in conversation language (CC 2.1.176) - UI feature
- Bedrock credential caching improvements (CC 2.1.176) - Provider-specific
- Fixed availableModels enforcement for alias model picks (CC 2.1.176) - Bug fix
- Fixed auto mode failing on Fable 5 (CC 2.1.176) - Bug fix
- Fixed Linux sandbox with symlinked settings (CC 2.1.176) - Bug fix
- Fixed clipboard in tmux over SSH (CC 2.1.176) - Bug fix
- Fixed Remote Control model switching (CC 2.1.176) - Bug fix
- Fixed /cd and worktree git branch reporting (CC 2.1.176) - Bug fix
- Fixed claude agents back navigation (CC 2.1.176) - Bug fix
- Fixed backgrounded sessions showing "Working" forever (CC 2.1.176) - Bug fix
- Various background agent and Windows fixes (CC 2.1.176) - Bug fixes
- Fixed Fable 5 model name normalization (CC 2.1.173) - Bug fix
- Fixed spurious sandbox warning on Windows (CC 2.1.173) - Bug fix
- Fixed /model picker hiding model family (CC 2.1.174) - UI fix
- Fixed Fable 5 usage credits banner (CC 2.1.174) - Bug fix
- Fixed Bedrock GovCloud regions (CC 2.1.174) - Provider-specific
- Various background session and co-author fixes (CC 2.1.174) - Bug fixes
- Search bar in /plugin marketplace browser (CC 2.1.172) - UI feature
- OTEL metric model attribute (CC 2.1.172) - Telemetry
- Fixed 1M context sessions getting stuck (CC 2.1.172) - Bug fix
- Fixed image processing errors (CC 2.1.172) - Bug fix
- Fixed agents view spinner timing (CC 2.1.172) - UI fix
- Fixed background agent settings issues (CC 2.1.172) - Bug fixes
- Fixed /model suggestions and availableModels restrictions (CC 2.1.172) - Bug fixes
- Fixed WebFetch wildcard domain rules (CC 2.1.172) - Bug fix
- Fixed memory recall in remote sessions (CC 2.1.172) - Bug fix
- Fixed workflow validation Date.now()/Math.random() (CC 2.1.172) - Bug fix
- Various mouse, plugin, performance improvements (CC 2.1.172) - Misc fixes
- REMOVED: Claude in Chrome skill note (CC 2.1.176) - Internal prompt removal
- REMOVED: Design sync modules consolidated (CC 2.1.174) - Internal refactoring
- Design sync workflow expansions (CC 2.1.172-2.1.176) - Anthropic internal skill
- Claude API reference updates for Fable 5 (CC 2.1.172-2.1.176) - API docs, not plugin-dev
- Model migration guide updates (CC 2.1.172-2.1.176) - Migration docs
- Streaming reference updates (CC 2.1.172) - API docs
- HTTP error codes reference updates (CC 2.1.172) - API docs
- Live documentation sources updates (CC 2.1.172) - Reference links
- Managed Agents client/core/endpoint/events updates (CC 2.1.172) - Managed Agents specific

---

## Summary

**Critical changes requiring documentation updates:**
1. Fork subagent_type must now be explicit (`subagent_type: "fork"`)
2. Sub-agents can now nest 5 levels deep
3. Skill hot-reload optimization (only changed skills re-announced)

**Version note:** The official changelog shows versions 2.1.172, 2.1.173, 2.1.174, 2.1.175, 2.1.176 after 2.1.170. The system-prompts changelog confirms prompt changes in 2.1.172, 2.1.174, and 2.1.176 (with no changes in 2.1.173, 2.1.175, 2.1.177).

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | Y | Retrieved via curl from upstream GitHub raw |
| System-prompts | Y | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | skipped | Comprehensive dual-source data sufficient |

---

## Recommendations for Stage 3

### MUST UPDATE (3 items)

1. **Fork subagent_type explicit requirement (HIGH PRIORITY)**:
   - Files: agent-development documentation
   - Action: Update guidance to note that `subagent_type: "fork"` must be passed explicitly; omitting subagent_type now starts a fresh agent
   - Note: Breaking behavioral change affecting agent orchestration patterns

2. **Sub-agent nesting depth (MEDIUM PRIORITY)**:
   - Files: agent-development documentation
   - Action: Update guidance to note sub-agents can spawn sub-agents (5 levels max)
   - Note: Enables complex orchestration patterns; reconcile with existing CC 2.1.169 worker fork guidance

3. **Skill hot-reload optimization (LOW PRIORITY)**:
   - Files: skill-development documentation
   - Action: Add note that skill hot-reload now only re-sends changed skills (CC 2.1.174)
   - Note: Performance improvement for skill developers

### MAY UPDATE (3 items - evaluate as Stage 3 proceeds)

- footerLinksRegexes setting (if plugin-settings documents managed settings)
- Security monitor expansions (affects autonomous plugin agent behavior)
- Hook if conditions bug fix (add version note to existing documentation)

---

## Stage 2: Verification Results
### Verified: 2026-06-13

#### Must Update Verification
- ! **Fork subagent_type explicit requirement** (CC 2.1.176) -- confirmed in system-prompts changelog 2.1.176; gap exists in agent-development/overview.md (Worker Fork Guidance section at lines 438-447 does not document new explicit requirement)
- ! **Sub-agents can now spawn their own sub-agents (5 levels deep)** (CC 2.1.172) -- confirmed in official changelog; gap exists (agent-development mentions CC 2.1.169 guidance that forked workers should not spawn subagents, but 5-level nesting is not documented)
- ! **Skill hot-reload optimization** (CC 2.1.174) -- PROMOTED from May Update; confirmed in official changelog; gap exists in skill-development/overview.md (Hot-Reloading section at lines 504-513 does not mention this performance improvement)
- X **claude.ai Project tool** (CC 2.1.174) -- rejected: new Claude capability, not plugin system documentation
- X **Artifact tool** (CC 2.1.172) -- rejected: new Claude capability, not plugin system documentation
- X **Claude Fable 5 model identity** (CC 2.1.172) -- rejected: internal model identity, not plugin-dev documentation scope
- X **Cowork onboarding role picker** (CC 2.1.172) -- rejected: Cowork is separate product, not documented in plugin-dev
- X **Hook if conditions for file paths** (CC 2.1.176) -- reclassified to May Update: bug fix validating existing correct documentation

#### Missed Items (promoted from No Action)
- ! **Skill hot-reload optimization** (CC 2.1.174) -- missed in original classification as "May Update" with low confidence; promoted to Must Update
  - Affects: skill-development reference documentation
  - Details: Performance improvement that skill developers should know about when iterating

#### May Update Resolution
- = footerLinksRegexes setting -- kept as May Update: only relevant if plugin-settings documents managed settings (verify during Stage 3)
- = Security monitor expansions -- kept as May Update: may affect autonomous agent design guidance (evaluate during Stage 3)
- = Hook if conditions bug fix -- kept as May Update: existing documentation is correct, version note optional
- v enforceAvailableModels managed setting -- demoted to No Action: enterprise setting, not plugin-dev relevant
- v wheelScrollAccelerationEnabled setting -- demoted to No Action: UI setting, not plugin-dev relevant
- v Workflow tool agent() null return -- demoted to No Action: outside version range (CC 2.1.166, pre-2.1.171)
- v WebFetch Artifact URL exception -- demoted to No Action: Claude tool capability, not plugin system
- v Coordinator mode parallel worker guidance -- demoted to No Action: Claude behavior, not plugin system
- v Managed Agents scheduled deployments -- demoted to No Action: separate product from plugins

#### Summary
- Must Update: 3 items (3 confirmed, 4 rejected from original 7)
- May Update: 3 items remaining (6 demoted to No Action)
- No Action: 10 items added (4 from Must Update, 6 from May Update)
- Confidence: HIGH -- independent verification against raw changelogs confirms Stage 1 captured changes correctly but over-classified non-plugin-relevant items

#### Verification Notes
- **Sources independently verified**: Fetched CC changelog via WebFetch; read system-prompts CHANGELOG.md directly
- **Topic mappings verified**: Read agent-development/overview.md, hook-development/overview.md, skill-development/overview.md to confirm affected sections
- **Keyword scan performed**: Searched for hook, plugin, agent, skill, tool, permission, subagent, MCP, frontmatter in changelog entries
- **Version range confirmed**: 2.1.171-2.1.176 (last audited: 2.1.170)
- **No significant issues**: Original Stage 1 identified changes correctly; corrections are primarily about relevance filtering for plugin-dev scope
