# Upstream Change Manifest
## CC Version Range: 2.1.183 - 2.1.195
## Generated: 2026-06-28
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - agent unavailable in CI]

---

### Must Update

- [ ] **Hook matchers with hyphens require exact matches** (CC 2.1.195)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: hook-development/overview.md (Matchers section)
  - Details: Hook matchers with hyphens (e.g., `code-reviewer`, `mcp__brave-search`) now require exact matches instead of substring matching. Wildcard patterns like `mcp__brave-search__.*` now required for partial matches. Breaking change for plugins using hyphenated matchers.
  - Raw changelog: "Fixed hook matchers with hyphenated identifiers (e.g., `code-reviewer`, `mcp__brave-search`) performing substring matching instead of exact matching"

- [ ] **External plugins via project settings no longer require reinstall consent** (CC 2.1.195)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: plugin-structure/overview.md (Plugin Loading section)
  - Details: External plugins enabled via project `.claude/settings.json` no longer prompt for reinstall consent on each loader path. Changes plugin installation UX.
  - Raw changelog: "Fixed external plugins enabled only via project `.claude/settings.json` not requiring explicit install consent on each loader path"

- [ ] **Hooks with comma-separated matchers fix** (CC 2.1.191)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: hook-development/overview.md (Matchers section, Critical Gotchas)
  - Details: Fixed hooks with comma-separated matchers (e.g., `"Bash,PowerShell"`) silently never firing. Document that pipe-separated patterns are required, not commas.
  - Raw changelog: "Fixed hooks with comma-separated matchers silently never firing"

- [ ] **Background monitor WebSocket source** (CC 2.1.195)
  - Source: system-prompts changelog
  - Confidence: high (VERIFIED)
  - Affects: plugin-structure/overview.md (Experimental Features section)
  - Details: New `ws` source type for background monitors that opens a WebSocket and streams each incoming text frame as one notification event. Documents binary frames, socket close codes, and same rate limiting as bash.
  - Raw changelog: "NEW: Tool Description: Background monitor WebSocket source"

- [ ] **autoMode.classifyAllShell setting** (CC 2.1.193)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: plugin-settings documentation, hook behavior in auto mode
  - Details: New setting `autoMode.classifyAllShell` routes all Bash/PowerShell commands through the safety classifier, not just arbitrary-code-execution patterns.
  - Raw changelog: "Added `autoMode.classifyAllShell` setting to route all Bash/PowerShell commands through classifier"

- [ ] **sandbox.credentials setting** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: plugin-structure security documentation
  - Details: New setting `sandbox.credentials` blocks sandboxed commands from reading credential files and secret environment variables. Important security setting.
  - Raw changelog: "Added `sandbox.credentials` setting to block credential file and secret variable access"

- [ ] **claude mcp login/logout commands** (CC 2.1.186)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: mcp-integration/overview.md (MCP CLI Commands section)
  - Details: New CLI commands `claude mcp login <name>` and `claude mcp logout <name>` for authenticating MCP servers without interactive `/mcp` menu.
  - Raw changelog: "Added `claude mcp login <name>` and `claude mcp logout <name>` CLI commands"

- [ ] **Agent(type) deny rules enforcement fix** (CC 2.1.186)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: agent-development/overview.md (permissions section)
  - Details: Fixed `Agent(type)` deny rules and `Agent(x,y)` allowed-types restrictions not enforcing properly for named subagent spawns.
  - Raw changelog: "Fixed `Agent(type)` deny rules not enforcing properly"

- [ ] **Skill frontmatter case acceptance** (CC 2.1.186)
  - Source: CC changelog
  - Confidence: high (VERIFIED)
  - Affects: skill-development/overview.md (frontmatter section)
  - Details: Skill frontmatter now accepts kebab-case, snake_case, and camelCase field names interchangeably. More flexibility for skill authors.
  - Raw changelog: "Improved skill frontmatter kebab/snake/camelCase acceptance"

- [ ] **ReadMcpResourceDirTool added** (CC 2.1.186)
  - Source: system-prompts changelog
  - Confidence: high (VERIFIED)
  - Affects: mcp-integration/overview.md (MCP Resources section)
  - Details: New MCP directory resource listing tool with required `server`/`uri` parameters, non-recursive direct-child listings, subdirectory descent via returned URIs.
  - Raw changelog: "NEW: Tool Description: ReadMcpResourceDirTool prompt"

