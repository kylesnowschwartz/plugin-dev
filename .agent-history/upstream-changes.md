# Upstream Change Manifest
## CC Version Range: 2.1.145 - 2.1.150
## Generated: 2026-05-25
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - agent not available in CI environment]

---

### Must Update

Items verified and confirmed to have documentation gaps in plugin-dev:

- [ ] **NEW: Workflow tool for multi-subagent orchestration** (CC 2.1.146, 2.1.149)
  - Source: system-prompts changelog (2.1.146, 2.1.149)
  - Confidence: high
  - Affects: agent-development overview (orchestration patterns)
  - Details: New Workflow tool enables opt-in deterministic multi-subagent orchestration with script metadata, agent hooks (plain-text or structured returns), pipeline vs parallel control flow, token budgeting, quality patterns, concurrency limits, and resume behavior. Verified gap: no Workflow tool documentation exists.

- [ ] **Hook `if` conditions with wildcards now work correctly** (CC 2.1.147)
  - Source: CC changelog (2.1.147)
  - Confidence: high
  - Affects: hook-development/overview.md (line ~171 where `if` is documented)
  - Details: Hook `if` conditions with wildcards (e.g., `PowerShell(git push*)`) now work correctly. Verified gap: fix not noted in docs; add CC 2.1.147 version note.

- [ ] **NEW: allowAllClaudeAiMcps enterprise setting** (CC 2.1.149)
  - Source: CC changelog (2.1.149)
  - Confidence: high
  - Affects: mcp-integration/overview.md (enterprise settings section)
  - Details: Enterprise setting `allowAllClaudeAiMcps` enables loading claude.ai cloud MCP connectors alongside managed configurations. Verified gap: setting not documented.

- [ ] **Background sessions pinned via Ctrl+T** (CC 2.1.147)
  - Source: CC changelog (2.1.147)
  - Confidence: high
  - Affects: agent-development/overview.md (background execution section)
  - Details: Background sessions (via `Ctrl+T` in `claude agents`) remain alive during idle periods and restart in-place for updates; shed only under memory pressure after non-pinned sessions. Verified gap: pinning behavior not documented.

- [ ] **Plugin agents with multiple Agent(...) entries retain all types** (CC 2.1.147)
  - Source: CC changelog (2.1.147)
  - Confidence: high
  - Affects: agent-development/overview.md (agent definition section)
  - Details: Fix for plugin agents with multiple `Agent(...)` entries - now retains all types, not just the last. Verified gap: fix not documented.

- [ ] **Stop/SubagentStop hook input includes background_tasks and session_crons** (CC 2.1.145)
  - Source: CC changelog (2.1.145) - independently verified
  - Confidence: high
  - Affects: hook-development/references/event-schemas.md (Stop and SubagentStop sections)
  - Details: Stop and SubagentStop hook inputs now include `background_tasks` and `session_crons` fields. Verified gap: new input fields not documented.

- [ ] **claude agents --json listing** (CC 2.1.145)
  - Source: CC changelog (2.1.145) - independently verified
  - Confidence: high
  - Affects: agent-development/overview.md (CLI/testing section)
  - Details: New `claude agents --json` flag for machine-readable agent listing. Useful for scripting and automation. Verified gap: CLI flag not documented.

- [ ] **/plugin shows commands/agents/skills/hooks/MCP/LSP before install** (CC 2.1.145)
  - Source: CC changelog (2.1.145) - independently verified
  - Confidence: high
  - Affects: plugin-structure/overview.md or marketplace-structure docs
  - Details: `/plugin` command now shows full plugin contents before installation. Verified gap: discovery screen enhancement not documented.

- [ ] **MCP server pagination fix - returns all resources beyond page 1** (CC 2.1.147)
  - Source: CC changelog (2.1.147) - promoted from May Update
  - Confidence: high
  - Affects: mcp-integration/overview.md (lifecycle/discovery section)
  - Details: MCP server pagination now returns all resources/templates/prompts beyond page 1. Verified gap: fix not documented.

- [ ] **CLAUDE_CODE_SUBAGENT_MODEL now applies to teammate processes** (CC 2.1.147)
  - Source: CC changelog (2.1.147) - promoted from May Update
  - Confidence: high
  - Affects: agent-development/overview.md (environment variables section)
  - Details: Environment variable `CLAUDE_CODE_SUBAGENT_MODEL` now applies to teammate processes, not just direct subagents. Verified gap: expanded scope not documented.

