# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.19.0] - 2026-05-28

### Added

- **plugin-structure**: Documented `defaultEnabled: false` manifest field for opt-in plugins that start disabled (CC 2.1.154)
- **mcp-integration**: Documented stdio server environment variables `CLAUDE_CODE_SESSION_ID` and `CLAUDECODE=1` (CC 2.1.154)
- **agent-development**: Documented Opus 4.8 model support with high-effort defaults (CC 2.1.154)
- **agent-development**: Documented background session temporary directory change to `$CLAUDE_JOB_DIR/tmp` (CC 2.1.154)
- **command-development**: Documented AskUserQuestion tightened usage guidance — only ask when blocked on genuine ambiguity (CC 2.1.154)

## [0.18.0] - 2026-05-29

### Changed

- **Maintainer tooling relocated out of the shipped plugin**: Moved the `update-from-upstream` orchestration and its three verification agents (`changelog-differ`, `update-manifest-verifier`, `update-reviewer`) from `plugins/plugin-dev/` to the repo's `.claude/` directory. These exist only to keep this plugin's docs synced with Claude Code releases; they no longer load into context or clutter the skill/agent menus for users who install the plugin. They remain fully available to local development and the `upstream-sync.yml` CI workflow, which discovers them via the Agent SDK's `project` setting source.

### Removed

- **Shipped plugin no longer bundles the upstream-sync skill and agents** — the plugin now ships 1 skill (`plugin-dev`) and 3 agents (`plugin-validator`, `skill-reviewer`, `agent-creator`).

## [0.17.0] - 2026-05-28

### Added

- **hook-development**: Documented MessageDisplay hook event (26th event) for transforming or hiding assistant message text as displayed (CC 2.1.152)
- **hook-development**: Documented SessionStart hook `reloadSkills` and `sessionTitle` output fields (CC 2.1.152)
- **skill-development**: Documented `disallowed-tools` frontmatter field for removing tools from model's available pool (CC 2.1.152)
- **skill-development**: Documented `/reload-skills` command for hot-reloading skills during development (CC 2.1.152)
- **command-development**: Documented `disallowed-tools` frontmatter field for commands (CC 2.1.152)
- **marketplace-structure**: Documented `skipLfs` option for GitHub/git URL sources to skip Git LFS downloads (CC 2.1.153)
- **agent-development**: Documented MCP policy enforcement fix for subagent frontmatter MCP servers (CC 2.1.153)
- **agent-development**: Documented `--strict-mcp-config` behavior change for explicitly-passed agent definitions (CC 2.1.153)
- **agent-development**: Documented Agent tool autocomplete for native slash commands and bundled skills (CC 2.1.153)
- **agent-development**: Documented multiple `Agent(...)` types fix in tools frontmatter (CC 2.1.147)

## [0.16.1] - 2026-05-19

### Changed

- **claude-code-compatibility**: Audited CC 2.1.144 — bug fixes only, no plugin-system changes requiring documentation updates

## [0.16.0] - 2026-05-16

### Added

- **agent-development**: Documented SendUserFile tool for surfacing generated deliverable files with captions (CC 2.1.142)
- **agent-development**: Documented Agent tool simplified usage notes covering delegation, fork behavior, resumption, worktree isolation, background execution, parallel launches, and context restrictions (CC 2.1.140)
- **agent-development**: Documented Self-Modification protected paths for security monitor (CC 2.1.140)
- **agent-development**: Documented `worktree.bgIsolation: "none"` setting for background sessions to edit working copy directly (CC 2.1.143)
- **hook-development**: Documented `args` field for exec-form command spawning without shell interpolation (CC 2.1.139)
- **hook-development**: Documented `continueOnBlock` option for PostToolUse hooks to feed rejection back to Claude (CC 2.1.139)
- **hook-development**: Documented `terminalSequence` output field for desktop notifications, window titles, and bells (CC 2.1.141)
- **hook-development**: Documented Stop hook `impossible` response shape for conditions that can never be satisfied (CC 2.1.143)
- **hook-development**: Documented Stop hook 8-block cap to prevent infinite loops with `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` override (CC 2.1.143)