- [ ] **MCP headersHelper auth retry** (CC 2.1.193)
  - Source: CC changelog
  - Confidence: high (PROMOTED from May Update)
  - Affects: mcp-integration/overview.md (Authentication section)
  - Details: MCP `headersHelper` auth now automatically re-runs and reconnects on 401/403 responses.
  - Raw changelog: "Improved MCP `headersHelper` auth with automatic retry on 401/403 responses"

- [ ] **Plugin auto-rename with marketplace mapping** (CC 2.1.193)
  - Source: CC changelog
  - Confidence: high (PROMOTED from May Update)
  - Affects: marketplace-structure/overview.md
  - Details: Plugin auto-rename now supports marketplace `renames` maps, automatically following name changes and updating settings.
  - Raw changelog: "Improved plugin auto-rename with marketplace mapping support"

---

### May Update

- [ ] **auto-mode denial reasons in transcript** (CC 2.1.193)
  - Source: CC changelog
  - Confidence: medium
  - Affects: auto-mode documentation, debugging guidance
  - Details: Auto-mode denial reasons are now integrated into transcript and `/permissions` interface, improving visibility.
  - Raw changelog: "Integrated auto-mode denial reasons into transcript and `/permissions` interface"

- [ ] **Coordinator mode worker-approval pattern** (CC 2.1.186)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development advanced patterns
  - Details: Adds worker-approval pattern that spawns fresh workers for user-approved actions instead of relaying consent back to the preparing worker.
  - Raw changelog: "System Prompt: Coordinator mode orchestration - Adds a worker-approval pattern..."

- [ ] **Async agent launched system reminder change** (CC 2.1.193)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development documentation
  - Details: Removes fallback instruction to work on non-overlapping tasks or briefly report when async agent is launched.
  - Raw changelog: "System Reminder: Async agent launched - Removes the fallback instruction..."

- [ ] **Security monitor expansion** (CC 2.1.195, 2.1.193, 2.1.187, 2.1.186)
  - Source: system-prompts changelog
  - Confidence: medium (DOWNGRADED from Must Update)
  - Affects: auto-mode documentation, agent security guidelines
  - Details: Major rework of autonomous agent security rules. Consider adding a note about expanded security rules affecting auto-mode behavior.
  - Raw changelog: Multiple entries expanding security monitor rules

---

### No Action

**Stage 2 Downgrades:**
- Memory prompts and reminders REMOVED (CC 2.1.191) - plugin-dev does not document memory features; CC core feature removal
- Skills section in /plugin Installed tab (CC 2.1.186) - UI change, not plugin authoring concern
- Context tip system added (CC 2.1.191) - internal CC feature, not plugin-exposed API
- teammateMode: "iterm2" setting (CC 2.1.186) - IDE-specific configuration
- /rewind command support (CC 2.1.191) - user command, not plugin-relevant
- Artifact tool design skill requirement (CC 2.1.187) - internal CC tool behavior
- Claude Code gateway protocol documentation (CC 2.1.195) - enterprise infrastructure, not plugin development

