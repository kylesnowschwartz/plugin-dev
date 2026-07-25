# Upstream Change Manifest
## CC Version Range: 2.1.212 - 2.1.220
## Generated: 2026-07-25
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [Y]

---

### Must Update

- [ ] **DirectoryAdded hook event** (CC 2.1.219)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: hook-development (overview.md, event-schemas.md)
  - Details: New hook event (the 29th) that activates after registering new working directories mid-session via `/add-dir` or SDK `register_repo_root` requests. Includes input, refreshed-sandbox timing, and source-specific failure and output handling.
  - Raw changelog: "Added `DirectoryAdded` hook that activates after `/add-dir` or SDK `register_repo_root` control request registers a new working directory mid-session"

- [ ] **Skills with context:fork now run in background by default** (CC 2.1.219)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: skill-development (advanced-frontmatter.md)
  - Details: Skills with `context: fork` now default to background execution. Opt out per skill with `background: false` in frontmatter.
  - Raw changelog: "Skills with `context: fork` now run in the background by default; opt out per skill with `background: false`"

- [ ] **Skills and plugin frontmatter accept alternate boolean values** (CC 2.1.219)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: skill-development, plugin-structure (manifest-reference.md)
  - Details: Boolean fields in YAML frontmatter now accept `yes`/`no`/`on`/`off`/`1`/`0` (case-insensitive) alongside `true`/`false`.
  - Raw changelog: "Skills and plugin frontmatter now accept `yes`/`no`/`on`/`off`/`1`/`0` (case-insensitive) as boolean values alongside `true`/`false`"

- [ ] **Agent markdown files reject names containing colon** (CC 2.1.219)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: agent-development (overview.md)
  - Details: Agent identifiers cannot contain `:` -- reserved for plugin namespacing (`plugin:subdir:agent-name`).
  - Raw changelog: "Agent markdown files reject agent names containing `:`, reserved for plugin namespacing"

- [ ] **Agent frontmatter hooks require workspace trust** (CC 2.1.219)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: agent-development, hook-development
  - Details: Agent frontmatter hooks now require the agent file's own folder to have accepted workspace trust.
  - Raw changelog: "Agent frontmatter hooks now require the agent file's own folder to have accepted workspace trust"

- [ ] **Subagent nesting depth changed to 3 with env var** (CC 2.1.219)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: Default nesting depth is now 3 (was 1, docs incorrectly say 5 from CC 2.1.172). New `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` environment variable for customization.
  - Raw changelog: "Subagents can spawn nested subagents up to depth 3 by default (was 1); configure with `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`"

- [ ] **Invoke skill background behavior clarification** (CC 2.1.218)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (skill-loading-and-runtime.md)
  - Details: Background skills initially return only the agent name; results delivered later through task notifications. Should not be waited on or invoked again while pending.
  - Raw changelog (system-prompts): "Tool Description: Invoke skill background behavior clarification"

- [ ] **sandbox.filesystem.disabled setting** (CC 2.1.216)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: plugin-settings (overview.md)
  - Details: New setting to skip filesystem isolation while maintaining network control. Explains unrestricted host-filesystem access for sandboxed commands while retaining network confinement.
  - Raw changelog: "Added `sandbox.filesystem.disabled` setting to skip filesystem isolation while maintaining network control"

- [ ] **Subagent delegation restraint guidance** (CC 2.1.215)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (advanced-agent-fields.md)
  - Details: New guidance limits subagent use to genuinely independent, sizeable, or parallel work; keeps small tasks in parent agent; discourages redundant fan-out. Agent tool recommendations now conditional on subagent steering mode.
  - Raw changelog (system-prompts): "NEW: System Prompt: Subagent delegation restraint"

- [ ] **Removed automatic skill invocation for /verify and /code-review** (CC 2.1.215)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: skill-development (skill-loading-and-runtime.md)
  - Details: Users must explicitly invoke these commands now. Main-conversation Skill tool instructions for mandatory matching-skill invocation removed.
  - Raw changelog: "Removed automatic skill invocation for `/verify` and `/code-review` - users must explicitly invoke these commands"

- [ ] **Per-session subagent spawn cap** (CC 2.1.213)
  - Source: changelog
  - Confidence: medium
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: Per-session subagent spawn cap (default 200) halts delegation loops. Override with `CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION`.
  - Raw changelog: "Added per-session subagent spawn cap (default 200) to halt delegation loops"

