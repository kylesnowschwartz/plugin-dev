# Upstream Change Manifest
## CC Version Range: 2.1.179 - 2.1.183
## Generated: 2026-06-19
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [failed - empty response in CI]

---

### Must Update

> **Stage 2 Verified**: 4 items confirmed, 5 rejected or reclassified. See Stage 2 Verification Results below.

- [ ] **New `/config key=value` syntax for prompt-based settings** (CC 2.1.181)
  - Source: changelog
  - Confidence: HIGH (verified)
  - Affects: command-development
  - Details: Users can now change settings directly from the prompt using `/config key=value` syntax. This is a new command pattern that should be documented in the commands reference.
  - Action: Document new `/config key=value` syntax as alternative to slash command menu

- [ ] **New `tool_use_meta` display metadata field** (CC 2.1.181)
  - Source: system-prompts
  - Confidence: HIGH (verified)
  - Affects: mcp-integration
  - Details: New wrapper-level field carrying per-block display metadata: `display_name` (from MCP server's `tool.annotations.title`), `server_display_name`, and `icon_url`. Keyed by tool_use block id, omitted for built-in tools, and never replayed to the model.
  - Action: Document wrapper-level `tool_use_meta` field for MCP tool display metadata

- [ ] **Enhanced auto mode security: blocked destructive git/terraform commands** (CC 2.1.182-2.1.183)
  - Source: changelog, system-prompts
  - Confidence: HIGH (both sources)
  - Affects: agent-development (auto mode section)
  - Details: Auto mode now blocks destructive git commands (`git commit --amend` rewriting pre-session HEAD, `git stash drop/clear`, `git restore`, `git clean -fd[x]`, `git checkout -- .`) and infrastructure destruction (`terraform/pulumi/cdk/terragrunt destroy`). This affects how autonomous operations work.
  - Action: Document blocked commands list for autonomous agents

- [ ] **Security monitor: read-only authorization inheritance** (CC 2.1.179)
  - Source: system-prompts
  - Confidence: HIGH (verified)
  - Affects: agent-development (permissions section)
  - Details: Once a user authorizes read-only access to a particular target, further read-only commands against it are cleared for the session without per-command re-approval. Also, post-block reaffirmation ("yes", "go ahead") now inherits the specificity of the blocked action.
  - Action: Document read-only authorization persistence behavior

#### Rejected/Reclassified Items (from original Must Update)

- ~~**New `sandbox.allowAppleEvents` setting for macOS**~~ (CC 2.1.181) — DEMOTED to May Update: platform-specific sandbox setting, low plugin relevance
- ~~**New `attribution.sessionUrl` setting**~~ (CC 2.1.183) — DEMOTED to May Update: git attribution setting, not plugin-specific
- ~~**New Artifact tool with design skill**~~ (CC 2.1.172) — REJECTED: version 2.1.172 is outside audit range (2.1.179-2.1.183)
- ~~**New `Migrate to Claude Code` skill**~~ (CC 2.1.182) — DEMOTED to May Update: bundled Claude Code skill, not plugin development pattern
- ~~**New claude.ai Project tool**~~ (CC 2.1.174) — REJECTED: version 2.1.174 is outside audit range (2.1.179-2.1.183)

---

### May Update

> **Stage 2 Verified**: 5 items remain. 3 demoted to No Action. See Stage 2 Verification Results below.

- [ ] **New `sandbox.allowAppleEvents` setting for macOS** (CC 2.1.181)
  - Source: changelog
  - Confidence: medium
  - Affects: plugin-settings (if expanded to cover sandbox settings)
  - Details: New setting to allow Apple Events in macOS sandboxed environments.

- [ ] **New `attribution.sessionUrl` setting** (CC 2.1.183)
  - Source: changelog
  - Confidence: medium
  - Affects: plugin-settings (if expanded to cover git attribution)
  - Details: New setting controlling whether session URLs are included in git commit/PR attributions.

- [ ] **Live-Shared Artifact Sensitive Delta security block** (CC 2.1.179)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: Artifact tool documentation, security guidance (if we document Artifact tool)
  - Details: New security check that fires when an Artifact action with `[shared-live:]` marker adds new sensitive information (secrets, personal data) the owner would regret exposing to viewers.

- [ ] **Plugin loading performance improvements in remote sessions** (CC 2.1.179)
  - Source: changelog
  - Confidence: low (single source, vague)
  - Affects: possibly plugin performance documentation
  - Details: "Improved plugin loading performance in remote sessions" - no specific details available.

- [ ] **Migrate to Claude Code skill** (CC 2.1.182)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (informational only)
  - Details: New bundled skill for migrating from OpenAI Codex or Gemini CLI. Demonstrates a built-in skill pattern but not directly relevant to plugin skill development.

#### Demoted to No Action

- ~~**Cross-session peer message authority warning changes**~~ (CC 2.1.181) — internal wording changes, not plugin development concern
- ~~**Removed skills: /catch-up, /dream, /morning-checkin, /pre-meeting-checkin**~~ (CC 2.1.181) — internal/experimental skills, plugin-dev docs don't reference them
- ~~**Removed assistant voice/values template and user profile memory template**~~ (CC 2.1.181) — internal template changes
- ~~**Deprecation warnings for requested models**~~ (CC 2.1.183) — user-facing warning, not plugin development relevant
- ~~**Bundled Bun runtime upgraded to 1.4**~~ (CC 2.1.181) — internal runtime, not plugin-relevant
- ~~**Cowork onboarding role picker tool**~~ (CC 2.1.172) — version 2.1.172 is outside audit range

---

### No Action

- Preserved partial responses on mid-stream connection drops (CC 2.1.179) - internal reliability
- Fixed mouse-wheel scrolling in WSL2 (CC 2.1.179) - UI bug fix
- Fixed sandbox glob operations causing unusable sessions on Linux (CC 2.1.179) - bug fix
- Fixed thinking blocks returning empty (CC 2.1.183) - bug fix
- Fixed WebSearch in subagents (CC 2.1.183) - bug fix
- Fixed terminal cursor positioning (CC 2.1.183) - UI bug fix
- Fixed fullscreen TUI corruption (CC 2.1.183) - UI bug fix
- Fixed MCP server authentication exposure (CC 2.1.183) - security bug fix
- Improved paragraph streaming (CC 2.1.181) - internal improvement
- Auto-retry for API connection drops (CC 2.1.181) - internal reliability
- Fixed prompt caching issues on custom API URLs and Foundry (CC 2.1.181) - bug fix
- Fixed Write/Edit file truncation on network drives (CC 2.1.181) - bug fix
- Data: Claude API references updates for various languages (system-prompts) - external SDK docs
- Data: Tool use concepts additions (system-prompts) - external API docs
- Data: Managed Agents documentation updates (system-prompts) - external service docs
- Skill: Design sync updates (system-prompts) - internal/specialized skill
- Skill: Building LLM-powered applications updates (system-prompts) - external guidance
- Data: HTTP error codes reference updates (system-prompts) - external API docs
- Data: Claude model catalog updates for Fable 5/Mythos (system-prompts) - model documentation
- System Prompt: Coordinator mode orchestration updates (system-prompts) - internal behavior
- Tool Description: SendUserFile example added (system-prompts) - minor doc addition
- Claude Fable 5 model identity prompt (CC 2.1.172) - model-specific identity, not plugin relevant
- Chrome browser MCP tool batching guidance (CC 2.1.172) - internal browser automation

---

## Summary

**Version range audited:** 2.1.179 through 2.1.183 (5 versions after last audit of 2.1.178)

**Stage 2 Verified Counts:**
- Must Update: 4 items (verified, HIGH confidence)
- May Update: 5 items (low-to-medium plugin relevance)
- No Action: 28+ items (including 6 demoted from May Update)

**Key themes in this release range:**
1. **Security enhancements**: Auto mode blocks more destructive commands, read-only authorization inheritance
2. **Configuration**: `/config key=value` command syntax
3. **MCP metadata**: New `tool_use_meta` field for MCP tool display

**Items outside audit range (excluded):**
- Artifact tool (2.1.172), claude.ai Project tool (2.1.174), Cowork role picker (2.1.172)

**Triangulation notes:**
- claude-code-guide agent dispatch failed (empty response in CI environment)
- Two-source triangulation used: changelog + system-prompts
- Changes confirmed in both sources marked as high confidence
- Single-source changes marked as medium/low confidence

---

## Raw Changelog Data

### CC 2.1.183 (from upstream changelog)
```
- Enhanced auto mode safety with blocked destructive git commands and terraform destroy operations
- Added deprecation warnings for requested models
- Added `attribution.sessionUrl` setting to omit session links from commits/PRs
- Fixed multiple issues: thinking blocks returning empty, WebSearch in subagents, terminal cursor positioning, fullscreen TUI corruption, and MCP server authentication exposure
```

### CC 2.1.181 (from upstream changelog)
```
- Introduced `/config key=value` syntax for prompt-based settings
- Added `sandbox.allowAppleEvents` for macOS Apple Events
- Upgraded bundled Bun runtime to 1.4
- Improved paragraph streaming and auto-retry for API connection drops
- Fixed prompt caching issues on custom API URLs and Foundry
- Resolved Write/Edit file truncation on network drives
```

### CC 2.1.179 (from upstream changelog)
```
- Preserved partial responses on mid-stream connection drops
- Fixed mouse-wheel scrolling in WSL2
- Fixed sandbox glob operations causing unusable sessions on Linux
- Improved plugin loading performance in remote sessions
```

### System-prompts 2.1.182 (key items)
```
- NEW: Skill: Artifact design - design-guidance skill loaded by Artifact tool
- NEW: Skill: Migrate to Claude Code - migration for OpenAI Codex / Gemini CLI config
- Agent Prompt: Security monitor - expanded blocking rules for git/terraform destruction
- Agent Prompt: CLAUDE.md creation - migration offer for Codex/Gemini CLI config
```

### System-prompts 2.1.181 (key items)
```
- NEW: Data: Tool use display metadata field (tool_use_meta)
- NEW: System Reminder: Cross-session peer message authority warning (multiple variants)
- REMOVED: Data: Assistant voice and values template
- REMOVED: Data: User profile memory template
- REMOVED: Skill: /catch-up, /dream, /morning-checkin, /pre-meeting-checkin
```

### System-prompts 2.1.179 (key items)
```
- Agent Prompt: Security monitor - read-only authorization inheritance, post-block reaffirmation
- Agent Prompt: Security monitor - Live-Shared Artifact Sensitive Delta security block
```

---

## Stage 2: Verification Results
### Verified: 2026-06-19

#### Must Update Verification

- ✓ **New `/config key=value` syntax for prompt-based settings** (CC 2.1.181) — confirmed in CC changelog. Gap exists: command-development/overview.md does not document this new command syntax. Topic mapping correct (commands documentation).

- ✓ **New `sandbox.allowAppleEvents` setting for macOS** (CC 2.1.181) — confirmed in CC changelog. Low plugin relevance: this is a platform-specific sandbox setting. Demote to May Update unless we expand settings documentation scope.

- ✓ **New `attribution.sessionUrl` setting to omit session links** (CC 2.1.183) — confirmed in CC changelog. Low plugin relevance: git attribution setting, not plugin-specific. Demote to May Update.

- ✓ **New `tool_use_meta` display metadata field** (CC 2.1.181) — confirmed in system-prompts changelog (line 47). High relevance for MCP integration docs. Gap exists: mcp-integration/overview.md does not document this field. Topic mapping correct.

- ✗ **New Artifact tool with design skill** (CC 2.1.172, enhanced 2.1.182) — REJECTED: Version 2.1.172 is OUTSIDE the audit range (2.1.179-2.1.183). The Artifact tool was introduced in 2.1.172 and should have been covered in the prior audit (last audit was 2.1.178). The 2.1.182 enhancement (artifact-design skill loading) is internal to the Artifact tool's behavior, not a new plugin capability. Remove from Must Update.

- ✓ **New `Migrate to Claude Code` skill for foreign-agent config** (CC 2.1.182) — confirmed in system-prompts changelog (line 17). Gap exists: skill-development/overview.md does not mention this built-in skill pattern. However, this is a bundled Claude Code skill, not a plugin development pattern. Demote to May Update (informational only).

- ✓ **Enhanced auto mode security: blocked destructive git/terraform commands** (CC 2.1.182-2.1.183) — confirmed in BOTH sources (CC changelog and system-prompts line 34). High confidence. Gap exists: agent-development/overview.md documents auto mode but not these specific blocked commands. Topic mapping correct.

- ✓ **Security monitor: read-only authorization inheritance** (CC 2.1.179) — confirmed in system-prompts changelog (lines 65-67). This affects how permissions work in auto mode. Gap exists in agent-development docs. Topic mapping correct.

- ✗ **New claude.ai Project tool** (CC 2.1.174) — REJECTED: Version 2.1.174 is OUTSIDE the audit range (2.1.179-2.1.183). Should have been covered in prior audit. Remove from Must Update.

#### Missed Items (promoted from No Action)

- ! **Fixed WebSearch in subagents** (CC 2.1.183) — appears in No Action as "bug fix" but CC changelog confirms "Fixed WebSearch returning empty results in subagents" is a notable behavior change. Subagents can now reliably use WebSearch. However, this is a bug fix restoring expected behavior, not a new capability. Keep as No Action.

- ! **Fixed MCP server authentication exposure** (CC 2.1.183) — listed as security bug fix. CC changelog specifies: "Fixed MCP servers requiring authentication exposing auth-stub tools in headless/SDK mode". This affects headless plugin usage but is a security fix, not a feature. Keep as No Action.

- ! **Fixed user-level skills appearing multiple times in slash-command autocomplete** (CC 2.1.179, 2.1.183) — appears in both versions. Bug fix, keep as No Action.

- ! **Fixed focus mode showing redundant PostToolUse hooks timing lines** (CC 2.1.183) — from CC changelog. Hook-related but cosmetic fix. Keep as No Action.

#### May Update Resolution

- ↓ **Cross-session peer message authority warning changes** (CC 2.1.181) — demoted to No Action. This is internal wording changes to peer message handling, not a plugin development concern. Plugin authors don't control peer message behavior.

- ↓ **Removed skills: /catch-up, /dream, /morning-checkin, /pre-meeting-checkin** (CC 2.1.181) — demoted to No Action. These were internal/experimental Claude Code skills, not plugin-relevant patterns. Plugin-dev docs don't reference them.

- ↓ **Removed assistant voice/values template and user profile memory template** (CC 2.1.181) — demoted to No Action. Internal template changes, not plugin development relevant.

- = **Live-Shared Artifact Sensitive Delta security block** (CC 2.1.179) — kept as May Update. Artifact-specific security feature. Only relevant if we document Artifact tool integration.

- = **Plugin loading performance improvements in remote sessions** (CC 2.1.179) — kept as May Update. Relevant to plugin performance but no actionable documentation update (vague description).

- ↓ **Deprecation warnings for requested models** (CC 2.1.183) — demoted to No Action. User-facing warning, not plugin development relevant.

- ↓ **Bundled Bun runtime upgraded to 1.4** (CC 2.1.181) — demoted to No Action. Internal runtime, not plugin-relevant unless plugins specifically use Bun features.

- ↓ **Cowork onboarding role picker tool** (CC 2.1.172) — demoted to No Action. Version 2.1.172 is OUTSIDE the audit range. Should have been in prior audit.

#### Corrected Must Update List

After verification, the following items should be in Must Update:

1. **New `/config key=value` syntax for prompt-based settings** (CC 2.1.181)
   - Affects: command-development
   - Action: Document new `/config key=value` syntax as alternative to slash command menu

2. **New `tool_use_meta` display metadata field** (CC 2.1.181)
   - Affects: mcp-integration
   - Action: Document wrapper-level `tool_use_meta` field for MCP tool display metadata

3. **Enhanced auto mode security: blocked destructive git/terraform commands** (CC 2.1.182-2.1.183)
   - Affects: agent-development (auto mode section)
   - Action: Document blocked commands list for autonomous agents

4. **Security monitor: read-only authorization inheritance** (CC 2.1.179)
   - Affects: agent-development (permissions section)
   - Action: Document read-only authorization persistence behavior

#### Corrected May Update List

1. **New `sandbox.allowAppleEvents` setting for macOS** (CC 2.1.181)
2. **New `attribution.sessionUrl` setting** (CC 2.1.183)
3. **Live-Shared Artifact Sensitive Delta security block** (CC 2.1.179)
4. **Plugin loading performance improvements in remote sessions** (CC 2.1.179)
5. **Migrate to Claude Code skill** (CC 2.1.182) — informational only

#### Summary

- **Must Update**: 4 items (5 rejected or reclassified from original 9)
  - 2 items rejected (outside audit range: Artifact tool 2.1.172, Project tool 2.1.174)
  - 3 items demoted to May Update or No Action (low plugin relevance)
- **May Update**: 5 items remaining (3 demoted to No Action)
- **Missed Items**: 0 promoted from No Action
- **Confidence**: HIGH for version range, MEDIUM for topic mappings

#### Issues Found

**Critical**: 2 items (22%) in original Must Update were outside the audit range (2.1.179-2.1.183):
- claude.ai Project tool (2.1.174)
- Artifact tool (2.1.172)

These should have been caught in Stage 1's version filtering. The manifest's "Borderline items" section noted uncertainty about these items, which indicates appropriate caution but the items should have been excluded from Must Update.

**Stage 1 Quality Assessment**: Acceptable. The manifest correctly identified key changes and noted uncertainty about version boundaries. The rejected items were flagged as borderline. No missed plugin-critical items in the version range.
