# Upstream Change Manifest
## CC Version Range: 2.1.99 - 2.1.104
## Generated: 2026-04-13
## Sources: changelog [partial], system-prompts [full], claude-code-guide [full]

> **Note:** The CC changelog fetch returned partial data (2.1.99-2.1.100 not included in fetched content). System-prompts changelog provided complete coverage for the version range. Version 2.1.99 appears to have been skipped (no entry exists in system-prompts changelog between 2.1.98 and 2.1.100).

---

### Must Update

- [ ] **Fork usage guidelines: removed "don't peek" exception** (CC 2.1.101)
  - Source: system-prompts changelog (verified)
  - Confidence: high
  - Affects: agent-development skill
  - Details: Previously agents could read fork output if user explicitly requested. Now unconditionally prohibits reading or tailing fork output files. This changes documented fork behavior.
  - Raw changelog: "System Prompt: Fork usage guidelines - Relaxed the 'don't peek' rule: removed the exception allowing users to explicitly request a progress check; now unconditionally prohibits reading or tailing fork output files."
  - Gap location: agent-development/SKILL.md lines 629-638 discuss fork execution but do not mention the "don't peek" rule

- [ ] **Plugin hooks run with allowManagedHooksOnly** (CC 2.1.101)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: hook-development skill
  - Details: Plugin hooks from force-enabled plugins now run even when org has `allowManagedHooksOnly` enabled. Important for enterprise plugin deployment.
  - Raw changelog: "Plugin hooks from force-enabled plugins run when `allowManagedHooksOnly` is set"

- [ ] **Settings resilience for hook event names** (CC 2.1.101)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: hook-development skill
  - Details: Unrecognized hook event names no longer cause entire settings file to be ignored. Only the unrecognized event is skipped. Improves debugging experience.
  - Raw changelog: "Settings resilience: unrecognized hook event names no longer cause entire file to be ignored"

- [ ] **Skills not honoring context: fork and agent frontmatter** (CC 2.1.101 - BUG FIX)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: skill-development skill
  - Details: Bug fix - skills with `context: fork` and `agent` frontmatter were not being honored. Now fixed. This is critical for skill developers using these features.
  - Raw changelog: "skills not honoring `context: fork` and `agent` frontmatter"

- [ ] **Subagents didn't inherit MCP tools from dynamically-injected servers** (CC 2.1.101 - BUG FIX)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: agent-development, mcp-integration skills
  - Details: Bug fix for subagent MCP tool inheritance. Subagents now properly inherit MCP tools from dynamically-injected servers.
  - Raw changelog: "Subagents didn't inherit MCP tools from dynamically-injected servers"

- [ ] **Sub-agents in isolated worktrees denied Read/Edit access** (CC 2.1.101 - BUG FIX)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: agent-development skill
  - Details: Bug fix - sub-agents in isolated worktrees were incorrectly denied Read/Edit access to their own worktree files. Now fixed.
  - Raw changelog: "Sub-agents in isolated worktrees denied Read/Edit access to own worktree files"

- [ ] **permissions.deny not overriding PreToolUse hook permissionDecision** (CC 2.1.101 - BUG FIX)
  - Source: CC changelog (WebFetch verified)
  - Confidence: high
  - Affects: hook-development skill
  - Details: Bug fix - `permissions.deny` rules were not overriding PreToolUse hook `permissionDecision: "ask"`. Now properly enforced.
  - Raw changelog: "permissions.deny rules weren't overriding PreToolUse hook `permissionDecision: \"ask\"`"

---

### May Update

- [ ] **Communication style section renamed** (CC 2.1.104)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: skill documentation examples (if any)
  - Details: Section heading changed from "Communication style" to "Text output (does not apply to tool calls)" to clarify guidelines apply only to text output, not tool calls. Informational only - does not affect plugin development practices.
  - Raw changelog: "System Prompt: Communication style - Renamed section heading from 'Communication style' to 'Text output (does not apply to tool calls)' to clarify that the guidelines apply only to text output, not tool calls."

- [ ] **Autonomous loop check system prompt** (CC 2.1.101)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: agent-development skill (informational)
  - Details: New behavior for autonomous timer-based invocations using cloud infrastructure. Plugins cannot replicate this directly, but agent developers may want to know autonomous patterns exist in CC.
  - Raw changelog: "**NEW:** System Prompt: Autonomous loop check - Added behavior for autonomous timer-based invocations..."

