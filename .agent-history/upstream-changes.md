# Upstream Change Manifest
## CC Version Range: 2.1.127 - 2.1.132
## Generated: 2026-05-07
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - CI environment]

---

### Must Update

- [x] **--plugin-url flag for loading plugins from URLs** (CC 2.1.129) ✅ Applied to plugin-structure/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-loading skill, plugin-validator agent
  - Details: New `--plugin-url` flag allows loading plugin archives directly from URLs. This is a significant plugin system enhancement that enables remote plugin distribution. Plugin developers need to know about this capability for distributing plugins without requiring local installation.
  - Raw: "Added the `--plugin-url` flag for loading plugin archives from URLs"

- [x] **--plugin-dir now accepts .zip archives** (CC 2.1.128) ✅ Applied to plugin-structure/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-loading skill, plugin-validator agent
  - Details: The `--plugin-dir` flag now accepts `.zip` archives in addition to directories. This changes how plugins can be distributed and loaded, enabling zip-based plugin distribution.
  - Raw: "`--plugin-dir` now accepts `.zip` archives"

- [x] **Plugin manifest: themes and monitors under "experimental" key** (CC 2.1.129) ✅ Applied to plugin-structure/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: plugin-manifest skill, plugin.json reference
  - Details: The `themes` and `monitors` fields in plugin.json must now be placed under an `"experimental"` key. This is a breaking change for plugins using these features. Documentation must be updated to reflect this new manifest structure.
  - Raw: "Plugin manifests now expect `themes` and `monitors` under `\"experimental\"`"

- [x] **skillOverrides setting with off/user-invocable-only/name-only options** (CC 2.1.129) ✅ Applied to skill-development/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: skill-format skill, plugin configuration documentation
  - Details: New `skillOverrides` setting allows users to control how skills behave: `off` disables skills entirely, `user-invocable-only` restricts to user-invoked skills, `name-only` shows only skill names without full descriptions. Plugin developers should understand these modes for skill design.
  - Raw: "Added `skillOverrides` setting: `off`, `user-invocable-only`, `name-only`"

- [x] **MCP workspace reserved server name** (CC 2.1.128) ✅ Applied to mcp-integration/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: mcp-integration skill
  - Details: The name "workspace" is now reserved for MCP servers. Plugins or configurations using "workspace" as an MCP server name may conflict with this reservation.
  - Raw: "MCP `workspace` is now a reserved server name"

- [x] **CLAUDE_CODE_SESSION_ID environment variable** (CC 2.1.132) ✅ Applied to hook-development/overview.md
  - Source: CC changelog
  - Confidence: high
  - Affects: environment-variables reference, hook scripts
  - Details: New environment variable `CLAUDE_CODE_SESSION_ID` exposes the current session ID. Useful for hook scripts that need to track or identify sessions.
  - Raw: "Added CLAUDE_CODE_SESSION_ID env var"

- [x] **CLAUDE_CODE_LOOP_PERSISTENT environment variable guidance** (CC 2.1.129) ✅ Applied to agent-development/overview.md
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: environment-variables reference, autonomous agent guidance
  - Details: New system prompt guidance for `CLAUDE_CODE_LOOP_PERSISTENT` environment variable covering autonomous work loops, timer-invocation guidance, when to continue established work, maintain current PRs, broaden scope before stopping, and authorization for irreversible actions.
  - Raw: "NEW: System Prompt: Autonomous loop persistence guidance (CLAUDE_CODE_LOOP_PERSISTENT) - Adds timer-invocation guidance for autonomous work loops"

- [x] **Background job agent instructions (NEW built-in)** (CC 2.1.128) ✅ Applied to agent-development/overview.md
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: agent skill, subagent documentation
  - Details: New built-in background-agent instructions replacing the previous background-job behavior system prompt. Includes progress narration, tool-result restatement, noisy-investigation delegation, and explicit status signals (`result:`, `needs input:`, `failed:`).
  - Raw: "Agent Prompt: Background job agent instructions - Replaces the background-job behavior system prompt with built-in background-agent instructions"

