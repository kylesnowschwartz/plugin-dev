# Upstream Change Manifest
## CC Version Range: 2.1.139 - 2.1.143
## Generated: 2026-05-16
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - timed out in CI]

---

### Must Update

- [ ] **NEW: SendUserFile tool** (CC 2.1.142)
  - Source: system-prompts
  - Confidence: high
  - Affects: hook-development (new tool to match), agent-development (agents generating deliverables)
  - Details: New tool for surfacing generated deliverable files to the user with optional captions and normal or proactive status. Plugin developers creating skills that generate artifacts (reports, files, exports) should be aware of this tool for better user experience.
  - Raw: "**NEW:** Tool Description: SendUserFile - Describes the SendUserFile tool for surfacing generated deliverable files to the user, with optional captions and normal or proactive status."

- [ ] **NEW: Agent tool simplified usage notes** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development reference
  - Details: New simplified usage notes added to Agent tool description covering: when to delegate, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions. This provides clearer reference for plugin authors using the Agent tool in skills or creating agent definitions.
  - Raw: "**NEW:** Tool Description: Agent (simple usage notes) - Simplified usage notes for the Agent tool covering when to delegate, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions."

- [ ] **Security monitor: explicit agent-config paths for Self-Modification rule** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (agents modifying config), hook-development (hooks targeting config files)
  - Details: The security monitor now has an explicit enumerated list of agent-config paths that trigger Self-Modification rules. These paths are now explicitly documented:
    - `.claude/settings*.json`
    - `CLAUDE.md`, `CLAUDE.local.md`, `.claude.json`
    - `.claude/rules/`, `.claude/hooks/`, `.claude/commands/`
    - `.claude/agents/`, `.claude/skills/`, `.claude/output-styles/`
    - `.claude/workflows/`, `.claude/routines/`
    - `.claude/scheduled_tasks.json`, `.claude/loop.md`
    - `.mcp.json`

    Exception carved out: Files under `.claude/worktrees/<name>/` are now treated as ordinary project files, not Self-Modification. This is important for plugin developers to understand what paths are protected.
  - Raw: "Agent Prompt: Security monitor for autonomous agent actions (second part) - Expands the Self-Modification rule from a vague description to an explicit list of agent-config paths..."

- [ ] **Hook condition evaluator: new 'impossible' response shape** (CC 2.1.143)
  - Source: system-prompts
  - Confidence: high
  - Affects: hook-development (Stop hook documentation)
  - Details: The hook condition evaluator for stop conditions now supports a third response shape beyond `{"ok": true}` and `{"ok": false}`:
    ```json
    {"ok": false, "impossible": true, "reason": "..."}
    ```
    This is for conditions that can never be satisfied: self-contradictory goals, missing capability, or when the assistant has exhausted all approaches. The evaluator independently verifies impossibility rather than trusting the assistant's self-assessment.
  - Raw: "Agent Prompt: Hook condition evaluator (stop) - Adds a third response shape..."

- [ ] **Hook terminalSequence output field** (CC 2.1.141) [PROMOTED by Stage 2]
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: hook-development (output format section)
  - Details: Hooks can now emit desktop notifications, window titles, and bells via new `terminalSequence` JSON field in hook output. Enables plugin hooks to provide visual/audio feedback to users.
  - Raw: "Hooks can now emit desktop notifications, window titles, and bells via new `terminalSequence` JSON field"

- [ ] **Hook args field (exec form)** (CC 2.1.139) [PROMOTED by Stage 2]
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: hook-development (hook entry schema section)
  - Details: New `args: string[]` field for command hooks allows exec-form command spawning without shell interpolation. Safer than shell-based command strings for hooks that need to pass arguments.
  - Raw: "Added hook `args: string[]` field (exec form) for direct command spawning without shell"

- [ ] **continueOnBlock for PostToolUse hooks** (CC 2.1.139) [PROMOTED by Stage 2]
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: hook-development (PostToolUse section)
  - Details: New `continueOnBlock` option for PostToolUse hooks. When set, the hook can block and provide a rejection reason that feeds back to Claude instead of stopping execution entirely.
  - Raw: "Added `continueOnBlock` for `PostToolUse` hooks to feed rejection back to Claude"

