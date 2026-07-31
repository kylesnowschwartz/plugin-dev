# Upstream Change Manifest
## CC Version Range: 2.1.212 - 2.1.220
## Generated: 2026-07-28
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [Y]

---

### Must Update

- [ ] **DirectoryAdded hook event** (CC 2.1.219)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: hook-development skill, hook event table
  - Details: New hook event (29th) for mid-session directory registration via `/add-dir` and SDK `register_repo_root` requests. Input includes refreshed-sandbox timing and source-specific failure/output handling.
  - Raw: "**NEW:** Data: DirectoryAdded hook description -- Documents the post-registration hook for `/add-dir` and SDK `register_repo_root` requests, including its input, refreshed-sandbox timing, and source-specific failure and output handling."

- [ ] **Claude Opus 5 as default model** (CC 2.1.219)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: agent-development skill, model references
  - Details: Claude Opus 5 replaces Sonnet 5 as default model with 1M context window at "$10/$50 per Mtok". Omitting `thinking` runs adaptive thinking. Explicit thinking disablement on Opus 5 only accepted through `high` effort; returns 400 at `xhigh` or `max`. Adds `xhigh` effort value.
  - Raw: "Added Claude Opus 5 as default model with 1M context window at '$10/$50 per Mtok'" and "Data: Claude API reference (all languages) -- Add Claude Opus 5 guidance that omitting `thinking` runs adaptive thinking."

- [ ] **sandbox.network.strictAllowlist setting** (CC 2.1.219)
  - Source: changelog only
  - Confidence: medium
  - Affects: hook-development skill (sandbox affects Bash command execution) [REMAPPED BY STAGE 2 - was plugin-settings]
  - Details: New setting for network restrictions in sandboxed environments.
  - Raw: "Introduced `sandbox.network.strictAllowlist` setting for network restrictions."

- [ ] **sandbox.filesystem.disabled setting** (CC 2.1.216)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: hook-development skill (sandbox affects Bash command execution) [REMAPPED BY STAGE 2 - was plugin-settings]
  - Details: Enables unrestricted host-filesystem access for sandboxed commands while retaining network confinement, independent Bash prompting, and environment-credential protection.
  - Raw: "**NEW:** Data: Sandbox filesystem disabled setting -- Explains unrestricted host-filesystem access for sandboxed commands while retaining network confinement, independent Bash prompting, and environment-credential protection, and notes the filesystem read protections this setting disables."

- [ ] **EndConversation tool** (CC 2.1.214)
  - Source: changelog only
  - Confidence: medium
  - Affects: tool documentation, agent-development skill
  - Details: New tool for handling abusive users. Allows agents to terminate conversations.
  - Raw: "Added `EndConversation` tool for handling abusive users."

- [ ] **Skills require explicit invocation - /verify and /code-review disabled** (CC 2.1.215)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: skill-development skill, auto-invocation behavior
  - Details: Automatic `/verify` and `/code-review` skill execution disabled. Skills now require explicit invocation. Behavioral change affecting how skills are triggered.
  - Raw: "Disabled automatic `/verify` and `/code-review` skill execution. Skills now require explicit invocation."

- [ ] **Subagent delegation restraint guidance** (CC 2.1.215)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent-development skill, subagent patterns
  - Details: New system prompt limits subagent use to genuinely independent, sizeable, or parallel work. Keeps small tasks and inline verification in parent agent. Discourages redundant fan-out and duplicated work. Favors a few precisely briefed agents.
  - Raw: "**NEW:** System Prompt: Subagent delegation restraint -- Limits subagent use to genuinely independent, sizeable, or parallel work; keeps small tasks and inline verification in the parent agent; discourages redundant fan-out and duplicated work; and favors a few precisely briefed agents."

- [ ] **/fork redesigned to copy conversations into background sessions** (CC 2.1.212)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: agent-development skill, fork behavior documentation
  - Details: Breaking change to /fork command behavior. Now copies conversations into background sessions instead of previous behavior.
  - Raw: "Redesigned `/fork` to copy conversations into background sessions."

- [ ] **Session-wide WebSearch tool call limits (default 200)** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: tool documentation, resource limits
  - Details: Implements session-wide limit of 200 WebSearch tool calls per session. Important constraint for plugins that use web search extensively.
  - Raw: "Implemented session-wide WebSearch tool call limits (default 200)."