- [ ] **MCP tool calls auto-background at 2 minutes** (CC 2.1.213)
  - Source: changelog
  - Confidence: medium
  - Affects: mcp-integration (operations.md)
  - Details: MCP tool calls over 2 minutes automatically background. Configure with `CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS`.
  - Raw changelog: "MCP tool calls running longer than 2 minutes auto-background; configure with `CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS`"

- [ ] **/fork restructured; /subtask introduced** (CC 2.1.212)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: command-development (built-in-commands.md), agent-development
  - Details: `/fork` now copies conversations into new background sessions. Previous subagent spawn behavior renamed to `/subtask`. Background agents can resume from `/resume` picker.
  - Raw changelog: "Restructured `/fork` functionality to copy conversations into new background sessions in agent view. Renamed previous subagent spawn behavior to `/subtask`"

- [ ] **Tool(param:value) permission syntax with wildcards** (CC 2.1.212)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: hook-development (advanced.md), agent-development (permission-modes-rules.md)
  - Details: Permission rules now support parameter matching like `Agent(model:opus)` or `Tool(param:*)` with wildcard support.
  - Raw changelog: "Changed `Tool(param:value)` permission syntax allows matching on input parameters with `*` wildcards"

- [ ] **Subagents inherit parent permission mode; Task tool mode deprecated** (CC 2.1.212)
  - Source: changelog (WebFetch)
  - Confidence: high
  - Affects: agent-development (advanced-agent-fields.md, permission-modes-rules.md)
  - Details: Subagents inherit parent session's permission mode by default. Task tool `mode` parameter deprecated.
  - Raw changelog: "Subagents inherit parent session's permission mode by default; Task tool `mode` parameter deprecated"

- [ ] **Persistent memory usage and writing guidance** (CC 2.1.212)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (advanced-agent-fields.md memory section)
  - Details: Cross-session file-memory rules for validating recalled knowledge, keeping memories applicable/durable/legible, and recording corrections.
  - Raw changelog (system-prompts): "NEW: System Prompt: Persistent memory usage and writing guidance"

---

### May Update

- [ ] **ISO modified timestamp in memory file frontmatter** (CC 2.1.214)
  - Source: changelog
  - Confidence: medium
  - Affects: plugin-settings (memory documentation)
  - Details: Added ISO `modified` timestamp to memory file frontmatter.

- [ ] **/resume picker in agent view** (CC 2.1.213)
  - Source: changelog
  - Confidence: medium
  - Affects: agent-development (background agent patterns)
  - Details: `/resume` picker in agent view for accessing past sessions including deleted ones as background jobs.

- [ ] **Import to Claude Code skill** (CC 2.1.213)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (patterns documentation)
  - Details: Built-in skill for reviewing foreign-agent configuration and translating to Claude Code equivalents; example of import-style skill pattern.

- [ ] **SuggestSkills proactive guidance** (CC 2.1.213)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (skill discovery)
  - Details: Proactive skill recommendations for repeatable workflows; affects how plugins surface skills.

- [ ] **Scheduled task automated firing reminder** (CC 2.1.213)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (scheduled agents)
  - Details: Scheduled turns treated as stored prompts without live user input; affects scheduled agent permissions.

- [ ] **Saving skills via file delivery guidance** (CC 2.1.216)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (skill authoring)
  - Details: On-disk account skills treated as read-only cache; skill changes delivered as `.skill` or `SKILL.md` files.

- [ ] **Session-wide WebSearch limit** (CC 2.1.213)
  - Source: changelog
  - Confidence: medium
  - Affects: agent-development (tool limits)
  - Details: Session-wide WebSearch limit (default 200, override via `CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION`).

---

### No Action

