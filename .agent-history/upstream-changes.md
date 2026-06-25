# Upstream Change Manifest
## CC Version Range: 2.1.184 - 2.1.191
## Generated: 2026-06-25
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent type not available in this environment]

---

### Must Update (Verified)

- [ ] **`/rewind` command added** (CC 2.1.191)
  - Source: CC changelog (confirmed)
  - Confidence: high
  - Affects: command-development
  - Details: New `/rewind` command for resuming conversations before `/clear` was executed. Provides undo capability for cleared conversations.
  - Raw: "Added `/rewind` for resuming conversations before `/clear` was executed"

- [ ] **MCP ReadMcpResourceDirTool added** (CC 2.1.186)
  - Source: system-prompts CHANGELOG (confirmed)
  - Confidence: high
  - Affects: mcp-integration
  - Details: New MCP directory resource listing tool with required `server`/`uri` parameters, non-recursive direct-child listings, subdirectory descent via returned URIs, and server support requirements.
  - Raw: "NEW: Tool Description: ReadMcpResourceDirTool prompt - Adds the MCP directory resource listing tool prompt..."

- [ ] **Hooks comma-separated matchers fix** (CC 2.1.191)
  - Source: CC changelog (confirmed)
  - Confidence: high
  - Affects: hook-development
  - Details: Fixed hooks with comma-separated matchers silently not firing. This was a bug that affected plugin hook configurations.
  - Raw: "Fixed hooks with comma-separated matchers silently not firing"

- [ ] **`/permissions` denials persistence fix** (CC 2.1.191)
  - Source: CC changelog (confirmed)
  - Confidence: high
  - Affects: hook-development (PermissionRequest/PermissionDenied hooks)
  - Details: Fixed `/permissions` denials not persisting after closure. Affects permission management that plugin hooks can interact with.
  - Raw: "Fixed `/permissions` denials not persisting after closure"
  - Note: Promoted from May Update

- [ ] **MCP server retry logic improved** (CC 2.1.191)
  - Source: CC changelog (confirmed)
  - Confidence: high
  - Affects: mcp-integration
  - Details: Improved MCP server reliability with retry logic for transient errors. Also improved MCP OAuth with retry support for headless environments. Directly affects plugins that bundle MCP servers.
  - Raw: "Improved MCP server reliability with retry logic for transient errors"
  - Note: Promoted from May Update

---

### May Update (Verified)

- [ ] **`sandbox.credentials` setting added** (CC 2.1.187)
  - Source: CC changelog (confirmed)
  - Confidence: medium
  - Affects: plugin-settings (optional)
  - Details: New setting to block sandboxed commands from reading credential files. Low direct plugin relevance but may be useful background info.
  - Note: Demoted from Must Update

- [ ] **Agent proxy troubleshooting guide added** (CC 2.1.186)
  - Source: system-prompts CHANGELOG
  - Confidence: medium
  - Affects: troubleshooting documentation (optional)
  - Details: New troubleshooting guidance for Claude Code's policy-enforcing HTTPS agent proxy, covering CA-bundle trust setup, status checks, git/JVM/Docker fixes, unsupported traffic, and reporting policy denials.

- [ ] **`/plugin` unused plugin surfacing** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: medium
  - Affects: plugin commands documentation
  - Details: Improved `/plugin` surfacing unused plugins for cleanup.

- [ ] **`/install-github-app` workflow setup** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: medium
  - Affects: GitHub integration documentation
  - Details: Improved `/install-github-app` with optional GitHub Actions workflow setup.

- [ ] **`--json-schema` structured output fix** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: medium
  - Affects: CLI/headless documentation
  - Details: Fixed `--json-schema` structured output allowing indefinite `StructuredOutput` re-calls.

- [ ] **Subagent depth tracking fix** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: medium
  - Affects: agent-development
  - Details: Fixed subagent depth tracking for resumed and forked subagents.

- [ ] **Agent stop notifications improved** (CC 2.1.187)
  - Source: CC changelog
  - Confidence: medium
  - Affects: agent-development
  - Details: Fixed agent stop notifications and improved status messaging.

---

### No Action (Verified)

