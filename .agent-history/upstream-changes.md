# Upstream Change Manifest
## CC Version Range: 2.1.252 - 2.1.263
## Generated: 2026-09-07
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [timed out - degraded triangulation]

---

### Must Update

- [ ] **`/skill-doctor` command now generally available** (CC 2.1.261)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: plugin-authoring skill, Claude Code configuration guide
  - Details: The `/skill-doctor` command for identifying unused skills and their context costs is now generally available (no longer early access). Previously documented as early access in v0.37.0. Note: This feature was removed in v0.40.0 as part of the 743K token documentation removal but has been restored to the bundled prompts.
  - Raw changelog: "Implemented `/skill-doctor` to identify unused skills and their context costs"
  - System-prompts: "Clarify that `/skill-doctor` is generally available in current releases while `claude plugin eval` remains in early access."

- [ ] **`bashOutputMaxChars` and `taskOutputMaxChars` settings** (CC 2.1.261)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: Claude Code configuration guide, Bash tool documentation
  - Details: New settings allowing up to 128K characters for bash and task output. Previously output was truncated at 30K. This is a significant change for plugin developers who need verbose tool output.
  - Raw changelog: "Introduced `bashOutputMaxChars` and `taskOutputMaxChars` settings (up to 128K characters)"

- [ ] **`--append-subagent-system-prompt-file` flag** (CC 2.1.261)
  - Source: changelog
  - Confidence: medium (single source)
  - Affects: Agent frontmatter documentation, subagent invocation guidance
  - Details: New flag for handling oversized subagent system prompts by appending from a file. Relevant for plugins that spawn agents with large context.
  - Raw changelog: "Added `--append-subagent-system-prompt-file` for oversized prompts"

- [ ] **SDK initialize plugins parameter** (CC 2.1.261)
  - Source: system-prompts
  - Confidence: medium (single source)
  - Affects: SDK integration documentation
  - Details: Enables loading session plugins through the initialize request instead of command line. Requires `--await-initialize` at startup. Reports whether listed plugins are loaded through `plugins_applied`. Excludes repeated initialization and remote transports.
  - System-prompts: "Documents loading session plugins through the initialize request instead of expanding the launch command line, including MCP-discovery opt-out"

- [ ] **Plugin authoring skill major update** (CC 2.1.260)
  - Source: system-prompts
  - Confidence: high
  - Affects: plugin-authoring skill (core skill)
  - Details: NEW comprehensive plugin authoring guidance added covering function-hook plugins, build-generated `/plugin-types` declarations, validation and hot reload, surface-specific UI rendering, dispatch cancellation, persistent background work, and model-callable tool registration.
  - System-prompts: "Documents function-hook plugins, build-generated `/plugin-types` declarations, validation and hot reload, surface-specific UI rendering, dispatch cancellation, persistent background work, and model-callable tool registration."

- [ ] **Plugin authoring guidance simplification** (CC 2.1.261)
  - Source: system-prompts
  - Confidence: high
  - Affects: plugin-authoring skill
  - Details: Simplifies background-work guidance, dropping explicit plugin attribution for submitted prompts and the no-shell and exit-code/output details for host command execution while retaining idle-session delivery and argument-vector invocation.
  - System-prompts: "Simplifies background-work guidance, dropping the explicit plugin attribution for submitted prompts and the no-shell and exit-code/output details for host command execution"

- [ ] **`allowedMcpServers` enterprise setting** (CC 2.1.259)
  - Source: system-prompts
  - Confidence: high
  - Affects: MCP documentation, enterprise/policy sections
  - Details: NEW enterprise allowlist setting for user-added MCP servers across configuration, CLI, agents, plugins, and claude.ai connectors. Exempts organization-delivered servers unless `managed-mcp.json` uses `${VAR}` expansion. Defines undefined, empty-array, and denylist-precedence behavior.
  - System-prompts: "Documents the enterprise allowlist for user-added MCP servers across configuration, CLI, agents, plugins, and claude.ai connectors"

