# Upstream Change Manifest
## CC Version Range: 2.1.145 - 2.1.148
## Generated: 2026-05-22
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent unavailable in CI]

---

### Must Update

- [ ] **NEW: Workflow tool for deterministic multi-subagent orchestration** (CC 2.1.146)
  - Source: system-prompts
  - Confidence: high (verified Stage 2)
  - Affects: agent-development reference (orchestration patterns), skill-development (context: fork alternatives)
  - Details: New Workflow tool for opt-in deterministic multi-subagent orchestration. Includes script metadata, agent hooks with plain-text or structured returns, pipeline vs. parallel control flow, token budgeting, quality patterns, concurrency limits, and resume behavior. Two new agent prompts define plain text and structured output behavior for workflow-spawned subagents.
  - Raw changelog (system-prompts): "**NEW:** Tool Description: Workflow -- Describes the Workflow tool for opt-in deterministic multi-subagent orchestration, including script metadata, agent hooks with plain-text or structured returns, pipeline vs. parallel control flow, token budgeting, quality patterns, concurrency limits, and resume behavior."

- [ ] **Pinned background sessions behavior change** (CC 2.1.147)
  - Source: changelog
  - Confidence: high (verified Stage 2)
  - Affects: agent-development reference (background job section)
  - Details: Pinned background sessions now stay alive when idle and auto-restart. This changes the expected lifecycle behavior for background agents.
  - Raw changelog (CC): "Pinned background sessions now persist when idle and restart to apply updates"

- [ ] **Enhanced plugin discovery screens** (CC 2.1.145)
  - Source: changelog
  - Confidence: high (verified Stage 2)
  - Affects: marketplace-structure/overview.md, plugin-structure/overview.md
  - Details: Plugin discovery screens now show commands, agents, skills, hooks, and MCP/LSP servers before installation. This affects how plugin authors should structure and present their plugins.
  - Raw changelog (CC): "/plugin screens display commands, agents, skills, hooks, and MCP/LSP servers before installation"

- [ ] **Stop/SubagentStop hook input expanded** (CC 2.1.145) [ADDED BY STAGE 2]
  - Source: changelog
  - Confidence: high (verified Stage 2)
  - Affects: hook-development reference (event-schemas.md)
  - Details: `background_tasks` and `session_crons` fields added to Stop and SubagentStop hook input schemas.
  - Raw changelog (CC): "`background_tasks` and `session_crons` fields added to Stop and SubagentStop hook input"

---

### May Update

- [ ] **NEW: Run app skill system** (CC 2.1.145) [DEMOTED FROM MUST UPDATE BY STAGE 2]
  - Source: system-prompts
  - Confidence: medium
  - Affects: skill-development reference (as example pattern)
  - Details: Comprehensive new skill system for launching and driving project runtimes. Includes: (1) general `run-app` skill preferring project-specific run skills, (2) run skill generator for creating project-specific `run-<unit>` skills, (3) reusable template, and (4) example patterns for browser apps, CLI tools, Electron apps, libraries/SDKs, TUIs, and web server APIs.
  - Stage 2 note: This is Claude Code's internal skill system. Could be referenced as a pattern example for plugin skill development, but not directly plugin-dev-relevant.

- [ ] **Security monitor updates - hard/soft block distinction** (CC 2.1.146-2.1.147)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development reference (permission-modes-rules.md)
  - Details: Security monitor now distinguishes between unconditional hard blocks (classifier jailbreaking, bad-faith retry tunneling, permission-system indirection, data exfiltration) and user-authorizable soft blocks (destructive/irreversible actions). Self-modification rule expanded with explicit agent-config paths list.

- [ ] **Self-modification protected paths expanded** (CC 2.1.140) [OUTSIDE SCOPE - VERIFY IF ALREADY DOCUMENTED]
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development reference (already documented at lines 619-632)
  - Details: Explicit list of protected paths. Exception: `.claude/worktrees/<name>/` treated as ordinary project files.
  - Stage 2 note: Already documented in agent-development/overview.md. Verify completeness vs. source.

