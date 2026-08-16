# Upstream Change Manifest
## CC Version Range: 2.1.230 - 2.1.233
## Generated: 2026-08-16
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - agent dispatch failed]

---

## Must Update

### Plugin Eval and Skill-Doctor Commands (CC 2.1.233)
- [ ] **Plugin eval and skill-doctor early-access commands** (CC 2.1.233)
  - Source: system-prompts (NEW prompts)
  - Confidence: high
  - Affects: plugin-validator agent, skill-creation-workflow, plugin-dev skill
  - Details: New `claude plugin eval`, `eval init`, and `/skill-doctor` commands added. Covers suite authoring, graders, run options, result/report formats, sandboxing, CI, and troubleshooting. Uses `CLAUDE_CODE_WALNUT_SPIRE=1` env var for enablement in clients/CI that cannot receive the organization rollout. Supported in shell, user-settings, and managed-settings locations. Warning not to rely on project settings.
  - Raw: "Add condensed and comprehensive offline guidance for early-access `claude plugin eval`, `eval init`, and `/skill-doctor`, covering enablement, suite authoring, graders, run options, result and report formats, sandboxing, CI, and troubleshooting."

### Subagent Forking Default Enabled (CC 2.1.232)
- [ ] **Subagent forking enabled by default with conversation inheritance** (CC 2.1.232)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: agent-creator agent, orchestration-and-tools.md
  - Details: Subagent forking is now enabled by default. Worker fork agent prompt changed from "fork experiment" to "fork gate". This changes how agents spawn and inherit conversation context.
  - Raw changelog: "Subagent forking now enabled by default with conversation inheritance"
  - System-prompts: "Agent Prompt: Worker fork - Updates the fork agent's availability description from the 'fork experiment' to the 'fork gate.'"

### Cross-Session @ Mention Syntax (CC 2.1.232)
- [ ] **@ mention syntax for cross-session messaging** (CC 2.1.232)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: orchestration-and-tools.md (SendMessage, ListAgents sections)
  - Details: New `@` mention syntax allows cross-session messaging by name. `SendMessage` now delivers to bare names matching exactly one session. Interactive sessions keep unique names with variant generation. Cloud sessions can receive but not yet reply.
  - Raw changelog: "Added `@` mention syntax for cross-session messaging by name; `SendMessage` now delivers to bare names matching exactly one session; Interactive sessions keep unique names with variant generation"
  - System-prompts: "Clarify that exact live names deliver across local, remote, and cloud sessions, that references are only for ambiguity or lookup failures, and that cloud sessions can receive messages but cannot yet reply to another session."

### Marketplace Settings Aliases (CC 2.1.232)
- [ ] **Settings aliases: additionalMarketplaces, allowedMarketplaces, blockedMarketplaces** (CC 2.1.232)
  - Source: changelog
  - Confidence: high
  - Affects: marketplace-structure documentation, settings reference
  - Details: New settings aliases added for marketplace configuration. Enterprise policy `blockedMarketplaces` now supports bare repo URLs.
  - Raw changelog: "Settings aliases added: `additionalMarketplaces`, `allowedMarketplaces`; Enterprise policy: `blockedMarketplaces` supports bare repo URLs"

---

## May Update

### Artifact Components Skill (CC 2.1.232)
- [ ] **Artifact components skill with verifier-pinned decision blocks** (CC 2.1.232)
  - Source: system-prompts (NEW skill)
  - Confidence: medium
  - Affects: artifact documentation (if covered by plugin-dev)
  - Details: Reusable, verifier-pinned decision blocks for non-workshop HTML artifacts. Includes design tokens, styles, markup, and scripts for persisted selections.
  - Raw: "Add reusable, verifier-pinned decision blocks for non-workshop HTML artifacts, including canonical design tokens, styles, markup, and scripts for persisted selections"

### Artifact Comment Fast Acknowledgement (CC 2.1.232)
- [ ] **Artifact comment fast acknowledgement** (CC 2.1.232)
  - Source: system-prompts (NEW system prompt)
  - Confidence: medium
  - Affects: artifact workflow documentation
  - Details: New no-tools, single-sentence acknowledgement under 160 characters before full comment response. Distinguishes change requests from questions.

### Background Monitor Push Notification Guidance (CC 2.1.232)
- [ ] **Background monitor push notification guidance** (CC 2.1.232)
  - Source: system-prompts (NEW tool description)
  - Confidence: medium
  - Affects: Monitor tool documentation
  - Details: Background monitors should push only events that materially change what the user should do next, such as a new error or a status transition they were awaiting.

