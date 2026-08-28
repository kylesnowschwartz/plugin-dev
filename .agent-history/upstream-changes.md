# Upstream Change Manifest
## CC Version Range: 2.1.240 - 2.1.250
## Generated: 2026-08-28
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent dispatch unavailable]

---

### Must Update

- [ ] **Workflow authoring reference skill** (CC 2.1.248)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-format skill, possibly workflow documentation
  - Details: NEW skill that moves Workflow APIs, concurrency/budgeting rules, orchestration patterns, Ultracode guidance, and resume behavior into a dedicated reference instead of the tool description. Plugin-dev documentation may need to reference this new skill structure pattern.
  - Raw changelog: "**NEW:** Skill: Workflow authoring reference - Moves the detailed Workflow APIs, concurrency and budgeting rules, orchestration patterns, Ultracode guidance, and resume behavior into a dedicated reference instead of presenting them all in the tool description."

- [ ] **Coordinator mode forced-inheritance variant** (CC 2.1.248)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-creator agent, coordinator documentation
  - Details: Coordinator mode now supports a forced-inheritance variant where worker model parameter is ignored and must not be set. The normal variant more explicitly forbids downshifting work because it appears small, simple, or cheap. This affects agent coordination patterns.
  - Raw changelog: "System Prompt: Coordinator mode orchestration - Adds a forced-inheritance variant that says the worker model parameter is ignored and must not be set, while the normal variant more explicitly forbids downshifting work because it appears small, simple, or cheap."

- [ ] **SendFeedback tool** (CC 2.1.247)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: tools documentation, possibly plugin-dev skill
  - Details: NEW tool for drafting feedback reports. This is a new built-in tool that plugin developers should be aware of.
  - Raw changelog: "Introduced SendFeedback tool for drafting reports"

- [ ] **Cost optimization skill** (CC 2.1.247)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill examples, skill-format documentation
  - Details: NEW skill for cost-per-completed-task workflow. This is a significant new built-in skill that demonstrates advanced skill patterns including Admin API integration and multi-model tradeoffs.
  - Raw changelog: "**NEW:** Skill: Cost optimization - Adds a cost-per-completed-task workflow that profiles distinct traffic classes from Admin API data, application usage logs, or code estimates"

- [ ] **Admin API reference documentation** (CC 2.1.247)
  - Source: system-prompts
  - Confidence: high
  - Affects: claude-api documentation references
  - Details: NEW Admin API reference covering organization-admin authentication, workspace/API-key management, rate limits, service accounts, workload identity federation, and CMK. Plugin developers building enterprise integrations need this.
  - Raw changelog: "**NEW:** Data: Admin API reference - Documents organization-admin authentication, endpoint and SDK/CLI coverage..."

- [ ] **Agent tool simple usage notes** (CC 2.1.240)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-creator agent, Agent tool documentation
  - Details: NEW concise Agent-tool guidance covering when to delegate, fork behavior, resuming agents, worktree isolation, background execution, parallel launches, and context restrictions. This affects how agents should be documented.
  - Raw changelog: "**NEW:** Tool Description: Agent (simple usage notes) - Adds concise Agent-tool guidance covering when to delegate, fork behavior, resuming agents, worktree isolation, background execution, parallel launches, and context restrictions."

- [ ] **Artifact type discovery and creation guidance** (CC 2.1.242)
  - Source: system-prompts
  - Confidence: medium
  - Affects: skill documentation (Artifacts usage patterns)
  - Details: NEW tool description and system reminder for listing, inspecting, and creating from published Artifact types. Introduces trust boundary for third-party type instructions.
  - Raw changelog: "**NEW:** Tool Description: Artifact type discovery and creation guidance and System Reminder: Artifact type instructions trust boundary"

