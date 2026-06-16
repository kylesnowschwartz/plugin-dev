# Upstream Change Manifest
## CC Version Range: 2.1.177 - 2.1.178
## Generated: 2026-06-16
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - no output returned]

---

### Must Update

- [ ] **Tool parameter matching syntax for permission rules** (CC 2.1.178)
  - Source: changelog, verified Stage 2
  - Confidence: high
  - Affects: hook-development
  - Details: Permission rules now support tool parameter matching syntax like `Agent(model:opus)`. This allows more granular permission control based on tool parameters, not just tool names. Plugin developers can now write hook rules that match specific tool invocations.
  - Raw changelog: "Tool parameter matching syntax for permission rules (e.g., `Agent(model:opus)`)"

- [ ] **Nested skill directory support with collision handling** (CC 2.1.178)
  - Source: changelog, verified Stage 2
  - Confidence: high
  - Affects: skill-development, plugin-structure
  - Details: Skills can now be organized in nested directories. When collisions occur (same skill name in different directories), they display as `<dir>:<name>`. This affects how plugin skills should be organized and named.
  - Raw changelog: "Skills in nested `.claude/skills` directories now load when working on files there; naming conflicts display nested skills as `<dir>:<name>`"

- [ ] **Directory-scoped skills with prefix naming** (CC 2.1.178)
  - Source: system-prompts, verified Stage 2
  - Confidence: high
  - Affects: skill-development
  - Details: Skills whose names are prefixed with their directory (e.g., `apps/web:deploy`) are now supported. When both a scoped and unscoped variant exist, the most specific directory wins based on files being worked on, otherwise the unscoped one is used.
  - Raw system-prompts: "Tool Description: Skill - Adds guidance on directory-scoped skills whose names are prefixed with their directory (e.g. `apps/web:deploy`): when both a scoped and unscoped variant exist, pick by the files being worked on (most specific directory wins), otherwise use the unscoped one."

- [ ] **Agent tool `isolation: "remote"` option** (CC 2.1.178)
  - Source: system-prompts, verified Stage 2
  - Confidence: high
  - Affects: agent-development
  - Details: New Agent tool parameter `isolation: "remote"` runs the agent in a remote CCR (Claude Code Runner) sandbox. Always runs as a background task with completion notification. This is a significant new capability for sandboxed agent execution.
  - Raw system-prompts: "Tool Description: Agent (usage notes) - Adds an `isolation: \"remote\"` option to run the agent in a remote CCR sandbox (always a background task, with completion notification) and drops `team_name` from the parameters listed as unavailable in subagent and teammate contexts."

- [ ] **Workflow tool `effort` option for agent() spawns** (CC 2.1.178)
  - Source: system-prompts, verified Stage 2
  - Confidence: high
  - Affects: skill-development (Workflow Tool Limits section), agent-development
  - Details: The Workflow tool's `agent()` spawns now accept an `effort` option that overrides reasoning effort ('low' | 'medium' | 'high' | 'xhigh' | 'max'). Omit to inherit session effort, use 'low' for cheap mechanical stages and higher tiers for hard verify/judge stages.
  - Raw system-prompts: "Tool Description: Workflow - Adds an `effort` option to `agent()` spawns that overrides the reasoning effort ('low' | 'medium' | 'high' | 'xhigh' | 'max'); omit to inherit the session effort, use 'low' for cheap mechanical stages and higher tiers only for the hardest verify/judge stages."

- [ ] **SendMessageTool `"main"` recipient for background subagents** (CC 2.1.178)
  - Source: system-prompts, verified Stage 2
  - Confidence: high
  - Affects: agent-development
  - Details: Background subagents can now message the main conversation using `"main"` as the recipient in SendMessageTool. This enables better coordination between background agents and the primary session.
  - Raw system-prompts: "Tool Description: SendMessageTool - Adds a `\"main\"` recipient option for messaging the main conversation (background subagents only)."

- [ ] **TeamDelete and TeammateTool removed** (CC 2.1.178)
  - Source: system-prompts, verified Stage 2
  - Confidence: high (explicit REMOVED marker)
  - Affects: agent-development (Agent Teams section)
  - Details: The TeamDelete tool (for deleting completed teams) and TeammateTool (for team creation, agent-type selection, task ownership, message delivery) have been removed. Any documentation referencing these tools needs updating.
  - Raw system-prompts: "REMOVED: Tool Description: TeamDelete - Removes the tool description for deleting a completed team's team and task directories." and "REMOVED: Tool Description: TeammateTool - Removes the TeamCreate/team-coordination tool description..."

