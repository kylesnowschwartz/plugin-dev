# Advanced Skill Frontmatter Fields

This reference covers frontmatter fields that go beyond the core `name` and `description` requirements. These fields enable model selection, scoped hooks, and context budget optimization.

## model

Override the model used when a skill is active.

### Values

| Value         | Behavior                                              |
| ------------- | ----------------------------------------------------- |
| `inherit`     | Use the conversation's current model (default)        |
| `sonnet`      | Claude Sonnet — balanced performance and cost         |
| `opus`        | Claude Opus — maximum capability, highest cost        |
| `haiku`       | Claude Haiku — fastest, lowest cost                   |
| Full model ID | Specific version (e.g., `claude-sonnet-4-5-20250929`) |

### When to Use Each

- **`inherit` (default):** Most skills. Lets the user's model choice apply.
- **`haiku`:** Fast, cost-sensitive operations — linting, formatting checks, simple lookups. Good for skills that run frequently.
- **`sonnet`:** Standard workflows — code review, generation, analysis. The balanced default.
- **`opus`:** Complex reasoning — architectural decisions, security audits, detailed analysis requiring maximum capability.
- **Full model ID:** Pin to a specific version when skill behavior depends on exact model capabilities.

### Example

```yaml
---
name: quick-lint
description: This skill should be used for fast code quality checks...
model: haiku
---
```

### Notes

- Shorthand names (`sonnet`, `opus`, `haiku`) resolve to the current default version of each family
- The `model` field is shared with commands (same syntax and behavior)
- When `context: fork` is set, the model applies to the forked subagent

## hooks (Scoped Hooks)

Define hooks that activate only when the skill is in use, rather than globally for all tool calls.

### Concept

Unlike `hooks.json` (which applies globally whenever the plugin is active), scoped hooks in frontmatter are lifecycle-bound to the skill. They activate when the skill loads and deactivate when it completes. This enables skill-specific validation without affecting other workflows.

### Format

The `hooks` field uses the same event/matcher/hook structure as `hooks.json`:

```yaml
---
name: validated-writer
description: Write files with safety validation...
hooks:
  PreToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
          timeout: 10
  PostToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/post-write-check.sh"
---
```

### Supported Events

Scoped hooks support a subset of hook events:

| Event         | Purpose                                          |
| ------------- | ------------------------------------------------ |
| `PreToolUse`  | Validate or block tool calls before execution    |
| `PostToolUse` | Run checks after successful tool execution       |
| `Stop`        | Verify completion criteria before skill finishes |

Other events (`SessionStart`, `UserPromptSubmit`, etc.) are session-level and don't apply to skill scope.

### Comparison with hooks.json

| Aspect   | `hooks.json`                               | Frontmatter `hooks`                           |
| -------- | ------------------------------------------ | --------------------------------------------- |
| Scope    | Global (always active when plugin enabled) | Skill-specific (active only during skill use) |
| Events   | All 11+ hook events                        | PreToolUse, PostToolUse, Stop                 |
| Location | `hooks/hooks.json` file                    | YAML frontmatter in SKILL.md                  |
| Use case | Plugin-wide validation, logging            | Skill-specific safety checks                  |

### Use Cases

- **Skill-specific validation:** A "database writer" skill that validates SQL before execution
- **Restricted workflows:** A "deploy" skill that checks branch and test status before allowing Bash commands
- **Quality gates:** A "code generator" skill that runs linting after every Write operation

### Hook Types in Frontmatter

Both `command` and `prompt` hook types work in frontmatter:

**Command hook** (executes a script):

```yaml
hooks:
  PreToolUse:
    - matcher: Bash
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/check-safety.sh"
```

**Prompt hook** (LLM evaluation — for Stop events):

```yaml
hooks:
  Stop:
    - hooks:
        - type: prompt
          prompt: 'Verify that all generated code has tests. Return {"decision": "stop"} if satisfied or {"decision": "continue", "reason": "missing tests for..."} if not.'
```

## Skill Visibility Budget

Claude Code allocates a character budget for skill descriptions to manage context window usage efficiently.

### How It Works

1. All installed skills contribute their `description` text to a shared budget
2. Default budget: approximately 2% of the context window or ~16KB fallback (controlled by `SLASH_COMMAND_TOOL_CHAR_BUDGET`)
3. When total descriptions exceed the budget, lower-priority skills may be excluded from auto-discovery
4. Excluded skills are still available via explicit `/skill-name` invocation — they just won't auto-trigger

### What Counts Against the Budget

- The `description` frontmatter field text
- Skill name and metadata overhead
- This applies across ALL installed plugins, not just yours

### Optimization Strategies

1. **Keep descriptions concise:** Target 100-300 characters for the description field
2. **Use trigger phrases, not explanations:** "create a hook", "add PreToolUse" is better than "This skill provides comprehensive guidance for creating event-driven automation..."
3. **Move detail to SKILL.md body:** The body only loads when the skill triggers, not at discovery time
4. **Progressive disclosure:** Description (always loaded) → SKILL.md body (on trigger) → references (on demand)

### Checking Budget Usage

- `/context` command shows context usage including excluded skills if over budget
- Environment variable: `SLASH_COMMAND_TOOL_CHAR_BUDGET=20000` to increase budget
- Monitor with: `claude --debug` shows skill loading details

### Practical Impact

For most plugins with 5-15 skills, the default budget is sufficient. Budget becomes a concern when:

- Multiple plugins are installed simultaneously (each adding descriptions)
- Individual skill descriptions exceed 500 characters
- A plugin has 20+ skills with verbose descriptions

## Skill Permission Syntax

Skills can be referenced in settings.json allow rules using the `Skill()` syntax:

### Exact Match

Allow a specific skill to be invoked:

```json
{
  "permissions": {
    "allow": ["Skill(my-skill-name)"]
  }
}
```

### Prefix Match with Arguments

Allow a skill with any arguments:

```json
{
  "permissions": {
    "allow": ["Skill(my-skill-name *)"]
  }
}
```

This enables fine-grained control over which skills can be auto-invoked by Claude vs requiring explicit user invocation. Combine with `disable-model-invocation` frontmatter for maximum control.

## Visual Output Generators

Skills can bundle scripts that generate visual output (HTML files, charts, interactive visualizations) for rich user experiences.

### Pattern

1. Bundle a script (Python, Node.js, etc.) in the skill's `scripts/` directory
2. The script generates an HTML file or other visual output
3. Claude orchestrates: reads data, runs the script, presents the result

### Example Structure

```
visualization-skill/
├── SKILL.md
├── scripts/
│   └── generate-chart.py    # Produces HTML output
└── references/
    └── chart-options.md     # Configuration reference
```

### SKILL.md Usage

```markdown
To generate the visualization:

1. Gather the data from the user's project
2. Run the script: `python ${CLAUDE_PLUGIN_ROOT}/skills/visualization-skill/scripts/generate-chart.py`
3. The script outputs an HTML file — inform the user of its location
```

Visual output generators combine the power of deterministic scripts with Claude's ability to gather context and present results. The script handles rendering while Claude handles data gathering and user interaction.
