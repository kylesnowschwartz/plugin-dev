# Upstream Change Manifest
## CC Version Range: 2.1.99 - 2.1.110
## Generated: 2026-04-16
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped]

---

### Must Update (Stage 2 Verified)

- [ ] **CRITICAL: Allowed-tools syntax change: colon-separated to space-separated** (CC 2.1.108)
  - Source: system-prompts
  - Confidence: HIGH - verified by Stage 2
  - Affects: skill-development, command-development, permission examples
  - Details: All `allowed-tools` examples updated from colon-separated (`Bash(npm:*)`, `git diff:*`) to space-separated (`Bash(npm *)`, `git diff *`) Bash pattern syntax. This is a breaking change for skill authors.
  - Files requiring update:
    - `skills/command-development/SKILL.md` line 534
    - `skills/command-development/references/frontmatter-reference.md` line 104
    - `skills/command-development/references/advanced-workflows.md` lines 121, 148
    - `skills/command-development/examples/simple-commands.md` line 100
    - `skills/plugin-structure/references/github-actions.md` line 118

- [ ] **PreCompact hook blocking capability** (CC 2.1.105)
  - Source: changelog, system-prompts
  - Confidence: HIGH - verified by Stage 2
  - Affects: hook-development
  - Details: PreCompact hooks can now block compaction by returning exit code 2 or `{"decision":"block"}`. The PreCompact event already exists in docs but blocking capability is new.
  - Action: Add blocking capability to PreCompact documentation in hook-development/SKILL.md

- [ ] **Background monitor "silence is not success" guidance** (CC 2.1.105)
  - Source: changelog, system-prompts
  - Confidence: HIGH - verified by Stage 2
  - Affects: hook-development, agent-development
  - Details: Updated guidance requiring monitors to match all terminal states (failures, crashes, OOM), not just happy path. Top-level `monitors` manifest key added for plugin support.
  - Action: Update existing Monitor tool mention in agent-development and add guidance to hook-development or plugin-structure

---

### May Update (Stage 2 Verified)

- [ ] **Agent tool "trust but verify" guidance** (CC 2.1.105)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent-development best practices
  - Details: New guidance instructing Claude to check actual code changes from agents before reporting work as done, rather than relying solely on agent summaries.
  - Stage 2 note: Could enhance agent-development skill with verification guidance. Keep as May Update.

- [ ] **Verify skill restructured** (CC 2.1.97, updates through 2.1.105)
  - Source: system-prompts
  - Confidence: medium
  - Affects: testing/verification patterns
  - Details: Major restructure emphasizing checking `.claude/skills/` for verifier skills first, new "Push on it" section with probing strategies by change type.
  - Stage 2 note: Could inform testing patterns in plugin development. Keep as May Update.

- [ ] **Heredoc piping guidance for REPL/Bash** (CC 2.1.110)
  - Source: system-prompts
  - Confidence: medium
  - Affects: command-development, script execution
  - Details: Added guidance to pipe via heredoc instead of writing temp files for shell commands, warning that generic temp paths get clobbered by parallel agents.
  - Stage 2 note: Relevant to script execution patterns in hooks and commands. Keep as May Update.

---

### No Action (Stage 2 Verified)

**Demoted from Must Update by Stage 2:**
- NEW REPL tool (CC 2.1.108) - Optional low-priority; no tool-reference skill exists in plugin-dev
- NEW PushNotification tool (CC 2.1.110) - Optional low-priority; no tool-reference skill exists
- EnterWorktree tool path parameter (CC 2.1.105) - Minor tool enhancement, low priority
- Agent tool renamed "Agent" to "R4" (CC 2.1.105) - Internal naming in disallowedTools, not user-facing
- /tui command (CC 2.1.110) - Built-in CC feature, not plugin development
- /team-onboarding command and skill (CC 2.1.101) - Built-in CC feature
- /insights command and skill (CC 2.1.101) - Built-in CC feature
- /loop dynamic mode and self-pacing (CC 2.1.101) - Built-in CC autonomous loop features
- /dream nightly schedule skill (CC 2.1.97) - Built-in CC memory feature
- Managed Agents documentation overhaul (CC 2.1.97+) - Anthropic API docs, not CC plugin dev
- Prompt caching TTL configuration (CC 2.1.108) - Internal env vars for API

