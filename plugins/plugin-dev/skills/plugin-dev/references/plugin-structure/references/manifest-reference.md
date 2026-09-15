# Plugin Manifest Reference

Complete reference for `plugin.json` configuration.

## File Location

**Required path**: `.claude-plugin/plugin.json`

The manifest MUST be in the `.claude-plugin/` directory at the plugin root. Claude Code will not recognize plugins without this file in the correct location.

## Complete Field Reference

### Core Fields

#### name (required)

**Type**: String
**Format**: kebab-case
**Example**: `"test-automation-suite"`

The unique identifier for the plugin. Used for:

- Plugin identification in Claude Code
- Conflict detection with other plugins
- Command namespacing (optional)

**Requirements**:

- Must be unique across all installed plugins
- Use only lowercase letters, numbers, and hyphens
- No spaces or special characters
- Start with a letter
- End with a letter or number

**Validation**:

```javascript
/^[a-z][a-z0-9]*(-[a-z0-9]+)*$/;
```

**Examples**:

- ✅ Good: `api-tester`, `code-review`, `git-workflow-automation`
- ❌ Bad: `API Tester`, `code_review`, `-git-workflow`, `test-`

#### version

**Type**: String
**Format**: Semantic versioning (MAJOR.MINOR.PATCH)
**Example**: `"2.1.0"`
**Default**: `"0.1.0"` if not specified

Semantic versioning guidelines:

- **MAJOR**: Incompatible API changes, breaking changes
- **MINOR**: New functionality, backward-compatible
- **PATCH**: Bug fixes, backward-compatible

**Pre-release versions**:

- `"1.0.0-alpha.1"` - Alpha release
- `"1.0.0-beta.2"` - Beta release
- `"1.0.0-rc.1"` - Release candidate

**Examples**:

- `"0.1.0"` - Initial development
- `"1.0.0"` - First stable release
- `"1.2.3"` - Patch update to 1.2
- `"2.0.0"` - Major version with breaking changes

#### description

**Type**: String
**Length**: 50-200 characters recommended
**Example**: `"Automates code review workflows with style checks and automated feedback"`

Brief explanation of plugin purpose and functionality.

**Best practices**:

- Focus on what the plugin does, not how
- Use active voice
- Mention key features or benefits
- Keep under 200 characters for marketplace display

**Examples**:

- ✅ "Generates comprehensive test suites from code analysis and coverage reports"
- ✅ "Integrates with Jira for automatic issue tracking and sprint management"
- ❌ "A plugin that helps you do testing stuff"
- ❌ "This is a very long description that goes on and on about every single feature..."

### Metadata Fields

#### author

**Type**: Object
**Fields**: name (required), email (optional), url (optional)

```json
{
  "author": {
    "name": "Jane Developer",
    "email": "jane@example.com",
    "url": "https://janedeveloper.com"
  }
}
```

**Use cases**:

- Credit and attribution
- Contact for support or questions
- Marketplace display
- Community recognition

#### homepage

**Type**: String (URL)
**Example**: `"https://docs.example.com/plugins/my-plugin"`

Link to plugin documentation or landing page.

**Should point to**:

- Plugin documentation site
- Project homepage
- Detailed usage guide
- Installation instructions

**Not for**:

- Source code (use `repository` field)
- Issue tracker (include in documentation)
- Personal websites (use `author.url`)

#### repository

**Type**: String (URL)
**Example**: `"https://github.com/user/plugin-name"`

Source code repository location.

```json
{
  "repository": "https://github.com/user/plugin-name"
}
```

**Use cases**:

- Source code access
- Issue reporting
- Community contributions
- Transparency and trust

#### license

**Type**: String
**Format**: SPDX identifier
**Example**: `"MIT"`

Software license identifier.

**Common licenses**:

- `"MIT"` - Permissive, popular choice
- `"Apache-2.0"` - Permissive with patent grant
- `"GPL-3.0"` - Copyleft
- `"BSD-3-Clause"` - Permissive
- `"ISC"` - Permissive, similar to MIT
- `"UNLICENSED"` - Proprietary, not open source

**Full list**: <https://spdx.org/licenses/>

**Multiple licenses**:

```json
{
  "license": "(MIT OR Apache-2.0)"
}
```

#### keywords

**Type**: Array of strings
**Example**: `["testing", "automation", "ci-cd", "quality-assurance"]`

Tags for plugin discovery and categorization.

**Best practices**:

- Use 5-10 keywords
- Include functionality categories
- Add technology names
- Use common search terms
- Avoid duplicating plugin name