**Rejected from Must Update (not plugin-relevant):**
- Memory prompts and reminders removed (CC 2.1.191) -- internal memory system, not plugin API
- Context tip system added (CC 2.1.191) -- internal UX feature
- Artifact tool rework with artifact-design skill (CC 2.1.187) -- internal tool guidance
- Agent thread notes clarification (CC 2.1.187) -- internal agent behavior
- Verify plan reminder removed (CC 2.1.187) -- internal system prompt
- PR review flow replaced (CC 2.1.186) -- internal slash command implementation
- Security monitor edit-removal guidance (CC 2.1.186) -- internal security guidance
- Coordinator mode worker-approval pattern (CC 2.1.186) -- internal orchestration
- Security monitor scope narrowed (CC 2.1.186) -- internal classifier changes
- code_execution tool version updated (CC 2.1.186) -- API documentation, not plugin-dev
- Migrate to Claude Code skill removed (CC 2.1.185) -- built-in skill, not plugin-dev

**Demoted from May Update:**
- `/btw` arrow navigation (CC 2.1.187) -- UI feature, not plugin-relevant
- Background agents stopping fix (CC 2.1.191) -- bug fix, not documentation-worthy
- Background jobs stuck state fix (CC 2.1.187) -- bug fix, not documentation-worthy
- SendMessageTool protocol changes (CC 2.1.186) -- internal protocol, not plugin API
- Mouse click support in fullscreen mode (CC 2.1.187) -- UI feature, low plugin relevance

**Original No Action (confirmed):**
- Fixed scroll position jumping during streaming responses (CC 2.1.191)
- Improved `/voice` error messaging for organization-disabled cases (CC 2.1.191)
- Fixed `/login` URL truncation in Windows Terminal (CC 2.1.191)
- Fixed Cmd+click on links in fullscreen Ghostty over SSH (CC 2.1.191, 2.1.187)
- Fixed `claude agents` sending slash commands as text instead of showing hints (CC 2.1.191)
- Reduced CPU usage during streaming by ~37% through text update coalescing (CC 2.1.191)
- Reduced long-session memory growth from terminal output caching (CC 2.1.191)
- Bug fixes and reliability improvements (CC 2.1.190)
- Added org-configured model restrictions to model picker and related interfaces (CC 2.1.187)
- Fixed `--resume` failing with "No conversation found" for certain scenarios (CC 2.1.187)
- Fixed remote MCP tool calls hanging beyond 5 minutes (CC 2.1.187)
- Fixed Claude Code Remote sessions taking ~2.7s longer to start (CC 2.1.187)
- Fixed pasted Korean/CJK text becoming mojibake in certain terminals (CC 2.1.187)
- Fixed `/update` over Remote Control hanging during trust dialogs (CC 2.1.187)
- Fixed channel connections dropping after navigation (CC 2.1.187)
- Fixed leaked agent worktree registrations cleanup (CC 2.1.187)
- Fixed Esc/Ctrl-C/Ctrl-D not working during `/share` uploads (CC 2.1.187)
- Fixed `claude --help` not listing `--bg`/`--background` flag (CC 2.1.187)
- Fixed VSCode extension becoming unresponsive when resuming large sessions (CC 2.1.187)

---

## Summary (Updated after Stage 2 Verification)

**Version range audited:** 2.1.184 through 2.1.191 (8 versions after last audit of 2.1.183)

**Version gap note:** Versions 2.1.184, 2.1.188, 2.1.189, and 2.1.190 have no documented changes (2.1.190 only has "bug fixes and reliability improvements").

**Counts (after verification):**
- Must Update: 5 items (3 confirmed from original 15, 2 promoted from May Update)
- May Update: 7 items (after demotions)
- No Action: 35+ items (11 rejected from Must Update, 5 demoted from May Update, 19+ original)

**Key themes for plugin developers in this release range:**

1. **MCP enhancements** (2.1.186, 2.1.191):
   - ReadMcpResourceDirTool added for directory resource listing
   - MCP server retry logic improved for transient errors
   - MCP OAuth retry support for headless environments

2. **Hook fixes** (2.1.191):
   - Fixed comma-separated matchers not firing -- directly affects plugin hook configurations
   - Fixed `/permissions` denials not persisting -- affects PermissionRequest/PermissionDenied hooks

3. **New commands** (2.1.191):
   - `/rewind` for undoing `/clear` operations

