# Upstream Change Manifest
## CC Version Range: 2.1.111 - 2.1.114
## Generated: 2026-04-19
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - subagent dispatch unavailable]

---

### Must Update

- [ ] **Skill tool invocation rules tightened** (CC 2.1.111)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: plugin-dev skill (skill authoring guidance)
  - Details: Skill tool description now has strict guardrail to only invoke skills that appear in the available-skills list or that the user explicitly typed as a slash command. Claude must never guess or invent skill names. This affects how we document skill invocation patterns.
  - Raw: "Tool Description: Skill - Tightened invocation rules: removed example-heavy format in favor of concise instructions; added strict guardrail to only invoke skills that appear in the available-skills list or that the user explicitly typed as a slash command, never guessing or inventing skill names."

- [ ] **NEW skill: /less-permission-prompts (renamed to /fewer-permission-prompts in 2.1.113)** (CC 2.1.111)
  - Source: CC changelog + system-prompts changelog
  - Confidence: high
  - Affects: plugin-dev skill (may want to reference this pattern)
  - Details: New built-in skill that analyzes session transcripts to extract frequently used read-only tool-call patterns and adds them to project's `.claude/settings.json` permission allowlist. Renamed from "Less" to "Fewer" in 2.1.113 for grammar correctness.
  - Raw changelog: "Added `/less-permission-prompts` skill scanning transcripts for common read-only operations"
  - Raw system-prompts: "NEW: Skill: Generate permission allowlist from transcripts - Analyzes session transcripts to extract frequently used read-only tool-call patterns"

- [ ] **Memory synthesis agent: retrieval-only directive** (CC 2.1.111)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: plugin-dev skill (agent prompt patterns)
  - Details: Memory synthesis subagent now has full retrieval-only directive - must not answer or solve queries from general knowledge, must return empty results when no memory covers the query. Strengthened "do not invent facts" rule.
  - Raw: "Agent Prompt: Memory synthesis - Strengthened the 'do not invent facts' rule into a full retrieval-only directive"