- [x] **RemoteTrigger tool description (NEW)** (CC 2.1.128) ⏭️ Skipped - Claude.ai cloud API tool, not CLI plugin-relevant
  - Source: system-prompts changelog
  - Confidence: high
  - Affects: tools reference
  - Details: New tool description for RemoteTrigger - the claude.ai remote-trigger API tool for listing, reading, creating, updating, and running scheduled remote agent routines without exposing OAuth tokens.
  - Raw: "Tool Description: RemoteTrigger prompt - Describes the claude.ai remote-trigger API tool"

---

### May Update

- [ ] **Edit tool line-number prefix format hardcoded** (CC 2.1.128)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: edit-tool reference (if any)
  - Details: Edit tool description now hardcodes the Read-output line-number prefix format as "line number + tab" in indentation-preservation guidance. Useful context for plugin developers writing tool guidance.
  - Raw: "Tool Description: Edit - Hardcodes the Read-output line-number prefix format as 'line number + tab'"

---

### No Action

- VS Code extension fix (CC 2.1.131) - IDE-specific, not plugin-relevant
- Mantle endpoint auth fix (CC 2.1.131) - Internal infrastructure
- Background agent state classifier expansion (CC 2.1.129) - Internal agent behavior
- Verification specialist prompt removal (CC 2.1.129) - Internal prompt management
- Session memory update instructions removal (CC 2.1.128) - Internal prompt management
- Session memory template removal (CC 2.1.128) - Internal prompt management
- Background job behavior prompt removal (CC 2.1.128) - Replaced by new built-in instructions
- Claude API SDK references updates (CC 2.1.128) - API documentation, not CLI plugins
- Model catalog deprecation updates (CC 2.1.128) - Model selection, not plugin system
- Proactive schedule offer gate (CC 2.1.132) - Scheduling behavior, not plugin system
- Onboarding guide workflow changes (CC 2.1.132) - Onboarding flow, not plugin system
- Security monitor CronCreate/CronDelete/CronList/RemoteTrigger allowances (CC 2.1.132) - Security monitor internals
- Status line input/output token clarification (CC 2.1.132) - UI detail, not plugin system
- CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN env var (CC 2.1.132) - Terminal rendering, not plugin-relevant [demoted from May Update]
- CLAUDE_CODE_FORCE_SYNC_OUTPUT env var (CC 2.1.129) - Terminal output mode, not plugin-relevant [demoted from May Update]
- CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE env var (CC 2.1.129) - Package manager, not plugin-relevant [demoted from May Update]
- SDK hosts persistent localSettings suggestion (CC 2.1.128) - SDK-specific, not CLI plugins [demoted from May Update]
- Bash allow rules fix for in-project paths (CC 2.1.129) - Bug fix, no doc change needed [demoted from May Update]
- Managed Agents skill limit 64->20 (CC 2.1.132) - Cloud API, not CLI plugins [demoted from May Update]
- Managed Agents multiagent/outcomes/webhooks (CC 2.1.132) - Cloud API, not CLI plugins [demoted from May Update]
- Agent thread notes final message (CC 2.1.128) - Internal agent guidance, not plugin-relevant [demoted from May Update]
- Previously invoked skills reminder (CC 2.1.119) - Already documented in skill-development [demoted from May Update]

---

## Summary

**Critical plugin system changes (Must Update):**
1. New `--plugin-url` flag for remote plugin loading
2. `--plugin-dir` now accepts `.zip` archives
3. Plugin manifest structure change: `themes`/`monitors` under `"experimental"`
4. New `skillOverrides` setting for skill behavior control
5. MCP `workspace` reserved server name
6. New `CLAUDE_CODE_SESSION_ID` environment variable
7. New `CLAUDE_CODE_LOOP_PERSISTENT` guidance
8. New background job agent built-in instructions
9. New RemoteTrigger tool

**Token delta from system-prompts:**
- 2.1.132: +6,720 tokens
- 2.1.131: +0 tokens
- 2.1.129: +1,335 tokens
- 2.1.128: +1,406 tokens
- Total for range: +9,461 tokens

