
# Plugin Settings Pattern for Claude Code Plugins

## Overview

Plugins can store user-configurable settings and state in `.claude/plugin-name.local.md` files within the project directory. This pattern uses YAML frontmatter for structured configuration and markdown content for prompts or additional context.

**Key characteristics:**

- File location: `.claude/plugin-name.local.md` in project root
- Structure: YAML frontmatter + markdown body
- Purpose: Per-project plugin configuration and state
- Usage: Read from hooks, commands, and agents
- Lifecycle: User-managed (not in git, should be in `.gitignore`)

## File Structure

### Basic Template

```markdown
---
enabled: true
setting1: value1
setting2: value2
numeric_setting: 42
list_setting: ["item1", "item2"]
---

# Additional Context

This markdown body can contain:

- Task descriptions
- Additional instructions
- Prompts to feed back to Claude
- Documentation or notes
```

### Example: Plugin State File

**.claude/my-plugin.local.md:**

```markdown
---
enabled: true
strict_mode: false
max_retries: 3
notification_level: info
coordinator_session: team-leader
---

# Plugin Configuration

This plugin is configured for standard validation mode.
Contact @team-lead with questions.
```

## Reading Settings Files

### From Hooks (Bash Scripts)

#### Pattern: Check existence and parse frontmatter

```bash
#!/bin/bash
set -euo pipefail

# Define state file path
STATE_FILE=".claude/my-plugin.local.md"

# Quick exit if file doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0  # Plugin not configured, skip
fi

# Parse YAML frontmatter (between --- markers)
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")

# Extract individual fields
ENABLED=$(echo "$FRONTMATTER" | grep '^enabled:' | sed 's/enabled: *//' | sed 's/^"\(.*\)"$/\1/')
STRICT_MODE=$(echo "$FRONTMATTER" | grep '^strict_mode:' | sed 's/strict_mode: *//' | sed 's/^"\(.*\)"$/\1/')

# Check if enabled
if [[ "$ENABLED" != "true" ]]; then
  exit 0  # Disabled
fi

# Use configuration in hook logic
if [[ "$STRICT_MODE" == "true" ]]; then
  # Apply strict validation
  # ...
fi
```

See `examples/read-settings-hook.sh` for complete working example.

### From Commands

Commands can read settings files to customize behavior:

```markdown
---
description: Process data with plugin
allowed-tools: Read, Bash
---

# Process Command

Steps:

1. Check if settings exist at `.claude/my-plugin.local.md`
2. Read configuration using Read tool
3. Parse YAML frontmatter to extract settings
4. Apply settings to processing logic
5. Execute with configured behavior
```

### From Agents

Agents can reference settings in their instructions:

```markdown
---
name: configured-agent
description: Agent that adapts to project settings
---

Check for plugin settings at `.claude/my-plugin.local.md`.
If present, parse YAML frontmatter and adapt behavior according to:

- enabled: Whether plugin is active
- mode: Processing mode (strict, standard, lenient)
- Additional configuration fields
```

## Parsing Techniques

### Extract Frontmatter

```bash
# Extract everything between --- markers
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$FILE")
```

### Read Individual Fields

**String fields:**

```bash
VALUE=$(echo "$FRONTMATTER" | grep '^field_name:' | sed 's/field_name: *//' | sed 's/^"\(.*\)"$/\1/')
```

**Boolean fields:**

```bash
ENABLED=$(echo "$FRONTMATTER" | grep '^enabled:' | sed 's/enabled: *//')
# Compare: if [[ "$ENABLED" == "true" ]]; then
```

**Numeric fields:**

```bash
MAX=$(echo "$FRONTMATTER" | grep '^max_value:' | sed 's/max_value: *//')
# Use: if [[ $MAX -gt 100 ]]; then
```

### Read Markdown Body

Extract content after second `---`:

```bash
# Get everything after closing ---
BODY=$(awk '/^---$/{i++; next} i>=2' "$FILE")
```

## Common Patterns

### Pattern 1: Temporarily Active Hooks

Use settings file to control hook activation:

