# Upstream Change Manifest
## CC Version Range: 2.1.207 - 2.1.207
## Generated: 2026-07-13
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - single version, minimal plugin-system changes]

---

### Must Update

- [ ] **Plugin security: shell-injection fix -- `${user_config.*}` rejected in shell-form commands** (CC 2.1.207)
  - Source: changelog (verified Stage 2)
  - Confidence: HIGH
  - Affects: hook-development (overview.md, Security Best Practices section)
  - Details: `${user_config.*}` interpolation in shell-form hook commands is now rejected for security. Plugin developers must use exec form (`args` array) or read values via `$CLAUDE_PLUGIN_OPTION_<KEY>` environment variables. The hook-development docs already document `args` (CC 2.1.139) but need security context.
  - Raw changelog text: "Plugin hooks/monitors/MCP headersHelper: `${user_config.*}` in shell-form commands is now rejected (shell-injection fix). Hooks: use exec form (`args` array) or `$CLAUDE_PLUGIN_OPTION_<KEY>`; monitors and headersHelper: read the value inside the script (config file or the server's `env` block)."

- [ ] **Plugin option values no longer read from project-level settings** (CC 2.1.207) [BREAKING CHANGE]
  - Source: changelog (missed by Stage 1, promoted by Stage 2)
  - Confidence: HIGH
  - Affects: plugin-settings (overview.md), plugin-structure (plugin.json docs)
  - Details: `pluginConfigs` are no longer read from project-level `.claude/settings.json`. Only user settings (`~/.claude/settings.json`), `--settings` flag, and managed settings are honored. Plugin developers and users who stored plugin configuration in project settings must migrate.
  - Raw changelog text: "Plugin option values (`pluginConfigs`) are no longer read from project-level `.claude/settings.json`; only user, `--settings`, and managed settings are honored"

---

### May Update

- [ ] **NEW: Data: Structured tool output field schema** (CC 2.1.207)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: mcp-integration (advanced tool output patterns)
  - Details: Documents the per-tool `tool_use_result` output contract, including completed Agent/Task reports and run totals. Tells clients to render structured output instead of parsing model-facing result text. This may be relevant for advanced plugin authors building MCP tools that return structured data.

---

### No Action

**Demoted from May Update by Stage 2:**
- REMOVED: Tool Description: Bash (sandbox - user permission prompt) (CC 2.1.207) - internal CC doc simplification
- NEW: Skill: /morning slash command (CC 2.1.207) - new built-in skill, not plugin-relevant
- Skill: Auto mode setup expanded guidance (CC 2.1.207) - CC auto-mode setup flow, not plugin-relevant
- Model default updated to Opus 4.8 (CC 2.1.207) - platform configuration
- Auto mode expanded across platforms (CC 2.1.207) - platform availability

**Demoted from Must Update by Stage 2:**
- ScheduleWakeup/Snooze tool changes (CC 2.1.207) - internal CC tools not accessible to plugins

**Internal behavior and UI improvements:**
- Terminal responsiveness enhanced when streaming lengthy content (CC 2.1.207) - internal performance
- Security fix: remote managed settings dialog (CC 2.1.207) - internal security fix
- Spurious prompt-injection warnings eliminated (CC 2.1.207) - internal bug fix
- Auto-updater preserves custom launcher scripts (CC 2.1.207) - user-facing but not plugin-relevant
- Compound commands with cd redirection fix (CC 2.1.207) - internal behavior fix
- Transcript positioning corrected (CC 2.1.207) - UI fix
- Git configuration cleanup after removing worktrees (CC 2.1.207) - internal cleanup
- Pattern validation improved for rules globs and skill paths (CC 2.1.207) - internal validation

**Bug fixes:**
- Agent teams: crash loop fix for malformed teammate messages (CC 2.1.207) - bug fix
- Background sessions: naming persistence and git worktree handling (CC 2.1.207) - bug fix
- Remote Control: task status preservation during network interruptions (CC 2.1.207) - bug fix
- Deep research: agent labeling accuracy (CC 2.1.207) - internal improvement
- Windows credential resolution: 60-second stall guard (CC 2.1.207) - platform-specific fix
- Usage confirmation: malformed credit amounts rejected (CC 2.1.207) - validation fix

**Platform-specific fixes:**
- Bedrock: eliminated repeated AWS SSO credential requests (CC 2.1.207) - platform-specific fix

