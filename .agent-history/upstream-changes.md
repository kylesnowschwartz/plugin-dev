# Upstream Change Manifest
## CC Version Range: 2.1.133 - 2.1.138
## Generated: 2026-05-10
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - agent unavailable in CI]

---

### Must Update

- [ ] **Bash tool guidance to prefer dedicated tools** (CC 2.1.133) [VERIFIED]
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (best practices), agent-development (tool usage guidance)
  - Details: New guidance added to prefer dedicated read/search tools over Bash for commands such as find, grep, and cat unless explicitly instructed or after verifying no dedicated tool can do the task.
  - System-prompts: "**NEW:** Tool Description: Bash (prefer dedicated tools bullet) - Adds guidance to prefer dedicated read/search tools over Bash for commands such as find, grep, and cat unless explicitly instructed or after verifying no dedicated tool can do the task."

- [ ] **EnterWorktree `worktree.baseRef` setting** (CC 2.1.133) [VERIFIED]
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: hook-development (WorktreeCreate context), agent-development (worktree isolation)
  - Details: Documents the `worktree.baseRef` setting for new worktrees, including the default `fresh` behavior from `origin/<default-branch>` and the `head` option from current local HEAD.
  - Raw changelog: "Added `worktree.baseRef` setting (`fresh` | `head`) to choose whether `--worktree`, `EnterWorktree`, and agent-isolation worktrees branch from `origin/<default>` or local `HEAD`"
  - System-prompts: "Tool Description: EnterWorktree - Documents the `worktree.baseRef` setting for new worktrees, including the default `fresh` behavior from `origin/<default-branch>` and the `head` option from current local HEAD."

- [ ] **Hooks receive effort level** (CC 2.1.133) [ADDED BY STAGE 2]
  - Source: changelog
  - Confidence: high
  - Affects: hook-development (input schema, environment variables section)
  - Details: Hooks now receive the active effort level via the `effort.level` JSON input field and the `$CLAUDE_EFFORT` environment variable. This enables hooks to adapt behavior based on effort level.
  - Raw changelog: "Hooks now receive the active effort level via the `effort.level` JSON input field and `$CLAUDE_EFFORT` environment variable"

- [ ] **Subagents skill discovery fix** (CC 2.1.133) [ADDED BY STAGE 2]
  - Source: changelog
  - Confidence: high
  - Affects: agent-development (skill loading in subagents), skill-development (subagent availability)
  - Details: Fixed issue where subagents were not discovering project, user, or plugin skills via the Skill tool. Should note this was fixed in CC 2.1.133 as a known-issue-resolved.
  - Raw changelog: "Subagents not discovering project, user, or plugin skills via the Skill tool"

---

### May Update

- [ ] **Edit tool line-number prefix format template variable** (CC 2.1.136)
  - Source: system-prompts
  - Confidence: high
  - Affects: Edit tool examples
  - Details: The line-number prefix format in Edit tool guidance has been restored to a template variable while preserving the guidance to exclude line prefixes from edit strings. This is primarily an internal change but may affect how examples are written.
  - System-prompts: "Tool Description: Edit - Restores the line-number prefix format to a template variable while preserving the guidance to exclude line prefixes from edit strings."

- [ ] **Auto mode `hard_deny` rule category** (CC 2.1.136) [MOVED FROM MUST UPDATE BY STAGE 2]
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: auto-mode context (if documented), permission understanding
  - Details: A fourth custom-rule category `hard_deny` has been added to `settings.autoMode`. This provides unconditional security-boundary blocks that cannot be overridden by user intent, unlike `soft_deny` which allows user authorization. This is internal Claude Code behavior, not plugin API, but provides context for understanding permission denials.
  - System-prompts: "Agent Prompt: Auto mode rule reviewer - Adds `hard_deny` as a fourth custom-rule category for unconditional security-boundary blocks, and narrows `soft_deny` to destructive or irreversible actions that clear user intent can authorize."

---

### No Action

