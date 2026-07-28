# Advanced Skill Frontmatter Fields

This reference covers frontmatter fields that go beyond the core `name` and `description` requirements. These fields enable tool restriction, forked execution, model selection, scoped hooks, file scoping, and context budget optimization.

## Skill Invocation Name (CC 2.1.94)

Plugin skills declared via `"skills": ["./"]` use the skill's frontmatter `name` for invocation instead of the directory basename. Ensure the `name` field in frontmatter matches how users should invoke the skill.

## Frontmatter Field Case Acceptance (CC 2.1.186)

Skill frontmatter fields accept multiple case conventions: `kebab-case`, `snake_case`, and `camelCase`. The following are all equivalent:

```yaml
# All valid:
allowed-tools: Read, Grep    # kebab-case (recommended)
allowed_tools: Read, Grep    # snake_case
allowedTools: Read, Grep     # camelCase

user-invocable: false        # kebab-case (recommended)
user_invocable: false        # snake_case
userInvocable: false         # camelCase
```

**Recommendation:** Use kebab-case for consistency with official documentation, but all variants work.

## Boolean Value Expansion (CC 2.1.216)

Frontmatter boolean fields now accept expanded value formats beyond just `true`/`false`:

```yaml
# All equivalent to true:
user-invocable: true
user-invocable: yes
user-invocable: on
user-invocable: 1

# All equivalent to false:
user-invocable: false
user-invocable: no
user-invocable: off
user-invocable: 0
```

**Recommendation:** Use `true`/`false` for clarity and consistency, but the expanded values are accepted for compatibility with YAML conventions.

## allowed-tools

Optionally restrict which tools Claude can use when the skill is active:

```yaml
---
name: code-reviewer
description: Review code for best practices...
allowed-tools: Read, Grep, Glob
---
```

Use `allowed-tools` for:

- Read-only skills that shouldn't modify files
- Security-sensitive workflows
- Skills with limited scope

When specified, Claude can only use the listed tools without needing permission. If omitted, Claude follows the standard permission model.

## context

Control how the skill's context is loaded:

```yaml
---
name: analysis-skill
description: Perform deep code analysis...
context: fork
---
```

**Values:**

- `fork` - Run skill in a subagent (separate context), preserving main agent's context
- Not specified - Run in main agent's context (default)

Use `context: fork` for:

- Skills that load large reference files
- Skills that might pollute the main context
- Expensive operations you want isolated

**Deferred tools (CC 2.1.126):** Skills with `context: fork` now correctly receive access to deferred tools (WebSearch, WebFetch, etc.) on their first turn. Previously, these tools were unavailable until the second turn in forked contexts.

## agent

Specify which agent type handles the forked skill. The agent provides the **execution environment** (system prompt, tools, behavioral rules). The skill body provides the **task** (what to do). The forked agent does not inherit your conversation history.

```yaml
---
name: exploration-skill
description: Explore codebase patterns...
context: fork
agent: Explore
---
Find all React components that accept a `userId` prop and trace how they fetch user data.
```

In this example, the `Explore` agent's system prompt controls behavior and available tools. The skill body ("Find all React components...") becomes the task prompt the agent receives.

**Values:**

- `Explore` - Fast, read-only agent for codebase exploration
- `Plan` - Architect agent for implementation planning
- `general-purpose` - Full-capability agent (default when `context: fork` is set)
- Custom agent name - Any agent defined in `.claude/agents/` or by a plugin

When using a custom agent, you control both sides: the agent definition sets the system prompt, tools, MCP servers, and hooks. The skill sets the task and triggering conditions. This lets one agent serve many skills, and the same skill shape could target different agents.

**Design guidance:** Put *what to do* in the skill. Put *how to behave* in the agent definition.

Requires `context: fork` to be set.

### Skill + Agent vs. Direct Agent Tool Call

Both approaches delegate work to a sub-agent, but they serve different design needs:

| Dimension | Skill `context: fork` | Direct Agent tool call |
|---|---|---|
| **Interface** | Declarative YAML + markdown body | Imperative prompt string |
| **Triggering** | Automatic (description matching) | Manual (caller decides when) |
| **Context** | Inherits parent context, shares prompt cache | Fresh start, no inherited context |
| **Task prompt** | SKILL.md body (static) | Whatever you pass at runtime (dynamic) |
| **System prompt** | From agent type or agent definition | From `subagent_type` |