**Notes:**
- claude-code-guide agent cross-reference was skipped (CI environment limitation)
- All "Must Update" items confirmed from at least one authoritative source
- Plugin manifest structure change (`themes`/`monitors` under `"experimental"`) is a potential breaking change for existing plugins using these features
- Version 2.1.127 and 2.1.130 do not appear in either changelog (likely internal releases with no public changes)

---

## Stage 2: Verification Results
### Verified: 2026-05-07

#### Must Update Verification
- [Y] **--plugin-url flag for loading plugins from URLs** (CC 2.1.129) — confirmed in CC changelog, gap exists in plugin-structure/overview.md (no mention of --plugin-url)
- [Y] **--plugin-dir now accepts .zip archives** (CC 2.1.128) — confirmed in CC changelog, gap exists in plugin-structure/overview.md (only mentions directories at line 663)
- [Y] **Plugin manifest: themes and monitors under "experimental" key** (CC 2.1.129) — confirmed in CC changelog, gap exists in plugin-structure/overview.md (no mention of experimental key for themes/monitors)
- [Y] **skillOverrides setting with off/user-invocable-only/name-only options** (CC 2.1.129) — confirmed in CC changelog, gap exists in skill-development/overview.md (no mention of skillOverrides setting)
- [Y] **MCP workspace reserved server name** (CC 2.1.128) — confirmed in CC changelog, gap exists in mcp-integration/overview.md (no mention of "workspace" being reserved)
- [Y] **CLAUDE_CODE_SESSION_ID environment variable** (CC 2.1.132) — confirmed in CC changelog, gap exists in hook-development/overview.md (not listed in Environment Variables section)
- [Y] **CLAUDE_CODE_LOOP_PERSISTENT environment variable guidance** (CC 2.1.129) — confirmed in system-prompts changelog, gap exists (not documented anywhere in plugin-dev)
- [Y] **Background job agent instructions (NEW built-in)** (CC 2.1.128) — confirmed in system-prompts changelog, partial gap: CC 2.1.117 behavior documented in agent-development/overview.md lines 651-659, but 2.1.128 replacement adds more specific guidance (result:/needs input:/failed: status signals)
- [Y] **RemoteTrigger tool description (NEW)** (CC 2.1.128) — confirmed in system-prompts changelog, gap exists (no RemoteTrigger tool documentation)

#### Missed Items (promoted from No Action)
None identified. The "No Action" items were correctly classified as not plugin-relevant.

#### May Update Resolution
- [v] **CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN environment variable** — demoted to No Action: terminal rendering configuration, not plugin-relevant
- [v] **CLAUDE_CODE_FORCE_SYNC_OUTPUT environment variable** — demoted to No Action: terminal output mode, not plugin-relevant
- [v] **CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE environment variable** — demoted to No Action: package manager behavior, not plugin-relevant
- [v] **SDK hosts receive persistent localSettings suggestion** — demoted to No Action: SDK-specific, not CLI plugin-relevant
- [v] **Bash allow rules fix for in-project paths** — demoted to No Action: bug fix, documented behavior unchanged
- [^] **Edit tool line-number prefix format hardcoded** — kept as May Update: useful for plugin developers writing Edit tool guidance, but not critical
- [v] **Managed Agents skill limit changed from 64 to 20** — demoted to No Action: Managed Agents is cloud API, not CLI plugins
- [v] **Managed Agents multiagent sessions, outcomes, webhooks (NEW)** — demoted to No Action: Managed Agents is cloud API, not CLI plugins
- [v] **Agent thread notes - return reports in final message** — demoted to No Action: internal agent behavior guidance, not plugin-relevant
- [v] **Previously invoked skills reminder** — demoted to No Action: already documented at skill-development/overview.md lines 371-379 (CC 2.1.119 section)

#### Summary
- Must Update: 9 items (9 confirmed, 0 rejected, 0 added)
- May Update: 1 item remaining (Edit tool line-number prefix format)
- No Action: 10 items demoted from May Update
- Confidence: HIGH — all Must Update items verified against primary sources, skill mappings correct

#### Notes
- The "Affects" mappings were validated by reading the target reference files
- No significant issues found (0% rejection rate, 0 missed items)
- Stage 1 analysis was accurate and comprehensive