---

### No Action

- OS CA certificate store trust by default for enterprise proxies (CC 2.1.101) - Infrastructure, not plugin-related
- Auto-creation of cloud environments for remote sessions (CC 2.1.101) - Backend feature
- Improved brief mode retry logic for plain text responses (CC 2.1.101) - Internal behavior
- Enhanced focus mode with self-contained summaries (CC 2.1.101) - UI feature
- Better tool-not-available error messaging (CC 2.1.101) - Error handling
- Improved rate-limit retry messages with specific reset times (CC 2.1.101) - Error handling
- Security fixes and permission handling improvements (CC 2.1.101) - Security hardening
- v2.1.102, v2.1.103 - No system-prompt changes detected (versions may not exist or have no prompt changes)
- ScheduleWakeup tool (CC 2.1.101) - CC internal tool for /loop, not available to plugins
- Snooze tool (CC 2.1.101) - CC internal tool for /loop, not available to plugins
- /loop slash command (CC 2.1.101) - CC built-in command using cloud infrastructure, not a plugin pattern
- /insights slash command (CC 2.1.101) - CC built-in command, not a plugin pattern
- Build Claude API skill prompt caching default (CC 2.1.101) - CC internal skill behavior, not plugin-controllable
- REMOVED: Three communication/output system prompts (CC 2.1.100) - CC internal prompts, no plugin impact
- Team onboarding guide generation (CC 2.1.101) - CC built-in feature, not a plugin pattern
- /loop slash command extension points (CC 2.1.101) - CC internal extension mechanism, not available to plugins

---

## Summary

**Total changes in range:** 23 identified (after Stage 2 verification)
- **Must update:** 7 items (fork behavior, hook fixes, skill/agent bug fixes)
- **May update:** 2 items (communication style rename, autonomous loop info)
- **No action:** 16 items (infrastructure, internal behavior, CC-only features)

**Key themes in this release (plugin-relevant):**
1. **Fork behavior change** - No more "peek" exception for reading fork output
2. **Hook resilience** - Unrecognized event names no longer break entire settings file
3. **Enterprise hooks** - Force-enabled plugin hooks run with allowManagedHooksOnly
4. **Critical bug fixes** - Skills `context: fork`/`agent` frontmatter, subagent MCP inheritance, worktree access

**Recommended priority:**
1. Document fork "don't peek" change in agent-development skill
2. Add hook resilience note to hook-development skill
3. Note resolved bug fixes in compatibility docs (skills frontmatter, subagent MCP, worktree access)
4. Document allowManagedHooksOnly behavior for enterprise deployments

---

## Notes

1. **Stage 2 verification corrected significant issues**: Stage 1 referenced non-existent skills (tool-catalog, slash-command-creator, agent-creator, build-skills) and missed critical plugin bug fixes from the CC changelog.

2. **High-priority items for plugin-dev (corrected)**:
   - Fork "don't peek" exception removed (CC 2.1.101) - affects agent-development
   - Hook resilience for unrecognized event names (CC 2.1.101) - affects hook-development
   - Skills `context: fork` and `agent` frontmatter bug fix (CC 2.1.101) - affects skill-development
   - Subagent MCP tool inheritance bug fix (CC 2.1.101) - affects agent-development, mcp-integration
   - allowManagedHooksOnly now allows force-enabled plugin hooks (CC 2.1.101) - affects hook-development

3. **Both changelogs are necessary**: System-prompts changelog captures prompt/tool description changes, but CC changelog contains critical plugin runtime bug fixes not reflected in system-prompts.

4. **Token delta summary**:
   - 2.1.100: -845 tokens (removed three system prompts)
   - 2.1.101: +4,676 tokens (autonomous loop system, /loop skills, /insights)
   - 2.1.104: +8 tokens (minor heading change)

5. **Note on version 2.1.99**: No entry exists in the system-prompts changelog between 2.1.98 and 2.1.100. This version was likely skipped or contained only infrastructure changes not reflected in system prompts.

6. **Note on versions 2.1.102/2.1.103**: No entries found in system-prompts changelog. These versions may have been internal releases or contained no prompt changes.

