
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

The manifest defines plugin metadata and configuration. Located at `.claude-plugin/plugin.json`:

### Required Fields

```json
{
  "name": "plugin-name"
}
```

**Name requirements:**

- Use kebab-case format (lowercase with hyphens)
- Must be unique across installed plugins
- No spaces or special characters
- Example: `code-review-assistant`, `test-runner`, `api-docs`

### Recommended Metadata

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief explanation of plugin purpose",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://example.com"
  },
  "homepage": "https://docs.example.com",
  "repository": "https://github.com/user/plugin-name",
  "license": "MIT",
  "keywords": ["testing", "automation", "ci-cd"]
}
```

**Version format**: Follow semantic versioning (MAJOR.MINOR.PATCH)
**Keywords**: Use for plugin discovery and categorization

### Component Path Configuration

Specify custom paths for components (supplements default directories):

```json
{
  "name": "plugin-name",
  "commands": "./custom-commands",
  "agents": ["./agents", "./specialized-agents"],
  "hooks": "./config/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

**Important**: Custom paths supplement defaults—they don't replace them. Components in both default directories and custom paths will load.

**Path rules:**

- Must be relative to plugin root
- Must start with `./`
- Cannot use absolute paths
- Support arrays for multiple locations

### User Configuration (userConfig)

Declare configurable values in `.claude-plugin/plugin.json` that users are prompted for when enabling the plugin:

```json
{
  "name": "plugin-name",
  "userConfig": {
    "api_endpoint": {
      "description": "Your team's API endpoint",
      "sensitive": false
    },
    "api_token": {
      "description": "API authentication token",
      "sensitive": true
    }
  }
}
```

**Storage:**

- Non-sensitive values: stored in `settings.json` under `pluginConfigs[<plugin-id>].options`
- Sensitive values (`sensitive: true`): stored in the system keychain (macOS) or `~/.claude/.credentials.json` elsewhere

**Accessing configured values:**

- In MCP/LSP server configs, hook commands, and skill/agent content: `${user_config.KEY}` (non-sensitive only)
- As environment variables in plugin subprocesses: `CLAUDE_PLUGIN_OPTION_<KEY>`

**Constraints:** Keychain storage has an approximately 2KB total limit for sensitive values. Keep sensitive values small.

## Component Organization

### Commands (Legacy)

> **Note:** The `commands/` directory is a legacy format. For new plugins, prefer `skills/<name>/SKILL.md` which supports progressive disclosure via `references/` and `examples/` subdirectories. Both formats are loaded identically by Claude Code.

Simple, user-invocable prompts stored as single `.md` files. Use when you don't need bundled resources. Both commands and skills are invoked via the Skill tool — commands are essentially simple skills.

**Location**: `commands/` directory
**Format**: Markdown files with YAML frontmatter
**Auto-discovery**: All `.md` files in `commands/` load automatically

**Example structure**:

```
commands/
├── review.md        # /review command
├── test.md          # /test command
└── deploy.md        # /deploy command
```

**File format**:

```markdown
name: command-name
description: Command description

Command implementation instructions...
```

**Usage**: Commands integrate as native slash commands in Claude Code

### Agents

**Location**: `agents/` directory
**Format**: Markdown files with YAML frontmatter
**Auto-discovery**: All `.md` files in `agents/` load automatically

**Example structure**:

```
agents/
├── code-reviewer.md
├── test-generator.md
└── refactorer.md
```

**File format**:

```markdown
description: Agent role and expertise
capabilities:
  - Specific task 1
  - Specific task 2

Detailed agent instructions and knowledge...
```

**Usage**: Users can invoke agents manually, or Claude Code selects them automatically based on task context

### Skills

**Location**: `skills/` directory with subdirectories per skill
**Format**: Each skill in its own directory with `SKILL.md` file
**Auto-discovery**: All `SKILL.md` files in skill subdirectories load automatically

**Example structure**:

```
skills/
├── api-testing/
│   ├── SKILL.md
│   ├── scripts/
│   │   └── test-runner.py
│   └── references/
│       └── api-spec.md
└── database-migrations/
    ├── SKILL.md
    └── examples/
        └── migration-template.sql
```

**SKILL.md format**:

```markdown
name: Skill Name
description: When to use this skill

Skill instructions and guidance...
```

**Tool restrictions** (optional): Skills can include `allowed-tools` in frontmatter to limit tool access:

```yaml
name: safe-reader
description: Read-only file access skill
allowed-tools: Read, Grep, Glob # Optional: restricts available tools
```

Use for read-only workflows, security-sensitive tasks, or limited-scope operations.

**Supporting files**: Skills can include scripts, references, examples, or assets in subdirectories

**Usage**: Claude Code autonomously activates skills based on task context matching the description

### Hooks

**Location**: `hooks/hooks.json` or inline in `plugin.json`
**Format**: JSON configuration defining event handlers
**Registration**: Hooks register automatically when plugin enables

**Example structure**:

```
hooks/
├── hooks.json           # Hook configuration
└── scripts/
    ├── validate.sh      # Hook script
    └── check-style.sh   # Hook script
```

**Configuration format**:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/validate.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Available events**: PreToolUse, PermissionRequest, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification

**Usage**: Hooks execute automatically in response to Claude Code events

### MCP Servers

**Location**: `.mcp.json` at plugin root or inline in `plugin.json`
**Format**: JSON configuration for MCP server definitions
**Auto-start**: Servers start automatically when plugin enables

**Example format**:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/servers/server.js"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

**Usage**: MCP servers integrate seamlessly with Claude Code's tool system

### LSP Servers

**Location**: Inline in `plugin.json` under `lspServers` field
**Format**: JSON configuration for Language Server Protocol servers
**Auto-start**: Servers start when files matching extensions are opened

**Example format**:

```json
{
  "lspServers": {
    "python": {
      "command": "pyright-langserver",
      "args": ["--stdio"],
      "extensionToLanguage": {
        ".py": "python",
        ".pyi": "python"
      }
    }
  }
}
```

**Usage**: LSP servers provide code intelligence (go-to-definition, find references, hover)

For detailed LSP configuration, see the `lsp-integration` skill.

### Output Styles

**Location**: `plugin.json` under `outputStyles` field, pointing to style files
**Format**: Path or array of paths to markdown style files
**Purpose**: Customize how Claude formats responses

**Example format (directory)**:

```json
{
  "outputStyles": "./styles/"
}
```

**Example format (array of paths)**:

```json
{
  "outputStyles": ["./styles/concise.md", "./styles/detailed.md"]
}
```

**Usage**: Plugins can define consistent output formatting for their domain. See `references/output-styles.md` for detailed style file format.

### Plugin Executables (bin/)

**Location**: `bin/` directory at plugin root
**Format**: Executable files (compiled binaries, scripts with shebang)
**Auto-discovery**: Executables in `bin/` can be invoked as bare commands from the Bash tool
**Added**: CC 2.1.91

**Example structure**:

```
plugin-name/
├── bin/
│   ├── my-tool           # Compiled binary
│   └── helper.sh         # Shell script with #!/bin/bash
```

**Usage**:

```bash
# In hooks, MCP servers, or when Claude uses Bash tool:
my-tool --flag value
helper.sh arg1 arg2
```

**Requirements**:

- Files must have execute permissions (`chmod +x`)
- Scripts must have proper shebang (`#!/bin/bash`, `#!/usr/bin/env python3`, etc.)
- Binaries must be compatible with target platform

**Use cases**:

- Ship compiled tools (formatters, linters, converters)
- Provide standalone utilities without requiring dependencies
- Bundle platform-specific binaries

## Portable Path References

### ${CLAUDE_PLUGIN_ROOT}

Use `${CLAUDE_PLUGIN_ROOT}` environment variable for all intra-plugin path references:

```json
{
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/run.sh"
}
```

**Why it matters**: Plugins install in different locations depending on:

- User installation method (marketplace, local, npm)
- Operating system conventions
- User preferences

**Where to use it**:

- Hook command paths
- MCP server command arguments
- Script execution references
- Resource file paths

**Never use**:

- Hardcoded absolute paths (`/Users/name/plugins/...`)
- Relative paths from working directory (`./scripts/...` in commands)
- Home directory shortcuts (`~/plugins/...`)

### Path Resolution Rules

**In manifest JSON fields** (hooks, MCP servers):

```json
"command": "${CLAUDE_PLUGIN_ROOT}/scripts/tool.sh"
```

**In component files** (commands, agents, skills):

```markdown
Reference scripts at: ${CLAUDE_PLUGIN_ROOT}/scripts/helper.py
```

**In executed scripts**:

```bash
#!/bin/bash
# ${CLAUDE_PLUGIN_ROOT} available as environment variable
source "${CLAUDE_PLUGIN_ROOT}/lib/common.sh"
```

## File Naming Conventions

### Component Files

**Commands**: Use kebab-case `.md` files

- `code-review.md` → `/code-review`
- `run-tests.md` → `/run-tests`
- `api-docs.md` → `/api-docs`

**Agents**: Use kebab-case `.md` files describing role

- `test-generator.md`
- `code-reviewer.md`
- `performance-analyzer.md`

**Skills**: Use kebab-case directory names

- `api-testing/`
- `database-migrations/`
- `error-handling/`

### Supporting Files

**Scripts**: Use descriptive kebab-case names with appropriate extensions

- `validate-input.sh`
- `generate-report.py`
- `process-data.js`

**Documentation**: Use kebab-case markdown files

- `api-reference.md`
- `migration-guide.md`
- `best-practices.md`

**Configuration**: Use standard names

- `hooks.json`
- `.mcp.json`
- `plugin.json`

## Auto-Discovery Mechanism

Claude Code automatically discovers and loads components:

1. **Plugin manifest**: Reads `.claude-plugin/plugin.json` when plugin enables
2. **Commands**: Scans `commands/` directory for `.md` files
3. **Agents**: Scans `agents/` directory for `.md` files
4. **Skills**: Scans `skills/` for subdirectories containing `SKILL.md`
5. **Hooks**: Loads configuration from `hooks/hooks.json` or manifest
6. **MCP servers**: Loads configuration from `.mcp.json` or manifest

**Discovery timing**:

- Plugin installation: Components register with Claude Code
- Plugin enable: Components become available for use
- No restart required: Changes take effect on next Claude Code session

**Override behavior**: Custom paths in `plugin.json` supplement (not replace) default directories

## Best Practices

### Organization

1. **Logical grouping**: Group related components together
   - Put test-related commands, agents, and skills together
   - Create subdirectories in `scripts/` for different purposes

2. **Minimal manifest**: Keep `plugin.json` lean
   - Only specify custom paths when necessary
   - Rely on auto-discovery for standard layouts
   - Use inline configuration only for simple cases

3. **Documentation**: Include README files
   - Plugin root: Overall purpose and usage
   - Component directories: Specific guidance
   - Script directories: Usage and requirements

### Naming

1. **Consistency**: Use consistent naming across components
   - If command is `test-runner`, name related agent `test-runner-agent`
   - Match skill directory names to their purpose

2. **Clarity**: Use descriptive names that indicate purpose
   - Good: `api-integration-testing/`, `code-quality-checker.md`
   - Avoid: `utils/`, `misc.md`, `temp.sh`

3. **Length**: Balance brevity with clarity
   - Commands: 2-3 words (`review-pr`, `run-ci`)
   - Agents: Describe role clearly (`code-reviewer`, `test-generator`)
   - Skills: Topic-focused (`error-handling`, `api-design`)

### Portability

1. **Always use ${CLAUDE_PLUGIN_ROOT}**: Never hardcode paths
2. **Test on multiple systems**: Verify on macOS, Linux, Windows
3. **Document dependencies**: List required tools and versions
4. **Avoid system-specific features**: Use portable bash/Python constructs

### Maintenance

1. **Version consistently**: Update version in plugin.json for releases
2. **Deprecate gracefully**: Mark old components clearly before removal
3. **Document breaking changes**: Note changes affecting existing users
4. **Test thoroughly**: Verify all components work after changes

## Common Patterns

### Minimal Plugin

Single command with no dependencies:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json    # Just name field
└── commands/
    └── hello.md       # Single command
```

### Full-Featured Plugin

Complete plugin with all component types:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/          # User-facing commands
├── agents/            # Specialized subagents
├── skills/            # Auto-activating skills
├── hooks/             # Event handlers
│   ├── hooks.json
│   └── scripts/
├── .mcp.json          # External integrations
└── scripts/           # Shared utilities
```

### Skill-Focused Plugin

Plugin providing only skills:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── skill-one/
    │   └── SKILL.md
    └── skill-two/
        └── SKILL.md
```

## Plugin Caching

Claude Code caches plugin content for performance. Understanding caching behavior helps with development and debugging.

### What Gets Cached

- Plugin manifest (plugin.json)
- Component files (commands, agents, skills)
- Configuration files (hooks.json, .mcp.json)

### Cache Invalidation

Cached content refreshes when:

- Claude Code session restarts
- Plugin is reinstalled or updated
- User runs `/plugins refresh` (if available)

### Why External Paths Fail

**Important:** Paths outside the plugin directory may not work reliably because:

1. **Security boundary** - Plugins are sandboxed to their directory
2. **Caching** - External paths aren't monitored for changes
3. **Portability** - External paths break on different machines

**Always use:**

- `${CLAUDE_PLUGIN_ROOT}` for paths within the plugin
- Bundled resources instead of external file references
- Environment variables for user-specific paths

### Development Workflow

During development, reload plugins by:

1. Exiting Claude Code
2. Making changes to plugin files
3. Restarting Claude Code

Or use `--plugin-dir` for testing without installation:

```bash
claude --plugin-dir /path/to/plugin
```

## Troubleshooting

**Component not loading**:

- Verify file is in correct directory with correct extension
- Check YAML frontmatter syntax (commands, agents, skills)
- Ensure skill has `SKILL.md` (not `README.md` or other name)
- Confirm plugin is enabled in Claude Code settings

**Path resolution errors**:

- Replace all hardcoded paths with `${CLAUDE_PLUGIN_ROOT}`
- Verify paths are relative and start with `./` in manifest
- Check that referenced files exist at specified paths
- Test with `echo $CLAUDE_PLUGIN_ROOT` in hook scripts

**Auto-discovery not working**:

- Confirm directories are at plugin root (not in `.claude-plugin/`)
- Check file naming follows conventions (kebab-case, correct extensions)
- Verify custom paths in manifest are correct
- Restart Claude Code to reload plugin configuration

**Plugin blocked by organization policy**:

- Organizations can block specific plugins via `managed-settings.json` (CC 2.1.85)
- Blocked plugins cannot be installed or enabled and are hidden from marketplace views
- If users report they can't find or install the plugin, check whether their organization has restricted it
- Plugin developers cannot override organization policies; work with the organization's admin to approve the plugin

**Plugin scripts failing with "Permission denied"**:

- Fixed in CC 2.1.86. Official marketplace plugin scripts previously failed with "Permission denied" on macOS/Linux (since CC 2.1.83)
- Ensure all executable scripts have proper permissions: `chmod +x scripts/*.sh`
- Include `#!/bin/bash` (or appropriate shebang) at the top of every script

**Conflicts between plugins**:

- Use unique, descriptive component names
- Namespace commands with plugin name if needed
- Document potential conflicts in plugin README
- Consider command prefixes for related functionality

## Runtime Contexts

Plugins behave differently in non-interactive environments:

- **Headless/CI mode** (`claude -p`): See `references/headless-ci-mode.md`
- **GitHub Actions**: See `references/github-actions.md`
- **Advanced topics** (caching, auto-update, keybindings): See `references/advanced-topics.md`

## Plugin Validation

```bash
claude plugin validate    # CLI validation
claude --debug            # Detailed logging
claude --verbose          # Additional debugging
```

Use `/plugins` in the TUI to view installed plugins and their status.

### Additional Source Types

```bash
claude plugin install npm-package-name
claude plugin install pip-package-name
```


## Additional Resources

### Reference Files

- **`references/component-patterns.md`** - Detailed patterns for each component type
- **`references/manifest-reference.md`** - Complete plugin.json field reference
- **`references/headless-ci-mode.md`** - Headless and CI mode behavior
- **`references/github-actions.md`** - GitHub Actions integration
- **`references/advanced-topics.md`** - Caching, auto-update, keybindings
- **`references/output-styles.md`** - Output style file format and examples

### Example Files

Working examples in `examples/`:

- **`minimal-plugin.md`** - Single command plugin structure
- **`standard-plugin.md`** - Typical plugin with multiple components
- **`advanced-plugin.md`** - Full-featured plugin with all component types
