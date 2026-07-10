# Upstream Change Manifest
## CC Version Range: 2.1.202 - 2.1.206
## Generated: 2026-07-10
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [Y]

---

### Must Update (Stage 2 Verified)

- [ ] **/doctor command CLAUDE.md trimming check** (CC 2.1.206)
  - Source: system-prompts changelog + changelog (confirmed both)
  - Confidence: high
  - Affects: plugin-settings reference (CLAUDE.md guidance)
  - Details: The /doctor command now includes a check suggesting trimming checked-in CLAUDE.md files. Removes codebase-derivable layouts, stack lists, standard commands, copied schemas, generic advice, and mechanically enforced rules while preserving gotchas, rationale, non-standard conventions, safety directives, and other non-derivable guidance.
  - Stage 2 Note: Plugin developers creating CLAUDE.md files should understand what content survives /doctor recommendations.

- [ ] **MCP servers failed to connect system reminder** (CC 2.1.205)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: mcp-integration reference
  - Details: New system reminder warns when configured MCP servers fail to connect, tells agents to treat their tools as unavailable because of connection failure rather than missing capability, and marks quoted connection errors as diagnostic data rather than instructions.
  - Stage 2 Note: Relevant for plugin developers bundling MCP servers; affects error handling patterns.

- [ ] **Background tasks changed event schema** (CC 2.1.203)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: hook-development reference (event-schemas.md)
  - Details: New `background_tasks_changed` level-event schema with replace-set semantics, unspecified ordering relative to bookend events, id-only payloads, and per-process reset behavior.
  - Stage 2 Note: New hook event that plugins can respond to; must be documented in event-schemas.md.

---

### May Update (Stage 2 Verified)

- [ ] **Auto mode consent flow system reminder** (CC 2.1.203)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development patterns (auto mode)
  - Details: New auto-mode guidance to try safe alternatives first, keep working when consent is blocked, batch remaining consent asks before ending the turn.
  - Stage 2 Note: Behavioral guidance for auto mode; useful but not critical for plugin developers.

- [ ] **SendMessageTool addressing changes for completed agents** (CC 2.1.203)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development patterns
  - Details: Names keep working after completion and resume the transcript, using raw agentId only for unnamed agents or when a newer agent has taken the name.
  - Stage 2 Note: Behavioral improvement; existing code continues to work.

- [ ] **Loop execution explicit re-arming** (CC 2.1.202)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development patterns (background loops)
  - Details: Loop re-arming is now an explicit per-turn decision; end loops by calling the wakeup tool with stop: true instead of omitting the call.
  - Stage 2 Note: Affects advanced agent patterns using loops/scheduling.

- [ ] **Plugin LSP server initialization fixes** (CC 2.1.205)
  - Source: CC changelog
  - Confidence: medium
  - Affects: lsp-integration reference
  - Details: Plugin LSP server initialization fixes.
  - Stage 2 Note: Promoted from No Action; specifically relevant to plugin LSP integration.

- [ ] **Auto mode setup skill rework** (CC 2.1.206)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: auto mode documentation examples
  - Details: Reworks setup around mechanically pre-gathered, untrusted local recon.
  - Stage 2 Note: Useful context for auto-mode workflows but not critical.

- [ ] **Security monitor consent and user-intent interpretation tightening** (CC 2.1.203 and 2.1.205)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: auto mode security documentation
  - Details: Replaces broad high-severity user-intent checks with explicit soft-block consent bars.
  - Stage 2 Note: Auto mode security changes; relevant for plugin agents in auto mode.

- [ ] **Dynamic workflow size setting** (CC 2.1.202)
  - Source: CC changelog only
  - Confidence: low
  - Affects: workflow configuration documentation
  - Details: New setting for controlling agent counts in workflows.
  - Stage 2 Note: Promoted from low confidence; affects workflow orchestration patterns.

- [ ] **Session working directories in MCP roots/list** (CC 2.1.203)
  - Source: CC changelog only
  - Confidence: low
  - Affects: mcp-integration reference
  - Details: Session working directories now included in MCP roots/list response.
  - Stage 2 Note: Relevant for MCP integration documentation.

---

### No Action (Stage 2 Verified)