```bash
#!/bin/bash
STATE_FILE=".claude/security-scan.local.md"

# Quick exit if not configured
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

# Read enabled flag
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")
ENABLED=$(echo "$FRONTMATTER" | grep '^enabled:' | sed 's/enabled: *//')

if [[ "$ENABLED" != "true" ]]; then
  exit 0  # Disabled
fi

# Run hook logic
# ...
```

**Use case:** Enable/disable hooks without editing hooks.json (requires restart).

### Pattern 2: Agent State Management

Store agent-specific state and configuration:

**.claude/multi-agent-swarm.local.md:**

```markdown
---
agent_name: auth-agent
task_number: 3.5
pr_number: 1234
coordinator_session: team-leader
enabled: true
dependencies: ["Task 3.4"]
---

# Task Assignment

Implement JWT authentication for the API.

**Success Criteria:**

- Authentication endpoints created
- Tests passing
- PR created and CI green
```

Read from hooks to coordinate agents:

```bash
AGENT_NAME=$(echo "$FRONTMATTER" | grep '^agent_name:' | sed 's/agent_name: *//')
COORDINATOR=$(echo "$FRONTMATTER" | grep '^coordinator_session:' | sed 's/coordinator_session: *//')

# Send notification to coordinator
tmux send-keys -t "$COORDINATOR" "Agent $AGENT_NAME completed task" Enter
```

### Pattern 3: Configuration-Driven Behavior

**.claude/my-plugin.local.md:**

```markdown
---
validation_level: strict
max_file_size: 1000000
allowed_extensions: [".js", ".ts", ".tsx"]
enable_logging: true
---

# Validation Configuration

Strict mode enabled for this project.
All writes validated against security policies.
```

Use in hooks or commands:

```bash
LEVEL=$(echo "$FRONTMATTER" | grep '^validation_level:' | sed 's/validation_level: *//')

case "$LEVEL" in
  strict)
    # Apply strict validation
    ;;
  standard)
    # Apply standard validation
    ;;
  lenient)
    # Apply lenient validation
    ;;
esac
```

## Creating Settings Files

### From Commands

Commands can create settings files:

```markdown
# Setup Command

Steps:

1. Ask user for configuration preferences
2. Create `.claude/my-plugin.local.md` with YAML frontmatter
3. Set appropriate values based on user input
4. Inform user that settings are saved
5. Remind user to restart Claude Code for hooks to recognize changes
```

### Template Generation

Provide template in plugin README:

```markdown
## Configuration

Create `.claude/my-plugin.local.md` in the project:

## \`\`\`markdown

enabled: true
mode: standard
max_retries: 3

---

# Plugin Configuration

Settings are active.
\`\`\`

After creating or editing, restart Claude Code for changes to take effect.
```

## Best Practices

### File Naming

✅ **DO:**

- Use `.claude/plugin-name.local.md` format
- Match plugin name exactly
- Use `.local.md` suffix for user-local files

❌ **DON'T:**

- Use different directory (not `.claude/`)
- Use inconsistent naming
- Use `.md` without `.local` (might be committed)

### Gitignore

Always add to `.gitignore`:

```gitignore
.claude/*.local.md
.claude/*.local.json
```

Document this in plugin README.

### Defaults

Provide sensible defaults when settings file doesn't exist:

```bash
if [[ ! -f "$STATE_FILE" ]]; then
  # Use defaults
  ENABLED=true
  MODE=standard
else
  # Read from file
  # ...
fi
```

### Validation

Validate settings values:

```bash
MAX=$(echo "$FRONTMATTER" | grep '^max_value:' | sed 's/max_value: *//')

# Validate numeric range
if ! [[ "$MAX" =~ ^[0-9]+$ ]] || [[ $MAX -lt 1 ]] || [[ $MAX -gt 100 ]]; then
  echo "⚠️  Invalid max_value in settings (must be 1-100)" >&2
  MAX=10  # Use default
fi
```

### Restart Requirement

**Important:** Settings changes require Claude Code restart.

Document in the plugin README:

```markdown
## Changing Settings

After editing `.claude/my-plugin.local.md`:

1. Save the file
2. Exit Claude Code
3. Restart: `claude`
4. New settings will be loaded
```

