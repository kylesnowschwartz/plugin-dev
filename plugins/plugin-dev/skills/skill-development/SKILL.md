---
name: skill-development
version: 0.2.0
description: This skill should be used when the user asks to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", "SKILL.md format", "skill frontmatter", "skill triggers", "trigger phrases for skills", "progressive disclosure", "skill references folder", "skill examples folder", "validate skill", "skill model field", "skill hooks", "scoped hooks in skill", "visibility budget", "context budget", "SLASH_COMMAND_TOOL_CHAR_BUDGET", "skill permissions", "Skill() syntax", "visual output", "skill precedence", "argument-hint", "paths frontmatter", "file-scoped skill", or needs guidance on skill structure, file organization, writing style, or skill development best practices for Claude Code plugins.
---

# Skill Development for Claude Code Plugins

This skill provides guidance for creating effective skills for Claude Code plugins.

## About Skills

Skills are modular, self-contained packages that extend Claude's capabilities by providing
specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific
domains or tasks—they transform Claude from a general-purpose agent into a specialized agent
equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

1. Specialized workflows - Multi-step procedures for specific domains
2. Tool integrations - Instructions for working with specific file formats or APIs
3. Domain expertise - Company-specific knowledge, schemas, business logic
4. Bundled resources - Scripts, references, and assets for complex and repetitive tasks
5. Visual output generation — Scripts that produce HTML/interactive visualizations

### Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation intended to be loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

Both skills and commands are invoked via the Skill tool and share the same underlying mechanism. Commands are essentially simple skills stored as single `.md` files without bundled resources. See `references/commands-vs-skills.md` for a comparison.

### Skill Precedence

Skills follow precedence: Enterprise > Personal (`~/.claude/skills/`) > Project (`.claude/skills/`) > Plugin skills. Higher-priority skills with the same name shadow lower-priority ones. Use distinctive, namespaced names for plugin skills to avoid collisions.

#### SKILL.md (required)

**Metadata Quality:** The `name` and `description` in YAML frontmatter determine when Claude will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g. "This skill should be used when..." instead of "Use this skill when...").

**Skill Invocation Name (CC 2.1.94):** Plugin skills declared via `"skills": ["./"]` now use the skill's frontmatter `name` for invocation instead of the directory basename. Ensure the `name` field in frontmatter matches how users should invoke the skill.

#### Optional Frontmatter Fields

##### allowed-tools

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

##### context

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

##### agent

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

##### Skill + Agent vs. Direct Agent Tool Call

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

##### skills

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

##### user-invocable

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

##### disable-model-invocation

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

##### model (optional)

```yaml
model: haiku
```

Values: `sonnet`, `opus`, `haiku`, `inherit` (default), or full model ID. See `references/advanced-frontmatter.md` for details.

##### hooks (optional)

```yaml
hooks:
  PreToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
```

Scoped hooks that activate when this skill is loaded and deactivate when it finishes. Supported events: `PreToolUse`, `PostToolUse`, `Stop`. See `references/advanced-frontmatter.md`.

##### paths (optional)

Scope the skill to specific files using glob patterns:

```yaml
paths:
  - "src/**/*.{ts,tsx}"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
```

When set, the skill only loads into context when Claude is working with files matching these patterns. Reduces token usage by making skills contextual rather than always-loaded. Accepts a YAML list of glob patterns with brace expansion support.

> **Resolved (CC 2.1.86):** Write, Edit, and Read tools previously failed on files outside the project root when conditional (path-scoped) skills were configured. This is now fixed.

##### argument-hint (optional)

```yaml
argument-hint: "<file-path> [--verbose]"
```

Provides autocomplete hint text in the `/` menu. Cosmetic only; doesn't affect argument parsing.

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context

##### References (`references/`)

Documentation and reference material intended to be loaded as needed into context.

- **When to include**: For documentation that Claude should reference while working
- **Examples**: `references/schema.md` for database schemas, `references/api_docs.md` for API specifications
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both

##### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output Claude produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/slides.pptx` for templates

### Dynamic Content in Skills

Skills support dynamic content injection and variable substitution for context-aware behavior.

#### String Substitutions

Use variables in skill content that get replaced at runtime:

```markdown
The session ID is: ${CLAUDE_SESSION_ID}
Arguments passed: $ARGUMENTS
```

**Available substitutions:**

