
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

### Invoke Skill Tool (CC 2.1.196)

Claude Code includes a built-in "Invoke skill" tool that loads packaged skills by exact name or explicit user request. Key behaviors:

- **Scoped skill-name resolution** — When both scoped (`apps/web:deploy`) and unscoped (`deploy`) variants exist, the tool resolves based on files being worked on
- **Optional args** — Skills can receive arguments passed through the tool invocation
- **No re-invocation of loaded skills** — The tool does not re-invoke a skill already loaded in the current turn

This tool is how Claude programmatically loads skills — plugin developers don't need to call it directly, but understanding its behavior helps when designing skills that may be invoked automatically vs. manually.

### Skill Precedence

Skills follow precedence: Enterprise > Personal (`~/.claude/skills/`) > Project (`.claude/skills/`) > Plugin skills. Higher-priority skills with the same name shadow lower-priority ones. Use distinctive, namespaced names for plugin skills to avoid collisions.

### Nested Skill Directories (CC 2.1.178)

Skills can be organized in nested directories within `.claude/skills/`. When working on files in a nested directory, skills from that directory's `.claude/skills/` are loaded automatically.

**Collision handling:** When the same skill name exists in multiple nested directories, the skill displays as `<dir>:<name>` format (e.g., `apps/web:deploy`). This prevents name collisions while maintaining clarity about which skill is which.

**Example structure:**

```
project/
├── .claude/skills/         # Project-level skills
│   └── shared-skill/
├── apps/
│   └── web/
│       └── .claude/skills/ # Nested skills for apps/web
│           └── deploy/     # Appears as "apps/web:deploy" if collision
└── packages/
    └── api/
        └── .claude/skills/ # Nested skills for packages/api
            └── deploy/     # Appears as "packages/api:deploy" if collision
```

### Directory-Scoped Skills (CC 2.1.178)

Skills whose names are prefixed with their directory path (e.g., `apps/web:deploy`) enable targeted skill activation. When both a scoped and unscoped variant exist:

1. **Files being worked on determine precedence** — the most specific directory wins
2. **Otherwise, unscoped skill is used** — when no files provide context

**Use cases:**

- Monorepos with different deployment procedures per app
- Package-specific build or test skills
- Directory-specific conventions that shouldn't apply globally

### Automatic Local Skill Loading (CC 2.1.157)

Skills in `.claude/skills/` directories now load automatically without marketplace installation or explicit configuration. Simply place a skill directory with a `SKILL.md` file in your project's `.claude/skills/` or personal `~/.claude/skills/`, and it becomes available immediately.

**Development workflow:**

1. Create skill directory: `mkdir -p .claude/skills/my-skill`
2. Add `SKILL.md` with frontmatter and content
3. Skill is immediately available — no install step required

This streamlines local plugin development and testing. Skills loaded this way follow the standard precedence rules.

### skillOverrides Setting (CC 2.1.129)

Users can control skill behavior globally via the `skillOverrides` setting in their settings.json:

```json
{
  "skillOverrides": "user-invocable-only"
}
```

**Values:**

- `off` - Disable all skills entirely (skills won't load or trigger)
- `user-invocable-only` - Only allow skills that users explicitly invoke via `/skillname`
- `name-only` - Show skill names in menus but don't load full descriptions (reduces context usage)

**Implications for plugin developers:**

- Skills may not trigger automatically if users have restrictive `skillOverrides` settings
- Design skills to work well when user-invoked (clear `/skillname` entry point)
- Keep skill names descriptive since they may be the only visible identifier
- Test skills with `skillOverrides: "user-invocable-only"` to ensure they work when explicitly invoked

### disableBundledSkills Setting (CC 2.1.169)

The `disableBundledSkills` managed setting hides bundled skills, workflows, and slash commands from the model:

```json
{
  "disableBundledSkills": true
}
```

**When enabled:**

- Built-in Claude Code skills are hidden from the model
- Plugin-provided skills remain available
- User-defined skills remain available

**Implications for plugin developers:**

- This setting gives plugins more control over the skill landscape
- Useful for enterprise environments with custom skill sets
- Plugin skills should be self-contained and not rely on bundled skills

#### SKILL.md (required)

**Metadata Quality:** The `name` and `description` in YAML frontmatter determine when Claude will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g. "This skill should be used when..." instead of "Use this skill when...").

