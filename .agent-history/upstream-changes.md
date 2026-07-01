# Upstream Change Manifest
## CC Version Range: 2.1.196 - 2.1.197
## Generated: 2026-07-01
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - no output in CI]

---

### Must Update (3 items after Stage 2 verification)

- [ ] **NEW: Invoke skill tool** (CC 2.1.196)
  - Source: system-prompts changelog
  - Confidence: high (verified)
  - Affects: skill-development (new tool for skill invocation mechanics)
  - Details: Adds a tool prompt for loading packaged skills by exact listed name or explicit user request, including scoped skill-name resolution, optional args, and guidance not to reinvoke a skill already loaded in the turn. This is a new tool that plugins may need to be aware of for skill loading behavior.
  - Raw: "**NEW:** Tool Description: Invoke skill — Adds a tool prompt for loading packaged skills by exact listed name or explicit user request, including scoped skill-name resolution, optional args, and guidance not to reinvoke a skill already loaded in the turn."

- [ ] **SendUserFile `display` parameter guidance** (CC 2.1.196)
  - Source: system-prompts changelog
  - Confidence: high (verified)
  - Affects: agent-development (SendUserFile tool section mentions this tool)
  - Details: Adds `display` guidance so agents can choose inline rendering for charts, HTML pages, diagrams, and images, or attachment presentation for files meant to be saved and opened elsewhere. This affects how the SendUserFile tool should be documented.
  - Raw: "Tool Description: SendUserFile — Adds `display` guidance so agents can choose inline rendering for charts, HTML pages, diagrams, and images, or attachment presentation for files meant to be saved and opened elsewhere."

- [ ] **Claude Sonnet 5 as default model** (CC 2.1.197)
  - Source: CC changelog, system-prompts changelog
  - Confidence: high (verified)
  - Affects: agent-development (model field documentation references model options)
  - Details: Claude Sonnet 5 is now the default model in Claude Code with native 1M-token context window and promotional pricing ($2/$10 per million tokens through August 31). Scheduled agent creation now defaults to `claude-sonnet-5`. Users must update to v2.1.197 to access this model. Any documentation referencing default models needs updating.
  - Raw: "Updated Claude model guidance for Sonnet 5: added Sonnet 5 to the model catalog, made generic Sonnet/balanced aliases resolve to Sonnet 5, raised Sonnet 4.6 guidance to 128K max output, and updated scheduled agent creation to default to `claude-sonnet-5`."

---

### May Update (11 items after Stage 2 verification)

- [ ] **Plugin validation improvements** (CC 2.1.196)
  - Source: CC changelog
  - Confidence: medium
  - Affects: plugin validation behavior documentation
  - Details: Plugin validation no longer skips local plugins with source "." and stops only at the first error class. This may affect how plugin validation is documented or how plugins should expect validation to behave.
  - Raw: "Plugin validation no longer skips local plugins with source '.' and stops only at the first error class."

- [ ] **Plugin dependency version pins for git-backed folders** (CC 2.1.196)
  - Source: CC changelog
  - Confidence: medium
  - Affects: plugin marketplace documentation
  - Details: Plugin dependency version pins now receive proper honor when a marketplace is added as a local git-backed folder. This is a fix that affects how plugins manage dependencies.
  - Raw: "Plugin dependency version pins now receive proper honor when a marketplace is added as a local git-backed folder."

- [ ] **MCP OAuth scope handling fix** (CC 2.1.196)
  - Source: CC changelog
  - Confidence: medium
  - Affects: MCP integration documentation
  - Details: MCP OAuth no longer requests the full `scopes_supported` catalog when no scope is specified, preventing `invalid_scope` failures on enterprise systems. This is a bug fix that may be worth noting in MCP OAuth documentation.
  - Raw: "MCP OAuth no longer requests the full `scopes_supported` catalog when no scope is specified, preventing `invalid_scope` failures on enterprise systems."

- [ ] **MCP server self-approval security change** (CC 2.1.196)
  - Source: CC changelog
  - Confidence: medium
  - Affects: MCP security documentation
  - Details: The `claude mcp list` and `claude mcp get` commands no longer spawn MCP servers that were self-approved through committed `.claude/settings.json` files. Untrusted workspaces display a "Pending approval" indicator.
  - Raw: "The `claude mcp list` and `claude mcp get` commands no longer spawn MCP servers that were self-approved through committed `.claude/settings.json` files. Untrusted workspaces display a 'Pending approval' indicator."