**Categories to consider**:

- Functionality: `testing`, `debugging`, `documentation`, `deployment`
- Technologies: `typescript`, `python`, `docker`, `aws`
- Workflows: `ci-cd`, `code-review`, `git-workflow`
- Domains: `web-development`, `data-science`, `devops`

### Component Path Fields

Each of these fields points at where a component type lives. Setting one changes whether the component's default directory is still scanned, and the answer differs per field:

| Field                   | Default location       | Setting the field                                                |
| ----------------------- | ---------------------- | ---------------------------------------------------------------- |
| `skills`                | `skills/`              | Loads alongside the default — the directory is still scanned      |
| `commands`              | `commands/`            | Replaces the default — the directory is not auto-loaded           |
| `agents`                | `agents/`              | Replaces the default — the directory is not auto-loaded           |
| `outputStyles`          | `output-styles/`       | Replaces the default — the directory is not auto-loaded           |
| `experimental.themes`   | `themes/`              | Replaces the default — the directory is not auto-loaded           |
| `experimental.monitors` | `monitors/monitors.json` | Replaces the default — the file is read only when omitted       |
| `hooks`                 | `hooks/hooks.json`     | Merges — every declared source combines with the default          |
| `mcpServers`            | `.mcp.json`            | Merges — every declared source combines with the default          |
| `lspServers`            | `.lsp.json`            | Merges — every declared source combines with the default          |

For a replacing field, list the default directory's own files alongside the new ones when you want both: `"commands": ["./commands/", "./extras/"]`.

#### skills

**Type**: String or Array of strings
**Default**: `["./skills"]`
**Example**: `"./custom-skills"`

Paths to directories containing skill definitions.

**Behavior**: Loads alongside the default `skills/` directory, which is always scanned. `skills` is the one component path field that adds rather than replaces. The exception: for a marketplace entry whose `source` resolves to the marketplace root, declaring specific subdirectories replaces the `skills/` scan.

**Root-Level Skills (CC 2.1.221):** Plugins can now use `"skills": "."` to load a root-level `SKILL.md` directly from the plugin root. This enables simpler single-skill plugin structures:

```json
{
  "name": "my-single-skill",
  "skills": "."
}
```

With this configuration, place `SKILL.md` at the plugin root instead of in a `skills/` subdirectory. Validation now suggests using the plugin root when a root-level `SKILL.md` is detected but the skills path doesn't include `"."`.

**Use cases:**

- Single-skill plugins where subdirectory structure is unnecessary
- Simpler plugin organization for focused plugins
- Reduced nesting for minimal plugins

#### commands

**Type**: String or Array of strings
**Default**: `["./commands"]`
**Example**: `"./cli-commands"`

Path to a command file or skill directory, relative to the plugin root — or an array of such paths. When set, the default `commands/` directory is not auto-loaded; list its files here too if you want both.

**Single path**:

```json
{
  "commands": "./custom-commands"
}
```

**Multiple paths**:

```json
{
  "commands": ["./commands", "./admin-commands", "./experimental-commands"]
}
```

**Behavior**: Replaces the default `commands/` auto-load — the directory is not auto-loaded once this field is set.

**Use cases**:

- Organizing commands by category
- Separating stable from experimental commands
- Loading commands from shared locations

#### agents

**Type**: String or Array of strings
**Default**: `["./agents"]`
**Example**: `"./agents/code-reviewer.md"`

Path to an agent file, relative to the plugin root — or an array of such paths. Directories are not accepted; each entry must point at an agent `.md` file. When set, the default `agents/` directory is not auto-loaded; list its files here too if you want both.

**Use cases**:

- Grouping agents by specialization
- Separating general-purpose from task-specific agents
- Loading agents from plugin dependencies

#### hooks

**Type**: String (path to JSON file) or Object (inline configuration)
**Default**: `"./hooks/hooks.json"`

Hook configuration location or inline definition.

**File path**:

```json
{
  "hooks": "./config/hooks.json"
}
```

**Inline configuration**:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Use cases**:

- Simple plugins: Inline configuration (< 50 lines)
- Complex plugins: External JSON file
- Multiple hook sets: Separate files for different contexts

#### mcpServers

**Type**: String (path to JSON file) or Object (inline configuration)
**Default**: `./.mcp.json`

MCP server configuration location or inline definition.

**File path**:

```json
{
  "mcpServers": "./.mcp.json"
}
```

**Inline configuration**:

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/servers/github-mcp.js"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Use cases**:

- Simple plugins: Single inline server (< 20 lines)
- Complex plugins: External `.mcp.json` file
- Multiple servers: Always use external file

#### lspServers

**Type**: Object, keyed by language
**Default**: none

LSP server configuration, keyed by language, providing go-to-definition, find-references, and hover for matching files.

**Inline configuration**:

```json
{
  "name": "my-plugin",
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

**Use cases**:

- Bundling a language server so plugin users get code intelligence without separate setup
- Configuring extension-to-language mapping for languages with multiple file extensions

See `../../lsp-integration/overview.md` for the full configuration reference, including the separate `.lsp.json` file format.

#### outputStyles

**Type**: String or Array of strings
**Default**: `["./output-styles"]`
**Example**: `"./styles"`

Path(s) to output style definition files or directories.

**Single path**:

```json
{
  "outputStyles": "./styles"
}
```

**Multiple paths**:

```json
{
  "outputStyles": ["./styles/default.md", "./styles/compact.md"]
}
```

**Behavior**: Replaces the default `output-styles/` auto-load — the directory is not auto-loaded once this field is set. List its files here too if you want both.

Output style files are markdown with YAML frontmatter (`name`, `description`, `keep-coding-instructions`). See `output-styles.md` for the complete frontmatter schema.

**Use cases**:

- Providing domain-specific formatting (e.g., concise code review output)
- Bundling multiple style options for users to choose from
- Offering specialized output modes for different workflows

### experimental (CC 2.1.129)

**Type**: Object

Experimental plugin components are declared under the `"experimental"` key in plugin.json. Three components live there: `themes`, `evals`, and `monitors`. Fields under `experimental` may change shape without a deprecation cycle.

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "experimental": {
    "themes": ["./themes/"],
    "evals": "evals",
    "monitors": "./monitors/monitors.json"
  }
}
```

Top-level `themes` and `monitors` also load, and `claude plugin validate` accepts them with a deprecation warning:

```text
themes: 'themes' is an experimental component; declare it under 'experimental.themes'
instead of at the top level. Top-level still loads for now but will be removed in a
future release.
```

Declare both under `experimental` so the plugin keeps working once the top-level form is removed.

#### experimental.themes

**Type**: String (path to a themes directory or file) or Array of such paths
**Default**: `["./themes"]`

Custom UI themes for Claude Code.

```json
{
  "experimental": {
    "themes": ["./themes/dark.json", "./themes/light.json"]
  }
}
```

**Behavior**: Replaces the default `themes/` auto-load — the directory is not auto-loaded once this field is set. List its files here too if you want both.

#### experimental.evals (CC 2.1.269)

**Type**: String (path to the eval case directory, relative to the plugin root) or Array of such paths
**Default**: `"evals"`

Directory of eval cases for the `claude plugin eval` harness. When an array is given, its first entry is the case directory.

```json
{
  "experimental": {
    "evals": "evals"
  }
}
```