**Items NOT plugin-relevant (rejected from Stage 1):**
Most of the Stage 1 "Must Update" items were internal Claude Code behavior changes (memory system, security monitor, artifact tool, coordinator orchestration) that plugin developers cannot customize or need to document. Plugin-dev focuses on APIs, hooks, MCP tools, and features that plugin authors can directly use.

**Triangulation notes:**
- claude-code-guide agent type not available in this environment (skipped)
- Two-source triangulation used: CC changelog + system-prompts CHANGELOG
- Changes confirmed in system-prompts marked as high confidence (more detailed source)
- Single-source changes from CC changelog marked as high confidence when clear feature additions

---

## Raw Changelog Data

### CC 2.1.191 (from upstream changelog)
```
- Added `/rewind` for resuming conversations before `/clear` was executed
- Fixed scroll position jumping during streaming responses
- Fixed background agents resurrecting after being stopped
- Improved `/voice` error messaging for organization-disabled cases
- Fixed `/login` URL truncation in Windows Terminal
- Fixed Cmd+click on links in fullscreen Ghostty over SSH
- Fixed `claude agents` sending slash commands as text instead of showing hints
- Fixed hooks with comma-separated matchers silently not firing
- Fixed `/permissions` denials not persisting after closure
- Improved MCP server reliability with retry logic for transient errors
- Improved MCP OAuth with retry support for headless environments
- Reduced CPU usage during streaming by ~37% through text update coalescing
- Reduced long-session memory growth from terminal output caching
```

### CC 2.1.190 (from upstream changelog)
```
- Bug fixes and reliability improvements
```

### CC 2.1.187 (from upstream changelog)
```
- Added `sandbox.credentials` setting to block sandboxed commands from reading credential files
- Added org-configured model restrictions to model picker and related interfaces
- Added mouse click support to select menus in fullscreen mode
- Fixed `--resume` failing with "No conversation found" for certain scenarios
- Fixed `--json-schema` structured output allowing indefinite `StructuredOutput` re-calls
- Fixed remote MCP tool calls hanging beyond 5 minutes
- Fixed Claude Code Remote sessions taking ~2.7s longer to start
- Fixed pasted Korean/CJK text becoming mojibake in certain terminals
- Fixed `/update` over Remote Control hanging during trust dialogs
- Fixed background jobs getting stuck in "working" state indefinitely
- Fixed channel connections dropping after navigation
- Fixed agent stop notifications and improved status messaging
- Fixed subagent depth tracking for resumed and forked subagents
- Fixed leaked agent worktree registrations cleanup
- Fixed Cmd+click not opening URLs in fullscreen Ghostty on macOS
- Fixed `claude --help` not listing `--bg`/`--background` flag
- Fixed Esc/Ctrl-C/Ctrl-D not working during `/share` uploads
- Improved `/install-github-app` with optional GitHub Actions workflow setup
- Improved `/btw` with arrow navigation for stepping through answers
- Improved `/plugin` surfacing unused plugins for cleanup
- Fixed VSCode extension becoming unresponsive when resuming large sessions
```

### System-prompts 2.1.191 (key items)
```
- NEW: Agent Prompt: Context tip selector - deciding when a brief Claude Code feature tip would help
- NEW: Agent Prompt: Context tip reception evaluator - tracking tip reception
- NEW: Data: Context tip situations (manual polling, persistent memory)
- REMOVED: Memory prompts and reminders - standalone memory synthesis/pruning agent prompts, memory-file description and staleness guidance, recalled-memory handling guidance, stale project-memory refresh guidance, immutable memory extraction/consolidation tool-constraint reminders
```

### System-prompts 2.1.187 (key items)
```
- REMOVED: System Reminder: Verify plan reminder - post-plan verification tool reminder
- Agent Prompt: Explore; System Prompt: Plan vs memory guidance - Add Artifact tool to disallowed tool lists
- Skill: Artifact design - Reworked from frontend-interface to broader artifact guidance
- Skill: Design sync - Authorization-error guidance update
- System Prompt: Agent thread notes - Agents return reports/analysis directly in final response
- Tool Description: Artifact - Must load artifact-design skill before writing page
```

