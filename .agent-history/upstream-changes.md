# Upstream Change Manifest
## CC Version Range: 2.1.207 - 2.1.208
## Generated: 2026-07-14
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - only 1 version delta]

---

## Summary

Only **one version** (2.1.208) has been released since the last audit (2.1.207). This is a relatively minor release focused on accessibility, configuration options, and bug fixes. No breaking changes to the plugin system were identified.

---

### Must Update

_(None identified)_

There are no changes in v2.1.208 that directly affect plugin manifests, hook events, skill formats, or agent behavior in ways that require documentation updates.

---

### May Update

_(None remaining after Stage 2 verification - all 4 items demoted to No Action)_

---

### No Action

_System-prompts changes (demoted from May Update by Stage 2):_

- **Artifact tool: Native Mermaid rendering** (CC 2.1.208) - plugin-dev does not document the Artifact tool
- **Auto mode setup: Deterministic pre-gathering changes** (CC 2.1.208) - internal CC behavior, not plugin authoring
- **Artifact themes: OS color scheme support** (CC 2.1.208) - Artifact-related, not plugin authoring
- **Background monitor: Foreground fallback guidance** (CC 2.1.208) - system prompt guidance for built-in tool

_CC changelog items (confirmed by Stage 2):_

- **Screen reader mode** (`--ax-screen-reader` flag) (CC 2.1.208) - Accessibility feature, not plugin-related
- **`vimInsertModeRemaps` setting** (CC 2.1.208) - Editor configuration, not plugin-related
- **`CLAUDE_CODE_PROCESS_WRAPPER` env var** (CC 2.1.208) - Corporate launcher execution, not plugin-related
- **Mouse-click support for multi-select menus** (CC 2.1.208) - UI enhancement, not plugin-related
- **Fast mode auto-restore after model switches** (CC 2.1.208) - Internal behavior, not plugin-related
- **Background agent reply persistence** (CC 2.1.208) - Bug fix, not plugin-related
- **Background daemon attach failures fix** (CC 2.1.208) - Bug fix, not plugin-related
- **Context window reset fix after CLI auto-updates** (CC 2.1.208) - Bug fix, not plugin-related
- **HTTP/2 GOAWAY connection handling** (CC 2.1.208) - Network fix, not plugin-related
- **Stream-json/JSON output truncation fix** (CC 2.1.208) - Bug fix, not plugin-related
- **Scientific notation env vars parsing** (CC 2.1.208) - Bug fix, not plugin-related
- **Large markdown tables pagination** (CC 2.1.208) - UI enhancement, not plugin-related
- **Edit tool modified-file handling** (CC 2.1.208) - Tool bug fix, not plugin-system change
- **Read/Grep/Glob tool improvements** (CC 2.1.208) - Tool bug fixes (empty files, regex, null bytes)
- **`apiKeyHelper` script error display** (CC 2.1.208) - Error handling improvement
- **Bedrock streaming error clarification** (CC 2.1.208) - Error messaging, not plugin-related
- **`/upgrade` login flow fix** (CC 2.1.208) - Command bug fix, not plugin-related
- **Stream-json input handling for Windows SDK hosts** (CC 2.1.208) - Platform fix, not plugin-related
- **Headless stream-json session hang fix** (CC 2.1.208) - Bug fix, not plugin-related
- **Background task orphan notice consolidation** (CC 2.1.208) - UI improvement, not plugin-related
- **Remote Control client improvements** (CC 2.1.208) - Feature enhancement, not plugin-related
- **Agent tool error messaging improvement** (CC 2.1.208) - Error messaging, not plugin-system change
- **`/usage` and `/mcp` caching fixes** (CC 2.1.208) - Command bug fixes, not plugin-related
- **"Change directory" SDK host fix** (CC 2.1.208) - Bug fix, not plugin-related
- **Workflow save dialog path fix** (CC 2.1.208) - UI fix, not plugin-related
- **`/release-notes` context injection fix** (CC 2.1.208) - Command fix, not plugin-related
- **Memory leak fixes** (agent view, MCP stderr, LSP docs, async hooks, file read) (CC 2.1.208) - Performance fixes
- **Permission rule matcher optimization** (CC 2.1.208) - Performance improvement
- **Input responsiveness during task list updates** (CC 2.1.208) - Performance improvement
- **Tool-call CPU overhead reduction** (CC 2.1.208) - Performance improvement
- **File edit read cache bounded to 16 MB** (CC 2.1.208) - Performance improvement
- **Session transcript/checkpoint size reduction** (CC 2.1.208) - Performance improvement
- **Background agent/fork session memory improvements** (CC 2.1.208) - Performance improvement
- **Completed background agents in `/tasks`** (CC 2.1.208) - Behavior refinement, not plugin-related
- **Stopped background agents transcript display** (CC 2.1.208) - UI improvement, not plugin-related
- **Background daemon worker version compatibility** (CC 2.1.208) - Compatibility improvement
- **Agent view Ctrl+X handling for worktrees** (CC 2.1.208) - UI improvement, not plugin-related
- **Catastrophic removal prompts with `$(...)` and backticks** (CC 2.1.208) - UI fix, not plugin-related
- **`/install-github-app` and `/mcp` blocked in background sessions** (CC 2.1.208) - Security hardening
- **Empty MCP server URLs display** (CC 2.1.208) - UI improvement, not plugin-related
- **`/usage` rate-limited display** (CC 2.1.208) - UI improvement, not plugin-related
- **Bedrock AWS SSO profile authentication fix** (CC 2.1.208) - Authentication fix, not plugin-related

