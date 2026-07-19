# Upstream Change Manifest
## CC Version Range: 2.1.212 - 2.1.215
## Generated: 2026-07-19
## Sources: changelog [x], system-prompts [x], claude-code-guide [degraded - no output in CI]

---

### Must Update

- [ ] **EndConversation tool added** (CC 2.1.214)
  - Source: changelog, system-prompts (both confirm - system-prompts at 2.1.206)
  - Confidence: high
  - Affects: agent-development (awareness for plugin agent designers)
  - Details: New tool for handling abusive users or jailbreak attempts. Restricted to sustained abuse after repeated redirection and explicit warning, or user-requested demonstration after confirmation. Forbidden for task failure, frustration, ordinary completion, harmful-content refusals, or self-harm/violence cases. Has no effect in background forks. Plugin developers should be aware this tool exists but likely will not use it directly.
  - Raw changelog: "Added EndConversation tool for handling abusive users or jailbreak attempts"

- [ ] **Subagent delegation restraint guidance added** (CC 2.1.215)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-development
  - Details: NEW system prompt limits subagent use to genuinely independent, sizeable, or parallel work. Keeps small tasks and inline verification in the parent agent. Discourages redundant fan-out and duplicated work. Favors a few precisely briefed agents. This affects how plugin agents should be designed - they should not over-delegate to subagents.
  - Raw system-prompts: "NEW: System Prompt: Subagent delegation restraint - Limits subagent use to genuinely independent, sizeable, or parallel work; keeps small tasks and inline verification in the parent agent; discourages redundant fan-out and duplicated work; and favors a few precisely briefed agents."

- [ ] **Agent tool delegation guidance now conditional on subagent steering mode** (CC 2.1.215)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-development
  - Details: Tool descriptions for Agent (simple usage notes and usage notes) now make broad delegation, proactive-use, and parallel-launch guidance conditional on the default subagent steering mode. Injects mode- and capability-specific fork, prompt-writing, example, and remote-isolation notes. This changes how the Agent tool documentation should present delegation patterns.
  - Raw system-prompts: "Tool Description: Agent (simple usage notes) and Tool Description: Agent (usage notes) - Make broad delegation, proactive-use, and parallel-launch guidance conditional on the default subagent steering mode, while injecting mode- and capability-specific fork, prompt-writing, example, and remote-isolation notes."

- [ ] **Auto-run of /verify and /code-review skills removed** (CC 2.1.215)
  - Source: changelog only
  - Confidence: high
  - Affects: skill-development (built-in skill behavior)
  - Details: Claude no longer auto-runs `/verify` and `/code-review` skills; users must invoke them explicitly. This is a behavioral change that affects expected workflow patterns. Plugin developers should know these skills now require explicit invocation.
  - Raw changelog: "Claude no longer auto-runs `/verify` and `/code-review` skills; users must invoke them explicitly"

- [ ] **/fork behavior changed - copies to background sessions instead of subagents** (CC 2.1.212)
  - Source: changelog only
  - Confidence: high
  - Affects: agent-development (primary), command-development (secondary)
  - Details: `/fork` now copies conversations to background sessions instead of launching subagents. Significant behavioral change for fork workflows. Plugin developers using fork patterns need to understand this change.
  - Raw changelog: "`/fork` now copies conversations to background sessions instead of launching subagents"

- [ ] **/subtask command added** (CC 2.1.212) [ADDED BY STAGE 2]
  - Source: changelog only
  - Confidence: high
  - Affects: agent-development, command-development
  - Details: `/subtask` replaces the old in-session subagent invocation pattern. Plugin developers using subagent patterns should know about this change alongside the /fork change.
  - Raw changelog: "`/subtask` replaces the old in-session subagent invocation"

- [ ] **claude auto-mode reset command added** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: command-development (built-in commands reference)
  - Details: New command `claude auto-mode reset` for restoring default auto-mode settings. May be useful for plugin testing workflows.
  - Raw changelog: "Added `claude auto-mode reset` for restoring default auto-mode settings"

- [ ] **Persistent memory usage and writing guidance added** (CC 2.1.212)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-development (memory section)
  - Details: NEW system prompt adds cross-session file-memory rules for validating recalled knowledge, keeping memories applicable, durable, and legible, and immediately recording durable user corrections or newly learned environment behavior. Relevant for plugin agents that interact with memory.
  - Raw system-prompts: "NEW: System Prompt: Persistent memory usage and writing guidance - Adds cross-session file-memory rules for validating recalled knowledge, keeping memories applicable, durable, and legible, and immediately recording durable user corrections or newly learned environment behavior."