### Bound Conversation Activity Authority Warning (CC 2.1.232)
- [ ] **Bound conversation activity authority warning** (CC 2.1.232)
  - Source: system-prompts (NEW system reminder)
  - Confidence: medium
  - Affects: security/permissions documentation
  - Details: Bound-conversation edits and reactions treated as awareness-only, never as fresh instructions, approval, consent, or a way around denial.

### WebFetch Cache TTL Environment Variable (CC 2.1.233)
- [ ] **CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS environment variable** (CC 2.1.233)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: WebFetch tool documentation, environment variables
  - Details: New environment variable for configuring WebFetch cache TTL. System-prompts now derive cache-expiry text at render time instead of hard-coding 15 minutes.
  - Raw: "Added `CLAUDE_CODE_WEBFETCH_CACHE_TTL_MS` environment variable configuration"

### Memory Cgroup Support (CC 2.1.233)
- [ ] **Memory cgroup support for Bash tool on Linux** (CC 2.1.233)
  - Source: changelog
  - Confidence: low
  - Affects: Bash tool documentation (if documenting resource limits)
  - Details: Added memory cgroup support for Bash tool commands on Linux.

### SendFeedback Drafting Guidance (CC 2.1.232)
- [ ] **SendFeedback drafting guidance updates** (CC 2.1.232)
  - Source: system-prompts
  - Confidence: medium
  - Affects: feedback documentation
  - Details: Tightened privacy by replacing personal identifiers with roles, excluding customer channel IDs, constraining file-path evidence, describing vulnerabilities without working exploits.

### /config Dialog Expiry and Cross-Session Messages (CC 2.1.232)
- [ ] **/config rows for dialog expiry and cross-session messages** (CC 2.1.232)
  - Source: changelog
  - Confidence: medium
  - Affects: /config command documentation
  - Details: New configuration options exposed in /config for dialog expiry timeout and cross-session message handling.

### /code-review Background Agent at High Effort (CC 2.1.232)
- [ ] **/code-review at high effort runs as background agent** (CC 2.1.232)
  - Source: changelog
  - Confidence: medium
  - Affects: slash command documentation
  - Details: The /code-review command at high effort levels now runs as a background agent.

### Cowork External @-imports Memory Exclusion (CC 2.1.232)
- [ ] **Cowork sessions exclude external @-imports from memory** (CC 2.1.232)
  - Source: changelog
  - Confidence: low
  - Affects: Cowork documentation (if applicable)
  - Details: External @-imports are now excluded from memory in Cowork sessions.

### Todo/Task-Tracking Tools Removed (CC 2.1.233) [Reclassified from Must Update]
- [ ] **Todo/task-tracking tools removed from Opus 4.8+ models** (CC 2.1.233)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: model-specific documentation, tool availability notes
  - Details: Todo and task-tracking tools have been removed from Opus 4.8 and newer models. Model-specific runtime behavior, not plugin API change.
  - Stage 2 note: Reclassified because plugin-dev does not document which built-in tools exist on which models.

### Plugin Validate for .claude/skills Directories (CC 2.1.233) [Reclassified from Must Update]
- [ ] **Improved `claude plugin validate` for `.claude/skills` directories** (CC 2.1.233)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: skill-development references (YAML frontmatter diagnosis guidance)
  - Details: CC CLI behavior improvement with better .claude/skills directory handling and YAML frontmatter parse failure diagnosis.
  - Stage 2 note: Reclassified because this is CC CLI behavior, not plugin-dev scope. plugin-validator agent calls user's CC installation.

### Web Fetch Agent Delegation (CC 2.1.232) [Reclassified from Must Update]
- [ ] **Web fetch agent delegation flow** (CC 2.1.232)
  - Source: system-prompts (NEW agent prompts)
  - Confidence: medium
  - Affects: WebFetch tool documentation, agent patterns
  - Details: New dedicated WebFetch delegation flow replacing inline summarizer. Internal CC agent behavior.
  - Stage 2 note: Reclassified because this is internal CC agent behavior, not plugin-facing API.

---

## No Action