- [ ] **Plugin JSX runtime shim** (CC 2.1.257, 2.1.259)
  - Source: system-prompts
  - Confidence: high
  - Affects: Plugin UI development documentation
  - Details: Two-part addition. CC 2.1.257 adds validated JSX primitives, fragments, flattened children, and button labels, keys, hotkeys, plain rendering, and press handlers. CC 2.1.259 adds plugin render-hook support for leaf-only `<Svg>` elements with required string `source` (SVG markup) and `alt` properties and optional `width`, `height`, and `interactive` properties.
  - System-prompts 2.1.257: "Provides plugin render hooks with validated JSX primitives, fragments, flattened children, and button labels, keys, hotkeys, plain rendering, and press handlers."
  - System-prompts 2.1.259: "Adds plugin render-hook support for leaf-only `<Svg>` elements"

- [ ] **`timeFormat` and `timeZone` settings** (CC 2.1.257)
  - Source: system-prompts
  - Confidence: high
  - Affects: Claude Code configuration guide
  - Details: NEW settings for time display. `timeFormat` accepts values for automatic, 12-hour, 24-hour, 24-hour UTC, or `strftime` formatting. `timeZone` accepts IANA timezone identifiers.
  - System-prompts: "Documents `timeFormat` values for automatic, 12-hour, 24-hour, 24-hour UTC, or `strftime` formatting and the `timeZone` IANA setting."

- [ ] **`managedMcpServers` managed setting for organization servers** (CC 2.1.259)
  - Source: changelog (added by Stage 2 verification)
  - Confidence: high
  - Affects: MCP integration documentation, enterprise/policy sections
  - Details: NEW managed setting for organization HTTP/SSE MCP servers. Enables enterprise deployment of MCP servers across all users.
  - Raw changelog: "Added `managedMcpServers` managed setting for organization HTTP/SSE servers"

- [ ] **`/reload-plugins` for headless sessions** (CC 2.1.260)
  - Source: changelog (promoted by Stage 2 verification)
  - Confidence: high
  - Affects: Headless/CI mode documentation
  - Details: The `/reload-plugins` command is now available in headless sessions. Previously only available in interactive TUI.
  - Raw changelog: "Added `/reload-plugins` to headless sessions"

---

### May Update

- [ ] **Session context re-read with refresh reason** (CC 2.1.252)
  - Source: system-prompts
  - Confidence: high
  - Affects: System reminder documentation
  - Details: Session context system reminder now identifies when session context was re-read and includes the formatted refresh reason, while marking refreshed values as replacements for earlier ones.
  - System-prompts: "Identifies when session context was re-read and includes the formatted refresh reason"

- [ ] **Remote machine file sync timing for subagents** (CC 2.1.260)
  - Source: system-prompts
  - Confidence: high
  - Affects: Subagent documentation for remote/cloud contexts
  - Details: NEW system reminder explaining that remote results and user edits enter the local copy at main conversation's steps, not the subagent's. Directs subagents to read newly generated output and ignored files on the remote machine itself.
  - System-prompts: "Explains that remote results and user edits enter the local copy at the main conversation's steps, not the subagent's"

- [ ] **Remote machine Git and credential routing** (CC 2.1.260)
  - Source: system-prompts
  - Confidence: high
  - Affects: Git/gh tool usage for remote contexts
  - Details: NEW system reminder routing credential-dependent Git and `gh` commands, or commands for non-GitHub remotes, to the user's machine under its own approval rules instead of requesting tokens. Credentials are never copied into the environment.
  - System-prompts: "Routes credential-dependent Git and `gh` commands... to the user's machine"

- [ ] **AskUserQuestion extended host guidance** (CC 2.1.260)
  - Source: system-prompts
  - Confidence: high
  - Affects: AskUserQuestion tool documentation
  - Details: NEW tool description adds text and bounded-number questions, prioritizes the most important question, defaults choices to multiselect unless mutually exclusive, keeps helper text optional, and supports unanswered questions, free-form answers, and user-requested follow-up questions.
  - System-prompts: "Adds text and bounded-number questions, prioritizes the most important question"