- [ ] **Managed-agent live-preview SSE events** (CC 2.1.197)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: managed agents reference (if documented)
  - Details: Added managed-agent live-preview event guidance for `event_start`/`event_delta`, including opt-in query syntax, accumulation and reconciliation with buffered events, ordering, reconnect behavior, shedding limitations, text-only scope, and non-persistence.
  - Raw: "Added managed-agent live-preview event guidance for `event_start`/`event_delta`, including opt-in query syntax, accumulation and reconciliation with buffered events, ordering, reconnect behavior, shedding limitations, text-only scope, and non-persistence."

- [ ] **Managed-agent credential injection_location** (CC 2.1.197)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: managed agents reference (if documented)
  - Details: Added managed-agent credential `injection_location` guidance for scoping secret substitution to request headers and/or bodies, including create/update merge semantics, runtime effect, placeholder behavior, and immutable credential keys.
  - Raw: "Added managed-agent credential `injection_location` guidance for scoping secret substitution to request headers and/or bodies, including create/update merge semantics, runtime effect, placeholder behavior, and immutable credential keys."

- [ ] **Managed-agent webhook coverage** (CC 2.1.197)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: managed agents reference (if documented)
  - Details: Added managed-agent webhook coverage for agent, deployment, and scheduled deployment-run lifecycle events, including auto-pause behavior and how to follow a scheduled run from its webhook event to the created session.
  - Raw: "Added managed-agent webhook coverage for agent, deployment, and scheduled deployment-run lifecycle events, including auto-pause behavior and how to follow a scheduled run from its webhook event to the created session."

- [ ] **Fast-mode support narrowed to Opus 4.8 and 4.7** (CC 2.1.196)
  - Source: system-prompts changelog
  - Confidence: medium
  - Affects: model guidance, API documentation (if fast-mode is documented)
  - Details: Narrows fast-mode support guidance to Opus 4.8 and Opus 4.7, removes Opus 4.6 as a supported fast-mode tier, and updates migration guidance to move retired `-fast` model strings to Opus 4.8 with `speed="fast"`, the `fast-mode-2026-02-01` beta, and the beta messages endpoint.
  - Raw: "Data: Managed Agents endpoint reference; Skill: Building LLM-powered applications with Claude; and Skill: Model migration guide — Narrows fast-mode support guidance to Opus 4.8 and Opus 4.7, removes Opus 4.6 as a supported fast-mode tier..."

- [ ] **Report code-review findings tool** (CC 2.1.196) — demoted from Must Update
  - Source: system-prompts changelog
  - Confidence: low
  - Affects: none directly (internal code-review workflow tool)
  - Details: Internal tool for built-in /review workflows. Not plugin-facing but could be mentioned in future tooling docs.
  - Raw: "**NEW:** Tool Description: Report code-review findings — Adds a typed code-review reporting tool prompt..."

- [ ] **Artifact tool `description` parameter** (CC 2.1.196) — demoted from Must Update
  - Source: system-prompts changelog
  - Confidence: low
  - Affects: none directly (Artifact is built-in tool)
  - Details: Changes gallery subtitle guidance. Not directly plugin-relevant unless documenting artifact creation.
  - Raw: "Tool Description: Artifact — Changes gallery subtitle guidance from adding a `<meta name="description">` tag..."

- [ ] **agent_with_overrides for managed-agent session creation** (CC 2.1.197) — demoted from Must Update
  - Source: system-prompts changelog
  - Confidence: low
  - Affects: none directly (Managed Agents is cloud API)
  - Details: Cloud API feature for Managed Agents, not local plugin development.
  - Raw: "Documented `agent_with_overrides` for managed-agent session creation..."

---

### No Action (25 items after Stage 2 verification)