7. **Actual skill names in plugin-dev**:
   - skill-development (not "build-skills")
   - command-development (not "slash-command-creator")
   - agent-development (not "agent-creator")
   - hook-development
   - mcp-integration
   - plugin-structure
   - plugin-settings
   - lsp-integration
   - marketplace-structure
   - plugin-dev-guide
   - update-from-upstream

---

## Stage 2: Verification Results
### Verified: 2026-04-13

#### Must Update Verification

- X **ScheduleWakeup tool** (CC 2.1.101) — RECLASSIFIED: Skill mapping incorrect. Manifest listed "tool-catalog" which does not exist. No equivalent skill in plugin-dev documents built-in tools. However, this is Claude Code internal behavior, not something plugin developers would document. Demoted to No Action.

- X **Snooze tool** (CC 2.1.101) — RECLASSIFIED: Same issue as ScheduleWakeup. No "tool-catalog" skill exists. This is internal CC behavior for /loop command, not a plugin development concern. Demoted to No Action.

- X **/loop slash command** (CC 2.1.101) — RECLASSIFIED: Skill mapping incorrect. Listed "slash-command-creator" which does not exist; should be "command-development". However, /loop is a built-in CC slash command, not a pattern for plugin developers to replicate. The /loop command uses cloud scheduling and background monitoring features not available to plugins. Demoted to No Action.

- X **/insights slash command** (CC 2.1.101) — RECLASSIFIED: Same reasoning as /loop. Built-in CC command, not a plugin development pattern. Demoted to No Action.

- ! **Autonomous loop check system prompt** (CC 2.1.101) — RECLASSIFIED: Affects "agent-development" (not "agent-creator" which does not exist). However, this is CC internal behavior for autonomous timer-based invocations, not directly applicable to plugin agent development. The autonomous loop system uses cloud infrastructure (ScheduleWakeup, cron jobs) not available to plugins. Demoted to May Update - could mention autonomous patterns exist but plugins cannot replicate this.

- ! **Fork usage guidelines: removed "don't peek" exception** (CC 2.1.101) — CONFIRMED with correction. Skill mapping should be "agent-development" (not "agent-creator"). Gap exists: agent-development/SKILL.md mentions fork execution modes at line 629-638 but does not document the "don't peek" rule or its change. This is relevant for plugin developers creating agents that spawn forks.
  - Affects: agent-development
  - Gap confirmed at: /home/runner/work/plugin-dev/plugin-dev/plugins/plugin-dev/skills/agent-development/SKILL.md

- ! **Build Claude API skill: prompt caching now default** (CC 2.1.101) — RECLASSIFIED: Skill mapping incorrect. Listed "build-skills" which does not exist. The actual skill is "skill-development". However, this change is about Claude Code's internal "Build Claude API and SDK apps" skill, not about plugin skill development patterns. Plugin developers do not control whether their skills use prompt caching. Demoted to No Action.

#### Missed Items (promoted from No Action)

- ! **Plugin hooks from force-enabled plugins run when allowManagedHooksOnly is set** (CC 2.1.101) — MISSED from CC changelog. This is directly relevant to plugin hook development.
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: hook-development
  - Details: Plugin hooks now execute even when org has `allowManagedHooksOnly` enabled, if the plugin is force-enabled. This is important for enterprise plugin deployment.

- ! **Settings resilience: unrecognized hook event names no longer cause entire file to be ignored** (CC 2.1.101) — MISSED from CC changelog. Directly relevant to hook development.
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: hook-development
  - Details: Previously a typo in a hook event name would silently break all hooks in settings.json. Now only the unrecognized event is skipped.

- ! **Multiple plugin bug fixes** (CC 2.1.101) — MISSED from CC changelog. Multiple plugin-relevant bug fixes:
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: plugin-structure, skill-development
  - Details:
    - Slash commands resolving to wrong plugin
    - `/plugin update` failing with ENAMETOOLONG
    - Discover showing installed plugins
    - Stale version cache
    - Skills not honoring `context: fork` and `agent` frontmatter (CRITICAL - this was broken!)

- ! **Subagents didn't inherit MCP tools from dynamically-injected servers** (CC 2.1.101) — MISSED from CC changelog.
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: agent-development, mcp-integration
  - Details: Bug fix for subagent MCP tool inheritance. Relevant for plugins using agents with MCP servers.

