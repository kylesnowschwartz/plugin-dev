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

```text
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
- Note that managed settings can override plugin availability

### Version Constraints via Managed Settings (CC 2.1.163)

Managed settings can enforce Claude Code version requirements:

```json
{
  "requiredMinimumVersion": "2.1.160",
  "requiredMaximumVersion": "2.2.0"
}
```

**Fields:**

- `requiredMinimumVersion` — Users must have at least this version
- `requiredMaximumVersion` — Users must have at most this version

**Use cases:**

- Ensuring plugins work with compatible Claude Code versions
- Enterprise environments requiring version consistency
- Plugins depending on features introduced in specific versions

## External Plugin Loading via Settings (CC 2.1.195)

External plugins specified via project settings (`.claude/settings.json`) no longer prompt for reinstall consent on each session. Once a user has consented to an external plugin, it loads automatically on subsequent sessions:

```json
{
  "plugins": [
    "/path/to/external/plugin"
  ]
}
```

**Behavior change:**

- First load: User is prompted to consent to the external plugin
- Subsequent loads: Plugin loads automatically without re-consent

**Security note:** This change makes external plugin management smoother while maintaining the initial consent requirement. Users should only add trusted plugin paths to their settings.

## Automatic Local Skill Loading (CC 2.1.157)

Skills placed in `.claude/skills/` directories load automatically without requiring marketplace installation or explicit plugin configuration. This enables a streamlined local development workflow:

```text
project/
└── .claude/
    └── skills/
        └── my-skill/
            └── SKILL.md    # Automatically discovered and loaded
```

**Benefits:**

- No marketplace publishing required for local skills
- Skills are immediately available in the project
- Simplifies plugin development iteration
- Works alongside installed marketplace plugins

**Precedence:** Local `.claude/skills/` are discovered at the Project level in the skill precedence hierarchy (Enterprise > Personal > Project > Plugin).

## Nested .claude/ Directory Precedence (CC 2.1.178)

When nested `.claude/` directories exist in a project (common in monorepos), the closest directory to the working location takes precedence for name collisions.

**Affected components:** Agents, Workflows, Output styles, Skills (via nested skill directory support).

**Example structure:**

```text
monorepo/
├── .claude/                    # Root-level configuration
│   ├── agents/
│   │   └── reviewer.md         # Root reviewer agent
│   └── workflows/
│       └── deploy.yml          # Root deploy workflow
├── apps/
│   └── web/
│       └── .claude/            # Nested configuration for apps/web
│           ├── agents/
│           │   └── reviewer.md # Web-specific reviewer (takes precedence here)
│           └── workflows/
│               └── deploy.yml  # Web-specific deploy (takes precedence here)
└── packages/
    └── api/
        └── .claude/            # Nested configuration for packages/api
            └── agents/
                └── reviewer.md # API-specific reviewer (takes precedence here)