- [ ] **worktree.bgIsolation: "none" setting** (CC 2.1.143) [PROMOTED by Stage 2]
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: agent-development (background agents, worktree isolation)
  - Details: New setting allows background sessions to edit the working copy directly without entering a worktree via `EnterWorktree`. Affects how background agents interact with the main working directory.
  - Raw: "New `worktree.bgIsolation: "none"` setting allows background sessions to edit the working copy directly without `EnterWorktree`"

- [ ] **Stop hooks block cap (8 consecutive blocks)** (CC 2.1.143) [PROMOTED by Stage 2]
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: hook-development (Stop event section)
  - Details: Stop hooks now have a built-in safeguard: turns end with a warning after 8 consecutive blocks to prevent infinite loops. Override via `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` environment variable.
  - Raw: "Fixed stop hooks blocking repeatedly forever -- turns now end with a warning after 8 consecutive blocks (override via `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`)"

---

### May Update

- [ ] **Write tool description: 'When to use' format** (CC 2.1.140) [DEMOTED from Must Update by Stage 2]
  - Source: system-prompts
  - Confidence: medium
  - Affects: tool-reference documentation (low priority)
  - Details: Write tool description has been rewritten into a "When to use" format that explicitly names the two use cases: (1) creating a new file, or (2) fully replacing a previously-read file. The description now explicitly points users to the Edit tool for partial changes. Low priority for plugin-dev since we reference tools by name, not by documenting their descriptions.
  - Raw: "Tool Description: Write (read existing file first) - Rewrites the description into a 'When to use' format..."

- [ ] **Snooze tool: warning against short-interval wakeups** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent documentation (background/scheduled work, low priority)
  - Details: Snooze tool now explicitly warns not to schedule short-interval wakeups to poll for harness-tracked background work (since the agent is re-invoked automatically when background work finishes). Recommends long 1200s+ fallback heartbeat for monitoring. Low priority since Snooze is not a core plugin development concern.
  - Raw: "Tool Description: Snooze (delay and reason guidance) - Adds an explicit warning not to schedule short-interval wakeups..."

---

### No Action

**Original No Action items:**
- Fast mode defaults to Opus 4.7 (CC 2.1.142) - model selection, not plugin-related
- Agent view (Research Preview) added (CC 2.1.139) - UI feature, not plugin system
- Goal completion tracking, scroll speed configuration (CC 2.1.139) - UI features
- Plugin dependency enforcement (CC 2.1.143) - internal enforcement logic, not new manifest fields
- Projected context costs (CC 2.1.143) - UI/display feature
- Background session enhancements (CC 2.1.143) - internal improvements
- HTTPS plugin cloning (CC 2.1.141) - installation behavior, not plugin authoring
- Workspace ID support (CC 2.1.141) - internal identifier
- Session title generator data treatment (CC 2.1.142) - internal prompt refinement, treats content as data
- Managed Agents onboarding Console escape hatch (CC 2.1.142) - Managed Agents specific, not plugin-dev
- /rename conversation wrapper (CC 2.1.142) - internal prompt refinement
- Amazon Bedrock model IDs section (CC 2.1.142) - API provider specific, not plugin system
- Create verifier skills TodoWrite/TaskCreate toggle (CC 2.1.142) - internal tool resolution based on tasks feature
- Worker fork wording cleanup (CC 2.1.140) - minor wording change, drops "in your system prompt"
- Action safety and truthful reporting prompt (CC 2.1.136) - already in previous audit, internal agent behavior
- Claude Platform on AWS reference (CC 2.1.139) - cloud deployment, not plugin system
- Dream memory consolidation log discovery update (CC 2.1.120) - memory system internal
- WebSearch template variable rename (CC 2.1.120) - internal variable naming
- Task tools reminder change - removes "never mention reminder to user" (CC 2.1.139) - internal behavior
- TodoWrite reminder change - removes "never mention reminder to user" (CC 2.1.139) - internal behavior
- /insights report output trimming (CC 2.1.139) - internal formatting
- Dynamic pacing loop reordering (CC 2.1.139) - internal step ordering