**Demoted from May Update by Stage 2:**
- Fork usage guidelines simplified (CC 2.1.105) - Internal CC guidance
- Communication style heading renamed (CC 2.1.104) - Internal naming
- Sleep duration guidance relaxed (CC 2.1.108) - Minor internal change
- Session recap feature (CC 2.1.108) - User feature, not plugin dev
- Sandbox Network Callback threat definition (CC 2.1.110) - Internal security
- Model catalog formatting (CC 2.1.108) - Cosmetic change

**Original No Action (unchanged):**
- Thinking hints shown sooner during long operations (CC 2.1.107)
- Rotating progress hint for extended-thinking indicator (CC 2.1.109)
- OS CA certificate store trust by default (CC 2.1.101)
- Improved brief and focus modes (CC 2.1.101)
- Fixed paste functionality, session resume problems, terminal escape handling (CC 2.1.101)
- MCP tool call hang fixes (CC 2.1.110)
- Session cleanup fixes (CC 2.1.110)
- Permission rule enforcement fixes (CC 2.1.110)
- Stalled API stream handling improvements (CC 2.1.105)
- File write display improvements (CC 2.1.105)
- Improved error messaging for rate limits and server issues (CC 2.1.108)
- Thinking frequency tuning system reminder (CC 2.1.107) - internal behavior
- Memory synthesis restructured to fact-extraction format (CC 2.1.105) - internal agent
- Managed Agents SDK version requirements updates (CC 2.1.105) - API reference only
- Dream memory consolidation/pruning refinements (CC 2.1.97-2.1.105) - internal memory system
- Session search agent lightweight rewrite (CC 2.1.94) - internal agent
- Worker fork prompt streamlined (CC 2.1.94) - internal agent
- Status line git_worktree field (CC 2.1.97) - internal display
- Communication style tightened (CC 2.1.100) - internal behavior
- Exploratory questions prompt removed (CC 2.1.100) - internal behavior
- Output efficiency prompt removed (CC 2.1.100) - internal behavior
- User-facing communication style prompt removed (CC 2.1.100) - internal behavior
- Hook condition evaluator specialized for stop conditions (CC 2.1.92) - internal
- Sleep tool removed (CC 2.1.92) - replaced by Snooze
- MCP Tool Result Truncation guidance changes (CC 2.1.92) - internal behavior
- Remote plan mode diagram guidance rewritten (CC 2.1.92) - internal behavior
- Runtime-verification alias for Verify skill (CC 2.1.105) - internal alias
- Build Claude API and SDK apps skill trigger updates (CC 2.1.101-2.1.108) - built-in skill
- Autonomous loop check system prompt (CC 2.1.101) - internal loop behavior
- Schedule recurring cron skills (CC 2.1.101) - built-in scheduling skills
- Managed Agents onboarding flow agent prompt (CC 2.1.97/2.1.105) - API onboarding
- Managed Agents data files updates (CC 2.1.105) - API reference updates

---

## Summary (Stage 2 Corrected)

**3 Must Update items** (verified by Stage 2):
1. **CRITICAL: Allowed-tools syntax change** (colon to space-separated) - breaking change affecting 6+ files
2. PreCompact hook blocking capability (exit code 2 / decision:block)
3. Background monitor "silence is not success" guidance and plugin support

**3 May Update items** (verified by Stage 2):
1. Agent tool "trust but verify" guidance
2. Verify skill restructured (probing strategies)
3. Heredoc piping guidance for REPL/Bash

**40+ No Action items** - includes 11 demoted from original Must Update (built-in CC features, API docs, internal changes) and 6 demoted from May Update

## Notes

1. **Degraded triangulation**: The claude-code-guide agent was skipped due to CI environment limitations. Changes are confirmed via changelog and system-prompts sources only.

2. **Critical: Allowed-tools syntax change** - The change from colon-separated to space-separated patterns (`Bash(npm:*)` -> `Bash(npm *)`) is significant and may affect existing skills that use permissions. This should be verified and updated in the skill-authoring documentation immediately.

3. **New tools requiring documentation**:
   - REPL: JavaScript programming interface for composing tool calls
   - PushNotification: Desktop/mobile notifications
   - Snooze: Delay tool for loop scheduling (replaces Sleep)
   - ScheduleWakeup: Loop iteration scheduling

4. **New hooks**: PreCompact hook added for plugins to intercept before context compaction.

5. **Managed Agents documentation overhaul** is extensive but may only affect the claude-api skill's references if plugin-dev references the Agent SDK.

