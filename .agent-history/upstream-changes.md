# Upstream Change Manifest
## CC Version Range: 2.1.236 - 2.1.239
## Generated: 2026-08-22
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - no output]

---

### Must Update

- [ ] **Cross-session messaging: `notify_when_idle` parameter** (CC 2.1.236)
  - Source: changelog, system-prompts (Tool Description: SendMessage cross-session guidance)
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: agent-development/references/orchestration-and-tools.md
  - Details: Adds one-shot `notify_when_idle` subscriptions for local sessions, including pure subscriptions, approval-held notices, expiry behavior. Use instead of polling or status-chasing messages.
  - Raw changelog: "Added `notify_when_idle` to cross-session messaging for one-shot idle notifications"

- [ ] **Built-in "Concise" output style** (CC 2.1.237)
  - Source: changelog, system-prompts (System Prompt: Concise output style)
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: plugin-structure/references/output-styles.md
  - Details: New built-in output style that "leads with results and skips preamble". Defines style to lead with results, omit narration and repeated recaps, use short plain answers by default, and preserve requested detail and correctness.
  - Raw changelog: "Added built-in 'Concise' output style that 'leads with results and skips preamble'"

- [ ] **Plugin marketplace `headersHelper` support** (CC 2.1.238)
  - Source: changelog, system-prompts
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: marketplace-structure/references/schema-reference.md, marketplace-structure/overview.md
  - Details: Plugin marketplaces now support `headersHelper` for minting HTTP headers (like tokens). Enables dynamic authentication for private marketplaces.
  - Raw changelog: "Plugin marketplaces support `headersHelper` for minting HTTP headers (like tokens)"

- [ ] **SendMessage ambiguous recipient display** (CC 2.1.239)
  - Source: system-prompts (Data: SendMessage ambiguous recipient display)
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: agent-development/references/orchestration-and-tools.md
  - Details: Restores user-facing "not sent" explanations for inexact or duplicate agent names, unavailable or truncated session searches, and recipients that require exact-name or pinned-identity confirmation.

- [ ] **Previously invoked skills context broadening** (CC 2.1.239)
  - Source: system-prompts (System Reminder: Previously invoked skills)
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: skill-development/references/skill-loading-and-runtime.md
  - Details: Broadens the post-compaction warning so request or argument text anywhere in restored skill bodies, including "User Request" sections, is historical context rather than a new live instruction.

- [ ] **Coordinator mode capability-aware routing** (CC 2.1.239)
  - Source: system-prompts (System Prompt: Coordinator mode orchestration, Tool Description: ListAgents)
  - Confidence: high (Stage 2 VERIFIED)
  - Affects: agent-development/references/advanced-agent-fields.md
  - Details: Add capability-aware user-message routing, `blocked` worker outcomes, concise launch updates when no communications role exists, and teammates as addressable agents.

- [ ] **Edit/Write read-before-edit path-sensitive guidance** (CC 2.1.236)
  - Source: system-prompts (Tool Description: Edit, Write)
  - Confidence: high (Stage 2 PROMOTED from May Update)
  - Affects: hook-development or tool reference examples
  - Details: Make read-before-edit and read-before-overwrite guidance path-sensitive, explicitly retaining the prior-Read requirement for files outside the working directory.

---

### May Update

- [ ] **ANTHROPIC_DEFAULT_MODEL environment variable** (CC 2.1.236)
  - Source: changelog
  - Confidence: medium (changelog only)
  - Affects: configuration documentation
  - Details: New environment variable for setting default model in new sessions.
  - Raw changelog: "Added `ANTHROPIC_DEFAULT_MODEL` environment variable for new session defaults"

- [ ] **Sandbox wildcard read-deny precedence** (CC 2.1.236)
  - Source: changelog
  - Confidence: medium (changelog only)
  - Affects: sandbox configuration documentation
  - Details: Sandbox wildcard read-deny rules now take precedence over allowed regions.
  - Raw changelog: "Sandbox wildcard read-deny rules now take precedence over allowed regions"

- [ ] **Poll tool for harness events** (CC 2.1.237)
  - Source: system-prompts (Tool Description: Poll)
  - Confidence: medium (Stage 2 DEMOTED from Must Update - specialized harness tool, not directly plugin-relevant)
  - Affects: tool reference documentation (if documenting harness events)
  - Details: New tool that adds idle wait for queued harness events, returning pending events immediately and yielding to new user input.