**Original No Action items:**
- Transcript write failure warnings (CC 2.1.217) - UI behavior, not plugin-relevant
- Memory leak fix for truncated MCP tool outputs (CC 2.1.217) - Bug fix
- Auto-update failures fix on Windows (CC 2.1.217) - Platform-specific bug fix
- Background session isolation with symlink canonicalization (CC 2.1.217) - Internal fix
- Auto-compact triggering fix for Claude Opus 4.8 on Bedrock (CC 2.1.217) - Provider-specific fix
- Quadratic message normalization slowdown fix (CC 2.1.216) - Performance fix
- Auto mode denial handling after OAuth expiration (CC 2.1.216) - Bug fix
- AskUserQuestion response continuation logic fix (CC 2.1.216) - Bug fix
- Permission check bypass fix for Windows PowerShell 5.1 (CC 2.1.214) - Security fix
- Bash permission checks for edge cases (CC 2.1.214) - Bug fix
- OpenTelemetry logging enhancements (CC 2.1.214) - Internal logging
- Plan mode auto-running file-modifying Bash fix (CC 2.1.213) - Bug fix
- Worktree creation symlink traversal fix (CC 2.1.213, 2.1.212) - Bug fix
- Shell mode execution with path autocomplete popup fix (CC 2.1.213) - Bug fix
- /ultrareview branch reference handling (CC 2.1.213) - Command fix
- Background session ghost subagent spawning fix (CC 2.1.212) - Bug fix
- Text output handling with mid-stream API errors (CC 2.1.219) - Bug fix
- MCP server status reporting with HTTP error details (CC 2.1.219) - Diagnostic improvement
- Model picker display inconsistencies fix (CC 2.1.219) - UI fix
- Copy-on-select functionality in GNU screen fix (CC 2.1.219) - Environment-specific fix
- Remote Control fast-mode status persistence fix (CC 2.1.219) - Feature fix
- Transcript jumping during streaming fix (CC 2.1.218) - UI fix
- Multi-line paste handling fix (CC 2.1.218) - Input handling fix
- /context token usage reporting after compaction fix (CC 2.1.218) - Display fix
- /ultrareview descriptive arguments (CC 2.1.218) - Command enhancement
- Windows path handling character corruption fix (CC 2.1.218) - Platform-specific fix
- Context tip selector and reception evaluator removed (CC 2.1.212) - Internal change
- Session search subagent removed (CC 2.1.212) - Internal change
- Doctor checkup suggestion trigger removed (CC 2.1.212) - Internal change
- No changes to system prompts (CC 2.1.220) - Empty release
- No changes to system prompts (CC 2.1.214) - Prompt changes not in system-prompts

**Demoted from Must Update (not plugin-system features):**
- Claude Opus 5 as default model (CC 2.1.219) - Model change, not plugin API
- sandbox.network.strictAllowlist setting (CC 2.1.219) - Sandbox config, low plugin relevance
- workflowSizeGuideline setting (CC 2.1.219) - Workflow runtime, not plugin API
- mcp_server_errors field in stream-json (CC 2.1.219) - SDK integration only
- /code-review executes as background subagent (CC 2.1.218) - Built-in command behavior
- EndConversation tool (CC 2.1.214) - Internal safety tool
- Periodic progress heartbeats for long tool calls (CC 2.1.214) - Runtime behavior
- claude auto-mode reset command (CC 2.1.212) - CLI command, not plugin API
- Artifact PR review skill (CC 2.1.213, 2.1.218) - Built-in skill, not plugin system
- Artifact whiteboard skill (CC 2.1.218) - Built-in skill, not plugin system

**Demoted from May Update (not plugin-relevant):**
- Docker daemon-redirect flag permission prompts (CC 2.1.216) - Runtime permission behavior
- Emoji shortcode autocomplete (CC 2.1.217) - UI feature
- Screen reader mode enhancements (CC 2.1.217, 2.1.218) - Accessibility UI
- /explain-usage slash command (CC 2.1.217) - Built-in command
- Correction restraint guidance (CC 2.1.217) - Behavioral guidance
- Delivering work at full scope guidance (CC 2.1.217, 2.1.218) - Behavioral guidance
- Action safety and truthful reporting (CC 2.1.216, 2.1.219) - Behavioral guidance
- Artifact supporting files guidance (CC 2.1.216) - Artifact publishing
- Workshop artifact / decision workshop skill (CC 2.1.216-2.1.219) - Built-in skill
- /code-review inline mode when Agent unavailable (CC 2.1.213) - Built-in command fallback
- /simplify inline mode when Agent unavailable (CC 2.1.213) - Built-in command fallback

---

## Notes

### Source Triangulation

- **Changelog (WebFetch)**: Primary source for feature announcements and version numbers
- **System-prompts CHANGELOG.md**: Most detailed source with NEW/REMOVED markers and token deltas; provides implementation details not in upstream changelog
- **claude-code-guide agent**: Confirmed partial documentation coverage; many runtime features are not reflected in system prompts (see verification results below)