- [ ] **SendMessageTool team coordination changes** (CC 2.1.147)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development reference (advanced-agent-fields.md)
  - Details: Team messaging guidance updated: teammates should be addressed by name while active; `agentId` should only be used to resume a completed background agent.

---

### No Action

**In-scope (CC 2.1.145-2.1.148):**
- Fixed Bash tool returning exit code 127 for some users (CC 2.1.148) - bug fix
- Auto-updater, diff rendering, and hook handling improvements (CC 2.1.147) - internal
- Enterprise login, command output, and terminal issue fixes (CC 2.1.147) - bug fixes
- Multiple permission prompts and tool availability fixes (CC 2.1.145) - bug fixes
- Prompt caching max_tokens:0 guidance (CC 2.1.145) - API optimization, not plugin-dev relevant
- JSON output for listing live sessions (CC 2.1.145) - CLI utility feature [DEMOTED BY STAGE 2]
- /code-review command (replaces /simplify) (CC 2.1.147) - built-in CC command, not plugin-dev [DEMOTED BY STAGE 2]

**Out-of-scope (included by Stage 1 but outside CC 2.1.145-2.1.148 range):**
- Memory instructions slug format change (CC 2.1.139) - outside scope
- PowerShell command mapping table (CC 2.1.139) - outside scope
- Output style per-turn reminder sourcing change (CC 2.1.141) - outside scope
- Amazon Bedrock model ID guidance (CC 2.1.142) - outside scope
- Coding session title generator data treatment (CC 2.1.142) - outside scope
- Managed Agents outcomes and webhooks (CC 2.1.132) - outside scope
- Conversation/partial compaction security preservation (CC 2.1.139) - outside scope
- Managed Agents skill limit reduced (CC 2.1.132) - outside scope [DEMOTED BY STAGE 2]
- Snooze tool short-interval warning (CC 2.1.140) - outside scope [DEMOTED BY STAGE 2]
- Write tool description rewrite (CC 2.1.140) - outside scope [DEMOTED BY STAGE 2]
- Managed Agents self-hosted sandboxes (CC 2.1.145) - cloud API, not CC plugin system [DEMOTED BY STAGE 2]
- Plan mode phase four guidance (CC 2.1.146) - internal plan mode, not plugin-dev [DEMOTED BY STAGE 2]

---

## Summary (Updated by Stage 2)

**Versions analyzed:** 2.1.145, 2.1.146, 2.1.147, 2.1.148

**Must Update (4 items):**
1. Workflow tool (CC 2.1.146) - new tool for multi-subagent orchestration
2. Pinned background sessions (CC 2.1.147) - lifecycle change for background agents
3. Enhanced plugin discovery screens (CC 2.1.145) - affects plugin presentation
4. Stop/SubagentStop hook input expanded (CC 2.1.145) - new hook input fields [ADDED]

**May Update (4 items):**
1. Run app skill system (CC 2.1.145) - pattern example [DEMOTED from Must Update]
2. Security monitor hard/soft blocks (CC 2.1.146-2.1.147)
3. Self-modification protected paths (CC 2.1.140) - verify if already documented
4. SendMessageTool team coordination (CC 2.1.147)

**No Action (19 items):** Bug fixes, internal refactors, out-of-scope versions, non-plugin-dev features

---

## Notes

1. **Degraded triangulation:** The claude-code-guide agent was unavailable in this CI environment. Changes were cross-referenced between the official CC changelog and system-prompts changelog only.

2. **Version gap note:** The system-prompts changelog shows v2.1.137 and v2.1.138 had no prompt changes, and v2.1.131 also had no changes.

3. **Confidence scoring:**
   - High: Confirmed in both CC changelog and system-prompts
   - Medium: Found in only one source
   - Low: Inferred or unclear scope