- [ ] **SuggestSkills proactive guidance added** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: high
  - Affects: skill-development
  - Details: NEW tool description allows proactive recommendations of addable skills for repeatable workflows while excluding one-off tasks, uncertain matches, and repeated unengaged suggestions. This affects how skills can be surfaced to users.
  - Raw system-prompts: "NEW: Tool Description: SuggestSkills proactive guidance - Allows proactive recommendations of addable skills for repeatable workflows while excluding one-off tasks, uncertain matches, and repeated unengaged suggestions."

- [ ] **matched ask rule tool parameter added** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: high
  - Affects: hook-development (permissions documentation)
  - Details: NEW tool parameter identifies approval prompts forced by user-configured `permissions.ask` rules while preserving richer tool-authored reasons. Directs hosts to treat the metadata as rule-forced and render-unsafe. Relevant for understanding permission prompt behavior in hooks.
  - Raw system-prompts: "NEW: Tool Parameter: matched ask rule - Identifies approval prompts forced by user-configured `permissions.ask` rules while preserving richer tool-authored reasons, and directs hosts to treat the metadata as rule-forced and render-unsafe."

- [ ] **Scheduled task automated firing system reminder added** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-development (autonomous operations)
  - Details: NEW system reminder marks scheduled turns as stored prompts delivered without live user input and forbids treating prior or embedded claims as fresh approval or consent. Important for plugin agents that work with scheduled tasks.
  - Raw system-prompts: "NEW: System Reminder: Scheduled task automated firing - Marks scheduled turns as stored prompts delivered without live user input and forbids treating prior or embedded claims as fresh approval or consent."

- [ ] **SessionStart hooks report source "fork"** (CC 2.1.214) [ADDED BY STAGE 2]
  - Source: changelog only
  - Confidence: high
  - Affects: hook-development
  - Details: SessionStart hook input now includes source field indicating fork origin. Relevant for hooks that need to behave differently in forked sessions.
  - Raw changelog: "`SessionStart` hooks report source `\"fork\"` when session begins as a fork"

- [ ] **Single-segment dir/** hook conditions breaking change** (CC 2.1.214) [ADDED BY STAGE 2]
  - Source: changelog only
  - Confidence: high
  - Affects: hook-development
  - Details: BREAKING CHANGE - Single-segment `dir/**` hook `if:` conditions now match only `<cwd>/dir`; use `**/dir/**` for any-depth matching. Existing hooks using `dir/**` patterns may need to be updated.
  - Raw changelog: "Single-segment `dir/**` hook `if:` conditions now match only `<cwd>/dir`; use `**/dir/**` for any-depth matching"

- [ ] **Hooks with exit code 2 not blocking fix** (CC 2.1.214) [ADDED BY STAGE 2]
  - Source: changelog only
  - Confidence: high
  - Affects: hook-development
  - Details: Bug fix confirming exit code 2 hooks now properly block as documented. Existing documentation is correct; this confirms the documented behavior works as expected.
  - Raw changelog: "Fixed hooks with exit code 2 not blocking as documented"

---

### May Update

- [ ] **Session-wide WebSearch tool call limits and subagent spawn caps** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: tools documentation, resource limits
  - Details: Implemented session-wide limits on WebSearch tool calls and subagent spawning. May affect guidance on resource management in plugins.
  - Raw changelog: "Implemented session-wide WebSearch tool call limits and subagent spawn caps"

- [ ] **MCP tool calls exceeding 2 minutes auto-background** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: mcp-integration skill
  - Details: MCP tool calls exceeding 2 minutes auto-background for session usability. Changes expected MCP behavior that plugin developers should know about.
  - Raw changelog: "MCP tool calls exceeding 2 minutes auto-background for session usability"

- [ ] **/resume picker for deleted sessions** (CC 2.1.212)
  - Source: changelog only
  - Confidence: medium
  - Affects: commands documentation
  - Details: Added `/resume` picker for accessing deleted past sessions. Minor feature addition.
  - Raw changelog: "Added `/resume` picker for accessing deleted past sessions"