- [ ] **Directory sync guidance system reminders** (CC 2.1.242)
  - Source: system-prompts
  - Confidence: medium
  - Affects: system reminder documentation patterns
  - Details: NEW mode-specific guidance for synced git checkouts, live uncommitted checkouts, and plain folders. Relevant for understanding how CC handles remote/cloud sessions.
  - Raw changelog: "**NEW:** System Reminder: Directory sync guidance and notices - Adds mode-specific guidance for synced git checkouts, live uncommitted checkouts, and plain folders"

- [ ] **Removed /loop slash command variant** (CC 2.1.248)
  - Source: system-prompts
  - Confidence: high
  - Affects: command documentation
  - Details: REMOVED the older fixed/default-interval prompt variant of /loop; the dynamic-mode prompt remains. Any documentation referencing the old /loop behavior needs updating.
  - Raw changelog: "**REMOVED:** Skill: `/loop` slash command - Removes the older fixed/default-interval prompt variant"

- [ ] **Hooks invalid JSON error reporting** (CC 2.1.248)
  - Source: changelog
  - Confidence: high
  - Affects: hook-development
  - Details: NEW behavior where hooks silently treating invalid JSON as plain text are now reported as hook errors with parse messages. Hook developers need to understand proper JSON output requirements.
  - Raw changelog: "Fixed hooks silently treating invalid JSON as plain text; now reported as hook errors with parse messages"

- [ ] **plugin.json UTF-8 BOM fix** (CC 2.1.246)
  - Source: changelog
  - Confidence: high
  - Affects: plugin-structure
  - Details: FIX for plugin installation failing with UTF-8 byte-order mark in plugin.json. Document that plugin.json should not have UTF-8 BOM.
  - Raw changelog: "Fixed plugin installation failing with UTF-8 byte-order mark (BOM) in `plugin.json`"

- [ ] **syncClaudeAiPlugins setting** (CC 2.1.246)
  - Source: system-prompts
  - Confidence: high
  - Affects: plugin-settings
  - Details: NEW setting documentation for how setting plugin sync to false stops downloads, hides or trashes previously synced plugins according to settings scope.
  - Raw changelog: "**NEW:** Data: `syncClaudeAiPlugins` setting"

- [ ] **experimental.cacheTtl in agent frontmatter** (CC 2.1.248)
  - Source: changelog
  - Confidence: high
  - Affects: agent-development (advanced-agent-fields.md)
  - Details: NEW experimental frontmatter field for per-agent prompt cache TTL configuration. Should be documented in advanced-agent-fields.md.
  - Raw changelog: "Added `experimental.cacheTtl` to agent frontmatter for per-agent prompt cache TTL configuration"

- [ ] **Writing for the user system prompt** (CC 2.1.247)
  - Source: system-prompts
  - Confidence: high
  - Affects: output style documentation, skill authoring guidance
  - Details: NEW system prompt with strict requirements for standalone, answer-first final messages with concise complete sentences; prohibits em dashes, parentheticals, arrows, reasoning commentary, and session-invented labels. Affects how skills should be authored.
  - Raw changelog: "**NEW:** System Prompt: Writing for the user - Requires standalone, answer-first final messages with concise complete sentences; prohibits em dashes, parentheticals, arrows, reasoning commentary, and session-invented labels"

---

### May Update

- [ ] **Artifact workshop skill** (CC 2.1.246)
  - Source: system-prompts
  - Confidence: medium
  - Affects: skill examples
  - Details: NEW iterative decision workshops with direct-HTML and Markdown lanes, on-page choice confirmation, evolving published drafts. May be relevant as an advanced skill pattern example.
  - Raw changelog: "**NEW:** Skill: Artifact workshop and Data: Artifact workshop page HTML template"

- [ ] **Whiteboard skill** (CC 2.1.246)
  - Source: system-prompts
  - Confidence: medium
  - Affects: skill documentation
  - Details: NEW model-facing trigger guidance for shared sketch canvas. Demonstrates interactive skill patterns.
  - Raw changelog: "**NEW:** Skill: Whiteboard description - Adds model-facing trigger guidance for creating a shared sketch canvas"

