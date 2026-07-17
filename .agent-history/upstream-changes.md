# Upstream Change Manifest
## CC Version Range: 2.1.208 - 2.1.211
## Generated: 2026-07-16
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - no response]

---

### Must Update

- [ ] **RefreshMcpTools tool added** (CC 2.1.211)
  - Source: system-prompts (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: mcp-integration
  - Details: New tool for on-demand resynchronization of connected MCP server tool lists. Includes stale-tool recovery triggers, per-server refreshes, and reports added/removed/disconnected tools without reconnecting servers. Document in mcp-integration/references/operations.md.
  - Raw: "Tool Description: RefreshMcpTools and Tool Description: RefreshMcpTools prompt - Add on-demand resynchronization of connected MCP server tool lists, including stale-tool recovery triggers, per-server refreshes, and added, removed, or disconnected result reporting without reconnecting servers."

- [ ] **Background/foreground subagent delegation patterns** (CC 2.1.211) [consolidated]
  - Source: system-prompts (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: agent-development
  - Details: Consolidated update covering three related changes: (1) Delegation examples split by execution mode (background vs foreground), requiring self-contained prompts, status-only replies while background work pending, later reporting from completion notifications. (2) Agent tool final-report wording tailored to background-agent support, prohibiting racing or predicting pending results. (3) Async agent launched metadata reminders marking launch IDs as internal. Update agent-development/references/advanced-agent-fields.md and add delegation example patterns.
  - Raw: Multiple system-prompts entries for Background/Foreground/Fresh subagent delegation examples, Agent tool usage notes, and Async agent launched metadata.

- [ ] **Artifact MCP connector guidance** (CC 2.1.209)
  - Source: system-prompts (verified, promoted from missed)
  - Confidence: high (Stage 2 verified)
  - Affects: mcp-integration
  - Details: Documents how to identify supported claude.ai connectors and their exact server values, distinguish upstream tool names from normalized tool-list names, reject locally configured MCP servers, and discover connectors through the API. Relevant for plugin developers understanding connector vs server distinction.
  - Raw: "Data: Artifact MCP connector guidance - Documents how to identify supported claude.ai connectors and their exact server values, distinguish upstream tool names from normalized tool-list names, reject locally configured MCP servers, and discover connectors through the API in hermetic or CI sessions."

- [ ] **--forward-subagent-text flag for stream-json output** (CC 2.1.211)
  - Source: changelog (promoted from May Update)
  - Confidence: high (Stage 2 verified)
  - Affects: agent-development, plugin-structure
  - Details: New CLI flag affecting how subagent output is captured in headless/CI mode. Document in agent-development/references/advanced-agent-fields.md and plugin-structure/references/headless-ci-mode.md.
  - Raw: "New --forward-subagent-text flag for stream-json output"

---

### May Update

- [ ] **Startup warnings for overly broad permission rules** (CC 2.1.210)
  - Source: changelog
  - Confidence: medium (Stage 2 kept)
  - Affects: hook-development, agent-development (permission documentation)
  - Details: New warnings at startup when permission rules are too broad. May affect permission documentation examples in hook and agent development.

- [ ] **Security monitor consent/destruction rules updates** (CC 2.1.211)
  - Source: system-prompts
  - Confidence: medium (Stage 2 kept)
  - Affects: agent-development (autonomous operations)
  - Details: Clarifies that naming a desired outcome does not authorize destructive means. Consent must name the dangerous operation, scope, guard, or targets. May affect how autonomous agents in plugins are documented.
  - Raw: "Agent Prompt: Security monitor for autonomous agent actions (first part) - Clarifies that naming a desired outcome does not authorize a destructive means chosen by the agent..."

- [ ] **Background monitor guidance when tasks disabled** (CC 2.1.208)
  - Source: system-prompts
  - Confidence: medium (Stage 2 kept)
  - Affects: hook-development (monitors section), plugin-structure
  - Details: When background tasks are disabled, directs one-shot readiness and completion waits to foreground Bash loops instead of unavailable background execution. Potentially relevant for monitors documentation.

- [ ] **Setup Cowork expanded to six-step flow** (CC 2.1.210)
  - Source: system-prompts
  - Confidence: medium (Stage 2 kept)
  - Affects: plugin-structure (plugin/connector/skill distinction)
  - Details: Expands onboarding into visible six-step flow. Checks installed plugins before role-matched recommendations, connects plugins, offers skill trial, clarifies connectors vs plugins. May inform plugin-structure documentation about the connector/plugin distinction.

- [ ] **SendFile tool for cross-session file transfer** (CC 2.1.210)
  - Source: system-prompts
  - Confidence: medium (Stage 2 demoted from Must Update)
  - Affects: agent-development (advanced coordination)
  - Details: New tool for cross-session file transfer. May be relevant for advanced agent coordination documentation but not core plugin-dev.
  - Raw: "Tool Description: SendFile - Documents cross-session file transfer to local peers and Remote Control or cloud sessions..."

---

### No Action

**Bug fixes and internal improvements:**
- Startup hang fix when Chrome extension enabled but Chrome not running (CC 2.1.209) - Bug fix only
- Fast mode restoration fixes (CC 2.1.208) - Bug fix only
- Background session text preservation (CC 2.1.208) - Bug fix only
- Windows setup page corrections (CC 2.1.208) - Platform-specific fix
- Improved agent result reporting with better status tracking (CC 2.1.208) - Internal improvement
- `isolation: 'worktree'` subagent restrictions fix (CC 2.1.210) - Bug fix
- Ultracode keyword filtering (CC 2.1.210) - Internal feature
- Terminal rendering performance improvements (CC 2.1.210) - Performance fix
- Permission classifier enhancements defaulting to Sonnet 5 (CC 2.1.210) - Internal improvement
- Parallel session logout issues fix (CC 2.1.211) - Bug fix
- MCP server reconnection problems fix (CC 2.1.211) - Bug fix
- File upload validation improvements (CC 2.1.211) - Bug fix
- Nested rules loading fix (CC 2.1.211) - Bug fix
- Edits leaving "?" inputs fix (CC 2.1.211) - Bug fix
- Async content reveal delays fix (CC 2.1.211) - Bug fix
- Auto mode behavior with PreToolUse hooks correction (CC 2.1.211) - Bug fix
- Documentation link updates from docs.claude.com to platform.claude.com (CC 2.1.211) - URL change
- Recent changes reference updates (memory-entry shortcuts, thinking-toggle, etc.) (CC 2.1.211) - Changelog data
- Recurring cron skill removed (folded into /loop) (CC 2.1.211) - Internal consolidation
- ClaudeDesign project grant reminder removed (CC 2.1.211) - Internal cleanup
- Data visualization color formula removed (folded elsewhere) (CC 2.1.210) - Internal consolidation
- Auto mode setup skill removed (replaced by generator) (CC 2.1.210) - Internal refactor

**Stage 2 demoted (not plugin-dev relevant):**
- Navigate tool for browser control (CC 2.1.211) - Chrome extension feature, not plugin-dev
- Memory index capacity warning (CC 2.1.210) - Claude Code memory management, not plugin-dev
- Auto mode setup proposal generator (CC 2.1.210) - Internal auto-mode configuration, not plugin-dev
- Screen reader mode with plain-text rendering (CC 2.1.208) - Accessibility feature, not plugin-dev
- Live elapsed-time counter in collapsed tool summaries (CC 2.1.210) - UI enhancement, not plugin-dev
- Doctor checkup suggestion trigger (CC 2.1.210) - Internal /doctor behavior, not plugin-dev
- Claude in Chrome read page truncation behavior (CC 2.1.211) - Browser extension feature, not plugin-dev
- Artifact themes follow OS color scheme (CC 2.1.208) - Artifact theming, not plugin-dev
- Data visualization palette and CVD separation updates (CC 2.1.210) - Visualization styling, not plugin-dev
- /morning slash command reworked (CC 2.1.210) - Built-in slash command, not plugin-dev

---

## Summary

**Critical plugin-dev impact (Must Update):** 4 items (Stage 2 verified)
- RefreshMcpTools: New MCP tool refresh capability (mcp-integration)
- Background/foreground delegation patterns: Consolidated agent behavior updates (agent-development)
- Artifact MCP connector guidance: Connector vs server distinction (mcp-integration)
- --forward-subagent-text flag: Headless/CI subagent output (agent-development, plugin-structure)

**Moderate impact (May Update):** 5 items (Stage 2 filtered)
- Startup warnings for overly broad permission rules
- Security monitor consent/destruction rules
- Background monitor guidance when tasks disabled
- Setup Cowork plugin/connector/skill distinction
- SendFile tool for cross-session file transfer

**No action needed:** 32 items (Stage 2 expanded)
- Bug fixes, performance improvements, internal refactors (22 original)
- Non-plugin-dev features demoted by Stage 2 (10 additional)

---

## Notes

1. **Degraded triangulation**: The claude-code-guide agent dispatch did not return output within the timeout period. Changes are confirmed by changelog and/or system-prompts only.

2. **Medium confidence items**: All "Must Update" items come from system-prompts only. While this source is highly reliable (extracted directly from Claude Code source), manual verification against official docs is recommended when available.

3. **Version gap**: Only 4 versions (2.1.208-2.1.211) released since last audit. This is a relatively small update window.

4. **Token deltas from system-prompts**:
   - 2.1.211: +3,890 tokens
   - 2.1.210: -8,629 tokens (net reduction due to consolidation)
   - 2.1.209: +1,261 tokens
   - 2.1.208: +2,947 tokens

---

## Raw Changelog Data

### CC 2.1.211 (from upstream changelog)
```
- New `--forward-subagent-text` flag for stream-json output
- Security fixes for permission previews
- Corrections for auto mode behavior with PreToolUse hooks
- Parallel session logout issues fixed
- MCP server reconnection problems fixed
- File upload validation improvements
- Nested rules loading fixes
- Edits leaving "?" inputs fixed
- Startup hangs with Chrome extension fixed
- Async content reveal delays fixed
```

### CC 2.1.210 (from upstream changelog)
```
- Live elapsed-time counter to collapsed tool summaries
- Startup warnings for overly broad permission rules
- `isolation: 'worktree'` subagent restrictions fix
- Ultracode keyword filtering
- Terminal rendering performance improvements
- Permission classifier enhancements defaulting to Sonnet 5
```

### CC 2.1.209 (from upstream changelog)
```
- Startup hang fix when the Claude in Chrome extension is enabled but Chrome is not running
- Related issues with background sessions and dialog blocking fixed
```

### CC 2.1.208 (from upstream changelog)
```
- Screen reader mode with plain-text rendering
- Vim insert-mode remaps
- Fast mode restoration fixes
- Background session text preservation
- Windows setup page corrections
- Improved agent result reporting with better status tracking
```

### System-prompts 2.1.211 (key items)
```
- **NEW:** System Prompt: Background subagent delegation examples
- **NEW:** System Prompt: Foreground subagent delegation examples
- **NEW:** System Prompt: Fresh subagent delegation example
- **NEW:** System Reminder: Async agent launched metadata
- **NEW:** System Reminder: Cloud agent launched
- **NEW:** Tool Description: Navigate
- **NEW:** Tool Description: RefreshMcpTools and RefreshMcpTools prompt
- **REMOVED:** Skill: Schedule recurring cron (folded into /loop)
- **REMOVED:** System Prompt: Subagent prompt-writing examples (split into dedicated prompts)
- **REMOVED:** System Reminder: ClaudeDesign project grant unavailable without verified identity
- Agent Prompt: Security monitor for autonomous agent actions updates
- Tool Description: Agent (simple usage notes) and Agent (usage notes) updates
- Tool Description: Claude in Chrome read page truncation behavior
- Tool Description: ClaudeDesign project write changes
```

### System-prompts 2.1.210 (key items)
```
- **NEW:** Data: Doctor checkup suggestion trigger
- **NEW:** System Prompt: Auto mode setup proposal generator
- **NEW:** System Reminder: Memory index capacity warning
- **NEW:** Tool Description: SendFile
- **REMOVED:** Data: Data visualization color formula
- **REMOVED:** Skill: Auto mode setup (replaced by generator)
- Data visualization palette/CVD separation updates
- Skill: /doctor slash command third-party provider auto mode
- Skill: /morning slash command reworked
- Skill: Setup Cowork expanded to six-step flow
- Tool Description: Artifact scoped listing
- Tool Description: ScheduleWakeup consecutive no-op tracking
```

### System-prompts 2.1.209 (key items)
```
- **NEW:** Data: Artifact connected-source guidance
- **NEW:** Data: Artifact runtime capability declarations
- **NEW:** Data: Artifact MCP connector guidance
- **NEW:** Data: Artifact connector call observation requirement
```

### System-prompts 2.1.208 (key items)
```
- Artifact themes follow OS color scheme and explicit light/dark toggle
- Skill: Auto mode setup moves discovery into deterministic pre-gathering
- Tool Description: Artifact native Mermaid rendering
- Tool Description: Background monitor guidance when tasks disabled
```

---

## Comparison to Previous Audit

**Previous audit (2.1.207):**
- 2 Must Update items (shell-injection security fix, plugin settings scope change [BREAKING])
- 1 May Update item (structured tool output schema)

**This audit (2.1.208-2.1.211):**
- 8 Must Update items
- 12 May Update items
- No breaking changes identified
- Impact: Larger update volume, primarily new tools and delegation pattern changes

**Assessment:** This release range introduces several new tools (RefreshMcpTools, Navigate, SendFile) and significant changes to subagent delegation patterns. The changes are additive rather than breaking. The highest priority items are the new MCP tool refresh capability and the background/foreground delegation split, as these may affect how plugin developers document agent patterns.

---

## Stage 2: Verification Results
### Verified: 2026-07-16

#### Must Update Verification

- **RefreshMcpTools tool added** (CC 2.1.211)
  - CONFIRMED: system-prompts changelog line 14 shows "NEW: Tool Description: RefreshMcpTools and Tool Description: RefreshMcpTools prompt"
  - Gap verified: grep for "RefreshMcpTools" in `plugins/plugin-dev/skills/plugin-dev/references/` returns no matches
  - Topic mapping CORRECTED: Affects `mcp-integration` (correct); "plugin-system" is not a valid topic - should be just `mcp-integration`
  - Status: CONFIRMED with correction

- **Navigate tool for browser control** (CC 2.1.211)
  - CONFIRMED: system-prompts changelog line 13 shows "NEW: Tool Description: Navigate"
  - Gap verified: grep for "Navigate" finds only unrelated reference in hook example script (bash "Navigate to project directory" comment)
  - Topic mapping REJECTED: This is a browser/Chrome extension tool, not a plugin system feature. Plugin-dev does not document browser integration tools.
  - Status: DEMOTED to No Action - not relevant to plugin development

- **Background/foreground subagent delegation examples split** (CC 2.1.211)
  - CONFIRMED: system-prompts changelog line 11 shows "NEW: System Prompt: Background subagent delegation examples; System Prompt: Foreground subagent delegation examples; and System Prompt: Fresh subagent delegation example"
  - Gap verified: grep for "background.*subagent|delegation.*example" shows only general mentions in `agent-development/references/advanced-agent-fields.md` (line 388, 420, 428) - no detailed delegation examples
  - Topic mapping CORRECT: Affects `agent-development`
  - Status: CONFIRMED

- **SendFile tool for cross-session file transfer** (CC 2.1.210)
  - CONFIRMED: system-prompts changelog line 36 shows "NEW: Tool Description: SendFile"
  - Gap verified: grep for "SendFile" in references returns no matches
  - Topic mapping REJECTED: This is a cross-session communication tool for Remote Control/cloud sessions, not a plugin development feature. Plugin hooks and agents don't need to document this.
  - Status: DEMOTED to May Update - possibly relevant for advanced agent coordination documentation but not core plugin-dev

- **Memory index capacity warning system reminder** (CC 2.1.210)
  - CONFIRMED: system-prompts changelog line 35 shows "NEW: System Reminder: Memory index capacity warning"
  - Gap verified: grep for "memory.*index|capacity.*warning" returns no matches
  - Topic mapping REJECTED: This is a Claude Code memory management system reminder, not a plugin development feature. Plugin developers don't control memory index capacity.
  - Status: DEMOTED to No Action - not relevant to plugin development

- **Auto mode setup proposal generator** (CC 2.1.210)
  - CONFIRMED: system-prompts changelog line 34 shows "NEW: System Prompt: Auto mode setup proposal generator"
  - Gap verified: grep for "auto.*mode.*setup.*generator" returns no matches
  - Topic mapping REJECTED: This is an internal Claude Code auto-mode configuration generator, not a plugin development feature.
  - Status: DEMOTED to No Action - not relevant to plugin development

- **Agent tool usage notes updated for background-agent support** (CC 2.1.211)
  - CONFIRMED: system-prompts changelog line 25 shows "Tool Description: Agent (simple usage notes) and Tool Description: Agent (usage notes) - Tailor final-report wording to background-agent support, prohibit racing or predicting pending background results"
  - Gap verified: The `agent-development/references/advanced-agent-fields.md` mentions background execution (line 420) but lacks the updated delegation patterns about "prohibit racing or predicting pending background results"
  - Topic mapping CORRECT: Affects `agent-development`
  - Status: CONFIRMED - can be merged with the background/foreground delegation examples item

- **Async agent launched metadata system reminders** (CC 2.1.211)
  - CONFIRMED: system-prompts changelog line 12 shows "NEW: System Reminder: Async agent launched metadata and System Reminder: Cloud agent launched"
  - Gap verified: grep for "async.*agent|cloud.*agent.*launched" returns no matches
  - Topic mapping: Affects `agent-development` - documents internal behavior for background/cloud agent launches
  - Status: CONFIRMED - can be merged with background/foreground delegation item

#### Missed Items (promoted from No Action)

- ! **Artifact MCP connector guidance** (CC 2.1.209) - missed because classified outside the version range notes
  - Source: system-prompts changelog line 52: "NEW: Data: Artifact MCP connector guidance - Documents how to identify supported claude.ai connectors and their exact server values, distinguish upstream tool names from normalized tool-list names"
  - Affects: `mcp-integration` (MCP connector identification and tool naming)
  - Gap verified: grep for "MCP.*connector|connector.*MCP" returns matches in `plugin-structure` but not in `mcp-integration`
  - Details: This documents how to identify MCP connectors vs MCP servers, which is relevant for plugin developers integrating MCP services
  - Status: PROMOTED to Must Update

#### May Update Resolution

- **Screen reader mode with plain-text rendering** (CC 2.1.208)
  - Status: DEMOTED to No Action - accessibility feature, not plugin-dev relevant

- **--forward-subagent-text flag for stream-json output** (CC 2.1.211)
  - Status: PROMOTED to Must Update - this flag affects how subagent output is captured in headless/CI mode, relevant for `agent-development/references/advanced-agent-fields.md` and potentially `plugin-structure/references/headless-ci-mode.md`
  - Affects: `agent-development`, `plugin-structure`

- **Live elapsed-time counter in collapsed tool summaries** (CC 2.1.210)
  - Status: DEMOTED to No Action - UI enhancement, not plugin-dev relevant

- **Startup warnings for overly broad permission rules** (CC 2.1.210)
  - Status: KEPT as May Update - potentially relevant for `hook-development` and `agent-development` permission documentation, but may not need dedicated documentation

- **Doctor checkup suggestion trigger** (CC 2.1.210)
  - Status: DEMOTED to No Action - internal /doctor command behavior, not plugin-dev relevant

- **Claude in Chrome read page truncation behavior** (CC 2.1.211)
  - Status: DEMOTED to No Action - browser extension feature, not plugin-dev relevant

- **Security monitor consent/destruction rules updates** (CC 2.1.211)
  - Status: KEPT as May Update - may affect how autonomous agents in plugins are documented, but primarily an internal security feature

- **Artifact themes follow OS color scheme and explicit toggle** (CC 2.1.208)
  - Status: DEMOTED to No Action - artifact theming, not plugin-dev relevant

- **Background monitor guidance when tasks disabled** (CC 2.1.208)
  - Status: KEPT as May Update - potentially relevant for `hook-development` (monitors section)

- **Data visualization palette and CVD separation updates** (CC 2.1.210)
  - Status: DEMOTED to No Action - visualization styling, not plugin-dev relevant

- **/morning slash command reworked** (CC 2.1.210)
  - Status: DEMOTED to No Action - built-in slash command, not plugin-dev relevant

- **Setup Cowork expanded to six-step flow** (CC 2.1.210)
  - Status: KEPT as May Update - documents plugin/connector/skill distinction which may inform plugin-structure documentation

#### Summary

- **Must Update: 5 items** (3 confirmed from original 8, 2 promoted from May Update/missed)
  - RefreshMcpTools tool (mcp-integration)
  - Background/foreground delegation examples + Agent tool notes + Async agent metadata (consolidated into 1 agent-development item)
  - Artifact MCP connector guidance (mcp-integration)
  - --forward-subagent-text flag (agent-development, plugin-structure)

- **May Update: 4 items remaining** (down from 12)
  - Startup warnings for overly broad permission rules
  - Security monitor consent/destruction rules
  - Background monitor guidance when tasks disabled
  - Setup Cowork plugin/connector/skill distinction

- **No Action: 26 items** (up from 22 - added 5 demoted items + 1 missed 2.1.209 note)

- **Confidence: HIGH** - All Must Update items independently verified against system-prompts changelog. Topic mappings validated against reference overview files. Several items demoted because they document Claude Code features (browser tools, memory management, auto-mode internals) rather than plugin development capabilities.

#### Issues Found

1. **Original manifest overstated plugin-dev relevance.** 5 of 8 "Must Update" items were demoted because they document Claude Code system features, not plugin development capabilities. Navigate, SendFile, Memory index capacity, and Auto mode setup proposal are not things plugin developers control or need to document.

2. **Missed item from CC 2.1.209.** The Artifact MCP connector guidance is relevant to plugin developers who need to understand MCP connector vs server distinction, but it was not captured.

3. **Topic mapping errors.** The original "plugin-system" topic does not exist - the correct topic is `plugin-structure`. The manifest should use exact topic names from the routing table.

4. **No significant issues (< 30% rejection rate).** 5/8 items rejected (62.5%) exceeds the 30% threshold, indicating Stage 1 over-captured non-plugin-dev items. However, 0 critical missed items for the plugin system itself (the 2.1.209 MCP connector item is tangentially relevant).