### System-prompts 2.1.186 (key items)
```
- Agent Prompt: /review slash command - Replaces /review-pr with PR-diff-only GitHub review
- NEW: Agent Prompt: Security monitor edit-removal guidance
- NEW: Data: Claude Code agent proxy troubleshooting guide
- NEW: Tool Description: ReadMcpResourceDirTool prompt
- Agent Prompt: Security monitor - Narrowed classifier scope
- Data: Tool use - code_execution_20250825 to code_execution_20260521
- System Prompt: Coordinator mode orchestration - Worker-approval pattern
- Tool Description: SendMessageTool - Protocol-response section conditional
```

### System-prompts 2.1.185 (key items)
```
- REMOVED: Skill: Migrate to Claude Code - migration for Codex/Gemini CLI config
- Agent Prompt: CLAUDE.md creation - Removed migration offer
- Skill: /init CLAUDE.md and skill setup - Removed migration-offer item
```

---

## Stage 2: Verification Results
### Verified: 2026-06-25

#### Must Update Verification

- x **Memory prompts and reminders removed** (CC 2.1.191) -- REJECTED: Not plugin-relevant. This is an internal Claude Code memory system change, not affecting plugin development patterns. Plugin developers do not interact with Claude Code's memory synthesis/pruning system.

- x **Context tip system added** (CC 2.1.191) -- REJECTED: Not plugin-relevant. This is an internal UX feature for suggesting Claude Code tips to users. Does not affect plugin development patterns, hooks, or agent behavior that plugin authors can control.

- check **`/rewind` command added** (CC 2.1.191) -- Confirmed in CC changelog. Affects: command-development. Gap exists (not documented in command-development/overview.md). KEEP as Must Update. Plugin developers may want to document this command for completeness.

- check **`sandbox.credentials` setting added** (CC 2.1.187) -- Confirmed in CC changelog. However, DEMOTE to May Update: This is a security setting that affects sandboxed Bash commands, but plugin developers rarely need to document individual settings unless they specifically affect plugin behavior. Low plugin relevance.

- x **Artifact tool rework with artifact-design skill** (CC 2.1.187) -- REJECTED: Not plugin-relevant. This is about Claude Code's internal Artifact tool and design guidance, not about plugin development. Plugin developers do not create Artifacts as part of plugin functionality.

- x **Agent thread notes clarification** (CC 2.1.187) -- REJECTED: Not plugin-relevant for documentation. This is guidance for Claude Code's internal agent behavior about returning reports directly. Plugin developers do not control this behavior through plugin configuration.

- x **Verify plan reminder removed** (CC 2.1.187) -- REJECTED: Not plugin-relevant. This is an internal system prompt change affecting Claude Code's planning behavior. Does not affect plugin hooks, agents, or skills that developers create.

- x **PR review flow replaced** (CC 2.1.186) -- REJECTED: Not plugin-relevant. This describes Claude Code's internal `/review` slash command implementation, not something plugin developers need to know or can customize.

- x **Security monitor edit-removal guidance added** (CC 2.1.186) -- REJECTED: Not plugin-relevant for documentation. This is internal guidance for Claude Code's security monitor, not affecting plugin development.

- check **MCP ReadMcpResourceDirTool added** (CC 2.1.186) -- Confirmed in system-prompts CHANGELOG. Affects: mcp-integration. Gap exists (not documented). KEEP as Must Update. This is a new MCP tool that plugin authors should know about for directory resource listing.

- x **Coordinator mode worker-approval pattern** (CC 2.1.186) -- REJECTED: Not plugin-relevant for plugin-dev documentation. This is internal agent coordination behavior. Plugin developers create agents but do not control Claude Code's coordinator mode orchestration.

- x **Security monitor scope narrowed** (CC 2.1.186) -- REJECTED: Not plugin-relevant. Internal security classifier changes do not affect plugin development patterns.

- x **code_execution tool version updated** (CC 2.1.186) -- REJECTED: Not plugin-relevant. This is about Claude API examples in documentation, not plugin development.

- x **Migrate to Claude Code skill removed** (CC 2.1.185) -- REJECTED: Not plugin-relevant. This is about a built-in Claude Code skill for migrating from other tools, not about plugin development.

- check **Hooks comma-separated matchers fix** (CC 2.1.191) -- Confirmed in CC changelog. Affects: hook-development. Gap exists (bug fix should be noted). KEEP as Must Update. This is directly plugin-relevant as it affects how hook matchers work.

