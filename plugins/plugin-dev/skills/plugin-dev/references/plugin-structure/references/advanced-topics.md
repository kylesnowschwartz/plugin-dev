# Advanced Plugin Topics

This reference covers specialized topics that plugin developers may encounter in advanced use cases. Each section is self-contained.

## Function-Hook Plugins (Mods)

Function-hook plugins, which Claude Code calls **mods**, are plugins whose hooks are TypeScript/JavaScript functions instead of shell commands. A mod can draw a live pane, a band above the prompt, a status line entry, or a toast, and can block, rewrite, or react to tool calls and prompts. Its `hooks/hooks.json` holds `{ "modules": ["./register.tsx"] }`, naming a module that exports `register(on, options)`, instead of the event-keyed `hooks` object that command hooks use.

### Load the Built-in `plugin-authoring` Skill to Write or Debug a Mod

Claude Code ships the authoritative mod guidance as the `plugin-authoring` skill in the built-in plugin `cc-plugin-plugin-authoring`. Load it (the Skill tool, or `/plugin-authoring`) before writing, changing, or debugging a hooks module. This reference does not repeat its content, because the skill is generated for the running build and this file is not:

- **Types for this build.** Loading the skill writes `types/claude-code.d.ts` into the skill's extracted directory: every event's input and result, every `$` method with its doc comment, and every element's props. Once a mod has loaded, `<mod folder>/.claude-plugin/types/` holds the same declarations plus a `tsconfig.json` for `tsc -p <mod folder>`.
- **Hot reload.** Loading the skill is what starts Claude Code's watch on the session's mods folder. The first file written there asks the user whether to enable hot reloading for the session; only the user can answer. Without the skill loaded, Claude Code does not watch the folder, and a new mod loads only through `claude --plugin-dir <folder>`.
- **Working examples.** The skill's `examples/` folder holds complete modules for a pane, a band above the prompt, and a tool-call hook, each of which validates and type-checks on that build.
- **The long form.** The skill's `reference.md` covers the full event list, `ui.render`, `$.state` contracts, `session.append`, the `.catch` pattern for guarding hooks, dispatch time budgets, `$.tool.register` and `$.agent.register`, `claude plugin test`, and sharing a mod through a marketplace.

The skill does not load when `CLAUDE_CODE_ENTRYPOINT` is `local-agent`. A second built-in plugin, `cc-plugin-mods-guide`, ships beside it.

**A built-in mod (CC 2.1.287).** Claude Code ships one mod of its own, "You should know", in which a side agent watches the session and flags things the user or Claude might miss. Users turn it on with `/plugin enable cc-plugin-you-should-know@builtin` (first-party sessions with telemetry on).

### When to Use a Mod

**Consider a mod when:**

- Your plugin needs custom UI rendering (panes, bands, status line entries, toasts) beyond text output
- Hook logic is complex enough that shell commands become unwieldy
- You need direct access to session state beyond what env vars provide
- Hot reload during development is valuable

**Stick with declarative hooks.json when:**

- Simple validation or logging is sufficient
- Shell commands meet your needs
- You prefer not to write JavaScript/TypeScript
- Maximum portability across environments

Most plugins work well with declarative `hooks.json` configuration.

### Risks That Apply Across Plugin Types

**Rewriting tool input under auto mode.** A `tool.call` hook that rewrites a call's input with `next({ ...e, ... })` can leave the auto-mode classifier with no verdict, the same as a PreToolUse hook that returns `updatedInput`. See `../../hook-development/references/advanced.md`.

**Managed rules still apply (CC 2.1.289).** On managed machines, a managed deny or ask rule on a nested compound shell command holds even when a user-installed mod's `tool.call` hook approves the call.

### Version History

The `plugin-authoring` skill describes only the build it ships with. This history records when mod behavior changed, for authors who support older Claude Code versions.