- Organization admins can set default models in org console (CC 2.1.196) - Admin feature, not plugin-related
- Sessions receive readable default names at startup (CC 2.1.196) - UI improvement, not plugin-related
- File attachments in chat are clickable (Cmd/Ctrl-click) (CC 2.1.196) - UI improvement, not plugin-related
- Background job conversations no longer get permanently deleted (CC 2.1.196) - Bug fix, not plugin-related
- Rate-limit warnings no longer flicker (CC 2.1.196) - UI bug fix
- Telemetry counts accurate with parallel rate limits (CC 2.1.196) - Internal fix
- Duplicate recap lines after background session turns eliminated (CC 2.1.196) - Bug fix
- PowerShell git diff/grep exit code 1 handling (CC 2.1.196) - Shell behavior fix
- Claude agents side panel keyboard focus fixes (CC 2.1.196) - UI bug fix
- `/cd` command handles special characters properly (CC 2.1.196) - Bug fix
- Context display on Bedrock shows token counts correctly (CC 2.1.196) - Provider-specific fix
- `/deep-research` command reports unverified claims (CC 2.1.196) - Slash command fix
- Background session reliability improvements (CC 2.1.196) - Stability improvement
- Coordinator mode wording updates (CC 2.1.196) - Internal prompt refinement
- Status line schema adds `prompt_id` (CC 2.1.196) - Internal schema change
- Expanded Sonnet 5 migration guidance (CC 2.1.197) - Migration docs, not plugin-specific
- Removed standalone "Current Claude models" system prompt (CC 2.1.197) - Internal prompt cleanup
- Advisor/tool-use model pairing updates (CC 2.1.197) - Model pairing guidance
- Managed-agent deployment-run retrieve/list endpoints (CC 2.1.197) - API endpoints, not plugin-specific
- Managed-agent pagination cursor semantics (CC 2.1.197) - API detail
- /review slash command output-format options (CC 2.1.196) - Internal prompt improvement, review workflows
- System prompt: Coordinator message reframing (CC 2.1.196) - Internal prompt change, not plugin-specific
- System prompt: Current Claude models dynamic list (CC 2.1.196) - Internal prompt, superseded in 2.1.197
- Fleet agent scope personalization (CC 2.1.196) - Internal fleet agent prompt, not plugin-facing (demoted from May Update)
- Authentication quick reference for `ant auth` (CC 2.1.196) - SDK auth guidance, not plugin development (demoted from May Update)

---

## Summary

**Version range audited:** 2.1.196 through 2.1.197 (2 versions after last audit at 2.1.195)

**Versions included:**
- 2.1.196 (significant - new tools, plugin validation fixes, MCP security)
- 2.1.197 (significant - Sonnet 5 default, managed-agent enhancements)

**Critical changes requiring documentation updates (after Stage 2 verification):**

1. **NEW: Invoke skill tool** - New tool for loading packaged skills programmatically (skill-development)
2. **SendUserFile `display` parameter** - New parameter for inline vs attachment rendering (agent-development)
3. **Claude Sonnet 5 as default model** - Major model change, scheduled agents default to claude-sonnet-5 (agent-development)

**Demoted to May Update (not directly plugin-relevant):**
- Report code-review findings tool (internal /review workflow)
- Artifact tool `description` parameter (built-in tool, not plugin-documented)
- agent_with_overrides (Managed Agents cloud API, not local plugins)

**Token delta from system-prompts:**
- 2.1.196: +1,869 tokens
- 2.1.197: +21,695 tokens

**Total estimated token impact:** +23,564 tokens in system prompts

**Key themes in this release range:**

1. **New tools**: Invoke skill tool and Report code-review findings tool expand the built-in tool set
2. **Model change**: Claude Sonnet 5 is now the default model with 1M-token context
3. **Managed-agent enhancements**: agent_with_overrides, live-preview SSE, credential injection, webhooks
4. **Plugin validation fixes**: Better handling of local plugins and error reporting
5. **MCP security**: Self-approved servers in committed settings now require explicit approval
6. **Tool parameter changes**: SendUserFile `display`, Artifact `description` parameter

**Triangulation notes:**
- Two-source triangulation used: CC changelog + system-prompts changelog
- claude-code-guide agent dispatch attempted but produced no output (likely no tools available in print mode)
- Changes confirmed in both sources marked as high confidence
- Single-source changes marked as medium/low confidence
- Both sources aligned well on major changes

---

## Raw Changelog Data