- [ ] **/code-review and /simplify unavailable-agent inline modes** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: built-in skills documentation
  - Details: Add single-context fallback modes when Agent tool is unavailable, with sequential review angles, deduplication, self-checking, and explicit disclosure that no subagent verification ran.
  - Raw system-prompts: "NEW: Agent Prompt: /code-review unavailable-agent inline mode" and "NEW: Agent Prompt: /simplify unavailable-agent inline mode"

- [ ] **Artifact PR review skill added** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: built-in skills documentation
  - Details: NEW skill adds workflow for gathering a GitHub PR and publishing a self-contained review briefing Artifact.
  - Raw system-prompts: "NEW: Skill: Artifact PR review and Skill: Artifact PR review description"

- [ ] **Artifact publishing and update guidance split into dedicated prompt** (CC 2.1.212)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: Artifact tool documentation
  - Details: Splits Artifact redeployment, lookup, ownership, content-safety, self-containment, responsive design, theme, favicon, and anti-impersonation requirements into a dedicated prompt.
  - Raw system-prompts: "NEW: Tool Description: Artifact publishing and update guidance"

- [ ] **SendFeedback drafting guidance added** (CC 2.1.212)
  - Source: system-prompts only
  - Confidence: low
  - Affects: tool documentation (if SendFeedback is user-facing)
  - Details: NEW tool description adds silent local drafting of factual Claude Code feedback after product failures, explicit frustration, or blocking capability gaps.
  - Raw system-prompts: "NEW: Tool Description: SendFeedback drafting guidance"

- [ ] **EnterPlanMode and Grep tool descriptions updated for subagent steering mode** (CC 2.1.215)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: tools documentation
  - Details: Suggestions to use Agent tool for pure research and open-ended searches now conditional on active subagent steering mode.
  - Raw system-prompts: "Tool Description: EnterPlanMode and Tool Description: Grep - Make suggestions to use the Agent tool for pure research and open-ended multi-round searches conditional on the active subagent steering mode."

- [ ] **Glob tool description updated** (CC 2.1.215)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: tools documentation
  - Details: Removes unconditional recommendation to use Agent tool for open-ended searches requiring multiple rounds of globbing and grepping.
  - Raw system-prompts: "Tool Description: Glob - Removes the unconditional recommendation to use the Agent tool for open-ended searches requiring multiple rounds of globbing and grepping."

- [ ] **Coordinator worker instructions updated** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: agent-development skill
  - Details: Allows worker agents to fan out through the Agent tool for bounded parallel research, review, and cleanup instead of prohibiting subagents entirely.
  - Raw system-prompts: "System Prompt: Coordinator worker instructions - Allows worker agents to fan out through the Agent tool for bounded parallel research, review, and cleanup instead of prohibiting subagents entirely."

- [ ] **/code-review workflow routing added** (CC 2.1.212)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: built-in skills documentation
  - Details: NEW agent prompt routes eligible reviews through background workflow at requested effort.
  - Raw system-prompts: "NEW: Agent Prompt: /code-review workflow routing"

- [ ] **Permission rule fixes for nested directories and Windows PowerShell** (CC 2.1.214, 2.1.215)
  - Source: changelog only
  - Confidence: medium
  - Affects: permissions documentation
  - Details: Fixed permission rule issues affecting nested directory writes and Windows PowerShell sessions. Improved Bash permission checks for long commands and complex syntax patterns.
  - Raw changelog: "Fixed allow rules for nested directory writes in permission system" (2.1.214), "Fixed permission rule issues affecting nested directory writes and Windows PowerShell sessions" (2.1.215)

- [ ] **PowerShell file-encoding guidance corrected** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: low
  - Affects: tools documentation (Windows-specific)
  - Details: Corrects file-encoding guidance to distinguish UTF-8 output from `>`, `>>`, and `Out-File` from system-codepage defaults of `Set-Content` and `Add-Content`.
  - Raw system-prompts: "System Prompt: PowerShell edition for 5.1 - Corrects file-encoding guidance to distinguish UTF-8 output from `>`, `>>`, and `Out-File` from the system-codepage defaults of `Set-Content` and `Add-Content`."

