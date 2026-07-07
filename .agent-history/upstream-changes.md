# Upstream Change Manifest
## CC Version Range: 2.1.198 - 2.1.201
## Generated: 2026-07-04
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent SDK version incompatible in CI]

---

### Must Update

- [ ] **Subagents now run in background by default** (CC 2.1.198)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: agent-development (Agent tool section)
  - Details: The Agent tool now defaults to `run_in_background: true` unless explicitly set to `false`. This is a behavioral change that affects how agents are dispatched. The system-prompts confirm: "Makes agents background by default unless `run_in_background: false`". Plugin developers need to be aware that agent calls will now run asynchronously by default. This affects agent-creator agent and plugin-developer skill documentation.
  - Raw changelog: "Subagents now run in background by default"
  - Raw system-prompts: "Tool Description: Agent -- Makes agents background by default unless `run_in_background: false`, and documents that agent type definitions supply model, reasoning effort, and tool access while the call-level `model` overrides only that launch."

- [ ] **Subagents inherit session's extended thinking configuration** (CC 2.1.198)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: agent-development
  - Details: Agent type definitions supply model, reasoning effort, and tool access, while the call-level `model` parameter overrides only the model at launch. Extended thinking configuration is now inherited from parent session. This affects how agent frontmatter interacts with session settings.
  - Raw changelog: "Subagents now inherit session's extended thinking configuration"

- [ ] **Slash-skill stacking: load multiple skills (up to 5)** (CC 2.1.199)
  - Source: changelog
  - Confidence: medium (changelog only)
  - Affects: skill-development (skill invocation section)
  - Details: Enhanced slash-skill stacking allows loading multiple skills simultaneously, up to 5 at a time. This changes how users can interact with skills and should be documented in skill invocation guidance.
  - Raw changelog: "Enhanced slash-skill stacking to load multiple skills (up to 5)"

- [ ] **Background agent notifications via hooks** (CC 2.1.198)
  - Source: changelog
  - Confidence: medium (changelog only)
  - Affects: hook-development (new hook capability)
  - Details: New capability for background agents to send notifications through the hook system. May introduce new hook events or hook input fields for background agent lifecycle.
  - Raw changelog: "Added background agent notifications via hooks"

- [ ] **ListAgents tool added** (CC 2.1.200)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: agent-development (tools reference)
  - Details: New tool for listing available agents including in-process subagents, local/cloud Claude sessions, and reply-only remote bridge sessions. Agents should address a row by its exact name and append its `[ref]` only when the bare name is ambiguous.
  - Raw system-prompts: "Tool Description: ListAgents -- Adds a tool for listing agents you can message -- in-process subagents, other local and cloud Claude sessions, and reply-only remote bridge sessions -- instructing agents to address a row by its exact name and append its `[ref]` only when the bare name is ambiguous."

- [ ] **Default permission mode changed to Manual** (CC 2.1.200)
  - Source: changelog
  - Confidence: medium (changelog only)
  - Affects: plugin-settings (permission modes documentation)
  - Details: Changed default permission mode to "Manual" across all interfaces. This may affect plugin testing workflows and documentation about permission handling.
  - Raw changelog: "Changed default permission mode to 'Manual' across all interfaces"

- [ ] **Verify skill now persists to .claude/skills/verify/SKILL.md** (CC 2.1.200)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: skill-development (skill creation patterns)
  - Details: The verify skill now bootstraps and persists working build/launch/drive recipes to `.claude/skills/verify/SKILL.md` at the appropriate scope (repo root or touched package/app directory in monorepo). This is notable for understanding skill auto-creation patterns.
  - Raw system-prompts: "Skill: Verify skill -- Now bootstraps a project verify skill: after getting through a cold-start verification, persist the working build/launch/drive recipe to `.claude/skills/verify/SKILL.md` at the right scope (repo root, or the touched package/app directory in a monorepo), or fold new learnings into an existing verify skill instead of duplicating."