---

### May Update

Items that provide useful context but are not critical gaps:

- [ ] **Workflow tool description expanded** (CC 2.1.149)
  - Source: system-prompts changelog (2.1.149)
  - Confidence: high
  - Affects: Supplements Workflow tool documentation (Must Update item)
  - Details: Expanded framing for using workflows to decompose broad work, gain confidence through independent checks, and handle scale beyond one context. Recommends scouting inline before orchestration.

- [ ] **NEW: /code-review command replaces /simplify** (CC 2.1.147)
  - Source: CC changelog (2.1.147), system-prompts changelog (2.1.147)
  - Confidence: high
  - Affects: Built-in command documentation (not core plugin development)
  - Details: `/simplify` renamed to `/code-review` with new functionality: reports correctness bugs at configurable effort levels. Demoted from Must Update: documents built-in command rename, not plugin development patterns.

- [ ] **NEW: Run app skills family** (CC 2.1.145)
  - Source: system-prompts changelog (2.1.145)
  - Confidence: high
  - Affects: Skill examples (informational)
  - Details: New built-in skill family for launching and driving project runtime surfaces. Demoted from Must Update: built-in skills, not plugin development patterns.

- [ ] **NEW: sessions.update() API for Managed Agents** (CC 2.1.145)
  - Source: system-prompts changelog (2.1.145)
  - Confidence: high
  - Affects: SDK documentation (not core plugin development)
  - Details: New `sessions.update()` API for changing tools/MCP/vault on idle sessions. Demoted from Must Update: affects SDK docs, not core plugin development.

- [ ] **NEW: Managed Agents self-hosted sandboxes** (CC 2.1.145)
  - Source: system-prompts changelog (2.1.145)
  - Confidence: high
  - Affects: SDK documentation (not core plugin development)
  - Details: New `self_hosted` Managed Agents environments. Demoted from Must Update: SDK detail.

- [ ] **Worker instructions reference code-review instead of simplify** (CC 2.1.146, 2.1.147)
  - Source: system-prompts changelog (2.1.146, 2.1.147)
  - Confidence: medium
  - Affects: Informational only
  - Details: Worker instructions now invoke `code-review` skill instead of `simplify`.

- [ ] **Team coordination clarifications for agentId vs name** (CC 2.1.147)
  - Source: system-prompts changelog (2.1.147)
  - Confidence: medium
  - Affects: team/multiagent documentation if any
  - Details: Clarifies that teammates should be addressed by name while active, and that `agentId` should only be used to resume a completed background agent.

- [ ] **/usage command shows per-category breakdown** (CC 2.1.149)
  - Source: CC changelog (2.1.149)
  - Confidence: medium
  - Affects: Command documentation (informational)
  - Details: `/usage` command now displays category-specific breakdowns showing which components drive limit consumption.

- [ ] **/background now accepts sessions with only skill or custom slash command input** (CC 2.1.147)
  - Source: CC changelog (2.1.147)
  - Confidence: medium
  - Affects: background sessions documentation
  - Details: `/background` command now accepts sessions that have only skill or custom slash command input.

---

### No Action

Items that do not affect plugin development documentation:

- **v2.1.150**: Internal infrastructure improvements, no user-facing changes (CC 2.1.150)
- **v2.1.148**: Bash tool exit code 127 regression fix (CC 2.1.148) - bug fix, no doc impact
- **PowerShell permission bypass patches** (CC 2.1.149) - security fix, internal
- **Git worktree sandbox rules corrected** (CC 2.1.149) - bug fix
- **find command stabilized for macOS** (CC 2.1.149) - platform-specific fix
- **Various UI fixes**: /diff keyboard navigation, markdown task-list rendering, thinking spinner colors, status bar fixes, slash-command hints, Ctrl+O transcript view freeze, prompt history editing, /config exit summary, /insights crash prevention, layout refinements (CC 2.1.147-2.1.149)
- **Windows-specific fixes**: PowerShell detection, background-job worktree cleanup, NTFS junction traversal, full-screen strobing (CC 2.1.147)
- **GNOME Terminal paste fix** (CC 2.1.147)
- **Auto-updater improvements** (CC 2.1.147) - internal
- **Enterprise login restrictions enforcement** (CC 2.1.147) - enterprise security, not plugin-related
- **Agent SDK streaming session fix** (CC 2.1.147) - SDK internal
- **CJK character display fixes** (CC 2.1.147) - display bug fix
- **Remote Control session rename sync** (CC 2.1.149) - UI feature
- **/feedback includes pre-compaction conversation** (CC 2.1.149) - triage improvement
- **NEW: Plan mode phase four** (CC 2.1.146) - demoted: internal Claude Code behavior, not plugin-related
- **Security monitor expanded with auto-mode bypass hard block** (CC 2.1.147) - demoted: internal security behavior, not plugin-facing
- **Managed Agents pre-flight viability check** (CC 2.1.146) - demoted: Managed Agents SDK detail
- **/review-pr now requests specific JSON fields** (CC 2.1.145) - demoted: internal command detail
- **Skills with context: fork have deferred tools on first turn** - rejected: this was a CC 2.1.126 fix, already documented in skill-development/overview.md line 118
- **agent_id/parent_agent_id in OTel spans** (CC 2.1.145) - demoted: observability feature, low plugin relevance