- `$ARGUMENTS` - Arguments passed when skill is invoked (e.g., `/skill-name arg1 arg2`)
- `$ARGUMENTS[0]`, `$ARGUMENTS[1]` - Individual positional arguments (0-indexed)
- `$1`, `$2`, `$3` - 1-indexed shorthand for positional arguments
- `${CLAUDE_SESSION_ID}` - Current session identifier
- `${CLAUDE_PLUGIN_ROOT}` - Plugin directory path

#### Dynamic Context Injection

Execute commands to inject their output into skill context using backtick syntax:

```markdown
## Current Project Status

The git status is:
[BANG]`git status --short`

Recent commits:
[BANG]`git log --oneline -5`
```

**Syntax:** `` [BANG]`command` ``

**Use cases:**

- Load current project state (git status, package.json)
- Include dynamic configuration
- Fetch environment-specific information

**Security note:** Commands execute in the user's environment. Only use trusted commands.

**Disable shell execution (CC 2.1.91):** Organizations can disable inline shell execution in skills, custom slash commands, and plugin commands via the `disableSkillShellExecution` setting. When enabled, `[BANG]`command`` blocks are not executed. Design skills to work gracefully when shell execution is unavailable.

### Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Claude (Unlimited\*)

\*Unlimited because scripts can be executed without reading into context window.

## Skill Creation Process

To create a skill, follow these six steps. For detailed instructions on each step, see `references/skill-creation-workflow.md`.

1. **Understand the Skill**: Gather concrete examples of how the skill will be used through user questions and feedback
2. **Plan Reusable Contents**: Analyze examples to identify what scripts, references, and assets would be helpful
3. **Create Structure**: Set up the skill directory with `mkdir -p skills/skill-name/{references,examples,scripts}`
4. **Edit the Skill**: Write SKILL.md with proper frontmatter and imperative-form body; create bundled resources
5. **Validate and Test**: Check structure, trigger phrases, writing style, and progressive disclosure
6. **Iterate**: Improve based on real-world usage and feedback

### Key Writing Guidelines

- **Description**: Use third-person ("This skill should be used when...") with specific trigger phrases
- **Body**: Use imperative/infinitive form ("To create X, do Y"), not second person ("You should...")
- **Size**: Target 1,500-2,000 words; move detailed content to references/

### Visibility Budget

Skill descriptions consume ~2% of context window (~16KB fallback). If total skill descriptions exceed this budget, some skills may be excluded from discovery. Controlled by `SLASH_COMMAND_TOOL_CHAR_BUDGET`.

Keep descriptions concise but include trigger phrases. Skills with longer descriptions are more likely to be excluded when budget pressure is high. See `references/advanced-frontmatter.md` for optimization strategies.

### /skills Menu Display (CC 2.1.86)

The `/skills` menu truncates descriptions at **250 characters**. Descriptions longer than this are cut off in the menu listing (though the full description is still used for auto-discovery matching). Place the most important trigger phrases early in the description so they remain visible.

Skills are listed **alphabetically** in the `/skills` menu. Name skills with discoverability in mind — a skill named `api-testing` appears near the top, while `zsh-config` appears at the bottom.

### Context Management for Plugins