### claude-code-guide Verification Results

The claude-code-guide agent verified the following coverage:
- **Documented**: sandbox.filesystem.disabled setting (CC 2.1.216), DirectoryAdded hook (CC 2.1.219), Claude Opus 5 model change (CC 2.1.219)
- **Partially documented**: Skill tool removal (CC 2.1.215), /code-review background refactor (CC 2.1.218)
- **Not documented in system prompts**: Many changelog items are runtime features that do not appear in system prompts (WebSearch limits, subagent caps, EndConversation tool, etc.)

### Confidence Levels

- **High**: Confirmed across multiple sources (changelog + system-prompts)
- **Medium**: Appears in only one source; may need manual verification
- **Low**: Conflicting information between sources (none in this audit)

### Version Summary (Post-Verification)

| Version | Must Update | May Update | No Action |
|---------|-------------|------------|-----------|
| 2.1.220 | 0 | 0 | 1 |
| 2.1.219 | 6 | 0 | 9 |
| 2.1.218 | 1 | 0 | 7 |
| 2.1.217 | 0 | 0 | 8 |
| 2.1.216 | 1 | 1 | 5 |
| 2.1.215 | 2 | 0 | 0 |
| 2.1.214 | 0 | 1 | 6 |
| 2.1.213 | 2 | 5 | 7 |
| 2.1.212 | 4 | 0 | 4 |

**Totals (post-verification)**: 16 Must Update, 7 May Update, 47 No Action

### Key Themes

1. **Subagent Management Overhaul**: Nesting depth increased to 3 (from 1), spawn caps added (200 per session), delegation restraint guidance introduced, /fork renamed to /subtask, CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH env var added
2. **New Hook Event**: DirectoryAdded is the 27th hook event - fires after `/add-dir` or SDK `register_repo_root`
3. **New Settings**: sandbox.network.strictAllowlist, sandbox.filesystem.disabled, workflowSizeGuideline
4. **New Model**: Claude Opus 5 with adaptive thinking, $10/$50 per Mtok, 1M context
5. **Background Execution Patterns**: /code-review now runs as background subagent, MCP auto-backgrounds at 2 minutes
6. **Artifact Capabilities**: PR review skill, whiteboard skill, workshop/decision artifacts
7. **Command Changes**: /fork to /subtask rename, /verify and /code-review no longer auto-invoke skills, claude auto-mode reset command added

### Token Deltas (from system-prompts)

- 2.1.220: No changes
- 2.1.219: +30,034 tokens
- 2.1.218: +39,506 tokens
- 2.1.217: +13,476 tokens
- 2.1.216: +31,503 tokens
- 2.1.215: +645 tokens
- 2.1.214: No changes
- 2.1.213: +7,589 tokens
- 2.1.212: +1,066 tokens

**Net change**: +123,819 tokens (significant prompt expansion)

---

## Stage 2: Verification Results
### Verified: 2026-07-25

#### Must Update Verification