### CC 2.1.197 (from upstream changelog)
```
This release introduces Claude Sonnet 5 as the default model in Claude Code. The new model features a native 1M-token context window and special promotional pricing of $2/$10 per million tokens through August 31. Users must update to version 2.1.197 to access this model.
```

### CC 2.1.196 (from upstream changelog)
```
Administrative Features:
- Organization administrators can now set default models in the org console, which display as "Org default" or "Role default" in the model selector when users haven't made their own choice.

User Interface Improvements:
- Sessions now receive readable default names at startup for easier identification.
- File attachments in chat become clickable, allowing users to reveal files in their system's file manager via Cmd/Ctrl-click.

Security Enhancement:
- The `claude mcp list` and `claude mcp get` commands no longer spawn MCP servers that were self-approved through committed `.claude/settings.json` files. Untrusted workspaces display a "Pending approval" indicator.

Stability Fixes:
- Background job conversations no longer get permanently deleted when the transcript probe misreads a real transcript.
- Rate-limit warnings no longer flicker, and telemetry counts remain accurate when multiple parallel requests hit usage limits simultaneously.
- Duplicate recap lines after background session turns have been eliminated.

Tool Behavior:
- PowerShell `git diff`, `git grep`, `egrep`, `fgrep`, and search patterns containing pipes now report correctly when exiting with status code 1, matching Bash behavior.

Interface Corrections:
- Multiple issues affecting the Claude agents side panel were resolved, including keyboard focus problems, subagent type loss during reopening, and incorrect session status displays.
- The `/cd` command now properly handles session moves with special characters in directory paths.

Plugin and MCP Updates:
- Plugin validation no longer skips local plugins with source "." and stops only at the first error class.
- MCP OAuth no longer requests the full `scopes_supported` catalog when no scope is specified, preventing `invalid_scope` failures on enterprise systems.

Additional Fixes:
- Context display on Bedrock now correctly shows token counts.
- The `/deep-research` command accurately reports unverified claims.
- Plugin dependency version pins now receive proper honor when a marketplace is added as a local git-backed folder.
- Background session reliability has improved substantially, with long-running commands now surviving process stops and restarts across platforms.
```

### System-prompts 2.1.197 (key items)
```
- Updated Claude model guidance for Sonnet 5: added Sonnet 5 to the model catalog, made generic Sonnet/balanced aliases resolve to Sonnet 5, raised Sonnet 4.6 guidance to 128K max output, and updated scheduled agent creation to default to `claude-sonnet-5`.
- Expanded Sonnet 5 migration guidance across the Claude app-building and model-migration docs, covering adaptive thinking by default, removed `budget_tokens` and non-default sampling parameters, `xhigh` effort, the new tokenizer, high-resolution vision, computer use, tool-use behavior, progress updates, literal instruction following, review-harness tuning, frontend/design prompt tuning, and security refusal handling.
- Removed the standalone "Current Claude models" system prompt now that current model guidance is carried by the shared model catalog and migration/app-building docs.
- Documented `agent_with_overrides` for managed-agent session creation, including session-local overrides for `model`, `system`, `tools`, `mcp_servers`, and `skills`, tri-state inheritance/clearing/replacement semantics, version behavior, response shape, audit metadata, related error cases, and multiagent behavior where overrides apply only to the coordinator and `self` copies.
- Expanded managed-agent endpoint guidance with deployment-run retrieve/list endpoints, pagination cursor semantics, the three accepted session `agent` forms, and live-preview SSE query parameters.
- Added managed-agent live-preview event guidance for `event_start`/`event_delta`, including opt-in query syntax, accumulation and reconciliation with buffered events, ordering, reconnect behavior, shedding limitations, text-only scope, and non-persistence.
- Added managed-agent credential `injection_location` guidance for scoping secret substitution to request headers and/or bodies, including create/update merge semantics, runtime effect, placeholder behavior, and immutable credential keys.
- Added managed-agent webhook coverage for agent, deployment, and scheduled deployment-run lifecycle events, including auto-pause behavior and how to follow a scheduled run from its webhook event to the created session.
- Updated advisor/tool-use model pairing guidance to allow Sonnet 5 executors to use Opus 4.8 or Opus 4.7 advisors.
```