- [ ] **Per-session subagent spawn cap (default 200)** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: agent-development skill, resource limits
  - Details: Implements limit of 200 subagent spawns per session. Critical constraint for plugins that spawn many subagents.
  - Raw: "Added per-session subagent spawn cap (default 200)."

- [ ] **MCP tool calls over 2 minutes auto-background** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: mcp-integration skill, timeout behavior
  - Details: MCP tool calls exceeding 2 minutes are automatically moved to background execution. Affects MCP server design and long-running tool expectations.
  - Raw: "MCP tool calls over 2 minutes auto-background automatically."

- [ ] **claude auto-mode reset command** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: command documentation
  - Details: New `claude auto-mode reset` command with confirmation. Allows resetting auto-mode configuration.
  - Raw: "Added `claude auto-mode reset` command with confirmation."

- [ ] **Persistent memory usage and writing guidance** (CC 2.1.212, expanded 2.1.219)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: memory/skill documentation
  - Details: New cross-session file-memory rules for validating recalled knowledge, keeping memories applicable, durable, and legible. Later expanded to add pinned memories for globally applicable guidance and restrict memory deletion to eligible Markdown files outside protected subdirectories.
  - Raw: "**NEW:** System Prompt: Persistent memory usage and writing guidance -- Adds cross-session file-memory rules for validating recalled knowledge, keeping memories applicable, durable, and legible, and immediately recording durable user corrections or newly learned environment behavior."

- [ ] **Invoke skill tool background guidance** (CC 2.1.218)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: skill-development skill
  - Details: Clarifies that background skills initially return only the agent name, deliver results later through task notifications, and should not be waited on or invoked again while pending.
  - Raw: "Tool Description: Invoke skill -- Clarifies that background skills initially return only the agent name, deliver results later through task notifications, and should not be waited on or invoked again while pending."

- [ ] **SessionStart hook source "fork"** (CC 2.1.214/2.1.218) [STAGE 2 ADDITION]
  - Source: changelog (CC 2.1.214)
  - Confidence: high
  - Affects: hook-development (event-schemas.md)
  - Details: SessionStart hooks now report source "fork" when session begins as fork instead of "resume". Breaking change to hook input schema.
  - Raw: "Changed SessionStart hooks to report source 'fork' when session begins as fork instead of 'resume'"

- [ ] **Boolean value expansion for frontmatter** (CC 2.1.216) [STAGE 2 ADDITION]
  - Source: changelog
  - Confidence: high
  - Affects: skill-development, agent-development, command-development
  - Details: Skill and plugin frontmatter booleans now accept yes/no/on/off/1/0 (case-insensitive) alongside true/false.
  - Raw: "Added yes/no/on/off/1/0 (case-insensitive) as accepted values for skill and plugin frontmatter booleans alongside true/false"

- [ ] **Agent names cannot contain colons** (CC 2.1.216) [STAGE 2 ADDITION]
  - Source: changelog
  - Confidence: high
  - Affects: agent-development (validation rules)
  - Details: Agent markdown files reject agent names containing `:`, reserved for plugin namespacing. Breaking validation change.
  - Raw: "Changed agent markdown files to reject agent names containing ':', reserved for plugin namespacing"

- [ ] **Concurrent subagent cap** (CC 2.1.217) [STAGE 2 ADDITION]
  - Source: changelog
  - Confidence: high
  - Affects: agent-development (resource limits)
  - Details: Cap on concurrently-running subagents (default 20, override with CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS). Different from per-session spawn cap.
  - Raw: "Added cap on concurrently-running subagents (default 20, override with CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS)"

- [ ] **Nested subagent depth 3** (CC 2.1.219) [STAGE 2 ADDITION]
  - Source: changelog
  - Confidence: high
  - Affects: agent-development (orchestration)
  - Details: Subagents can spawn nested subagents up to depth 3 by default; CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1 to disable. Replaces previous default of no nesting.
  - Raw: "Subagents can now spawn nested subagents up to depth 3 by default; set CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1 to disable"