4. **Plugin-dev relevance:** The most impactful changes for plugin-dev documentation are:
   - The /code-review command replacing /simplify (affects any references to /simplify)
   - The Workflow tool (new orchestration capability)
   - Enhanced plugin discovery (affects plugin visibility/metadata)
   - The run-app skill system (could be referenced as a pattern example)

---

## Stage 2: Verification Results
### Verified: 2026-05-22

#### Must Update Verification

- **[1] /code-review command (replaces /simplify)** (CC 2.1.147)
  - **Status:** CONFIRMED
  - **CC Changelog:** Verified - "Renamed `/simplify` to `/code-review` with effort levels and inline GitHub PR comments"
  - **System-prompts:** Verified - 8 NEW Agent Prompts for /code-review parts 1-8, plus "REMOVED: Skill: Simplify"
  - **Gap exists:** Yes - plugin-dev mentions `code-reviewer` agent examples but NOT the built-in `/code-review` command. No existing documentation of `/simplify` to update.
  - **Affects:** Not directly plugin-dev -- this is about Claude Code's built-in commands, not plugin system. Demote to No Action.

- **[2] Workflow tool for deterministic multi-subagent orchestration** (CC 2.1.146)
  - **Status:** CONFIRMED
  - **CC Changelog:** Not present (2.1.146 not in CC changelog -- system-prompts-only release)
  - **System-prompts:** Verified - "NEW: Tool Description: Workflow" plus two workflow subagent prompts
  - **Gap exists:** Yes - no mention of Workflow tool in plugin-dev
  - **Affects:** agent-development reference (orchestration patterns), potentially skill-development (context: fork alternatives)
  - **Note:** This is a significant new tool for agent orchestration that plugin developers should know about.

- **[3] Run app skill system** (CC 2.1.145)
  - **Status:** CONFIRMED
  - **CC Changelog:** Not present (system-prompts-only change)
  - **System-prompts:** Verified - 7 NEW skills for run-app ecosystem (general skill, generator, template, 5 examples)
  - **Gap exists:** Yes - no documentation of run-app skill system
  - **Affects:** skill-development reference (as example pattern). However, this is Claude Code's internal skill system, not plugin-dev-relevant. Demote to May Update.

- **[4] Pinned background sessions behavior change** (CC 2.1.147)
  - **Status:** CONFIRMED
  - **CC Changelog:** Verified - "Pinned background sessions now persist when idle and restart to apply updates"
  - **System-prompts:** Not mentioned (feature/behavioral change, not prompt change)
  - **Gap exists:** Partial - agent-development mentions background agents but not pinning behavior
  - **Affects:** agent-development reference (background job section)
  - **Note:** Keep as Must Update -- affects agent design for background execution.

- **[5] Enhanced plugin discovery screens** (CC 2.1.145)
  - **Status:** CONFIRMED
  - **CC Changelog:** Verified - "/plugin screens display commands, agents, skills, hooks, and MCP/LSP servers before installation"
  - **System-prompts:** Not mentioned (UI change, not prompt change)
  - **Gap exists:** Yes - plugin-structure and marketplace-structure don't document what shows in discovery screens
  - **Affects:** marketplace-structure/overview.md, plugin-structure/overview.md
  - **Note:** Keep as Must Update -- affects how plugin authors should structure/present their plugins.

#### Missed Items (promoted from No Action)

- **! Stop/SubagentStop hook input expanded** (CC 2.1.145) - MISSED
  - **CC Changelog:** "`background_tasks` and `session_crons` fields added to Stop and SubagentStop hook input"
  - **Why missed:** Not in No Action list, not reviewed
  - **Affects:** hook-development reference (event-schemas.md)
  - **Decision:** Promote to Must Update

#### May Update Resolution