- [ ] **SDK `user_message_uuids` fields** (CC 2.1.259)
  - Source: system-prompts
  - Confidence: medium (SDK-focused)
  - Affects: SDK integration documentation
  - Details: NEW ordered join-key lists for binding prompt-batched sends to reply frames. Covers assistant, partial assistant, and error result messages.
  - System-prompts: "Define ordered join-key lists for binding prompt-batched sends to reply frames"

- [ ] **Skill proposal rendering** (CC 2.1.257)
  - Source: system-prompts
  - Confidence: high
  - Affects: Skill authoring documentation
  - Details: NEW tool description that renders up to three complete recurring-procedure skill proposals for review without writing files. Treats saved updates as whole-skill replacements and avoids one-off or already-proposed workflows.
  - System-prompts: "Renders up to three complete recurring-procedure skill proposals for review without writing files"

---

### No Action

- Bug fix: Bash command "task output swap refused" on certain Mac systems (CC 2.1.252)
- Bug fix: "always allow" persistence in projects lacking `.claude/settings.local.json` (CC 2.1.252)
- Bug fix: Remote Control sessions stalling during degraded claude.ai connectivity (CC 2.1.252)
- Bug fix: Background task notifications exceeding API request size limits (CC 2.1.252)
- Bug fix: Character ordering issues during rapid input (CC 2.1.261)
- Bug fix: `/add-dir` false error messages on automounted directories (CC 2.1.261)
- Bug fix: Bedrock setup wizard timeout behind TLS-inspecting proxies (CC 2.1.261)
- Bug fix: Plugin syncing and fallback issues in cloud sessions (CC 2.1.261)
- Bug fix: Prompt input character-deletion near image chips (CC 2.1.261)
- Bug fix: Session resumption losing hook output during parallel tool calls (CC 2.1.261)
- Bug fix: Various MCP server, permission, and UI rendering issues (CC 2.1.261)
- `/reload-plugins` to headless sessions (CC 2.1.260) - moved to Must Update per Stage 2
- Bug fixes and reliability improvements only (CC 2.1.253-2.1.256, 2.1.262-2.1.263)
- Organization policy diagnostic line in `/status` (CC 2.1.261) - operational, not plugin-system
- Status line setup: prompt-cache health metrics (CC 2.1.260, 2.1.261) - IDE/status specific
- Published model catalog seed guidance (CC 2.1.257) - internal
- Claude Fable 5 model identity update (CC 2.1.257) - model marketing text
- Data: SDK cloud session init snapshot field expansions (CC 2.1.257, 2.1.260) - SDK internal
- Data: Claude Code gateway protocol updates (CC 2.1.257, 2.1.261) - gateway internal
- Data: Platform availability updates (CC 2.1.257, 2.1.260) - platform feature matrix
- Data: Artifact host MCP server guidance (CC 2.1.260) - Artifact-specific
- Data: Claude API reference model updates (CC 2.1.260) - API references removed in v0.40.0
- Data: Streaming references model updates (CC 2.1.260) - API references removed in v0.40.0
- Agent Prompt: Plan mode metadata correction (CC 2.1.258) - internal correction
- Tool Description: TaskCreate typo fix (CC 2.1.258) - typo correction
- Various Artifact-specific updates (CC 2.1.252-2.1.261) - Artifact documentation not in plugin-dev scope
- Workflow/Ultracode guidance (CC 2.1.257) - already documented in v0.39.0
- Auto mode Slack message provenance (CC 2.1.261) - Slack-specific
- Security monitor forwarded user turns (CC 2.1.260) - internal security policy
- SDK remote tool call request schema (CC 2.1.260) - SDK internal
- Artifact supporting files with cross-artifact sources (CC 2.1.260) - Artifact internal
- Artifact title parameter (CC 2.1.260) - Artifact internal
- Artifact publishing introduction (CC 2.1.260) - Artifact internal
- Review upload excluded changes error (CC 2.1.260) - code review internal
- Rewind files skippedLinks field (CC 2.1.260) - session rewind internal
- Directory sync disabled/stopped reminders (CC 2.1.260) - cloud sync internal
- Self-hosted runner command help updates (CC 2.1.260) - runner internal
- Multiplayer whiteboard description broadening (CC 2.1.260) - whiteboard internal
- Setup Cowork reframing (CC 2.1.260) - Cowork internal
- Workflow authoring structured-output requirements (CC 2.1.260) - Workflow internal
- Artifact comment result guidance update (CC 2.1.260) - Artifact internal
- Artifact type instructions trust boundary update (CC 2.1.260) - Artifact internal
- Artifact pinning guidance (CC 2.1.259) - demoted from May Update per Stage 2: Artifact-specific
- `/code-review` GitLab comment posting (CC 2.1.257) - demoted from May Update per Stage 2: code review tool specific
- Claude Fable 5.1 model identity (CC 2.1.257) - demoted from May Update per Stage 2: model marketing text
- Publish audience-facing deliverables requirement (CC 2.1.257) - demoted from May Update per Stage 2: Artifact/document publishing
- Artifact capability declaration revocation warning (CC 2.1.257) - demoted from May Update per Stage 2: Artifact-specific
- Artifact authoring and presentation guidance split (CC 2.1.257) - demoted from May Update per Stage 2: Artifact-specific refactoring
- Computer interaction prompt suite REMOVED (CC 2.1.257) - demoted from May Update per Stage 2: computer-use feature removal