Plugin hooks refresh within a session — run `/reload-plugins` after editing `hooks/hooks.json`. Hooks declared in `settings.json` load at session start and need a restart.

## Security Considerations

### Sanitize User Input

When writing settings files from user input:

```bash
# Escape quotes in user input
SAFE_VALUE=$(echo "$USER_INPUT" | sed 's/"/\\"/g')

# Write to file
cat > "$STATE_FILE" <<EOF
---
user_setting: "$SAFE_VALUE"
---
EOF
```

### Validate File Paths

If settings contain file paths:

```bash
FILE_PATH=$(echo "$FRONTMATTER" | grep '^data_file:' | sed 's/data_file: *//')

# Check for path traversal
if [[ "$FILE_PATH" == *".."* ]]; then
  echo "⚠️  Invalid path in settings (path traversal)" >&2
  exit 2
fi
```

### Permissions

Settings files should be:

- Readable by user only (`chmod 600`)
- Not committed to git
- Not shared between users

### Component Names in Telemetry (`OTEL_LOG_TOOL_DETAILS`)

`OTEL_LOG_TOOL_DETAILS=1` is an opt-in that adds tool detail to OpenTelemetry output. As of **CC 2.1.273** it also includes real **agent, skill, plugin and MCP server names** on cost and token metrics.

Plugin authors shipping into an enterprise should know that with this opt-in set, the plugin's name, its skills' names, and its MCP servers' names reach the telemetry backend. If any of those names are themselves sensitive — an internal project codename, a customer name — say so in the plugin's deployment documentation so operators can decide whether to enable the flag.

## Real-World Examples

### multi-agent-swarm Plugin

**.claude/multi-agent-swarm.local.md:**

```markdown
---
agent_name: auth-implementation
task_number: 3.5
pr_number: 1234
coordinator_session: team-leader
enabled: true
dependencies: ["Task 3.4"]
additional_instructions: Use JWT tokens, not sessions
---

# Task: Implement Authentication

Build JWT-based authentication for the REST API.
Coordinate with auth-agent on shared types.
```

**Hook usage (agent-stop-notification.sh):**

- Checks if file exists (line 15-18: quick exit if not)
- Parses frontmatter to get coordinator_session, agent_name, enabled
- Sends notifications to coordinator if enabled
- Allows quick activation/deactivation via `enabled: true/false`

### ralph-wiggum Plugin

**.claude/ralph-loop.local.md:**

```markdown
---
iteration: 1
max_iterations: 10
completion_promise: "All tests passing and build successful"
---

Fix all the linting errors in the project.
Make sure tests pass after each fix.
```

**Hook usage (stop-hook.sh):**

- Checks if file exists (line 15-18: quick exit if not active)
- Reads iteration count and max_iterations
- Extracts completion_promise for loop termination
- Reads body as the prompt to feed back
- Updates iteration count on each loop

## Quick Reference

### File Location

```
project-root/
└── .claude/
    └── plugin-name.local.md
```

### Frontmatter Parsing

```bash
# Extract frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$FILE")

# Read field
VALUE=$(echo "$FRONTMATTER" | grep '^field:' | sed 's/field: *//' | sed 's/^"\(.*\)"$/\1/')
```

### Body Parsing

```bash
# Extract body (after second ---)
BODY=$(awk '/^---$/{i++; next} i>=2' "$FILE")
```

### Quick Exit Pattern

```bash
if [[ ! -f ".claude/my-plugin.local.md" ]]; then
  exit 0  # Not configured
fi
```

## Memory & Rules Context

### Settings Scope Precedence

Settings follow precedence: Managed > CLI flags > Local (`.claude/settings.local.json`) > Project (`.claude/settings.json`) > User (`~/.claude/settings.json`). Plugin hooks and MCP servers are merged across scopes, not replaced. A plugin-settings `.local.md` file is separate from this system -- it's a custom per-project state file your plugin reads directly.

### Plugin Option Values Scope Restriction (CC 2.1.207)

**Breaking change:** `pluginConfigs` are no longer read from project-level `.claude/settings.json`. Only these sources are honored:

- **User settings** (`~/.claude/settings.json`)
- **CLI `--settings` flag** (explicit settings file)
- **Managed settings** (organization policy)