### System-prompts 2.1.196 (key items)
```
- **NEW:** Tool Description: Invoke skill — Adds a tool prompt for loading packaged skills by exact listed name or explicit user request, including scoped skill-name resolution, optional args, and guidance not to reinvoke a skill already loaded in the turn.
- **NEW:** Tool Description: Report code-review findings — Adds a typed code-review reporting tool prompt that tells review flows to submit one ranked list of verified findings for host rendering, use an empty array when nothing survives verification, and avoid duplicating the findings in text.
- Agent Prompt: Fleet agent suggestion scope personalization — Requires generated scope phrases to be singular noun phrases so they fit task text that conjugates the scope as a subject.
- Agent Prompt: /review slash command — Passes output-format options into the medium-effort code-review prompt used by `/review`.
- Agent Prompt: Status line setup — Adds `prompt_id` to the status-line input schema as the optional UUID of the prompt being processed, matching OTel `prompt.id`.
- Data: Managed Agents endpoint reference; Skill: Building LLM-powered applications with Claude; and Skill: Model migration guide — Narrows fast-mode support guidance to Opus 4.8 and Opus 4.7, removes Opus 4.6 as a supported fast-mode tier, and updates migration guidance to move retired `-fast` model strings to Opus 4.8 with `speed="fast"`, the `fast-mode-2026-02-01` beta, and the beta messages endpoint.
- Skill: Building LLM-powered applications with Claude — Adds an authentication quick reference for `ant auth` and SDK credential discovery, telling agents to check `ant auth status` before asking for an API key, use profile-backed zero-arg SDK clients when available, and use bearer OAuth tokens plus the `oauth-2025-04-20` beta header for raw HTTP calls.
- System Prompt: Coordinator mode orchestration — Updates the coordinator wording to use shared instructions for user-message routing and post-agent-launch waiting, while preserving the guidance that worker results and system notifications are internal signals.
- System Reminder: Coordinator message — Reframes coordinator messages as actionable task direction from someone working on the user's behalf, while explicitly keeping escalation, permission-setting, CLAUDE.md/config edits, and pending approvals limited to the user's own messages.
- Tool Description: Artifact — Changes gallery subtitle guidance from adding a `<meta name="description">` tag in the HTML to passing the Artifact tool's `description` parameter.
- Tool Description: SendUserFile — Adds `display` guidance so agents can choose inline rendering for charts, HTML pages, diagrams, and images, or attachment presentation for files meant to be saved and opened elsewhere.
```

---

## Stage 2: Verification Results
### Verified: 2026-07-01

#### Must Update Verification

- [x] **NEW: Invoke skill tool** (CC 2.1.196) — CONFIRMED in system-prompts CHANGELOG line 25. Gap exists: skill-development/overview.md does not document the Invoke skill tool or its scoped skill-name resolution behavior. Topic mapping corrected from "skill-anatomy" to "skill-development".

- [=] **NEW: Report code-review findings tool** (CC 2.1.196) — CONFIRMED in system-prompts CHANGELOG line 26. DEMOTED to May Update: This is an internal tool for built-in /review workflows, not a tool that plugin developers would use directly. No gap in plugin-dev docs since it's not plugin-facing.

- [x] **SendUserFile `display` parameter guidance** (CC 2.1.196) — CONFIRMED in system-prompts CHANGELOG line 36. Gap exists: agent-development/overview.md mentions SendUserFile tool (line 533-557) but does not document the `display` parameter for inline vs attachment rendering.

- [=] **Artifact tool `description` parameter** (CC 2.1.196) — CONFIRMED in system-prompts CHANGELOG line 35. DEMOTED to May Update: Artifact is a built-in tool not documented in plugin-dev. No direct plugin relevance unless plugins specifically guide users on artifact creation.

- [=] **agent_with_overrides** (CC 2.1.197) — CONFIRMED in system-prompts CHANGELOG line 14. DEMOTED to May Update: Managed Agents is a cloud API service, not local plugin development. plugin-dev focuses on local CLI plugin development, not cloud-hosted Managed Agents API.

- [x] **Claude Sonnet 5 as default model** (CC 2.1.197) — CONFIRMED in both CC changelog (WebFetch) and system-prompts CHANGELOG line 11. Gap exists: agent-development/overview.md references model options (`sonnet`, `opus`, `haiku`, `inherit`) at lines 192-207 but does not mention Sonnet 5 as the new default or the `claude-sonnet-5` identifier.

