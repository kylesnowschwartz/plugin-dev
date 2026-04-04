# Upstream Change Manifest
## CC Version Range: 2.1.89 - 2.1.92
## Generated: 2026-04-04
## Sources: changelog [OK], system-prompts [OK], claude-code-guide [failed - agent not available in CI]

---

### Must Update

- [ ] **PreToolUse hooks can return `"defer"` permission decision** (CC 2.1.89)
  - Source: changelog, system-prompts (implied by deferred tool handling)
  - Confidence: high
  - Affects: hook-development skill (SKILL.md line 322)
  - Details: Headless sessions can now pause tool execution and resume later with `-p --resume`. The `defer` decision allows hooks to put tools on hold rather than immediately allowing or denying. This is a new permission decision type alongside `allow`, `deny`, and `ask`.
  - Raw changelog: "Added `\"defer\"` permission decision to `PreToolUse` hooks -- headless sessions can pause and resume with `-p --resume`"
  - Gap: SKILL.md line 322 shows `permissionDecision: "allow|deny|ask"` -- needs `defer` added

- [ ] **MCP tool result persistence override via `_meta` annotation** (CC 2.1.91)
  - Source: changelog only
  - Confidence: high
  - Affects: mcp-integration skill (SKILL.md MCP Output Limits section)
  - Details: MCP servers can now return larger results (up to 500K characters) by setting `_meta["anthropic/maxResultSizeChars"]` in the tool result annotation. Useful for large database schemas or similar payloads.
  - Raw changelog: "Added MCP tool result persistence override via `_meta[\"anthropic/maxResultSizeChars\"]` annotation (up to 500K)"
  - Gap: Not documented in mcp-integration/SKILL.md

- [ ] **`disableSkillShellExecution` setting** (CC 2.1.91)
  - Source: changelog only
  - Confidence: high
  - Affects: skill-development skill (Dynamic Content section) and command-development skill
  - Details: New setting that disables inline shell execution in skills, custom slash commands, and plugin commands. This is a security control for environments that want skills but not arbitrary shell execution.
  - Raw changelog: "`disableSkillShellExecution` setting to disable inline shell execution in skills, custom slash commands, and plugin commands"
  - Gap: Not documented in skill-development/SKILL.md or command-development/SKILL.md

- [ ] **Plugins can ship executables under `bin/` directory** (CC 2.1.91)
  - Source: changelog only
  - Confidence: high
  - Affects: plugin-structure skill (Directory Structure section)
  - Details: Plugins can now include executables in a `bin/` subdirectory and invoke them as bare commands from the Bash tool. This enables plugins to ship compiled tools or scripts.
  - Raw changelog: "Plugins can ship executables under `bin/` and invoke them as bare commands from Bash tool"
  - Gap: Not documented in plugin-structure/SKILL.md

---

### May Update

- [ ] **`MCP_CONNECTION_NONBLOCKING=true` env var** (CC 2.1.89)
  - Source: changelog only
  - Confidence: low
  - Affects: mcp-integration skill (headless/CI mode patterns)
  - Details: For `-p` mode, this env var skips waiting for MCP connections entirely.
  - Raw changelog: "`MCP_CONNECTION_NONBLOCKING=true` for `-p` mode skips MCP connection wait entirely"

- [ ] **MCP tool truncation guidance updated** (CC 2.1.92)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: mcp-integration skill (subagent guidance)
  - Details: Changed subagent file-reading guidance from "Read ALL of [file]" to instruct reading in sequential chunks using offset/limit until 100% of the file has been read, then summarizing.
  - System-prompts: "System Prompt: MCP Tool Result Truncation -- Changed subagent file-reading guidance..."

- [ ] **ReadFile tool supports relative paths** (CC 2.1.91)
  - Source: system-prompts only
  - Confidence: low
  - Affects: skill script examples (minor style preference)
  - Details: ReadFile now supports relative paths as a preferred alternative (for brevity) to absolute-path-only requirement. Line read limit and additional notes are now configurable.
  - System-prompts: "Tool Description: ReadFile -- Added support for relative file paths (preferred for brevity)..."

---

### No Action

**Demoted from Must Update (Stage 2 verification):**
- PermissionDenied hook fires after auto mode classifier denials (CC 2.1.89) -- already documented in hook-development/SKILL.md lines 385-423
- `/tag` and `/vim` commands removed (CC 2.1.92) -- built-in commands, not plugin-dev scope
- Write tool guidance changed: always prefer Edit (CC 2.1.92) -- tool description, not plugin-dev scope
- Hook condition evaluator specialized for stop conditions (CC 2.1.92) -- internal implementation detail
- Sleep tool removed (CC 2.1.92) -- built-in tool, not plugin-dev scope
- Agent Design Patterns skill added (CC 2.1.91) -- built-in CC skill, not plugin-dev scope