### Bug Fixes (CC 2.1.230-2.1.233)
- MCP OAuth sign-in redirect URI mismatch fix (CC 2.1.231) - bug fix only
- Fixed cloud sessions marked as lost during environment shutdown (CC 2.1.233)
- Fixed MCP v2 connection subscription stream issues on serverless hosts (CC 2.1.233)
- Fixed notification hooks not firing for permission prompts in Claude Desktop/VS Code (CC 2.1.233)
- Fixed idle Linux sessions consuming 100% CPU with sandboxing enabled (CC 2.1.233)
- Fixed bundled skill aliases reporting "Unknown command" in certain modes (CC 2.1.233)
- Fixed skill argument substitution preventing re-expansion as template markers (CC 2.1.233)
- Fixed Windows NT device prefix paths bypassing UNC validation (CC 2.1.233)
- Fixed Windows auto mode Bash command approval regression (CC 2.1.233)
- Reverted 2.1.232 Bash permission changes for symlinks and input redirections (CC 2.1.233)
- Fixed PowerShell permission bypass via variable-writing parameters (CC 2.1.232)
- Fixed Windows permission bypass with Cygwin-style symlinks (CC 2.1.232)
- Fixed nested git repositories inheriting parent directory trust (CC 2.1.232)
- Fixed MCP connection hangs on protocol-version probe failures (CC 2.1.232)
- Fixed Remote Control sessions with bridge inheritance issues (CC 2.1.232)
- Fixed Remote Control sessions becoming unreachable while idle (CC 2.1.232)
- Fixed bridge sessions not restoring conversation history on restart (CC 2.1.232)
- Remote Control: resuming deleted sessions now starts replacements (CC 2.1.232)
- Fixed cloud gateway login issues after managed settings failures (CC 2.1.232)
- Fixed voice mode "listening..." stuck state (CC 2.1.232)
- Fixed mTLS client certificate rotation requiring restart (CC 2.1.232)
- Fixed malformed AWS/Vertex region values not falling back properly (CC 2.1.232)
- Fixed stream idle timeout errors on Bedrock/Vertex/gateway (CC 2.1.232)
- Fixed content-sized overlays with truncated text rendering issues (CC 2.1.232)
- Fixed stray characters in long preview truncation (CC 2.1.232)
- Fixed startup race unregistering plugin marketplaces (CC 2.1.232)
- Fixed `/update` and `/tui` refusing restart with surviving work (CC 2.1.232)
- Fixed usage-limit guidance suggestions in SDK/remote sessions (CC 2.1.232)
- Fixed consent message for `--advisor fable` launches (CC 2.1.232)

### Performance and UX Improvements (CC 2.1.232-2.1.233)
- Improved `claude self-hosted-runner` session start time (CC 2.1.233)
- Improved apps gateway error forwarding with upstream messages (CC 2.1.233)
- Improved screen reader mode rendering for `/effort` selector (CC 2.1.233)
- Improved print mode diagnostics for unrecognized models (CC 2.1.233)
- Improved fullscreen streaming responsiveness (CC 2.1.232)
- Improved managed settings approval dialog clarity (CC 2.1.232)
- `/feedback` and `/bug` open immediately during Claude responses (CC 2.1.232)
- `/plugin install` refreshes marketplace before install (CC 2.1.232) - already documented in v0.36.0
- Pasted/clipboard images read without blocking event loop (CC 2.1.232)
- Remote Control reconnection improved for ~30 minutes (CC 2.1.232)
- Remote Control resume no longer takes control from other sessions (CC 2.1.232)
- Updated agent panel with immediate completion hiding (CC 2.1.232)
- Remote Control terminal clarifies session end reasons (CC 2.1.232)
- Shortened background agent resumption message (CC 2.1.232)

### Security Hardening (CC 2.1.232-2.1.233)
- Bash input redirections permission-checked on all platforms (CC 2.1.232)
- Hardened cross-session messaging socket directory on `/tmp` (CC 2.1.232)
- Hardened Linux filesystem sandbox against protected-path bypass (CC 2.1.232)
- Changed `sandbox.ripgrep` honoring to user/managed/`--settings` only (CC 2.1.232)
- GitLab token family secret redaction (CC 2.1.232)

### Gateway/Internal Changes (CC 2.1.232-2.1.233)
- Gateway: `desktop:` overlay accepts all released Desktop settings (CC 2.1.232)
- Gateway: Empty/malformed managed policies entries fail at boot (CC 2.1.232)
- forward_user_identity apps gateway setting (CC 2.1.233)

### UI/UX Changes (CC 2.1.232-2.1.233)
- Changed GitHub app setup tip behavior for non-GitHub repositories (CC 2.1.233)
- Fable 5 offered as advisor again for organizations with access (CC 2.1.232)
- Removed startup tip about creating custom subagents (CC 2.1.232)