**Stage 2 Reclassified Items (from Must Update):**
- **EndConversation tool added** (CC 2.1.206) - Internal tool with specific usage restrictions (sustained abuse, user demo). Not plugin development API.
- **Artifact skills (dashboard, data table, explainer, report)** (CC 2.1.206) - Bundled Claude Code skills, not plugin APIs.
- **Code Review skills effort-scaled modes** (CC 2.1.206) - Bundled Claude Code skills, not plugin APIs.
- **PR explainer artifact-template mode** (CC 2.1.206) - Internal skill enhancement, not plugin API.
- **Proactive schedule offer prompts removed** (CC 2.1.206) - Internal scheduling behavior.
- **Security monitor transcript tampering soft block** (CC 2.1.205) - Auto mode security infrastructure; agents should not tamper with transcripts.
- **Verify skill narrowed project skill updates** (CC 2.1.205) - Internal verify skill behavior.
- **EnterWorktree nested repository support** (CC 2.1.203) - Minor enhancement to existing functionality.
- **Governed GitHub CLI shim** (CC 2.1.202) - Infrastructure; plugins use gh normally.
- **/code-review low effort minimum findings mode** (CC 2.1.202) - Internal code review mode.

**Stage 2 Reclassified Items (from May Update):**
- **Quick PR creation remote guidance** (CC 2.1.206) - Minor behavioral change to built-in PR creation.
- **ClaudeDesign tool preference** (CC 2.1.206) - Separate tool surface, not plugin API.
- **Conversation/message summarization user turn counting** (CC 2.1.205) - Internal summarization behavior.
- **/review slash command sectioned PR review** (CC 2.1.202) - Internal /review behavior.
- **PR explainer requirements expanded** (CC 2.1.202) - Internal skill behavior.
- **Manual permission mode indicator in footer** (CC 2.1.203) - UI indicator.
- **Login expiration warnings** (CC 2.1.203) - Authentication UX.

**Original No Action Items (bug fixes and infrastructure):**
- **Hook event streaming fix during SessionStart hooks in headless sessions** (CC 2.1.204) - Bug fix, no prompt changes per system-prompts changelog
- **--json-schema fix for invalid schemas** (CC 2.1.205) - Bug fix for CLI
- **Messages sent during --max-turns limit no longer silently lost** (CC 2.1.205) - Bug fix
- **Windows worktree removal improvements** (CC 2.1.205) - Platform-specific bug fix
- **Background agent status fixes for resumed sessions** (CC 2.1.205) - Bug fix
- **Windows crash prevention** (CC 2.1.205) - Platform-specific bug fix
- **Inline Ctrl+R history search crash fixes** (CC 2.1.202) - Bug fix
- **Background session rename persistence improvements** (CC 2.1.202) - Bug fix
- **mTLS handshake transient failure handling** (CC 2.1.202) - Bug fix
- **Remote Control command routing fixes** (CC 2.1.202) - Bug fix
- **Sign-in URL reliability improvements** (CC 2.1.202) - Bug fix
- **Voice dictation retry loop prevention** (CC 2.1.202) - Bug fix
- **Worktree repository performance optimization** (CC 2.1.202) - Performance fix
- **OpenTelemetry attributes for workflow-spawned agents** (CC 2.1.202) - Observability, not plugin-facing
- **Gateway login Anthropic public endpoints support** (CC 2.1.206) - Infrastructure
- **Background agents auto-upgrade after updates** (CC 2.1.206) - Lifecycle management
- **Expired login error messaging** (CC 2.1.206) - UX improvement
- **MCP server timeout and OAuth refresh fixes** (CC 2.1.206) - Bug fixes
- **Model picker pricing display** (CC 2.1.206) - UI improvement
- **Desktop sessions stuck "running" status fix** (CC 2.1.206) - Bug fix
- **Improved agents view terminal width** (CC 2.1.206) - UI improvement
- **Ctrl+X session permanence** (CC 2.1.206) - UI behavior
- **Enhanced /cd with directory path suggestions** (CC 2.1.206) - Minor UX (not in system-prompts, may be CLI only)
- **Context usage analysis performance** (CC 2.1.203) - Performance
- **Background agent PATH inheritance corrections** (CC 2.1.203) - Bug fix
- **Git worktree bash failures resolved** (CC 2.1.203) - Bug fix
- **Worktree-isolated subagent shell command fixes** (CC 2.1.203) - Bug fix
- **Subagent work preservation returning to agent view** (CC 2.1.203) - UI behavior
- **stale token recovery for background sessions** (CC 2.1.203) - Bug fix
- **Background session responsiveness after sleep/wake** (CC 2.1.203) - Bug fix

