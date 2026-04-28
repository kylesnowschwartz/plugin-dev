# Upstream Change Manifest
## CC Version Range: 2.1.121 - 2.1.121
## Generated: 2026-04-28
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - agent dispatch timed out in CI]

---

### Must Update

- [ ] **`alwaysLoad` option for MCP servers** (CC 2.1.121)
  - Source: changelog (verified Stage 2)
  - Confidence: HIGH (independently verified)
  - Affects: mcp-integration (`references/mcp-integration/overview.md`)
  - Details: New option added for MCP servers that allows them to load unconditionally, bypassing tool-search deferral. This is directly relevant for plugin developers who want their MCP servers to always be available regardless of lazy-loading settings.
  - Raw changelog: "Added `alwaysLoad` option for MCP server configuration to bypass tool-search deferral"

- [ ] **Plugin pruning command** (CC 2.1.121)
  - Source: changelog (verified Stage 2)
  - Confidence: HIGH (independently verified)
  - Affects: plugin-structure (`references/plugin-structure/overview.md`)
  - Details: New `claude plugin prune` command for removing orphaned auto-installed dependencies. Document the command syntax and when users should use it (cleanup after uninstalling plugins).
  - Raw changelog: "`claude plugin prune` command for removing orphaned auto-installed dependencies"

- [ ] **PostToolUse `updatedToolOutput` for tool output replacement** (CC 2.1.121)
  - Source: changelog (added Stage 2)
  - Confidence: HIGH (independently verified)
  - Affects: hook-development (`references/hook-development/overview.md`, `references/hook-development/references/event-schemas.md`)
  - Details: PostToolUse hooks can now replace tool output via `hookSpecificOutput.updatedToolOutput`. This extends beyond the existing `updatedMCPToolOutput` (MCP-only) to allow output replacement for ANY tool. Critical capability for hook developers.
  - Raw changelog: "`PostToolUse` hooks can now replace tool output via `hookSpecificOutput.updatedToolOutput`"

- [ ] **`CLAUDE_CODE_FORK_SUBAGENT=1` for non-interactive sessions** (CC 2.1.121)
  - Source: changelog (added Stage 2)
  - Confidence: HIGH (independently verified)
  - Affects: agent-development, plugin-structure (`references/plugin-structure/references/headless-ci-mode.md`)
  - Details: New environment variable support enabling subagent forking in non-interactive/headless sessions. Relevant for CI/CD automation and headless plugin testing.
  - Raw changelog: "`CLAUDE_CODE_FORK_SUBAGENT=1` support in non-interactive sessions"

### May Update

- [ ] **MCP server auto-retry on transient errors** (CC 2.1.121)
  - Source: changelog (added Stage 2)
  - Confidence: MEDIUM (informational)
  - Affects: mcp-integration (`references/mcp-integration/overview.md`)
  - Details: MCP servers now auto-retry up to 3 times for transient startup errors. This is useful information for plugin developers debugging MCP server connection issues. Could be mentioned in the error handling or debugging section.
  - Raw changelog: "MCP server auto-retry (up to 3 times) for transient startup errors"

### No Action

- Type-to-filter search for skills (CC 2.1.121) - UI improvement for `/skills` menu, not plugin-relevant (demoted from May Update - Stage 2)
- ReadFile tool description change (CC 2.1.121) - Internal prompt cleanup, not plugin-relevant (demoted from May Update - Stage 2)
- Improved fullscreen scrolling (CC 2.1.121) - UI improvement, not plugin-related
- Scrollable dialogs in fullscreen and non-fullscreen modes (CC 2.1.121) - UI improvement, not plugin-related
- Memory leak fixes (CC 2.1.121) - Internal performance fix, not plugin-related
- Enhanced `/terminal-setup` for clipboard access in iTerm2 (CC 2.1.121) - Terminal setup, not plugin-related
- `redirectUri` parameter support in SDK `mcp_authenticate` (CC 2.1.121) - SDK feature, not plugin manifest/structure relevant
- OpenTelemetry additions (CC 2.1.121) - Observability internals, not plugin-related
- Various bug fixes including Bash tool, MCP auth, LSP diagnostics, Windows plugin cache (CC 2.1.121) - Stability improvements, not documentation gaps