- ? **DirectoryAdded hook event** (CC 2.1.219) -- confirmed in changelog and system-prompts. Gap exists in hook-development/overview.md (current count is 28, adding DirectoryAdded makes 29). **Note:** Manifest claims this is the 27th event; existing docs show 28 events, so this would be the 29th.
- ! **Claude Opus 5 as default model** (CC 2.1.219) -- confirmed in changelog and system-prompts. **Reclassified to No Action:** This is a model change, not a plugin-system change. Plugin-dev documents model shorthand (`opus`, `sonnet`, `haiku`) which continue to work; the specific model they resolve to is not plugin-dev's scope.
- ? **sandbox.network.strictAllowlist setting** (CC 2.1.219) -- confirmed in changelog. Gap exists (no existing documentation). **Note:** Low plugin relevance; this is a sandbox config, not directly plugin-relevant unless plugins spawn sandboxed commands.
- ? **workflowSizeGuideline setting** (CC 2.1.219) -- confirmed in changelog. Gap exists. **Note:** Low plugin relevance; workflow size is runtime behavior, not directly plugin-relevant.
- ? **mcp_server_errors field in stream-json** (CC 2.1.219) -- confirmed in changelog. Gap exists. **Note:** Only relevant for SDK integration, not typical plugin development.
- ! **Subagent nesting depth increased to 3** (CC 2.1.218) -- **WRONG VERSION.** WebFetch changelog shows this change is in CC 2.1.219, not 2.1.218. CC 2.1.218 only mentions `SubagentStart` hook fix. Gap exists (current docs say 5 levels from CC 2.1.172). The new default is 3 with `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` env var for customization.
- ? **/code-review executes as background subagent** (CC 2.1.218) -- confirmed in changelog and system-prompts. Gap exists. Low plugin relevance (documents built-in command behavior, not plugin APIs).
- ? **sandbox.filesystem.disabled setting** (CC 2.1.216) -- confirmed in changelog and system-prompts. Gap exists in plugin-settings (no sandbox settings documented).
- ? **Subagent delegation restraint guidance** (CC 2.1.215) -- confirmed in system-prompts. Partial coverage exists in agent-development/references/advanced-agent-fields.md (forked worker guidance) but new restraint guidance not documented.
- ? **Removed automatic skill invocation for /verify and /code-review** (CC 2.1.215) -- confirmed in changelog and system-prompts. Gap exists in skill-development/references/skill-loading-and-runtime.md.
- ? **Session-wide WebSearch limit** (CC 2.1.213) -- confirmed in changelog. Gap exists. Low plugin relevance (runtime limit, not configurable by plugins).
- ? **Per-session subagent spawn cap** (CC 2.1.213) -- confirmed in changelog. Gap exists. Moderate plugin relevance (affects agent-heavy plugins).
- ? **MCP tool calls auto-background at 2 minutes** (CC 2.1.213) -- confirmed in changelog. Gap exists in mcp-integration/references/operations.md. Moderate plugin relevance for MCP-heavy plugins.
- ? **EndConversation tool** (CC 2.1.214) -- confirmed in changelog. Gap exists. Low plugin relevance (internal safety tool, not plugin-exposed).
- ? **Periodic progress heartbeats for long tool calls** (CC 2.1.214) -- confirmed in changelog. Gap exists. Low plugin relevance (runtime behavior).
- ? **/fork restructured; /subtask introduced** (CC 2.1.212) -- confirmed in changelog and system-prompts. Gap exists in command-development. Moderate plugin relevance.
- ? **claude auto-mode reset command** (CC 2.1.212) -- confirmed in changelog. Gap exists. Low plugin relevance (CLI command, not plugin API).
- ? **Persistent memory usage and writing guidance** (CC 2.1.212) -- confirmed in system-prompts. Partial coverage exists in agent-development/references/advanced-agent-fields.md but new guidance not documented.
- ! **Artifact PR review skill** (CC 2.1.213, 2.1.218) -- **Demoted to No Action:** This is a Claude Code built-in skill, not a plugin-system feature. Documenting built-in skills is not plugin-dev's scope.
- ! **Artifact whiteboard skill** (CC 2.1.218) -- **Demoted to No Action:** Same as above; built-in skill, not plugin-system feature.

#### Missed Items (promoted from No Action)

- ! **Skills with `context: fork` now run in background by default** (CC 2.1.219) -- missed because listed only in WebFetch, not in manifest. Can opt out with `background: false`.
  - Affects: skill-development
  - Details: Skills with `context: fork` now default to background execution; add `background: false` to frontmatter for foreground.

- ! **Skills and plugin frontmatter accept alternate boolean values** (CC 2.1.219) -- missed because listed only in WebFetch, not in manifest. Now accept `yes`/`no`/`on`/`off`/`1`/`0` (case-insensitive) alongside `true`/`false`.
  - Affects: skill-development, plugin-structure
  - Details: Boolean fields in frontmatter now more flexible; validation scripts may need updates.

- ! **Agent markdown files reject names containing colon** (CC 2.1.219) -- missed because listed only in WebFetch, not in manifest. Colon reserved for plugin namespacing.
  - Affects: agent-development
  - Details: Agent identifiers cannot contain `:` -- reserved for plugin namespacing (`plugin:subdir:agent-name`).

- ! **Agent frontmatter hooks require workspace trust** (CC 2.1.219) -- missed because listed only in WebFetch, not in manifest.
  - Affects: agent-development, hook-development
  - Details: Agent frontmatter hooks require the agent file's folder to have accepted workspace trust.