---

## Summary (Stage 2 Updated)

**Version range audited:** 2.1.202 through 2.1.206 (5 versions after last audit at 2.1.201)

**Stage 2 Verification Results:**
- **Must Update:** 3 items (down from 16 in Stage 1)
- **May Update:** 8 items (reclassified and verified)
- **No Action:** Remainder (including 17 reclassified items)
- **Confidence:** HIGH

**Versions included:**
- 2.1.202 (limited plugin relevance - loop re-arming pattern change)
- 2.1.203 (significant - background_tasks_changed event schema, auto mode consent flow)
- 2.1.204 (minimal - hook event streaming fix only, no system prompt changes)
- 2.1.205 (significant for plugins - MCP server connection failure reminder, LSP initialization fixes)
- 2.1.206 (limited plugin relevance - /doctor CLAUDE.md trimming guidance)

**Token delta from system-prompts:**
- 2.1.202: +3,217 tokens
- 2.1.203: +16,113 tokens
- 2.1.204: No changes
- 2.1.205: +23,674 tokens
- 2.1.206: +10,807 tokens

**Total estimated token impact:** +53,811 tokens in system prompts (mostly internal features)

---

### Critical Changes Requiring Documentation Updates (Stage 2 Verified)

**Must Update (3 items):**

1. **/doctor CLAUDE.md trimming** (CC 2.1.206) - New check recommending trimming CLAUDE.md files. Plugin developers should understand what content survives /doctor recommendations when creating CLAUDE.md files.
   - Update: plugin-settings reference (CLAUDE.md guidance section)

2. **MCP server connection failure reminder** (CC 2.1.205) - New system reminder when MCP servers fail to connect. Plugin developers bundling MCP servers should document expected error handling.
   - Update: mcp-integration reference (Error Handling section)

3. **background_tasks_changed event** (CC 2.1.203) - New hook event schema with replace-set semantics. Plugin developers can now respond to background task state changes.
   - Update: hook-development/references/event-schemas.md (add new event)

**May Update (8 items) - optional enhancements for completeness:**

4. **Auto mode consent flow** (CC 2.1.203) - Behavioral guidance for auto mode consent handling. Useful for plugin agents running in auto mode.

5. **SendMessageTool addressing changes** (CC 2.1.203) - Names keep working after agent completion. Improves multi-agent patterns.

6. **Loop execution explicit re-arming** (CC 2.1.202) - New pattern for ending loops with `stop: true`. Affects advanced loop-based agents.

7. **Plugin LSP server initialization fixes** (CC 2.1.205) - Bug fixes for LSP plugin initialization.

8. **Security monitor consent/user-intent tightening** (CC 2.1.203, 2.1.205) - Auto mode security changes.

---

### Key Themes in This Release Range

1. **Artifact workflows**: Major expansion of artifact template skills (dashboard, data table, explainer, report)
2. **Code review evolution**: Effort-scaled review modes from low to xhigh
3. **Security tightening**: Transcript tampering blocks, consent flow guidance, user-intent interpretation
4. **Background agent events**: New background_tasks_changed schema for hook system
5. **MCP resilience**: Connection failure handling guidance
6. **CLAUDE.md hygiene**: /doctor check for trimming overly verbose CLAUDE.md files
7. **Multi-agent coordination**: SendMessageTool addressing improvements for completed agents

---

### Triangulation Notes

- Three-source triangulation used: CC changelog + system-prompts changelog + claude-code-guide agent
- claude-code-guide agent confirmed /doctor CLAUDE.md trimming and transcript tampering soft block
- claude-code-guide noted several changelog items (Dynamic workflow size, MCP roots/list, permission indicator) not found in system-prompts
- Changes confirmed in both changelog sources marked as high confidence
- Single-source changes marked as medium/low confidence
- System-prompts provided the most detailed behavioral change information

---

## Raw Changelog Data