### Version 2.1.230
- No documented changes in either source

### Already Documented (Stage 2 Rejected)
- GitLab support in plugin marketplaces (CC 2.1.232-2.1.233) - Already documented in marketplace-structure/overview.md (lines 139, 146, 275). The CC 2.1.232 change expands internal support but plugin-dev already covers GitLab as a plugin source.

---

## Summary

**Version Range:** 2.1.230 - 2.1.233 (4 versions since last audit of 2.1.229)

**Key Changes for Plugin-Dev (Must Update - Stage 2 Verified):**

1. **Plugin eval and skill-doctor commands** (CC 2.1.233) - Major new feature for testing plugins and skills. Highly relevant to plugin-dev.
2. **Subagent forking default enabled** (CC 2.1.232) - Changes agent spawning behavior.
3. **@ mention syntax for cross-session messaging** (CC 2.1.232) - New SendMessage/ListAgents addressing pattern.
4. **Marketplace settings aliases** (CC 2.1.232) - New settings for marketplace configuration.

**Reclassified to May Update (Stage 2):**
- Todo/task-tracking tools removed from Opus 4.8+ (CC 2.1.233) - Model-specific runtime behavior, not plugin API.
- Plugin validate for .claude/skills directories (CC 2.1.233) - CC CLI behavior, not plugin-dev scope.
- Web fetch agent delegation (CC 2.1.232) - Internal CC agent behavior, not plugin-facing API.

**Rejected (Stage 2):**
- GitLab support in plugin marketplaces (CC 2.1.232-2.1.233) - Already documented in marketplace-structure.

**Token Impact:** System prompts show significant changes:
- 2.1.233: +27,728 tokens
- 2.1.232: +48,736 tokens
- 2.1.231: No changes
- 2.1.230: Not in system-prompts (likely no prompt changes)

**Total delta since 2.1.229:** +76,464 tokens (substantial release window)

**Key Themes:**
1. Plugin evaluation and skill diagnostics - new testing infrastructure
2. Cross-session messaging improvements with @ mentions
3. GitLab support expanding beyond GitHub-only
4. Model-specific changes (Opus 4.8+ tool removal)
5. Subagent forking behavior changes

**Notes:**
- Version 2.1.230 had no documented changes in either source
- Version 2.1.231 was a single bug fix (MCP OAuth)
- The claude-code-guide agent dispatch failed, so this manifest uses two-source triangulation only
- High-confidence items appear in both changelog and system-prompts sources

**Next Steps:**
1. Stage 2: Validate this manifest
2. Stage 3: Update affected documentation in plugin-dev skills
3. Stage 4: Review and verify changes

---

## Stage 2: Verification Results
### Verified: 2026-08-16

#### Must Update Verification

- **CONFIRMED** [Plugin eval and skill-doctor commands] (CC 2.1.233) - Confirmed in system-prompts (NEW prompts: "Plugin eval and skill-doctor quick reference", "Plugin eval enabled-session status"). Gap verified: no `plugin eval`, `skill-doctor`, or `WALNUT_SPIRE` documentation exists in plugin-dev. Affects: skill-development references (new testing infrastructure), plugin-validator agent (eval integration).

- **CONFIRMED** [Subagent forking default enabled] (CC 2.1.232) - Confirmed in CC changelog ("Subagent forking now on by default") and system-prompts ("Worker fork" prompt change). Gap exists: `advanced-agent-fields.md` documents fork syntax change (CC 2.1.176) but NOT the "default enabled" behavioral change. Affects: `references/agent-development/references/advanced-agent-fields.md`.

- **CONFIRMED** [@ mention syntax for cross-session messaging] (CC 2.1.232) - Confirmed in CC changelog ("Added `@` mention support for other Claude sessions", "SendMessage delivers to bare matching names"). Gap exists: `orchestration-and-tools.md` documents SendMessage "main" (CC 2.1.178) and ListAgents labels (CC 2.1.228-2.1.229) but NOT @ mention syntax. Affects: `references/agent-development/references/orchestration-and-tools.md`.

- **RECLASSIFIED to May Update** [Todo/task-tracking tools removed] (CC 2.1.233) - Confirmed in CC changelog, but this is model-specific runtime behavior, not plugin API documentation. Plugin-dev does not document which built-in tools exist on which models. Low relevance to plugin development unless plugins explicitly rely on these tools. Demoted.