- ! **Tool(param:value) permission syntax with wildcards** (CC 2.1.212) -- missed because classified as internal change.
  - Affects: hook-development, agent-development (permission modes)
  - Details: Permission rules now support parameter matching like `Agent(model:opus)` or `Tool(param:*)`.

- ! **Subagents inherit parent permission mode by default; Task tool `mode` deprecated** (CC 2.1.212) -- missed in manifest.
  - Affects: agent-development
  - Details: Subagents now inherit parent's permission mode by default. Task tool `mode` parameter deprecated.

#### May Update Resolution

- = **ISO modified timestamp in memory file frontmatter** (CC 2.1.214) -- kept as May Update: low plugin relevance but could document in plugin-settings.
- v **Docker daemon-redirect flag permission prompts** (CC 2.1.216) -- demoted to No Action: runtime permission behavior, not plugin-configurable.
- v **Emoji shortcode autocomplete** (CC 2.1.217) -- demoted to No Action: UI feature, not plugin-relevant.
- v **Screen reader mode enhancements** (CC 2.1.217, 2.1.218) -- demoted to No Action: accessibility UI, not plugin-relevant.
- = **/resume picker in agent view** (CC 2.1.213) -- kept as May Update: documents background agent resume patterns.
- = **Import to Claude Code skill** (CC 2.1.213) -- kept as May Update: documents skill patterns but is built-in skill.
- = **SuggestSkills proactive guidance** (CC 2.1.213) -- kept as May Update: affects how skills are discovered/suggested.
- = **Scheduled task automated firing reminder** (CC 2.1.213) -- kept as May Update: affects scheduled agent execution.
- ^ **Invoke skill background behavior clarification** (CC 2.1.218) -- promoted to Must Update: directly affects skill invocation semantics.
  - Affects: skill-development
  - Details: Background skills return only agent name initially; results delivered via task notifications.
- v **/explain-usage slash command** (CC 2.1.217) -- demoted to No Action: built-in command, not plugin feature.
- v **Correction restraint guidance** (CC 2.1.217) -- demoted to No Action: behavioral guidance, not plugin API.
- v **Delivering work at full scope guidance** (CC 2.1.217, 2.1.218) -- demoted to No Action: behavioral guidance, not plugin API.
- v **Action safety and truthful reporting** (CC 2.1.216, 2.1.219) -- demoted to No Action: behavioral guidance, not plugin API.
- = **Saving skills via file delivery guidance** (CC 2.1.216) -- kept as May Update: affects how skills are authored/delivered.
- v **Artifact supporting files guidance** (CC 2.1.216) -- demoted to No Action: Artifact publishing, not plugin system.
- v **Workshop artifact / decision workshop skill** (CC 2.1.216-2.1.219) -- demoted to No Action: built-in skill, not plugin system.
- v **/code-review inline mode when Agent unavailable** (CC 2.1.213) -- demoted to No Action: built-in command fallback.
- v **/simplify inline mode when Agent unavailable** (CC 2.1.213) -- demoted to No Action: built-in command fallback.

#### Summary

- **Must Update:** 22 items (15 confirmed with gaps, 2 rejected/demoted, 5 added from missed items, 1 promoted from May Update)
- **May Update:** 7 items remaining (12 demoted to No Action, 1 promoted to Must Update)
- **No Action:** 44 items (30 original + 14 demoted)
- **Confidence:** Medium-high. Stage 1 missed 6 significant plugin-relevant changes from the WebFetch changelog. The CC 2.1.219 release had substantial plugin-system changes not fully captured. Version attribution for subagent nesting was incorrect (2.1.218 vs 2.1.219).

**Issues found:**
1. Subagent nesting depth change misattributed to CC 2.1.218; actually in CC 2.1.219
2. Six plugin-relevant items from CC 2.1.219 not captured in manifest
3. Hook event count incorrect (manifest says 27th, should be 29th)
4. Several "Must Update" items are behavioral/model changes, not plugin-system changes

---

## Raw Changelog Data

### CC 2.1.220 (from upstream changelog)
```
- Contains bug fixes and reliability improvements without detailed release notes
```