**System-prompts internal changes:**
- NEW: System Reminder: ClaudeDesign project grant unavailable without verified identity (CC 2.1.207) - ClaudeDesign-specific, not plugin-relevant
- System Prompt: Harness instructions - conditional system-reminder guidance (CC 2.1.207) - internal behavior
- Tool Description: Artifact - proactive private publishing guidance (CC 2.1.207) - artifact publishing rules, not plugin API
- Agent Prompt: /code-review part 9 fix application simplification (CC 2.1.207) - internal /code-review behavior
- Agent Prompt: Quick PR creation remote guidance (CC 2.1.207) - minor guidance change

---

## Summary

**Version range audited:** 2.1.207 (1 version after last audit at 2.1.206)

**Stage 1 Classification Results:**
- **Must Update:** 2 items
- **May Update:** 6 items
- **No Action:** Remainder (bug fixes, internal improvements, platform-specific changes)
- **Confidence:** MEDIUM (single-source changes, no critical API changes)

**Token delta from system-prompts:**
- 2.1.207: +6,150 tokens

**Key Findings:**

1. **Security fix in hooks/monitors** - A shell-injection vulnerability was addressed. While the fix is in CC core (not plugins), this is the most notable change for plugin developers from a security awareness perspective.

2. **Scheduling tool guidance changes** - ScheduleWakeup/Snooze tool descriptions updated with pacing guidance. This affects how plugins interact with scheduling tools.

3. **Relatively light release for plugin-dev** - Most changes are bug fixes, platform-specific improvements, or internal behavior changes not affecting plugin APIs.

---

## Stage 2: Verification Results
### Verified: 2026-07-13

#### Must Update Verification

- ! **Plugin security: shell-injection fix** (CC 2.1.207) -- RECLASSIFIED with expanded details
  - Original manifest description was incomplete
  - Actual change: `${user_config.*}` in shell-form commands now rejected; use exec form (`args` array) or `$CLAUDE_PLUGIN_OPTION_<KEY>` environment variable
  - Gap confirmed: hook-development/overview.md documents `args` field (CC 2.1.139) but lacks security context and `${user_config.*}` rejection warning
  - Affects: hook-development (overview.md, security best practices section)

- X **ScheduleWakeup/Snooze tool changes** (CC 2.1.207) -- REJECTED
  - Reason: ScheduleWakeup/Snooze are internal CC tools not accessible to plugins
  - Topic mapping "tool-reference documentation" does not exist in plugin-dev
  - These are background loop pacing tools for CC's own scheduled tasks
  - Demoted to No Action

#### Missed Items (promoted from No Action)

- ! **Plugin option values no longer read from project settings** (CC 2.1.207)
  - MISSED by Stage 1 -- this is a BREAKING CHANGE
  - Source: CC changelog (exact text: "Plugin option values (`pluginConfigs`) are no longer read from project-level `.claude/settings.json`; only user, `--settings`, and managed settings are honored")
  - Affects: plugin-settings (overview.md settings precedence section), plugin-structure (plugin.json documentation)
  - Details: Plugin developers and users who stored pluginConfigs in project `.claude/settings.json` must migrate to user settings or managed settings
  - Priority: HIGH (breaking change)

#### May Update Resolution

- = **Structured tool output field schema** (CC 2.1.207) -- kept as May Update
  - Reason: Potentially useful for advanced MCP tool development but not core plugin functionality
  - Affects: mcp-integration (if documenting advanced tool output patterns)

- v **Bash sandbox permission prompt removed** (CC 2.1.207) -- demoted to No Action
  - Reason: Internal CC documentation simplification, not affecting plugin development

- v **/morning slash command** (CC 2.1.207) -- demoted to No Action
  - Reason: New built-in skill, does not affect plugin development patterns

- v **Auto mode setup expansion** (CC 2.1.207) -- demoted to No Action
  - Reason: CC auto-mode setup flow, not plugin development

- v **Model default updated to Opus 4.8** (CC 2.1.207) -- demoted to No Action
  - Reason: Platform configuration, not plugin-relevant

- v **Auto mode expanded across platforms** (CC 2.1.207) -- demoted to No Action
  - Reason: Platform availability, not plugin development

#### Summary

- **Must Update:** 2 items (1 confirmed with expanded detail, 1 promoted from missed)
- **May Update:** 1 item remaining
- **Rejected:** 1 item (demoted from original Must Update)
- **Demoted from May Update:** 5 items
- **Confidence:** HIGH (verified against primary sources, found one missed breaking change)