- [ ] **Permission prompt auto-denied after timeout** (CC 2.1.246)
  - Source: system-prompts
  - Confidence: medium
  - Affects: system reminder patterns
  - Details: NEW system reminder explaining unattended timeout behavior. May inform hook or permission documentation.
  - Raw changelog: "**NEW:** System Reminder: Permission prompt auto-denied after timeout"

- [ ] **Project timeline user message provenance** (CC 2.1.242)
  - Source: system-prompts
  - Confidence: medium
  - Affects: security/trust documentation
  - Details: NEW system prompt treating server-verified project-owner timeline markers as direct user turns.
  - Raw changelog: "**NEW:** System Prompt: Project timeline user message provenance"

- [ ] **Snooze tool guidance updates** (CC 2.1.240)
  - Source: system-prompts
  - Confidence: medium
  - Affects: tool documentation
  - Details: Prohibits short-interval polling for harness-tracked background work, recommends 1200-second fallback heartbeat. May affect background agent documentation.
  - Raw changelog: "Tool Description: Snooze (delay and reason guidance) - Prohibits short-interval polling..."

- [ ] **Write tool read-existing-file guidance** (CC 2.1.240)
  - Source: system-prompts
  - Confidence: medium
  - Affects: tool documentation examples
  - Details: Clarifies Write is for creating files or fully replacing previously read files, while partial modifications should use Edit. May need to update Edit/Write examples.
  - Raw changelog: "Tool Description: Write (read existing file first) - Clarifies that Write is for creating files or fully replacing previously read files"

- [ ] **Remote machine auto mode rules** (CC 2.1.248)
  - Source: system-prompts
  - Confidence: medium
  - Affects: auto-mode documentation
  - Details: NEW agent prompt for security monitor applying executing machine's deny/allow rules to remote commands.
  - Raw changelog: "**NEW:** Agent Prompt: Remote machine auto mode rules"

- [ ] **Model picker curation via settings** (CC 2.1.243)
  - Source: changelog
  - Confidence: low
  - Affects: settings documentation
  - Details: Model picker can now be curated via settings. May affect model-related documentation.
  - Raw changelog: "Added... model picker curation via settings"

- [ ] **Restricted mode removing built-in tools** (CC 2.1.248)
  - Source: changelog
  - Confidence: medium
  - Affects: permissions/sandbox documentation
  - Details: Restricted mode now removes built-in tools. May affect security documentation.
  - Raw changelog: "Notable additions include restricted mode removing built-in tools"

- [ ] **Artifact watch approval explanation** (CC 2.1.246)
  - Source: system-prompts
  - Confidence: low
  - Affects: artifact documentation
  - Details: Explains session-wide watch approval, local live connections versus cloud wakeups, and reapproval boundary for comment auto-replies.
  - Raw changelog: "**NEW:** Tool Description: Artifact watch approval explanation"

---

### No Action