After auto-compaction, skill descriptions survive (they're re-injected), but skill body content may be lost. Users can re-invoke the skill to reload it. The `PreCompact` hook can preserve critical state before compaction occurs.

When multiple plugins are installed, their skill descriptions share the same budget. Design descriptions to be distinctive and concise.

## Plugin-Specific Considerations

### Skill Location in Plugins

Plugin skills live in the plugin's `skills/` directory:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
├── agents/
└── skills/
    └── my-skill/
        ├── SKILL.md
        ├── references/
        ├── examples/
        └── scripts/
```

### Auto-Discovery

Claude Code automatically discovers skills:

- Scans `skills/` directory
- Finds subdirectories containing `SKILL.md`
- Loads skill metadata (name + description) always
- Loads SKILL.md body when skill triggers
- Loads references/examples when needed

### No Packaging Needed

Plugin skills are distributed as part of the plugin, not as separate ZIP files. Users get skills when they install the plugin.

### Testing in Plugins

Test skills by installing plugin locally:

```bash
# Test with --plugin-dir
claude --plugin-dir /path/to/plugin

# Ask questions that should trigger the skill
# Verify skill loads correctly
```

## Examples from Plugin-Dev

Study the skills in this plugin as examples of best practices:

**hook-development skill:**

- Excellent trigger phrases: "create a hook", "add a PreToolUse hook", etc.
- Lean SKILL.md (2,125 words)
- 3 references/ files for detailed content
- 3 examples/ of working hooks
- 3 scripts/ utilities

**agent-development skill:**

- Strong triggers: "create an agent", "agent frontmatter", etc.
- Focused SKILL.md (1,896 words)
- References include the AI generation prompt from Claude Code
- Complete agent examples

**plugin-settings skill:**

- Specific triggers: "plugin settings", ".local.md files", "YAML frontmatter"
- References show real implementations (multi-agent-swarm, ralph-wiggum)
- Working parsing scripts

Each demonstrates progressive disclosure and strong triggering.

## Validation Checklist

Before finalizing a skill:

**Structure:**

- [ ] SKILL.md file exists with valid YAML frontmatter
- [ ] Frontmatter has `name` and `description` fields
- [ ] Name uses only lowercase letters, numbers, and hyphens (max 64 chars)
- [ ] Description is under 1024 characters
- [ ] (Optional) `allowed-tools` field if restricting tool access
- [ ] (Optional) `context: fork` if running in subagent
- [ ] (Optional) `agent` field if specifying agent type (requires `context: fork`)
- [ ] (Optional) `skills` array if loading other skills (requires `context: fork`)
- [ ] (Optional) `user-invocable` field if hiding from slash menu
- [ ] (Optional) `disable-model-invocation` field if blocking programmatic use
- [ ] (Optional) `model` field if overriding default model
- [ ] (Optional) `hooks` field if using scoped hooks
- [ ] (Optional) `argument-hint` field for autocomplete hints
- [ ] (Optional) `paths` field for file-scoped activation
- [ ] Markdown body is present and substantial
- [ ] Referenced files actually exist

**Description Quality:**

- [ ] Uses third person ("This skill should be used when...")
- [ ] Includes specific trigger phrases users would say
- [ ] Lists concrete scenarios ("create X", "configure Y")

**Content Quality:**

- [ ] SKILL.md body uses imperative/infinitive form
- [ ] Body is focused and lean (1,500-2,000 words ideal, <3k max)
- [ ] Detailed content moved to references/
- [ ] Examples are complete and working

**Testing:**

- [ ] Skill triggers on expected user queries
- [ ] Content is helpful for intended tasks
- [ ] No duplicated information across files

## Quick Reference

### Minimal Skill

```
skill-name/
└── SKILL.md
```

Good for: Simple knowledge, no complex resources needed

### Standard Skill (Recommended)

```
skill-name/
├── SKILL.md
├── references/
│   └── detailed-guide.md
└── examples/
    └── working-example.sh
```

Good for: Most plugin skills with detailed documentation

### Complete Skill

```
skill-name/
├── SKILL.md
├── references/
│   ├── patterns.md
│   └── advanced.md
├── examples/
│   ├── example1.sh
│   └── example2.json
└── scripts/
    └── validate.sh
```

Good for: Complex domains with validation utilities

## Best Practices Summary

**DO:**

- Use third-person in description ("This skill should be used when...")
- Include specific trigger phrases ("create X", "configure Y")
- Keep SKILL.md lean (1,500-2,000 words)
- Use progressive disclosure (move details to references/)
- Write in imperative/infinitive form
- Reference supporting files clearly
- Provide working examples
- Create utility scripts for common operations

**DON'T:**

- Use second person ("You should...")
- Have vague trigger conditions
- Put everything in SKILL.md (>3,000 words without references/)
- Leave resources unreferenced
- Include broken or incomplete examples

## Additional Resources

### Example Skills

Copy-paste ready skill templates in `examples/`:

- **`examples/minimal-skill.md`** - Bare-bones skill with just SKILL.md (git conventions example)
- **`examples/complete-skill.md`** - Full skill with references/, examples/, and scripts/ (API testing example)
- **`examples/frontmatter-templates.md`** - Quick-reference frontmatter patterns for common use cases

### Reference Files

For detailed guidance, consult:

- **`references/skill-creation-workflow.md`** - Plugin-specific skill creation workflow (recommended for plugin skills)
- **`references/skill-creator-original.md`** - Original generic skill-creator methodology (includes init/packaging scripts for standalone skills)
- **`references/advanced-frontmatter.md`** - Model, hooks, argument-hint, and visibility budget details
- **`references/commands-vs-skills.md`** - Comparison of commands and skills formats

### Study These Skills

Plugin-dev's skills demonstrate best practices:

- `../hook-development/` - Progressive disclosure, utilities
- `../agent-development/` - AI-assisted creation, references
- `../mcp-integration/` - Comprehensive references
- `../plugin-settings/` - Real-world examples
- `../command-development/` - Clear critical concepts
- `../plugin-structure/` - Good organization
