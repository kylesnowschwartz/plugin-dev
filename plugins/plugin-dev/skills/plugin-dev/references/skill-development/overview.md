
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

- **scripts/** — Executable code for tasks needing deterministic reliability or repeatedly rewritten (e.g. `scripts/rotate_pdf.py`). Token efficient; may run without loading into context.
- **references/** — Documentation loaded as needed (e.g. `references/schema.md`, `references/api_docs.md`). If files are large (>10k words), include grep search patterns in SKILL.md. Avoid duplication: information lives in either SKILL.md or references, not both.
- **assets/** — Files used in the output Claude produces, not loaded into context (e.g. `assets/logo.png`, `assets/slides.pptx`).

Both skills and commands are invoked via the Skill tool and share the same underlying mechanism. Commands are essentially simple skills stored as single `.md` files without bundled resources. See `references/commands-vs-skills.md` for a comparison.

### Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Claude (Unlimited\*)

\*Unlimited because scripts can be executed without reading into context window.

### What Goes Where

Apply these decision rules when splitting content across the skill (fuller guidance in `references/skill-creation-workflow.md`):

- **SKILL.md body** — Core concepts, essential procedures, quick-reference tables, pointers to bundled resources, and the most common use cases. Keep under 3,000 words, ideally 1,500-2,000.
- **references/** — Detailed patterns, comprehensive API docs, migration guides, edge cases, and extensive walkthroughs. Each file may be large (2,000-5,000+ words).
- **examples/** — Complete, runnable scripts, configuration files, and templates users can copy and adapt directly.
- **scripts/** — Executable validation, testing, parsing, and automation utilities. Should be executable and documented.

Reach for a **command** (single `.md` file) when a simple reusable prompt or dynamic-argument prompt is all that's needed; reach for a **skill** once validation scripts, reference documentation, working examples, or progressive disclosure are involved. Migrate a command to a skill when it grows complex — see `references/commands-vs-skills.md`.

## SKILL.md Frontmatter

The `name` and `description` in YAML frontmatter determine when Claude will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g. "This skill should be used when..." instead of "Use this skill when...").

A strong description names concrete, quoted trigger phrases users would actually say:

```yaml
# Good — third person, specific quoted triggers
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse hook", "validate tool use", or mentions hook events (PreToolUse, PostToolUse, Stop).

# Bad — vague, wrong person, no triggers
description: Provides hook guidance.
```

### Field Reference

Only `name` and `description` are required. Every optional field below is documented in full — with values, examples, comparison tables, and version notes — in `references/advanced-frontmatter.md`.

| Field | Required | Purpose |
| --- | --- | --- |
| `name` | Yes | Skill identifier (kebab-case, max 64 chars) |
| `description` | Yes | When to use, third-person, with trigger phrases (< 1024 chars) |
| `allowed-tools` | No | Allowlist tools Claude may use while active (read-only/security scopes) |
| `disallowed-tools` | No | Denylist tools to remove from the pool (CC 2.1.152) |
| `context` | No | `fork` runs the skill in a subagent, preserving main context |
| `agent` | No | Agent type handling the fork (`Explore`, `Plan`, `general-purpose`, custom); requires `context: fork` |
| `skills` | No | Load other same-plugin skills into the fork; requires `context: fork` |
| `user-invocable` | No | `false` hides from the `/` menu (still auto-discoverable + Skill-tool callable) |
| `disable-model-invocation` | No | `true` blocks programmatic Skill-tool invocation (user-only) |
| `model` | No | Override model: `sonnet`, `opus`, `haiku`, `inherit` (default), or full ID |
| `hooks` | No | Scoped hooks (`PreToolUse`, `PostToolUse`, `Stop`) active only while loaded |
| `paths` | No | Glob patterns; skill loads only when working on matching files |
| `argument-hint` | No | Autocomplete hint text in the `/` menu (cosmetic) |

Frontmatter fields accept `kebab-case`, `snake_case`, and `camelCase` (CC 2.1.186); kebab-case is recommended. Plugin skills declared via `"skills": ["./"]` use the frontmatter `name` for invocation, not the directory basename (CC 2.1.94). Skills can be referenced in settings.json allow rules via `Skill(name)` syntax. See `references/advanced-frontmatter.md` for all of the above plus visual-output-generator patterns.

## Skill Creation Process

To create a skill, follow these six steps. For detailed instructions on each step, plus the validation checklist, structure patterns, and best-practices summary, see `references/skill-creation-workflow.md`.

1. **Understand the Skill**: Gather concrete examples of how the skill will be used through user questions and feedback
2. **Plan Reusable Contents**: Analyze examples to identify what scripts, references, and assets would be helpful
3. **Create Structure**: Set up the skill directory with `mkdir -p skills/skill-name/{references,examples,scripts}`
4. **Edit the Skill**: Write SKILL.md with proper frontmatter and imperative-form body; create bundled resources
5. **Validate and Test**: Check structure, trigger phrases, writing style, and progressive disclosure (use the `skill-reviewer` agent)
6. **Iterate**: Improve based on real-world usage and feedback

### Key Writing Guidelines

- **Description**: Use third-person ("This skill should be used when...") with specific trigger phrases users would actually say, quoted. Avoid vague, second-person, or unquoted triggers.
- **Body**: Use imperative/infinitive form ("To create X, do Y"), not second person ("You should...")
- **Size**: Target 1,500-2,000 words (< 3k max); move detailed content to references/

For the generic (non-plugin) skill-creator methodology, including `init_skill.py` and `package_skill.py` scripts for standalone skills, see `references/skill-creator-original.md`.

### Visibility Budget

Skill descriptions consume ~2% of context window (~16KB fallback), controlled by `SLASH_COMMAND_TOOL_CHAR_BUDGET`. If total skill descriptions exceed this budget, some skills may be excluded from auto-discovery (still invocable via `/skill-name`). Keep descriptions concise but include trigger phrases; skills with longer descriptions are excluded first under pressure. See `references/advanced-frontmatter.md` for optimization strategies.

## Dynamic Content

Skills support `$ARGUMENTS`/`$1` variable substitution, `${CLAUDE_PLUGIN_ROOT}` and `${CLAUDE_SESSION_ID}` paths, and inline command injection via `` [BANG]`command` `` blocks. Organizations can disable inline shell execution. For the full substitution list, the literal-`$` escape (CC 2.1.163), and `disableSkillShellExecution` (CC 2.1.91), see `references/skill-loading-and-runtime.md`.

## Loading, Precedence, and Runtime Behavior

Skill discovery, precedence (Enterprise > Personal > Project > Plugin), nested and directory-scoped skills, the Invoke Skill tool, slash-skill stacking, the `skillOverrides` and `disableBundledSkills` settings, hot-reloading, `/skills` menu display, and behavior across compaction all live in `references/skill-loading-and-runtime.md`. Consult it when a skill won't trigger, when designing for shadowing/collisions, or when a user reports skills disabled by settings.

### Skill Location in Plugins

Plugin skills live in the plugin's `skills/` directory and are auto-discovered — no packaging or ZIP required; users get them when they install the plugin:

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

Test locally with `claude --plugin-dir /path/to/plugin` and ask questions that should trigger the skill. Study plugin-dev's own skills (`../hook-development/`, `../agent-development/`, `../mcp-integration/`, `../plugin-settings/`, `../command-development/`, `../plugin-structure/`) as best-practice examples; details in `references/skill-creation-workflow.md`.

## Reference and Example Files

| Reference | When to read |
| --- | --- |
| `references/skill-creation-workflow.md` | Creating or iterating a plugin skill: full six-step workflow, writing-style guide, common mistakes, validation checklist, structure patterns (minimal/standard/complete), best-practices DO/DON'T, and study-these-skills list |
| `references/advanced-frontmatter.md` | Configuring any optional frontmatter field: `allowed-tools`, `disallowed-tools`, `context`/`agent`/`skills`, `user-invocable`, `disable-model-invocation`, `model`, `hooks`, `paths`, `argument-hint`, case acceptance, `Skill()` permission syntax, visibility budget, visual-output generators |
| `references/skill-loading-and-runtime.md` | Understanding how skills load, resolve, and behave at runtime: precedence, nested/scoped skills, Invoke Skill tool, slash-skill stacking, `skillOverrides`/`disableBundledSkills`, dynamic content, hot-reload, `/skills` menu, compaction |
| `references/commands-vs-skills.md` | Deciding between a command and a skill, or migrating a command that has grown complex into a skill |
| `references/skill-creator-original.md` | Building a standalone (non-plugin) skill with Anthropic's original skill-creator methodology, including `init_skill.py` and `package_skill.py` |
| `examples/minimal-skill.md` | Copying a bare-bones single-file SKILL.md (git-conventions example) |
| `examples/complete-skill.md` | Copying a full skill with references/, examples/, and scripts/ (API-testing example) |
| `examples/frontmatter-templates.md` | Copy-paste frontmatter for common patterns: strong triggers, read-only, multi-domain, security-focused, plugin-specific |