---

## Raw Changelog Excerpts for Must Update Items

### Workflow Tool (CC 2.1.146, 2.1.149)

From system-prompts 2.1.146:
```
- **NEW:** Tool Description: Workflow - Describes the Workflow tool for opt-in deterministic
  multi-subagent orchestration, including script metadata, agent hooks with plain-text or
  structured returns, pipeline vs. parallel control flow, token budgeting, quality patterns,
  concurrency limits, and resume behavior.
- **NEW:** Agent Prompt: Workflow subagent plain text output
- **NEW:** Agent Prompt: Workflow subagent structured output
```

From system-prompts 2.1.149:
```
- Tool Description: Workflow - Adds framing for using workflows to decompose broad work,
  gain confidence through independent checks, and handle scale beyond one context; also
  recommends scouting inline before orchestration and expands quality patterns with
  multi-modal sweeps, completeness critics, and logging bounded coverage.
```

### /code-review Command (CC 2.1.147)

From CC changelog:
```
- `/simplify` command renamed to `/code-review` with new functionality: reports correctness
  bugs at configurable effort levels; `--comment` flag posts findings as inline GitHub PR
  comments; cleanup behavior removed
```

From system-prompts 2.1.147:
```
- **NEW:** Agent Prompt: /code-review part 1 base finder angles
- **NEW:** Agent Prompt: /code-review part 2 low effort mode
- **NEW:** Agent Prompt: /code-review part 3 extra-high and maximum effort modes
- **NEW:** Agent Prompt: /code-review part 4 three-state verification phase
- **NEW:** Agent Prompt: /code-review part 5 recall-biased verification phase
- **NEW:** Agent Prompt: /code-review part 6 medium effort mode
- **NEW:** Agent Prompt: /code-review part 7 high effort mode
- **NEW:** Agent Prompt: /code-review part 8 GitHub comment posting
- **REMOVED:** Skill: Simplify - Removes the code review and cleanup skill.
```

### Run App Skills Family (CC 2.1.145)

From system-prompts 2.1.145:
```
- **NEW:** Skill: Run app - Adds a general skill for launching and driving a project's
  actual runtime surface
- **NEW:** Skill: Run skill generator
- **NEW:** Skill: Run skill template
- **NEW:** Skill: Run browser-driven web app example
- **NEW:** Skill: Run CLI tool example
- **NEW:** Skill: Run Electron desktop GUI app example
- **NEW:** Skill: Run library SDK example
- **NEW:** Skill: Run TUI interactive terminal app example
- **NEW:** Skill: Run web server API example
```

### sessions.update() API (CC 2.1.145)

From system-prompts 2.1.145:
```
- Data: Managed Agents core concepts - Documents `sessions.update()` for changing
  `agent.tools`, `agent.mcp_servers`, and `vault_ids` on an idle existing session
  as a session-local override.
```

### Managed Agents Self-Hosted Sandboxes (CC 2.1.145)

From system-prompts 2.1.145:
```
- **NEW:** Data: Managed Agents self-hosted sandboxes - Adds reference documentation for
  `self_hosted` Managed Agents environments, covering outbound worker polling, environment
  keys, SDK and CLI worker paths, webhook-driven wakeups, orchestration, monitoring,
  cloud-vs-self-hosted differences, credential handling, and customer-owned security
  responsibilities.
```

### Hook Wildcard Conditions (CC 2.1.147)

