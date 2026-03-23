# Advanced Plugin Topics

This reference covers specialized topics that plugin developers may encounter in advanced use cases. Each section is self-contained.

## Keybindings Plugin Context

Claude Code's keybindings system (`~/.claude/keybindings.json`) includes a `plugin:` context with actions for plugin management:

| Action           | Description             |
| ---------------- | ----------------------- |
| `plugin:toggle`  | Enable/disable a plugin |
| `plugin:install` | Install a plugin        |

**Configuration:**

```json
{
  "bindings": [
    {
      "context": "Plugin",
      "bindings": {
        "ctrl+p": "plugin:toggle"
      }
    }
  ]
}
```

**Plugin developer relevance:** Low. This is user-facing configuration. Plugins cannot define custom keybindings. If your plugin has frequently used commands, document keyboard shortcuts users can configure.

## Status Line Integration

Plugins can provide status line scripts that display contextual information in the Claude Code footer.

### How It Works

Users configure a status line command in `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

The script receives JSON via stdin with session context (model, cost, tokens, workspace info) and outputs a single line of text (ANSI colors supported).

### Available Data

The JSON input includes:

- `model.display_name` — Current model name
- `cost.total_cost_usd` — Session cost
- `cost.total_lines_added` / `total_lines_removed` — Code changes
- `context_window.used_percentage` — Context usage
- `context_window.total_input_tokens` / `total_output_tokens` — Token counts
- `workspace.current_dir` / `project_dir` — Directory info
- `version` — Claude Code version

### Plugin Use Case

A plugin could bundle a status line script that displays plugin-specific information:

```bash
#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd')
echo "[$model] \$${cost}"
```

**Note:** Users must manually configure their status line to use the plugin's script. There is no auto-configuration mechanism.

## Claude Code as MCP Server

Claude Code can itself act as an MCP server, exposing its capabilities to other MCP clients:

```bash
claude mcp serve
```

**Plugin developer relevance:** Edge case. This is useful when building toolchains where one Claude Code instance needs to communicate with another, or when integrating Claude Code into a larger MCP-based system. Plugin MCP servers are unaffected by this feature.

## MCP `@` Resource Reference Syntax

Users can reference MCP resources inline using the `@` syntax:

```
@server-name:protocol://resource/path
```

### Common Patterns

| Syntax        | Example                                     |
| ------------- | ------------------------------------------- |
| File resource | `@filesystem:file:///path/to/file.txt`      |
| Database      | `@database:postgres://localhost/mydb/users` |
| GitHub        | `@github:https://github.com/user/repo`      |
| Custom        | `@myserver:custom://resource/id`            |

### Discovery

Type `@` in Claude Code to see available resources from connected MCP servers.

### Plugin Design Note

If your plugin's MCP server exposes resources, document the available resource URIs and protocols in your README. Users can then reference them with `@plugin-server:protocol://path`.

## Hook Agent Type Details

The `agent` hook type (covered briefly in the hook-development SKILL.md) spawns a full subagent for complex verification workflows.

For comprehensive coverage including configuration, behavior, supported events, when to use agent hooks, and detailed examples, see the hook-development skill's `references/advanced.md` file.

**Quick summary:** Agent hooks spawn a subagent with full tool access (Read, Bash, Grep, etc.) for multi-step verification. They're significantly slower (30-120 seconds) but more capable than command or prompt hooks. Only supported on `Stop` and `SubagentStop` events.

## Auto-Update Behavior

### Default Behavior

- **Official marketplaces:** Auto-update enabled by default
- **Third-party/local marketplaces:** Auto-update disabled by default

### Environment Variables

| Variable                        | Effect                                 |
| ------------------------------- | -------------------------------------- |
| `DISABLE_AUTOUPDATER=true`      | Disable all auto-updates               |
| `FORCE_AUTOUPDATE_PLUGINS=true` | Force auto-update for all marketplaces |

### Plugin Versioning Implications

- Use semantic versioning (`MAJOR.MINOR.PATCH`)
- Breaking changes should bump MAJOR version
- Users on auto-update receive MINOR/PATCH changes automatically
- Document breaking changes in CHANGELOG
- Consider pre-release versions (`2.0.0-beta.1`) for testing

## Plugin Caching

### How Caching Works