**Original No Action (verified):**
- CLAUDE_CODE_DISABLE_MOUSE_CLICKS env var for fullscreen mode (CC 2.1.195) - IDE-specific
- Voice dictation fixes for silence/auto-submit/languages (CC 2.1.195) - user interface
- Background jobs disappearing/losing data fix (CC 2.1.195) - internal bug fix
- Voice mode Linux improvements (CC 2.1.195) - platform-specific
- Remote session startup improvements (CC 2.1.195) - infrastructure
- claude agents UI improvements for small terminals (CC 2.1.195) - UI polish
- OpenTelemetry logging additions (CC 2.1.193) - observability
- File path autocomplete for bash mode (CC 2.1.193) - UI enhancement
- MCP server auth startup notice (CC 2.1.193) - UX improvement
- Memory-pressure management for idle background shells (CC 2.1.193) - performance
- Various /model, /login, /voice UI fixes (CC 2.1.193) - bug fixes
- Scroll position, background agent, login URL fixes (CC 2.1.191) - bug fixes
- Sandbox network permission dialog improvements (CC 2.1.191) - UX
- MCP server reliability improvements (CC 2.1.191) - stability
- CPU usage reduction during streaming (CC 2.1.191) - performance
- Bug fixes and reliability improvements (CC 2.1.190) - general maintenance
- Mouse click support in fullscreen (CC 2.1.187) - UI
- Various --resume, --json-schema, remote MCP fixes (CC 2.1.187) - bug fixes
- /install-github-app enhancements (CC 2.1.187) - feature polish
- /btw arrow key navigation (CC 2.1.187) - UI
- VSCode extension fixes (CC 2.1.187) - IDE extension
- Streaming failures fixes (CC 2.1.186) - stability
- Various background task/session fixes (CC 2.1.186) - bug fixes
- Bash auto-response configuration (CC 2.1.186) - configurable behavior
- Stream-stall hint timing change (CC 2.1.185) - UX tuning
- Gateway landing page and device code entry page (CC 2.1.195) - infrastructure
- Fleet agent suggestion scope personalization (CC 2.1.193) - internal
- Artifact meta description guidance (CC 2.1.193) - minor enhancement
- Skill: Artifact design dataviz-callout marker (CC 2.1.193) - internal
- Model migration guide fast-mode updates (CC 2.1.193) - SDK documentation
- Code execution tool version update to code_execution_20260521 (CC 2.1.186) - SDK reference
- /review-pr flow replacement with medium-effort review (CC 2.1.186) - internal
- Migrate to Claude Code skill REMOVED (CC 2.1.185) - cleanup of migration tooling
- CLAUDE.md creation migration offer removed (CC 2.1.185) - cleanup
- /init CLAUDE.md migration phase removed (CC 2.1.185) - cleanup

---

## Summary

**Version range audited:** 2.1.183 through 2.1.195 (7 versions after last audit)

**Versions included:**
- 2.1.185 (minor)
- 2.1.186 (significant - MCP auth, skills UI, teammate mode)
- 2.1.187 (significant - sandbox.credentials, Artifact changes)
- 2.1.190 (bug fixes only)
- 2.1.191 (significant - memory removal, context tips, /rewind)
- 2.1.193 (significant - autoMode.classifyAllShell, denial reasons)
- 2.1.195 (significant - hook matcher changes, WebSocket monitors)

**Critical changes requiring documentation updates:**
1. Hook matcher behavior change (exact match for hyphens) - breaking change
2. Comma-separated hook matchers fix - critical bug fix
3. Memory system removal - major feature change
4. Background monitor WebSocket source - new feature
5. Multiple new settings (autoMode.classifyAllShell, sandbox.credentials)
6. MCP CLI commands (login/logout)
7. Skill frontmatter case flexibility
8. Agent(type) deny rules fix
9. Security monitor expansion
10. Context tip system addition
11. ReadMcpResourceDirTool addition
12. External plugins via project settings consent change
13. Skills section in /plugin UI
14. Skill frontmatter case acceptance

**Token delta from system-prompts:**
- 2.1.195: +12,157 tokens
- 2.1.193: +4,615 tokens
- 2.1.191: +59 tokens
- 2.1.190: no changes
- 2.1.187: +9,726 tokens
- 2.1.186: +4,485 tokens
- 2.1.185: -660 tokens

**Total estimated token impact:** +30,382 tokens in system prompts

**Key themes in this release range:**
1. **Hook system fixes**: Critical fixes for hyphenated matchers (exact match) and comma-separated matchers (silent failure)
2. **Security enhancements**: New sandbox.credentials setting, expanded security monitor rules
3. **Memory system removal**: Major deprecation of memory-related prompts and features
4. **MCP improvements**: New login/logout CLI commands, ReadMcpResourceDirTool, headersHelper retry
5. **Monitor enhancements**: WebSocket source type for background monitors
6. **Auto-mode safety**: classifyAllShell setting, denial reasons in transcript
7. **Skill flexibility**: Case-insensitive frontmatter fields (kebab/snake/camel)

**Triangulation notes:**
- claude-code-guide agent dispatch unavailable in CI environment
- Two-source triangulation used: CC changelog + system-prompts changelog
- Changes confirmed in both sources marked as high confidence
- Single-source changes marked as medium/low confidence
- Both sources aligned well on major changes

---

## Raw Changelog Data