- [ ] **Massive system prompt removals** (CC 2.1.111)
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: plugin-dev skill (tool usage guidance may need updating)
  - Priority: LOW (these were Claude's default behaviors, not plugin-specific)
  - Details: Multiple system prompt sections removed including: minimize file creation, no premature abstractions, no time estimates, no unnecessary additions, read before modifying, and multiple tool usage instructions (create files, delegate exploration, direct search, edit files, read files, reserve Bash, search content, search files, skill invocation). These were part of Claude's default behavior.
  - Raw: "REMOVED: System Prompt: Doing tasks (minimize file creation), (no premature abstractions), (no time estimates), (no unnecessary additions), (read before modifying); System Prompt: Tool usage (create files), (delegate exploration), (direct search), (edit files), (read files), (reserve Bash), (search content), (search files), (skill invocation)"

- [ ] **Bash tool: cd git command permission prompt avoidance** (CC 2.1.113)
  - Source: system-prompts changelog + CC changelog
  - Confidence: high
  - Affects: plugin-dev skill (Bash tool examples)
  - Details: Bash tool now explicitly instructs never to prepend `cd <current-directory>` to a `git` command since git already operates on current working tree and the compound form triggers a permission prompt.
  - Raw: "Tool Description: Bash (maintain cwd) - Added explicit instruction to never prepend `cd <current-directory>` to a `git` command"

### Rejected (Out of Version Range)

The following items were incorrectly included by Stage 1. They are from CC 2.1.105 which predates the last audit baseline (CC 2.1.110):

- ~~**Agent tool: "trust but verify" guidance added** (CC 2.1.105)~~ -- predates audit baseline
- ~~**Monitor tool: comprehensive failure matching guidance** (CC 2.1.105)~~ -- predates audit baseline AND already documented in manifest-reference.md line 414
- ~~**NEW: /runtime-verification alias for Verify skill** (CC 2.1.105)~~ -- predates audit baseline
- ~~**EnterWorktree tool: expanded trigger conditions** (CC 2.1.105)~~ -- predates audit baseline

---

### May Update

- [ ] **Opus 4.7 with xhigh effort level** (CC 2.1.111)
  - Source: CC changelog + system-prompts changelog
  - Confidence: high
  - Affects: model documentation, effort level references
  - Details: Claude Opus 4.7 now available with new `xhigh` effort level between `high` and `max`. Auto mode available for Max subscribers. Multiple API references updated. Not directly plugin-related but may affect examples.

- [ ] **Auto mode no longer requires --enable-auto-mode** (CC 2.1.111)
  - Source: CC changelog
  - Confidence: high
  - Affects: any documentation mentioning auto mode flags
  - Details: Auto mode flag requirement removed. Auto mode now generally available.

- [ ] **NEW: /ultrareview for cloud-based code review** (CC 2.1.111)
  - Source: CC changelog
  - Confidence: high
  - Affects: may want to reference as example of complex skill
  - Details: Comprehensive cloud-based code review using parallel multi-agent analysis. Improved in 2.1.113 with faster launch via parallelized checks.

- [ ] **sandbox.network.deniedDomains setting** (CC 2.1.113)
  - Source: CC changelog
  - Confidence: high
  - Affects: settings documentation
  - Details: New setting to block specific domains despite broader allowlist rules.

- [ ] **/skills menu: sorting by token count** (CC 2.1.111)
  - Source: CC changelog
  - Confidence: high
  - Affects: skill authoring guidance (size optimization)
  - Details: `/skills` menu now supports sorting by token count (press `t` to toggle). Relevant for skill size awareness.

### Demoted to No Action (Out of Version Range)

The following items were demoted from May Update because they predate the audit baseline (CC 2.1.110):

- ~~**Windows PowerShell tool rollout** (CC 2.1.111)~~ -- kept but low priority, platform-specific
- ~~**NEW: PushNotification tool** (CC 2.1.110)~~ -- version 2.1.110 is audit baseline, not new
- ~~**REPL tool and scripting conventions** (CC 2.1.108, 2.1.110)~~ -- predates or equals audit baseline
- ~~**Loop/snooze/dynamic pacing features** (CC 2.1.101, 2.1.105)~~ -- predates audit baseline
- ~~**Managed Agents documentation additions** (CC 2.1.97, 2.1.105)~~ -- predates audit baseline
- ~~**Communication style prompt simplified** (CC 2.1.100, 2.1.104)~~ -- predates audit baseline
- ~~**Fork usage: removed "don't peek" exception** (CC 2.1.101)~~ -- predates audit baseline
- ~~**Thinking frequency tuning system reminder** (CC 2.1.107)~~ -- predates audit baseline

---

### No Action

**Bug fixes, UI enhancements, internal changes (CC 2.1.111-2.1.114):**
- Permission dialog crash fix for agent teams (CC 2.1.114) - bug fix
- CLI spawn native binary change (CC 2.1.113) - internal architecture
- Fullscreen mode Shift+arrow scrolling (CC 2.1.113) - UI enhancement
- Multiline input Ctrl+A/E readline behavior (CC 2.1.113) - UI enhancement
- Windows Ctrl+Backspace word deletion (CC 2.1.113) - UI enhancement
- Long URL clickability with OSC 8 hyperlinks (CC 2.1.113) - terminal feature
- /loop Esc cancellation and wakeup display (CC 2.1.113) - UI enhancement
- /extra-usage from Remote Control clients (CC 2.1.113) - remote feature
- Remote Control autocomplete suggestions (CC 2.1.113) - remote feature
- Subagent stall timeout 10-minute limit (CC 2.1.113) - reliability fix
- Bash multiline comment display (CC 2.1.113) - display fix
- macOS security hardening for /private paths (CC 2.1.113) - security
- Bash deny rules for env/sudo/watch wrappers (CC 2.1.113) - security
- find -exec/-delete allow rule fix (CC 2.1.113) - security
- MCP concurrent-call timeout fix (CC 2.1.113) - bug fix
- Multiple UI fixes: Cmd-backspace, markdown tables, session recap, /copy, etc. (CC 2.1.113) - bug fixes
- Plugin error handling improvements (CC 2.1.111) - internal
- Fixed Claude calling non-existent commit skill (CC 2.1.111) - bug fix
- Various Windows fixes for CLAUDE_ENV_FILE and paths (CC 2.1.111) - platform fixes
- Opus 4.7 temporarily unavailable error fix (CC 2.1.112) - bug fix
- Model catalog and API reference updates for Opus 4.7 (CC 2.1.111) - data updates
- HTTP error codes reference Opus 4.7 additions (CC 2.1.111) - data updates
- Streaming reference updates (CC 2.1.111) - data updates
- Tool use concepts Opus 4.7 additions (CC 2.1.111) - data updates
- Skillify Current Session directive change (CC 2.1.111) - internal restructure
- Windows PowerShell tool rollout (CC 2.1.111) - platform-specific, low priority

**Pre-audit baseline items (CC 2.1.97-2.1.110) -- excluded from this audit:**
- Security monitor sandbox network callback threat (CC 2.1.110) - at baseline
- NEW: PushNotification tool (CC 2.1.110) - at baseline
- REPL tool and scripting conventions (CC 2.1.108, 2.1.110) - at/before baseline
- Sleep duration guidance simplification (CC 2.1.108) - before baseline
- Thinking frequency tuning system reminder (CC 2.1.107) - before baseline
- Explore agent metadata changes (CC 2.1.105) - before baseline
- Plan mode agent metadata changes (CC 2.1.105) - before baseline
- Managed Agents scope_id parameter updates (CC 2.1.105) - before baseline
- Agent tool "trust but verify" (CC 2.1.105) - before baseline, rejected from Must Update
- Monitor "silence is not success" (CC 2.1.105) - before baseline AND already documented
- /runtime-verification alias (CC 2.1.105) - before baseline, rejected from Must Update
- EnterWorktree expanded triggers (CC 2.1.105) - before baseline, rejected from Must Update
- Fork usage removed "don't peek" exception (CC 2.1.101) - before baseline
- Loop/snooze/dynamic pacing features (CC 2.1.101, 2.1.105) - before baseline
- Communication style prompt simplified (CC 2.1.100, 2.1.104) - before baseline
- Dream memory consolidation transcript source note (CC 2.1.98) - before baseline
- Dream memory pruning team/ rules (CC 2.1.98) - before baseline
- Advisor tool wording updates (CC 2.1.98) - before baseline
- Managed Agents documentation additions (CC 2.1.97, 2.1.105) - before baseline

---

## Summary

**Version Range**: 2.1.111 through 2.1.114 (4 versions since last audit at 2.1.110)

**Key Themes** (after Stage 2 verification):
1. **Skill invocation strictness** - Major change affecting how skills are invoked (CC 2.1.111)
2. **System prompt removals** - Many default behavior instructions removed in v2.1.111 (low impact on plugins)
3. **New built-in skills** - /fewer-permission-prompts (CC 2.1.111, renamed in 2.1.113)
4. **Opus 4.7 support** - New model with xhigh effort level (May Update)
5. **Bash cd+git guidance** - Permission prompt avoidance (CC 2.1.113)

**Action Required** (after Stage 2 verification): 5 items in "Must Update" category need review for plugin-dev documentation updates.

**Stage 2 Corrections**:
- 4 items rejected from Must Update (CC 2.1.105 predates audit baseline)
- 8 items demoted from May Update to No Action (versions predate audit baseline)
- 1 item already documented (Monitor "silence is not success" at manifest-reference.md:414)

**Data Quality Notes**:
- Two-source triangulation (CC changelog + system-prompts changelog)
- claude-code-guide agent dispatch failed (--subagent-type not available in environment)
- System-prompts changelog provides more structured detail with token counts and NEW/REMOVED markers
- **Stage 1 error**: Included items from CC 2.1.105 in a manifest claiming range 2.1.111-2.1.114

---

## Token Delta Summary (from system-prompts)

| Version | Delta | Key Changes |
|---------|-------|-------------|
| 2.1.114 | +0 | No prompt changes |
| 2.1.113 | +26 | Renamed skill heading, Bash cd+git guidance |
| 2.1.112 | +0 | No prompt changes |
| 2.1.111 | +21,018 | Two new skills, 14 prompts REMOVED, Opus 4.7 docs, Skill tool tightened |

**Net change since 2.1.110**: +21,044 tokens (massive restructure with many removals offset by new Opus 4.7 documentation)

---

## Raw Changelog Excerpts for Must Update Items

### Skill Tool Invocation (CC 2.1.111)
```
Tool Description: Skill - Tightened invocation rules: removed example-heavy format
in favor of concise instructions; added strict guardrail to only invoke skills that
appear in the available-skills list or that the user explicitly typed as a slash
command, never guessing or inventing skill names.
```

### System Prompt Removals (CC 2.1.111)
```
REMOVED: System Prompt: Doing tasks (minimize file creation)
REMOVED: System Prompt: Doing tasks (no premature abstractions)
REMOVED: System Prompt: Doing tasks (no time estimates)
REMOVED: System Prompt: Doing tasks (no unnecessary additions)
REMOVED: System Prompt: Doing tasks (read before modifying)
REMOVED: System Prompt: Tool usage (create files)
REMOVED: System Prompt: Tool usage (delegate exploration)
REMOVED: System Prompt: Tool usage (direct search)
REMOVED: System Prompt: Tool usage (edit files)
REMOVED: System Prompt: Tool usage (read files)
REMOVED: System Prompt: Tool usage (reserve Bash)
REMOVED: System Prompt: Tool usage (search content)
REMOVED: System Prompt: Tool usage (search files)
REMOVED: System Prompt: Tool usage (skill invocation)
```

### Bash cd+git Guidance (CC 2.1.113)
```
Tool Description: Bash (maintain cwd) - Added explicit instruction to never prepend
`cd <current-directory>` to a `git` command, since `git` already operates on the
current working tree and the compound form triggers a permission prompt.
```

### Agent "Trust but Verify" (CC 2.1.105)
```
Tool Description: Agent (usage notes) - Added "trust but verify" guidance instructing
Claude to check actual code changes from agents before reporting work as done, rather
than relying solely on agent summaries.
```

### Monitor "Silence is Not Success" (CC 2.1.105)
```
Tool Description: Background monitor (streaming events) - Added "silence is not success"
guidance requiring monitors to match all terminal states (failures, crashes, OOM) not
just the happy path; added examples of wrong vs right grep patterns for comprehensive
coverage; updated output volume guidance to emphasize capturing both success and failure
signals; added note about merging stderr with `2>&1` for directly-run commands.
```

### Memory Synthesis Retrieval-Only (CC 2.1.111)
```
Agent Prompt: Memory synthesis - Strengthened the "do not invent facts" rule into a
full retrieval-only directive: the subagent must not answer or solve queries from
general knowledge, and must return empty results when no memory covers the query.
```

---

## Stage 2: Verification Results
### Verified: 2026-04-19

#### Must Update Verification

**Confirmed (in version range 2.1.111-2.1.114):**
- [x] **Skill tool invocation rules tightened** (CC 2.1.111) -- confirmed in system-prompts changelog, gap exists in skill-development docs (no mention of strict available-skills guardrail)
- [x] **NEW skill: /less-permission-prompts -> /fewer-permission-prompts** (CC 2.1.111, 2.1.113) -- confirmed in both CC changelog and system-prompts changelog, not documented in plugin-dev (new built-in skill pattern)
- [x] **Memory synthesis agent: retrieval-only directive** (CC 2.1.111) -- confirmed in system-prompts changelog, affects agent prompt design patterns
- [x] **Massive system prompt removals** (CC 2.1.111) -- confirmed in system-prompts changelog, 14 prompts removed. Impact on plugin-dev is LOW since these were Claude's default behaviors not plugin-specific guidance
- [x] **Bash tool: cd git command permission prompt avoidance** (CC 2.1.113) -- confirmed in system-prompts changelog, useful guidance for Bash tool examples

**Rejected (out of version range - CC 2.1.105 predates last audit at 2.1.110):**
- [x] **Agent tool: "trust but verify" guidance** (CC 2.1.105) -- REJECTED: Version 2.1.105 predates last audit baseline (2.1.110). Should have been caught in prior audit cycle. Not including.
- [x] **Monitor tool: comprehensive failure matching guidance** (CC 2.1.105) -- REJECTED: Version 2.1.105 predates audit baseline. Additionally, "silence is NOT success" IS ALREADY DOCUMENTED at `/home/runner/work/plugin-dev/plugin-dev/plugins/plugin-dev/skills/plugin-dev/references/plugin-structure/references/manifest-reference.md` line 414.
- [x] **NEW: /runtime-verification alias for Verify skill** (CC 2.1.105) -- REJECTED: Version 2.1.105 predates audit baseline.
- [x] **EnterWorktree tool: expanded trigger conditions** (CC 2.1.105) -- REJECTED: Version 2.1.105 predates audit baseline.

#### Missed Items (promoted from No Action)
- None identified. The No Action classifications appear correct.

#### May Update Resolution
- = **Opus 4.7 with xhigh effort level** (CC 2.1.111) -- kept as May Update: not directly plugin-related, model choice is user decision
- = **Auto mode no longer requires --enable-auto-mode** (CC 2.1.111) -- kept as May Update: affects CLI usage, not plugin authoring
- = **NEW: /ultrareview for cloud-based code review** (CC 2.1.111) -- kept as May Update: could reference as complex skill example but not required
- = **sandbox.network.deniedDomains setting** (CC 2.1.113) -- kept as May Update: settings reference could mention this
- = **Windows PowerShell tool rollout** (CC 2.1.111) -- kept as May Update: platform-specific, low priority
- [x] **NEW: PushNotification tool** (CC 2.1.110) -- demoted to No Action: version 2.1.110 is the last audit baseline, not new
- [x] **REPL tool and scripting conventions** (CC 2.1.108, 2.1.110) -- demoted to No Action: version range predates or equals audit baseline
- = **/skills menu: sorting by token count** (CC 2.1.111) -- kept as May Update: useful for skill size awareness guidance
- [x] **Loop/snooze/dynamic pacing features** (CC 2.1.101, 2.1.105) -- demoted to No Action: versions predate audit baseline
- [x] **Managed Agents documentation additions** (CC 2.1.97, 2.1.105) -- demoted to No Action: versions predate audit baseline
- [x] **Communication style prompt simplified** (CC 2.1.100, 2.1.104) -- demoted to No Action: versions predate audit baseline
- [x] **Fork usage: removed "don't peek" exception** (CC 2.1.101) -- demoted to No Action: version predates audit baseline
- [x] **Thinking frequency tuning system reminder** (CC 2.1.107) -- demoted to No Action: version predates audit baseline

#### Summary
- **Must Update**: 5 items confirmed (4 rejected as out-of-range)
- **May Update**: 5 items remaining (8 demoted to No Action due to version range)
- **Confidence**: HIGH - independent verification confirms CC changelog and system-prompts changelog data

#### Critical Finding: Version Range Error
Stage 1 included items from CC 2.1.105 in a manifest claiming range 2.1.111-2.1.114. The last audit was at CC 2.1.110 (per `/home/runner/work/plugin-dev/plugin-dev/docs/claude-code-compatibility.md`). Items from versions 2.1.97-2.1.110 should NOT appear as new items in this manifest.

**Root cause**: Stage 1 read the full system-prompts changelog but did not properly filter by the audit baseline version. Items earlier than 2.1.111 were incorrectly included.

**Recommendation**: Future Stage 1 runs should explicitly verify each item's version against the last-audited version from `docs/claude-code-compatibility.md` before including it.