- **CC 2.1.260-2.1.261:** function-hook plugins introduced; expanded in CC 2.1.267.
- **CC 2.1.267:** `.catch` handlers on hooks, one transcript notice per failing hook or module, and a debug-log line for every failure. Keyed boxes (`<Box key="...">`) scope hover styles to their subtree.
- **CC 2.1.268:** surfaces (`terminal`, `desktop`, `vscode`, `mobile`) support different element sets; a tree that does not validate falls back to Claude Code's own rendering.
- **CC 2.1.269:** the embedded plugin-development skill was removed from Claude Code's system prompts.
- **CC 2.1.283:** the module shape was reworked (element constructors come from `$.ui.resolve(e)`; the manifest declares no `experimental` field and no JSX runtime dependency), hot reload gained per-session user consent, and a "Plugin authoring" skill was bundled.
- **CC 2.1.284:** that skill moved out of the system prompts into the built-in plugin `cc-plugin-plugin-authoring`.
- **CC 2.1.287:** announced as "Claude Mods"; the built-in "You should know" mod shipped.
- **CC 2.1.288:** `$.ui.selection()` returns the text the user last selected in fullscreen mode. `claude plugin test` runs a mod's `*.test.ts` files (CC 2.1.288 fixed it reporting mods as turned off remotely after reading an out-of-date saved setting).
- **CC 2.1.289:** the `/plugin-types` command and its `.claude/types` output were removed; types come from the `plugin-authoring` skill. `agent.spawn` covers teammates, `$.agent.list()` reports idle and waiting states, and one agent id is used across plugin hook events. A mod's `Client` that fails while drawn fails alone and raises `ui.fault`.
- **CC 2.1.290:**
  - The `tool.check` event carries `agentId`, and its question and verdict carry `ceiling`, naming the approval an organization requires.
  - A `turn.step` hook result includes `serverToolUses`, the tool calls the API ran itself.
  - The typings add `ThemeKey` and `Color`.
  - `claude plugin validate` lists each gating hook with whether it has a `.catch` (`gatingHooks` under `--json`), and accepts a module that destructures an option named like one of its top-level functions.
  - A `prompt.submit` hook that calls `next(e)` and then denies or drops is reported as failed.
  - Long text from plugin hooks is clipped and logged rather than refused or dropped silently.
  - When another mod denies a `$.process.spawn` after the child ran, the call rejects saying so.
  - The skill has Claude give the one command another person runs to install a mod.
- **CC 2.1.292:**
  - `prompt.autocomplete` lets a mod add rows to the prompt box's autocomplete list.
  - `agent.spawn` covers workflow agents, with their run and index.
  - `$.model.complete` supports prompt caching through `cache: true` on a prompt or system block.
  - `config.set`, `state.set`, `env.set`, and `agent.spawn` hooks that call `next(e)` and then deny or drop are reported as failed. Decide before calling `next(e)`.
  - A `tool.check` hook answering allow does not skip the dialog of a tool that requires the user's answer.
  - `tool.call` hooks see arguments after misnamed parameters are repaired.
  - A prompt drop or setting deny reason longer than 4,096 characters is honored.
  - A module that reads a `$.state` value through a top-level `var` that is declared again or reassigned is refused.
  - A failed `expect` inside a test's hook, or a stub answer the engine refuses, fails the test.
- **CC 2.1.293:**
  - `$.tool.register` takes `isDeferred`; `false` lists the tool's schema in the prompt from the start instead of behind tool search.
  - `claude plugin test` works for mods that call `$.session.append`, and tests can read the appended rows back with the new `mock.session`.
  - A mod's hooks on `classic.*` events are no longer skipped while the plugin hooks worker restarts, which had left settings hooks to answer without them.
- **CC 2.1.295:**
  - `$.ui.notify` raises a native notification through the user's own notification setting and says which channel sent it.
  - A mod's `Button` takes children, strings and `Text`, so a list row can be one pressable with a chip or a dim detail inside.
  - A deeply nested tool input is no longer handed to a mod's hook cut short with no error, so a guard sees all of the content it checks.
  - Calls a mod makes while it reloads during a plugin hooks worker restart are refused, instead of getting past another mod's guard hook that has a `.catch`.
  - When a mod denies a tool call after the tool ran, Claude and the user read that the tool ran and a plugin withheld its result.
  - `/model`, `/fast`, `/output-style`, and the auto-update channel in `/config` ask a plugin's `config.set` hook before saving.
  - A prompt that a `prompt.submit` hook rewrote or dropped is no longer saved to prompt history as typed.
  - Cloud sessions no longer hang when a `session.receive` hook asks for permission before passing a message on.
  - `claude plugin test` fails a `session.append` hook that removes tool call, tool result, or thinking blocks that a real session keeps.
  - Toasts from the organization's mods show ahead of other mods' toasts.
  - A plugin that adds very large interfaces no longer gets another plugin unloaded when the plugin hooks worker stalls.
  - Generated type files are written only where a mod is being developed, not into a `--plugin-dir` plugin's folder in `-p` and SDK sessions.
  - A hooks module that nests code thousands of levels deep loads and validates instead of failing with a bare stack-overflow message. When a module is refused over a rebound top-level `var`, `claude plugin validate` and plugin loading name the line that rebinds it, the cause, and a fix.
  - The built-in `plugin-authoring` skill no longer tells a session with no terminal to run terminal commands, and explains sharing a mod only when asked.