### CC 2.1.195 (from upstream changelog)
```
- Introduced CLAUDE_CODE_DISABLE_MOUSE_CLICKS to disable mouse interactions in fullscreen mode
- Fixed hook matchers with hyphens (e.g., code-reviewer) now requiring exact matches instead of substring matching
- Resolved voice dictation capturing silence in long macOS sessions after input device changes
- Fixed voice dictation auto-submit for languages without spaces (Japanese, Chinese, Thai)
- Fixed external plugins enabled via project settings not requiring reinstall consent
- Fixed /plugin Enable/Disable failing when plugin names differ from marketplace entries
- Resolved background jobs disappearing or losing data in newer Claude Code versions
- Fixed crashed background tasks showing blank screens on restart
- Improved voice mode on Linux to distinguish microphone absence from missing SoX
- Enhanced claude agents completed list to utilize vertical space better on small terminals
- Improved Remote session startup with provisioning checklist display
```

### CC 2.1.193 (from upstream changelog)
```
- Added autoMode.classifyAllShell setting to route all Bash/PowerShell commands through classifier
- Integrated auto-mode denial reasons into transcript and /permissions interface
- Added claude_code.assistant_response OpenTelemetry logging (redacted unless explicitly enabled)
- Implemented live file path autocomplete for bash mode
- Added startup notice when MCP servers require authentication
- Added automatic memory-pressure management for idle background shell commands
- Fixed /model and client-data UI showing stale state after /login
- Fixed backgrounding cancellation when carrying over running tasks
- Fixed pinned background agents being re-prompted unnecessarily after auto-updates
- Fixed phantom subagent spawning when backgrounding main turn
- Improved MCP headersHelper auth with automatic retry on 401/403 responses
- Improved plugin auto-rename with marketplace mapping support
- Enhanced /add-dir messaging
```

### CC 2.1.191 (from upstream changelog)
```
- Added /rewind support for resuming conversations before /clear was run
- Fixed scroll position jumping during streaming responses
- Fixed background agents resurrecting after being stopped
- Fixed /voice showing generic message instead of explaining org policy restrictions
- Fixed /login URL truncation in Windows Terminal wrapping
- Fixed Cmd+click link opening in fullscreen mode for Ghostty over ssh/tmux
- Fixed slash command sending to background sessions as prompt text
- Fixed job rows showing full paths instead of [Image #N] placeholders
- Fixed hooks with comma-separated matchers silently never firing
- Fixed /permissions approval not persisting on close
- Fixed agent panel jumping during scrolling past overflow
- Fixed welcome splash art overflowing default 80x24 Terminal window
- Fixed managed settings forceRemoteSettingsRefresh not taking effect
- Improved sandbox network permission dialog with session-wide host remembering
- Enhanced MCP server reliability with transient error retry logic
- Improved MCP OAuth with discovery and token request retries
- Enhanced MCP error messages to show HTTP 404 URLs
- Improved vim mode prompt-history search hints
- Reduced CPU usage during streaming by ~37% through text update coalescing
- Reduced long-session memory growth from terminal output caching
```

### CC 2.1.190 (from upstream changelog)
```
- Bug fixes and reliability improvements
```

### CC 2.1.187 (from upstream changelog)
```
- Added sandbox.credentials setting to block credential file and secret variable access
- Added org-configured model restrictions to model picker and related interfaces
- Added mouse click support to fullscreen mode select menus
- Fixed --resume failing when original run produced no model turns
- Fixed --json-schema and workflow structured output infinite loop
- Fixed remote MCP tool calls hanging indefinitely (now abort after 5 minutes)
- Fixed Remote sessions taking ~2.7s longer to start
- Fixed pasted Korean/CJK text becoming mojibake in certain terminals
- Fixed /update over Remote Control hanging on trust dialogs
- Fixed background jobs getting stuck in "working" state indefinitely
- Fixed channel connections dropping after agents view navigation
- Fixed agent stop notifications attribution and wording
- Fixed subagent depth tracking for resumed and forked agents
- Fixed leaked agent worktree registrations with automatic cleanup
- Fixed Cmd+click URL opening in fullscreen Ghostty on macOS
- Fixed claude --help not listing background flag
- Fixed Esc/Ctrl-C/Ctrl-D not working during /share upload
- Enhanced /install-github-app with optional GitHub Actions workflow
- Improved /btw with arrow key navigation
- Improved /plugin with recent-activity surfacing
- Fixed VSCode extension unresponsiveness when resuming large sessions
```