---

## Raw Changelog Data

### CC Changelog v2.1.208

```
- Screen reader mode with plain-text rendering (opt-in via `claude --ax-screen-reader`)
- `vimInsertModeRemaps` setting for two-key sequences like `jj` to Escape
- `CLAUDE_CODE_PROCESS_WRAPPER` for corporate launcher execution
- Mouse-click support for multi-select menus in fullscreen
- Fast mode now restores automatically after model switches
- Background agent replies saved when delivery fails
- Background daemon attach failures fixed after binary updates
- Context window reset issue resolved after CLI auto-updates
- HTTP/2 GOAWAY connection handling in supervised/background sessions
- Stream-json/JSON output truncation fixed for large responses
- Scientific notation environment variables now parse correctly
- Large markdown tables (200+ rows) display with pagination
- Edit tool now handles files modified after reading
- Read, Grep, and Glob tool improvements (empty files, regex patterns, null bytes)
- `apiKeyHelper` script errors shown within 3 attempts
- Bedrock streaming with gateway transformation errors clarified
- `/upgrade` login flow fixed for browser failures
- Stream-json input handling for Windows-style SDK hosts
- Headless stream-json sessions no longer hang on control requests
- Background task orphan notices consolidated into summaries
- Remote Control clients now see background agents and workflow progress
- Agent tool error messaging improved for unrecognized subagents
- `/usage` and `/mcp` caching issues addressed
- "Change directory" in SDK hosts fixed for idle sessions
- Workflow save dialog shows correct `CLAUDE_CONFIG_DIR`
- `/release-notes` no longer injects changelog into context
- Memory leak fixed in agent view image retention
- SDK sessions preserve agents after plugin refresh
- Multiple memory leaks resolved (MCP stderr, LSP documents, async hooks)
- File read memory issue fixed for extremely long lines
- Permission rule matcher compilation and caching optimized
- Input responsiveness improved during task list updates
- Tool-call CPU overhead reduced through tool-pool caching
- File edit read cache bounded to 16 MB
- Session transcript and checkpoint sizes reduced significantly
- Background agent and fork session memory usage improved
- Completed background agents remain in `/tasks` until cleanup
- Stopped background agents show transcript immediately
- Background daemon worker version compatibility improved
- Agent view Ctrl+X handling enhanced for worktrees
- Catastrophic removal prompts now work with `$(...)` and backticks
- `/install-github-app` and `/mcp` blocked in background sessions
- Empty MCP server URLs display as "not configured"
- `/usage` shows last-known bars when rate-limited
- Bedrock AWS SSO profile authentication fixed
```

### System-Prompts Changelog v2.1.208

```
_+2,947 tokens_

- Data: Data visualization reference palette; Data: Plan artifact HTML template;
  Skill: Artifact dashboard; Skill: Artifact data table; Skill: Artifact explainer;
  Skill: Artifact report; and Skill: Plan Artifact - Make artifact themes follow
  both the OS color scheme and the viewer's explicit light/dark toggle, keep
  applicable print output light, preserve the plan template's theme shim, and
  require restyling palette values consistently across every theme and print scope.

- Skill: Auto mode setup - Moves repository visibility, ruleset, branch-protection,
  shell-command-word, and nearby-repository discovery into deterministic pre-gathering;
  treats gathered names as untrusted data; forbids agents from reading raw shell
  history or repeating filesystem and GitHub scans; and scopes optional recon to
  the user's project and source selections.

- Tool Description: Artifact - Documents native Mermaid rendering for Markdown
  `mermaid` fences and HTML `<pre class="mermaid">` blocks without external libraries.

- Tool Description: Background monitor (streaming events) - When background tasks
  are disabled, directs one-shot readiness and completion waits to foreground Bash
  loops instead of unavailable background execution.
```