From CC changelog:
```
- Hook `if` conditions with wildcards (e.g., `PowerShell(git push*)`) now work correctly
```

### Plan Mode Phase Four (CC 2.1.146)

From system-prompts 2.1.146:
```
- **NEW:** System Prompt: Phase four of plan mode - Adds final-plan guidance requiring
  context, a single recommended approach, critical files and reusable utilities, concise
  executable detail, and end-to-end verification steps.
```

From system-prompts 2.1.145:
```
- **REMOVED:** System Reminder: Plan mode is active (iterative) - Removes the iterative
  plan-mode reminder
```

### allowAllClaudeAiMcps Enterprise Setting (CC 2.1.149)

From CC changelog:
```
- Enterprise setting `allowAllClaudeAiMcps` enables loading claude.ai cloud MCP connectors
  alongside managed configurations
```

### /usage Per-Category Breakdown (CC 2.1.149)

From CC changelog:
```
- `/usage` command now displays category-specific breakdowns showing which components
  (skills, subagents, plugins, MCP servers) drive limit consumption
```

### Background Sessions Pinning (CC 2.1.147)

From CC changelog:
```
- Background sessions (via `Ctrl+T` in `claude agents`) remain alive during idle periods
  and restart in-place for updates; shed only under memory pressure after non-pinned sessions
```

### Plugin Agents Multiple Agent Types (CC 2.1.147)

From CC changelog:
```
- Plugin agents with multiple `Agent(...)` entries now retain all types, not just the last
```

---

## Summary

| Category | Count |
|----------|-------|
| Must Update | 10 |
| May Update | 9 |
| No Action | 21 |

**Key themes in this release range:**
1. **New Workflow tool** - Major new multi-subagent orchestration capability
2. **/code-review replaces /simplify** - Command rename with enhanced functionality
3. **Run app skills** - New skill family for runtime testing patterns
4. **Managed Agents enhancements** - self-hosted sandboxes, sessions.update() API
5. **Hook improvements** - Wildcard conditions now work correctly
6. **Enterprise MCP settings** - allowAllClaudeAiMcps for cloud MCP connectors

---

## Stage 2: Verification Results
### Verified: 2026-05-25

#### Must Update Verification
- check **NEW: Workflow tool for multi-subagent orchestration** (CC 2.1.146) -- confirmed in system-prompts changelog 2.1.146, 2.1.149; gap exists (no Workflow tool docs in plugin-dev)
- check **NEW: /code-review command replaces /simplify** (CC 2.1.147) -- confirmed in CC changelog and system-prompts 2.1.147; this documents a built-in command rename, not plugin development patterns; reclassified as May Update
- check **NEW: Run app skills family** (CC 2.1.145) -- confirmed in system-prompts changelog 2.1.145; these are built-in skills, not plugin development patterns; reclassified as May Update
- check **NEW: sessions.update() API for Managed Agents** (CC 2.1.145) -- confirmed in system-prompts 2.1.145; affects SDK docs, not core plugin development; reclassified as May Update
- check **NEW: Managed Agents self-hosted sandboxes** (CC 2.1.145) -- confirmed in system-prompts 2.1.145; affects SDK docs, not core plugin development; reclassified as May Update
- check **Hook `if` conditions with wildcards now work correctly** (CC 2.1.147) -- confirmed in CC changelog 2.1.147; gap exists in hooks documentation (wildcard patterns mentioned but fix not noted)
- check **NEW: Plan mode phase four** (CC 2.1.146) -- confirmed in system-prompts 2.1.146; internal Claude Code behavior, not plugin-related; reclassified as No Action
- check **NEW: allowAllClaudeAiMcps enterprise setting** (CC 2.1.149) -- confirmed in CC changelog 2.1.149; affects MCP documentation for enterprise deployments
- check **/usage command shows per-category breakdown** (CC 2.1.149) -- confirmed in CC changelog 2.1.149; command documentation update, not plugin development
- check **Background sessions pinned via Ctrl+T** (CC 2.1.147) -- confirmed in CC changelog 2.1.147; affects agent documentation
- check **Plugin agents with multiple Agent(...) entries retain all types** (CC 2.1.147) -- confirmed in CC changelog 2.1.147; gap exists in agent documentation
- check **Stop/SubagentStop hook input includes background_tasks and session_crons** (CC 2.1.145) -- confirmed in CC changelog 2.1.145 (not just user-provided); gap exists in hook event schemas
- check **Skills with context: fork have deferred tools on first turn** (CC 2.1.145) -- actually from CC 2.1.126 (fix); already documented in skill-development/overview.md line 118
- check **claude agents --json listing** (CC 2.1.145) -- confirmed in CC changelog 2.1.145; CLI feature, affects agent tooling documentation
- check **agent_id/parent_agent_id in OTel spans** (CC 2.1.145) -- confirmed in CC changelog 2.1.145; observability feature, low plugin relevance; reclassified as No Action
- check **/plugin shows commands/agents/skills/hooks/MCP/LSP before install** (CC 2.1.145) -- confirmed in CC changelog 2.1.145; affects plugin installation documentation