**Demoted from May Update by Stage 2:**
- Verify skill: destructive path guard and no-CI workflow (CC 2.1.143) - internal CC skill, not plugin authoring
- Conversation/partial compaction: security-relevant instructions preservation (CC 2.1.139) - internal CC behavior
- Memory instructions: kebab-case slugs, metadata block, cross-links (CC 2.1.139) - CC memory system, not plugin-dev
- PowerShell reference table: Unix to PowerShell mapping (CC 2.1.139) - internal tool docs, hook-development already covers PowerShell
- Output style per-turn reminder sourcing (CC 2.1.141) - internal implementation detail
- Auto mode: destructive-action guidance now generic (CC 2.1.139) - internal prompt refinement
- Managed Agents skill limit: 64 -> 20 per agent (CC 2.1.132) - Managed Agents platform, not local plugins

---

## Summary

**Version Range:** 2.1.139 - 2.1.143 (5 versions since last audit at 2.1.138)

**Total Changes Analyzed:** 45+ across system-prompts and changelog

**Must Update: 9 items** (4 original + 5 promoted by Stage 2)
1. **NEW SendUserFile tool** (CC 2.1.142) - major new tool for surfacing deliverables
2. **NEW Agent tool simplified usage notes** (CC 2.1.140) - clearer Agent tool reference for plugin authors
3. **Security monitor Self-Modification paths** (CC 2.1.140) - explicit enumerated list of protected paths
4. **Hook condition evaluator 'impossible' response** (CC 2.1.143) - new hook response shape for stop conditions
5. **Hook terminalSequence output field** (CC 2.1.141) - [PROMOTED] desktop notifications via hooks
6. **Hook args field (exec form)** (CC 2.1.139) - [PROMOTED] safer command spawning without shell
7. **continueOnBlock for PostToolUse hooks** (CC 2.1.139) - [PROMOTED] feed rejection back to Claude
8. **worktree.bgIsolation: "none" setting** (CC 2.1.143) - [PROMOTED] background sessions skip worktree
9. **Stop hooks block cap** (CC 2.1.143) - [PROMOTED] 8-block cap prevents infinite loops

**May Update: 2 items** (1 demoted from Must Update + 1 retained)
- Write tool 'When to use' format (demoted - low priority for plugin-dev)
- Snooze tool polling warning (low priority)

**No Action: 29 items** (22 original + 7 demoted from May Update)

**Token delta from system-prompts:**
- 2.1.143: +302 tokens
- 2.1.142: +1,080 tokens
- 2.1.141: +4 tokens
- 2.1.140: +622 tokens
- 2.1.139: +2,248 tokens
- **Total for range: +4,256 tokens**

**Triangulation Notes:**
- claude-code-guide agent timed out in CI environment; triangulation degraded to two sources
- Stage 2 verification discovered 5 missed items from CC changelog (WebFetch)
- Changelog provides feature-level summaries; system-prompts provides implementation details
- Versions 2.1.138, 2.1.137, 2.1.131 had no system prompt changes
- Stage 1 significantly underestimated hook-related changes in CC 2.1.139 and 2.1.143

---

## Key Plugin-Dev Impacts

### For plugin.json / Manifest
- No new manifest fields identified in this range

### For Skills
- SendUserFile tool available for skills generating deliverables
- Agent tool has clearer usage guidance
- Verify skill has new workflow patterns worth documenting

### For Hooks
- New 'impossible' response shape for stop condition evaluators: `{"ok": false, "impossible": true, "reason": "..."}`
- Security-relevant instructions now explicitly preserved across compaction

### For Agents
- Explicit list of Self-Modification protected paths documented
- Agent tool simplified usage notes available

### For Tools
- Write tool "When to use" format change
- Snooze tool short-interval warning
- PowerShell reference table for Windows development

---

## Stage 2: Verification Results
### Verified: 2026-05-16

#### Must Update Verification

- **[check]** **NEW: SendUserFile tool** (CC 2.1.142) -- CONFIRMED in system-prompts CHANGELOG ("Tool Description: SendUserFile - Describes the SendUserFile tool for surfacing generated deliverable files to the user, with optional captions and normal or proactive status."). Gap exists: plugin-dev does not document SendUserFile anywhere. Skill mapping corrected: This affects **hook-development** documentation (new tool hooks can match) and potentially **agent-development** (agents generating deliverables).