### CC 2.1.206 (from upstream changelog)
```
- Enhanced `/cd` command with directory path suggestions matching `/add-dir` behavior
- New `/doctor` check suggesting trimming checked-in `CLAUDE.md` files
- Improved `/commit-push-pr` to auto-allow pushes to configured push remotes
- Gateway login now supports Anthropic-operated public endpoints
- Background agents upgrade automatically after Claude Code updates
- Fixed expired login error messaging for better user guidance
- Multiple MCP server fixes including timeout handling and OAuth refresh issues
- Model picker improvements for accurate pricing display
- Desktop sessions no longer get stuck showing "running" status
- Improved agents view with full terminal width status column
- Session permanence: Ctrl+X now permanently removes completed sessions
```

### CC 2.1.205 (from upstream changelog)
```
- Auto mode rule blocking transcript file tampering
- Fixed `--json-schema` producing unstructured output with invalid schemas
- Messages sent during `--max-turns` limit no longer silently lost
- Windows worktree removal improvements preventing file deletion outside target
- Background agent status fixes for resumed sessions
- Session-to-PR linking improvements for bash output exceeding limits
- Plugin LSP server initialization fixes
- Windows crash prevention when launch directory becomes unavailable
- Agent view rendering corrections and improved session information display
```

### CC 2.1.204 (from upstream changelog)
```
- Hook event streaming fix during SessionStart hooks in headless sessions
```

### CC 2.1.203 (from upstream changelog)
```
- Login expiration warnings allowing pre-authentication before interruptions
- Manual permission mode indicator added to footer
- Session working directories now included in MCP `roots/list`
- Background session responsiveness improvements after sleep/wake cycles
- stale token recovery for background sessions
- Subagent work preservation when returning to agent view
- Context usage analysis performance improvements
- Background agent PATH inheritance corrections
- Git worktree bash failures resolved
- Worktree-isolated subagent shell command fixes
```

### CC 2.1.202 (from upstream changelog)
```
- New "Dynamic workflow size" setting for controlling agent counts
- OpenTelemetry attributes added for workflow-spawned agents
- Inline Ctrl+R history search crash fixes
- Background session rename persistence improvements
- mTLS handshake transient failure handling
- Remote Control command routing fixes
- Image/file handling in Remote Control apps
- Sign-in URL reliability improvements for SSH connections
- Workflow script unicode quote escape fixes
- Voice dictation retry loop prevention
- Remote Control permission mode display fixes
- Worktree repository performance optimization
- Skill invocation improvements
- Workflow review engine streamlining
```

### System-prompts 2.1.206 (key items)
```
- **NEW:** Tool Description: EndConversation and System Reminder: End conversation background fork no-op
- **NEW:** Skill: Artifact dashboard; Skill: Artifact data table; Skill: Artifact explainer; Skill: Artifact report
- **NEW:** Skill: Code Review correctness finder angles; Code Review inline medium/high; Code Review inline xhigh; Code Review low effort expanded-findings
- **NEW:** Skill: PR explainer artifact-template mode
- **REMOVED:** System Prompt: Proactive schedule offer after natural future follow-up
- **REMOVED:** System Prompt: Strict proactive schedule offer gate
- Skill: /doctor slash command -- Add checked-in CLAUDE.md trimming pass
- Skill: Auto mode setup -- Reworks setup around pre-gathered local recon
- Tool Description: ClaudeDesign -- Prefer live shared Claude Design canvas
```

### System-prompts 2.1.205 (key items)
```
- **NEW:** Data: Interrupt receipt still queued field
- **NEW:** Data: Peer sender display name field
- **NEW:** Skill: /doctor slash command and description
- **NEW:** System Reminder: MCP servers failed to connect
- Agent Prompt: Security monitor -- soft block for transcript JSONL tampering
- Skill: Verify skill -- Narrows project skill updates
- Conversation summarization -- count only actual user-role turns
```

### System-prompts 2.1.203 (key items)
```
- **NEW:** Data: Background tasks changed event schema
- **NEW:** Data: Context tip situation -- subagent fan-out
- **NEW:** System Reminder: Auto mode consent flow
- **REMOVED:** Agent Prompt: Fleet agent suggestion scope personalization
- **REMOVED:** System Prompt: Tool execution denied
- Agent Prompt: General purpose -- task-specific agents do assigned work directly
- Tool Description: SendMessageTool -- names keep working after completion
- Tool Description: EnterWorktree -- nested repository support
```