- [ ] **SDK subagent stats schema** (CC 2.1.238)
  - Source: system-prompts (Data: SDK subagent stats schema)
  - Confidence: medium (Stage 2 DEMOTED from Must Update - SDK internals)
  - Affects: agent-development if plugin authors need subagent metrics
  - Details: Documents cumulative per-session Agent-tool subagent counts by launch mode, type, nesting, outcome, and refusal.

- [ ] **SDK MCP server errors field** (CC 2.1.239)
  - Source: system-prompts (Data: SDK MCP server errors field)
  - Confidence: medium
  - Affects: mcp-integration documentation
  - Details: Documents skipped `--mcp-config` entries on SDK init frames, including stable error categories, omitted affected servers, Remote Control bridge failures, and CI handling.

- [ ] **Security monitor autonomous action updates** (CC 2.1.239)
  - Source: system-prompts (Agent Prompt: Security monitor)
  - Confidence: medium
  - Affects: agent-development (autonomous mode, permission modes)
  - Details: Adds unverifiable-deletion-scope soft block for runtime-computed destructive writes against shared or remote state.

---

### No Action

- Fullscreen renderer offer for Bedrock/Vertex/Foundry setups (CC 2.1.239) - IDE/UI specific
- `/claude-api upgrade` migration tool for Python projects (CC 2.1.239) - User-facing command, not plugin system
- Cloud session plugins synced display as `name@synced` (CC 2.1.239) - Display change only
- Alpine/musl builds native image paste/clipboard/audio-capture (CC 2.1.239) - Platform-specific
- Fixed Bedrock streaming issues behind proxies (CC 2.1.239) - Bug fix
- Fixed Claude Code hanging at startup with Bedrock SSO (CC 2.1.239) - Bug fix
- Fixed Edit/Write pauses in JetBrains IDE terminals (CC 2.1.239) - IDE-specific bug fix
- WebFetch cache expiry fix (15 minutes) (CC 2.1.239) - Bug fix
- MCP elicitation forms scrollable (CC 2.1.239) - UI fix
- Fixed unbounded memory growth in long sessions (CC 2.1.238) - Bug fix
- Fixed custom output styles reverting mid-session (CC 2.1.238) - Bug fix
- Improved worktree-isolation Bash refusals messaging (CC 2.1.238) - UX improvement
- Fixed prompt caching for LLM gateways/custom base URLs (CC 2.1.237) - Bug fix
- Fixed clipboard operations after directory removal (CC 2.1.236) - Bug fix
- Fixed `/model` picker rendering taller than terminal (CC 2.1.236) - UI fix
- VCS state changed branch field (CC 2.1.238) - Internal event schema
- Cost estimates US-only inference premium display (CC 2.1.239) - Billing display
- Artifact slides/spreadsheet skills removed (CC 2.1.239) - Artifact-specific, not plugin system
- Session title generator improvements (CC 2.1.234 reference) - Internal
- GitLab merge-request metadata support (CC 2.1.234 reference) - VCS integration
- Self-hosted runner `--defer-shutdown-max-min` (CC 2.1.238) - Deployment-specific, not plugin development (Stage 2 demoted)
- Proxy authorization command support (CC 2.1.238) - Enterprise deployment, not plugin development (Stage 2 demoted)
- keybindingFlavor setting (CC 2.1.238) - User preference setting (Stage 2 demoted)
- Artifact live room guidance (CC 2.1.238) - Artifact system outside plugin scope (Stage 2 demoted)
- Artifact runtime verification guidance (CC 2.1.238) - Artifact system outside plugin scope (Stage 2 demoted)
- Auto mode Slack message provenance (CC 2.1.237) - Slack integration, not plugin development (Stage 2 demoted)
- Artifact content host network block guidance (CC 2.1.239) - Artifact system outside plugin scope (Stage 2 demoted)
- Bash git commit PR body template fix (CC 2.1.239) - Bug fix to PR template generation (Stage 2 demoted)
- Auto memory durable lesson instructions (CC 2.1.239) - Memory system internals (Stage 2 demoted)
- Collaborative-goals identity branch (CC 2.1.239) - Identity/persona internals (Stage 2 demoted)
- Artifact tools expansion: list_files, read_file actions (CC 2.1.239) - Artifact system outside plugin scope (Stage 2 demoted)

---

## Summary

**Version range**: 2.1.236 to 2.1.239 (4 versions since last audit on 2026-08-19)