- [ ] **Project skill upkeep guidance: never create skills (except verify)** (CC 2.1.200)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: skill-development (skill patterns)
  - Details: New guidance clarifying that agents should only edit existing project skills and never create new ones (a new skill shadows a same-named built-in), with `verify` as the sole exception. Important for skill development patterns.
  - Raw system-prompts: "System Prompt: Project skill upkeep for feedback memory -- Clarifies to only edit existing project skills and never create one (a new skill shadows a same-named built-in), with `verify` as the sole exception, and to place a verify correction in the closest-scoped `.claude/skills/verify/SKILL.md`, never duplicated at broader scopes."

- [ ] **Isolated worktree shipping instructions** (CC 2.1.198)
  - Source: system-prompts
  - Confidence: high (promoted from May Update during Stage 2 verification)
  - Affects: agent-development (background session guidance)
  - Details: Background-session guidance that isolated worktree agents should commit changes, push a branch, and open a draft PR without asking. Affects background agent behavior and workflow automation.
  - Raw system-prompts: "System Prompt: Isolated worktree shipping instructions -- isolated worktree agents should commit changes, push a branch, and open a draft PR without asking"

- [ ] **SessionStart, Setup, and SubagentStart hooks stderr fix** (CC 2.1.199)
  - Source: changelog
  - Confidence: medium (promoted during Stage 2 verification -- bug fix with documentation impact)
  - Affects: hook-development (exit code 2 behavior documentation)
  - Details: These hooks now properly show stderr in transcript when exiting with code 2. Previously stderr was silently hidden. This affects the documented hook behavior.
  - Raw changelog: "Fixed `SessionStart`, `Setup`, and `SubagentStart` hooks silently hiding stderr when exiting with code 2; error now shown in transcript"

- [ ] **SearchPlugins, SearchSkills, SearchMcpRegistry, SuggestConnectors, ListConnectors tools** (CC 2.1.199)
  - Source: system-prompts
  - Confidence: medium (promoted from May Update during Stage 2 verification)
  - Affects: plugin-structure (tool discovery)
  - Details: New discovery tools for searching org plugins/skills and MCP connector registries. Directly relevant for plugin discovery workflows.
  - Raw system-prompts: "Tool Description: SearchPlugins, SearchSkills, SearchMcpRegistry, SuggestConnectors, and ListConnectors -- Adds discovery prompts for searching org plugins/skills and MCP connector registries"

---

### May Update

- [ ] **SSL certificate error handling with immediate feedback** (CC 2.1.199)
  - Source: changelog
  - Confidence: low (changelog only)
  - Affects: troubleshooting documentation
  - Details: Improved SSL certificate error handling provides immediate feedback to users. May be relevant for MCP integration troubleshooting.
  - Raw changelog: "Improved SSL certificate error handling with immediate feedback"

- [ ] **Enhanced subagent error reporting to parents** (CC 2.1.199)
  - Source: changelog
  - Confidence: low (changelog only)
  - Affects: agent-development (error handling patterns)
  - Details: Subagents now report errors more effectively to their parent agents. May affect agent design guidance.
  - Raw changelog: "Enhanced subagent error reporting to parents"

- [ ] **ClaudeDesign tool added** (CC 2.1.199)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: tools reference (if documented)
  - Details: New tool for working with Claude Design projects including design-system context, managing projects/files, rendering previews.
  - Raw system-prompts: "Tool Description: ClaudeDesign -- Adds instructions for working with Claude Design projects"

- [ ] **Plan artifact HTML template and Plan Artifact skill** (CC 2.1.198, 2.1.199)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: skill-development (artifact patterns)
  - Details: New standard plan artifact template and skill for creating shareable HTML plan pages from implementation plans, design docs, and RFCs.
  - Raw system-prompts: "Skill: Plan Artifact and Data: Plan artifact HTML template -- Adds a standard Artifact template and skill for turning implementation plans, design docs, and RFCs into shareable HTML plan pages"