**Demoted from May Update (Stage 2 verification):**
- Named subagents in `@` mention typeahead (CC 2.1.89) -- UX feature, no plugin API impact
- `/powerup` command added (CC 2.1.90) -- built-in command, not plugin-dev scope
- `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE` env var (CC 2.1.90) -- operational env var
- `.husky` added to protected directories (CC 2.1.90) -- permissions detail, not plugin-dev scope
- `forceRemoteSettingsRefresh` policy setting (CC 2.1.92) -- managed settings, not plugin-dev scope
- Edit tool guidelines made configurable (CC 2.1.91) -- not plugin-dev scope
- Computer Use MCP skill added (CC 2.1.89) -- built-in CC skill
- Remote plan mode (ultraplan) prompt added (CC 2.1.89) -- built-in CC feature
- Buddy Mode prompt added (CC 2.1.89) -- built-in CC feature
- Security monitor prompt significantly expanded (CC 2.1.89-2.1.90) -- internal security

**Original No Action items:**
- Fix for rate-limit options dialog infinite loop (CC 2.1.90)
- Subagent spawning fix after tmux window changes (CC 2.1.92)
- Stop hooks fix for small fast model `ok:false` (CC 2.1.92)
- Tool input validation fixes for streaming (CC 2.1.92)
- API 400 error fix for whitespace-only thinking blocks (CC 2.1.92)
- Write tool diff computation 60% faster (CC 2.1.92)
- Bedrock setup wizard added (CC 2.1.92)
- Per-model cost breakdown in `/cost` (CC 2.1.92)
- `/release-notes` interactive version picker (CC 2.1.92)
- Remote Control session name improvements (CC 2.1.92)
- Footer hint for uncached tokens after cache expiration (CC 2.1.92)
- Linux sandbox `apply-seccomp` fix (CC 2.1.92)
- Transcript chain fix for `--resume` (CC 2.1.91)
- `cmd+delete` fix for various terminals (CC 2.1.91)
- Plan mode fix for remote sessions (CC 2.1.91)
- JSON schema validation fix for `permissions.defaultMode: "auto"` (CC 2.1.91)
- Edit tool using shorter anchors (CC 2.1.91)
- Faster `stripAnsi` on Bun (CC 2.1.91)
- Multi-line prompt support in deep links (CC 2.1.91)
- Various PreToolUse hook fixes for JSON stdout (CC 2.1.90)
- Auto mode boundary respect fixes (CC 2.1.90)
- PowerShell security hardening (CC 2.1.90)
- SSE transport performance fix (CC 2.1.90)
- `/resume` parallel session loading (CC 2.1.90)
- DNS cache commands removed from auto-allow (CC 2.1.90)
- CLAUDE_CODE_NO_FLICKER env var (CC 2.1.89)
- Edit/Read/Write symlink target checking fix (CC 2.1.89)
- Various voice mode fixes (CC 2.1.89)
- CRLF handling fixes (CC 2.1.89)
- StructuredOutput schema cache fix (CC 2.1.89)
- LSP server restart on crash (CC 2.1.89)
- Autocompact thrash loop detection (CC 2.1.89)
- Nested CLAUDE.md re-injection fix (CC 2.1.89)
- Hooks `if` condition fix for compound commands (CC 2.1.89)
- Thinking summaries disabled by default (CC 2.1.89)
- Team memory content display removed (CC 2.1.92)
- /pr-comments slash command removed (CC 2.1.91)
- Update Magic Docs agent prompt removed (CC 2.1.91)
- Memory attachment guidance updates (CC 2.1.90-2.1.91)
- Verification specialist prompt expansions (CC 2.1.89-2.1.90)
- Prompt caching documentation updates (CC 2.1.89)

---

## Notes

1. **Degraded triangulation**: The claude-code-guide agent was not available in this CI environment, so cross-referencing against official docs was not performed. Changes are confirmed via changelog and system-prompts sources only.

2. **High-priority items for plugin-dev**:
   - The `defer` permission decision is a significant addition to the hooks system
   - PermissionDenied hook expansion affects auto-mode integration
   - Plugin `bin/` directory support is a new plugin capability
   - `disableSkillShellExecution` setting affects how skills execute
   - Write tool "always prefer Edit" guidance may affect our examples
   - Sleep tool removal affects tool documentation

3. **System-prompts changelog is more authoritative** for prompt/tool description changes, while the GitHub changelog captures user-facing features and settings.

4. **Token delta summary**:
   - 2.1.89: +3,986 tokens (MCP truncation, remote plan mode, buddy mode, computer use MCP skill)
   - 2.1.90: +815 tokens (memory attachment, security monitor expansion)
   - 2.1.91: +2,043 tokens (Agent Design Patterns skill, tool description updates)
   - 2.1.92: -167 tokens (hook evaluator specialization, Sleep tool removal, Write tool guidance)