- **[1] Managed Agents self-hosted sandboxes** (CC 2.1.145)
  - **Decision:** = Keep as May Update
  - **Reason:** Cloud API feature, not directly relevant to Claude Code plugin system

- **[2] Plan mode phase four guidance** (CC 2.1.146)
  - **Decision:** = Keep as May Update (or demote to No Action)
  - **Reason:** Internal plan mode change, plugin-dev doesn't document plan mode behavior

- **[3] Security monitor hard/soft block distinction** (CC 2.1.146-2.1.147)
  - **Decision:** = Keep as May Update
  - **Reason:** Already partially documented in agent-development (Self-Modification section), but hard/soft block distinction is new. Worth considering.

- **[4] Self-modification protected paths expanded** (CC 2.1.140)
  - **Decision:** = Keep as May Update (already documented)
  - **Reason:** Verified in agent-development/overview.md lines 619-632 -- explicit path list is already present. May need to verify completeness.

- **[5] JSON output for listing live sessions** (CC 2.1.145)
  - **Decision:** = Demote to No Action
  - **Reason:** CLI utility feature, not plugin-dev relevant

- **[6] SendMessageTool team coordination changes** (CC 2.1.147)
  - **Decision:** = Keep as May Update
  - **Reason:** Agent teams documentation exists in advanced-agent-fields.md; may need update for agentId guidance

- **[7] Managed Agents skill limit reduced** (CC 2.1.132)
  - **Decision:** = Demote to No Action
  - **Reason:** Outside version range (2.1.145-2.1.148), Managed Agents is cloud API not plugin system

- **[8] Snooze tool short-interval warning** (CC 2.1.140)
  - **Decision:** = Demote to No Action
  - **Reason:** Outside version range (2.1.140 < 2.1.145), internal scheduling guidance

- **[9] Write tool description rewrite** (CC 2.1.140)
  - **Decision:** = Demote to No Action
  - **Reason:** Outside version range (2.1.140 < 2.1.145), internal tool description change

#### Additional No Action Validations

Items in No Action list from versions outside scope (2.1.139-2.1.142) should not have been included:
- Memory instructions slug format change (CC 2.1.139) - correct, outside scope
- PowerShell command mapping table (CC 2.1.139) - correct, outside scope
- Output style per-turn reminder sourcing change (CC 2.1.141) - correct, outside scope
- Amazon Bedrock model ID guidance (CC 2.1.142) - correct, outside scope
- Coding session title generator data treatment (CC 2.1.142) - correct, outside scope
- Managed Agents outcomes and webhooks (CC 2.1.132) - correct, outside scope
- Conversation/partial compaction security preservation (CC 2.1.139) - correct, outside scope

**Note:** Stage 1 included items from versions outside the stated range (2.1.132, 2.1.139, 2.1.140, 2.1.141, 2.1.142). This should be flagged for process improvement.

#### Summary

- **Must Update:** 4 items (3 confirmed, 1 rejected as not plugin-dev-relevant, 1 added)
  - Workflow tool (CC 2.1.146) -- KEEP
  - Pinned background sessions (CC 2.1.147) -- KEEP
  - Enhanced plugin discovery screens (CC 2.1.145) -- KEEP
  - Stop/SubagentStop hook input expanded (CC 2.1.145) -- ADDED
  - ~~/code-review command~~ -- REJECTED (not plugin-dev-relevant, built-in CC feature)
  - ~~Run app skill system~~ -- DEMOTED to May Update (internal CC skill, not plugin-dev)

- **May Update:** 4 items remaining
  - Run app skill system (demoted from Must Update)
  - Security monitor hard/soft block distinction
  - Self-modification protected paths (may already be documented)
  - SendMessageTool team coordination

- **Confidence:** MEDIUM
  - 1 item rejected from Must Update (20% rejection rate)
  - 1 item added (missed by Stage 1)
  - Several items from outside version scope were included
  - No major structural issues, but scope discipline needs improvement