- **[check]** **NEW: Agent tool simplified usage notes** (CC 2.1.140) -- CONFIRMED in system-prompts CHANGELOG ("Tool Description: Agent (simple usage notes) - Simplified usage notes for the Agent tool covering when to delegate, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions."). Gap exists: agent-development/overview.md does not mention these simplified usage notes. Affects: **agent-development** reference.

- **[check]** **Security monitor: explicit agent-config paths for Self-Modification rule** (CC 2.1.140) -- CONFIRMED in system-prompts CHANGELOG. Lists explicit paths: `.claude/settings*.json`, `CLAUDE.md`, `.claude/rules/`, `.claude/hooks/`, `.claude/commands/`, `.claude/agents/`, `.claude/skills/`, etc. Gap exists: plugin-dev does not document Self-Modification protected paths. Affects: **agent-development** (agents modifying config) and **hook-development** (hooks targeting config files).

- **[check]** **Hook condition evaluator: new 'impossible' response shape** (CC 2.1.143) -- CONFIRMED in system-prompts CHANGELOG ("Adds a third response shape `{"ok": false, "impossible": true, "reason": ...}` for conditions that can never be satisfied"). Gap exists: hook-development/overview.md documents Stop hook blocking but not the 'impossible' response variant. Affects: **hook-development** skill.

- **[check]** **Write tool description: 'When to use' format** (CC 2.1.140) -- CONFIRMED in system-prompts CHANGELOG ("Tool Description: Write (read existing file first) - Rewrites the description into a 'When to use' format"). However, this is LOWER PRIORITY for plugin-dev: the Write tool is a standard CC tool, and plugin-dev references it only incidentally. Reclassified to **May Update** since plugin authors don't need detailed Write tool documentation -- they reference it by name.

#### Missed Items (promoted from No Action or newly identified)

- **[!]** **Hook terminalSequence output field** (CC 2.1.141) -- MISSED by Stage 1. The CC 2.1.141 changelog notes: "Hooks can now emit desktop notifications, window titles, and bells via new `terminalSequence` JSON field." This is plugin-relevant: hooks can now output terminal sequences for notifications. Not documented in plugin-dev hook-development reference.
  - Affects: **hook-development** (output format section)
  - Details: New `terminalSequence` field in hook JSON output enables desktop notifications, window titles, and terminal bells.

- **[!]** **Hook args field (exec form)** (CC 2.1.139) -- MISSED by Stage 1. The CC 2.1.139 WebFetch result notes: "Added hook `args: string[]` field (exec form) for direct command spawning without shell." This is a new hook configuration option allowing array-based command execution without shell interpolation.
  - Affects: **hook-development** (hook entry schema section)
  - Details: New `args` field in hook config allows exec-form command execution (safer, no shell interpolation).

- **[!]** **continueOnBlock for PostToolUse hooks** (CC 2.1.139) -- MISSED by Stage 1. The CC 2.1.139 WebFetch result notes: "Added `continueOnBlock` for `PostToolUse` hooks to feed rejection back to Claude." This allows PostToolUse hooks to block and provide feedback without stopping execution.
  - Affects: **hook-development** (PostToolUse section)
  - Details: New `continueOnBlock` option for PostToolUse hooks feeds rejection reason to Claude instead of stopping.

- **[!]** **worktree.bgIsolation: "none" setting** (CC 2.1.143) -- MISSED by Stage 1. The CC 2.1.143 WebFetch result notes: "New `worktree.bgIsolation: "none"` setting allows background sessions to edit the working copy directly without `EnterWorktree`." This affects how background agents interact with worktrees.
  - Affects: **agent-development** (background agents, worktree isolation)
  - Details: New setting to disable automatic worktree isolation for background sessions.

- **[!]** **Stop hooks block cap (8 consecutive blocks)** (CC 2.1.143) -- MISSED by Stage 1. The CC 2.1.143 changelog notes: "Fixed stop hooks blocking repeatedly forever -- turns now end with a warning after 8 consecutive blocks (override via `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`)." This is important for Stop hook authors to understand.
  - Affects: **hook-development** (Stop event section)
  - Details: Stop hooks now have an 8-block cap to prevent infinite loops; configurable via env var.