- **CC 2.1.296:**
  - A plugin's served `$` methods run in the calling agent's working directory and respect the turn their calling hook holds, instead of using the main session's directory.
  - `$.agent.register` is refused from a mod's hook that is still running after the mod was reloaded or removed.
  - `$.http.fetch` accepts a `HEAD` request whose response declares a `Content-Length` over the 4 MiB body limit.
  - Esc or an interrupt during a mod's `prompt.submit` hook (or a `UserPromptSubmit` hook) no longer ends headless sessions, clears the typed prompt, or lets the unchecked prompt through.

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

### Per-Subagent Status Line

A separate `subagentStatusLine` setting (same `{"type": "command", "command": "..."}` shape) draws a custom status line for each subagent row in the agent panel. The script receives that row's context as JSON on stdin. Since CC 2.1.293 the payload includes `agentType`, so a script can tell custom subagent types apart, for example to label rows for a plugin's own agents differently from built-in ones. As with `statusLine`, the user configures it; a plugin can ship the script and document the setting.

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

The `agent` hook type spawns a full subagent for complex verification workflows.

For comprehensive coverage including configuration, behavior, supported events, when to use agent hooks, and detailed examples, see the hook-development topic (`../../hook-development/references/advanced.md`). The per-event Types column in `../../hook-development/overview.md` (Hook Events Reference) is the authoritative list of which hook types each event accepts.

**Quick summary:** Agent hooks spawn a subagent with full tool access (Read, Bash, Grep, etc.) for multi-step verification. They're significantly slower (30-120 seconds) but more capable than command or prompt hooks. Like prompt hooks, they need a live conversation, so the 20 events dispatched without one reject them. That covers every lifecycle, context, config, environment, worktree, MCP, display, notification, and model-switch event, plus `SubagentStart` and `StopFailure`. Of the 13 conversation events, `PermissionRequest` also refuses them at run time (CC 2.1.280), because an agent hook cannot return an allow or deny decision. The Types column linked above is the per-event list. Agent hooks are most useful on decision-control events such as `Stop` and `SubagentStop`.

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
3. **Symlinks inside the plugin only:** A symlink whose target is also inside the plugin directory is resolved during the copy, so the target content is included. A symlink that resolves outside the plugin root makes installation fail (see Path Traversal Security below)

### Workarounds for External Files

If your plugin needs content from outside its directory:

- **`${CLAUDE_PLUGIN_DATA}`:** Write state to `~/.claude/plugins/data/<plugin>-<marketplace>`, a per-plugin directory created on install and removed on uninstall. It is the only writable location a plugin owns; the plugin directory itself is a cache copy
- **Restructure:** Move shared content into the plugin directory
- **Environment variables:** Reference external paths via environment variables, not file paths
- **MCP servers:** Use MCP tools to access external resources at runtime

### Cache Management

Users can clear the plugin cache:

```bash
rm -rf ~/.claude/plugins/cache
```

This forces re-caching on next session start.

**No-version plugins are restored at the installed commit (CC 2.1.283).** When a plugin that declares no `version` has missing cached files, Claude Code restores it at the commit that was installed. Before CC 2.1.283 it silently restored the source's newest commit instead. Declaring `version` is still the reliable way to pin what users run.

## Plugin CLI Management Commands

Users manage plugins through CLI commands (or the `/plugin` interactive interface):

### Installation