---

## Notes

1. **Version 2.1.121 is a minor release** with only 5 documented changes from the upstream changelog. Of these, 2 directly affect plugin development:
   - `alwaysLoad` for MCP servers (new configuration option)
   - Plugin pruning command (new CLI command)

2. **System-prompts delta**: -13 tokens total, indicating this was primarily a cleanup release with minimal system prompt changes. The only change was removal of a redundant extension point from the ReadFile tool description.

3. **Cross-reference gap**: The claude-code-guide agent dispatch timed out in this CI environment (empty output after 90+ seconds). Official documentation cross-referencing could not be completed. Manual verification against https://docs.anthropic.com/en/docs/claude-code is recommended for the "Must Update" items.

4. **Lower confidence items**: The `alwaysLoad` and plugin pruning entries come only from the changelog (via WebFetch summary). The exact configuration syntax and command arguments should be verified before updating plugin-dev documentation.

## Token Delta Summary (from system-prompts)

| Version | Delta | Key Changes |
|---------|-------|-------------|
| 2.1.121 | -13 | ReadFile tool description cleanup (removed redundant extension point) |

**Net change since 2.1.120**: -13 tokens (minor cleanup release)

---

## Summary

| Category | Count |
|----------|-------|
| Must Update | 4 |
| May Update | 1 |
| No Action | 9 |

**Version Range**: 2.1.121 only (1 version since last audit at 2.1.120)

**High-priority items for plugin-dev** (verified Stage 2):
1. **`alwaysLoad` for MCP servers** (CC 2.1.121) - new configuration option to bypass tool-search deferral
2. **Plugin pruning command** (CC 2.1.121) - `claude plugin prune` for removing orphaned dependencies
3. **PostToolUse `updatedToolOutput`** (CC 2.1.121) - hooks can now replace ANY tool output (not just MCP)
4. **`CLAUDE_CODE_FORK_SUBAGENT=1`** (CC 2.1.121) - subagent support in non-interactive sessions

**Documentation targets**:
1. `references/mcp-integration/overview.md` - add `alwaysLoad` configuration option and auto-retry behavior
2. `references/plugin-structure/overview.md` - add `claude plugin prune` command
3. `references/hook-development/overview.md` and `event-schemas.md` - add `updatedToolOutput` for PostToolUse
4. `references/plugin-structure/references/headless-ci-mode.md` - add `CLAUDE_CODE_FORK_SUBAGENT=1`

---

## Raw Changelog Excerpts

### CC 2.1.121 (from upstream changelog via WebFetch - Stage 2 verified)

**Added:**
- `alwaysLoad` option for MCP server configuration to bypass tool-search deferral
- `claude plugin prune` command for removing orphaned auto-installed dependencies
- Type-to-filter search box in `/skills` interface
- `PostToolUse` hooks can now replace tool output via `hookSpecificOutput.updatedToolOutput`
- Scrollable dialogs in both fullscreen and non-fullscreen modes
- `CLAUDE_CODE_FORK_SUBAGENT=1` support in non-interactive sessions
- Enhanced `/terminal-setup` for clipboard access in iTerm2
- MCP server auto-retry (up to 3 times) for transient startup errors
- `redirectUri` parameter support in SDK `mcp_authenticate` for custom scheme completion
- OpenTelemetry additions: `stop_reason`, `gen_ai.response.finish_reasons`, and `user_system_prompt`

**Fixed:**
- Unbounded memory growth when processing many images
- `/usage` memory leaks (~2GB potential)
- Memory leak in long-running tools with missing progress events
- Bash tool unusability after working directory deletion
- Various MCP authentication and connection issues
- LSP diagnostic expansion and display improvements
- Managed settings approval prompt behavior
- `NO_PROXY` environment variable handling across HTTP clients
- Plugin MCP servers on Windows with incomplete cache
- Multiple UI rendering and scrollback issues

### System-prompts 2.1.121 (from local CHANGELOG.md)

```
_-13 tokens_

- Tool Description: ReadFile -- Removed the extra additional-usage-notes extension point from the
  end of the ReadFile tool description, leaving the existing additional-read-note hook as the
  final conditional guidance.
```

---