- Removed Artifact slides and spreadsheet skills (CC 2.1.239) - OUT OF VERSION RANGE (2.1.239 < 2.1.240)
- Artifact live room guidance (CC 2.1.238) - OUT OF VERSION RANGE (2.1.238 < 2.1.240)
- Artifact runtime verification guidance (CC 2.1.238) - OUT OF VERSION RANGE (2.1.238 < 2.1.240)
- SDK set max thinking tokens request schema (CC 2.1.241) - SDK internal, no plugin impact
- Loops breakdown in usage tracking (CC 2.1.243) - Usage UI, no plugin impact
- glibc 2.44 crash fix (CC 2.1.245) - Linux-specific bug fix
- Arrow-key sequences in dialogs fix (CC 2.1.247) - UI fix
- Transcript slowdowns with long single lines fix (CC 2.1.246) - Performance fix
- Fullscreen scrolling issues fix (CC 2.1.246) - UI fix
- Background session failures fix (CC 2.1.246) - Bug fix
- Markdown rendering problems fix (CC 2.1.246) - UI fix
- MCP OAuth failures fix (CC 2.1.243) - Bug fix
- Auto mode availability issues fix (CC 2.1.243) - Bug fix
- /model picker functionality fix (CC 2.1.243) - Bug fix
- US-only inference premium in cost estimates (CC 2.1.239) - Billing feature
- Fullscreen renderer support expansion (CC 2.1.239) - UI feature
- Python migration guidance improvement (CC 2.1.239) - Migration help
- Keybinding flavor setting (CC 2.1.238) - User preference setting
- Self-hosted runner shutdown deferral (CC 2.1.238) - Enterprise feature
- Prompt caching for LLM gateway fix (CC 2.1.237) - Performance fix
- Spellcheck setting (CC 2.1.235) - User preference setting
- Markdown list alignment fix (CC 2.1.235) - UI fix
- CLAUDE_CODE_PROJECT_DIR_NAME env var (CC 2.1.234) - Environment variable
- Selection clear keybinding action (CC 2.1.234) - Keybinding feature
- GitLab MR badge support (CC 2.1.234) - IDE integration
- Automatic continuation at usage-limit resets (CC 2.1.234) - User experience
- Memory cgroup support on Linux (CC 2.1.233) - Platform-specific
- MCP v2 connection handling improvement (CC 2.1.233) - Internal improvement
- GitLab MR support for --worktree flag (CC 2.1.233) - IDE integration
- Server-managed settings diagnostics (CC 2.1.248) - Internal diagnostics
- Client labeling for self-hosted runners (CC 2.1.248) - Enterprise feature
- SSE keepalive pings (CC 2.1.229) - Streaming improvement
- Sessions stopping redraw fix (CC 2.1.228) - Bug fix
- Git not found on Windows fix (CC 2.1.228) - Bug fix
- Feature flags evaluation fix (CC 2.1.227) - Bug fix
- Bug fixes releases (CC 2.1.240, 2.1.241, 2.1.226, 2.1.220) - Various bug fixes
- Prompt-cache misses during OAuth refreshes fix (CC 2.1.248) - Bug fix
- Session cleanup preservation for desktop apps (CC 2.1.248) - Bug fix
- Various SDK data schema updates - Internal SDK changes
- Message Batches API references (CC 2.1.246) - SDK resources, not plugin-relevant
- Files API references (CC 2.1.246) - SDK resources, not plugin-relevant
- Streaming references (CC 2.1.246) - SDK resources, not plugin-relevant
- Security monitor Self-Modification protection expansion (CC 2.1.240) - Internal security
- Worker fork clarification (CC 2.1.240) - Internal guidance
- Computer request_access guidance (CC 2.1.242) - Computer Use MCP, not plugin-relevant
- Computer computer_batch guidance (CC 2.1.242) - Computer Use MCP, not plugin-relevant
- device_bash tool descriptions removed (CC 2.1.242) - Internal tool removal
- Agent Hook remote transcript note (CC 2.1.242) - Internal hook behavior
- Security monitor browsing path evaluation (CC 2.1.242) - Internal security
- Dynamic pacing loop execution (CC 2.1.242) - Internal loop behavior
- Rate limit unified windows data (CC 2.1.242) - Internal data schema
- Upload device hook template request (CC 2.1.242) - Internal hook schema
- Status line setup subscription rate-limit windows (CC 2.1.242) - Internal UI
- Plugin eval mock enhancements (CC 2.1.242) - Plugin eval internals
- Claude API pricing updates (CC 2.1.242) - Pricing info
- Platform availability updates (CC 2.1.242) - Platform info
- Design skill canvas authoring updates (CC 2.1.242) - Design skill internals
- Browser read-only access tool prefix update (CC 2.1.242) - Internal MCP prefix change
- Query result pending command count (CC 2.1.242) - Internal schema
- Interrupt cancel queued parameter (CC 2.1.242) - Internal schema
- SDK cloud session init snapshot field (CC 2.1.242) - Internal schema
- SDK protocol capabilities field (CC 2.1.242) - Internal schema
- Artifact MCP connector guidance (CC 2.1.239-2.1.248) - Artifact system internals
- Artifact database guidance (CC 2.1.242) - Artifact system internals
- Artifact identical resubmission refusal (CC 2.1.239-2.1.247) - Artifact system internals
- Artifact supporting files guidance (CC 2.1.242) - Artifact system internals
- Artifact publishing and update guidance (CC 2.1.242-2.1.248) - Artifact system internals
- Artifact live room guidance updates (CC 2.1.238-2.1.242) - Artifact system internals
- /schedule slash command updates (CC 2.1.246-2.1.248) - Schedule command internals
- Memory instructions conditional guidance (CC 2.1.247) - Memory system internals
- Directory sync branch switch parked work (CC 2.1.247) - Cloud sync internals
- Prompt Caching documentation updates (CC 2.1.247) - Caching internals
- Agent Design Patterns caching advice (CC 2.1.247) - Pattern updates
- Building LLM-powered applications updates (CC 2.1.247) - SDK guide updates
- Design skill canvas/artboard updates (CC 2.1.247) - Design skill internals
- Whiteboard skill updates (CC 2.1.246-2.1.247) - Whiteboard skill internals
- Background tasks changed event schema (CC 2.1.247) - Internal event schema
- Claude Code gateway protocol (CC 2.1.247) - Internal protocol
- Live documentation sources (CC 2.1.247) - Internal data
- Plan artifact HTML template (CC 2.1.246-2.1.247) - Internal template
- Workshop artifact HTML template (CC 2.1.246-2.1.247) - Internal template
- RefreshMcpTools surface-specific guidance (CC 2.1.248) - MCP tool internals
- Artifact content host allowlist guidance (CC 2.1.239) - Artifact system
- /insights report output rework (CC 2.1.239) - Insights command internals
- Artifact default format change to HTML (CC 2.1.239) - Artifact system
- Artifact reads via action: "read" (CC 2.1.239) - Artifact system
- Artifact watch modes (CC 2.1.239) - Artifact system
- Artifact room approval changes (CC 2.1.239) - Artifact system
- Anthropic Python SDK upgrade guidance (CC 2.1.239) - SDK internals
- SDK protocol capabilities (CC 2.1.239) - SDK internals