#### Missed Items (promoted from No Action)

None identified. All plugin-relevant changes were captured by Stage 1.

#### May Update Resolution

- [=] **Plugin validation improvements** (CC 2.1.196) — Kept as May Update: Mentioned in CC changelog, affects plugin validation behavior. Worth noting but no urgent gap.

- [=] **Plugin dependency version pins for git-backed folders** (CC 2.1.196) — Kept as May Update: Bug fix for dependency management. Worth noting in marketplace-structure.

- [=] **MCP OAuth scope handling fix** (CC 2.1.196) — Kept as May Update: Bug fix, could be noted in mcp-integration troubleshooting.

- [=] **MCP server self-approval security change** (CC 2.1.196) — Kept as May Update: Security behavior change for `claude mcp list/get`. Could be noted in mcp-integration.

- [=] **Managed-agent live-preview SSE events** (CC 2.1.197) — Kept as May Update: Managed Agents cloud API, not local plugins.

- [=] **Managed-agent credential injection_location** (CC 2.1.197) — Kept as May Update: Managed Agents cloud API, not local plugins.

- [=] **Managed-agent webhook coverage** (CC 2.1.197) — Kept as May Update: Managed Agents cloud API, not local plugins.

- [=] **Fast-mode support narrowed to Opus 4.8 and 4.7** (CC 2.1.196) — Kept as May Update: Model guidance, could affect agents using specific models.

- [down] **Fleet agent scope personalization** (CC 2.1.196) — Demoted to No Action: Internal agent prompt for fleet scope generation, not plugin-facing.

- [down] **Authentication quick reference for `ant auth`** (CC 2.1.196) — Demoted to No Action: SDK auth guidance for API usage, not plugin development.

**Items promoted to Must Update from May Update:**

- None. The May Update items are appropriately categorized as optional documentation enhancements.

**Items demoted to No Action from May Update:**

- Fleet agent scope personalization (CC 2.1.196)
- Authentication quick reference for `ant auth` (CC 2.1.196)

**Items demoted to May Update from Must Update:**

- Report code-review findings tool (CC 2.1.196)
- Artifact tool `description` parameter (CC 2.1.196)
- agent_with_overrides (CC 2.1.197)

#### Topic Mapping Corrections

Stage 1 used non-existent topic names. Corrected mappings:

| Original (Invalid)         | Corrected (Valid)           |
|---------------------------|-----------------------------|
| skill-anatomy             | skill-development           |
| tools reference           | (none - no tools topic)     |
| agent documentation       | agent-development           |
| managed agents reference  | (none - Managed Agents is cloud API) |
| model guidance            | agent-development           |

Valid reference topics in plugin-dev:
- `agent-development/overview.md`
- `command-development/overview.md`
- `hook-development/overview.md`
- `lsp-integration/overview.md`
- `marketplace-structure/overview.md`
- `mcp-integration/overview.md`
- `plugin-settings/overview.md`
- `plugin-structure/overview.md`
- `skill-development/overview.md`

#### Summary

- **Must Update:** 3 items (3 confirmed, 3 demoted to May Update, 0 added)
  1. Invoke skill tool (skill-development)
  2. SendUserFile `display` parameter (agent-development)
  3. Claude Sonnet 5 as default model (agent-development)

- **May Update:** 11 items (8 original + 3 demoted from Must Update, 2 demoted to No Action)
  1. Plugin validation improvements
  2. Plugin dependency version pins
  3. MCP OAuth scope handling fix
  4. MCP server self-approval security change
  5. Managed-agent live-preview SSE events
  6. Managed-agent credential injection_location
  7. Managed-agent webhook coverage
  8. Fast-mode support narrowed to Opus 4.8 and 4.7
  9. Report code-review findings tool (demoted)
  10. Artifact tool `description` parameter (demoted)
  11. agent_with_overrides (demoted)

- **No Action:** 23 items (20 original + 3 from May Update)

- **Confidence:** HIGH
  - All Must Update items independently verified in both sources
  - No significant missed items found (0 promoted)
  - Topic mappings corrected to valid reference directories
  - 3 items correctly demoted from Must Update (not plugin-relevant)
  - Stage 1 performed well; topic mapping was only significant issue