- [ ] **Single-segment dir/** hook condition change** (CC 2.1.218) [STAGE 2 ADDITION]
  - Source: changelog
  - Confidence: high
  - Affects: hook-development (matchers, advanced.md)
  - Details: Single-segment `dir/**` hook `if:` conditions now match only `<cwd>/dir`; write `**/dir/**` for any-depth matching. Breaking change for hook matchers.
  - Raw: "Changed single-segment 'dir/**' hook 'if:' conditions to match only '<cwd>/dir'; write '**/dir/**' for any-depth matching"

---

### May Update

- [ ] **/code-review runs as background subagent** (CC 2.1.218)
  - Source: changelog, system-prompts (both confirm)
  - Confidence: high
  - Affects: examples, workflow documentation
  - Details: Code review command converted to run as background subagent. System-prompts confirms routing eligible reviews through background workflow at requested effort.

- [ ] **Action safety and truthful reporting restored** (CC 2.1.216)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent behavior documentation
  - Details: System prompt restored (was removed in 2.1.215, readded in 2.1.216) for confirmation of hard-to-reverse or outward-facing actions, target inspection before destructive changes, and plain reporting of failed/skipped/verified outcomes.

- [ ] **Scope fidelity merged into Delivering work at full scope** (CC 2.1.218)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent behavior documentation
  - Details: Former scope-fidelity rules absorbed into new "Delivering work at full scope" prompt. Strengthens routine ambiguity handling, scope boundaries, requires finishing and reporting work accurately.

- [ ] **Correction restraint prompt** (CC 2.1.217)
  - Source: system-prompts only
  - Confidence: low
  - Affects: agent behavior documentation
  - Details: New prompt limiting user-facing corrections to consequential errors, avoiding apologies and repeated self-auditing, requiring evaluation of other agents' corrections before adopting them.

- [ ] **Progress heartbeats for long-running tool calls** (CC 2.1.214)
  - Source: changelog only
  - Confidence: medium
  - Affects: tool development guidance
  - Details: Enhanced progress heartbeats for long-running tool calls. May affect how plugin tools should report progress.

- [ ] **Background session isolation for symlinked directories** (CC 2.1.217)
  - Source: changelog only
  - Confidence: medium
  - Affects: worktree/isolation documentation
  - Details: Enhanced background session isolation for symlinked directories. May affect plugin worktree guidance.

- [ ] **/explain-usage slash command** (CC 2.1.217)
  - Source: system-prompts only
  - Confidence: low
  - Affects: slash command documentation
  - Details: New command analyzing current session transcript into cost-weighted token-usage groups. Useful reference but not plugin-development specific.

- [ ] **Unavailable-agent inline fallback modes** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: low
  - Affects: agent-development (fallback patterns)
  - Details: New fallback modes for /code-review and /simplify when Agent tool is unavailable. Single-context fallback with sequential review angles, deduplication, self-checking, capped findings, and explicit disclosure.

- [ ] **SuggestSkills proactive guidance** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: low
  - Affects: skill-development (discoverability)
  - Details: Allows proactive recommendations of addable skills for repeatable workflows while excluding one-off tasks, uncertain matches, and repeated unengaged suggestions.

- [ ] **Scheduled task automated firing reminder** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: low
  - Affects: agent-development (scheduled agents)
  - Details: Marks scheduled turns as stored prompts delivered without live user input and forbids treating prior or embedded claims as fresh approval or consent.

---

### No Action