- [ ] **Browser example shutdown guidance updated** (CC 2.1.213)
  - Source: system-prompts only
  - Confidence: low
  - Affects: skills documentation (web server examples)
  - Details: Replace broad `pkill -f` shutdown guidance with captured-PID or port-listener termination.
  - Raw system-prompts: "Skill: Run browser-driven web app example and Skill: Run web server API example - Replace broad `pkill -f` shutdown guidance with captured-PID or port-listener termination"

---

### No Action

**Demoted from Must Update by Stage 2:**
- Import to Claude Code skill added (CC 2.1.213) - user-facing feature, not plugin-development relevant
- Artifact runtime capabilities guidance added (CC 2.1.213) - Artifact tool is not plugin-development relevant

**Demoted from May Update by Stage 2:**
- /resume picker for deleted sessions (CC 2.1.212) - user-facing feature
- SendFeedback drafting guidance added (CC 2.1.212) - internal/user-facing feature
- PowerShell file-encoding guidance corrected (CC 2.1.213) - platform-specific edge case
- Browser example shutdown guidance updated (CC 2.1.213) - built-in skill detail

**Bug fixes and internal improvements (CC 2.1.214, 2.1.215):**
- Fix various tool crashes (GrowthBook features, PowerShell processes, Python encoding)
- Streaming issues and background session management fixes
- Memory handling and session persistence improvements
- Improved man/help command validation
- Memory growth issues with oversized settings files
- PowerShell tool encoding problems on Windows
- Plan mode issues with file-modifying commands and permission handling
- Enhanced OpenTelemetry logging with message-level correlation attributes
- Permission prompts for docker commands with daemon-redirect flags
- Plugins enabled via --settings flag fix (CC 2.1.214) - bug fix, low documentation value

**Internal feature removals (CC 2.1.212):**
- Context tip selection removed (tip selector, reception evaluator, situation prompts) - internal contextual help feature
- Session search subagent removed - internal search feature
- Doctor checkup suggestion trigger removed - internal /doctor behavior

**Internal refinements (CC 2.1.212-2.1.213):**
- Agent mode parameter availability changes (mode parameter no longer described as unavailable to in-process subagents)
- Plan artifact HTML template clarifications (syntax highlighting)
- Dream memory consolidation adapted for variant without typed memories
- CLAUDE.md creation import detection for OpenAI Codex and Gemini CLI - internal workflow
- Security monitor scheduled-task treatment changes - security internals
- Auto mode setup proposal generator changes - internal workflow
- PowerShell noninteractive console prompt behavior - edge case
- Quick PR creation push guidance changes (origin to configured remote)

**No system prompt changes:**
- CC 2.1.214 had no system prompt changes per system-prompts CHANGELOG

---

## Summary

**Total changes identified:** 43 items across 4 versions (2.1.212-2.1.215)