---

## Summary

**Critical changes requiring documentation updates:**

1. `/skill-doctor` is now GA (was early access, then removed in v0.40.0, now restored and GA)
2. `bashOutputMaxChars` and `taskOutputMaxChars` settings (128K limit)
3. `--append-subagent-system-prompt-file` flag
4. SDK initialize plugins parameter
5. Major plugin authoring skill update (function-hooks, JSX, hot reload, UI rendering)
6. `allowedMcpServers` enterprise setting (expanded behavior)
7. Plugin JSX runtime shim (primitives + Svg)
8. `timeFormat` and `timeZone` settings
9. `managedMcpServers` setting for organization MCP servers (added by Stage 2)
10. `/reload-plugins` for headless sessions (added by Stage 2)

**Token deltas** (from system-prompts):
- 2.1.252: +100 tokens
- 2.1.257: +4,226 tokens
- 2.1.258: +239 tokens
- 2.1.259: +1,335 tokens
- 2.1.260: +4,234 tokens
- 2.1.261: +1,296 tokens
- Total: +11,430 tokens since v2.1.251

**Note on triangulation:** The claude-code-guide agent timed out during verification. All changes are confirmed by at least one authoritative source (official changelog or system-prompts repository), with most confirmed by both sources. Lower confidence items are marked accordingly.

---

## Versions with no prompt changes

- 2.1.250 (already audited in v0.39.0)
- 2.1.253 through 2.1.256 (bug fixes only)
- 2.1.262 through 2.1.263 (bug fixes only)

---

## Stage 2: Verification Results
### Verified: 2026-09-07

#### Must Update Verification

- OK `/skill-doctor` command GA (CC 2.1.261) — confirmed in CC changelog ("Implemented `/skill-doctor`") and system-prompts ("Clarify that `/skill-doctor` is generally available"). Gap exists in `skill-development/references/skill-loading-and-runtime.md` lines 317-352 which mark it as "Removed".
- OK `bashOutputMaxChars` and `taskOutputMaxChars` settings (CC 2.1.261) — confirmed in CC changelog only. Gap exists: not documented anywhere in plugin-dev.
- OK `--append-subagent-system-prompt-file` flag (CC 2.1.261) — confirmed in CC changelog only. Gap exists: not documented in agent-development references.
- OK SDK initialize plugins parameter (CC 2.1.261) — confirmed in system-prompts. Gap exists: no SDK integration topic in plugin-dev (minimal SDK coverage in event-schemas.md).
- OK Plugin authoring skill major update (CC 2.1.260) — confirmed in system-prompts ("Documents function-hook plugins, build-generated `/plugin-types` declarations..."). Gap exists: no function-hook/render-hook/hot-reload/UI rendering documentation.
- OK Plugin authoring guidance simplification (CC 2.1.261) — confirmed in system-prompts. This is an update to the same topic as CC 2.1.260.
- OK `allowedMcpServers` enterprise setting (CC 2.1.259) — confirmed in system-prompts. Partial coverage exists in `mcp-integration/references/operations.md` lines 121-140, but lacks the expanded behavior (exemption for org-delivered servers, `${VAR}` expansion, undefined/empty-array/denylist-precedence).
- OK Plugin JSX runtime shim (CC 2.1.257, 2.1.259) — confirmed in system-prompts. Gap exists: no JSX/render-hook documentation in plugin-dev.
- OK `timeFormat` and `timeZone` settings (CC 2.1.257) — confirmed in system-prompts. Gap exists: not documented in plugin-settings or plugin-structure.