**Migration required:** If you or your plugin's users stored `pluginConfigs.<plugin-id>.options` in project-level `.claude/settings.json`, those values must be moved to user settings (`~/.claude/settings.json`) or specified via `--settings`.

**Rationale:** This change prevents project-level configuration from overriding security-sensitive plugin options that should be user-controlled.

**Unaffected:** Plugin `.local.md` state files (the pattern documented above) are not affected by this change — they are read directly by plugin hooks and are not part of the `pluginConfigs` system.

### syncClaudeAiPlugins Setting (CC 2.1.246)

The `syncClaudeAiPlugins` setting controls whether plugins are synchronized from Claude.ai:

```json
{
  "syncClaudeAiPlugins": false
}
```

**Behavior when set to `false`:**

- Stops downloading plugins from Claude.ai
- Hides or trashes previously synced plugins according to the settings scope
- Affects plugins installed via the Claude.ai web interface

**Scope behavior:**

- **User settings** — affects all projects for the user
- **Project settings** — affects only that project
- **Managed settings** — enforced across the organization

**Implications for plugin developers:**

- Users may disable Claude.ai plugin sync for security or compliance reasons
- Plugins distributed via other channels (marketplace, direct URL) are not affected
- Document alternative installation methods if targeting environments where sync may be disabled

> **CC 2.1.273:** Signing in with a Claude account now also requests access to your claude.ai plugins. This is an OAuth scope change on the sync path; it changes nothing a plugin author authors.

### syncClaudeAiSkills Setting

Skills synced from claude.ai have their **own** control, separate from `syncClaudeAiPlugins`:

```json
{
  "syncClaudeAiSkills": false
}
```

**Behavior when set to `false`:**

- Turns off syncing of the skills enabled on claude.ai
- Previously synced skills are moved to `~/.claude/skills/.trash` at the next launch — recoverable, not deleted

A `CLAUDE_CODE_SYNC_SKILLS` environment variable also exists.

> **CC 2.1.273:** Skills synced from claude.ai previously stayed available after an organization turned Skills off. They now move to the same recoverable trash.

**Implications for plugin developers:** skills reaching a user through claude.ai sync can disappear from a session when an org policy changes, independently of anything in the plugin manifest. Do not assume a synced skill your plugin's docs reference will be present. Skills that ship inside a plugin are unaffected — they are installed with the plugin, not synced.

Still undocumented upstream: exactly how an organization turns Skills off, and whether that org toggle is the same control as `syncClaudeAiSkills`.

Plugin settings files (`.local.md`) exist alongside Claude Code's broader memory and rules system. Understanding how CLAUDE.md imports, `.claude/rules/` path-specific rules, and the memory priority hierarchy interact with plugin content helps design plugins that complement rather than conflict with user configurations.

See `references/memory-rules-system.md` for the full priority hierarchy, import syntax, and design implications.

### Bash and Task Output Character Limits (CC 2.1.261)

CC 2.1.261 added two settings for the maximum output size of Bash commands and Task tool results. Only `bashOutputMaxChars` still has an effect:

```json
{
  "bashOutputMaxChars": 65536
}
```

**Settings:**

- **`bashOutputMaxChars`** — Maximum characters returned from Bash tool output (up to 128K)
- **`taskOutputMaxChars`** — **No effect since CC 2.1.277.** It capped output read back through the TaskOutput tool, which CC 2.1.277 removed. Claude now reads a background task's output file with the Read tool. The setting is still accepted so existing files keep loading, and the `TASK_MAX_OUTPUT_LENGTH` environment variable is likewise inert. Remove both from plugin setup instructions.

**Default behavior:** Without these settings, output is truncated at 30K characters.

**Use cases:**

- Plugins that need verbose tool output for analysis (large log files, extensive test output)
- Workflows that aggregate output from multiple sources
- Debugging plugins that process large data sets

**Plugin author guidance:**

- Document if your plugin requires increased output limits
- Consider whether users need to configure these settings for your plugin to work effectively
- For hooks processing Bash output, be aware that larger outputs may increase processing time

### Maximum Effort Level Setting (CC 2.1.267)