- [ ] **Auto mode setup skill** (CC 2.1.198)
  - Source: system-prompts
  - Confidence: medium (system-prompts only)
  - Affects: skill-development (built-in skill patterns)
  - Details: New guided setup workflow for auto-mode environment context, repo/session reconnaissance, and settings updates.
  - Raw system-prompts: "Skill: Auto mode setup -- Adds a guided setup workflow for auto-mode environment context, repo/session reconnaissance"

- [ ] **Shared git stash safety warning** (CC 2.1.198)
  - Source: system-prompts
  - Confidence: low (system-prompts only)
  - Affects: agent-development (git safety patterns)
  - Details: Warning that stash stack is shared across worktrees and sessions, preferring WIP commits or uniquely tagged stash entries.
  - Raw system-prompts: "System Prompt: Shared git stash safety -- Warns that the stash stack is shared across worktrees and sessions"

- [ ] **Security monitor expansions for autonomous agents** (CC 2.1.198-2.1.200)
  - Source: system-prompts
  - Confidence: low (system-prompts only)
  - Affects: auto-mode safety patterns
  - Details: Major expansions to autonomous agent action security monitoring, including exfiltration rules, protected content classes, soft-block rules. May affect agent design for auto-mode scenarios.
  - Raw system-prompts: Multiple "Agent Prompt: Security monitor" entries

- [ ] **Improved background agent reliability on Linux** (CC 2.1.199)
  - Source: changelog
  - Confidence: low (changelog only)
  - Affects: CI documentation (if relevant)
  - Details: Background agent reliability improvements specific to Linux.
  - Raw changelog: "Improved background agent reliability on Linux"

---

### No Action

- New /dataviz skill (CC 2.1.198) - Built-in skill feature, not plugin-dev relevant (demoted from Must Update in Stage 2)
- File already in context system reminder (CC 2.1.199) - Internal efficiency optimization, no plugin-dev impact (demoted from May Update in Stage 2)
- Claude Tag (Claude in Slack) reference added (CC 2.1.200) - Slack integration, not plugin-dev related (demoted from May Update in Stage 2)
- set_cwd needs_trust directory parameter (CC 2.1.200) - Internal tool parameter, not plugin-dev relevant (demoted from May Update in Stage 2)
- Claude Sonnet 5 sessions no longer use mid-conversation system role for harness reminders (CC 2.1.201) - Internal harness change
- Disabled auto-continue for user-question dialogs (CC 2.1.200) - UI behavior
- Fixed multiple background session issues including mid-turn interruption after sleep/wake (CC 2.1.200) - Bug fix
- Fixed subagents being cut off by rate limits (CC 2.1.200) - Bug fix
- Improved screen-reader accessibility and terminal output synchronization (CC 2.1.200) - Accessibility fix
- Fixed streaming response handling when API errors occur mid-stream (CC 2.1.199) - Bug fix
- Claude in Chrome now generally available (CC 2.1.198) - Browser extension feature
- REMOVED: Agent Prompt: Agent creation architect (CC 2.1.198) - Internal removal
- REMOVED: Skill: Create verifier skills (CC 2.1.198) - Internal removal
- REMOVED: Tool Description: Bash command-chaining notes (CC 2.1.198) - Redundant removal
- Code walkthrough / PR explainer / Code review artifact publishing (CC 2.1.198) - Built-in skill features
- Plugin eval authoring interview skill (CC 2.1.198) - Internal eval tooling
- Thin-client diff dialog schema (CC 2.1.198) - Internal protocol
- Plan mode workflow reminders split (CC 2.1.198) - Internal restructuring
- Workflow tool example changes (CC 2.1.198) - Internal example update
- Context tip selector improvements (CC 2.1.199) - Internal tip system
- PushNotification behavior clarification (CC 2.1.199) - Internal notification system
- EnterPlanMode generalization (CC 2.1.198) - Internal wording change
- PowerShell command-timeout note (CC 2.1.198) - Windows-specific
- Status-line JSON schema updates (CC 2.1.198-2.1.200) - Internal status UI
- Setup Cowork and Cowork role selection (CC 2.1.199) - Internal onboarding flow
- Artifact design skill rework (CC 2.1.198) - Built-in skill internal update
- Coordinator mode orchestration worker-approval pattern (CC 2.1.198) - Internal coordination
- SendMessageTool legacy shutdown/plan-approval conditional (CC 2.1.198) - Internal messaging