### CC 2.1.219 (from upstream changelog)
```
- Introduced Claude Opus 5 (`claude-opus-5`) as the new default Opus model, featuring 1M context window at $10/$50 per Mtok
- Added `sandbox.network.strictAllowlist` setting to automatically deny non-allowlisted network hosts in sandboxed commands
- Implemented `DirectoryAdded` hook that activates after registering new working directories mid-session via `/add-dir`
- Enhanced stream-json initialization with `mcp_server_errors` field documenting skipped MCP configuration entries
- Added `workflowSizeGuideline` settings key for customizing dynamic workflow size recommendations
- Corrected text output handling when turns end with mid-stream API errors
- Enhanced MCP server status reporting with HTTP error details and whitespace warnings
- Fixed model picker display inconsistencies for Opus variants
- Resolved copy-on-select functionality issues in GNU screen environments
- Corrected Remote Control fast-mode status persistence across model switches
```

### CC 2.1.218 (from upstream changelog)
```
- Refactored `/code-review` to execute as background subagent, preventing review output from filling main conversation
- Added screen reader announcements for text deletions in accessibility mode
- Enhanced Windows path handling to prevent character corruption in tool inputs
- Extended subagent nesting capability to depth 3 by default (previously depth 1)
- Added environment variable `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` for controlling nesting depth
- Resolved transcript jumping issues during streaming responses
- Fixed multi-line paste handling in various terminal types
- Corrected `/context` token usage reporting after message compaction
- Enhanced `/ultrareview` to accept descriptive arguments like branch reviews
```

### CC 2.1.217 (from upstream changelog)
```
- Introduced emoji shortcode autocomplete in prompt input (e.g., `:heart:`)
- Implemented warnings for transcript write failures and disabled session saving
- Added screen reader mode enhancements for keystroke echo and UI navigation
- Fixed memory leak where truncated MCP tool outputs retained full untruncated results
- Resolved auto-update failures on Windows that could delete `claude.exe`
- Enhanced background session isolation with symlink canonicalization
- Fixed auto-compact triggering for Claude Opus 4.8 on Bedrock
```

### CC 2.1.216 (from upstream changelog)
```
- Added `sandbox.filesystem.disabled` setting to skip filesystem isolation while maintaining network control
- Implemented permission prompts for `docker` commands carrying daemon-redirect flags
- Resolved quadratic message normalization slowdown in long sessions
- Fixed auto mode denial handling after OAuth token expiration
- Corrected `AskUserQuestion` response continuation logic
```

### CC 2.1.215 (from upstream changelog)
```
- Removed automatic skill invocation for `/verify` and "/code-review" - users must explicitly invoke these commands
```

### CC 2.1.214 (from upstream changelog)
```
- Fixed permission check bypass affecting Windows PowerShell 5.1 sessions
- Corrected Bash permission checks for various edge cases (long commands, variable subscripts)
- Added `EndConversation` tool for handling abusive users or jailbreak attempts
- Implemented periodic progress heartbeats for long-running tool calls
- Added ISO `modified` timestamp to memory file frontmatter
- Enhanced OpenTelemetry logging with message-level correlation attributes
```

### CC 2.1.213 (from upstream changelog)
```
- Added `/resume` picker in agent view for accessing past sessions including deleted ones
- Implemented session-wide WebSearch limit (default 200 calls) to prevent runaway search loops
- Added per-session subagent spawn cap (default 200) to halt delegation loops
- Configured MCP tool calls over 2 minutes to automatically background
- Resolved plan mode auto-running file-modifying Bash commands without permission
- Fixed worktree creation following symlinks at `.claude/worktrees`
- Corrected shell mode execution when path autocomplete popup was active
- Enhanced `/ultrareview` branch reference handling
```

### CC 2.1.212 (from upstream changelog)
```
- Restructured `/fork` functionality to copy conversations into new background sessions in agent view
- Renamed previous subagent spawn behavior to `/subtask`
- Added `claude auto-mode reset` command with confirmation prompt
- Expanded background agent capabilities: long-running MCP calls now auto-background
- Sessions can now resume from `/resume` picker as background jobs
- Corrected plan mode permission handling for file-modifying Bash commands
- Fixed worktree creation symlink traversal vulnerabilities
- Resolved background session ghost subagent spawning after main turn completion
```

### System-prompts 2.1.219 (key items)
```
- **NEW:** Agent Prompt: /code-review minimal mode
- **NEW:** Data: DirectoryAdded hook description
- **NEW:** Data: Interrupt cancel queued parameter, receipt cancelled field, SDK protocol capabilities field
- **NEW:** Skill: Artifact PR review description (composed publish flow)
- **NEW:** System Prompt: Plan mode interactive workshop offer
- Data: Claude API reference updates for Claude Opus 5
- Data: Claude model catalog, HTTP error codes, Platform availability updates for Opus 5
- System Prompt: Persistent memory usage and writing guidance updates
- System Prompt: Action safety and truthful reporting updates
```