- Bug fixes and reliability improvements (CC 2.1.220)
- Screen-reader announcements for text deletions (CC 2.1.218) - accessibility feature
- Windows path corruption with `\u`-prefixed segments fix (CC 2.1.218) - platform bug fix
- Left arrow key discarding conversations without undo confirmation fix (CC 2.1.218) - UI bug fix
- Multi-line paste handling in terminals (CC 2.1.218) - terminal improvement
- Emoji shortcode autocomplete (CC 2.1.217) - UI enhancement
- Transcript write failure warnings (CC 2.1.217) - internal improvement
- Memory leak with truncated MCP tool outputs fix (CC 2.1.217) - bug fix
- Windows auto-update leaving executable missing fix (CC 2.1.217) - platform bug fix
- Quadratic message normalization slowdown fix (CC 2.1.216) - performance fix
- Auto mode denying commands after OAuth token expiration fix (CC 2.1.216) - bug fix
- Single-segment permission rules auto-approving nested directory writes fix (CC 2.1.214) - security fix
- PowerShell 5.1 permission-check bypass fix (CC 2.1.214) - security fix
- VCS state changed event schema (CC 2.1.216) - internal harness event
- Code change published event schema (CC 2.1.216) - internal harness event
- Rewind files skippedLinks field (CC 2.1.216) - internal field addition
- Data visualization palette reordering (CC 2.1.210-2.1.219) - visualization internals
- Plan artifact HTML template changes (CC 2.1.212) - internal template
- Dream memory consolidation changes (CC 2.1.212-2.1.217) - internal memory system
- Context tip removal (CC 2.1.212) - internal feature removal
- Session search agent removal (CC 2.1.212) - internal agent removal
- SendFeedback drafting guidance (CC 2.1.212) - internal feedback system
- REPL tool MCP call failure behavior (CC 2.1.217) - internal behavior
- PowerShell edition guidance correction (CC 2.1.213) - minor correction
- Workshop artifact HTML template changes (CC 2.1.216-2.1.219) - internal template
- Artifact PR review workflow (CC 2.1.213-2.1.219) - artifact workflow, not plugin-dev
- Artifact whiteboard (CC 2.1.218) - artifact feature, not plugin-dev
- Import to Claude Code skill (CC 2.1.213) - import workflow, not plugin-dev
- Artifact runtime capabilities (CC 2.1.216-2.1.219) - artifact feature, not plugin-dev
- Navigate tool (CC 2.1.211) - browser extension feature, not plugin-dev
- Managed Agents API updates (CC 2.1.218-2.1.219) - API documentation, not plugin-dev
- AskUserQuestion minimum options validation (CC 2.1.216) - internal validation

---

## Summary