---

## Summary

**Version range**: 2.1.240 to 2.1.250 (11 versions since last audit on 2026-08-22)

**Token delta** (from system-prompts):
- 2.1.240: -1,911 tokens
- 2.1.241: +182 tokens
- 2.1.242: +30,636 tokens
- 2.1.243: no changes
- 2.1.245: no changes
- 2.1.246: +69,754 tokens
- 2.1.247: +26,898 tokens
- 2.1.248: +2,562 tokens
- 2.1.250: no changes
- **Total**: +128,121 tokens

**Key themes**:
1. **New skills**: Workflow authoring reference, Cost optimization, Artifact workshop, Whiteboard
2. **New tools**: SendFeedback
3. **Removed features**: /loop fixed variant, Artifact slides/spreadsheet skills
4. **Agent improvements**: Simple usage notes, coordinator forced-inheritance variant
5. **Artifact enhancements**: Type discovery, live rooms, runtime verification, workshop
6. **Writing style**: New "Writing for the user" system prompt with strict formatting requirements
7. **Cloud/Directory sync**: Comprehensive guidance for synced checkouts and plain folders

**Priority items for plugin-dev**:
1. Agent tool simple usage notes (CC 2.1.240) - affects agent documentation patterns
2. SendFeedback tool (CC 2.1.247) - new built-in tool
3. Cost optimization skill (CC 2.1.247) - demonstrates advanced skill patterns
4. Workflow authoring reference (CC 2.1.248) - new skill reference pattern
5. Writing for the user (CC 2.1.247) - affects skill authoring guidance
6. Coordinator forced-inheritance (CC 2.1.248) - affects multi-agent coordination