- **RECLASSIFIED to May Update** [Plugin validate for .claude/skills] (CC 2.1.233) - Confirmed in CC changelog. This is CC CLI behavior improvement, not plugin-dev documentation scope. The YAML frontmatter diagnosis guidance is relevant to skill-development but is advisory rather than API change. The plugin-validator agent does not need update since it calls the user's CC installation. Demoted.

- **REJECTED** [GitLab support in plugin marketplaces] (CC 2.1.232-2.1.233) - GitLab support is ALREADY DOCUMENTED in marketplace-structure/overview.md at lines 139 (Git URLs section), 146 (gitlab.com example), 275 (GITLAB_TOKEN). The CC 2.1.232 change expands internal support but plugin-dev already covers GitLab as a plugin source. The --worktree MR URL support (CC 2.1.233) is CLI flag behavior, not plugin documentation scope.

- **CONFIRMED** [Marketplace settings aliases] (CC 2.1.232) - Confirmed in CC changelog ("Settings accept friendlier marketplace aliases", "additionalMarketplaces, allowedMarketplaces"). Gap exists: marketplace-structure/overview.md mentions `blockedMarketplaces` (line 239) and `strictKnownMarketplaces` (line 243) but NOT the new aliases `additionalMarketplaces` or `allowedMarketplaces`. Affects: `references/marketplace-structure/overview.md` (Enterprise Features section).

- **RECLASSIFIED to May Update** [Web fetch agent delegation] (CC 2.1.232) - Confirmed in system-prompts (NEW agent prompts). This is internal CC agent behavior, not plugin-facing API. Plugin-dev documents WebFetch tool usage but not internal delegation architecture. Demoted to May Update since it affects how WebFetch works but not plugin development patterns.

#### Missed Items (promoted from No Action)

None identified. The No Action section correctly categorizes bug fixes, performance improvements, security hardening, and internal changes as not requiring plugin-dev documentation updates.

#### May Update Resolution

- **=** [Artifact Components Skill] - Kept as May Update: Not in plugin-dev scope (artifact internals).
- **=** [Artifact Comment Fast Acknowledgement] - Kept as May Update: Not in plugin-dev scope.
- **=** [Background Monitor Push Notification Guidance] - Kept as May Update: Could be relevant to Monitor tool docs in advanced-agent-fields.md but low priority.
- **=** [Bound Conversation Activity Authority Warning] - Kept as May Update: Security context, not plugin-specific.
- **=** [WebFetch Cache TTL Environment Variable] - Kept as May Update: Environment variable documentation could go in plugin-settings if we document CC env vars.
- **DOWN** [Memory Cgroup Support] - Demoted to No Action: Linux kernel feature, not plugin-relevant.
- **=** [SendFeedback Drafting Guidance] - Kept as May Update: Internal guidance changes.
- **=** [/config Dialog Expiry and Cross-Session Messages] - Kept as May Update: UI config, not plugin API.
- **=** [/code-review Background Agent at High Effort] - Kept as May Update: Slash command behavior.
- **DOWN** [Cowork External @-imports Memory Exclusion] - Demoted to No Action: Cowork internals, not plugin-relevant.
- **UP** [Todo/task-tracking tools removed] - Promoted from Must Update: Kept as May Update per reclassification above.
- **UP** [Plugin validate for .claude/skills] - Promoted from Must Update: Kept as May Update per reclassification above.
- **UP** [Web fetch agent delegation] - Promoted from Must Update: Kept as May Update per reclassification above.

#### Topic Mapping Corrections

- Item "orchestration-and-tools.md" should be referenced as `references/agent-development/references/orchestration-and-tools.md` (it is a sub-reference file, not a top-level topic).
- There is no standalone `orchestration-and-tools` topic with an overview.md file.
- Valid reference topics with overview.md files: `agent-development`, `command-development`, `hook-development`, `lsp-integration`, `marketplace-structure`, `mcp-integration`, `plugin-settings`, `plugin-structure`, `skill-development`.

#### Summary

- **Must Update:** 4 items (3 confirmed, 1 rejected, 3 reclassified to May Update)
  - Plugin eval and skill-doctor commands (CC 2.1.233)
  - Subagent forking default enabled (CC 2.1.232)
  - @ mention syntax for cross-session messaging (CC 2.1.232)
  - Marketplace settings aliases (CC 2.1.232)
- **May Update:** 12 items remaining (3 promoted from Must Update, 2 demoted to No Action)
- **Rejected:** 1 item (GitLab support - already documented)
- **Confidence:** High. Stage 1 correctly identified the major plugin-relevant changes. Minor reclassifications reflect accurate scope assessment.