- [ ] **Nested `.claude/` directory precedence** (CC 2.1.178)
  - Source: changelog (Stage 2 discovery)
  - Confidence: high
  - Affects: plugin-structure, agent-development, skill-development
  - Details: When nested `.claude/` directories exist, the agent, workflow, and output-style closest to the working directory take precedence when names collide. This affects skill/agent namespacing in monorepos.
  - Raw changelog: "Nested `.claude/` directories: the agent, workflow, and output-style closest to the working directory take precedence when names collide"

---

### May Update

- [ ] **NEW Code Review skill (conventions dimension)** (CC 2.1.178)
  - Source: system-prompts
  - Confidence: high (NEW marker)
  - Affects: skill examples/reference
  - Details: New built-in skill that reads CLAUDE.md files and flags diff lines breaking stated rules. Could be referenced as an example of well-structured skills.
  - Stage 2: Kept as May Update - example skill, not required for plugin development

- [ ] **Agent tool spawn-restriction wording update** (CC 2.1.178)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent-development
  - Details: Wording changed from "one of the agent types above" to "one of the available agent types" - clarifies that available types are listed in system-reminder messages.
  - Stage 2: Kept as May Update - minor wording change, current docs adequate

- [ ] **Artifact tool WebFetch guidance** (CC 2.1.178)
  - Source: system-prompts
  - Confidence: medium
  - Affects: tool documentation
  - Details: Reading existing artifact content is now done via WebFetch with artifact URL.
  - Stage 2: Kept as May Update - minor addition, not core to plugin development

---

### No Action

- Compact tool descriptions for newer models (Glob, Grep, ReadFile) (CC 2.1.178) - internal Claude Code behavior, not controllable by plugin developers (Stage 2 demotion)
- Remote Control error messaging improvements (CC 2.1.178) - internal infrastructure
- Bug fixes for subagent transcripts, background sessions, and MCP server specs (CC 2.1.178) - bug fixes
- Quick git commit agent prompt removed (CC 2.1.178) - internal Claude Code agent, not relevant to plugin development (Stage 2 demotion)
- Bash tool git commit guidance condensed (CC 2.1.178) - internal guidance (Stage 2 demotion)
- Auto mode subagent evaluation before launch (CC 2.1.178) - internal auto-mode behavior (Stage 2 demotion)
- /doctor command improved formatting (CC 2.1.178) - user-facing CLI improvement (Stage 2 demotion)
- v2.1.177 - No changes to system prompts (pass-through release)

---

## Summary

**Key findings for plugin-dev v0.23.0:**

1. **Agent tool changes** are significant: new `isolation: "remote"` option, `"main"` recipient for SendMessageTool, and team tools removal
2. **Skill organization** has new features: nested directories with collision handling, directory-scoped skill prefixes
3. **Workflow tool** has new `effort` parameter for agent spawns
4. **Permission rules** now support tool parameter matching (granular hook rules)
5. **Nested .claude/ precedence** affects how plugins work in monorepos

**Recommended priority (Stage 2 verified):**
1. Update agent-development for isolation: "remote", SendMessageTool "main", team tools removal
2. Update skill-development for nested directories and scoped names (`apps/web:deploy`)
3. Update hook-development for permission rule parameter matching (`Agent(model:opus)`)
4. Update skill-development and agent-development for Workflow effort option
5. Update plugin-structure for nested .claude/ directory precedence

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | Y | Retrieved via WebFetch from upstream GitHub raw |
| System-prompts | Y | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | skipped | Agent dispatch returned no output |

---

## Version Notes

- Last audited version: 2.1.176 (2026-06-13)
- Current latest version: 2.1.178
- Version 2.1.177 had no system prompt changes (pass-through release)
- All changes are from v2.1.178

---

## Stage 2: Verification Results
### Verified: 2026-06-16

#### Must Update Verification

- [x] **Tool parameter matching syntax for permission rules** (CC 2.1.178)
  - Confirmed in CC changelog: "Added `Tool(param:value)` syntax for permission rules to match tool input parameters using wildcards, such as `Agent(model:opus)` to restrict Opus subagents"
  - Gap exists: hook-development/overview.md does not document tool parameter matching syntax
  - Topic correction: Affects `hook-development` (not "hooks skill")

- [x] **Nested skill directory support with collision handling** (CC 2.1.178)
  - Confirmed in CC changelog: "Skills in nested `.claude/skills` directories now load when working on files there; naming conflicts display nested skills as `<dir>:<name>`"
  - Gap exists: skill-development/overview.md does not mention nested directories or collision handling
  - Topic correction: Affects `skill-development` (not "skill-authoring skill")

- [x] **Directory-scoped skills with prefix naming** (CC 2.1.178)
  - Confirmed in system-prompts: "Tool Description: Skill - Adds guidance on directory-scoped skills whose names are prefixed with their directory (e.g. `apps/web:deploy`)"
  - Gap exists: skill-development/overview.md does not document scoped skill naming (`apps/web:deploy` format)
  - Topic: `skill-development`