**Degraded triangulation note**: The claude-code-guide agent dispatch was not available in this environment. Changes were verified using two sources (upstream changelog and system-prompts changelog). Confidence ratings reflect dual-source verification where both sources confirm the change.

---

## Total changes requiring action

- **Must Update**: 13 items (post-verification: 10 original confirmed + 4 promoted - 1 rejected)
- **May Update**: 10 items (post-verification: 16 original - 2 promoted - 4 demoted)
- **No Action**: 85+ items (bug fixes, UI changes, internal schemas, Artifact system, SDK internals, out-of-range items)

---

## Stage 2: Verification Results
### Verified: 2026-08-28

#### Must Update Verification

- ✓ **Workflow authoring reference** (CC 2.1.248) — confirmed in system-prompts changelog line 18. Gap exists: not documented in plugin-dev skill-format or skill-development references. Affects skill documentation patterns.
- ✓ **Coordinator mode forced-inheritance variant** (CC 2.1.248) — confirmed in system-prompts changelog line 29. Gap exists: not documented in agent-development overview or advanced-agent-fields.md. Affects agent coordination patterns.
- ✓ **SendFeedback tool** (CC 2.1.247) — confirmed in both CC changelog and system-prompts. Gap exists: not mentioned anywhere in plugin-dev. New built-in tool plugin developers should know about.
- ✓ **Cost optimization skill** (CC 2.1.247) — confirmed in system-prompts changelog line 43. Gap exists: not referenced in plugin-dev. Demonstrates advanced skill patterns (Admin API, evaluations).
- ✓ **Admin API reference documentation** (CC 2.1.247) — confirmed in system-prompts changelog line 41. Gap exists: not mentioned in plugin-dev. Relevant for enterprise plugin integrations.
- ✓ **Agent tool simple usage notes** (CC 2.1.240) — confirmed in system-prompts changelog line 135. Gap exists: agent-development overview does not include fork behavior, resuming agents, worktree isolation, background execution, or parallel launches.
- ✓ **Artifact type discovery and creation guidance** (CC 2.1.242) — confirmed in system-prompts changelog line 100. Gap exists: not in plugin-dev. May affect skill patterns.
- ✓ **Directory sync guidance system reminders** (CC 2.1.242) — confirmed in system-prompts changelog line 98. Low plugin relevance; primarily affects cloud session behavior.
- ✗ **Removed Artifact slides and spreadsheet skills** (CC 2.1.239) — **OUT OF VERSION RANGE**. The manifest claims 2.1.240-2.1.250 but this item is from 2.1.239. Reclassify to No Action (out-of-range).
- ✓ **Removed /loop slash command variant** (CC 2.1.248) — confirmed in system-prompts changelog line 20. Low plugin relevance; internal command behavior change.
- ✓ **Writing for the user system prompt** (CC 2.1.247) — confirmed in system-prompts changelog line 44. Gap exists: skill authoring guidance does not mention these strict writing requirements.

#### Missed Items (promoted from No Action or newly discovered)

- ! **Hooks invalid JSON error reporting** (CC 2.1.248) — hooks silently treating invalid JSON as plain text; now reported as hook errors with parse messages. Highly plugin-relevant: affects hook error handling documentation.
  - Source: CC changelog 2.1.248 Fixed section
  - Affects: hook-development
  - Details: Hook scripts that return invalid JSON are now properly reported as errors instead of being silently treated as plain text. Plugin developers need to understand proper JSON output requirements.

