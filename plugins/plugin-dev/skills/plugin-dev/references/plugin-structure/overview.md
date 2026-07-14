
# Plugin Structure for Claude Code

## Overview

Claude Code plugins follow a standardized directory structure with automatic component discovery. Master this structure to create well-organized, maintainable plugins that integrate seamlessly with Claude Code.

**Key concepts:**

- Conventional directory layout for automatic discovery
- Manifest-driven configuration in `.claude-plugin/plugin.json`
- Component-based organization (commands, agents, skills, hooks)
- Portable path references using `${CLAUDE_PLUGIN_ROOT}`
- Explicit vs. auto-discovered component loading

## Directory Structure

Every Claude Code plugin follows this organizational pattern:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin manifest
├── commands/                 # Slash commands (.md files)
├── agents/                   # Subagent definitions (.md files)
├── skills/                   # Agent skills (subdirectories)
│   └── skill-name/
│       └── SKILL.md         # Required for each skill
├── hooks/
│   └── hooks.json           # Event handler configuration
├── .mcp.json                # MCP server definitions
├── bin/                     # Plugin executables (CC 2.1.91)
└── scripts/                 # Helper scripts and utilities
```

**Critical rules:**

1. **Manifest location**: The `plugin.json` manifest MUST be in `.claude-plugin/` directory
2. **Component locations**: All component directories (commands, agents, skills, hooks) MUST be at plugin root level, NOT nested inside `.claude-plugin/`
3. **Optional components**: Only create directories for components the plugin actually uses
4. **Naming convention**: Use kebab-case for all directory and file names

## Plugin Manifest (plugin.json)

The manifest defines plugin metadata and configuration, located at `.claude-plugin/plugin.json`.

### Required Field

```json
{
  "name": "plugin-name"
}
```

**Name requirements:** kebab-case (lowercase with hyphens), unique across installed plugins, no spaces or special characters. Examples: `code-review-assistant`, `test-runner`, `api-docs`.

### Recommended Metadata

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief explanation of plugin purpose",
  "author": { "name": "Author Name", "email": "author@example.com", "url": "https://example.com" },
  "homepage": "https://docs.example.com",
  "repository": "https://github.com/user/plugin-name",
  "license": "MIT",
  "keywords": ["testing", "automation", "ci-cd"]
}
```

Use semantic versioning (`MAJOR.MINOR.PATCH`); keywords aid discovery and categorization. For the complete field-by-field reference (types, formats, validation, alternative author/repository formats), see `references/manifest-reference.md`.

### Behavior and Config Fields

These plugin.json fields control installation and runtime behavior — full detail in `references/manifest-reference.md`:

- **`defaultEnabled`** (CC 2.1.154): `false` installs the plugin disabled so users must enable it via `/plugin` (default `true`). Use for resource-heavy, config-required, opt-in, or security-sensitive plugins.
- **`userConfig`**: declares values users are prompted for on enable, accessed as `${user_config.KEY}` (non-sensitive) or `CLAUDE_PLUGIN_OPTION_<KEY>` env vars; `sensitive: true` values go to the keychain. **CC 2.1.207 breaking change:** `pluginConfigs` are no longer read from project `.claude/settings.json` — only user/`--settings`/managed settings.
- **`experimental`** (CC 2.1.129): `themes` and `monitors` must nest under this key (previously root-level; old format fails to load).

### Component Path Configuration

Custom paths supplement (never replace) default directories — components in both defaults and custom paths load:

```json
{
  "commands": "./custom-commands",
  "agents": ["./agents", "./specialized-agents"],
  "hooks": "./config/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

**Path rules:** relative to plugin root, start with `./`, no absolute paths, arrays allowed for multiple locations. See `references/manifest-reference.md` for resolution order and validation.

## Component Organization

Each component type has a default location and auto-discovers on plugin enable. Detailed organization patterns (flat, categorized, hierarchical, role/capability/workflow-based) live in `references/component-patterns.md`.

- **Commands (legacy)** — `.md` files in `commands/` with YAML frontmatter (`name`, `description`) become slash commands. The `commands/` directory is a legacy format; for new plugins prefer `skills/<name>/SKILL.md`, which supports progressive disclosure via `references/` and `examples/`. Both formats load identically and are invoked via the Skill tool — commands are essentially simple skills.
- **Agents** — `.md` files in `agents/` with YAML frontmatter (`description`, `capabilities`). Users invoke them manually or Claude Code selects them automatically by task context.
- **Skills** — each in its own `skills/<name>/` directory with a required `SKILL.md` (frontmatter `name`, `description`). Optional `allowed-tools` frontmatter (e.g. `Read, Grep, Glob`) restricts tool access for read-only or security-sensitive workflows. Skills can bundle `scripts/`, `references/`, `examples/`, or `assets/`. Claude Code autonomously activates skills based on the description.
- **Hooks** — JSON config in `hooks/hooks.json` or inline in `plugin.json`; register automatically on enable. Available events: PreToolUse, PermissionRequest, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification.

  ```json
  {
    "hooks": {
      "PreToolUse": [
        {
          "matcher": "Write|Edit",
          "hooks": [
            { "type": "command", "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/validate.sh", "timeout": 30 }
          ]
        }
      ]
    }
  }
  ```

- **MCP servers** — `.mcp.json` at plugin root or inline in `plugin.json` under `mcpServers`; start automatically on enable.

  ```json
  {
    "mcpServers": {
      "server-name": {
        "command": "node",
        "args": ["${CLAUDE_PLUGIN_ROOT}/servers/server.js"],
        "env": { "API_KEY": "${API_KEY}" }
      }
    }
  }
  ```

- **LSP servers** — inline in `plugin.json` under `lspServers`, keyed by language with `command`, `args`, and `extensionToLanguage`; start when matching files open, providing go-to-definition, find-references, and hover. For detailed LSP configuration, see the `lsp-integration` skill.
- **Output styles** — `outputStyles` field pointing to a directory (`"./styles/"`) or array of markdown files; customize how Claude formats responses. See `references/output-styles.md` for the frontmatter schema (`name`, `description`, `keep-coding-instructions`) and when to prefer styles over skills, agents, or CLAUDE.md.
- **Monitors** (CC 2.1.129, nested under `experimental`) — background scripts streaming events via the Monitor tool. Silence is NOT success: monitors must actively emit output. See `references/manifest-reference.md` for the monitors-vs-hooks guidance.
- **Executables (`bin/`, CC 2.1.91)** — files in `bin/` (compiled binaries or scripts with a shebang) can be invoked as bare commands from the Bash tool. Requires execute permissions (`chmod +x`) and platform-compatible binaries. Use to ship formatters, linters, converters, or standalone utilities.

## Portable Path References

Use the `${CLAUDE_PLUGIN_ROOT}` environment variable for all intra-plugin path references:

```json
{ "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/run.sh" }
```

It matters because plugins install in different locations depending on installation method, OS conventions, and user preferences. Use it in hook command paths, MCP server arguments, script execution references, and resource file paths. It works in manifest JSON fields, in component markdown (commands, agents, skills), and as an environment variable inside executed scripts (`source "${CLAUDE_PLUGIN_ROOT}/lib/common.sh"`).

**Never use** hardcoded absolute paths (`/Users/name/...`), working-directory-relative paths (`./scripts/...` in commands), or home shortcuts (`~/plugins/...`). External paths fail because plugins run from a cache copy — see `references/advanced-topics.md` ("Why External Paths Fail" and "Caching Details").

## File Naming Conventions

Use kebab-case throughout: command files (`code-review.md` → `/code-review`), agent files describing role (`test-generator.md`), skill directories (`api-testing/`), scripts with descriptive names and appropriate extensions (`validate-input.sh`, `generate-report.py`), and docs (`api-reference.md`). Configuration files use standard names: `hooks.json`, `.mcp.json`, `plugin.json`. Balance brevity with clarity — commands 2-3 words, agents describe the role, skills stay topic-focused. Avoid vague names (`utils/`, `misc.md`, `temp.sh`).

## Auto-Discovery Mechanism

Claude Code automatically discovers and loads components:

1. **Plugin manifest**: reads `.claude-plugin/plugin.json` when the plugin enables
2. **Commands**: scans `commands/` for `.md` files
3. **Agents**: scans `agents/` for `.md` files
4. **Skills**: scans `skills/` for subdirectories containing `SKILL.md`
5. **Hooks**: loads from `hooks/hooks.json` or manifest
6. **MCP servers**: loads from `.mcp.json` or manifest

**Discovery timing:** components register at installation and become available on enable; no restart is required — changes take effect on the next Claude Code session. Custom paths in `plugin.json` supplement (not replace) default directories.

Related discovery behaviors are detailed in `references/advanced-topics.md`: automatic local skill loading from `.claude/skills/` (CC 2.1.157) and nested `.claude/` directory precedence in monorepos (CC 2.1.178).

## Common Patterns

- **Minimal** — just `plugin.json` (name field) plus one command; see `examples/minimal-plugin.md`.
- **Full-featured** — commands, agents, skills, hooks, `.mcp.json`, and shared `scripts/`; see `examples/standard-plugin.md` and `examples/advanced-plugin.md`.
- **Skill-focused** — only a `skills/` directory with one SKILL.md per skill.

For organization and best-practice guidance (logical grouping, minimal manifest, README documentation, portability, maintenance/versioning), see `references/component-patterns.md`.

## Development and Runtime

During development, reload plugins by restarting Claude Code, or test without installing:

```bash
claude --plugin-dir /path/to/plugin
```

Additional loading options (ZIP archives, remote URLs), safe mode, caching internals, auto-update, install scopes, and CLI management commands are covered in `references/advanced-topics.md`.

Plugins behave differently in non-interactive environments:

- **Headless/CI mode** (`claude -p`): see `references/headless-ci-mode.md`
- **GitHub Actions**: see `references/github-actions.md`

## Plugin Validation

```bash
claude plugin validate    # CLI validation
claude --debug            # Detailed logging
claude --verbose          # Additional debugging
```

Use `/plugins` in the TUI to view installed plugins and their status. Discovery tools (`SearchPlugins`, `SearchSkills`, CC 2.1.199), scaffolding (`claude plugin init`, CC 2.1.157), pruning (`claude plugin prune`, CC 2.1.121), install improvements (CC 2.1.117), and additional source types are documented in `references/advanced-topics.md`.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Component not loading | File in correct directory with correct extension; valid YAML frontmatter; skill uses `SKILL.md` (not `README.md`); plugin enabled |
| Path resolution errors | Replace hardcoded paths with `${CLAUDE_PLUGIN_ROOT}`; manifest paths relative and start with `./`; referenced files exist; test with `echo $CLAUDE_PLUGIN_ROOT` in hook scripts |
| Auto-discovery not working | Directories at plugin root (not in `.claude-plugin/`); kebab-case names and correct extensions; custom paths correct; restart Claude Code |
| Plugin blocked by org policy | Organizations can block plugins via `managed-settings.json` (CC 2.1.85); blocked plugins are hidden and cannot be installed or enabled; work with the org admin — developers cannot override policy |
| Scripts fail "Permission denied" | Fixed in CC 2.1.86 (official marketplace scripts failed on macOS/Linux since CC 2.1.83); ensure `chmod +x scripts/*.sh` and a proper shebang |
| Conflicts between plugins | Use unique, descriptive component names; namespace commands with the plugin name; document potential conflicts in the README |

## Reference and Example Files

| Reference | When to read |
| --- | --- |
| `references/manifest-reference.md` | Writing or validating `plugin.json` — full field reference (name/version/description/author/homepage/repository/license/keywords), component-path fields, `defaultEnabled`, `userConfig`, `experimental`, `monitors`, path resolution, validation errors, minimal/recommended/complete examples |
| `references/component-patterns.md` | Choosing how to organize commands, agents, skills, hooks, and scripts (flat/categorized/hierarchical, role/capability/workflow-based); component lifecycle; cross-component and layered patterns; naming, scalability, maintenance, and portability best practices |
| `references/output-styles.md` | Bundling output styles — frontmatter schema, file locations, plugin bundling, and choosing styles vs skills/agents/CLAUDE.md |
| `references/advanced-topics.md` | Keybindings, status line, Claude as MCP server, MCP `@` resource syntax, agent hooks, auto-update, caching internals and "why external paths fail", CLI management, install scopes, enterprise controls, version constraints (CC 2.1.163), external plugin loading (CC 2.1.195), local skill loading (CC 2.1.157), nested `.claude/` precedence (CC 2.1.178), loading options (CC 2.1.128-2.1.129), safe mode (CC 2.1.169), security settings (CC 2.1.187/2.1.193), Cowork format (CC 2.1.163), discovery tools/scaffolding/pruning/install improvements |
| `references/headless-ci-mode.md` | Building or testing plugins for `claude -p` — what works headless, permission flags, structured output, system-prompt flags, session management, subagent forking (CC 2.1.121) |
| `references/github-actions.md` | Making plugins work with `claude-code-action` in CI — setup, hooks in CI, skills via `prompt`, provider configs, cost management |
| `examples/minimal-plugin.md` | Starting the simplest plugin — single command, name-only manifest |
| `examples/standard-plugin.md` | Building a typical distributable plugin — commands, agents, skills with references, hooks, scripts |
| `examples/advanced-plugin.md` | Building a full-featured plugin — multi-level command/agent organization, MCP servers, monitors, shared libraries, connectors |