#### Missed Items (promoted from No Action)

- ! **`/permissions` denials persistence fix** (CC 2.1.191) -- Promoted from May Update to Must Update. This is directly plugin-relevant as it affects permission management that plugin hooks can interact with. Should be documented as a fix in hook-development or command-development.
  - Affects: hook-development (PermissionRequest/PermissionDenied hooks)
  - Details: Fixed `/permissions` denials not persisting after closure

- ! **MCP server retry logic improved** (CC 2.1.191) -- Promoted from May Update to Must Update. MCP reliability improvements directly affect plugins that bundle MCP servers.
  - Affects: mcp-integration
  - Details: Improved MCP server reliability with retry logic for transient errors; improved MCP OAuth with retry support

#### May Update Resolution

- down **`sandbox.credentials` setting** -- Demoted from Must Update: Low direct plugin relevance. Plugin developers do not typically document individual sandbox settings unless they specifically affect plugin behavior.

- = **Agent proxy troubleshooting guide added** (CC 2.1.186) -- Kept as May Update: Useful background info but not core to plugin development.

- = **Mouse click support in fullscreen mode** (CC 2.1.187) -- Kept as May Update (consider demoting to No Action): UI feature, low plugin relevance.

- down **`/btw` arrow navigation** (CC 2.1.187) -- Demoted to No Action: UI feature, not plugin-relevant.

- = **`/plugin` unused plugin surfacing** (CC 2.1.187) -- Kept as May Update: Plugin management feature worth noting.

- = **`/install-github-app` workflow setup** (CC 2.1.187) -- Kept as May Update: GitHub integration, potentially useful for CI/CD documentation.

- = **`--json-schema` structured output fix** (CC 2.1.187) -- Kept as May Update: Affects headless/CI usage patterns.

- down **Background agents stopping fix** (CC 2.1.191) -- Demoted to No Action: Bug fix, not documentation-worthy.

- down **Background jobs stuck state fix** (CC 2.1.187) -- Demoted to No Action: Bug fix, not documentation-worthy.

- = **Subagent depth tracking fix** (CC 2.1.187) -- Kept as May Update: Relevant to agent development documentation.

- = **Agent stop notifications improved** (CC 2.1.187) -- Kept as May Update: Relevant to agent behavior documentation.

- down **SendMessageTool protocol changes** (CC 2.1.186) -- Demoted to No Action: Internal protocol change, not directly affecting plugin development.

#### Summary

- **Must Update: 5 items** (3 confirmed from original 15, 2 promoted from May Update; 12 rejected as not plugin-relevant)
  1. `/rewind` command (CC 2.1.191) -- command-development
  2. MCP ReadMcpResourceDirTool (CC 2.1.186) -- mcp-integration
  3. Hooks comma-separated matchers fix (CC 2.1.191) -- hook-development
  4. `/permissions` denials persistence fix (CC 2.1.191) -- hook-development
  5. MCP server retry logic (CC 2.1.191) -- mcp-integration

- **May Update: 7 items** (1 demoted from Must Update, 4 demoted to No Action)
  1. `sandbox.credentials` setting (CC 2.1.187)
  2. Agent proxy troubleshooting (CC 2.1.186)
  3. Mouse click fullscreen (CC 2.1.187)
  4. `/plugin` unused surfacing (CC 2.1.187)
  5. `/install-github-app` workflow (CC 2.1.187)
  6. `--json-schema` fix (CC 2.1.187)
  7. Subagent depth tracking fix (CC 2.1.187)
  8. Agent stop notifications (CC 2.1.187)

- **Confidence: HIGH**

The Stage 1 manifest over-classified many items as plugin-relevant. The key distinction is:
- **Plugin-relevant**: Features that plugin developers can USE (hooks, MCP tools, commands, agent configs)
- **NOT plugin-relevant**: Internal Claude Code behavior changes (memory system, security monitor internals, artifact design, coordinator orchestration) that plugin developers cannot customize or need to know about

**Significant Issue Flag**: 12 of 15 original Must Update items (80%) were rejected as not plugin-relevant. Stage 1 needs improved filtering to distinguish between:
1. Changes to Claude Code's internal prompts/behavior (not plugin-relevant)
2. Changes to APIs, tools, hooks, and features plugin developers can use (plugin-relevant)