## [0.15.0] - 2026-05-10

### Added

- **hook-development**: Documented `effort.level` hook input field and `$CLAUDE_EFFORT` environment variable for effort-aware hooks (CC 2.1.133)
- **hook-development**: Documented `worktree.baseRef` setting (`fresh` | `head`) for WorktreeCreate events (CC 2.1.133)
- **agent-development**: Documented `worktree.baseRef` setting for agent-isolation worktrees (CC 2.1.133)
- **agent-development**: Documented subagent skill discovery fix — subagents now correctly discover project, user, and plugin skills (CC 2.1.133)
- **agent-development**: Documented Bash tool guidance to prefer dedicated tools (Read, Grep, Glob) over Bash commands (CC 2.1.133)
- **skill-development**: Documented subagent skill discovery fix (CC 2.1.133)
- **skill-development**: Added "prefer dedicated tools" to best practices (CC 2.1.133)

## [0.14.0] - 2026-05-07

### Added

- **plugin-structure**: Documented `--plugin-url` flag for loading plugin archives from URLs (CC 2.1.129)
- **plugin-structure**: Documented `--plugin-dir` now accepts `.zip` archives in addition to directories (CC 2.1.128)
- **plugin-structure**: Documented `experimental` key requirement for `themes` and `monitors` in plugin.json (CC 2.1.129) — **breaking change** for plugins using these features
- **skill-development**: Documented `skillOverrides` setting with `off`, `user-invocable-only`, and `name-only` options (CC 2.1.129)
- **mcp-integration**: Documented `workspace` as reserved MCP server name (CC 2.1.128)
- **hook-development**: Documented `CLAUDE_CODE_SESSION_ID` environment variable for session tracking (CC 2.1.132)
- **agent-development**: Documented `CLAUDE_CODE_LOOP_PERSISTENT` environment variable guidance for autonomous work loops (CC 2.1.129)
- **agent-development**: Documented background job agent built-in instructions replacing previous background-job behavior system prompt (CC 2.1.128)

## [0.13.1] - 2026-05-01

### Added