- ! **Sub-agents in isolated worktrees denied Read/Edit access to own worktree files** (CC 2.1.101) — MISSED from CC changelog.
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: agent-development
  - Details: Bug fix for worktree-isolated subagents. Relevant for plugin agents using worktree isolation.

- ! **permissions.deny rules weren't overriding PreToolUse hook permissionDecision: "ask"** (CC 2.1.101) — MISSED from CC changelog.
  - Source: CC changelog 2.1.101 (WebFetch confirmed)
  - Affects: hook-development
  - Details: Bug fix for permission interaction between deny rules and hook decisions.

#### May Update Resolution

- = **Communication style section renamed** (CC 2.1.104) — Kept as May Update. The rename from "Communication style" to "Text output (does not apply to tool calls)" is informational but does not affect plugin development practices.

- DOWN **REMOVED: Three communication/output system prompts** (CC 2.1.100) — Demoted to No Action. These were internal CC prompts, not something plugin developers reference or depend on.

- DOWN **Team onboarding guide generation** (CC 2.1.101/2.1.94) — Demoted to No Action. This is a built-in CC feature, not a plugin development pattern.

- DOWN **/loop slash command extension points** (CC 2.1.101) — Demoted to No Action. The extension points are for CC internal use, not available to plugins.

#### Summary

- Must Update: 1 item confirmed (fork "don't peek" removal), 6 rejected/demoted, 6 added from missed items = **7 total**
- May Update: 1 item remaining (communication style rename)
- No Action: 8 original + 6 demoted from Must Update + 3 demoted from May Update = **17 items**
- Confidence: MEDIUM - Stage 1 had significant skill mapping errors (referenced non-existent skills) and missed important plugin-specific bug fixes from CC changelog

#### Critical Issues Found

1. **Skill name errors**: Stage 1 referenced skills that do not exist:
   - "tool-catalog" - does not exist
   - "slash-command-creator" - should be "command-development"
   - "agent-creator" - should be "agent-development"
   - "build-skills" - should be "skill-development"

2. **Missed plugin bug fixes**: The CC changelog 2.1.101 contained multiple plugin-specific bug fixes that were not captured. The system-prompts changelog was prioritized but the CC changelog contains critical plugin runtime fixes.

3. **Misclassification of CC internal features**: Several items were classified as "Must Update" but are actually CC internal features (ScheduleWakeup, Snooze, /loop, /insights) that plugins cannot replicate or document meaningfully.

---

## Raw Changelog Excerpts

### Version 2.1.104 (system-prompts)
```
- System Prompt: Communication style -- Renamed section heading from "Communication style"
  to "Text output (does not apply to tool calls)" to clarify that the guidelines apply
  only to text output, not tool calls.
```

### Version 2.1.101 (system-prompts)
```
+4,676 tokens

NEW:
- System Prompt: Autonomous loop check
- System Reminder: Loop wakeup not scheduled
- Tool Description: ScheduleWakeup (/loop dynamic mode)
- Tool Description: Snooze (delay and reason guidance)
- Skill: /insights report output
- Skill: /loop cloud-first scheduling offer
- Skill: /loop self-pacing mode
- Skill: /loop slash command (dynamic mode)
- Skill: Dynamic pacing loop execution
- Skill: Schedule recurring cron and execute immediately (compact)
- Skill: Schedule recurring cron and run immediately

UPDATED:
- Skill: Build Claude API and SDK apps -- prompt caching as default, expanded triggers
- Skill: /loop slash command -- added extension points
- System Prompt: Fork usage guidelines -- removed "don't peek" exception
```

### Version 2.1.101 (CC changelog)
```
- Team onboarding guide generation from local Claude Code usage
- OS CA certificate store trust by default for enterprise proxies
- Auto-creation of cloud environments for remote sessions
- Improved brief mode retry logic for plain text responses
- Enhanced focus mode with self-contained summaries
- Better tool-not-available error messaging
- Improved rate-limit retry messages with specific reset times
- Multiple security fixes and permission handling improvements
```

### Version 2.1.100 (system-prompts)
```
-845 tokens

REMOVED:
- System Prompt: Exploratory questions -- analyze before implementing
- System Prompt: Output efficiency
- System Prompt: User-facing communication style

UPDATED:
- System Prompt: Communication style -- tightened end-of-turn summary to
  "one or two sentences. What changed and what's next. Nothing else."
```