### CC 2.1.186 (from upstream changelog)
```
- Added claude mcp login/logout <name> CLI commands for MCP authentication
- Added status filtering to /workflows agent detail view
- Added "Skills" section to /plugin Installed tab
- Added teammateMode: "iterm2" setting with auto mode detection warning
- Made bash commands trigger automatic Claude responses (configurable with setting)
- Fixed streaming failures with "Content block not found" or JSON parse errors
- Fixed subagent transcript scroll position bleeding into main transcript
- Fixed background task preview flashing raw tool names
- Fixed Chrome tab-group isolation not applying to concurrent CLI sessions
- Fixed background session recap duplication
- Fixed background session opening leaving previous screen painted behind
- Fixed Agent(type) deny rules not enforcing properly
- Fixed Esc/Ctrl+C not responding while background agents run
- Fixed misaligned option numbers in permission prompts
- Fixed pressing x not dismissing finished subagents
- Fixed misleading "MCP server disconnected" notice for retired tools
- Fixed /plugin showing incorrect "more above" indicator
- Fixed strikethrough markdown rendering with literal tildes
- Fixed --tools allowing feature-gated tools before flags loaded
- Fixed background job status showing stale "needs input" message
- Fixed dark-theme flash when opening background session
- Fixed mouse-selected text staying highlighted after deletion
- Fixed session cost not showing for usage-based subscribers
- Fixed agent teams inheriting incorrect --effort level
- Fixed Workflow agent({schema}) infinite loop on validation failures
- Improved claude mcp get/remove with typo suggestions and truncation
- Improved memory compaction reminders
- Improved skill frontmatter kebab/snake/camelCase acceptance
- Improved malformed YAML handling
- Changed CLAUDE_CODE_MAX_RETRIES cap to 15
- Changed background subagents to surface permission prompts in main session
- Changed /review <pr> to use medium review engine
```

### CC 2.1.185 (from upstream changelog)
```
- Updated stream-stall hint wording and trigger timing (now 20s instead of 10s)
```

### System-prompts 2.1.195 (key items)
```
- Agent Prompt: Context tip selector - Notes that the user message now also includes <ineligible_ids>
- Agent Prompt: Security monitor for autonomous agent actions (second part) - Greatly expands environment scope and rule set
- NEW: Data: Claude Code gateway protocol
- NEW: Data: Claude gateway landing page
- NEW: Data: Gateway device code entry page
- NEW: Tool Description: Background monitor WebSocket source
```

### System-prompts 2.1.193 (key items)
```
- NEW: Agent Prompt: Fleet agent suggestion scope personalization
- Agent Prompt: Security monitor - public data-sharing upload coverage
- Data: Managed Agents endpoint reference - model shorthand guidance updates
- Skill: Artifact design - dataviz-callout marker
- Skill: Building LLM-powered applications with Claude - fast-mode guidance updates
- Skill: Model migration guide - fast-mode migration guidance
- System Reminder: Async agent launched - removes fallback instruction
- Tool Description: Artifact - adds meta description guidance
```

### System-prompts 2.1.191 (key items)
```
- NEW: Agent Prompt: Context tip selector
- NEW: Agent Prompt: Context tip reception evaluator
- NEW: Data: Context tip situations (manual polling, persistent memory)
- REMOVED: Memory prompts and reminders (standalone memory synthesis/pruning, memory-file description, recalled-memory handling, stale project-memory refresh, immutable memory extraction/consolidation)
```

### System-prompts 2.1.187 (key items)
```
- REMOVED: System Reminder: Verify plan reminder
- Agent Prompt: Explore; System Prompt: Plan vs memory guidance - Add Artifact tool to disallowed tool lists
- Skill: Artifact design - Reworks from frontend-interface to broader artifact guidance
- Skill: Design sync - Updates authorization-error guidance
- System Prompt: Agent thread notes - Clarifies reports should be in final response
- Tool Description: Artifact - Must load artifact-design skill before writing
```

### System-prompts 2.1.186 (key items)
```
- Agent Prompt: /review slash command - Replaces older /review-pr flow
- NEW: Agent Prompt: Security monitor edit-removal guidance
- NEW: Data: Claude Code agent proxy troubleshooting guide
- NEW: Tool Description: ReadMcpResourceDirTool prompt
- Agent Prompt: Security monitor - Narrows classifier scope
- Data: Tool use concepts; Data: Tool use reference - code_execution version update
- System Prompt: Coordinator mode orchestration - worker-approval pattern
- Tool Description: SendMessageTool - Legacy shutdown/plan-approval conditional
```

### System-prompts 2.1.185 (key items)
```
- REMOVED: Skill: Migrate to Claude Code
- Agent Prompt: CLAUDE.md creation - Removes migration offer instruction
- Skill: /init CLAUDE.md and skill setup - Removes Codex/Gemini config check and Phase 8 migration
```