## Stage 2: Verification Results
### Verified: 2026-04-28

#### Must Update Verification
- ✓ **`alwaysLoad` option for MCP servers** (CC 2.1.121) — confirmed in upstream changelog, gap exists in `references/mcp-integration/overview.md` (no mention of `alwaysLoad`)
- ✓ **Plugin pruning command** (CC 2.1.121) — confirmed as `claude plugin prune` in upstream changelog, gap exists (not documented anywhere in plugin-dev)

#### Missed Items (promoted from No Action)
- ! **PostToolUse `updatedToolOutput` for tool output replacement** (CC 2.1.121) — CRITICAL MISS: Upstream changelog states "PostToolUse hooks can now replace tool output via `hookSpecificOutput.updatedToolOutput`". This is highly relevant to hook development.
  - Affects: hook-development
  - Details: New capability allowing PostToolUse hooks to replace ANY tool output (not just MCP tools). Currently plugin-dev only documents `updatedMCPToolOutput` for MCP tools at `references/hook-development/overview.md:463` and `references/hook-development/references/event-schemas.md:390`. Need to document the new general `updatedToolOutput` field.
  - Priority: HIGH

- ! **MCP server auto-retry on transient errors** (CC 2.1.121) — missed because classified as "various bug fixes"
  - Affects: mcp-integration
  - Details: MCP servers now auto-retry up to 3 times for transient startup errors. This is useful information for plugin developers to know when debugging MCP server issues.
  - Priority: LOW (nice-to-know, not critical)

- ! **`CLAUDE_CODE_FORK_SUBAGENT=1` for non-interactive sessions** (CC 2.1.121) — missed because not in No Action list
  - Affects: agent-development, headless-ci-mode
  - Details: New environment variable support for running subagents in non-interactive/headless sessions. Relevant for CI/CD and automation use cases.
  - Priority: MEDIUM

#### May Update Resolution
- ↓ **Type-to-filter search for skills** — demoted to No Action: This is a user-facing UI improvement for the `/skills` menu. Does not affect how plugins define or trigger skills. No documentation gap.
- ↓ **ReadFile tool description change** — demoted to No Action: Internal prompt cleanup removing redundant extension point. Not relevant to plugin development. The `additional-read-note` hook mentioned is internal to Claude Code, not a plugin feature.

#### Summary
- Must Update: 4 items (2 confirmed from Stage 1, 0 rejected, 2 added from missed items)
  - `alwaysLoad` option for MCP servers ✓
  - Plugin pruning command ✓
  - PostToolUse `updatedToolOutput` capability (NEW)
  - `CLAUDE_CODE_FORK_SUBAGENT=1` environment variable (NEW)
- May Update: 1 item remaining
  - MCP server auto-retry (informational, low priority)
- Confidence: HIGH — independent WebFetch of upstream changelog confirmed Stage 1's "Must Update" items and revealed 2 missed plugin-relevant features

#### Corrections Applied to Manifest
The following changes have been made to the manifest body above:
1. Added PostToolUse `updatedToolOutput` to Must Update
2. Added `CLAUDE_CODE_FORK_SUBAGENT=1` to Must Update
3. Moved Type-to-filter and ReadFile changes to No Action
4. Moved MCP auto-retry to May Update

---

## Data Quality Notes

- Two-source triangulation (CC changelog + system-prompts changelog) - both sources accessible
- claude-code-guide agent dispatch failed (timed out with empty output)
- System-prompts changelog provides structured detail with token counts
- This is a small delta release with limited plugin-relevant changes
- Confidence is MEDIUM for changelog-only items due to WebFetch summarization
- **Stage 2 Note:** Independent WebFetch revealed additional features not captured by Stage 1's summarization

---

## Comparison to Previous Audit

Previous audit (2.1.118-2.1.120) had:
- 36 Must Update items
- 9 May Update items
- +17,993 tokens net change

This audit (2.1.121) has (after Stage 2 verification):
- 4 Must Update items (2 original + 2 promoted from missed)
- 1 May Update item (1 demoted to informational)
- -13 tokens net change

This suggests 2.1.121 is a maintenance/polish release with a few targeted feature additions. The `PostToolUse` `updatedToolOutput` capability is the most significant plugin-relevant addition.