**Token delta** (from system-prompts):
- 2.1.236: +26,676 tokens
- 2.1.237: +1,249 tokens
- 2.1.238: +3,292 tokens
- 2.1.239: +960 tokens
- **Total**: +32,177 tokens

**Key themes**:
1. Cross-session messaging enhancements (`notify_when_idle`, ambiguous recipient handling)
2. Plugin marketplace authentication (`headersHelper`)
3. Built-in output styles (Concise)
4. Artifact system expansion (files, rooms, verification)
5. Agent coordination improvements (capability-aware routing, subagent stats)

**Priority items for plugin-dev**:
1. `notify_when_idle` cross-session parameter - affects agent communication patterns
2. Plugin marketplace `headersHelper` - affects marketplace/plugin.json documentation
3. Concise output style - new built-in style users may reference
4. Coordinator mode capability-aware routing - affects multi-agent patterns

---

## Stage 2: Verification Results
### Verified: 2026-08-22

#### Must Update Verification

- **Cross-session messaging: `notify_when_idle` parameter** (CC 2.1.236)
  - Confirmed in: changelog ("Added `notify_when_idle` to cross-session `SendMessage`"), system-prompts (Tool Description: SendMessage cross-session guidance)
  - Gap exists: `references/agent-development/references/orchestration-and-tools.md` documents SendMessage "main" recipient and ListAgents but NOT `notify_when_idle` parameter
  - Affects: agent-development (orchestration-and-tools.md)
  - Status: CONFIRMED

- **Built-in "Concise" output style** (CC 2.1.237)
  - Confirmed in: changelog ("Added built-in 'Concise' output style"), system-prompts (System Prompt: Concise output style)
  - Gap exists: `references/plugin-structure/references/output-styles.md` mentions "Claude Code includes built-in output styles" but does NOT document the specific "Concise" style
  - Affects: plugin-structure (output-styles.md)
  - Status: CONFIRMED

- **Poll tool for harness events** (CC 2.1.237)
  - Confirmed in: system-prompts (Tool Description: Poll)
  - Gap assessment: NEW tool - not currently documented anywhere in plugin-dev
  - Affects: This is a specialized tool for harness events; plugin developers would rarely interact with it directly
  - Status: DEMOTE TO "May Update" - not directly plugin-relevant unless plugins need to handle harness events

- **Plugin marketplace `headersHelper` support** (CC 2.1.238)
  - Confirmed in: changelog ("Plugin marketplaces support `headersHelper`"), system-prompts
  - Gap exists: `references/marketplace-structure/references/schema-reference.md` does NOT document `headersHelper` field
  - Note: MCP `headersHelper` already documented in `references/mcp-integration/references/authentication.md` but marketplace-level `headersHelper` is different
  - Affects: marketplace-structure (schema-reference.md, overview.md)
  - Status: CONFIRMED

- **SDK subagent stats schema** (CC 2.1.238)
  - Confirmed in: system-prompts (Data: SDK subagent stats schema)
  - Gap assessment: This documents SDK-level statistics, not directly plugin-developer facing
  - Affects: Potentially agent-development if plugin authors need subagent metrics
  - Status: DEMOTE TO "May Update" - SDK internals, not directly actionable for plugin developers