---

## Stage 2: Verification Results
### Verified: 2026-04-04

#### Must Update Verification
- ✓ **PreToolUse hooks can return `"defer"` permission decision** (CC 2.1.89) -- confirmed in changelog, gap exists in hook-development/SKILL.md line 322 (only shows `allow|deny|ask`, missing `defer`)
- ✗ **PermissionDenied hook now fires after auto mode classifier denials** (CC 2.1.89) -- REJECTED: already documented at hook-development/SKILL.md lines 385-423 (added in previous 2.1.88 sync)
- ✓ **MCP tool result persistence override via `_meta` annotation** (CC 2.1.91) -- confirmed in changelog, gap exists in mcp-integration/SKILL.md (no mention of maxResultSizeChars)
- ✓ **`disableSkillShellExecution` setting** (CC 2.1.91) -- confirmed in changelog, gap exists in skill-development/SKILL.md (not documented)
- ✓ **Plugins can ship executables under `bin/` directory** (CC 2.1.91) -- confirmed in changelog, gap exists in plugin-structure/SKILL.md (not documented)
- ↓ **`/tag` and `/vim` commands removed** (CC 2.1.92) -- demoted to No Action: built-in commands not documented in plugin-dev
- ↓ **Write tool guidance changed: always prefer Edit** (CC 2.1.92) -- demoted to No Action: not plugin-dev scope (tool descriptions)
- ↓ **Hook condition evaluator specialized for stop conditions** (CC 2.1.92) -- demoted to No Action: internal implementation detail, no plugin API surface change
- ↓ **Sleep tool removed** (CC 2.1.92) -- demoted to No Action: not plugin-dev scope (built-in tools)
- ↓ **Agent Design Patterns skill added** (CC 2.1.91) -- demoted to No Action: built-in CC skill, not plugin-dev documentation scope

#### Skill Mapping Corrections
- ! **skill-anatomy** -- INCORRECT: skill does not exist; should be `skill-development`
- ! **plugin-json-schema** -- INCORRECT: skill does not exist; should be `plugin-structure`
- ! **slash-commands** -- INCORRECT: skill does not exist; should be `command-development`
- ! **build-with-claude-api** -- INCORRECT: skill does not exist in plugin-dev (built-in CC skill)

#### Missed Items (promoted from No Action)
- None identified. Scanned changelog for: hook, plugin, agent, skill, command, MCP, LSP, tool, permission, subagent, frontmatter, manifest, plugin.json, PreToolUse, PostToolUse, SessionStart, Stop. All relevant items were captured.

#### May Update Resolution
- ↓ **Named subagents in `@` mention typeahead** (CC 2.1.89) -- demoted to No Action: UX feature, no plugin API impact
- = **`MCP_CONNECTION_NONBLOCKING=true` env var** (CC 2.1.89) -- kept as May Update: could document in mcp-integration references
- ↓ **`/powerup` command added** (CC 2.1.90) -- demoted to No Action: built-in command, not plugin-dev scope
- ↓ **`CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE` env var** (CC 2.1.90) -- demoted to No Action: operational env var, not plugin development
- ↓ **`.husky` added to protected directories** (CC 2.1.90) -- demoted to No Action: permissions detail, not plugin-dev scope
- ↓ **`forceRemoteSettingsRefresh` policy setting** (CC 2.1.92) -- demoted to No Action: managed settings, not plugin-dev scope
- = **MCP tool truncation guidance updated** (CC 2.1.92) -- kept as May Update: could document in mcp-integration subagent guidance
- = **ReadFile tool supports relative paths** (CC 2.1.91) -- kept as May Update: could affect skill script examples
- ↓ **Edit tool guidelines made configurable** (CC 2.1.91) -- demoted to No Action: not plugin-dev scope
- ↓ **Computer Use MCP skill added** (CC 2.1.89) -- demoted to No Action: built-in CC skill, not plugin-dev scope
- ↓ **Remote plan mode (ultraplan) prompt added** (CC 2.1.89) -- demoted to No Action: built-in CC feature
- ↓ **Buddy Mode prompt added** (CC 2.1.89) -- demoted to No Action: built-in CC feature
- ↓ **Security monitor prompt significantly expanded** (CC 2.1.89-2.1.90) -- demoted to No Action: internal security, not plugin API

#### Summary
- Must Update: 4 items confirmed (defer decision, MCP maxResultSizeChars, disableSkillShellExecution, plugin bin/)
- Must Update: 6 items demoted to No Action (not plugin-dev scope)
- May Update: 3 items remaining (MCP_CONNECTION_NONBLOCKING, MCP truncation guidance, ReadFile relative paths)
- Skill Mapping: 4 corrections needed (skill names were incorrect in original manifest)
- Confidence: HIGH -- Changes verified against primary sources; skill file gaps confirmed by reading actual SKILL.md files
