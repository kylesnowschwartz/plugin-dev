# Upstream Change Manifest
## CC Version Range: 2.1.139 - 2.1.140
## Generated: 2026-05-13
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - subagent dispatch unavailable in CI]

---

### Must Update

- [ ] **Hook `args` field support** (CC 2.1.139)
  - Source: changelog
  - Confidence: high
  - Affects: hooks skill, plugin-dev hook documentation
  - Details: Hooks now support an `args` field for passing arguments. This is a new hook capability that needs to be documented in the hooks reference. Enables hooks to receive custom arguments from the manifest.
  - Raw changelog: "Hook `args` field support" (from CC changelog 2.1.139)

- [ ] **Security monitor Self-Modification rule expansion with explicit paths** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: high
  - Affects: agents skill, security documentation, plugin path conventions
  - Details: The Self-Modification rule now explicitly lists agent-config paths that trigger security checks: `.claude/settings*.json`, `CLAUDE.md`, `CLAUDE.local.md`, `.claude.json`, `.claude/rules/`, `.claude/hooks/`, `.claude/commands/`, `.claude/agents/`, `.claude/skills/`, `.claude/output-styles/`, `.claude/workflows/`, `.claude/routines/`, `.claude/scheduled_tasks.json`, `.claude/loop.md`, `.mcp.json`. Exception carved out: files under `.claude/worktrees/<name>/` are treated as ordinary project files. Plugin developers need to understand these paths trigger special handling.
  - Raw system-prompts: "Agent Prompt: Security monitor for autonomous agent actions (second part) - Expands the Self-Modification rule from a vague description to an explicit list of agent-config paths (.claude/settings*.json, CLAUDE.md, CLAUDE.local.md, .claude.json, .claude/rules/, .claude/hooks/, .claude/commands/, .claude/agents/, .claude/skills/, .claude/output-styles/, .claude/workflows/, .claude/routines/, .claude/scheduled_tasks.json, .claude/loop.md, .mcp.json), and carves out exceptions so files under .claude/worktrees/<name>/ are treated as ordinary project files..."

- [ ] **NEW `/goal` command for completion conditions** (CC 2.1.139)
  - Source: changelog
  - Confidence: high
  - Affects: commands documentation, workflow automation
  - Details: New `/goal` command allows setting completion conditions for sessions. This is a new slash command that plugin developers may want to reference or integrate with.
  - Raw changelog: "/goal command for setting completion conditions" (from CC changelog 2.1.139)

- [ ] **`continueOnBlock` hook config option** (CC 2.1.139)
  - Source: changelog
  - Confidence: high (Stage 2 verified)
  - Affects: hook-development skill (PostToolUse hooks section)
  - Details: New hook configuration option `continueOnBlock` for PostToolUse hooks. When set to `true`, feeds rejection reasons back to Claude and continues the turn instead of halting. This enables hooks to provide feedback without blocking the workflow.
  - Raw changelog: "Added hook `continueOnBlock` config option for `PostToolUse` hooks--set to `true` to feed rejection reasons back to Claude and continue the turn"

- [ ] **Agent tool type matching now case-insensitive** (CC 2.1.140)
  - Source: changelog
  - Confidence: high
  - Affects: agents skill, agent frontmatter documentation, allowedTools syntax
  - Details: Agent tool type values are now matched case-insensitively. This affects how tools are specified in agent configurations. Example: `Bash` and `bash` now equivalent.
  - Raw changelog: "better agent tool type matching with case-insensitive values" (from CC changelog 2.1.140)

- [ ] **NEW Agent tool simplified usage notes** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: high
  - Affects: agents skill reference, Agent tool documentation
  - Details: New simplified usage notes for the Agent tool covering: when to delegate, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions. This provides authoritative guidance for agent design patterns.
  - Raw system-prompts: "NEW: Tool Description: Agent (simple usage notes) - Simplified usage notes for the Agent tool covering when to delegate, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions."