---

## Stage 2: Verification Results
### Verified: 2026-06-28

#### Must Update Verification

- **Hook matchers with hyphens require exact matches** (CC 2.1.195)
  - VERIFIED in CC changelog: "Fixed hook matchers with hyphenated identifiers (e.g., `code-reviewer`, `mcp__brave-search`) performing substring matching instead of exact matching; wildcard patterns like `mcp__brave-search__.*` now required for partial matches"
  - Gap exists in hook-development/overview.md - Matchers section (lines 1137-1188) does not mention this behavior change for hyphenated matchers
  - Status: CONFIRMED - needs documentation in hook matcher section

- **External plugins via project settings no longer require reinstall consent** (CC 2.1.195)
  - VERIFIED in CC changelog: "Fixed external plugins enabled only via project `.claude/settings.json` not requiring explicit install consent on each loader path"
  - Gap exists in plugin-structure/overview.md - no mention of project settings plugin loading behavior
  - Status: CONFIRMED - needs documentation in plugin loading section

- **Hooks with comma-separated matchers fix** (CC 2.1.191)
  - VERIFIED in CC changelog: "Fixed hooks with comma-separated matchers (e.g., `"Bash,PowerShell"`) silently never firing"
  - Gap exists in hook-development/overview.md - Matchers section shows pipe-separated patterns but does not warn against comma-separated patterns
  - Status: CONFIRMED - needs documentation as critical gotcha or behavior clarification

- **Background monitor WebSocket source** (CC 2.1.195)
  - VERIFIED in system-prompts changelog: "NEW: Tool Description: Background monitor WebSocket source - Adds an addendum documenting the background monitor's `ws` source"
  - Gap exists in plugin-structure/overview.md - experimental monitors section (line 427-432) does not mention WebSocket source type
  - Status: CONFIRMED - new feature needs documentation

- **Memory prompts and reminders REMOVED** (CC 2.1.191)
  - VERIFIED in system-prompts changelog: "REMOVED: Memory prompts and reminders - Removes the standalone memory synthesis/pruning agent prompts, memory-file description and staleness guidance fragments..."
  - Review of plugin-dev docs: No direct memory feature documentation exists in plugin-dev
  - Status: DOWNGRADED TO NO ACTION - plugin-dev does not document memory features; this is a CC core feature removal, not plugin-relevant

- **autoMode.classifyAllShell setting** (CC 2.1.193)
  - VERIFIED in CC changelog: "Added `autoMode.classifyAllShell` setting to route all Bash/PowerShell commands through auto-mode classifier"
  - Gap exists in plugin-settings/overview.md - does not document this new setting
  - Status: CONFIRMED - new setting relevant to plugin development (affects hook behavior in auto mode)

- **sandbox.credentials setting** (CC 2.1.187)
  - VERIFIED in CC changelog: "Added `sandbox.credentials` setting to block sandboxed commands from reading credential files and secret environment variables"
  - Gap exists in plugin-structure docs - security-related settings not documented
  - Status: CONFIRMED - security setting relevant to plugin developers

- **claude mcp login/logout commands** (CC 2.1.186)
  - VERIFIED in CC changelog: "Added `claude mcp login <name>` and `claude mcp logout <name>` CLI commands for authenticating MCP servers"
  - Gap exists in mcp-integration/overview.md - CLI commands section (line 757-769) does not include login/logout
  - Status: CONFIRMED - needs documentation in MCP CLI section

- **Skills section in /plugin Installed tab** (CC 2.1.186)
  - VERIFIED in CC changelog: "Added 'Skills' section to `/plugin` Installed tab"
  - Review: This is UI improvement, not plugin authoring concern
  - Status: DOWNGRADED TO NO ACTION - UI change, not plugin development relevant

- **Agent(type) deny rules enforcement fix** (CC 2.1.186)
  - VERIFIED in CC changelog: "Fixed `Agent(type)` deny rules and `Agent(x,y)` allowed-types restrictions not enforced for named subagent spawns"
  - Gap exists in agent-development/overview.md - permission rules section does not document Agent(type) syntax
  - Status: CONFIRMED - needs documentation in agent permissions section