**Skill Invocation Name (CC 2.1.94):** Plugin skills declared via `"skills": ["./"]` now use the skill's frontmatter `name` for invocation instead of the directory basename. Ensure the `name` field in frontmatter matches how users should invoke the skill.

**Frontmatter Field Case Acceptance (CC 2.1.186):** Skill frontmatter fields now accept multiple case conventions: `kebab-case`, `snake_case`, and `camelCase`. The following are all equivalent:

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

**Deferred tools (CC 2.1.126):** Skills with `context: fork` now correctly receive access to deferred tools (WebSearch, WebFetch, etc.) on their first turn. Previously, these tools were unavailable until the second turn in forked contexts.

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

##### disallowed-tools (optional)

```yaml
disallowed-tools: AskUserQuestion, WebSearch
```

Remove specific tools from Claude's available pool while the skill is active. Useful for autonomous skills that should never call certain tools (e.g., `AskUserQuestion` for background loops). Accepts space/comma-separated string or YAML list. The restriction clears when the user sends their next message. Added in CC 2.1.152. See `references/advanced-frontmatter.md` for details.

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

**Literal dollar sign escape (CC 2.1.163):** Use `\$` to output a literal dollar sign before digits without argument substitution:

```markdown
The regex pattern is \$1 for the first capture group.
```

This outputs `$1` literally instead of substituting the first argument.

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

Skills are listed **alphabetically** and in the `/skills` menu. Name skills with discoverability in mind — a skill named `api-testing` appears near the top, while `zsh-config` appears at the bottom.

**Token Count Sorting (CC 2.1.111):** Press `t` in the `/skills` menu to sort by token count. This helps identify large skills that consume significant context budget. Optimize large skills by moving content to references/ or using progressive disclosure.

### Context Management for Plugins

After auto-compaction, skill descriptions survive (they're re-injected), but skill body content may be lost. Users can re-invoke the skill to reload it. The `PreCompact` hook can preserve critical state before compaction occurs.

When multiple plugins are installed, their skill descriptions share the same budget. Design descriptions to be distinctive and concise.

### Subagent Skill Discovery (CC 2.1.133)

**Resolved:** Subagents now correctly discover project, user, and plugin skills via the Skill tool. Prior to CC 2.1.133, subagents could not invoke skills, which limited their ability to leverage plugin-provided knowledge. Skills used by agents should work correctly on CC 2.1.133 or later.

### Previously Invoked Skills (CC 2.1.119)

After conversation compaction, skills invoked before compaction are restored as context only via a "Previously invoked skills" reminder. This reminder warns not to re-execute setup actions or treat prior inputs as current instructions. The old "Invoked skills" reminder was replaced by this more explicit context-only framing.

**Implications for skill design:**

- Skills should be idempotent where possible
- Setup actions (file creation, initialization) should check if already done
- Skills should not assume prior context survives compaction unchanged

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

### Hot-Reloading Skills During Development (CC 2.1.152, 2.1.174)

Use the `/reload-skills` command to re-scan skill directories without restarting your session. This is useful during skill development when you're iterating on skill content:

1. Edit your SKILL.md or references
2. Run `/reload-skills` in Claude Code
3. Test the updated skill immediately

Changes to skill content, frontmatter, and references are picked up. No need to restart Claude Code.

**Performance optimization (CC 2.1.174):** Skill hot-reload now only re-sends changed skills instead of the entire skill listing. When you modify a single skill, only that skill is re-announced to Claude, reducing token overhead during rapid iteration. This makes the edit-reload-test cycle faster for developers working on individual skills.

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
- [ ] (Optional) `disallowed-tools` field if blocking specific tools
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
- Prefer dedicated tools (Read, Grep, Glob) over Bash commands (CC 2.1.133)

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