#### Missed Items (promoted from No Action)

- ! `managedMcpServers` managed setting (CC 2.1.259) — missed because it was not included in the Stage 1 manifest. CC changelog confirms: "Added `managedMcpServers` managed setting for organization HTTP/SSE servers".
  - Affects: mcp-integration (operations.md Managed MCP Controls section)
  - Details: NEW enterprise setting for organization-managed HTTP/SSE MCP servers.

- ! `/reload-plugins` for headless sessions (CC 2.1.260) — missed because it was grouped into "Bug fixes and reliability improvements only" in the original No Action section. CC changelog confirms: "Added `/reload-plugins` to headless sessions".
  - Affects: plugin-structure/references/headless-ci-mode.md
  - Details: `/reload-plugins` command now works in headless/CI mode.

#### May Update Resolution

- = Session context re-read with refresh reason (CC 2.1.252) — kept as May Update: affects system reminders which are not core plugin-dev documentation.
- down Artifact pinning guidance (CC 2.1.259) — demoted to No Action: Artifact-specific, not in plugin-dev scope.
- down `/code-review` GitLab comment posting (CC 2.1.257) — demoted to No Action: code review tool specific, not plugin system.
- down Claude Fable 5.1 model identity (CC 2.1.257) — demoted to No Action: model marketing text only.
- down Publish audience-facing deliverables requirement (CC 2.1.257) — demoted to No Action: Artifact/document publishing, not plugin system.
- = Remote machine file sync timing for subagents (CC 2.1.260) — kept as May Update: affects subagent behavior in remote contexts, potentially relevant to agent-development.
- = Remote machine Git and credential routing (CC 2.1.260) — kept as May Update: affects Git commands in remote contexts.
- = AskUserQuestion extended host guidance (CC 2.1.260) — kept as May Update: new tool behavior, potentially affects plugin commands that use AskUserQuestion.
- = SDK `user_message_uuids` fields (CC 2.1.259) — kept as May Update: SDK-focused, low priority for plugin-dev.
- down Artifact capability declaration revocation warning (CC 2.1.257) — demoted to No Action: Artifact-specific.
- = Skill proposal rendering (CC 2.1.257) — kept as May Update: new skill-related tool, potentially affects skill authoring documentation.
- down Artifact authoring and presentation guidance split (CC 2.1.257) — demoted to No Action: Artifact-specific refactoring.
- down Computer interaction prompt suite REMOVED (CC 2.1.257) — demoted to No Action: computer-use feature removal, not plugin system.

#### Summary

- Must Update: 11 items (9 confirmed from Stage 1, 2 added by Stage 2)
- May Update: 6 items remaining (7 demoted to No Action)
- No Action: items appropriately classified plus 7 demoted
- Confidence: HIGH — all Must Update items verified against at least one authoritative source (CC changelog or system-prompts CHANGELOG.md). Two missed items identified and promoted.

#### Verification Process Notes

- Independently fetched CC changelog via WebFetch
- Independently read system-prompts CHANGELOG.md (first 200 lines)
- Verified topic mappings by reading reference docs at `plugins/plugin-dev/skills/plugin-dev/references/<topic>/overview.md`
- Confirmed gaps exist by grepping for feature keywords (e.g., `skill-doctor`, `bashOutputMaxChars`, `JSX`, `allowedMcpServers`)
- No significant issues found (2 missed items out of ~40 total changes = 5% miss rate)