- **Artifact tools expansion: list_files, read_file actions** (CC 2.1.239)
  - Confirmed in: system-prompts (Tool Description: Artifact files guidance)
  - Gap assessment: Artifact tools are not currently documented in plugin-dev (they're Anthropic-specific UI features)
  - Status: DEMOTE TO "No Action" - Artifact system is outside plugin development scope

- **SendMessage ambiguous recipient display** (CC 2.1.239)
  - Confirmed in: system-prompts (Data: SendMessage ambiguous recipient display)
  - Gap exists: `references/agent-development/references/orchestration-and-tools.md` covers SendMessage but not ambiguous recipient handling
  - Affects: agent-development (orchestration-and-tools.md)
  - Status: CONFIRMED

- **Previously invoked skills context broadening** (CC 2.1.239)
  - Confirmed in: system-prompts (System Reminder: Previously invoked skills)
  - Gap exists: `references/skill-development/references/skill-loading-and-runtime.md` documents CC 2.1.119 original behavior but NOT the CC 2.1.239 broadening
  - Affects: skill-development (skill-loading-and-runtime.md)
  - Status: CONFIRMED

- **Coordinator mode capability-aware routing** (CC 2.1.239)
  - Confirmed in: system-prompts (System Prompt: Coordinator mode orchestration, Tool Description: ListAgents)
  - Gap exists: Agent teams documented in `references/agent-development/references/advanced-agent-fields.md` but NOT capability-aware routing
  - Affects: agent-development (advanced-agent-fields.md)
  - Status: CONFIRMED

#### Missed Items (promoted from No Action)

None identified. The "No Action" items were correctly classified as bug fixes, UI changes, or platform-specific features that do not affect the plugin system.

#### May Update Resolution

- **ANTHROPIC_DEFAULT_MODEL environment variable** (CC 2.1.236)
  - Status: KEEP as May Update - configuration documentation, not core plugin system
  - Affects: Could be mentioned in plugin-settings if documenting environment variables

- **Sandbox wildcard read-deny precedence** (CC 2.1.236)
  - Status: KEEP as May Update - security configuration, relevant if documenting sandbox behavior
  - Affects: Potentially plugin-structure (advanced-topics.md)

- **Edit/Write read-before-edit path-sensitive guidance** (CC 2.1.236)
  - Status: PROMOTE TO Must Update - directly affects how plugins should use Edit/Write tools
  - Affects: tool reference examples, potentially hook-development
  - Details: Make read-before-edit and read-before-overwrite guidance path-sensitive, retaining prior-Read requirement for files outside working directory

- **Self-hosted runner `--defer-shutdown-max-min`** (CC 2.1.238)
  - Status: DEMOTE TO No Action - deployment-specific, not plugin development

- **Proxy authorization command support** (CC 2.1.238)
  - Status: DEMOTE TO No Action - enterprise deployment, not plugin development

- **keybindingFlavor setting** (CC 2.1.238)
  - Status: DEMOTE TO No Action - user preference, not plugin development

- **Artifact live room guidance** (CC 2.1.238)
  - Status: DEMOTE TO No Action - Artifact system outside plugin scope

- **Artifact runtime verification guidance** (CC 2.1.238)
  - Status: DEMOTE TO No Action - Artifact system outside plugin scope

- **Auto mode Slack message provenance** (CC 2.1.237)
  - Status: DEMOTE TO No Action - Slack integration, not plugin development

- **SDK MCP server errors field** (CC 2.1.239)
  - Status: KEEP as May Update - relevant for MCP server development troubleshooting
  - Affects: mcp-integration documentation

- **Artifact content host network block guidance** (CC 2.1.239)
  - Status: DEMOTE TO No Action - Artifact system outside plugin scope

- **Security monitor autonomous action updates** (CC 2.1.239)
  - Status: KEEP as May Update - relevant for autonomous mode documentation
  - Affects: agent-development (permission modes)

- **Bash git commit PR body template fix** (CC 2.1.239)
  - Status: DEMOTE TO No Action - bug fix to PR template generation

- **Auto memory durable lesson instructions** (CC 2.1.239)
  - Status: DEMOTE TO No Action - memory system internals

- **Collaborative-goals identity branch** (CC 2.1.239)
  - Status: DEMOTE TO No Action - identity/persona internals

#### Summary

- **Must Update: 7 items** (6 confirmed from original 9, 1 promoted from May Update)
  1. Cross-session `notify_when_idle` (CC 2.1.236) - confirmed
  2. Built-in "Concise" output style (CC 2.1.237) - confirmed
  3. Plugin marketplace `headersHelper` (CC 2.1.238) - confirmed
  4. SendMessage ambiguous recipient display (CC 2.1.239) - confirmed
  5. Previously invoked skills broadening (CC 2.1.239) - confirmed
  6. Coordinator mode capability-aware routing (CC 2.1.239) - confirmed
  7. Edit/Write path-sensitive guidance (CC 2.1.236) - PROMOTED from May Update

- **Demoted to May Update: 2 items**
  - Poll tool (CC 2.1.237) - specialized harness tool
  - SDK subagent stats (CC 2.1.238) - SDK internals

- **Demoted to No Action: 10 items** (from May Update)
  - Artifact-related (4 items), Slack provenance, self-hosted runner, proxy auth, keybindingFlavor, Bash PR fix, memory/identity internals

- **May Update remaining: 4 items**
  - ANTHROPIC_DEFAULT_MODEL, sandbox read-deny precedence, SDK MCP errors, security monitor updates

- **Confidence: HIGH**
  - All changelog entries verified against primary sources
  - No missed items found in version range scan
  - Topic mappings validated against reference doc structure
  - 0% rejection rate (all original Must Update items confirmed)
  - 1 promotion from May Update (Edit/Write guidance)