**Use skill `context: fork`** when the task instructions are stable, the trigger is predictable, and you want automatic invocation with cache sharing.

**Use direct Agent calls** when you need dynamic prompts computed at runtime, parallel orchestration (spawning N agents from a loop), or worktree isolation for parallel git branches.

## skills

Load other skills into the forked agent's context:

```yaml
---
name: comprehensive-review
description: Full code review with testing...
context: fork
agent: general
skills: testing-patterns, security-audit
---
```

Requires `context: fork` to be set. Only skills from the same plugin can be loaded.

## user-invocable

Control whether the skill appears in the slash command menu:

```yaml
---
name: internal-review-standards
description: Apply internal code review standards...
user-invocable: false
---
```

**Default:** `true` (skills are visible in the `/` menu)

**Important:** This field only controls slash menu visibility. It does NOT affect:

- **Skill tool access** - Claude can still invoke the skill programmatically
- **Auto-discovery** - Claude still discovers and uses the skill based on context

Use `user-invocable: false` for skills that Claude should use automatically but users shouldn't invoke directly.

## disable-model-invocation

Prevent Claude from programmatically invoking the skill via the Skill tool:

```yaml
---
name: dangerous-operation
description: Perform dangerous operation...
disable-model-invocation: true
---
```

**Default:** `false` (programmatic invocation allowed)

Use for skills that should only be manually invoked by users, such as:

- Destructive operations requiring human judgment
- Interactive workflows needing user input
- Approval processes

**Visibility comparison:**

| Setting                          | Slash Menu | Skill Tool | Auto-Discovery |
| -------------------------------- | ---------- | ---------- | -------------- |
| `user-invocable: true` (default) | Visible    | Allowed    | Yes            |
| `user-invocable: false`          | Hidden     | Allowed    | Yes            |
| `disable-model-invocation: true` | Visible    | Blocked    | Yes            |

## paths

Scope the skill to specific files using glob patterns:

```yaml
paths:
  - "src/**/*.{ts,tsx}"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
```

When set, the skill only loads into context when Claude is working with files matching these patterns. Reduces token usage by making skills contextual rather than always-loaded. Accepts a YAML list of glob patterns with brace expansion support.

> **Resolved (CC 2.1.86):** Write, Edit, and Read tools previously failed on files outside the project root when conditional (path-scoped) skills were configured. This is now fixed.

## argument-hint

```yaml
argument-hint: "<file-path> [--verbose]"
```

Provides autocomplete hint text in the `/` menu. Cosmetic only; doesn't affect argument parsing.

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

## disallowed-tools

Remove specific tools from Claude's available pool while the skill is active. This is the denylist counterpart to `allowed-tools`.

### Format

Accepts space/comma-separated string or YAML list:

```yaml
---
name: autonomous-processor
description: Process files autonomously without user interruption...
disallowed-tools: AskUserQuestion, WebSearch
---
```

Or as a list:

```yaml
---
name: autonomous-processor
description: Process files autonomously without user interruption...
disallowed-tools:
  - AskUserQuestion
  - WebSearch
---
```

### Use Cases

- **Autonomous skills:** Remove `AskUserQuestion` for background loops that should never prompt for input
- **Offline workflows:** Remove `WebSearch` and `WebFetch` for air-gapped operations
- **Safety constraints:** Remove `Bash` or `Write` for read-only analysis skills

### Comparison with allowed-tools

| Field             | Approach  | Use When                                        |
| ----------------- | --------- | ----------------------------------------------- |
| `allowed-tools`   | Allowlist | Few tools needed, restrict to specific set      |
| `disallowed-tools`| Denylist  | Most tools needed, block specific dangerous ones|

Use one or the other. If both are specified, behavior is undefined.

### Lifecycle

The restriction clears when the user sends their next message. This ensures the tool pool resets between user turns, preventing accidental tool lockout across conversation turns.

> **CC 2.1.152:** Added `disallowed-tools` frontmatter field for skills and commands to remove tools from the model's available pool.

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