#### May Update Resolution

- **[down-arrow]** **Verify skill: destructive path guard and no-CI workflow** (CC 2.1.143) -- Demoted to **No Action**. The Verify skill is an internal CC skill, not something plugin-dev documents. Plugin authors do not need to know about Verify skill internals.

- **[=]** **Snooze tool: warning against short-interval wakeups** (CC 2.1.140) -- Kept as **May Update**. The Snooze tool is occasionally relevant for scheduled/background plugin workflows, but it is not a core plugin-dev concern. Low priority.

- **[down-arrow]** **Conversation/partial compaction: security-relevant instructions preservation** (CC 2.1.139) -- Demoted to **No Action**. This is internal CC behavior. Plugin authors don't control compaction behavior; they just benefit from security instructions being preserved automatically.

- **[down-arrow]** **Memory instructions: kebab-case slugs, metadata block, cross-links** (CC 2.1.139) -- Demoted to **No Action**. This affects CC memory features, not plugin development. Plugin-dev does not document memory file formats.

- **[down-arrow]** **PowerShell reference table: Unix to PowerShell mapping** (CC 2.1.139) -- Demoted to **No Action**. While Windows support matters, plugin-dev's hook scripts already note PowerShell considerations (CC 2.1.126). The detailed Unix-to-PowerShell mapping is internal to CC, not plugin-authoring guidance.

- **[down-arrow]** **Output style per-turn reminder sourcing** (CC 2.1.141) -- Demoted to **No Action**. This is an internal implementation detail about how output styles source reminders. Does not affect output style authoring.

- **[down-arrow]** **Auto mode: destructive-action guidance now generic** (CC 2.1.139) -- Demoted to **No Action**. Internal prompt refinement, not plugin-relevant.

- **[down-arrow]** **Managed Agents skill limit: 64 -> 20 per agent** (CC 2.1.132) -- Demoted to **No Action**. This is Managed Agents platform-specific (cloud), not local plugin development. Out of scope for plugin-dev.

- **[up-arrow]** **Write tool 'When to use' format** (CC 2.1.140) -- Reclassified from Must Update to **May Update**. The change is real but low priority for plugin-dev since we don't document individual tool descriptions.

#### Summary

- **Must Update: 4 items** (4 confirmed from original 5, 1 demoted to May Update)
  1. NEW SendUserFile tool (CC 2.1.142) -- affects hook-development, agent-development
  2. NEW Agent tool simplified usage notes (CC 2.1.140) -- affects agent-development
  3. Security monitor Self-Modification paths (CC 2.1.140) -- affects agent-development, hook-development
  4. Hook condition evaluator 'impossible' response (CC 2.1.143) -- affects hook-development

- **Missed Items (promoted to Must Update): 5 items**
  5. Hook terminalSequence output field (CC 2.1.141) -- affects hook-development
  6. Hook args field (exec form) (CC 2.1.139) -- affects hook-development
  7. continueOnBlock for PostToolUse hooks (CC 2.1.139) -- affects hook-development
  8. worktree.bgIsolation: "none" setting (CC 2.1.143) -- affects agent-development
  9. Stop hooks block cap (CC 2.1.143) -- affects hook-development

- **May Update: 2 items remaining**
  - Write tool 'When to use' format (demoted from Must Update)
  - Snooze tool short-interval warning

- **No Action: 7 items demoted** (from May Update) + original No Action items

- **Confidence: HIGH** -- Independent verification via WebFetch and system-prompts CHANGELOG confirms all Must Update items. Discovered 5 missed items that should be promoted to Must Update. Stage 1 captured the major items but missed several hook-related features from CC 2.1.139 and 2.1.141-2.1.143.

- **Significant Issues Flag: YES** -- 5 missed items discovered (>3 threshold). Stage 1 missed the `args` field, `continueOnBlock`, `terminalSequence`, `worktree.bgIsolation`, and stop hook block cap. These are all plugin-relevant features that should have been caught. The claude-code-guide timeout in Stage 1 likely contributed to missing these items since the CC changelog (WebFetch source) contains this information.
