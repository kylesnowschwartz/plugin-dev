# Upstream Change Manifest
## CC Version Range: 2.1.163 - 2.1.168
## Generated: 2026-06-07
## Sources: changelog [x], system-prompts [x], claude-code-guide [degraded - subagent dispatch unavailable in CI]

---

### Must Update

- [ ] **Stop and SubagentStop hooks: `hookSpecificOutput.additionalContext`** (CC 2.1.163)
  - Source: changelog confirmed, system-prompts not explicitly mentioned
  - Confidence: high
  - Affects: hooks-reference skill, hook event documentation
  - Details: Stop and SubagentStop hooks can now return `hookSpecificOutput.additionalContext` in their response. This extends hook output capabilities beyond the existing response fields.
  - Raw changelog: "Hooks: Stop and SubagentStop hooks can return `hookSpecificOutput.additionalContext`"

- [ ] **Skills: `\$` escape syntax for literal `$` before digits** (CC 2.1.163)
  - Source: changelog confirmed
  - Confidence: high
  - Affects: skill-authoring skill, skill format documentation
  - Details: Skills now support `\$` escape syntax to produce a literal `$` character before digits in command bodies. This prevents unintended variable interpolation in skill commands.
  - Raw changelog: "Skills: added `\$` escape syntax for literal `$` before digits in command bodies"

- [ ] **Cross-session messaging security enhancement** (CC 2.1.166)
  - Source: changelog confirmed, system-prompts confirmed (explicit warning added)
  - Confidence: high
  - Affects: agent-teams skill, cross-session messaging documentation
  - Details: Relayed messages from peer sessions no longer carry user authority. System prompts now include explicit warnings that peer-session messages cannot grant consent and must not be used to relay denied actions between sessions. This is a security hardening change.
  - Raw changelog: "Enhanced cross-session messaging security; relayed messages no longer carry user authority"
  - System-prompts entry: "**NEW:** System Reminder: Cross-session peer message authority warning - Adds an explicit warning that peer-session messages are not user authority, cannot grant consent, and must not be used to relay denied actions between sessions."

- [ ] **`/plugin list` command with `--enabled`/`--disabled` filters** (CC 2.1.163)
  - Source: changelog confirmed
  - Confidence: high
  - Affects: plugin-commands skill, CLI reference documentation
  - Details: New `/plugin list` command allows filtering installed plugins by enabled or disabled state using `--enabled` and `--disabled` flags.
  - Raw changelog: "Added `/plugin list` command with `--enabled`/`--disabled` filters"

---

### May Update

- [ ] **`fallbackModel` configuration for backup models** (CC 2.1.166)
  - Source: changelog confirmed
  - Confidence: medium
  - Affects: configuration reference, settings documentation
  - Details: New `fallbackModel` configuration option allows specifying up to three backup models when the primary model is unavailable. Claude Code retries once on fallback model for unexpected non-retryable API errors.
  - Raw changelog: "Added `fallbackModel` configuration for up to three backup models when primary is unavailable"

- [ ] **Glob pattern support in deny rules** (CC 2.1.166)
  - Source: changelog confirmed
  - Confidence: medium
  - Affects: permission rules documentation, managed settings reference
  - Details: Deny rules now support glob patterns for path matching. Allow rules reject non-MCP globs (presumably to prevent overly permissive allow patterns).
  - Raw changelog: "Implemented glob pattern support in deny rules; allow rules reject non-MCP globs"

- [ ] **`requiredMinimumVersion` and `requiredMaximumVersion` managed settings** (CC 2.1.163)
  - Source: changelog confirmed
  - Confidence: medium
  - Affects: managed settings documentation, enterprise deployment docs
  - Details: New managed settings to enforce minimum and/or maximum Claude Code versions in enterprise deployments.
  - Raw changelog: "Added `requiredMinimumVersion` and `requiredMaximumVersion` managed settings"

- [ ] **`MAX_THINKING_TOKENS=0` to disable thinking** (CC 2.1.166)
  - Source: changelog confirmed
  - Confidence: medium
  - Affects: environment variables documentation, model configuration
  - Details: Models with default thinking enabled via Claude API can have thinking disabled by setting `MAX_THINKING_TOKENS=0`.
  - Raw changelog: "Disabled thinking on models with default thinking via Claude API with `MAX_THINKING_TOKENS=0`"