**Critical plugin-dev impact (Must Update):** 20 items (14 original + 6 Stage 2 additions)
- DirectoryAdded hook: New 29th hook event (hook-development)
- Claude Opus 5 default: New default model with behavior changes (agent-development)
- sandbox.network.strictAllowlist: New sandbox setting (hook-development -- REMAPPED from plugin-settings)
- sandbox.filesystem.disabled: New sandbox setting (hook-development -- REMAPPED from plugin-settings)
- EndConversation tool: New tool (agent-development)
- Skills explicit invocation: Behavioral change for /verify and /code-review (skill-development)
- Subagent delegation restraint: New guidance limiting subagent use (agent-development)
- /fork redesign: Breaking change to background sessions (agent-development)
- WebSearch session limits: 200 call limit (tool documentation)
- Subagent spawn cap: 200 subagent limit (agent-development)
- MCP auto-background: 2-minute timeout triggers background (mcp-integration)
- auto-mode reset command: New command (command documentation)
- Persistent memory guidance: Cross-session memory rules (memory documentation)
- Invoke skill background: Background skill behavior (skill-development)
- **[STAGE 2]** SessionStart hook source "fork": New source value for forked sessions (hook-development)
- **[STAGE 2]** Boolean value expansion: yes/no/on/off/1/0 for frontmatter (skill/agent/command-development)
- **[STAGE 2]** Agent names cannot contain colons: Validation change (agent-development)
- **[STAGE 2]** Concurrent subagent cap: Default 20, CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS (agent-development)
- **[STAGE 2]** Nested subagent depth 3: Default 3 levels, CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH (agent-development)
- **[STAGE 2]** Single-segment dir/** hook condition: Breaking matcher change (hook-development)

**Moderate impact (May Update):** 10 items
- /code-review background subagent conversion
- Action safety and truthful reporting restored
- Scope fidelity merged into new prompt
- Correction restraint prompt
- Progress heartbeats
- Background session symlink isolation
- /explain-usage command
- Unavailable-agent fallback modes
- SuggestSkills proactive guidance
- Scheduled task firing reminder

**No action needed:** 30+ items
- Bug fixes, performance improvements, internal refactors
- Accessibility features
- Platform-specific fixes
- Internal prompt/template changes
- Artifact features (not plugin-dev)

---

## Token Deltas from System-Prompts

- 2.1.220: No changes
- 2.1.219: +30,034 tokens (major release - Opus 5, DirectoryAdded, etc.)
- 2.1.218: +39,506 tokens (major release - Artifact workflows, scope changes)
- 2.1.217: +13,476 tokens (/explain-usage, correction restraint, etc.)
- 2.1.216: +31,503 tokens (sandbox settings, Artifact updates)
- 2.1.215: +645 tokens (subagent delegation restraint)
- 2.1.214: No prompt changes
- 2.1.213: +7,589 tokens (unavailable-agent modes, PR review, Import)
- 2.1.212: +1,066 tokens (/code-review routing, memory guidance)

**Total delta since 2.1.211:** +123,819 tokens

---

## Notes

1. **Full triangulation achieved**: All three sources (changelog, system-prompts, claude-code-guide) were successfully consulted.

2. **Large release window**: 9 versions (2.1.212-2.1.220) with significant changes, notably the Opus 5 default model switch and extensive Artifact workflow additions.

3. **Breaking changes identified**:
   - /fork command now copies to background sessions (2.1.212)
   - Skills require explicit invocation (2.1.215)
   - Claude Opus 5 thinking behavior differs from Sonnet 5 (2.1.219)

4. **New resource limits**:
   - 200 WebSearch calls per session
   - 200 subagent spawns per session
   - 2-minute MCP timeout triggers auto-background

5. **New hook event**: DirectoryAdded (29th event) needs to be added to hook event table.

6. **New settings**: Two sandbox settings (network.strictAllowlist, filesystem.disabled) need documentation.

---

## Stage 2: Verification Results
### Verified: 2026-07-28

#### Must Update Verification
- [x] **DirectoryAdded hook event** (CC 2.1.219) — confirmed in CC changelog and system-prompts; gap exists in hook-development/overview.md (shows 28 events, needs 29) and event-schemas.md (missing DirectoryAdded schema)
- [x] **Claude Opus 5 as default model** (CC 2.1.219) — confirmed in CC changelog; gap exists in agent-development/overview.md (mentions Sonnet 5 as default, needs update for Opus 5)
- [x] **sandbox.network.strictAllowlist setting** (CC 2.1.219) — confirmed in CC changelog; RECLASSIFIED: plugin-settings skill documents plugin `.local.md` patterns, not CC sandbox settings; should map to hook-development or a new sandbox section
- [x] **sandbox.filesystem.disabled setting** (CC 2.1.216) — confirmed in CC changelog and system-prompts; RECLASSIFIED: same as above, wrong topic mapping
- [x] **EndConversation tool** (CC 2.1.214) — confirmed in CC changelog; gap exists - no mention in plugin-dev docs
- [x] **Skills require explicit invocation** (CC 2.1.215) — confirmed in CC changelog ("Claude no longer runs /verify and /code-review skills independently"); gap exists in skill-development docs
- [x] **Subagent delegation restraint guidance** (CC 2.1.215) — confirmed in system-prompts; partially documented in advanced-agent-fields.md but needs explicit mention of new restraint prompt
- [x] **/fork redesigned to copy conversations into background sessions** (CC 2.1.212/2.1.213) — confirmed in CC changelog; partial gap - some fork docs exist but need update for background session behavior
- [x] **Session-wide WebSearch tool call limits** (CC 2.1.213) — confirmed in CC changelog (default 200, tunable via CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION); gap exists
- [x] **Per-session subagent spawn cap** (CC 2.1.213) — confirmed in CC changelog (default 200, CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION); gap exists
- [x] **MCP tool calls over 2 minutes auto-background** (CC 2.1.213) — confirmed in CC changelog (CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS); gap exists in mcp-integration
- [x] **claude auto-mode reset command** (CC 2.1.213) — confirmed in CC changelog; minor relevance to plugin development
- [x] **Persistent memory guidance** (CC 2.1.212, expanded 2.1.219) — confirmed in system-prompts; gap exists for plugin developers needing to understand memory behavior
- [x] **Invoke skill background guidance** (CC 2.1.218) — confirmed in system-prompts; gap exists in skill-development docs

#### Missed Items (promoted from No Action / not in manifest)
- ! **SessionStart hook source "fork"** (CC 2.1.214/2.1.218) — missed because classified as improvement, not plugin-relevant
  - Affects: hook-development (event-schemas.md)
  - Details: SessionStart hooks now report source "fork" when session begins as fork instead of "resume". Current docs show `source: "startup|resume|clear|compact"` — needs "fork" added.