- **command-development**: Documented `claude project purge [path]` command for deleting all Claude Code project state (CC 2.1.126)
- **command-development**: Documented Windows PowerShell primary shell consideration for cross-platform commands (CC 2.1.126)
- **hook-development**: Documented file modification budget-exceeded system reminder for FileChanged context (CC 2.1.124)
- **hook-development**: Documented Windows PowerShell primary shell consideration for cross-platform hooks (CC 2.1.126)
- **skill-development**: Documented deferred tools (WebSearch, WebFetch) fix for `context: fork` skills now available on first turn (CC 2.1.126)
- **Loader-binding caveat for `${CLAUDE_PLUGIN_ROOT}` in frontmatter hooks.** Documented the observed runtime behavior: `${CLAUDE_PLUGIN_ROOT}` resolves only when an agent or skill file is loaded through plugin discovery; agents loaded via the `--agent` CLI flag from `.claude/agents/` see the variable unbound and the hook fails with "Hook command references ${CLAUDE_PLUGIN_ROOT} but the hook is not associated with a plugin." Workaround is to use `${CLAUDE_PROJECT_DIR}` with a project-relative path. Surface became newly reachable in CC 2.1.116 (main-thread frontmatter hooks via `--agent`). Caveat added to `references/hook-development/overview.md` (Scoped Hooks section + Environment Variables + Critical Gotchas), `references/hook-development/references/advanced.md`, `references/agent-development/overview.md` (hooks field), and `references/agent-development/references/advanced-agent-fields.md`. Cross-references upstream issues [#24529](https://github.com/anthropics/claude-code/issues/24529), [#27145](https://github.com/anthropics/claude-code/issues/27145), [#50357](https://github.com/anthropics/claude-code/issues/50357).


## [0.13.0] - 2026-04-28

### Added

- **mcp-integration**: Documented `alwaysLoad` configuration option to bypass lazy loading and tool-search deferral (CC 2.1.121)
- **mcp-integration**: Documented MCP server auto-retry (up to 3 times) for transient startup errors (CC 2.1.121)
- **plugin-structure**: Documented `claude plugin prune` command for removing orphaned auto-installed dependencies (CC 2.1.121)
- **hook-development**: Documented PostToolUse `updatedToolOutput` field for replacing output from ANY tool, not just MCP tools (CC 2.1.121)
- **plugin-structure**: Documented `CLAUDE_CODE_FORK_SUBAGENT=1` environment variable for enabling subagent forking in headless/CI sessions (CC 2.1.121)

## [0.12.0] - 2026-04-25

### Added

- **hook-development**: Documented `type: "mcp_tool"` hook type for direct MCP tool invocation without spawning an agent (CC 2.1.118)
- **hook-development**: Documented `duration_ms` field in PostToolUse and PostToolUseFailure hook inputs for performance monitoring (CC 2.1.119)
- **agent-development**: Documented print mode (`-p`/`--print`) frontmatter enforcement for `tools:` and `disallowedTools:` (CC 2.1.119)
- **agent-development**: Documented `--agent <name>` CLI flag now honors agent's frontmatter `permissionMode` (CC 2.1.119)
- **skill-development**: Documented "Previously invoked skills" compaction reminder that replaces old "Invoked skills" reminder with explicit context-only framing (CC 2.1.119)
- **plugin-structure**: Documented version constraint auto-update - dependent plugins now auto-update to highest satisfying git tag (CC 2.1.119)

### Changed

- **agent-development**: Removed Config tool from common tool sets (removed in CC 2.1.118) - use `/config` command instead

## [0.11.2] - 2026-04-22

### Added

- **agent-development**: Documented agent frontmatter `mcpServers` loading for main-thread sessions with `--agent` (CC 2.1.117)
- **agent-development**: Documented agent frontmatter `hooks` firing when running as main session agent via `--agent` (CC 2.1.116)
- **agent-development**: Documented background job behavior guidance - narrate progress, restate results in text, signal completion status (CC 2.1.117)
- **agent-development**: Documented SendMessageTool expanded `attachments` format - file path strings or attachment objects (CC 2.1.116)
- **plugin-structure**: Documented `plugin install` dependency handling and marketplace blocking enforcement (CC 2.1.117)
- **plugin-structure**: Documented `/reload-plugins` and auto-update now install missing plugin dependencies (CC 2.1.116)
- **marketplace-structure**: Documented marketplace blocking enforcement at install time (CC 2.1.117)

## [0.11.1] - 2026-04-19

### Added

- **skill-development**: Documented `/skills` menu token count sorting feature (CC 2.1.111)
- **command-development**: Documented Skill tool strict invocation rules - Claude only invokes skills from available-skills list (CC 2.1.111)
- **command-development**: Documented Bash cd+git guidance to avoid permission prompts (CC 2.1.113)
- **agent-development**: Documented memory synthesis retrieval-only directive for memory-enabled agents (CC 2.1.111)

## [0.11.0] - 2026-04-16

### Changed

- **BREAKING: Consolidated 9 teaching skills + plugin-dev-guide into single `plugin-dev` skill** with routing index and progressive disclosure. Eval showed 57.9% vs 47.4% trigger rate (strict superset, zero false positives). The consolidated skill uses a topic index table that routes to `references/<topic>/overview.md` files preserving the same content.
- **Removed `plugin-dev-guide` agent** — replaced by the routing index in the consolidated skill
- **Removed `start`, `create-plugin`, `create-marketplace` commands** — interactive scaffolding replaced by direct prompting with the consolidated skill and agents
- **Updated agent frontmatter**: `plugin-validator`, `agent-creator`, `skill-reviewer` now reference `skills: plugin-dev` instead of individual skill names
- `update-from-upstream` remains a separate skill (workflow, not reference)

### Migration

- If you referenced individual skills by name (e.g., `hook-development`, `skill-development`), use `plugin-dev` instead. The content is identical, reorganized under `references/<topic>/`.

## [0.10.3] - 2026-04-16

### Changed

- **BREAKING: Allowed-tools syntax change** - Updated all documentation to use space-separated format (`Bash(git *)`) instead of colon-separated format (`Bash(git:*)`) per Claude Code 2.1.108
- **command-development**: Updated allowed-tools examples across SKILL.md, references, and examples
- **plugin-structure**: Updated allowed-tools examples in github-actions.md and headless-ci-mode.md
- **/create-plugin, /create-marketplace**: Updated allowed-tools frontmatter
- **docs**: Updated allowed-tools examples in workflow-security.md and CONTRIBUTING.md

### Note

- CI workflow files (`.github/workflows/claude.yml`, `.github/workflows/component-validation.yml`) still use old colon-separated syntax. Update these manually if the repository has `workflows` write permission configured.

### Added

- **hook-development**: Documented PreCompact hook blocking capability with exit code 2 or `{"decision":"block"}` (CC 2.1.105)
- **plugin-structure**: Documented `monitors` manifest key for background monitoring scripts with "silence is not success" guidance (CC 2.1.105)

## [0.10.2] - 2026-04-10

### Added

- **agent-development**: Documented Monitor tool for streaming background events as chat notifications (CC 2.1.98)
- **agent-development**: Documented that agent threads always require absolute file paths unconditionally (CC 2.1.97)
- **skill-development**: Documented that plugin skills use frontmatter `name` for invocation instead of directory basename (CC 2.1.94)

### Changed

- **claude-code-compatibility**: Updated to CC 2.1.98 with notes on plugin skill hooks and CLAUDE_PLUGIN_ROOT fixes (CC 2.1.94)

## [0.10.1] - 2026-04-07

### Fixed

- **plugin-dev-guide agent**: Fixed YAML frontmatter parse error — added missing block scalar indicator (`|`) on description field

## [0.10.0] - 2026-04-04

### Added

- **hook-development**: Documented PreToolUse `defer` permission decision for pausing tool execution in headless sessions (CC 2.1.89)
- **mcp-integration**: Documented `_meta["anthropic/maxResultSizeChars"]` annotation for large MCP tool results up to 500K characters (CC 2.1.91)
- **skill-development**: Documented `disableSkillShellExecution` setting that organizations can use to disable inline shell execution (CC 2.1.91)
- **command-development**: Documented `disableSkillShellExecution` setting for command shell execution (CC 2.1.91)
- **plugin-structure**: Documented plugin `bin/` directory for shipping executables that can be invoked as bare commands (CC 2.1.91)

## [0.9.0] - 2026-03-31

### Added

- **hook-development**: Documented PermissionDenied hook event (25th event) for handling auto mode classifier denials with retry capability (CC 2.1.88)
- **hook-development**: Documented `file_path` absolute path behavior for Write/Edit/Read tools in PreToolUse/PostToolUse hooks (CC 2.1.88)
- **hook-development**: Documented `if` field fix for compound commands and env var prefixes (CC 2.1.88)
- **hook-development**: Documented partial compaction capability with structured summary format (CC 2.1.88)
- **agent-development**: Documented Config tool for getting/setting Claude Code settings (CC 2.1.88)

### Changed

- **hook-development**: Updated event count from 24 to 25 across skill and reference documentation

## [0.8.0] - 2026-03-29

### Added

- **hook-development**: Documented conditional `if` field for hooks using permission rule syntax (CC 2.1.85)
- **hook-development**: Documented `AskUserQuestion` satisfaction via PreToolUse `updatedInput` (CC 2.1.85)
- **skill-development**: Documented 250-character description cap in `/skills` menu (CC 2.1.86)
- **skill-development**: Documented alphabetical sorting in `/skills` menu (CC 2.1.86)
- **plugin-structure**: Documented organization plugin blocking via managed settings (CC 2.1.85)
- **plugin-structure**: Documented resolved "Permission denied" bug for marketplace scripts (CC 2.1.86)
- **mcp-integration**: Documented `CLAUDE_CODE_MCP_SERVER_NAME` and `CLAUDE_CODE_MCP_SERVER_URL` env vars for headersHelper (CC 2.1.85)
- **agent-development**: Documented upstream prompt change from "nothing more, nothing less" to "Complete the task fully" (CC 2.1.86)
- **agent-development**: Documented `name` field guidance for spawned agents/forks (CC 2.1.85)
- **agent-development**: Documented "Production Reads" blocked category in permission modes (CC 2.1.85)
- **marketplace-structure**: Documented organization plugin blocking (CC 2.1.85)

### Fixed

- **skill-development**: Noted resolved `paths:` frontmatter bug where tools failed on files outside project root (CC 2.1.86)
- **event-schemas**: Updated event count from 22 to 24

## [0.7.0] - 2026-03-29

### Added

- **update-from-upstream skill**: Four-stage pipeline for syncing plugin-dev documentation with Claude Code upstream releases, using source triangulation and independent verification agents
- **changelog-differ agent**: Stage 1 agent that fetches CC changelog, reads system-prompts repo, and dispatches claude-code-guide for three-source triangulation
- **update-manifest-verifier agent**: Stage 2 agent that independently re-fetches sources and validates the change manifest before edits are applied
- **update-reviewer agent**: Stage 4 agent that verifies completeness, accuracy, lint, version sync, regressions, and style of applied updates
- **claude-code-compatibility.md**: Version tracking file with audit log table recording which CC version plugin-dev is built against

## [0.6.1] - 2026-03-28

### Fixed

- **agent-development**: `skills` field documented as YAML array; corrected to comma-separated string matching actual Claude Code runtime behavior
- **skill-development**: Same YAML array fix for `skills` field in `context: fork` example

## [0.6.0] - 2026-03-27

### Added

- **plugin-dev-guide agent**: Haiku-powered triage agent that matches plugin development questions to the right specialized skill, keeping the main context window clean

### Changed

- **plugin-dev-guide skill**: Converted from in-context routing table to thin dispatch shim that spawns the triage agent and follows its recommendation

## [0.5.0] - 2026-03-27

### Added

- **agent-development**: `initialPrompt` frontmatter field for auto-submitting a first turn when agent runs as main session agent
- **hook-development**: `CwdChanged` event for reactive environment management on directory changes (supports `CLAUDE_ENV_FILE` and `watchPaths`)
- **hook-development**: `FileChanged` event for watching file changes with basename matcher support
- **plugin-structure**: `userConfig` manifest field for plugin-configurable values prompted at enable time, with keychain storage for sensitive values
- **skill-development**: `paths` frontmatter field accepting YAML list of globs for file-scoped skill activation
- **mcp-integration**: MCP description limits section documenting the 2KB cap on tool descriptions and server instructions

### Changed

- **hook-development**: Updated event count from 22 to 24 across skill, quick reference table, and hook type support matrix
- **hook-development**: `WorktreeCreate` now documents HTTP hook support with `hookSpecificOutput.worktreePath` response format

## [0.4.1] - 2026-03-24

### Documentation

- **Audit skills against official Claude Code docs** - Incorporated upstream documentation audit covering all 10 skills with new sections for agent teams, execution modes, MCP scope system, CLI commands, plugin validation, enterprise features, visibility budgets, and context management
- **Add 10 new reference files** - Advanced agent fields, permission modes/rules, hook input schemas, memory/rules system, headless CI mode, GitHub Actions integration, output styles, advanced topics, advanced frontmatter, commands-vs-skills
- **Expand existing references** - Hook advanced patterns, marketplace distribution/schema, MCP authentication/tool-usage, manifest reference, command skill-tool
- **Fix prompt hook support claim** - Corrected false claim that prompt hooks only support 4 events (actually supports 19)
- **Fix SessionEnd Quick Reference** - Added missing "resume" matcher
- **Update project docs** - Lint command updates (markdownlint-cli2), component-patterns agent fields, SECURITY supported versions

## [0.4.0] - 2026-03-20

### Added

- **Plugin-dev-guide meta-skill** - Navigation skill that routes users to the correct specialized skill
- **All 22 hook event documentation** - Comprehensive schemas, examples, and gotchas for every Claude Code hook event
- **Hook example scripts** - Working examples for StopFailure, TaskCompleted, TeammateIdle, WorktreeCreate/Remove, ConfigChange, Elicitation, and observability logging

### Changed

- **Fork ownership** - Updated plugin and marketplace ownership to kylesnowschwartz
- **Synced plugin structure** - Aligned with official Claude Code plugin conventions

## [0.3.2] - 2026-01-24

### Fixed

- **Restore MCP tool naming patterns** - Fixed `mcp__plugin_*__*` patterns in mcp-integration docs that prettier corrupted to `mcp**plugin_*__*`; added .prettierignore to prevent recurrence

### Documentation

- **Expand LSP integration skill** - Aligned with official Claude Code docs for comprehensive LSP server guidance
- **Optimize agent-development skill** - Trimmed SKILL.md to target word count for faster loading
- **Align tools/allowed-tools format** - Updated documentation to match official Claude Code docs terminology
- **Update CI/CD workflow documentation** - Fixed workflow list in docs/ci-cd.md (added yaml-lint.yml, removed non-existent weekly-maintenance.yml)

## [0.3.1] - 2026-01-24

### Fixed

- **Replace `!` with `[BANG]` in skill-development** - Fixed regression from #192 where dynamic context injection examples used literal `!` backtick patterns, causing shell execution errors during skill loading

### Documentation

- **Update skill counts for LSP integration** - Updated CONTRIBUTING.md and README.md to reflect 9 skills (was 8)
- **Add LSP Integration to README skills table** - Added missing entry for LSP skill triggers
- **Add 0.3.x to SECURITY.md** - Added current version to supported versions table

## [0.3.0] - 2026-01-24

### Changed

- **Sync documentation with official Claude Code docs** - Updated all skill documentation to align with latest Claude Code features and terminology (#192)
- **Replace deprecated TodoWrite with Task tools** - Updated documentation to use current TaskCreate, TaskUpdate, TaskGet, TaskList tools (#190)
- **Update documentation for Skill tool consolidation** - Reflect Claude Code's unified Skill tool approach (#186)
- **Optimize CLAUDE.md with progressive disclosure** - Restructured for faster onboarding

### Fixed

- **Use dynamic GitHub release badge** - Badge now updates automatically from GitHub releases (#054a89b)

### Security

- **Remove untrusted checkout in ci-failure-analysis** - Hardened workflow against potential code injection (#0d5a428)

### CI/CD

- **Improve workflow consistency and add YAML linting** - Enhanced CI reliability with yamllint integration
- **Improve links and markdownlint workflows** - Better error reporting and performance
- **Improve greet workflow** - Enhanced new contributor welcome experience
- **Improve CI workflows with Node.js setup** - Consistent tooling across workflows
- **Eliminate workflow dependencies and optimize CI** - Faster parallel execution
- **Clean up validate-workflows configuration** - Simplified workflow validation
- **Remove dependabot auto-merge workflow** - Simplified dependency management
- **Improve label system and dependabot config** - Better issue/PR organization
- **Improve GitHub templates** - Enhanced issue and PR template UX

### Dependencies

- Bump anthropics/claude-code-action to v1.0.34
- Bump actions/checkout to v6.0.2 (#183)
- Bump actions/cache to v5.0.2 (#189)
- Bump yamllint to 1.38.0

### Maintenance

- Ignore .mcp.json (user-specific MCP config)
- Update release procedure for dynamic version badge

## [0.2.1] - 2025-12-13

### Security

- **Harden validation scripts against bypass attacks** - Improved input validation and escaping in hook validation scripts (#164)
- **Prevent command injection in test-hook.sh** - Fixed potential command injection vulnerability (#148)
- **Use jq for safe JSON output** - Replaced echo with jq for proper JSON escaping in example hooks (#149)
- **Document security scope and trust model** - Added comprehensive security documentation for workflow commands (#165)

### Fixed

- **Workflow reliability improvements** - Enhanced workflow security, reliability, and documentation
- **Remove deprecated mode parameter** - Fixed claude-pr-review workflow by removing deprecated mode parameter (#171)
- **Shellcheck SC1087 errors** - Resolved array expansion errors in validate-hook-schema.sh (#168)
- **Replace unofficial `cc` alias** - Updated to use official `claude` CLI command
- **Issue and PR template improvements** - Fixed UX issues, restored spacing, removed unsupported fields
- **Labels configuration** - Corrected labels.yml and LABELS.md issues
- **Dependabot configuration** - Improved grouping and accountability settings
- **Suppress grep stderr** - Fixed noisy output in test-agent-trigger.sh (#150)

### Changed

- **Use ERE instead of BRE** - Refactored grep patterns to use Extended Regular Expressions for clarity (#159)

### Documentation

- **Comprehensive documentation improvements** - Major updates across README, CLAUDE.md, and skill documentation
- **Discussion templates** - Improved UX with plugin-specific fields
- **Prerequisites section** - Added utility script dependency documentation (#157)
- **Shellcheck guidance** - Added linting instructions to CONTRIBUTING.md (#160)
- **Secure mktemp pattern** - Documented secure temporary file handling (#158)
- **[BANG] workaround** - Documented security workaround for Claude Code #12781 (#156)

### Dependencies

- Bump anthropics/claude-code-action (#170)
- Bump EndBug/label-sync (#169)
- Update GitHub Actions to latest versions
- Remove deprecated sync-labels.sh script

## [0.2.0] - 2025-12-12

### Added

- **`/plugin-dev:start` command** - New primary entry point that guides users to choose between creating a plugin or marketplace (#145)
  - Uses `disable-model-invocation: true` to route cleanly to specialized workflows
  - Recommends plugin creation for most users

### Fixed

- Enable router invocation of workflow commands - workflow commands can now be invoked by other commands (#145)
- Replace `!` with `[BANG]` placeholder in skill documentation to prevent shell interpretation issues (#142)

### Documentation

- Fix component counts and update documentation accuracy across README, CONTRIBUTING, CLAUDE.md, and marketplace.json

## [0.1.0] - 2025-12-11

### Added

- **Initial release** of Plugin Development Toolkit for Claude Code

#### Core Plugin Features

- **8 specialized skills** with progressive disclosure architecture:
  - `hook-development` - Event-driven automation with prompt-based hooks
  - `mcp-integration` - Model Context Protocol server configuration
  - `plugin-structure` - Directory layout and manifest configuration
  - `plugin-settings` - Configuration via .claude/plugin-name.local.md files
  - `command-development` - Slash commands with frontmatter
  - `agent-development` - Autonomous agents with AI-assisted generation
  - `skill-development` - Creating skills with progressive disclosure
  - `marketplace-structure` - Plugin marketplace creation and distribution

- **3 validation agents** for automated quality assurance:
  - `plugin-validator` - Validates entire plugin structure and marketplace.json
  - `skill-reviewer` - Reviews skill quality, triggering reliability, and best practices
  - `agent-creator` - Generates new agents from natural language descriptions

- **2 guided workflow commands**:
  - `/plugin-dev:create-plugin` - 8-phase guided workflow for plugin creation
  - `/plugin-dev:create-marketplace` - 8-phase guided workflow for marketplace creation

#### Utility Scripts

- **Agent development scripts**:
  - `create-agent-skeleton.sh` - Create new agent skeleton files
  - `validate-agent.sh` - Validate agent frontmatter and structure
  - `test-agent-trigger.sh` - Test agent trigger phrase matching

- **Command development scripts**:
  - `validate-command.sh` - Validate command structure
  - `check-frontmatter.sh` - Check frontmatter field validity

- **Hook development scripts**:
  - `validate-hook-schema.sh` - Validate hooks.json schema
  - `test-hook.sh` - Test hooks with sample input
  - `hook-linter.sh` - Lint hook shell scripts

- **Plugin settings scripts**:
  - `validate-settings.sh` - Validate settings file structure
  - `parse-frontmatter.sh` - Parse YAML frontmatter from settings

#### CI/CD Workflows

- **PR validation workflows** (6 workflows):
  - `markdownlint.yml` - Markdown style enforcement
  - `links.yml` - Link validation with lychee
  - `component-validation.yml` - Plugin component validation
  - `version-check.yml` - Version consistency across manifests
  - `validate-workflows.yml` - GitHub Actions workflow validation
  - `claude-pr-review.yml` - AI-powered code review

- **Automation workflows** (8 workflows):
  - `claude.yml` - Main Claude Code workflow
  - `stale.yml` - Stale issue/PR management
  - `semantic-labeler.yml` - Automatic PR/issue labeling
  - `ci-failure-analysis.yml` - CI failure analysis
  - `weekly-maintenance.yml` - Scheduled maintenance tasks
  - `dependabot-auto-merge.yml` - Dependabot PR auto-merge
  - `sync-labels.yml` - Repository label synchronization
  - `greet.yml` - New contributor welcome messages

#### Documentation

- **User documentation**:
  - `README.md` - Comprehensive user guide with installation, usage examples, and best practices
  - `CONTRIBUTING.md` - Contributor guidelines and development setup
  - `SECURITY.md` - Security policy and vulnerability reporting
  - `CODE_OF_CONDUCT.md` - Community standards and expectations

- **Developer documentation**:
  - `CLAUDE.md` - Architecture, patterns, and development guide
  - Skill-specific references and examples in each skill directory

#### Repository Infrastructure

- **Issue templates** (4 types):
  - Bug report with reproduction steps
  - Feature request with use cases
  - Documentation improvements
  - Questions and discussions

- **Pull request template** with component-specific checklists

- **Label system** with categories:
  - Component labels (agent, command, skill, hook, docs)
  - Priority labels (critical, high, medium, low)
  - Status labels (blocked, in-progress, needs-review)
  - Effort labels (small, medium, large)

- **Dependabot** configured for GitHub Actions updates

#### Attribution

- Based on original plugin by Daisy Hollman at Anthropic
- Expanded with enhanced skills, additional utilities, and CI/CD infrastructure

[Unreleased]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.19.0...HEAD
[0.19.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.18.0...v0.19.0
[0.18.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.17.0...v0.18.0
[0.17.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.16.1...v0.17.0
[0.16.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.13.1...v0.14.0
[0.13.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.13.0...v0.13.1
[0.13.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.11.2...v0.12.0
[0.11.2]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.11.1...v0.11.2
[0.11.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.11.0...v0.11.1
[0.11.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.10.3...v0.11.0
[0.10.3]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.10.2...v0.10.3
[0.10.2]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.10.1...v0.10.2
[0.10.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/kylesnowschwartz/plugin-dev/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kylesnowschwartz/plugin-dev/releases/tag/v0.1.0