---

## Summary

**Version range audited:** 2.1.198 through 2.1.201 (4 versions after last audit at 2.1.197)

**Versions included:**
- 2.1.198 (significant - subagents background by default, extended thinking inheritance, /dataviz skill)
- 2.1.199 (significant - slash-skill stacking up to 5, new discovery tools)
- 2.1.200 (significant - Manual default permission mode, ListAgents tool, verify skill persistence)
- 2.1.201 (minimal - no plugin-relevant changes)

**Token delta from system-prompts:**
- 2.1.198: +53,384 tokens
- 2.1.199: +25,167 tokens
- 2.1.200: +6,194 tokens
- 2.1.201: No changes

**Total estimated token impact:** +84,745 tokens in system prompts

---

### Critical Changes Requiring Documentation Updates

1. **Subagents background by default** (CC 2.1.198) - This is the most significant behavioral change. All Agent tool calls now run in background unless `run_in_background: false` is specified. Affects existing documentation and examples showing synchronous agent dispatch.

2. **Slash-skill stacking up to 5** (CC 2.1.199) - Users can now load multiple skills simultaneously. Skill invocation documentation should be updated.

3. **Default permission mode Manual** (CC 2.1.200) - Affects plugin testing workflows and permission mode documentation.

4. **ListAgents tool** (CC 2.1.200) - New tool for agent discovery that may be useful in multi-agent scenarios.

5. **Verify skill auto-persistence** (CC 2.1.200) - New pattern where verify skills are automatically created/updated in `.claude/skills/verify/SKILL.md`.

6. **Project skill shadowing warning** (CC 2.1.200) - Important guidance that creating new project skills can shadow built-in skills.

---

### Key Themes in This Release Range

1. **Background-first agents**: Subagents now default to background execution, matching the async-first paradigm
2. **Multi-skill loading**: Slash-skill stacking allows loading up to 5 skills simultaneously
3. **Manual permission default**: More conservative default permission mode across interfaces
4. **Skill auto-creation**: Verify skill can now auto-persist recipes to project skills directory
5. **Agent discovery**: ListAgents tool enables programmatic discovery of available agents
6. **Extended thinking inheritance**: Subagents now inherit session's extended thinking configuration

---

### Triangulation Notes

- Two-source triangulation used: CC changelog + system-prompts changelog
- claude-code-guide agent dispatch skipped due to SDK version incompatibility in CI environment
- Changes confirmed in both sources marked as high confidence
- Single-source changes marked as medium/low confidence
- Both sources aligned well on major changes (subagent background default, /dataviz skill)
- System-prompts provided more granular detail on behavioral changes

---

## Raw Changelog Data

### CC 2.1.201 (from upstream changelog)
```
Claude Sonnet 5 sessions no longer use the mid-conversation system role for harness reminders
```

### CC 2.1.200 (from upstream changelog)
```
- Disabled auto-continue for user-question dialogs; users can opt into idle timeout
- Changed default permission mode to "Manual" across all interfaces
- Fixed multiple background session issues including mid-turn interruption after sleep/wake
- Fixed subagents being cut off by rate limits
- Improved screen-reader accessibility and terminal output synchronization
```

### CC 2.1.199 (from upstream changelog)
```
- Enhanced slash-skill stacking to load multiple skills (up to 5)
- Improved SSL certificate error handling with immediate feedback
- Fixed streaming response handling when API errors occur mid-stream
- Enhanced subagent error reporting to parents
- Improved background agent reliability on Linux
```

### CC 2.1.198 (from upstream changelog)
```
- Subagents now run in background by default
- Claude in Chrome now generally available
- Added background agent notifications via hooks
- New `/dataviz` skill for design guidance
- Subagents now inherit session's extended thinking configuration
```