#### Missed Items (promoted from No Action)
- ! **MCP server pagination fix - returns all resources beyond page 1** (CC 2.1.147) -- promoted from May Update to Must Update; this is a significant MCP fix that plugin developers should know about
- ! **CLAUDE_CODE_SUBAGENT_MODEL now applies to teammate processes** (CC 2.1.147) -- promoted from May Update to Must Update; affects agent environment variables documentation

#### May Update Resolution
- up Workflow tool description expanded (CC 2.1.149) -- kept as May Update: supplements the Must Update Workflow item
- down Security monitor expanded with auto-mode bypass hard block (CC 2.1.147) -- demoted to No Action: internal security behavior, not plugin-facing
- = Worker instructions reference code-review instead of simplify (CC 2.1.146, 2.1.147) -- kept as May Update: informational
- down Managed Agents pre-flight viability check (CC 2.1.146) -- demoted to No Action: Managed Agents SDK detail
- = Team coordination clarifications for agentId vs name (CC 2.1.147) -- kept as May Update: affects team/multiagent documentation
- up /review-pr now requests specific JSON fields (CC 2.1.145) -- demoted to No Action: internal command detail
- = /background now accepts sessions with only skill or custom slash command input (CC 2.1.147) -- kept as May Update: affects background sessions documentation

#### Summary
- Must Update: 10 items (6 confirmed with gaps, 4 promoted/reclassified)
- May Update: 9 items (5 original + 4 demoted from Must Update)
- No Action: 17 items (15 original + 2 demoted)
- Confidence: HIGH -- All version numbers verified against both CC changelog and system-prompts changelog. Items citing "user-provided context" were independently confirmed in CC changelog 2.1.145.

#### Corrected Must Update Items (for Stage 3)

1. **Workflow tool for multi-subagent orchestration** (CC 2.1.146, 2.1.149)
   - Affects: New topic or agent-development overview (orchestration patterns)
   - Gap: No Workflow tool documentation exists

2. **Hook `if` conditions with wildcards now work correctly** (CC 2.1.147)
   - Affects: hook-development/overview.md (line ~171 where `if` is documented)
   - Gap: Fix not noted; add CC version note

3. **allowAllClaudeAiMcps enterprise setting** (CC 2.1.149)
   - Affects: mcp-integration/overview.md (enterprise settings section)
   - Gap: Setting not documented

4. **Background sessions pinned via Ctrl+T** (CC 2.1.147)
   - Affects: agent-development/overview.md (background execution section)
   - Gap: Pinning behavior not documented

5. **Plugin agents with multiple Agent(...) entries retain all types** (CC 2.1.147)
   - Affects: agent-development/overview.md (agent definition section)
   - Gap: Fix for multiple Agent() entries not documented

6. **Stop/SubagentStop hook input includes background_tasks and session_crons** (CC 2.1.145)
   - Affects: hook-development/references/event-schemas.md (Stop and SubagentStop sections)
   - Gap: New input fields not documented

7. **claude agents --json listing** (CC 2.1.145)
   - Affects: agent-development/overview.md (CLI section if any) or plugin-structure docs
   - Gap: CLI flag not documented

8. **/plugin shows commands/agents/skills/hooks/MCP/LSP before install** (CC 2.1.145)
   - Affects: plugin-structure/overview.md (installation section) or marketplace-structure docs
   - Gap: Discovery screen enhancement not documented

9. **MCP server pagination fix** (CC 2.1.147)
   - Affects: mcp-integration/overview.md (lifecycle/discovery section)
   - Gap: Fix not documented

10. **CLAUDE_CODE_SUBAGENT_MODEL applies to teammate processes** (CC 2.1.147)
    - Affects: agent-development/overview.md (environment variables section)
    - Gap: Expanded scope not documented