When a plugin is installed, Claude Code copies plugin content to a cache directory. Plugins run from the cache, not from their source location.

### Key Implications

1. **No `../` paths:** Plugins cannot reference files outside their directory via `../` — the cache copy doesn't include parent directories
2. **`${CLAUDE_PLUGIN_ROOT}` resolves to cache:** The variable points to the cached copy, not the source
3. **Symlinks are followed:** Symlinks within the plugin directory are resolved during the copy, so the target content is included

### Workarounds for External Files

If your plugin needs content from outside its directory:

- **Symlinks:** Create symlinks to external files within the plugin directory (followed during cache copy)
- **Restructure:** Move shared content into the plugin directory
- **Environment variables:** Reference external paths via environment variables, not file paths
- **MCP servers:** Use MCP tools to access external resources at runtime

### Cache Management

Users can clear the plugin cache:

```bash
rm -rf ~/.claude/plugins/cache
```

This forces re-caching on next session start.

## Plugin CLI Management Commands

Users manage plugins through CLI commands (or the `/plugin` interactive interface):

### Installation

```bash
# Install from marketplace
claude plugin install plugin-name@marketplace-name

# Installation scopes
claude plugin install plugin-name@marketplace --scope user     # Personal (default)
claude plugin install plugin-name@marketplace --scope project  # Team (in .claude/settings.json)
claude plugin install plugin-name@marketplace --scope local    # Personal project (gitignored)
```

### Management

```bash
# List installed plugins
claude plugin list

# Enable/disable without uninstalling
claude plugin enable plugin-name@marketplace
claude plugin disable plugin-name@marketplace

# Update to latest version
claude plugin update plugin-name@marketplace

# Remove completely
claude plugin uninstall plugin-name@marketplace
```

### Marketplace Management

```bash
# Add a marketplace
claude plugin marketplace add owner/repo                    # GitHub
claude plugin marketplace add https://gitlab.com/org/repo.git  # Git URL
claude plugin marketplace add ./local-path                  # Local

# List/update/remove
claude plugin marketplace list
claude plugin marketplace update marketplace-name
claude plugin marketplace remove marketplace-name
```

### Plugin Developer Note

Document the exact install command in your README:

```markdown
## Installation

\`\`\`bash
claude plugin install my-plugin@my-marketplace
\`\`\`
```

## Installation Scopes

Plugins can be installed at different scopes, affecting who has access:

| Scope     | Location                      | Shared    | Gitignored | Use Case                 |
| --------- | ----------------------------- | --------- | ---------- | ------------------------ |
| `user`    | `~/.claude/settings.json`     | No        | N/A        | Personal tools (default) |
| `project` | `.claude/settings.json`       | Yes (git) | No         | Team standards           |
| `local`   | `.claude/settings.local.json` | No        | Yes        | Personal project tools   |
| `managed` | System paths                  | Yes (MDM) | N/A        | Enterprise enforcement   |

### Scope Precedence

When the same plugin is configured at multiple scopes, local overrides project, which overrides user.

### Team Plugin Distribution

For team plugins, install at `project` scope and commit `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "my-plugin@my-marketplace": true
  }
}
```

Team members get the plugin when they clone the repo.

### Enterprise Plugin Control

Organizations can use managed settings to:

- **Allowlist marketplaces:** `strictKnownMarketplaces` restricts which marketplaces users can add
- **Force plugins:** Pre-configure required plugins via managed settings
- **Block plugins:** Prevent specific plugins from being installed

### Enterprise Hook and Permission Control

Managed settings can also restrict hook and permission rule sources:

| Setting                           | Effect                                                          |
| --------------------------------- | --------------------------------------------------------------- |
| `allowManagedPermissionRulesOnly` | Only managed permission rules apply; user/project rules ignored |
| `allowManagedHooksOnly`           | Only managed hooks execute; plugin/user hooks disabled          |

**Plugin developer implications:**

- Test plugins with these settings enabled to verify graceful degradation
- Document which hooks are critical for plugin functionality
- Provide fallback behavior when hooks are disabled by enterprise policy

### Plugin Developer Implications

- Document recommended scope in README
- Test plugin at both user and project scopes
- For team plugins, provide `.claude/settings.json` snippets
- Note that managed settings can override plugin availability