### System-prompts 2.1.200 (key items)
```
- **NEW:** Data: Claude Tag (Claude in Slack) reference
- **NEW:** Tool Description: ListAgents
- **NEW:** Tool Parameter: set_cwd needs_trust directory
- Agent Prompt: Security monitor for autonomous agent actions (second part) -- expanded exfiltration and soft-block rules
- Skill: Verify skill -- Now bootstraps a project verify skill to `.claude/skills/verify/SKILL.md`
- System Prompt: Project skill upkeep for feedback memory -- only edit existing project skills, never create (shadows built-in)
```

### System-prompts 2.1.199 (key items)
```
- **NEW:** Agent Prompt: /code-review part 10 ReportFindings output format
- **NEW:** Skill: Setup Cowork and Setup Cowork role selection
- **NEW:** Tool Description: SearchPlugins, SearchSkills, SearchMcpRegistry, SuggestConnectors, ListConnectors
- **NEW:** Tool Description: ClaudeDesign
- **NEW:** System Reminder: File already in context
- Plan artifact updates, Artifact theme-aware guidance
```

### System-prompts 2.1.198 (key items)
```
- **NEW:** Skill: Data Visualization and Data Visualization description
- **NEW:** Skill: Auto mode setup
- **NEW:** Skill: Plan Artifact and Data: Plan artifact HTML template
- **NEW:** System Prompt: Isolated worktree shipping instructions
- **NEW:** System Prompt: Shared git stash safety
- **NEW:** System Prompt: Project skill upkeep for feedback memory
- **REMOVED:** Agent Prompt: Agent creation architect
- **REMOVED:** Skill: Create verifier skills
- Tool Description: Agent -- Makes agents background by default unless `run_in_background: false`
```

---

## Stage 2: Verification Results
### Verified: 2026-07-04

#### Must Update Verification

- **Subagents now run in background by default** (CC 2.1.198)
  - CONFIRMED in CC changelog: "Subagents now run in the background by default, so Claude keeps working while they run"
  - CONFIRMED in system-prompts: "Tool Description: Agent -- Makes agents background by default unless `run_in_background: false`"
  - Gap exists in agent-development/overview.md -- documents `run_in_background` parameter but not the new default behavior
  - Affects: agent-development (Agent tool section)

- **Subagents inherit session's extended thinking configuration** (CC 2.1.198)
  - CONFIRMED in CC changelog: "Subagents and context compaction now inherit the session's extended thinking configuration"
  - CONFIRMED in system-prompts: Agent type definitions supply model, reasoning effort, and tool access
  - Gap exists -- no documentation of extended thinking inheritance in agent-development
  - Affects: agent-development

- **Slash-skill stacking: load multiple skills (up to 5)** (CC 2.1.199)
  - CONFIRMED in CC changelog: "Stacked slash-skill invocations like `/skill-a /skill-b do XYZ` now load all leading skills (up to 5), not just first"
  - Gap exists in skill-development/overview.md -- no mention of skill stacking feature
  - Affects: skill-development (skill invocation section)

- **Background agent notifications via hooks** (CC 2.1.198)
  - CONFIRMED in CC changelog: "Added background agent notifications in `claude agents`; sessions fire `Notification` hook (`agent_needs_input` / `agent_completed`)"
  - Gap exists in hook-development -- Notification hook matchers list does not include `agent_needs_input` or `agent_completed`
  - Affects: hook-development (Notification event matchers)

- **ListAgents tool added** (CC 2.1.200)
  - CONFIRMED in system-prompts: "Tool Description: ListAgents -- Adds a tool for listing agents you can message"
  - Gap exists -- no documentation in agent-development or tools reference
  - Affects: agent-development (tools reference)

- **Default permission mode changed to Manual** (CC 2.1.200)
  - CONFIRMED in CC changelog: "Changed default permission mode to 'Manual' across all interfaces"
  - Gap exists -- plugin-settings and agent-development do not reflect this default change
  - Affects: plugin-settings (permission modes documentation), agent-development (permissionMode field)