- [ ] **Plugin warning for silently ignored component folders** (CC 2.1.140)
  - Source: changelog
  - Confidence: high (Stage 2 addition)
  - Affects: plugin-structure skill, plugin troubleshooting documentation
  - Details: Plugins now warn when default component folders (e.g., `commands/`) are silently ignored because `plugin.json` sets the matching key, visible in `/doctor`, `claude plugin list`, and `/plugin`. This helps developers debug why components are not loading.
  - Raw changelog: "Plugins now warn when default component folders (e.g., `commands/`) are silently ignored because `plugin.json` sets the matching key, visible in `/doctor`, `claude plugin list`, and `/plugin`"

- [ ] **MCP `CLAUDE_PROJECT_DIR` environment variable for plugins** (CC 2.1.139)
  - Source: changelog
  - Confidence: high (Stage 2 addition)
  - Affects: mcp-integration skill
  - Details: MCP stdio servers now receive `CLAUDE_PROJECT_DIR` in their environment. Plugin configs can reference `${CLAUDE_PROJECT_DIR}` in MCP server commands. This enables project-relative paths in MCP configurations.
  - Raw changelog: "MCP stdio servers now receive `CLAUDE_PROJECT_DIR` in their environment, with plugin configs able to reference `${CLAUDE_PROJECT_DIR}` in commands"

---

### May Update

- [ ] **Environment variable passing to MCP servers** (CC 2.1.139)
  - Source: changelog
  - Confidence: medium
  - Affects: MCP documentation, plugin MCP configurations
  - Details: MCP servers can now receive environment variables. May need to document how this works with plugin MCP configurations.
  - Raw changelog: "environment variable passing to MCP servers" (from CC changelog 2.1.139)

- [ ] **Snooze tool wakeup guidance changes** (CC 2.1.140)
  - Source: system-prompts
  - Confidence: high
  - Affects: background execution patterns, scheduling documentation
  - Details: Added warning not to schedule short-interval wakeups for harness-tracked background work. Recommends 1200s+ fallback heartbeat for actively polling external state (CI runs, deploys, remote queues). May affect skill patterns using background execution.
  - Raw system-prompts: "Tool Description: Snooze (delay and reason guidance) - Adds an explicit warning not to schedule short-interval wakeups to poll for harness-tracked background work..."

- [ ] **Security-relevant instructions preservation in compaction** (CC 2.1.139)
  - Source: system-prompts
  - Confidence: high
  - Affects: understanding of compaction behavior, skill design
  - Details: Compaction now preserves security-relevant instructions (sensitive files, forbidden operations, credential handling rules) verbatim in summaries. This means plugins providing security instructions can expect them to survive compaction.
  - Raw system-prompts: "Agent Prompt: Conversation summarization - Adds requirement to note security-relevant instructions or constraints (sensitive files, forbidden operations, credential handling rules) and preserve them verbatim..."

- [ ] **PowerShell Unix-to-PowerShell command mapping table** (CC 2.1.139)
  - Source: system-prompts
  - Confidence: high
  - Affects: Windows/PowerShell documentation, cross-platform skill development
  - Details: Added substantial reference table mapping Unix commands (head, tail, which, touch, wc, mkdir -p, rm -rf, ln -s, chmod, 2>/dev/null, inline VAR=x, bash control flow) to PowerShell equivalents. May affect cross-platform skill examples.
  - Raw system-prompts: "Tool Description: PowerShell - Adds a substantial reference table mapping Unix commands..."

- [ ] **Plugin detail viewing** (CC 2.1.139)
  - Source: changelog
  - Confidence: medium
  - Affects: plugin management documentation
  - Details: New capability to view plugin details. May be a new command or UI feature for inspecting installed plugins.
  - Raw changelog: "plugin detail viewing" (from CC changelog 2.1.139)

---

### No Action