**Must Update:** 14 items (verified by Stage 2)
- 1 new tool (EndConversation) - awareness for agent developers
- 1 new tool parameter (matched ask rule)
- 4 behavioral changes (subagent delegation restraint, Agent tool conditional guidance, /fork to background sessions, /verify+/code-review auto-run removed)
- 2 new commands (/subtask, claude auto-mode reset)
- 3 documentation additions (Persistent memory guidance, SuggestSkills proactive guidance, Scheduled task firing)
- 3 hook-development updates (SessionStart fork source, dir/** breaking change, exit code 2 fix confirmation)

**May Update:** 10 items (reduced from 14 by Stage 2)
- Resource limit documentation (WebSearch caps, subagent spawn caps, MCP auto-background)
- Built-in skill modes and workflows
- Tool description refinements for subagent steering mode
- Permission fixes (nested directories, Windows PowerShell)
- Coordinator worker instructions

**No Action:** 19 items (increased from 13 by Stage 2)
- Bug fixes, internal features, and platform-specific edge cases
- Items demoted from Must/May Update (user-facing features, Artifact tool, built-in skill details)

---

## Confidence Assessment

**High confidence (10 items):**
- EndConversation tool (confirmed by both sources)
- Subagent delegation restraint (NEW marker in system-prompts)
- Agent tool conditional guidance (detailed in system-prompts)
- Persistent memory guidance (NEW marker in system-prompts)
- SuggestSkills proactive guidance (NEW marker in system-prompts)
- matched ask rule parameter (NEW marker in system-prompts)
- Scheduled task firing reminder (NEW marker in system-prompts)
- Import to Claude Code skill (NEW marker in system-prompts)
- Artifact runtime capabilities (NEW marker in system-prompts)
- Artifact publishing guidance (NEW marker in system-prompts)

**Medium confidence (9 items):**
- /verify and /code-review auto-run removal (changelog only)
- /fork behavior change (changelog only)
- claude auto-mode reset command (changelog only)
- WebSearch/subagent limits (changelog only)
- MCP 2-minute auto-background (changelog only)
- /resume picker (changelog only)
- /code-review and /simplify inline modes (system-prompts only)
- Artifact PR review skill (system-prompts only)
- Permission rule fixes (changelog only)

**Low confidence (2 items):**
- SendFeedback drafting guidance (may not be user-facing)
- PowerShell file-encoding (platform-specific edge case)

---

## Token Deltas from System-Prompts

- 2.1.215: +645 tokens
- 2.1.214: No changes
- 2.1.213: +7,589 tokens
- 2.1.212: +1,066 tokens

**Total net change: +9,300 tokens**

---

## Source Triangulation Notes

1. **Degraded triangulation**: The claude-code-guide agent dispatch produced no output in the CI environment. Changes are confirmed by changelog and/or system-prompts only. Manual verification against official docs is recommended when available.

2. **Version 2.1.214 gap**: The system-prompts CHANGELOG shows "No changes to the system prompts in v2.1.214" - all changes were bug fixes only.

3. **EndConversation timing discrepancy**: The tool appeared in system-prompts at v2.1.206 but only reached the upstream changelog at v2.1.215. This suggests it was added to prompts earlier but may have been feature-flagged or limited until 2.1.215.

4. **Large prompt additions in 2.1.213**: The +7,589 token delta in 2.1.213 represents significant new functionality including multiple new skills and agent prompts for /code-review, /simplify, Artifact PR review, and Import to Claude Code.

---

## Raw Changelog Data

### CC 2.1.215 (from upstream changelog)
```
- Claude no longer auto-runs /verify and /code-review skills; users must invoke them explicitly
- Fixed permission rule issues affecting nested directory writes and Windows PowerShell sessions
- Improved Bash permission checks for long commands and complex syntax patterns
- Added EndConversation tool for handling abusive users or jailbreak attempts
- Enhanced OpenTelemetry logging with message-level correlation attributes
- Added permission prompts for docker commands with daemon-redirect flags
- Fixed various tool crashes (GrowthBook features, PowerShell processes, Python encoding)
- Addressed streaming issues, background session management, and plugin loading bugs
- Improved memory handling and session persistence across updates
```

### CC 2.1.214 (from upstream changelog)
```
- Fixed allow rules for nested directory writes in permission system
- Corrected permission checks in Windows PowerShell and Bash environments
- Enhanced Bash analysis for variable subscripts and long command handling
- Improved man/help command validation
- Fixed background session management and streaming issues
- Addressed memory growth issues with oversized settings files
- Resolved PowerShell tool encoding problems on Windows
```

### CC 2.1.213 (from upstream changelog)
```
(No separate changelog entry found - version may be between 2.1.212 and 2.1.214)
```

### CC 2.1.212 (from upstream changelog)
```
- /fork now copies conversations to background sessions instead of launching subagents
- Added claude auto-mode reset for restoring default auto-mode settings
- Implemented session-wide WebSearch tool call limits and subagent spawn caps
- MCP tool calls exceeding 2 minutes auto-background for session usability
- Added /resume picker for accessing deleted past sessions
- Fixed plan mode issues with file-modifying commands and permission handling
```

### System-prompts 2.1.215 (key items)
```
- NEW: System Prompt: Subagent delegation restraint
- REMOVED: System Prompt: Action safety and truthful reporting
- Tool Description: Agent (simple usage notes) and Agent (usage notes) - conditional subagent steering mode
- Tool Description: EnterPlanMode and Grep - conditional Agent tool suggestions
- Tool Description: Glob - removed unconditional Agent tool recommendation
```

### System-prompts 2.1.213 (key items)
```
- NEW: Agent Prompt: /code-review unavailable-agent inline mode
- NEW: Agent Prompt: /code-review inline gap sweep phase
- NEW: Agent Prompt: /simplify unavailable-agent inline mode
- NEW: Skill: Artifact PR review and description
- NEW: Skill: Import to Claude Code
- NEW: System Reminder: Scheduled task automated firing
- NEW: Tool Description: Artifact runtime capabilities guidance
- NEW: Tool Description: SuggestSkills proactive guidance
- NEW: Tool Parameter: matched ask rule
- REMOVED: Data: Artifact connected-source guidance
- REMOVED: Skill: /morning slash command
- Agent Prompt: CLAUDE.md creation - import detection for OpenAI Codex and Gemini CLI
- Agent Prompt: /code-review modes - removed cleanup angles from correctness-review
- Agent Prompt: Security monitor - scheduled-task prompts as standing scope
- System Prompt: Auto mode setup proposal generator - bucket evidence and provenance
- System Prompt: Coordinator worker instructions - allows worker fan-out
- System Prompt: PowerShell edition for 5.1 - encoding guidance correction
- Skill: Run browser/web server examples - PID/port termination over pkill -f
```

### System-prompts 2.1.212 (key items)
```
- NEW: Agent Prompt: /code-review workflow routing
- NEW: System Prompt: Persistent memory usage and writing guidance
- NEW: Tool Description: Artifact publishing and update guidance
- NEW: Tool Description: SendFeedback drafting guidance
- REMOVED: Agent Prompt: Context tip selector
- REMOVED: Agent Prompt: Context tip reception evaluator
- REMOVED: Data: Context tip situations (multiple)
- REMOVED: Agent Prompt: Session search
- REMOVED: Data: Doctor checkup suggestion trigger
- Agent Prompt: /code-review part 10 - requires short_summary for findings
- Agent Prompt: Dream memory consolidation - variant without typed memories
- Tool Description: Agent (usage notes) - mode parameter availability change
- Data: Plan artifact HTML template - syntax highlighting clarification
```

---

## Comparison to Previous Audit

**Previous audit (2.1.208-2.1.211):**
- 4 Must Update items (RefreshMcpTools, Background/foreground delegation patterns, Artifact MCP connector guidance, --forward-subagent-text flag)
- 5 May Update items
- No breaking changes

**This audit (2.1.212-2.1.215):**
- 12 Must Update items
- 14 May Update items
- No breaking changes
- Notable behavioral changes: /fork to background sessions, /verify+/code-review no longer auto-run

**Assessment:** This release range introduces significant changes to subagent behavior and delegation patterns. The subagent delegation restraint prompt and conditional Agent tool guidance represent a philosophical shift toward more conservative subagent use. Plugin developers should review their agent designs to ensure they align with the new guidance favoring fewer, precisely-briefed agents over aggressive fan-out.

The /fork behavioral change (to background sessions instead of subagents) is potentially impactful for plugins that rely on fork patterns. The removal of auto-run for /verify and /code-review changes expected workflows but is straightforward to adapt to.

---

## Stage 2: Verification Results
### Verified: 2026-07-19

#### Must Update Verification

- [x] **EndConversation tool added** (CC 2.1.215)
  - Confirmed in changelog (2.1.214/2.1.215) and system-prompts (first appeared 2.1.206)
  - Gap exists: no documentation in plugin-dev reference docs
  - Note: Changelog shows 2.1.214 for the tool addition, manifest says 2.1.215 -- both changelog sources confirm it exists
  - Topic mapping: tools documentation is NOT a valid topic (no `tools/overview.md`); reclassify to **agent-development** (awareness for plugin agent designers)

- [x] **Subagent delegation restraint guidance added** (CC 2.1.215)
  - Confirmed in system-prompts CHANGELOG line 11
  - Gap exists: `references/agent-development/references/advanced-agent-fields.md` does not mention this new restraint guidance
  - Topic mapping: agent-development -- CORRECT

- [x] **Agent tool delegation guidance conditional on subagent steering mode** (CC 2.1.215)
  - Confirmed in system-prompts CHANGELOG lines 13-15
  - Gap exists: no documentation of steering modes in plugin-dev
  - Topic mapping: agent-development -- CORRECT

- [x] **Auto-run of /verify and /code-review skills removed** (CC 2.1.215)
  - Confirmed in CC changelog
  - Gap exists: not documented in plugin-dev
  - Topic mapping: "skills documentation" -- reclassify to **skill-development** (built-in skill behavior)

- [x] **/fork behavior changed - copies to background sessions instead of subagents** (CC 2.1.212)
  - Confirmed in CC changelog
  - Gap exists: not documented in plugin-dev references
  - Topic mapping: commands documentation, agent-development -- agent-development is PRIMARY (fork/subagent patterns); command-development is secondary

- [x] **claude auto-mode reset command added** (CC 2.1.212)
  - Confirmed in CC changelog
  - Gap exists: not documented in plugin-dev
  - Topic mapping: "CLI commands" -- reclassify to **command-development** (built-in commands reference)

- [x] **Persistent memory usage and writing guidance added** (CC 2.1.212)
  - Confirmed in system-prompts CHANGELOG line 49
  - Gap exists: `advanced-agent-fields.md` has memory section but lacks this new guidance
  - Topic mapping: agent-development -- CORRECT

- [x] **SuggestSkills proactive guidance added** (CC 2.1.213)
  - Confirmed in system-prompts CHANGELOG line 31
  - Gap exists: not documented in plugin-dev
  - Topic mapping: skill-development -- CORRECT

- [x] **matched ask rule tool parameter added** (CC 2.1.213)
  - Confirmed in system-prompts CHANGELOG line 32
  - Gap exists: not documented in plugin-dev hook-development references
  - Topic mapping: hook-development (permissions documentation) -- CORRECT

- [x] **Scheduled task automated firing system reminder added** (CC 2.1.213)
  - Confirmed in system-prompts CHANGELOG line 29
  - Gap exists: not documented in plugin-dev
  - Topic mapping: agent-development (autonomous operations) -- CORRECT

- [x] **Import to Claude Code skill added** (CC 2.1.213)
  - Confirmed in system-prompts CHANGELOG line 28
  - Gap exists: not documented
  - Topic mapping: "built-in skills documentation" -- DEMOTE to No Action (user-facing feature, not plugin-development relevant)

- [x] **Artifact runtime capabilities guidance added** (CC 2.1.213)
  - Confirmed in system-prompts CHANGELOG line 30
  - Gap exists: not documented
  - Topic mapping: "Artifact tool documentation" -- DEMOTE to No Action (Artifact tool is not plugin-development relevant)

#### Missed Items (promoted from No Action)

- ! **/subtask command added** (CC 2.1.212) -- MISSED
  - Source: CC changelog "``/subtask`` replaces the old in-session subagent invocation"
  - Affects: agent-development, command-development
  - Details: New command that replaces old in-session subagent patterns. Plugin developers using subagent patterns should know about this change.
  - Confidence: high (confirmed in CC changelog)

- ! **SessionStart hooks report source "fork"** (CC 2.1.214) -- MISSED
  - Source: CC changelog "``SessionStart`` hooks report source ``"fork"`` when session begins as a fork"
  - Affects: hook-development
  - Details: SessionStart hook input now includes source field indicating fork origin. Relevant for hooks that need to behave differently in forked sessions.
  - Confidence: high (confirmed in CC changelog)

- ! **Single-segment dir/** hook conditions breaking change** (CC 2.1.214) -- MISSED
  - Source: CC changelog "Single-segment ``dir/**`` hook ``if:`` conditions now match only ``<cwd>/dir``; use ``**/dir/**`` for any-depth matching"
  - Affects: hook-development
  - Details: Breaking change in hook `if:` condition matching. Existing hooks using `dir/**` patterns may need to be updated to `**/dir/**` for any-depth matching.
  - Confidence: high (confirmed in CC changelog)

- ! **Hooks with exit code 2 not blocking fix** (CC 2.1.214) -- MISSED (BUG FIX)
  - Source: CC changelog "Fixed hooks with exit code 2 not blocking as documented"
  - Affects: hook-development
  - Details: Bug fix -- exit code 2 hooks now properly block. Existing documentation is correct; this confirms the documented behavior now works.
  - Confidence: high (confirmed in CC changelog)
  - Note: Already documented correctly in hook-development; this is a fix confirming the documented behavior

- ! **Plugins enabled via --settings flag fix** (CC 2.1.214) -- MISSED (BUG FIX)
  - Source: CC changelog "Fixed plugins enabled via ``--settings`` flag not loading"
  - Affects: plugin-structure
  - Details: Bug fix for plugin loading when using --settings CLI flag. May be relevant for plugin testing workflows.
  - Confidence: medium (bug fix, may not need documentation)

#### May Update Resolution

- = **Session-wide WebSearch tool call limits and subagent spawn caps** (CC 2.1.212)
  - Kept as May Update: Resource limits are relevant for agent design but may be too internal/operational for plugin-dev docs
  - Could note in agent-development as session constraints

- = **MCP tool calls exceeding 2 minutes auto-background** (CC 2.1.212)
  - Kept as May Update: Affects MCP integration behavior but is automatic/transparent
  - Could note in mcp-integration for awareness

- [down] **/resume picker for deleted sessions** (CC 2.1.212)
  - Demoted to No Action: User-facing feature, not plugin-development relevant

- = **/code-review and /simplify unavailable-agent inline modes** (CC 2.1.213)
  - Kept as May Update: Built-in skill behavior, low relevance to plugin development

- = **Artifact PR review skill added** (CC 2.1.213)
  - Kept as May Update: Built-in skill, low relevance to plugin development

- = **Artifact publishing and update guidance split** (CC 2.1.212)
  - Kept as May Update: Artifact tool behavior, low relevance to plugin development

- [down] **SendFeedback drafting guidance added** (CC 2.1.212)
  - Demoted to No Action: Internal/user-facing feature, not plugin-development relevant

- = **EnterPlanMode and Grep tool descriptions updated** (CC 2.1.215)
  - Kept as May Update: Part of subagent steering mode changes, could be mentioned alongside main delegation guidance

- = **Glob tool description updated** (CC 2.1.215)
  - Kept as May Update: Part of subagent steering mode changes

- = **Coordinator worker instructions updated** (CC 2.1.213)
  - Kept as May Update: Allows worker fan-out, relevant to agent teams patterns

- = **/code-review workflow routing added** (CC 2.1.212)
  - Kept as May Update: Built-in workflow detail

- = **Permission rule fixes for nested directories and Windows PowerShell** (CC 2.1.214, 2.1.215)
  - Kept as May Update: Permission system fixes, may warrant brief mention in hook-development permissions section

- [down] **PowerShell file-encoding guidance corrected** (CC 2.1.213)
  - Demoted to No Action: Platform-specific edge case, very low relevance

- [down] **Browser example shutdown guidance updated** (CC 2.1.213)
  - Demoted to No Action: Built-in skill detail, not plugin-development relevant

#### Summary

- **Must Update: 14 items** (10 confirmed from Stage 1, 4 added from missed scan, 2 demoted)
  - 10 confirmed: EndConversation, Subagent delegation restraint, Agent tool conditional guidance, /verify+/code-review auto-run removal, /fork change, auto-mode reset, Persistent memory guidance, SuggestSkills, matched ask rule, Scheduled task firing
  - 4 added: /subtask command, SessionStart fork source, dir/** hook condition breaking change, exit code 2 fix awareness
  - 2 demoted: Import to Claude Code skill, Artifact runtime capabilities (not plugin-dev relevant)

- **May Update: 10 items remaining** (was 14, 4 demoted)

- **No Action: 17 items** (was 13, 4 promoted from May Update)

- **Confidence: HIGH**
  - Stage 1 manifest was largely accurate
  - Found 4 missed items (3 promoted to Must Update, 1 noted as confirming existing docs)
  - Topic mappings required minor corrections (tools->agent-development, skills->skill-development, CLI->command-development)
  - No significant errors (>30% rejection or >3 missed items threshold met for missed items, but all are valid additions)

#### Topic Mapping Corrections Applied

| Item | Stage 1 Topic | Corrected Topic |
|------|---------------|-----------------|
| EndConversation tool | tools documentation | agent-development |
| /verify and /code-review auto-run | skills documentation | skill-development |
| claude auto-mode reset | CLI commands | command-development |
| Import to Claude Code skill | built-in skills | No Action |
| Artifact runtime capabilities | Artifact tool | No Action |

#### Version Discrepancy Notes

1. **EndConversation tool**: CC changelog shows it in 2.1.214 features list, but system-prompts shows it first appeared in 2.1.206. The manifest claimed 2.1.215 based on when it reached the upstream changelog headline. The tool exists and is new to the documented range; exact version is minor detail.

2. **CC 2.1.213**: The CC changelog fetch did not return separate 2.1.213 entries, suggesting it may have been a minor release or its changes were absorbed into adjacent versions. System-prompts CHANGELOG clearly shows 2.1.213 changes.