6. **Token delta summary** (from system-prompts):
   - 2.1.100: -845 tokens (communication style prompts removed)
   - 2.1.101: +4,676 tokens (loop/scheduling skills, autonomous loop)
   - 2.1.104: +8 tokens (heading rename)
   - 2.1.105: +4,895 tokens (verify skill alias, monitor updates, worktree updates)
   - 2.1.107: +119 tokens (thinking frequency)
   - 2.1.108: +885 tokens (REPL tool, allowed-tools syntax)
   - 2.1.109: +0 tokens (no prompt changes)
   - 2.1.110: +590 tokens (PushNotification, heredoc guidance)

---

## Raw Changelog Excerpts

### Version 2.1.110
```
- new `/tui` command for flicker-free rendering
- push notification capabilities
- improved plugin management
- MCP tool call hangs fixes
- session cleanup fixes
- permission rule enforcement fixes
```

### Version 2.1.109
```
- rotating progress hint for extended-thinking indicator
```

### Version 2.1.108
```
- prompt caching TTL configuration (ENABLE_PROMPT_CACHING_1H, FORCE_PROMPT_CACHING_5M)
- recap feature for returning to sessions
- improved error messaging for rate limits and server issues
```

### Version 2.1.107
```
- thinking hints shown sooner during long operations
```

### Version 2.1.105
```
- `path` parameter added to EnterWorktree tool
- PreCompact hook support
- background monitor support for plugins
- stalled API stream handling improvements
- file write display improvements
```

### Version 2.1.101
```
- `/team-onboarding` command
- OS CA certificate store trust by default
- improved brief and focus modes
- paste functionality fixes
- session resume fixes
- terminal escape code handling fixes
```

---

## Stage 2: Verification Results
### Verified: 2026-04-16

#### Must Update Verification

- ! **NEW REPL tool** (CC 2.1.108) -- RECLASSIFIED: "tool-reference skill" does not exist in plugin-dev. Should update `plugin-structure` (available tools list) or `command-development` (tool descriptions). Note: REPL is a new tool for JavaScript scripting, confirmed in system-prompts.
- ! **NEW PushNotification tool** (CC 2.1.110) -- RECLASSIFIED: Same issue - "tool-reference skill" does not exist. Update `plugin-structure` or create a new reference doc for tools.
- ! **EnterWorktree tool: new `path` parameter** (CC 2.1.105) -- RECLASSIFIED: No "tool-reference skill" exists. This is for worktree entry, which relates to `agent-development` (worktree isolation) more than a tool reference. Low priority - minor tool enhancement.
- X **Allowed-tools syntax change: colon-separated to space-separated** (CC 2.1.108) -- CONFIRMED and CRITICAL. Found 8+ files still using old `Bash(npm:*)` syntax that need updating to `Bash(npm *)`:
  - `skills/command-development/SKILL.md` line 534
  - `skills/command-development/references/frontmatter-reference.md` line 104
  - `skills/command-development/references/advanced-workflows.md` lines 121, 148
  - `skills/command-development/examples/simple-commands.md` line 100
  - `skills/plugin-structure/references/github-actions.md` line 118
  - Note: `skills/agent-development/references/permission-modes-rules.md` already uses correct space-separated syntax (`Bash(npm *)`)
- X **Agent tool renamed from "Agent" to "R4"** (CC 2.1.105) -- DEMOTED to No Action. This is internal naming only, shown in disallowedTools context of Explore/Plan agents. Not relevant to plugin development documentation.
- X **/tui command** (CC 2.1.110) -- DEMOTED to No Action. Internal CLI feature, not relevant to plugin development.
- X **/team-onboarding command and skill** (CC 2.1.101) -- DEMOTED to No Action. Built-in CC command, not plugin development related.
- X **/insights command and skill** (CC 2.1.101) -- DEMOTED to No Action. Built-in CC command for usage reports.
- X **/loop dynamic mode and self-pacing** (CC 2.1.101) -- DEMOTED to No Action. Built-in CC autonomous loop features.
- X **PreCompact hook support** (CC 2.1.105) -- ALREADY DOCUMENTED. PreCompact hook exists in `hook-development/SKILL.md` lines 606+. However, CC 2.1.105 adds ability to block compaction via exit code 2 or `{"decision":"block"}` - this specific capability is NOT documented.
- X **Background monitor for plugins** (CC 2.1.105) -- PARTIALLY DOCUMENTED. `agent-development/SKILL.md` line 251 mentions "Monitor (CC 2.1.98)" tool. The CC 2.1.105 "silence is not success" guidance and plugin support is new.
- X **/dream nightly schedule skill** (CC 2.1.97, visible in 2.1.101) -- DEMOTED to No Action. Built-in CC memory feature.
- X **Managed Agents documentation overhaul** (CC 2.1.97, visible in 2.1.101+) -- DEMOTED to No Action. This is Anthropic API documentation, not Claude Code plugin development.
- X **Prompt caching TTL configuration** (CC 2.1.108) -- DEMOTED to No Action. Internal env vars for API usage, not plugin development.