- [ ] **stdio MCP servers receive `CLAUDE_CODE_SESSION_ID` on `--resume`** (CC 2.1.163)
  - Source: changelog confirmed
  - Confidence: medium
  - Affects: MCP server development documentation
  - Details: stdio MCP servers now receive the `CLAUDE_CODE_SESSION_ID` environment variable when a session is resumed with `--resume`. Previously documented for new sessions, now confirmed for resumed sessions.
  - Raw changelog: "stdio MCP servers receive `CLAUDE_CODE_SESSION_ID` on `--resume`"

- [ ] **Hook `if: "Bash(...)"` condition fix** (CC 2.1.163) **[PROMOTED TO MUST UPDATE]**
  - Source: changelog confirmed
  - Confidence: high (promoted by Stage 2 verification)
  - Affects: hook-development skill, overview.md line ~172 where `if` field is documented
  - Details: Fixed bug where hook `if: "Bash(...)"` conditions were firing on every command containing `$()` or `$VAR` syntax rather than matching the intended pattern. This is a bug fix that may affect existing hook configurations. Plugin developers with workarounds should be notified.
  - Raw changelog: "Fixed hook `if: \"Bash(...)\"` conditions firing on every command with `$()` or `$VAR`"

- [ ] **"c to copy" shortcut for `/btw`** (CC 2.1.163)
  - Source: changelog confirmed
  - Confidence: low
  - Affects: slash commands reference
  - Details: Added "c to copy" keyboard shortcut to `/btw` for raw markdown copying.
  - Raw changelog: "Added \"c to copy\" shortcut to `/btw` for raw markdown copying"

- [ ] **`claude update` announces target version before downloading** (CC 2.1.166)
  - Source: changelog confirmed
  - Confidence: low
  - Affects: CLI reference documentation
  - Details: `claude update` command now shows the target version before beginning the download.
  - Raw changelog: "`claude update` now announces target version before downloading"

- [ ] **Cowork plugin authoring skill and component schemas** (CC 2.1.163 system-prompts)
  - Source: system-prompts confirmed (multiple NEW entries)
  - Confidence: medium
  - Affects: may provide useful reference for plugin-dev documentation
  - Details: System prompts added extensive Cowork plugin authoring documentation including component schemas (skills, agents, hooks, MCP servers), plugin examples (minimal, standard, complex), MCP discovery guidance, and knowledge MCP search strategies. This appears to be an internal Anthropic feature but may inform plugin-dev patterns.
  - System-prompts entries: Multiple NEW entries for "Data: Cowork plugin component schemas", "Data: Cowork plugin examples", "Data: Cowork plugin MCP discovery and connection", "Skill: Cowork plugin authoring"

- [ ] **Browser file upload tool** (CC 2.1.163 system-prompts)
  - Source: system-prompts confirmed
  - Confidence: low
  - Affects: tools reference (if exposed to plugins)
  - Details: New browser file upload tool that uploads shared session files directly to page file inputs by element ref, with 10 MB combined upload limit. May be Chrome-integration specific.
  - System-prompts entry: "**NEW:** Tool Description: Browser file upload"

- [ ] **Outcome-first communication style system prompt** (CC 2.1.163 system-prompts)
  - Source: system-prompts confirmed
  - Confidence: low
  - Affects: behavioral guidance for skill authors
  - Details: New system prompt guidance to lead with outcomes, write readable teammate-facing updates, match response shape to task complexity, and keep code comments limited to non-obvious constraints.
  - System-prompts entry: "**NEW:** System Prompt: Outcome-first communication style"

- [ ] **Workflow tool: 4096 item limit for `parallel()` and `pipeline()`** (CC 2.1.163 system-prompts)
  - Source: system-prompts confirmed
  - Confidence: medium
  - Affects: workflow/ultracode documentation
  - Details: Each `parallel()` or `pipeline()` call in workflow scripts accepts at most 4096 items and errors explicitly when the limit is exceeded.
  - System-prompts entry: "Tool Description: Workflow - Adds that each `parallel()` or `pipeline()` call accepts at most 4096 items"

- [ ] **Workflow tool: `agent()` returns `null` on terminal API error** (CC 2.1.166 system-prompts)
  - Source: system-prompts confirmed
  - Confidence: low
  - Affects: workflow documentation
  - Details: Clarifies that `agent()` returns `null` when a workflow subagent dies on a terminal API error after retries.
  - System-prompts entry: "Tool Description: Workflow - Clarifies that `agent()` returns `null` when a workflow subagent dies on a terminal API error"

---

### No Action