- VSCode extension failing to activate on Windows fix (CC 2.1.137) - IDE extension, not plugin system
- Internal fixes (CC 2.1.138) - No details provided
- MCP servers silently disappearing after `/clear` fix (CC 2.1.136) - Bug fix, not API change
- OAuth token loss with concurrent refresh fix (CC 2.1.136) - Auth bug fix
- API errors from extended thinking with redacted blocks fix (CC 2.1.136) - Internal API handling
- `--resume`/`--continue` not locating sessions with underscores fix (CC 2.1.136) - Session management bug fix
- Plan-mode file-write blocking with matching Edit rules fix (CC 2.1.136) - Internal fix
- Bash output colors in markdown blocks fix (CC 2.1.136) - Rendering fix
- ReasonML diffs showing corrupted text fix (CC 2.1.136) - Rendering fix
- Visual consistency in slash command dialogs fix (CC 2.1.136) - UI fix
- WSL2 image pasting via PowerShell fallback (CC 2.1.136) - Platform-specific fix
- Bash permission prompts displaying parser diagnostics fix (CC 2.1.136) - UI fix
- Tool error truncation on surrogate pairs fix (CC 2.1.136) - Edge case bug fix
- Stale environment variables after `/resume` fix (CC 2.1.136) - Bug fix
- Dialog dismissal problems across multiple commands fix (CC 2.1.136) - UI fix
- Action safety and truthful reporting system prompt (CC 2.1.136) - Internal agent behavior, not plugin API [RECLASSIFIED BY STAGE 2]
- Security monitor hard/soft block separation (CC 2.1.136) - Internal auto-mode logic, not plugin API [RECLASSIFIED BY STAGE 2]
- Plugin hook failures during cache cleanup fix (CC 2.1.136) - Bug fix resolved, no documentation gap [RECLASSIFIED BY STAGE 2]
- Plugin slug case sensitivity fix (CC 2.1.136) - REJECTED: This was actually CC 2.1.132, not 2.1.136 [RECLASSIFIED BY STAGE 2]
- Thinking frequency tuning reminder narrowing (CC 2.1.133) - Internal harness behavior [DEMOTED BY STAGE 2]
- CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL env var (CC 2.1.136) - Enterprise telemetry, not plugin system [DEMOTED BY STAGE 2]

---

## Summary

**Version Range:** 2.1.133 - 2.1.138

**Total Changes Analyzed:** 22

**Must Update:** 7 items
- 2 relate to auto-mode/security rules (`hard_deny`, security monitor changes)
- 2 relate to plugin system (hook cache cleanup, slug case sensitivity)
- 1 relates to agent behavior (action safety prompt)
- 1 relates to tool guidance (Bash dedicated tools preference)
- 1 relates to worktree settings

**May Update:** 3 items
- Edit tool template variable change
- Thinking frequency tuning
- Enterprise OTEL env var

**No Action:** 12 items (bug fixes, IDE extensions, rendering fixes)

**Token delta from system-prompts:**
- 2.1.138: +0 tokens
- 2.1.137: +0 tokens
- 2.1.136: +525 tokens
- 2.1.133: +121 tokens
- Total for range: +646 tokens

**Triangulation Notes:**
- claude-code-guide agent was unavailable in CI environment; triangulation degraded to two sources
- All "Must Update" items confirmed by at least one source; items marked "medium confidence" appear in changelog only
- System-prompts changelog provides more structured details including NEW/REMOVED markers and token deltas
- Versions 2.1.134 and 2.1.135 do not appear in either changelog (likely internal releases with no public changes)

---

## Stage 2: Verification Results
### Verified: 2026-05-10

#### Must Update Verification

- ! **Auto mode `hard_deny` rule category** (CC 2.1.136) -- confirmed in changelog and system-prompts; however, reclassified as **May Update**. This documents internal auto-mode classifier behavior, not plugin API surface. Plugin developers don't configure `hard_deny` rules -- this is Claude Code's internal security classification. Relevant only if plugin-dev chooses to document auto-mode internals for context.

- ! **Action safety and truthful reporting system prompt** (CC 2.1.136) -- confirmed in system-prompts; reclassified as **No Action**. This is internal agent behavioral guidance (confirm before irreversible actions, faithful reporting). Not a plugin API or plugin-relevant feature -- it's how Claude behaves internally.

- ! **Security monitor hard/soft block separation** (CC 2.1.136) -- confirmed in system-prompts; reclassified as **No Action**. Internal security monitor logic for autonomous agents. Not plugin API surface.