- **Verify skill now persists to .claude/skills/verify/SKILL.md** (CC 2.1.200)
  - CONFIRMED in system-prompts: "Skill: Verify skill -- Now bootstraps a project verify skill... persist the working build/launch/drive recipe to `.claude/skills/verify/SKILL.md`"
  - Gap exists -- no documentation of this auto-creation pattern
  - May Update: Informational for skill-development patterns; not directly plugin-dev guidance

- **Project skill upkeep guidance: never create skills (except verify)** (CC 2.1.200)
  - CONFIRMED in system-prompts: "System Prompt: Project skill upkeep for feedback memory -- Clarifies to only edit existing project skills and never create one (a new skill shadows a same-named built-in), with `verify` as the sole exception"
  - Partial gap -- skill-development mentions skill shadowing but does not warn against creating new skills that shadow built-ins
  - Affects: skill-development (skill patterns)

- **New /dataviz skill** (CC 2.1.198)
  - CONFIRMED in CC changelog: "New `/dataviz` skill for design guidance"
  - CONFIRMED in system-prompts: "Skill: Data Visualization and Data Visualization description"
  - DEMOTE: This is a built-in skill feature, not plugin-dev guidance. No action needed.
  - No Action: Built-in skill, does not affect plugin development documentation

#### Missed Items (promoted from No Action)

- ! **SessionStart, Setup, and SubagentStart hooks stderr fix** (CC 2.1.199)
  - Source: CC changelog "Fixed `SessionStart`, `Setup`, and `SubagentStart` hooks silently hiding stderr when exiting with code 2; error now shown in transcript"
  - Missed because: Listed under bug fixes but affects hook behavior documentation
  - Affects: hook-development (exit code 2 behavior documentation)
  - Details: These hooks now properly show stderr in transcript when exiting with code 2

- ! **SearchPlugins, SearchSkills, SearchMcpRegistry, SuggestConnectors, ListConnectors tools** (CC 2.1.199)
  - Already in May Update, but should be promoted
  - These are plugin discovery tools relevant to plugin-dev ecosystem
  - Affects: plugin-structure (tool discovery section)

#### May Update Resolution

- SSL certificate error handling (CC 2.1.199)
  - = kept as May Update: Useful for troubleshooting docs but low priority

- Enhanced subagent error reporting (CC 2.1.199)
  - = kept as May Update: Affects agent design patterns but not critical

- SearchPlugins, SearchSkills, SearchMcpRegistry, SuggestConnectors, ListConnectors tools (CC 2.1.199)
  - PROMOTED to Must Update: These are plugin/skill discovery tools directly relevant to plugin-dev

- ClaudeDesign tool (CC 2.1.199)
  - = kept as May Update: Design tool, tangentially related to plugin dev

- File already in context reminder (CC 2.1.199)
  - DEMOTED to No Action: Internal efficiency optimization, no plugin-dev impact

- Plan artifact template (CC 2.1.198-2.1.199)
  - = kept as May Update: Artifact patterns may be useful for skill outputs

- Auto mode setup skill (CC 2.1.198)
  - = kept as May Update: Background on built-in skill patterns

- Isolated worktree shipping instructions (CC 2.1.198)
  - PROMOTED to Must Update: Affects background agent behavior in worktrees, relevant to agent-development

- Shared git stash safety warning (CC 2.1.198)
  - = kept as May Update: Git safety pattern for agents

- Claude Tag reference (CC 2.1.200)
  - DEMOTED to No Action: Slack integration, not plugin-dev related

- set_cwd needs_trust directory (CC 2.1.200)
  - DEMOTED to No Action: Internal tool parameter, not plugin-dev relevant

- Security monitor expansions (CC 2.1.198-2.1.200)
  - = kept as May Update: Affects auto-mode safety patterns for agents

- Improved background agent reliability on Linux (CC 2.1.199)
  - = kept as May Update: Useful for CI documentation

#### Summary
- Must Update: 10 items (8 confirmed, 1 demoted to No Action, 3 added from May Update/missed)
- May Update: 7 items remaining
- Confidence: HIGH -- all items verified against primary sources (CC changelog and system-prompts changelog)