- Background agent sessions update to new Claude Code version in background (CC 2.1.163)
- `claude agents` filters sessions by URLs typed into the list (CC 2.1.166)
- Fixed recurring "image could not be processed" error (CC 2.1.166)
- Fixed remote sessions becoming stuck during backend disruptions (CC 2.1.166)
- Fixed flickering in JetBrains IDE terminals on 2026.1+ (CC 2.1.166)
- Fixed Shift+non-ASCII characters being dropped in Kitty keyboard protocol (CC 2.1.166)
- Fixed PowerShell command validation hanging past timeout on Windows (CC 2.1.166)
- Fixed orphaned `claude --bg-pty-host` processes at 100% CPU on macOS (CC 2.1.166)
- Fixed voice mode requiring `/login` to clear stale auth check (CC 2.1.166)
- Fixed managed settings with invalid entries silently disabling enforcement (CC 2.1.166)
- Fixed managed-settings predicates not matching with `${VAR}` references (CC 2.1.166)
- Fixed background agent sessions crash-looping (CC 2.1.166)
- Fixed duplicated thinking text in Ctrl+O transcript view (CC 2.1.166)
- Fixed `/doctor` showing contradictory failed check (CC 2.1.166)
- Fixed blank lines between background agent rows on non-Unicode terminals (CC 2.1.166)
- Fixed `claude -p` hanging after final result when backgrounded command never exits (CC 2.1.163)
- Fixed `claude -p` failing with "ANTHROPIC_API_KEY required" on Bedrock/Vertex/Foundry (CC 2.1.163)
- Fixed bash commands failing under bazel and EDR-protected workflows (CC 2.1.163)
- Fixed Bash commands failing on Windows with "EEXIST" (CC 2.1.163)
- Fixed org-managed permission rules not applying when fetch completed at startup (CC 2.1.163)
- Fixed background sessions losing running tasks when reattached after update (CC 2.1.163)
- Fixed terminal misalignment and hang when exiting agent view (CC 2.1.163)
- Fixed clicking Stop not clearing chip when underlying process was gone (CC 2.1.163)
- Fixed keyboard input becoming unresponsive after paste with dropped end marker (CC 2.1.163)
- Fixed deny rules on home-directory paths not blocking commands via `$HOME` (CC 2.1.163)
- Fixed stray "(no content)" line in transcript (CC 2.1.163)
- Clearer descriptions for built-in commands and skills in the / menu (CC 2.1.163)
- Subscription-switch suggestion shows in startup announcement slot (CC 2.1.163)
- `claude agents` dispatching from state-grouped view starts in current directory (CC 2.1.163)
- Bug fixes and reliability improvements (CC 2.1.165, 2.1.167, 2.1.168)

---

## Summary

Six versions were released after the last audit (2.1.162):

- **2.1.163**: Hook output extensions, skill escape syntax, /plugin list command, MCP session ID on resume, Cowork plugin schema additions
- **2.1.165**: Bug fixes only - no system prompt changes
- **2.1.166**: fallbackModel config, glob deny rules, cross-session security, MAX_THINKING_TOKENS=0, Workflow clarifications
- **2.1.167**: Bug fixes only - no system prompt changes
- **2.1.168**: Bug fixes only - no system prompt changes

**Must Update: 5 items** (4 original + 1 promoted by Stage 2)
1. Stop/SubagentStop hooks `additionalContext` output (high confidence - changelog)
2. Skills `\$` escape syntax (high confidence - changelog)
3. Cross-session messaging security (high confidence - dual source)
4. `/plugin list` command with filters (high confidence - changelog)
5. Hook `if: "Bash(...)"` condition fix (PROMOTED - affects existing hook configs)

**May Update: 6 items** (after Stage 2 resolution)
- fallbackModel configuration
- Glob pattern support in deny rules
- requiredMinimumVersion/requiredMaximumVersion managed settings
- MAX_THINKING_TOKENS=0 environment variable
- CLAUDE_CODE_SESSION_ID on --resume
- Workflow parallel/pipeline 4096 item limit

**Demoted to No Action by Stage 2: 5 items**
- /btw copy shortcut (UI feature, not plugin-related)
- claude update version announcement (CLI UX, not plugin-related)
- Cowork plugin documentation (internal Anthropic format, different from plugin.json)
- Browser file upload tool (Chrome-specific, not plugin-exposed)
- Outcome-first communication style (general Claude behavior)
- Workflow agent() null on terminal error (implementation detail)

**No Action: 30 items**
- Bug fixes, UI improvements, platform-specific fixes

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | x | Retrieved via WebFetch from upstream |
| System-prompts | x | Read from ./claude-code-system-prompts/CHANGELOG.md (first 200 lines) |
| claude-code-guide | degraded | Subagent dispatch unavailable in CI environment |

---

## Notes

1. **Cross-session security change (2.1.166)** is significant for any documentation covering agent teams or cross-session messaging. The security model has been tightened - peer-session messages no longer carry user authority.