- ! **plugin.json UTF-8 BOM fix** (CC 2.1.246) — plugin installation failing with UTF-8 byte-order mark in plugin.json.
  - Source: CC changelog 2.1.246 Fixed section
  - Affects: plugin-structure
  - Details: Document that plugin.json should not have UTF-8 BOM to avoid installation failures.

- ! **/reload-plugins fix for skills/ structure** (CC 2.1.246) — /reload-plugins reporting 0 skills for plugins defining skills under `skills/*/SKILL.md`.
  - Source: CC changelog 2.1.246 Fixed section
  - Affects: skill-development
  - Details: Bug fix context may help troubleshoot plugin reload issues.

- ! **syncClaudeAiPlugins setting** (CC 2.1.246) — promoted from May Update.
  - Source: system-prompts changelog line 67
  - Affects: plugin-settings
  - Details: Documents how setting plugin sync to false stops downloads and affects plugin visibility. Plugin developers should understand this setting.

- ! **experimental.cacheTtl in agent frontmatter** (CC 2.1.248) — promoted from May Update.
  - Source: CC changelog 2.1.248 Added section
  - Affects: agent-development
  - Details: New experimental frontmatter field for per-agent prompt cache TTL configuration. Should be documented in advanced-agent-fields.md.

#### May Update Resolution

- ↑ **syncClaudeAiPlugins setting** (CC 2.1.246) — promoted to Must Update: directly affects plugin sync behavior and visibility
- ↑ **Experimental cache TTL settings for agents** (CC 2.1.248) — promoted to Must Update: new agent frontmatter field
- = **Artifact workshop skill** (CC 2.1.246) — kept as May Update: advanced skill pattern, not essential
- = **Whiteboard skill** (CC 2.1.246) — kept as May Update: demonstrates interactive patterns but not essential
- = **Permission prompt auto-denied after timeout** (CC 2.1.246) — kept as May Update: may inform hook patterns
- = **Project timeline user message provenance** (CC 2.1.242) — kept as May Update: trust/security context
- ↓ **SDK set max thinking tokens request schema** (CC 2.1.241) — demoted to No Action: SDK internal, no plugin impact
- = **Snooze tool guidance updates** (CC 2.1.240) — kept as May Update: may affect background agent docs
- = **Write tool read-existing-file guidance** (CC 2.1.240) — kept as May Update: may affect tool usage examples
- = **Remote machine auto mode rules** (CC 2.1.248) — kept as May Update: security monitor context
- ↓ **Artifact live room guidance** (CC 2.1.238) — demoted to No Action: out of version range (2.1.238 < 2.1.240)
- ↓ **Artifact runtime verification guidance** (CC 2.1.238) — demoted to No Action: out of version range
- = **Model picker curation via settings** (CC 2.1.243) — kept as May Update: settings documentation
- ↓ **Loops breakdown in usage tracking** (CC 2.1.243) — demoted to No Action: usage UI, no plugin impact
- = **Restricted mode removing built-in tools** (CC 2.1.248) — kept as May Update: affects sandbox/permission docs
- = **Artifact watch approval explanation** (CC 2.1.246) — kept as May Update: artifact pattern documentation

#### Summary

- Must Update: **13 items** (10 confirmed, 1 rejected as out-of-range, 4 promoted from May Update/missed)
- May Update: **10 items** remaining (5 demoted, 2 promoted)
- Confidence: **High** — all Must Update items verified against primary sources; version range discrepancies identified and corrected

#### Critical Issues Found

1. **Version range includes out-of-range items**: The manifest includes 2.1.239 and 2.1.238 items while claiming 2.1.240-2.1.250 range. These have been reclassified.
2. **Plugin-specific bug fixes missed**: Several CC changelog bug fixes directly affecting plugins (UTF-8 BOM, /reload-plugins, hook JSON errors) were incorrectly classified as No Action.
3. **Item count discrepancy**: Original "11 Must Update" is now 13 after promotions and corrections.