```bash
# Install from marketplace
claude plugin install plugin-name@marketplace-name

# Add the marketplace if needed, then install from it (CC 2.1.292)
# Subject to the same policy checks as `claude plugin marketplace add`
claude plugin install plugin-name --marketplace owner/repo

# Installation scopes
claude plugin install plugin-name@marketplace --scope user     # Personal (default)
claude plugin install plugin-name@marketplace --scope project  # Team (in .claude/settings.json)
claude plugin install plugin-name@marketplace --scope local    # Personal project (gitignored)

# Set userConfig options during install (repeatable)
claude plugin install plugin-name@marketplace --config API_ENDPOINT=https://api.example.com --config MAX_RESULTS=50
```

Installing a plugin that declares `userConfig` does not prompt for the values. The install succeeds and prints `<N> userConfig option(s) not yet set — run /plugin configure <plugin> in Claude Code, or pass --config KEY=VALUE.`, and until they are set the session has no `CLAUDE_PLUGIN_OPTION_*` variables. `--config` is the unattended path at install time; `/plugin configure <plugin>` is the interactive one. After install, `claude plugin configure <plugin>` (CC 2.1.285) shows the plugin's options and which are unset, and `--values-stdin` saves values read from stdin. `--config <server>.<key>=<value>` (CC 2.1.285) sets a bundled `.mcpb` MCP server's own settings.

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

### Machine-Readable Output (CC 2.1.268)

`install`, `uninstall`, `update`, `enable`, and `disable` all accept `--json`. The last line of stdout is a single JSON object:

```bash
claude plugin install my-plugin@my-marketplace --json
```

```json
{
  "command": "install",
  "outcome": "success",
  "message": "Installed my-plugin@my-marketplace",
  "pluginId": "my-plugin@my-marketplace",
  "scope": "user"
}
```

On failure the object carries a `failureCode` alongside `outcome`. Because only the **last** line is guaranteed to be the JSON object, parse it with `tail -n 1` rather than feeding the whole stream to `jq`:

```bash
claude plugin install my-plugin@my-marketplace --json | tail -n 1 | jq -r '.outcome'
```

`claude plugin list --json` rows gained `errorDetails` and `noteDetails`, which surface load failures and advisory notes per plugin — useful for asserting a clean install in CI.

### Pinning a Marketplace-Declared Command (CC 2.1.271)

Some marketplaces declare a command Claude Code has to run on the user's machine: a **command source** produces the plugin directory by running a local command, and a `headersHelper` runs one to fetch the archive. Both prompt for approval, which makes them unattended-install blockers.

The old escape hatch was `-y`/`--yes`, which accepts whatever command the marketplace currently supplies — including one swapped in after review. `--accept-command <sha256>` replaces it with a pinned form:

```bash
# 1. See the command and its hash without running it
claude plugin install my-plugin@my-marketplace --json | tail -n 1 | jq -r '.shownCommand.sha256'

# 2. Install, accepting exactly that command
claude plugin install my-plugin@my-marketplace --accept-command 6f1e...c93a
claude plugin update my-plugin@my-marketplace --accept-command 6f1e...c93a
```

**Behavior:**

- Counts as `-y` for exactly the command whose sha256 is given, for that plugin and that marketplace catalog, and nothing else
- If the command changes, the install **fails** instead of silently running new code. A catalog refresh that moves the command counts as a change
- Required whenever stdin or stdout is not a TTY, which is every CI runner

**CI pattern:** record the hash during review, commit it next to the install command, and let the pipeline fail loudly when upstream changes what it wants to run. Prefer this over `-y` for any automated install of a command-backed source.

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

**CLI behavior changes (CC 2.1.295-2.1.296):**

- `claude plugin install`, `enable`, `disable`, and `marketplace add` warn when the settings file they write to does not load (CC 2.1.295)
- `claude plugin marketplace add` refuses a marketplace whose name no plugin can be installed under, instead of reporting success (CC 2.1.295). It also refuses names such as `constructor` clearly; before CC 2.1.296 those failed `add`, `marketplace update`, and `plugin install` with an internal error
- A marketplace repository with large git submodules adds and refreshes, because only the submodules that hold plugin files are fetched (CC 2.1.295)
- On Windows machines with no GitHub SSH key, installing from a GitHub `owner/repo` source retries the clone over HTTPS (CC 2.1.296)
- `/plugin`'s Errors tab asks before removing a marketplace that failed to load and uninstalling its plugins (CC 2.1.295)

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