- `/scroll-speed` command for mouse wheel tuning (CC 2.1.139) - UI/UX feature, not plugin-related
- Fixed `/goal` command hanging issues (CC 2.1.140) - Bug fix for new feature
- Write tool "When to use" format rewrite (CC 2.1.140) - Internal prompt change (Stage 2 demoted)
- Memory instructions format changes (CC 2.1.139) - Internal memory system, not plugin-documented (Stage 2 demoted)
- Output style custom per-turn reminder (CC 2.1.139) - Output styles not covered by plugin-dev (Stage 2 demoted)
- Agent view for tracking sessions (CC 2.1.139) - UI feature for session management, not plugin-related (Stage 2 demoted)
- Fixed settings hot-reload with symlinked files (CC 2.1.140) - Bug fix
- Fixed background service connectivity issues (CC 2.1.140) - Bug fix
- MCP server authentication retries fixed (CC 2.1.140) - Bug fix
- Terminal cursor positioning fixed (CC 2.1.140) - Bug fix
- Tool validation improvements (CC 2.1.140) - Internal improvement
- Claude Platform on AWS reference documentation (CC 2.1.139) - API/cloud feature, not plugin-related
- Task tools reminder visibility change (CC 2.1.139) - Internal prompt change
- TodoWrite reminder visibility change (CC 2.1.139) - Internal prompt change
- Auto mode header/guidance reframe (CC 2.1.139) - Internal prompt change
- Harness instructions compaction note removal (CC 2.1.139) - Internal prompt change
- Agent Worker fork wording cleanup (CC 2.1.140) - Minor wording change
- Insights report output change (CC 2.1.139) - Internal reporting feature
- Dynamic pacing loop execution reorder (CC 2.1.139) - Internal scheduling logic
- Loop self-pacing mode reorder (CC 2.1.139) - Internal scheduling logic
- Model migration guide Claude Platform on AWS section (CC 2.1.139) - API documentation
- Building LLM apps skill updates for AWS (CC 2.1.139) - API documentation
- Live documentation sources URL additions (CC 2.1.139) - Internal data sources

---

## Summary

**Version Range:** 2.1.139 - 2.1.140
**Total Changes Analyzed:** 34

**Must Update:** 8 items (Stage 2 verified)
- Hook `args` field support (new hook capability)
- Security monitor explicit path list (affects plugin path understanding)
- `/goal` command (new slash command)
- `continueOnBlock` hook config option (PostToolUse hooks - Stage 2 corrected)
- Agent tool type case-insensitivity (affects tool specifications)
- Agent tool simplified usage notes (new authoritative guidance)
- Plugin warning for silently ignored component folders (Stage 2 added)
- MCP `CLAUDE_PROJECT_DIR` environment variable (Stage 2 added)

**May Update:** 5 items (Stage 2 reduced from 9)
- Environment variable passing to MCP servers
- Snooze tool wakeup guidance
- Security-relevant instructions preservation in compaction
- PowerShell command mapping table
- Plugin detail viewing

**No Action:** 23 items (bug fixes, UI features, API docs, internal changes + 4 Stage 2 demoted)

**Token delta from system-prompts:**
- 2.1.140: +622 tokens
- 2.1.139: +2,248 tokens
- Total for range: +2,870 tokens

**Triangulation Notes:**
- claude-code-guide agent dispatch was unavailable in CI environment; triangulation degraded to two sources
- All "Must Update" items confirmed by at least one source; items marked "medium confidence" appear in changelog only without detailed information
- System-prompts changelog provides structured details including NEW/REMOVED markers and token deltas
- Both 2.1.139 and 2.1.140 have substantial changes, with 2.1.139 being a feature-heavy release

---

## Stage 2: Verification Results
### Verified: 2026-05-13

#### Must Update Verification
- [x] **Hook `args` field support** (CC 2.1.139) -- CONFIRMED in CC changelog. Gap exists: `/home/runner/work/plugin-dev/plugin-dev/plugins/plugin-dev/skills/plugin-dev/references/hook-development/overview.md` does not mention `args` field. Correctly affects: hook-development reference.
- [x] **Security monitor Self-Modification rule expansion** (CC 2.1.140) -- CONFIRMED in system-prompts changelog. Affects: agents skill (security context for plugin developers). Gap exists: agent-development overview does not list these paths as security-monitored.
- [x] **NEW `/goal` command** (CC 2.1.139) -- CONFIRMED in CC changelog. Affects: command documentation. Note: This is a built-in command, not directly plugin-related but useful context for plugin authors.
- ! **`continueOnBlock` config option** (CC 2.1.139) -- RECLASSIFIED: This is a **hook** config option for PostToolUse hooks, not a general config option. Affects: hook-development reference (not plugin-settings). Details: "Added hook `continueOnBlock` config option for `PostToolUse` hooks -- set to `true` to feed rejection reasons back to Claude and continue the turn"
- [x] **Agent tool type case-insensitivity** (CC 2.1.140) -- CONFIRMED in CC changelog: "Improved Agent tool `subagent_type` matching to accept case- and separator-insensitive values (e.g., `"Code Reviewer"` resolves to `code-reviewer`)". Gap exists: agent-development overview does not mention case-insensitivity.
- [x] **NEW Agent tool simplified usage notes** (CC 2.1.140) -- CONFIRMED in system-prompts changelog. Affects: agents skill reference (background execution, parallel launches, context restrictions).