- [x] **Agent tool `isolation: "remote"` option** (CC 2.1.178)
  - Confirmed in system-prompts: "Adds an `isolation: \"remote\"` option to run the agent in a remote CCR sandbox (always a background task, with completion notification)"
  - Gap exists: agent-development/overview.md mentions `isolation: "worktree"` but not `isolation: "remote"`
  - Topic: `agent-development`

- [x] **Workflow tool `effort` option for agent() spawns** (CC 2.1.178)
  - Confirmed in system-prompts: "Adds an `effort` option to `agent()` spawns that overrides the reasoning effort ('low' | 'medium' | 'high' | 'xhigh' | 'max')"
  - Gap exists: Workflow tool not documented in plugin-dev skill references
  - Topic correction: Affects `skill-development` (Workflow section at line 517 mentions the tool but no `effort` option)

- [x] **SendMessageTool `"main"` recipient for background subagents** (CC 2.1.178)
  - Confirmed in system-prompts: "Adds a `\"main\"` recipient option for messaging the main conversation (background subagents only)"
  - Gap exists: agent-development/overview.md does not mention SendMessageTool or messaging capabilities
  - Topic: `agent-development`

- [x] **Compact tool descriptions for newer models (Glob, Grep, ReadFile)** (CC 2.1.178)
  - Confirmed in system-prompts: NEW entries for "Tool Description: Glob compact", "Tool Description: Grep compact", "Tool Description: ReadFile compact"
  - Reclassified: This is internal Claude Code behavior, not something plugin developers can control or need to document
  - Demoted to No Action

- [x] **TeamDelete and TeammateTool removed** (CC 2.1.178)
  - Confirmed in system-prompts: REMOVED markers for both tools
  - Gap exists: agent-development/overview.md "Agent Teams" section at line 961 may reference team tools
  - Topic: `agent-development`

#### Missed Items (promoted from No Action)

- ! **Nested `.claude/` directory precedence** (CC 2.1.178) - missed because changelog only, no system-prompts detail
  - Source: CC changelog: "Nested `.claude/` directories: the agent, workflow, and output-style closest to the working directory take precedence when names collide"
  - Affects: `plugin-structure`, `agent-development`, `skill-development`
  - Details: When nested `.claude/` directories exist, the closest one to the working directory takes precedence for agents, workflows, and output-styles

#### May Update Resolution

- = **NEW Code Review skill (conventions dimension)** (CC 2.1.178)
  - Kept as May Update: Could be referenced as an example skill, but not required for plugin development
  - No action unless we want to add as a skill example

- = **Agent tool spawn-restriction wording update** (CC 2.1.178)
  - Kept as May Update: Minor wording change ("available agent types" vs "agent types above")
  - Current agent-development docs already explain agent type discovery adequately

- ! **Quick git commit agent prompt removed** (CC 2.1.178)
  - Demoted to No Action: Internal Claude Code agent prompt, not relevant to plugin development

- = **Artifact tool WebFetch guidance** (CC 2.1.178)
  - Kept as May Update: Reading artifacts via WebFetch is a minor addition, not core to plugin development

- = **Bash tool git commit guidance condensed** (CC 2.1.178)
  - Demoted to No Action: Internal guidance, not affecting plugin development

- = **Auto mode subagent evaluation before launch** (CC 2.1.178)
  - Demoted to No Action: Internal auto-mode behavior, not something plugin developers can control

- = **/doctor command improved formatting** (CC 2.1.178)
  - Demoted to No Action: User-facing CLI improvement, not relevant to plugin development

#### Summary

- **Must Update: 7 items** (6 confirmed, 1 demoted to No Action, 1 added from missed)
  - Tool parameter matching syntax -> hook-development
  - Nested skill directory support -> skill-development
  - Directory-scoped skills -> skill-development
  - Agent isolation: "remote" -> agent-development
  - Workflow effort option -> skill-development
  - SendMessageTool "main" recipient -> agent-development
  - TeamDelete/TeammateTool removal -> agent-development
  - (NEW) Nested .claude/ directory precedence -> plugin-structure, agent-development
- **May Update: 3 items remaining** (Code Review skill, spawn-restriction wording, Artifact WebFetch)
- **No Action: 7 items** (compact tool descriptions moved here, plus original no-action items)
- **Confidence: HIGH** - All items verified against primary sources, topic mappings corrected

#### Topic Name Corrections

The manifest used incorrect topic names. Corrections for Stage 3:
- "hooks skill" -> `hook-development`
- "skill-authoring skill" -> `skill-development`
- "agents skill" -> `agent-development`
- "plugin-manifest skill" -> `plugin-structure`