- **Allowlist marketplaces:** `strictKnownMarketplaces` restricts which marketplaces users can add. It takes a **list** of approved entries, not a boolean
- **Force plugins:** Pre-configure required plugins via managed settings
- **Block plugins:** Prevent specific plugins from being installed

**Headless and Desktop coverage (CC 2.1.269):** Plugins enabled through managed settings previously failed to load in headless sessions and on Claude Desktop. They now load in both, from the next session onward — Desktop picks this up once it bundles a CLI at or above CC 2.1.269. A plugin distributed by enterprise policy can therefore be relied on in CI, not just in interactive terminal sessions.

**Tampered settings cache (CC 2.1.295):** a tampered cache of server-managed settings could make a person's own plugin count as organization-managed. Since CC 2.1.295 it no longer does, so organization-managed status comes only from the organization's real settings.

### Enterprise Hook and Permission Control

Managed settings can also restrict hook and permission rule sources:

| Setting                           | Effect                                                          |
| --------------------------------- | --------------------------------------------------------------- |
| `allowManagedPermissionRulesOnly` | Only managed permission rules apply; user/project rules ignored |
| `allowManagedHooksOnly`           | Only managed hooks execute; plugin/user hooks disabled          |

**`allowed-tools` does not pre-approve under `allowManagedPermissionRulesOnly` (CC 2.1.282).** With this managed setting on, repository, user, and `--add-dir` skills and commands, and skills-directory plugin manifests, no longer pre-approve their own tools through `allowed-tools`. Before CC 2.1.282 they still did. Their tool calls go through the managed permission rules like any other call.

**Plugins keep pre-approval only from official or vouched sources (CC 2.1.284).** Under the same setting, plugins from marketplaces, claude.ai, and npm no longer pre-approve their own tools through `allowed-tools`. Only plugins from an official Anthropic source, or from a source that managed settings vouch for, keep that pre-approval. Deny and ask rules still apply to every plugin. Under this policy, a plugin's README should list the permission rules an administrator needs to add.

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

### claude.ai-Synced Plugins (CC 2.1.295-2.1.296)

Fixes for plugins synced from claude.ai:

- A synced plugin is no longer disabled when the marketplace dependency it declares was also synced from claude.ai (CC 2.1.296)
- Synced plugin hooks no longer fail with "Plugin directory does not exist" in long-running sessions after another session synced a plugin update (CC 2.1.295)

A plugin distributed this way that declares a marketplace dependency should state the minimum Claude Code version, since older versions can leave it disabled.

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
- `${CLAUDE_PLUGIN_DATA}` for writable state the plugin keeps between sessions
- Bundled resources instead of external file references
- Environment variables for user-specific paths

## Plugin Loading Options (CC 2.1.128-2.1.129, expanded 2.1.265)

Claude Code supports multiple ways to load plugins for development and distribution.

**Local directory:**

```bash
claude --plugin-dir /path/to/plugin
```

**Plugin folder (CC 2.1.265):** The `--plugin-dir` flag now supports plugin folders — directories containing multiple plugins that are auto-loaded:

```bash
# Load all plugins in a directory
claude --plugin-dir /path/to/plugins-folder/

# Structure:
# plugins-folder/
# ├── plugin-a/
# │   └── .claude-plugin/plugin.json
# └── plugin-b/
#     └── .claude-plugin/plugin.json
```

This simplifies loading multiple plugins during development without specifying each one individually. Each child folder that holds a `.claude-plugin/plugin.json` is loaded.

**Folders that also hold a marketplace manifest (CC 2.1.281):** A folder of plugins that also has a `.claude-plugin/marketplace.json` now loads the plugins in it. Before CC 2.1.281 it loaded as one empty plugin instead. On older versions, point `--plugin-dir` at each plugin directory. Only direct child folders count, so a marketplace that keeps plugins under `plugins/<name>/` is loaded by pointing the flag at `plugins/`, not at the repository root.

**`claude plugin validate` on such a folder (CC 2.1.289):** When a directory holds both `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`, `claude plugin validate` checks the marketplace and also the plugin's manifest and component files. Before CC 2.1.289 it skipped the plugin, so validate the plugin directory on its own when supporting older versions.

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