### System-prompts 2.1.218 (key items)
```
- **NEW:** Skill: Artifact PR review (composed publish flow)
- **NEW:** Skill: Artifact whiteboard and when-to-use guidance
- **REMOVED:** Data: Structured tool output field schema
- **REMOVED:** System Prompt: Scope fidelity (merged into Delivering work at full scope)
- Agent Prompt: /code-review workflow routing updates
- Data: Managed Agents updates (effort configuration, event contracts, thread-scoped previews)
- System Prompt: Delivering work at full scope updates
- Tool Description: Invoke skill background behavior clarification
```

### System-prompts 2.1.217 (key items)
```
- **NEW:** Skill: /explain-usage slash command
- **NEW:** System Prompt: Correction restraint
- **NEW:** System Prompt: Delivering work at full scope and Scope fidelity
- Agent Prompt: Coordinator worker instructions updates
- Agent Prompt: Dream memory consolidation updates
- Skill: Artifact PR review self-updating decisions
- System Prompt: REPL tool usage updates for MCP call failures
```

### System-prompts 2.1.216 (key items)
```
- **NEW:** Data: /auto-mode-setup usage
- **NEW:** Data: Code change published event schema and VCS state changed event schema
- **NEW:** Data: Rewind files skippedLinks field
- **NEW:** Data: Sandbox filesystem disabled setting
- **NEW:** Data: Workshop artifact HTML template and Skill: Artifact workshop
- **NEW:** System Prompt: Action safety and truthful reporting
- **NEW:** System Prompt: Saving skills via file delivery
- **NEW:** System Reminder: AskUserQuestion minimum options validation
- **NEW:** Tool Description: Artifact supporting files guidance and summary
- **REMOVED:** Tool Description: Skill (mandatory matching-skill invocation)
- Agent Prompt: /code-review ReportFindings output format
```

### System-prompts 2.1.215 (key items)
```
- **NEW:** System Prompt: Subagent delegation restraint
- **REMOVED:** System Prompt: Action safety and truthful reporting (restored in 2.1.216)
- Tool Description: Agent usage notes updates for subagent steering mode
- Tool Description: EnterPlanMode and Grep updates for Agent tool recommendations
- Tool Description: Glob removes unconditional Agent tool recommendation
```

### System-prompts 2.1.214 (key items)
```
<sub>_No changes to the system prompts in v2.1.214._</sub>
```

### System-prompts 2.1.213 (key items)
```
- **NEW:** Agent Prompt: /code-review unavailable-agent inline mode and inline gap sweep phase
- **NEW:** Agent Prompt: /simplify unavailable-agent inline mode
- **NEW:** Skill: Artifact PR review and description
- **NEW:** Skill: Import to Claude Code
- **NEW:** System Reminder: Scheduled task automated firing
- **NEW:** Tool Description: Artifact runtime capabilities guidance
- **NEW:** Tool Description: SuggestSkills proactive guidance
- **NEW:** Tool Parameter: matched ask rule
- **REMOVED:** Data: Artifact connected-source guidance (expanded into runtime capabilities)
- **REMOVED:** Skill: /morning slash command
- Agent Prompt: CLAUDE.md creation import detection
- Agent Prompt: Security monitor for autonomous agent actions updates
- System Prompt: Coordinator worker instructions subagent fan-out
```

### System-prompts 2.1.212 (key items)
```
- **NEW:** Agent Prompt: /code-review workflow routing
- **NEW:** System Prompt: Persistent memory usage and writing guidance
- **NEW:** Tool Description: Artifact publishing and update guidance
- **NEW:** Tool Description: SendFeedback drafting guidance
- **REMOVED:** Agent Prompt: Context tip selector and reception evaluator
- **REMOVED:** Agent Prompt: Session search
- **REMOVED:** Data: Doctor checkup suggestion trigger
- Agent Prompt: /code-review ReportFindings short_summary requirement
- Agent Prompt: Dream memory consolidation and CLAUDE.md reconciliation
- Tool Description: Agent mode parameter availability
```