```

**Behavior:**

- When working on files in `apps/web/`, the `apps/web/.claude/agents/reviewer.md` is used
- When working on files in `packages/api/`, the `packages/api/.claude/agents/reviewer.md` is used
- When working on root-level files, the root `.claude/agents/reviewer.md` is used

**Implications for plugins:**

- Plugin components are lowest precedence (after enterprise, personal, project, and nested project)
- Nested `.claude/` directories allow project-specific overrides of plugin behavior
- Monorepos can have different configurations per workspace without conflicts

## Caching Details

### What Gets Cached and Invalidation

Claude Code caches plugin content for performance. Cached content includes:

- Plugin manifest (plugin.json)
- Component files (commands, agents, skills)
- Configuration files (hooks.json, .mcp.json)

Cached content refreshes when:

- Claude Code session restarts
- Plugin is reinstalled or updated
- User runs `/reload-plugins`

### Dependency Auto-Install (CC 2.1.116)

`/reload-plugins` and background plugin auto-update now auto-install missing plugin dependencies from marketplaces you've already added. If a plugin declares dependencies on other plugins, they will be fetched automatically during refresh or auto-update cycles.

### Version Constraint Auto-Update (CC 2.1.119)

When a plugin depends on another plugin with a version constraint (e.g., `>=1.0.0`), the dependent plugin now auto-updates to the highest satisfying git tag rather than being locked to the original installation version. This ensures plugins stay up-to-date within compatible version ranges.

### Plugin Auto-Rename with Marketplace Mapping (CC 2.1.193)

When a plugin is renamed in its manifest and an associated marketplace entry maps the old name to the new name, Claude Code automatically updates the local plugin name. This enables smooth plugin rebranding without requiring users to manually uninstall and reinstall:

**Marketplace mapping example:**

```json
{
  "plugins": [
    {
      "name": "new-plugin-name",
      "previousNames": ["old-plugin-name"]
    }
  ]
}
```

**Behavior:**

- User has `old-plugin-name` installed
- Plugin author renames to `new-plugin-name` and adds `previousNames` mapping
- On next auto-update or `/reload-plugins`, Claude Code detects the rename
- Plugin is automatically updated to `new-plugin-name` locally

**Implications for plugin authors:**

- When renaming a plugin, add the old name to `previousNames` in the marketplace entry
- Users won't lose their plugin installation or settings
- Enables clean rebranding without disruption

### Why External Paths Fail

Paths outside the plugin directory may not work reliably because:

1. **Security boundary** — Plugins are sandboxed to their directory
2. **Caching** — External paths aren't monitored for changes
3. **Portability** — External paths break on different machines

**Always use:**

- `${CLAUDE_PLUGIN_ROOT}` for paths within the plugin
- Bundled resources instead of external file references
- Environment variables for user-specific paths

## Plugin Loading Options (CC 2.1.128-2.1.129)

Claude Code supports multiple ways to load plugins for development and distribution.

**Local directory:**

```bash
claude --plugin-dir /path/to/plugin
```

**ZIP archive (CC 2.1.128):**

```bash
claude --plugin-dir /path/to/plugin.zip
```

Zip archives are unpacked automatically. Useful for distributing self-contained plugin bundles.

**Remote URL (CC 2.1.129):**

```bash
claude --plugin-url https://example.com/plugin-archive.tar.gz
```

Fetches and loads plugins directly from URLs. Supports tar.gz and zip formats. Enables remote plugin distribution without requiring local installation or marketplace publishing.

## Safe Mode (CC 2.1.169)

The `--safe-mode` flag disables all customizations for troubleshooting:

```bash
claude --safe-mode
```

**What safe mode disables:**

- Plugin loading (all plugins are temporarily disabled)
- Custom skills and commands
- User hooks and MCP servers
- Custom settings overrides

**Use cases:**

- Debugging whether a plugin is causing issues
- Troubleshooting session problems
- Testing Claude Code behavior without customizations
- Isolating plugin conflicts

Safe mode is temporary for that session only — restarting normally restores all customizations.

## Security Settings

### Auto Mode Shell Classification (CC 2.1.193)

The `autoMode.classifyAllShell` setting controls how shell commands are classified in auto mode:

```json
{
  "autoMode": {
    "classifyAllShell": true
  }
}
```

**Behavior:**

- `false` (default) — Only potentially dangerous shell commands are classified by the auto mode classifier
- `true` — All shell commands are classified, providing stricter security at the cost of more classification calls

**Use cases:**

- High-security environments requiring review of all shell operations
- Enterprise deployments with strict command policies
- Debugging auto mode classification behavior

### Sandbox Credentials Setting (CC 2.1.187)

The `sandbox.credentials` setting controls Claude Code's access to credentials within sandboxed execution:

```json
{
  "sandbox": {
    "credentials": "none"
  }
}
```

**Values:**

- `"none"` — No credential access in sandboxed contexts
- `"keychain"` — Access to system keychain credentials
- `"env"` — Access to environment variable credentials

**Security implications:**

- Affects how plugins and hooks can access stored credentials
- Managed settings can enforce credential restrictions across an organization
- Stricter settings may break plugins that require credential access

### Sandbox Filesystem Setting (CC 2.1.216)

The `sandbox.filesystem.disabled` setting controls filesystem sandboxing:

```json
{
  "sandbox": {
    "filesystem": {
      "disabled": true
    }
  }
}
```

**Behavior:**

- `false` (default) — Filesystem sandboxing is enabled
- `true` — Filesystem sandboxing is disabled, allowing unrestricted file access

**Use cases:**

- Development environments requiring full filesystem access
- Enterprise settings where sandboxing interferes with workflows
- Troubleshooting sandboxing-related issues

**Security implications:** Disabling filesystem sandboxing reduces security isolation. Use cautiously and only when necessary.

### Sandbox Network Strict Allowlist (CC 2.1.219)

The `sandbox.network.strictAllowlist` setting enforces a strict network allowlist:

```json
{
  "sandbox": {
    "network": {
      "strictAllowlist": ["api.example.com", "cdn.example.com"]
    }
  }
}
```

**Behavior:**

- When set, only network connections to domains in the allowlist are permitted
- All other network connections are blocked
- Empty array blocks all network access

**Use cases:**

- Enterprise environments requiring strict network control
- Compliance requirements restricting external network access
- Security-sensitive deployments

**Implications for plugin developers:**

- Plugins that require network access may fail in strict allowlist environments
- Document any external network dependencies in your plugin's README
- Consider providing offline fallbacks for network-dependent features

## Cowork Plugin Format (CC 2.1.163)

Claude Code includes comprehensive Cowork plugin component format references for authoring plugins that integrate with the Cowork collaboration system.

**Documented components:**

- Skills schema and examples
- Agents schema and examples
- Hooks configuration
- MCP server integration
- Legacy command format
- CONNECTORS.md for external integrations
- README.md requirements
- Plugin packaging metadata

**Template types:**

- **Minimal plugin** — Single skill, basic structure
- **Standard plugin** — Multiple skills, hooks, README
- **Complex plugin** — Full-featured with agents, MCP servers, connectors

**MCP server discovery:** Cowork plugins support automatic MCP server discovery, allowing plugins to expose tools dynamically.

For detailed Cowork authoring guidance, use the `claude-code-guide` agent to query "Cowork plugin authoring" or "Cowork plugin schemas".

## Plugin Discovery and Management CLI Additions

### Plugin and Skill Discovery Tools (CC 2.1.199)

Claude Code includes built-in tools for discovering plugins and skills:

- **SearchPlugins** — Search org plugins by name, description, or keywords
- **SearchSkills** — Search available skills across installed plugins
- **SearchMcpRegistry** — Search MCP connector registries for available integrations
- **SuggestConnectors** — Get recommendations for connectors based on task context
- **ListConnectors** — List available MCP connectors

**Implications for plugin developers:**

- Plugins are discoverable through programmatic search, not just the marketplace UI
- Good plugin metadata (name, description, keywords) improves discoverability
- Skills should have clear, searchable descriptions
- Consider how your plugin appears in search results when writing descriptions

### Plugin Scaffolding (CC 2.1.157)

Create a new plugin with the recommended directory structure:

```bash
claude plugin init my-plugin
```

This scaffolds a new plugin in `.claude/skills/my-plugin/` with:

- `.claude-plugin/plugin.json` manifest
- Basic `SKILL.md` template
- Proper directory structure

**Use cases:** starting a new plugin from scratch, creating plugins with correct structure automatically, avoiding common structural mistakes.

### Plugin Pruning (CC 2.1.121)

Remove orphaned auto-installed dependencies after uninstalling plugins:

```bash
claude plugin prune
```

**Use case:** When you uninstall a plugin that had auto-installed dependencies, those dependencies may remain. Running `plugin prune` cleans up these orphaned dependencies to free disk space and reduce clutter.

### Plugin Install Improvements (CC 2.1.117)

- **Dependency handling**: `plugin install` now automatically handles missing dependencies, installing required plugins from configured marketplaces
- **Marketplace blocking enforced**: Plugins from blocked marketplaces (configured via `blockedMarketplaces` in managed settings) cannot be installed

### Plugin Immediate Activation (CC 2.1.221)

Plugins now **activate immediately when safe**, removing the previous requirement for `/reload-plugins` after installation:

- **Automatic activation**: When a plugin is installed and no conflicts or safety concerns exist, it becomes active immediately
- **No reload required**: Users no longer need to run `/reload-plugins` or restart Claude Code for newly installed plugins to take effect
- **Safe activation criteria**: Plugins activate immediately when they don't conflict with existing plugins, don't require user configuration, and pass validation

**Implications for plugin developers:**

- Plugin functionality is available faster after install
- Update any documentation that previously mentioned needing `/reload-plugins` after installation
- Plugins with `defaultEnabled: false` still require explicit user enablement via `/plugin`

### Additional Source Types

```bash
claude plugin install npm-package-name
claude plugin install pip-package-name
```