### Archive Plugin Sources (CC 2.1.224)

Plugins can now be installed from HTTPS-hosted zip archives without requiring git or npm. This provides an alternative distribution mechanism for permanent installation (unlike `--plugin-url` which loads plugins temporarily at runtime).

**Features:**

- Install from any HTTPS-hosted zip archive
- Optional SHA-256 pinning for integrity verification
- No git or npm required on the target machine
- Archives are unpacked and cached locally

**Installation:**

```bash
claude plugin install https://example.com/my-plugin.zip
claude plugin install https://example.com/my-plugin.zip --sha256=abc123...
```

**Marketplace entry format:**

```json
{
  "name": "my-plugin",
  "source": {
    "source": "archive",
    "url": "https://releases.example.com/my-plugin-1.0.0.zip",
    "sha256": "abc123def456..."
  },
  "version": "1.0.0"
}
```

**Use cases:**

- Distributing plugins to environments without git access
- Air-gapped or restricted network installations
- Pinning exact plugin versions with cryptographic verification
- Simplified CI/CD plugin distribution

**Comparison with --plugin-url:**

| Feature | `--plugin-url` | Archive source |
|---------|----------------|----------------|
| Persistence | Session only | Permanent install |
| Cache | No | Yes |
| SHA-256 verification | No | Yes |
| Marketplace support | No | Yes |
| Use case | Testing/development | Production distribution |

**Extraction hardening (CC 2.1.269):** Archives extracted for a session are no longer readable by other local users, extracted files no longer keep world-writable permission bits carried in the archive, and stale files no longer survive a re-extraction. Two consequences for plugin authors publishing archives:

- Do not rely on permission bits set inside the archive. Scripts that must be executable should be invoked through an interpreter (`bash "${CLAUDE_PLUGIN_ROOT}/scripts/x.sh"`) rather than depending on the archived mode
- A re-extraction is now a clean replacement, so a file removed between releases is genuinely gone. Do not count on a stale file lingering from an earlier version

**Host config size limit on self-hosted runners (CC 2.1.271):** A self-hosted runner session whose host config directory exceeds **64 MiB** used to lose *all* host config — settings, skills, plugins, and MCP servers — with no error at all. The plugin simply was not there. This is fixed, and `--host-config-snapshot disk|memory` now controls how the snapshot is taken. Large plugins are the usual way a runner crosses that threshold, so keep bundled assets (vendored dependencies, model files, sample corpora) out of the plugin directory and fetch them at runtime instead. If plugins mysteriously fail to load on a self-hosted runner, check the host config directory size before anything else.

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
- `true` — All shell commands Claude itself runs are classified, providing stricter security at the cost of more classification calls

> **CC 2.1.271 — inline `[BANG]` commands are no longer classified.** A skill's or slash command's inline `[BANG]` shell commands bypass the classifier entirely in auto mode and follow **default-mode permission rules** instead, regardless of `classifyAllShell`. A command that no allow or deny rule decides runs as a reviewed tool call. Plugin authors gate inline `[BANG]` commands with ordinary `permissions.allow`/`permissions.deny` rules — reasoning about classifier behavior no longer describes what happens.

**Which classifier runs (CC 2.1.273).** On Bedrock, Vertex and Foundry, auto mode now uses the **local** classifier by default. Set `CLAUDE_CODE_AUTO_MODE_SERVER=1` to use the platform's server-side classifier instead. This changes *which* classifier renders the verdict, not *which* commands get classified — the `classifyAllShell` and inline `[BANG]` rules above are unaffected.

**Auto mode is the default starting mode (CC 2.1.283-2.1.285).** CC 2.1.283 made interactive sessions on third-party providers, or with telemetry off, start in auto mode when no permission mode is configured; the classifier choice above now governs interactive Bedrock, Vertex and Foundry sessions that leave the mode unset. CC 2.1.284 extended the default to interactive terminal and VS Code sessions on every plan and provider, and CC 2.1.285 to `claude -p` and Python Agent SDK sessions on third-party providers or with telemetry off. Before these releases, those sessions started in `default` (Manual) mode. A configured permission mode still takes precedence. Because auto mode is now the common case, a PreToolUse hook (or mod) that rewrites tool input can stop its own tool from running; see `../../hook-development/references/advanced.md`.

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