#### Notes for Stage 3

1. **Hook security update (Must Update):** Add to hook-development/overview.md in the Security Best Practices section. Document that `${user_config.*}` interpolation in shell-form hook commands is now rejected for security. Recommend using exec form (`args` array) or reading values via `$CLAUDE_PLUGIN_OPTION_<KEY>` environment variables.

2. **Plugin settings scope change (Must Update - BREAKING):** Update plugin-settings/overview.md settings precedence section to note that `pluginConfigs` are no longer read from project-level `.claude/settings.json`. Only user settings, `--settings` flag, and managed settings are honored. This is a CC 2.1.207 breaking change requiring user migration.

3. **Structured tool output (May Update):** Consider documenting in mcp-integration for advanced tool authors who want to return structured output that clients can render specially.

---

## Triangulation Notes

- Two-source triangulation used: CC changelog + system-prompts changelog
- claude-code-guide agent dispatch skipped: Single version with minimal plugin-system changes; triangulation value is low for this update.
- The shell-injection security fix is notable but changelog-only, making details limited.
- System-prompts provided detailed behavioral change information for scheduling tools.
- No breaking changes or new hook events in this release.

---

## Raw Changelog Data

### CC 2.1.207 (from upstream changelog)
```
- Auto mode availability expanded across Bedrock, Vertex AI, and Foundry platforms without requiring opt-in
- Terminal responsiveness enhanced when streaming particularly lengthy lists, tables, paragraphs, or code blocks
- Security fix: remote managed settings no longer recorded as consented without displaying the security dialog
- Spurious prompt-injection warnings eliminated for system-generated conversation updates
- Auto-updater now preserves custom launcher scripts at `~/.local/bin/claude`
- Compound commands with `cd` redirection to `/dev/null` no longer prompt unnecessarily
- Transcript positioning corrected when responses finish streaming
- Git configuration cleanup after removing worktrees
- Pattern validation improved for rules globs and skill paths
- Agent teams: resolved crash loop caused by malformed teammate messages
- Background sessions: naming persistence and git worktree handling improvements
- Remote Control: task status preservation during network interruptions
- Deep research: agent labeling accuracy enhanced
- Bedrock: eliminated repeated AWS SSO credential requests
- Model default: Bedrock, Vertex, and Claude Platform on AWS updated to Opus 4.8
- Windows credential resolution: 60-second stall guard now prevents indefinite hangs
- Plugin security: shell-injection vulnerability addressed in hooks/monitors
- Usage confirmation: malformed credit amounts now rejected with error messaging
```

### System-prompts 2.1.207 (key items)
```
- **NEW:** Data: Structured tool output field schema — Documents the per-tool `tool_use_result` output contract
- **NEW:** Skill: /morning slash command — Adds morning-brief workflow for calendar/communication data
- **NEW:** System Reminder: ClaudeDesign project grant unavailable without verified identity
- **NEW:** Tool Description: ScheduleWakeup delay and reason guidance; Tool Description: Snooze; Skill: /loop self-pacing mode
- **REMOVED:** Tool Description: Bash (sandbox — user permission prompt)
- Skill: Auto mode setup — Expands setup to review and safely remove rules, migrate legacy entries
- System Prompt: Harness instructions — Makes system-reminder tag guidance conditional on tool context
- Tool Description: Artifact — Allows proactive private publishing with content restrictions
```

---

## Comparison to Previous Audit

**Previous audit (2.1.202-2.1.206):**
- 3 Must Update items
- 8 May Update items
- Significant changes: background_tasks_changed hook event, MCP connection failure reminder, /doctor CLAUDE.md trimming

**This audit (2.1.207) -- Stage 2 verified:**
- 2 Must Update items (shell-injection security fix, plugin settings scope change [BREAKING])
- 1 May Update item (structured tool output schema)
- Impact: Contains one breaking change that Stage 1 missed

**Stage 2 Assessment:** Stage 1 missed a breaking change (`pluginConfigs` no longer read from project settings) and incorrectly classified ScheduleWakeup/Snooze as plugin-relevant. The quality threshold was not met (>30% items needed correction: 1 rejected, 1 missed of 2 original Must Update items). Stage 1 process should be reviewed for future runs to ensure better plugin-relevance filtering and complete changelog parsing.