The `maxEffortLevel` setting caps the effort level (thinking budget) across all providers:

```json
{
  "maxEffortLevel": "medium"
}
```

**Values:** Standard effort levels (`low`, `medium`, `high`, `xhigh`).

**Behavior:**

- Prevents Claude from using higher effort levels than specified, regardless of task complexity
- Applies across all providers (Anthropic, third-party integrations)
- Useful for cost control in environments where high effort levels are expensive

**Use cases:**

- Cost-conscious deployments that want to cap thinking budget
- Enterprise environments with budget constraints
- Testing and development where maximum thinking isn't needed

**Plugin author guidance:**

- If your plugin performs tasks that benefit from extended thinking, document that users may need to adjust `maxEffortLevel`
- Hooks that read `$CLAUDE_EFFORT` may see capped values when this setting is active
- Consider providing guidance on recommended effort levels for your plugin's workflows

### Time Display Settings (CC 2.1.257)

Two new settings control how time is displayed in Claude Code:

```json
{
  "timeFormat": "24h",
  "timeZone": "America/New_York"
}
```

**`timeFormat` values:**

- `"auto"` — Automatic detection based on locale
- `"12h"` — 12-hour format with AM/PM
- `"24h"` — 24-hour format
- `"24h-utc"` — 24-hour format in UTC
- Custom `strftime` format string — e.g., `"%Y-%m-%d %H:%M:%S"`

**`timeZone` values:**

- Any valid IANA timezone identifier (e.g., `"America/New_York"`, `"Europe/London"`, `"Asia/Tokyo"`)

**Implications for plugin developers:**

- Plugins that display timestamps should respect these user preferences when possible
- Hooks that log timestamps can reference `$TZ` or read from settings
- Document any timezone-sensitive behavior in your plugin

### CLAUDE.md Best Practices and /doctor Trimming (CC 2.1.206)

The `/doctor` command includes a check that suggests trimming verbose CLAUDE.md files. When creating CLAUDE.md files for plugins or documenting plugin usage, understand what content survives /doctor recommendations:

**Content to REMOVE (codebase-derivable or mechanically enforced):**

- Directory layouts the model can discover via exploration
- Technology stack lists derivable from package files
- Standard CLI commands the model already knows
- Copied JSON/YAML schemas
- Generic coding advice
- Rules already enforced by linters or formatters

**Content to KEEP (non-derivable guidance):**

- Gotchas specific to the project
- Rationale behind unusual decisions
- Non-standard conventions unique to the codebase
- Safety directives (e.g., "never commit to main directly")
- Cross-cutting concerns not obvious from code structure
- Plugin-specific configuration instructions

**Plugin author guidance:** If your plugin requires CLAUDE.md documentation, keep it focused on plugin-specific gotchas and non-obvious configuration. Avoid duplicating information the model can derive from your plugin's manifest, README, or skill files.

## Additional Resources

### Reference Files

For detailed implementation patterns:

- **`references/parsing-techniques.md`** - Complete guide to parsing YAML frontmatter and markdown bodies
- **`references/real-world-examples.md`** - Deep dive into multi-agent-swarm and ralph-wiggum implementations
- **`references/memory-rules-system.md`** - How plugin content interacts with CLAUDE.md, rules, and the memory hierarchy

### Example Files

Working examples in `examples/`:

- **`read-settings-hook.sh`** - Hook that reads and uses settings
- **`create-settings-command.md`** - Command that creates settings file
- **`example-settings.md`** - Template settings file

### Utility Scripts

Development tools in `scripts/`:

- **`validate-settings.sh`** - Validate settings file structure
- **`parse-frontmatter.sh`** - Extract frontmatter fields

## Implementation Workflow

To add settings to a plugin:

1. Design settings schema (which fields, types, defaults)
2. Create template file in plugin documentation
3. Add gitignore entry for `.claude/*.local.md`
4. Implement settings parsing in hooks/commands
5. Use quick-exit pattern (check file exists, check enabled field)
6. Document settings in plugin README with template
7. Remind users that changes require Claude Code restart

Focus on keeping settings simple and providing good defaults when settings file doesn't exist.