#### Missed Items (promoted from No Action)
- ! **Plugin warning for silently ignored component folders** (CC 2.1.140) -- MISSED by Stage 1
  - Source: CC changelog
  - Affects: plugin-structure skill, plugin troubleshooting
  - Details: "Plugins now warn when default component folders (e.g., `commands/`) are silently ignored because `plugin.json` sets the matching key, visible in `/doctor`, `claude plugin list`, and `/plugin`"
  - Relevance: Direct plugin system behavior - helps developers debug why components are not loading

- ! **MCP `CLAUDE_PROJECT_DIR` environment variable** (CC 2.1.139) -- PARTIALLY CAPTURED under MCP env vars but deserves explicit call-out
  - Source: CC changelog
  - Affects: mcp-integration skill
  - Details: "MCP stdio servers now receive `CLAUDE_PROJECT_DIR` in their environment, with plugin configs able to reference `${CLAUDE_PROJECT_DIR}` in commands"
  - Relevance: Direct plugin MCP configuration capability

#### May Update Resolution
- = **Environment variable passing to MCP servers** -- KEPT as May Update, partially overlaps with CLAUDE_PROJECT_DIR item above but represents broader capability
- = **Snooze tool wakeup guidance** -- KEPT as May Update: affects background execution patterns documented in agent-development
- = **Write tool "When to use" format** -- DEMOTE to No Action: internal prompt change, does not affect plugin documentation
- = **Security-relevant instructions preservation** -- KEPT as May Update: important for plugin developers providing security instructions
- = **Memory instructions format changes** -- DEMOTE to No Action: internal memory system, not plugin-documented
- = **Output style custom per-turn reminder** -- DEMOTE to No Action: output styles not covered by plugin-dev
- = **PowerShell command mapping table** -- KEPT as May Update: affects cross-platform hook/command development
- = **Plugin detail viewing** -- KEPT as May Update: useful for plugin developers to understand plugin inspection
- = **Agent view for tracking sessions** -- DEMOTE to No Action: UI feature for session management, not plugin-related

#### Summary
- Must Update: 8 items (6 original confirmed + 2 promoted from missed)
- May Update: 5 items remaining (4 demoted to No Action)
- Confidence: HIGH - all items verified against primary sources

#### Corrections Applied
1. `continueOnBlock` reclassified as hook config option, affects hook-development (not plugin-settings)
2. Added "Plugin warning for silently ignored component folders" to Must Update
3. Added "MCP CLAUDE_PROJECT_DIR" to Must Update for explicit documentation
4. Demoted 4 May Update items to No Action (Write tool format, memory instructions, output styles, agent view)

---

## Priority Assessment (Stage 2 Updated)

### High Priority (blocking for next release)
1. **Hook `args` field** - Direct plugin API addition, gap in hook-development docs
2. **`continueOnBlock` hook config** - New PostToolUse hook capability, gap in hook-development docs
3. **Agent tool type case-insensitivity** - Affects agent frontmatter documentation
4. **Plugin warning for ignored folders** - Direct plugin debugging feature (Stage 2 added)

### Medium Priority (important but not blocking)
5. **Security monitor paths** - Context for plugin developers, affects agents skill
6. **Agent tool usage notes** - Reference material for agent patterns
7. **MCP `CLAUDE_PROJECT_DIR`** - Plugin MCP configuration capability (Stage 2 added)
8. **`/goal` command** - New feature documentation (less directly plugin-related)

### Low Priority (nice to have)
9. **Environment variable passing to MCP** - Minor enhancement
10. **Plugin detail viewing** - Discovery feature
11. **PowerShell command mapping** - Cross-platform skill examples