`--eval-dir <dir>` overrides this per run. See [Plugin Eval](../../skill-development/references/skill-loading-and-runtime.md#plugin-eval-claude-plugin-eval--generally-available-cc-21269) for the case layout and grader types.

#### experimental.monitors

**Type**: String (path to a JSON file containing the monitors array) or Array of inline monitor objects
**Added**: CC 2.1.105 (top-level), CC 2.1.129 (under `experimental`)
**Default**: `"./monitors/monitors.json"`

Background watch scripts the host arms as persistent Monitor tasks. They run unsandboxed, at the same trust tier as hooks, and stream events as chat notifications without the model having to arm them.

**File path**:

```json
{
  "experimental": {
    "monitors": "./monitors/monitors.json"
  }
}
```

**Inline definitions**:

```json
{
  "experimental": {
    "monitors": [
      {
        "name": "build-watch",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/watch-build.sh",
        "description": "Reports build failures as they happen",
        "when": "always"
      }
    ]
  }
}
```

Each entry requires `name`, `command`, and `description`. `when` is optional and defaults to `"always"`, which arms the monitor at session start and on plugin reload; `"on-skill-invoke:<skill>"` arms it the first time that skill is dispatched. Monitor names must be unique within a plugin.

**Behavior**: Replaces the default `monitors/monitors.json` auto-load — that file is read only when the field is omitted. If the default file exists but cannot be read, the plugin reports the failure instead of silently skipping it (CC 2.1.268).

**Host-armed monitors run for the session lifetime.** A manifest monitor's process is kept alive by the host for as long as the session lasts, and the entry takes no timeout field — the schema is exactly `name`, `command`, `description`, and `when`. Do not build re-arm logic into a monitor script on the assumption that the host will let it expire.

This is the opposite of the model-armed **Monitor tool**, whose watches always carry a deadline (CC 2.1.271) and must be re-armed. That distinction matters when porting a watch between the two: see [Monitor tool deadlines](../../agent-development/references/advanced-agent-fields.md#tools-field-version-behaviors) for the tool-side rules.

**Important: Silence is NOT success.** Unlike hooks where no output means success, monitors must actively output events to the Monitor tool. A silent monitor provides no value — design monitors to regularly emit status updates or event notifications.

**When to use monitors vs hooks**:

| Use Case                     | Monitors | Hooks   |
| ---------------------------- | -------- | ------- |
| Long-running background task | ✅       | ❌      |
| Event-driven response        | ❌       | ✅      |
| File system watching         | ✅       | ❌      |
| Tool validation              | ❌       | ✅      |
| Streaming output             | ✅       | ❌      |

**Output format**: Each stdout line from a monitor command is delivered to the model as a task notification.

### defaultEnabled (CC 2.1.154)

**Type**: Boolean
**Default**: `true`

Specifies whether the plugin is enabled by default after installation:

```json
{
  "name": "my-plugin",
  "defaultEnabled": false
}
```

**Values:**

- `true` (default) — Plugin is enabled immediately after installation
- `false` — Plugin is installed but disabled; users must manually enable it via `/plugin` command

**Use cases for `defaultEnabled: false`:**

- Plugins with significant resource requirements
- Plugins that require configuration before use
- Optional extensions that users should explicitly opt into
- Plugins with security-sensitive capabilities that users should consciously enable

### userConfig

**Type**: Object

Declares user-configurable values in `.claude-plugin/plugin.json`. Each key is an option name; each value is an option definition.

```json
{
  "name": "plugin-name",
  "userConfig": {
    "API_ENDPOINT": {
      "type": "string",
      "title": "API endpoint",
      "description": "Base URL of your team API",
      "required": true,
      "default": "https://api.example.com"
    },
    "API_TOKEN": {
      "type": "string",
      "title": "API token",
      "description": "Token used to authenticate API calls",
      "required": true,
      "sensitive": true
    },
    "MAX_RESULTS": {
      "type": "number",
      "title": "Maximum results",
      "description": "How many results to request per call",
      "default": 20,
      "min": 1,
      "max": 100
    },
    "VERBOSE": {
      "type": "boolean",
      "title": "Verbose logging",
      "description": "Write detailed logs to stderr",
      "default": false
    },
    "WORKSPACE_DIR": {
      "type": "directory",
      "title": "Workspace directory",
      "description": "Directory the plugin scans for projects"
    },
    "CONFIG_FILE": {
      "type": "file",
      "title": "Config file",
      "description": "Path to an existing configuration file"
    },
    "WATCH_PATHS": {
      "type": "string",
      "title": "Watched paths",
      "description": "Paths the plugin watches for changes",
      "multiple": true,
      "default": ["src", "lib"]
    }
  }
}
```

**Option keys** must be valid identifiers — letters, digits, and underscore, with no leading digit (`^[A-Za-z_]\w*$`). They become `CLAUDE_PLUGIN_OPTION_<KEY>` environment variables, so uppercase names read best.

**Option fields:**

| Field | Type | Required | Meaning |
| --- | --- | --- | --- |
| `type` | `string`, `number`, `boolean`, `directory`, `file` | Yes | Type of the configuration value |
| `title` | string | Yes | Human-readable label shown in the config dialog |
| `description` | string | Yes | Help text shown beneath the field in the config dialog |
| `required` | boolean | No | When `true`, validation fails if the field is empty |
| `default` | string, number, boolean, or string array | No | Value used when the user provides nothing |
| `multiple` | boolean | No | For `string` type: accept an array of strings |
| `options` | string array | No | For `string` type: the only values the field takes. `/config` shows the field as a picker over them |
| `sensitive` | boolean | No | Masks dialog input and stores the value in secure storage instead of `settings.json` |
| `min` | number | No | Minimum value (`number` type only) |
| `max` | number | No | Maximum value (`number` type only) |

The option schema is strict: any key outside this table fails validation with `userConfig.<KEY>: Invalid input`. Omitting `type`, `title`, or `description` fails with `userConfig.<KEY>.<field>: Invalid input`.

**Constrained choices use `options`.** A `string` option that should accept only a fixed set of values declares them in `options`, and `/config` renders the field as a picker over that list instead of a free-text box:

```json
{
  "userConfig": {
    "LOG_LEVEL": {
      "type": "string",
      "title": "Log level",
      "description": "Verbosity of the plugin's own logging",
      "options": ["debug", "info", "warn", "error"],
      "default": "info"
    }
  }
}
```

A stored value outside the list counts as **unset** rather than raising a validation error — the plugin sees no `CLAUDE_PLUGIN_OPTION_<KEY>` variable at all, exactly as if the user had never configured it. Pair `options` with `default` so an out-of-list value falls back to something usable, and with `required: true` when the plugin cannot run without a valid choice.

**Accessing configured values:**

- In MCP/LSP server configs, hook commands, and skill/agent content: `${user_config.KEY}` (non-sensitive only)
- As environment variables in plugin subprocesses: `CLAUDE_PLUGIN_OPTION_<KEY>`

**Install-time behavior:** `claude plugin install` does not prompt for these values. Installation succeeds and prints `<N> userConfig option(s) not yet set — run /plugin configure <plugin> in Claude Code, or pass --config KEY=VALUE.` (with `(<M> required)` appended when some options are `required: true`). Until the options are set, the session has no `CLAUDE_PLUGIN_OPTION_*` variables at all — hooks and servers must handle their absence. For unattended installs, pass `--config KEY=VALUE` once per option:

```bash
claude plugin install my-plugin@my-marketplace \
  --config API_ENDPOINT=https://api.example.com \
  --config MAX_RESULTS=50
```

**Storage:**

- Non-sensitive values: `settings.json` under `pluginConfigs[<plugin-id>].options`
- Sensitive values (`sensitive: true`): the existing `Claude Code-credentials` keychain item (macOS) or `~/.claude/.credentials.json` elsewhere, keyed `pluginSecrets/<plugin>@<marketplace>/<KEY>` — not a separate keychain entry. Uninstalling the plugin clears its `pluginSecrets` entries.

> **CC 2.1.207 Breaking Change:** `pluginConfigs` are no longer read from project-level `.claude/settings.json`. Only user settings (`~/.claude/settings.json`), `--settings` flag, and managed settings are honored. Plugin developers should document this restriction and guide users to store configuration in user settings.

**Constraints:** Keychain storage has an approximately 2KB total limit for sensitive values. Keep sensitive values small.

### Plugin Environment Variables

Claude Code sets these variables for plugin hooks. Plugin MCP/LSP server configuration (`command`, `args`, `env`, `url`) expands `CLAUDE_PLUGIN_ROOT` and `CLAUDE_PLUGIN_DATA` only:

| Variable | Value |
| --- | --- |
| `CLAUDE_PLUGIN_ROOT` | The plugin's own directory — use it for every intra-plugin path |
| `CLAUDE_PLUGIN_DATA` | `~/.claude/plugins/data/<plugin>-<marketplace>`, a per-plugin state directory |
| `CLAUDE_PROJECT_DIR` | The project root the session runs in. Set for plugin hooks; not expanded in MCP/LSP server configuration |
| `CLAUDE_PLUGIN_OPTION_<KEY>` | One variable per `userConfig` option, holding its configured value. Absent until the option is set |

`CLAUDE_PLUGIN_DATA` is where a plugin keeps state that must survive across sessions — caches, databases, logs, counters. The directory is created when the plugin is installed and removed when it is uninstalled, so nothing inside it survives a reinstall. It is plugin-only: hooks declared in skill frontmatter receive `${CLAUDE_PLUGIN_ROOT}` but not `${CLAUDE_PLUGIN_DATA}`.

## Path Resolution

### Relative Path Rules

All paths in component fields must follow these rules:

1. **Must be relative**: No absolute paths
2. **Must start with `./`**: Indicates relative to plugin root
3. **Cannot use `../`**: No parent directory navigation
4. **Forward slashes only**: Even on Windows

**Examples**:

- ✅ `"./commands"`
- ✅ `"./src/commands"`
- ✅ `"./configs/hooks.json"`
- ❌ `"/Users/name/plugin/commands"`
- ❌ `"commands"` (missing `./`)
- ❌ `"../shared/commands"`
- ❌ `".\\commands"` (backslash)

### Resolution Order

When Claude Code loads components, the manifest decides which locations are scanned at all — see the table under "Component Path Fields" for the per-field rule.

1. **Replacing fields** (`commands`, `agents`, `outputStyles`, `experimental.themes`, `experimental.monitors`): only the paths named in the manifest are scanned. The matching default directory is skipped. For `commands`, `agents`, `outputStyles`, and `experimental.themes`, Claude Code reports the skipped directory as shadowed: `Plugin <name>: <dir>/ folder exists but is not auto-loaded because the manifest sets "<field>"`. `experimental.monitors` and `workflows` replace their default silently — no message names them.

2. **Adding field** (`skills`): the default `skills/` directory is scanned first, then every path named in the manifest.

3. **Merging fields** (`hooks`, `mcpServers`, `lspServers`): the default file is read and every declared source combines with it.

4. **Registration**: all discovered components register with no overwriting. Name conflicts cause errors.

## Validation

### Manifest Validation

Claude Code validates the manifest on plugin load:

**Syntax validation**:

- Valid JSON format
- No syntax errors
- Correct field types

**Field validation**:

- `name` field present and valid format
- `version` follows semantic versioning (if present)
- Paths are relative with `./` prefix
- URLs are valid (if present)

**Component validation**:

- Referenced paths exist
- Hook and MCP configurations are valid
- No circular dependencies

### Common Validation Errors

**Invalid name format**:

```json
{
  "name": "My Plugin" // ❌ Contains spaces
}
```

Fix: Use kebab-case

```json
{
  "name": "my-plugin" // ✅
}
```

**Absolute path**:

```json
{
  "commands": "/Users/name/commands" // ❌ Absolute path
}
```

Fix: Use relative path

```json
{
  "commands": "./commands" // ✅
}
```

**Missing ./ prefix**:

```json
{
  "hooks": "hooks/hooks.json" // ❌ No ./
}
```

Fix: Add ./ prefix

```json
{
  "hooks": "./hooks/hooks.json" // ✅
}
```

**Invalid version**:

```json
{
  "version": "1.0" // ❌ Not semantic versioning
}
```

Fix: Use MAJOR.MINOR.PATCH

```json
{
  "version": "1.0.0" // ✅
}
```

## Minimal vs. Complete Examples

### Minimal Plugin

Bare minimum for a working plugin:

```json
{
  "name": "hello-world"
}
```

Relies entirely on default directory discovery.

### Recommended Plugin

Good metadata for distribution:

```json
{
  "name": "code-review-assistant",
  "version": "1.0.0",
  "description": "Automates code review with style checks and suggestions",
  "author": {
    "name": "Jane Developer",
    "email": "jane@example.com"
  },
  "homepage": "https://docs.example.com/code-review",
  "repository": "https://github.com/janedev/code-review-assistant",
  "license": "MIT",
  "keywords": ["code-review", "automation", "quality", "ci-cd"]
}
```

### Complete Plugin

Full configuration with all features:

```json
{
  "name": "enterprise-devops",
  "version": "2.3.1",
  "description": "Comprehensive DevOps automation for enterprise CI/CD pipelines",
  "author": {
    "name": "DevOps Team",
    "email": "devops@company.com",
    "url": "https://company.com/devops"
  },
  "homepage": "https://docs.company.com/plugins/devops",
  "repository": "https://github.com/company/devops-plugin.git",
  "license": "Apache-2.0",
  "keywords": [
    "devops",
    "ci-cd",
    "automation",
    "kubernetes",
    "docker",
    "deployment"
  ],
  "commands": ["./commands", "./admin-commands"],
  "agents": [
    "./specialized-agents/kubernetes-expert.md",
    "./specialized-agents/security-auditor.md"
  ],
  "hooks": "./config/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

## Best Practices

### Metadata

1. **Always include version**: Track changes and updates
2. **Write clear descriptions**: Help users understand plugin purpose
3. **Provide contact information**: Enable user support
4. **Link to documentation**: Reduce support burden
5. **Choose appropriate license**: Match project goals

### Paths

1. **Use defaults when possible**: Minimize configuration
2. **Organize logically**: Group related components
3. **Document custom paths**: Explain why non-standard layout used
4. **Test path resolution**: Verify on multiple systems

### Maintenance

1. **Bump version on changes**: Follow semantic versioning
2. **Update keywords**: Reflect new functionality
3. **Keep description current**: Match actual capabilities
4. **Maintain changelog**: Track version history
5. **Update repository links**: Keep URLs current

### Distribution

1. **Complete metadata before publishing**: All fields filled
2. **Test on clean install**: Verify plugin works without dev environment
3. **Validate manifest**: Use validation tools
4. **Include README**: Document installation and usage
5. **Specify license file**: Include LICENSE file in plugin root