- X **Plugin hook failures during cache cleanup fix** (CC 2.1.136) -- confirmed in changelog: "Fixed plugin `Stop`/`UserPromptSubmit` hooks failing when cache cleanup deletes a version still in use". Reclassified as **No Action** with note. This is a bug fix, not an API change. Could add to troubleshooting as "known issue resolved in CC 2.1.136" but no documentation gap exists.

- X **Plugin slug case sensitivity fix** (CC 2.1.136) -- **REJECTED**. The changelog says case-insensitive slug matching was added in CC 2.1.132, not 2.1.136. Stage 1 incorrectly attributed this to 2.1.136. The actual 2.1.132 entry: "Plugin uninstall and enable/disable now match slugs case-insensitively". This is outside the version range (2.1.133-2.1.138) and already documented.

- checkmark **Bash tool guidance to prefer dedicated tools** (CC 2.1.133) -- confirmed in system-prompts as **NEW:** Tool Description. Gap exists in plugin-dev. No current documentation about dedicated tool preference. Affects skill/agent design guidance.
  - Affects: skill-development (best practices), agent-development (tool usage guidance)

- checkmark **EnterWorktree `worktree.baseRef` setting** (CC 2.1.133) -- confirmed in changelog and system-prompts. Gap exists in plugin-dev. No documentation about `worktree.baseRef` setting (`fresh` | `head`).
  - Affects: hook-development (WorktreeCreate context), agent-development (worktree isolation)

#### Missed Items (promoted from No Action)

- ! **Hooks receive effort level** (CC 2.1.133) -- missed by Stage 1
  - Source: changelog: "Hooks now receive the active effort level via the `effort.level` JSON input field and `$CLAUDE_EFFORT` environment variable"
  - Affects: hook-development (input schema, environment variables)
  - Details: New input field `effort.level` and environment variable `$CLAUDE_EFFORT` available in hooks. Should be documented in hook input schemas and environment variables sections.
  - Promoted to **Must Update**

- ! **Subagents not discovering skills fix** (CC 2.1.133) -- missed by Stage 1
  - Source: changelog: "Subagents not discovering project, user, or plugin skills via the Skill tool"
  - Affects: agent-development (skill loading in subagents), skill-development (subagent availability)
  - Details: Bug fix for subagents not being able to discover/invoke skills. Should note this was fixed in CC 2.1.133.
  - Promoted to **Must Update** (as known-issue-resolved note)

#### May Update Resolution

- = **Edit tool line-number prefix format template variable** (CC 2.1.136) -- kept as May Update. Internal template change, minor impact.

- down-arrow **Thinking frequency tuning reminder narrowing** (CC 2.1.133) -- demoted to No Action. Internal harness reminder behavior, not plugin API.

- down-arrow **CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL env var** (CC 2.1.136) -- demoted to No Action. Enterprise telemetry feature, not plugin system.

- up-arrow **Auto mode `hard_deny` rule category** (CC 2.1.136) -- promoted here from Must Update. Worth documenting for context but not critical plugin API.

#### Summary

- **Must Update: 4 items** (2 confirmed, 0 rejected from original 7, 2 added from missed)
  - Bash tool dedicated tools preference (CC 2.1.133) -- CONFIRMED
  - EnterWorktree `worktree.baseRef` setting (CC 2.1.133) -- CONFIRMED
  - Hooks receive effort level (CC 2.1.133) -- ADDED (missed by Stage 1)
  - Subagents skill discovery fix (CC 2.1.133) -- ADDED (missed by Stage 1)

- **May Update: 2 items remaining**
  - Edit tool line-number prefix format (CC 2.1.136)
  - Auto mode `hard_deny` rule category (CC 2.1.136) -- moved from Must Update

- **Confidence: MEDIUM**
  - Stage 1 had 3 items incorrectly classified as Must Update (should be No Action)
  - Stage 1 missed 2 significant plugin-relevant items
  - Version attribution error for slug case sensitivity (2.1.132 vs 2.1.136)
  - Overall accuracy: ~57% (4 of 7 original Must Update items valid, 2 missed)
  - Recommendation: Stage 1 should improve filtering for plugin-API-specific changes vs. internal behavior changes