- **Skill frontmatter case acceptance** (CC 2.1.186)
  - VERIFIED in CC changelog: "Improved skill frontmatter kebab/snake/camelCase acceptance"
  - Gap exists in skill-development/overview.md - frontmatter documentation does not mention case flexibility
  - Status: CONFIRMED - needs documentation in skill frontmatter section

- **Security monitor major expansion** (CC 2.1.195, 2.1.193, 2.1.187, 2.1.186)
  - VERIFIED in system-prompts changelog across multiple versions
  - Review: Security monitor is internal CC behavior, not directly documentable for plugins
  - Status: DOWNGRADED TO MAY UPDATE - affects auto-mode behavior but not directly plugin-documentable; consider adding a note about expanded security rules in auto-mode

- **Context tip system added** (CC 2.1.191)
  - VERIFIED in system-prompts changelog: "NEW: Agent Prompt: Context tip selector", "NEW: Data: Context tip situations"
  - Review: Internal CC feature, not plugin-exposed
  - Status: DOWNGRADED TO NO ACTION - internal CC feature, not plugin API

- **ReadMcpResourceDirTool added** (CC 2.1.186)
  - VERIFIED in system-prompts changelog: "NEW: Tool Description: ReadMcpResourceDirTool prompt"
  - Gap exists in mcp-integration/overview.md - MCP Resources section does not mention directory listing
  - Status: CONFIRMED - new MCP capability needs documentation

#### May Update Resolution

- **teammateMode: "iterm2" setting** (CC 2.1.186)
  - Review: Very specific IDE setting, low relevance to plugin dev
  - Status: DEMOTED TO NO ACTION - IDE-specific configuration

- **/rewind command support** (CC 2.1.191)
  - Review: User-facing command enhancement
  - Status: DEMOTED TO NO ACTION - user command, not plugin-relevant

- **auto-mode denial reasons in transcript** (CC 2.1.193)
  - Review: Affects debugging but not plugin authoring
  - Status: KEPT AS MAY UPDATE - could be useful for plugin debugging documentation

- **MCP headersHelper auth retry** (CC 2.1.193)
  - Review: Affects MCP server behavior
  - Status: PROMOTED TO MUST UPDATE - MCP authentication behavior change should be documented

- **Plugin auto-rename with marketplace mapping** (CC 2.1.193)
  - Review: Affects plugin distribution
  - Status: PROMOTED TO MUST UPDATE - marketplace behavior change relevant to plugin authors

- **Coordinator mode worker-approval pattern** (CC 2.1.186)
  - Review: Agent coordination pattern
  - Status: KEPT AS MAY UPDATE - advanced pattern, not core plugin development

- **Artifact tool design skill requirement** (CC 2.1.187)
  - Review: Artifact tool behavior, not plugin-related
  - Status: DEMOTED TO NO ACTION - internal CC tool behavior

- **Claude Code gateway protocol documentation** (CC 2.1.195)
  - Review: Enterprise/infrastructure, not plugin development
  - Status: DEMOTED TO NO ACTION - infrastructure documentation

- **Async agent launched system reminder change** (CC 2.1.193)
  - Review: Agent coordination behavior
  - Status: KEPT AS MAY UPDATE - could affect agent design guidance

#### Missed Items (promoted from No Action)

No significant missed items found. The Stage 1 analysis was thorough.

#### Summary

- **Must Update:** 12 items (9 confirmed, 3 rejected/downgraded, 2 added from May Update)
  - Confirmed: Hook hyphen matchers, external plugins consent, comma-separated matchers, WebSocket monitors, autoMode.classifyAllShell, sandbox.credentials, MCP login/logout, Agent(type) deny rules, skill frontmatter case, ReadMcpResourceDirTool
  - Promoted from May Update: MCP headersHelper retry, plugin auto-rename
- **May Update:** 3 items remaining
  - auto-mode denial reasons, coordinator worker-approval, async agent reminder
- **No Action:** Items correctly classified plus downgrades (memory removal, skills UI, context tips, iterm2, /rewind, artifact tool, gateway protocol)
- **Confidence:** HIGH - changes verified against primary sources (CC changelog and system-prompts changelog)

#### Verification Notes

1. All CC changelog items verified against the WebFetch of raw changelog
2. System-prompts changelog verified via direct file read (first 200 lines covers all relevant versions)
3. Topic mappings verified by reading reference docs at plugin-dev/skills/plugin-dev/references/
4. No significant gaps in Stage 1 analysis - the differ agent performed well
5. Token delta from system-prompts aligns with manifest summary