---

## Recommendation

This audit covers a **single minor release** with no plugin-system breaking changes. Stage 2 verified all classifications and demoted the 4 "May Update" items to "No Action" (plugin-dev does not document Artifact functionality).

1. **No documentation updates required** - v2.1.208 is a maintenance/bugfix release
2. **Update compatibility doc** to record the audit: `CC 2.1.208 audited, no plugin-dev changes needed`

---

## Next Steps

1. ~~Stage 2 (update-manifest-verifier) should confirm no false negatives~~ **DONE**
2. Update `docs/claude-code-compatibility.md` audit log
3. No Stage 3/4 work needed - no documentation changes required

---

## Triangulation Notes

- Two-source triangulation used: CC changelog + system-prompts changelog
- claude-code-guide agent dispatch skipped: Single version with minimal plugin-system changes; triangulation value is low for this small delta
- Both sources confirm v2.1.208 is primarily bug fixes and accessibility improvements
- System-prompts token delta: +2,947 tokens (relatively small, indicating minor changes)
- No new hook events, no manifest schema changes, no skill format changes identified

---

## Comparison to Previous Audit

**Previous audit (2.1.207):**
- 2 Must Update items (shell-injection security fix, plugin settings scope change [BREAKING])
- 1 May Update item (structured tool output schema)
- Impact: Contained breaking change for pluginConfigs project-settings behavior

**This audit (2.1.208):**
- 0 Must Update items (confirmed by Stage 2)
- 0 May Update items (4 demoted to No Action by Stage 2)
- Impact: No plugin-system changes requiring documentation updates

**Assessment:** v2.1.208 is a maintenance release with no impact on plugin development documentation.

---

## Stage 2: Verification Results
### Verified: 2026-07-14

#### Must Update Verification

Stage 1 identified zero Must Update items. After independent verification against:
- CC changelog (WebFetch of raw GitHub CHANGELOG.md)
- System-prompts changelog (local `claude-code-system-prompts/CHANGELOG.md`)

**Conclusion:** Confirmed. No Must Update items required.

#### Missed Items (promoted from No Action)

No items promoted. All No Action classifications verified correct:

- **"SDK sessions preserve agents after plugin refresh"** - SDK host behavior improvement, not plugin authoring guidance. Correct as No Action.
- **"async hooks memory leak fix"** - Bug fix, no documentation change needed. Correct as No Action.
- **"Agent tool error messaging improved"** - UX improvement to error messages, not API/behavior change. Correct as No Action.
- **"/mcp blocked in background sessions"** - Security hardening for user-facing command, not plugin authoring. Correct as No Action.
- **"Permission rule matcher optimization"** - Performance improvement, no behavior change. Correct as No Action.

#### May Update Resolution

- ↓ **Artifact tool: Native Mermaid rendering** — demoted to No Action: plugin-dev does not document the Artifact tool; Mermaid support is not relevant to plugin authoring
- ↓ **Auto mode setup: Deterministic pre-gathering changes** — demoted to No Action: internal CC behavior for auto-mode setup, not plugin authoring
- ↓ **Artifact themes: OS color scheme support** — demoted to No Action: Artifact-related, plugin-dev does not cover Artifact functionality
- ↓ **Background monitor: Foreground fallback guidance** — demoted to No Action: system prompt guidance for built-in tool, not plugin authoring

#### Summary

- Must Update: 0 items (0 confirmed, 0 rejected, 0 added)
- May Update: 0 items remaining (4 demoted to No Action)
- Confidence: **HIGH** — v2.1.208 is a maintenance/bugfix release with no plugin-system changes requiring documentation updates

#### Verification Method

1. Independently fetched CC changelog via WebFetch (not relying on Stage 1's cache)
2. Read system-prompts CHANGELOG.md lines 1-200 (covers v2.1.208 and v2.1.207)
3. Scanned for plugin-relevant keywords: hook, plugin, agent, skill, command, MCP, mcp, LSP, lsp, tool, permission, subagent, frontmatter, manifest, plugin.json, PreToolUse, PostToolUse, SessionStart, Stop
4. Verified topic mappings by reading reference docs at `plugins/plugin-dev/skills/plugin-dev/references/<topic>/overview.md`
5. Confirmed Artifact tool is not documented in plugin-dev (grep for "Artifact" returned no matches in skill content)
6. Cross-referenced CC 2.1.208 raw changelog entries (lines 102-147 of manifest) against system-prompts changes