- ! **Boolean value expansion for frontmatter** (CC 2.1.216) — missed because classified as improvement
  - Affects: skill-development, agent-development, command-development
  - Details: Skill and plugin frontmatter booleans now accept yes/no/on/off/1/0 (case-insensitive) alongside true/false.
- ! **Agent names cannot contain colons** (CC 2.1.216) — missed because not captured
  - Affects: agent-development (validation rules)
  - Details: Agent markdown files reject agent names containing `:`, reserved for plugin namespacing. Breaking validation change.
- ! **Concurrent subagent cap** (CC 2.1.217) — missed because not captured
  - Affects: agent-development (resource limits)
  - Details: Cap on concurrently-running subagents (default 20, override with CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS).
- ! **Nested subagent depth 3** (CC 2.1.219) — missed because not captured
  - Affects: agent-development (orchestration)
  - Details: Subagents can spawn nested subagents up to depth 3 by default; CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1 to disable.
- ! **Single-segment dir/** hook condition change** (CC 2.1.218) — missed because listed as improvement
  - Affects: hook-development (matchers)
  - Details: Single-segment `dir/**` hook `if:` conditions now match only `<cwd>/dir`; write `**/dir/**` for any-depth. Breaking change for hook matchers.

#### May Update Resolution
- = **/code-review runs as background subagent** (CC 2.1.218) — kept as May Update: useful example but not core plugin-dev guidance
- = **Action safety and truthful reporting restored** (CC 2.1.216) — kept as May Update: agent behavior context, not plugin-specific
- = **Scope fidelity merged into Delivering work at full scope** (CC 2.1.218) — kept as May Update: agent behavior context
- = **Correction restraint prompt** (CC 2.1.217) — kept as May Update: general behavior, low plugin-dev relevance
- = **Progress heartbeats for long-running tool calls** (CC 2.1.214) — kept as May Update: may affect plugin tool design guidance
- = **Background session isolation for symlinked directories** (CC 2.1.217) — kept as May Update: relevant to worktree/isolation docs
- = **/explain-usage slash command** (CC 2.1.217) — kept as May Update: reference command, low priority
- = **Unavailable-agent inline fallback modes** (CC 2.1.213) — kept as May Update: useful pattern for plugin agents
- = **SuggestSkills proactive guidance** (CC 2.1.213) — kept as May Update: affects skill discoverability
- = **Scheduled task automated firing reminder** (CC 2.1.213) — kept as May Update: useful for scheduled agent guidance

#### Topic Mapping Corrections
- ! **sandbox.network.strictAllowlist** and **sandbox.filesystem.disabled** — WRONG topic. plugin-settings documents plugin `.local.md` state files, not Claude Code sandbox settings. These should either:
  1. Go in hook-development (sandbox affects Bash command execution in hooks), OR
  2. Create a new "sandbox-settings" reference section, OR
  3. Document in the main SKILL.md under a "Claude Code Settings Reference" section
  - Recommendation: Add to hook-development/references/advanced.md in a "Sandbox Configuration" section since hooks are most affected by sandbox settings.

#### Summary
- **Must Update:** 14 items (14 confirmed, 0 rejected, 6 added = **20 total**)
- **May Update:** 10 items remaining
- **No Action:** 30+ items (appropriate classification)
- **Confidence:** HIGH - all items verified against primary sources; 6 plugin-relevant items were missed by Stage 1

#### Issues for Orchestrator
1. **Missed Items:** 6 plugin-relevant changes were not captured in Stage 1's scan. The keywords used may have missed:
   - "source: fork" for SessionStart hooks
   - Boolean value expansion (yes/no/on/off/1/0)
   - Agent name colon restriction
   - Concurrent subagent limit (different from spawn cap)
   - Nested depth limit
   - Single-segment `dir/**` breaking change for hooks
2. **Topic Mapping Error:** sandbox settings were incorrectly mapped to plugin-settings skill. Stage 1 should verify topic mappings by reading the target overview files.
3. **Recommendation:** Stage 1 should expand keyword scan to include: `source`, `boolean`, `colon`, `concurrent`, `nested`, `depth`, `single-segment`, `dir/**`