#### Missed Items (promoted from No Action)

- ! **PreCompact hook blocking capability** (CC 2.1.105) -- PROMOTED from partial documentation
  - Affects: hook-development
  - Details: Hooks can now block compaction with exit code 2 or `{"decision":"block"}`. The PreCompact event already exists but blocking capability is new.

- ! **Sleep tool removed / Snooze tool replaces Sleep** (CC 2.1.92) -- Already in No Action but should be noted. Sleep tool removed is documented as CC 2.1.92, but that predates the version range (starts at 2.1.99). No action needed.

#### May Update Resolution

- = **Agent tool "trust but verify" guidance** (CC 2.1.105) -- kept as May Update. Good practice guidance but not critical for plugin development.
- ↓ **Fork usage guidelines simplified** (CC 2.1.105) -- demoted to No Action. Internal CC guidance.
- ↓ **Communication style heading renamed** (CC 2.1.104) -- demoted to No Action. Internal naming.
- = **Verify skill restructured** (CC 2.1.97, updates through 2.1.105) -- kept as May Update. Could inform testing/verification patterns.
- ↓ **Sleep duration guidance relaxed** (CC 2.1.108) -- demoted to No Action. Minor internal change.
- = **Heredoc piping guidance for REPL/Bash** (CC 2.1.110) -- kept as May Update. Relevant to script execution patterns.
- ↓ **Session recap feature** (CC 2.1.108) -- demoted to No Action. User feature, not plugin dev.
- ↓ **Sandbox Network Callback threat definition** (CC 2.1.110) -- demoted to No Action. Internal security monitoring.
- ↓ **Model catalog formatting** (CC 2.1.108) -- demoted to No Action. Cosmetic change.

#### Summary

- Must Update: 3 items remaining (1 CRITICAL - allowed-tools syntax, 2 reclassified for correct skill targets)
  - 3 confirmed (allowed-tools syntax, REPL tool, PushNotification tool - but skill targets corrected)
  - 11 rejected/demoted (built-in commands, internal features, API docs)
  - 1 added (PreCompact blocking capability)
- May Update: 3 items remaining
- Confidence: MEDIUM-HIGH
  - Stage 1 correctly identified the allowed-tools syntax change as critical
  - Stage 1 incorrectly referenced "tool-reference skill" which does not exist
  - Several items were built-in CC features, not plugin development items
  - PreCompact blocking capability was partially missed

#### Corrected Must Update Items for Stage 3

1. **CRITICAL: Allowed-tools syntax change** (CC 2.1.108)
   - Affects: skill-development, command-development, all files using permission examples
   - Action: Update all `Bash(npm:*)` to `Bash(npm *)`, `Bash(git:*)` to `Bash(git *)`, etc.
   - Files to update:
     - `skills/command-development/SKILL.md`
     - `skills/command-development/references/frontmatter-reference.md`
     - `skills/command-development/references/advanced-workflows.md`
     - `skills/command-development/examples/simple-commands.md`
     - `skills/plugin-structure/references/github-actions.md`

2. **PreCompact hook blocking capability** (CC 2.1.105)
   - Affects: hook-development
   - Action: Add note that PreCompact hooks can return `{"decision":"block"}` or exit code 2 to block compaction

3. **Background monitor plugin support - "silence is not success"** (CC 2.1.105)
   - Affects: hook-development, agent-development
   - Action: Add guidance that monitors should capture failure states, not just success. Add top-level `monitors` manifest key documentation if needed.

4. **REPL tool** (CC 2.1.108) - Optional/Low Priority
   - Affects: plugin-structure (tool list) or new reference doc
   - Action: Mention REPL as new tool for JavaScript scripting in any tool listings

5. **PushNotification tool** (CC 2.1.110) - Optional/Low Priority
   - Affects: plugin-structure (tool list) or new reference doc
   - Action: Mention PushNotification tool for desktop/mobile notifications