> **Per-command `allowed_domains` (CC 2.1.271).** Alongside this settings-level allowlist, Bash, PowerShell, and Monitor accept an `allowed_domains` **tool parameter** in sandboxed auto mode. The hosts a command declares are reviewed together with that command and opened for it alone; every other host is refused, and the grant does not carry to the next command. It is a tool parameter, not a settings key or a monitor manifest field — `experimental.monitors` entries take only `name`, `command`, `description`, and `when`. Agent and skill authors writing instructions around it should never widen the list because untrusted content asked them to.

**Use cases:**

- Enterprise environments requiring strict network control
- Compliance requirements restricting external network access
- Security-sensitive deployments

**Implications for plugin developers:**

- Plugins that require network access may fail in strict allowlist environments
- Document any external network dependencies in your plugin's README
- Consider providing offline fallbacks for network-dependent features

### Sandbox Confinement Claims (CC 2.1.268)

Claude Code's own Bash sandbox instructions were corrected to stop over-stating confinement. Two changes matter when writing plugin docs that describe what the sandbox guarantees:

- When filesystem isolation is **off**, no path allowlist is enforced. Earlier instructions named path lists that were not actually applied — do not repeat that framing in plugin documentation
- **Strict mode no longer claims commands can never run unsandboxed.** Treat the sandbox as a strong default, not an absolute guarantee, and keep security-relevant checks in your hooks rather than relying on sandbox confinement alone

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

### `/plugin` Menu Changes Apply on Close (CC 2.1.268)

CC 2.1.221 covered installation. CC 2.1.268 extends the same behavior to enable and disable: **installing, enabling or disabling a plugin through the `/plugin` menu takes effect when the menu closes.** `/reload-plugins` is not needed afterwards.

`/reload-plugins` is still a supported command and is still the right tool for changes the menu did not make:

- Editing plugin files on disk (`hooks/hooks.json`, skills, commands, agents) during development
- MCP server changes, which need the servers re-initialized

**Implications for plugin developers:** Do not tell users to run `/reload-plugins` after a menu toggle. Do keep it in your development-loop instructions, where files change outside the menu.

### Additional Source Types

```bash
claude plugin install npm-package-name
claude plugin install pip-package-name
```

**npm sources do not run install scripts (CC 2.1.275).** A plugin from an npm source is fetched with `npm pack --ignore-scripts` and integrity-verified, so `preinstall`, `install`, `postinstall`, and `prepare` scripts never run. Publish the plugin with everything it needs already in the package, such as built JavaScript and bundled binaries. Do not build or download files at install time. For work that must happen on the user's machine, use a `SessionStart` hook that writes into `${CLAUDE_PLUGIN_DATA}`.

**npm sources must be registry packages (CC 2.1.286).** Plugin installs refuse npm sources that are git repositories or folders, and install plugin dependencies only from registry packages. Publish the plugin, and any packages it depends on, to an npm registry; use a git or archive source for anything that is not published.

**Git LFS content is not downloaded (CC 2.1.274).** Plugin and marketplace clones leave Git LFS files as pointer files. Keep anything a plugin needs at runtime out of LFS, or tell users to run `git lfs pull` in the checkout.

**Version comes only from the plugin's own repository (CC 2.1.274).** A plugin or marketplace directory with no git repository of its own no longer takes its version from an enclosing git repository, such as a git-managed `~/.claude`. Set `version` in `plugin.json` for plugins distributed as plain directories.

## Path Traversal Security (CC 2.1.251)

Plugin installation now rejects plugin directories containing path traversal patterns:

**Rejected patterns:**

- Paths containing `..` segments (e.g., `skills/../../../etc/passwd`)
- Relative paths that escape the plugin directory
- Symlinks that resolve outside the plugin root

**Behavior:**

- Plugin installation fails with a clear error if path traversal is detected
- Existing plugins with path traversal patterns may fail validation on reload
- Affects all plugin sources: local directories, git, npm, and archive URLs

**Implications for plugin developers:**

- Audit plugin directory structure for any `..` path segments
- Ensure all skill, hook, and MCP server references use relative paths within the plugin
- Avoid symlinks that point outside the plugin directory
- Test plugin installation after any directory restructuring