### System-prompts 2.1.202 (key items)
```
- **NEW:** Agent Prompt: /code-review part 2 low effort minimum findings mode
- **NEW:** Data: Governed GitHub CLI shim header and routing
- Agent Prompt: /review slash command -- sectioned PR review
- Skill: Dynamic pacing loop execution -- loop re-arming explicit per-turn decision
- Skill: PR explainer -- requirements for PR walkthrough artifacts
```

---

## Stage 2: Verification Results
### Verified: 2026-07-10

#### Must Update Verification

**EndConversation tool added (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 14: "**NEW:** Tool Description: EndConversation and System Reminder: End conversation background fork no-op"
- Gap exists: No EndConversation tool documented in plugin-dev references
- Affects: tool-reference (if exists), agent-development patterns
- STATUS: Reclassified to **No Action** — This is a Claude Code internal tool with very specific usage restrictions (sustained abuse, user-requested demo). Plugin developers do not need to document or use this tool; it is not part of the plugin development API.

**Artifact skills added (dashboard, data table, explainer, report) (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 11: "**NEW:** Skill: Artifact dashboard; Skill: Artifact data table; Skill: Artifact explainer; and Skill: Artifact report"
- Gap exists: No artifact skill patterns documented in plugin-dev
- Affects: skill-development examples (if relevant)
- STATUS: Reclassified to **No Action** — These are bundled Claude Code skills, not plugin-development APIs. Plugin developers do not create or extend these skills; they are internal to Claude Code. No documentation gap for plugin development.

**Code Review skills expanded with effort-scaled modes (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 12: "**NEW:** Skill: Code Review correctness finder angles; Skill: Code Review inline medium/high template; Skill: Code Review inline xhigh mode; and Skill: Code Review low effort expanded-findings mode"
- Gap exists: No code review skill patterns documented
- Affects: skill-development reference patterns
- STATUS: Reclassified to **No Action** — These are bundled Claude Code code review skills, not plugin-development APIs. No documentation gap for plugin development.

**PR explainer artifact-template mode (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 13: "**NEW:** Skill: PR explainer artifact-template mode"
- STATUS: Reclassified to **No Action** — Internal Claude Code skill enhancement. Not relevant to plugin development documentation.

**/doctor command CLAUDE.md trimming check (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 19 (2.1.206) and line 28 (2.1.205): Both reference /doctor CLAUDE.md trimming
- CONFIRMED in CC changelog 2.1.206: "New `/doctor` check suggesting trimming checked-in `CLAUDE.md` files"
- Gap exists: plugin-dev CLAUDE.md guidance does not mention /doctor trimming recommendations
- Affects: plugin-settings reference (CLAUDE.md guidance), potentially skill-development
- STATUS: **CONFIRMED Must Update** — Plugin developers who create CLAUDE.md files should be aware of best practices for content that survives /doctor trimming recommendations.

**Proactive schedule offer prompts removed (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 15: "**REMOVED:** System Prompt: Proactive schedule offer after natural future follow-up and System Prompt: Strict proactive schedule offer gate"
- STATUS: Reclassified to **No Action** — This is a behavior change in Claude Code's built-in scheduling feature. Not relevant to plugin development documentation.

**MCP servers failed to connect system reminder (CC 2.1.205)**
- CONFIRMED in system-prompts changelog line 29: "**NEW:** System Reminder: MCP servers failed to connect"
- Gap: MCP integration overview does not document this new system reminder behavior
- Affects: mcp-integration reference
- STATUS: **CONFIRMED Must Update** — Plugin developers bundling MCP servers should understand how Claude Code handles connection failures.

**Security monitor transcript tampering soft block (CC 2.1.205)**
- CONFIRMED in system-prompts changelog line 38: "Adds a soft block for writing/tampering with Claude Code session transcript JSONL or forged classifier meta lines"
- CONFIRMED in CC changelog 2.1.205: "Auto mode rule blocking transcript file tampering"
- Gap: agent-development security patterns do not document this restriction
- Affects: agent-development patterns (auto mode security)
- STATUS: Reclassified to **No Action** — This is an auto-mode security rule that blocks malicious behavior. Plugin developers do not need to document or work around this; it is security infrastructure. Agents should not be tampering with transcripts.

**Verify skill narrowed project skill updates (CC 2.1.205)**
- CONFIRMED in system-prompts changelog line 39: "Skill: Verify skill — Narrows project verify-skill updates to cases where existing guidance steered the agent wrong or missed a needed step"
- STATUS: Reclassified to **No Action** — This is internal Claude Code verify skill behavior, not plugin-development API.

**Background tasks changed event schema (CC 2.1.203)**
- CONFIRMED in system-prompts changelog line 49: "**NEW:** Data: Background tasks changed event schema — Adds the `background_tasks_changed` level-event schema"
- Gap: hook-development/references/event-schemas.md does not include `background_tasks_changed` event
- Affects: hook-development reference (event-schemas.md)
- STATUS: **CONFIRMED Must Update** — This is a new hook event schema that plugin developers may need to respond to.

**Auto mode consent flow system reminder (CC 2.1.203)**
- CONFIRMED in system-prompts changelog line 51: "**NEW:** System Reminder: Auto mode consent flow"
- Gap: agent-development auto mode documentation does not cover new consent flow guidance
- Affects: agent-development patterns (auto mode)
- STATUS: Reclassified to **May Update** — This provides guidance for auto mode consent handling. Plugin agents running in auto mode may benefit from understanding this, but it is behavioral guidance rather than API change.

**SendMessageTool addressing changes for completed agents (CC 2.1.203)**
- CONFIRMED in system-prompts changelog line 74: "Tool Description: SendMessageTool — Updates cross-agent addressing so names keep working after completion"
- Gap: agent-development cross-agent communication patterns could be updated
- Affects: agent-development patterns
- STATUS: Reclassified to **May Update** — This is a behavioral improvement that plugin developers using multi-agent patterns may benefit from knowing, but existing code continues to work.

**EnterWorktree nested repository support (CC 2.1.203)**
- CONFIRMED in system-prompts changelog line 73: "Tool Description: EnterWorktree — Allows `path` entry into registered worktrees belonging to nested repositories"
- Gap: agent-development worktree documentation could mention nested repo support
- STATUS: Reclassified to **No Action** — This is an enhancement to existing functionality. The agent-development overview already covers worktree patterns adequately; this is a minor behavioral enhancement.

**Governed GitHub CLI shim (CC 2.1.202)**
- CONFIRMED in system-prompts changelog line 81: "**NEW:** Data: Governed GitHub CLI shim header and routing"
- Gap: No documentation of governed gh shim in plugin-dev
- STATUS: Reclassified to **No Action** — This is infrastructure for routing GitHub requests through agent proxy. Not directly relevant to plugin development; plugins can continue using gh normally.

**/code-review low effort minimum findings mode (CC 2.1.202)**
- CONFIRMED in system-prompts changelog line 80: "**NEW:** Agent Prompt: /code-review part 2 low effort minimum findings mode"
- STATUS: Reclassified to **No Action** — Internal Claude Code code review mode. Not plugin-development API.

**Loop execution explicit re-arming (CC 2.1.202)**
- CONFIRMED in system-prompts changelog line 85: "Skill: Dynamic pacing loop execution... Make loop re-arming an explicit per-turn decision... end loops by calling the wakeup tool with `stop: true`"
- Gap: No loop/workflow patterns documented that cover this change
- Affects: agent-development patterns (background loops)
- STATUS: Reclassified to **May Update** — This affects agents using loop/scheduling patterns. The change to explicit re-arming and `stop: true` is behavioral guidance that advanced plugin developers may benefit from.

#### Missed Items (promoted from No Action)

**Hook event streaming fix during SessionStart hooks in headless sessions (CC 2.1.204)**
- Source: CC changelog 2.1.204
- Previously classified as: Bug fix, no prompt changes
- STATUS: Remains **No Action** — Confirmed bug fix only, no prompt changes in system-prompts for 2.1.204.

**Plugin LSP server initialization fixes (CC 2.1.205)**
- Source: CC changelog 2.1.205
- Previously classified as: Bug fix
- STATUS: Promoted to **May Update** — This is specifically relevant to plugin developers using LSP integration. The lsp-integration reference should note that initialization issues were fixed in 2.1.205.

#### May Update Resolution

**Auto mode setup skill rework (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 18
- STATUS: Kept as **May Update** — Useful context for plugin developers building auto-mode workflows, but not critical documentation gap.

**Quick PR creation remote guidance (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 17
- STATUS: Demoted to **No Action** — Minor behavioral change to built-in PR creation; not plugin-development relevant.

**ClaudeDesign tool preference (CC 2.1.206)**
- CONFIRMED in system-prompts changelog line 20
- STATUS: Demoted to **No Action** — ClaudeDesign is a separate tool surface, not plugin-development API.

**Conversation/message summarization user turn counting (CC 2.1.205)**
- CONFIRMED in system-prompts changelog line 31
- STATUS: Demoted to **No Action** — Internal summarization behavior; not plugin-relevant.

**Security monitor consent and user-intent interpretation tightening (CC 2.1.203, 2.1.205)**
- CONFIRMED in system-prompts changelog lines 57, 58
- STATUS: Kept as **May Update** — Auto mode security changes that affect agent behavior in auto mode. Relevant for plugin agents but not critical.

**/review slash command sectioned PR review (CC 2.1.202)**
- CONFIRMED in system-prompts changelog line 82
- STATUS: Demoted to **No Action** — Internal /review behavior; not plugin-development API.

**PR explainer requirements expanded (CC 2.1.202)**
- CONFIRMED in system-prompts changelog line 86
- STATUS: Demoted to **No Action** — Internal skill behavior; not plugin-development API.

**Dynamic workflow size setting (CC 2.1.202)**
- Noted as "changelog only, not in system-prompts"
- CONFIRMED in CC changelog 2.1.202: "New 'Dynamic workflow size' setting for controlling agent counts"
- STATUS: Promoted to **May Update** — This setting affects workflow orchestration and could be relevant for plugin developers designing workflow patterns.

**Session working directories in MCP roots/list (CC 2.1.203)**
- Noted as "changelog only"
- CONFIRMED in CC changelog 2.1.203: "Session working directories now included in MCP `roots/list`"
- STATUS: Kept as **May Update** — Relevant for MCP integration documentation.

**Manual permission mode indicator in footer (CC 2.1.203)**
- STATUS: Demoted to **No Action** — UI indicator; not plugin-development relevant.

**Login expiration warnings (CC 2.1.203)**
- STATUS: Demoted to **No Action** — Authentication UX; not plugin-development relevant.

#### Summary

- **Must Update:** 3 items (2 confirmed, 13 reclassified to No Action or May Update)
  - /doctor CLAUDE.md trimming check (CC 2.1.206)
  - MCP servers failed to connect system reminder (CC 2.1.205)
  - background_tasks_changed event schema (CC 2.1.203)

- **May Update:** 7 items
  - Auto mode consent flow system reminder (CC 2.1.203)
  - SendMessageTool addressing changes (CC 2.1.203)
  - Loop execution explicit re-arming (CC 2.1.202)
  - Plugin LSP server initialization fixes (CC 2.1.205) — promoted
  - Auto mode setup skill rework (CC 2.1.206)
  - Security monitor consent/user-intent tightening (CC 2.1.203, 2.1.205)
  - Dynamic workflow size setting (CC 2.1.202) — promoted
  - Session working directories in MCP roots/list (CC 2.1.203)

- **No Action:** Remainder — bug fixes, internal skill changes, infrastructure not affecting plugin development API

- **Confidence:** HIGH — All items independently verified against system-prompts changelog (primary source) and CC changelog (secondary source). Most "Must Update" items were reclassified because they pertain to internal Claude Code skills and behaviors rather than plugin-development APIs. The remaining 3 items have clear documentation gaps in plugin-dev.

#### Key Findings

1. **Significant reclassification needed:** Stage 1 over-classified many internal Claude Code skill changes (artifact skills, code review skills, PR explainer, verify skill) as plugin-relevant when they are bundled Claude Code features, not plugin APIs.

2. **True plugin-relevant changes are limited:**
   - `background_tasks_changed` hook event — new event schema plugins can respond to
   - MCP connection failure guidance — affects plugin MCP server bundles
   - /doctor CLAUDE.md trimming — affects plugin CLAUDE.md best practices

3. **No missed critical items:** Scan of changelog for plugin keywords (hook, plugin, MCP, skill, agent, permission, subagent) found no additional items that should be Must Update.