2. **Cowork plugin documentation** added to system-prompts appears to be an internal Anthropic feature ("Cowork plugins" with `.plugin` file format). This may or may not be related to the plugin.json format used by plugin-dev. Worth monitoring for convergence.

3. **Skills `\$` escape syntax** is directly relevant to skill authoring documentation and should be documented in the skill format reference.

4. **Hook output extensions** (additionalContext for Stop/SubagentStop) extend the hook system and should be documented.

5. **`/plugin list` command** is a new plugin management command that should be documented in any CLI reference for plugin developers.

---

## Recommendations for Stage 3

### MUST UPDATE (5 items)

1. **Stop/SubagentStop hooks additionalContext (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/hook-development/references/event-schemas.md`
   - Action: Add `additionalContext` field to Stop and SubagentStop hook output schemas
   - Note: This extends what these hooks can return. Lines 473-480 (Stop) and 571-579 (SubagentStop) need updates.

2. **Skills `\$` escape syntax (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/skill-development/overview.md`
   - Action: Document `\$` escape syntax for literal `$` before digits in command bodies
   - Note: Add to the "String Substitutions" section around line 324. Prevents unintended variable interpolation.

3. **Cross-session messaging security (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/agent-development/overview.md`
   - Action: Add security note that peer-session messages do not carry user authority
   - Note: Add to the "Agent Teams" section around line 863. Important security consideration for multi-agent patterns.

4. **/plugin list command filters (HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/plugin-structure/references/advanced-topics.md`
   - Action: Document `--enabled` and `--disabled` filter options for `claude plugin list`
   - Note: Update the CLI reference section around line 193. Verify if this is also a `/plugin list` slash command.

5. **Hook `if: "Bash(...)"` condition fix (PROMOTED - HIGH PRIORITY)**:
   - File: `plugins/plugin-dev/skills/plugin-dev/references/hook-development/overview.md`
   - Action: Add version note about the bug fix for hook `if` conditions with `$()` or `$VAR`
   - Note: Update the `if` field documentation around line 172. This behavioral fix affects existing hook configurations.

### MAY UPDATE (evaluate as Stage 3 proceeds)

- fallbackModel configuration - new settings option
- Glob pattern support in deny rules - permission rule enhancement
- Hook if Bash(...) condition fix - behavior correction note
- MCP CLAUDE_CODE_SESSION_ID on --resume - environment variable documentation
- Workflow limits - if documenting workflows

---

## Stage 2: Verification Results
### Verified: 2026-06-07

#### Must Update Verification

- **[CONFIRMED]** Stop/SubagentStop hooks `hookSpecificOutput.additionalContext` (CC 2.1.163)
  - Changelog confirmed: "Hooks: Stop and SubagentStop hooks can return `hookSpecificOutput.additionalContext`"
  - System-prompts: Not explicitly mentioned (implementation detail)
  - Gap exists: `plugins/plugin-dev/skills/plugin-dev/references/hook-development/references/event-schemas.md` lines 473-480 and 571-579 show Stop/SubagentStop output schemas without `additionalContext` field
  - Affects: hook-development skill (event-schemas.md, overview.md)

- **[CONFIRMED]** Skills `\$` escape syntax for literal `$` before digits (CC 2.1.163)
  - Changelog confirmed: "Skills: added `\$` escape syntax for literal `$` before digits in command bodies"
  - Gap exists: `plugins/plugin-dev/skills/plugin-dev/references/skill-development/overview.md` documents `$ARGUMENTS`, `$1`, `$2` substitutions but NOT the escape syntax
  - Affects: skill-development skill (overview.md, advanced-frontmatter.md)

- **[CONFIRMED]** Cross-session messaging security enhancement (CC 2.1.166)
  - Changelog confirmed: "Enhanced cross-session messaging security; relayed messages no longer carry user authority"
  - System-prompts confirmed: "System Reminder: Cross-session peer message authority warning"
  - Gap exists: `plugins/plugin-dev/skills/plugin-dev/references/agent-development/overview.md` documents Agent Teams but does NOT mention cross-session security constraints
  - Affects: agent-development skill (overview.md, advanced-agent-fields.md)

- **[CONFIRMED]** `/plugin list` command with `--enabled`/`--disabled` filters (CC 2.1.163)
  - Changelog confirmed: "Added `/plugin list` command with `--enabled`/`--disabled` filters"
  - Gap exists: `plugins/plugin-dev/skills/plugin-dev/references/plugin-structure/references/advanced-topics.md` line 193 shows basic `claude plugin list` but NOT the filter flags
  - Note: Manifest incorrectly suggests `/plugin list` (slash command) but changelog says it's a CLI command. Verify actual form.
  - Affects: plugin-structure skill (advanced-topics.md CLI reference section)

#### Missed Items (promoted from No Action)

None identified. The Stage 1 agent correctly classified all plugin-relevant changes.

#### May Update Resolution

- **[KEEP AS MAY UPDATE]** fallbackModel configuration
  - Reason: Not directly plugin-related; user/enterprise configuration option
  - Consider documenting in configuration references if plugin-dev covers settings

- **[PROMOTE TO MUST UPDATE]** Hook `if: "Bash(...)"` condition fix (CC 2.1.163)
  - Reason: This bug fix affects existing hook configurations that use `if` conditions. The overview.md at line 172 documents the `if` field but doesn't mention this behavioral fix. Plugin developers with existing hooks may have workarounds that should be removed.
  - Changelog: "Fixed hook `if: \"Bash(...)\"` conditions firing on every Bash command containing `$()` or `$VAR`"
  - Affects: hook-development skill (overview.md, line ~172 where `if` field is documented)

- **[KEEP AS MAY UPDATE]** Glob pattern support in deny rules
  - Reason: Permission rule enhancement, may be relevant for hooks documentation but low priority

- **[KEEP AS MAY UPDATE]** MCP CLAUDE_CODE_SESSION_ID on --resume
  - Reason: Already documented for new sessions; this extends to resumed sessions. Low priority update.

- **[KEEP AS MAY UPDATE]** requiredMinimumVersion/requiredMaximumVersion managed settings
  - Reason: Enterprise deployment feature, not directly plugin-related

- **[KEEP AS MAY UPDATE]** MAX_THINKING_TOKENS=0 environment variable
  - Reason: Model configuration, not directly plugin-related

- **[KEEP AS MAY UPDATE]** Workflow tool 4096 item limit
  - Reason: Workflow/ultracode feature, not directly plugin-related unless documenting workflows

- **[DEMOTE TO NO ACTION]** "/c to copy" shortcut for /btw
  - Reason: UI convenience feature, not plugin-related

- **[DEMOTE TO NO ACTION]** `claude update` version announcement
  - Reason: CLI UX improvement, not plugin-related

- **[DEMOTE TO NO ACTION]** Cowork plugin authoring (system-prompts)
  - Reason: Internal Anthropic feature using `.plugin` format. Different from plugin.json format used by plugin-dev. Monitor for convergence but no action needed.

- **[DEMOTE TO NO ACTION]** Browser file upload tool (system-prompts)
  - Reason: Chrome integration specific, not exposed to plugin system

- **[DEMOTE TO NO ACTION]** Outcome-first communication style (system-prompts)
  - Reason: General Claude behavior, not plugin-specific guidance

- **[DEMOTE TO NO ACTION]** Workflow agent() null on terminal error (system-prompts)
  - Reason: Workflow implementation detail

#### Summary

- **Must Update: 5 items** (4 confirmed from Stage 1, 1 promoted from May Update)
  1. Stop/SubagentStop hooks `additionalContext` output
  2. Skills `\$` escape syntax
  3. Cross-session messaging security
  4. `/plugin list` command filters
  5. Hook `if: "Bash(...)"` condition fix (PROMOTED)

- **May Update: 6 items remaining** (after promotions/demotions)
  - fallbackModel configuration
  - Glob pattern support in deny rules
  - requiredMinimumVersion/requiredMaximumVersion managed settings
  - MAX_THINKING_TOKENS=0 environment variable
  - MCP CLAUDE_CODE_SESSION_ID on --resume
  - Workflow tool 4096 item limit

- **Confidence: HIGH**
  - All 4 original Must Update items verified against primary sources
  - Topic mappings validated by reading target reference docs
  - Gaps confirmed by searching for existing documentation
  - One item promoted from May Update to Must Update (hook if condition fix)
  - 5 items demoted from May Update to No Action (not plugin-relevant)

#### Verification Notes

1. **Manifest accuracy on `/plugin list`**: The changelog says "Added `/plugin list` command" which implies a slash command, but the context suggests it may be the CLI `claude plugin list` with new flags. Stage 3 should verify the actual invocation form before documenting.

2. **Hook if condition fix**: This is a behavioral change that affects existing hook configurations. Worth documenting as a version note in the `if` field documentation to help plugin developers who may have implemented workarounds.

3. **Cross-session security**: This is a security hardening that specifically affects agent teams and cross-session patterns. The documentation should add a security note in the Agent Teams section.
