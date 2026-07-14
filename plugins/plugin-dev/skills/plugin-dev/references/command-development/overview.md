
# Command Development for Claude Code

> **Note:** The `.claude/commands/` directory is a legacy format. For new plugins, prefer the `skills/<name>/SKILL.md` directory format. Both are loaded identically by Claude Code -- the only difference is file layout. The skills format supports progressive disclosure via `references/` and `examples/` subdirectories. See the Skill Development reference for the preferred format.

## Overview

Slash commands are frequently-used prompts defined as Markdown files that Claude executes during interactive sessions. Understanding command structure, frontmatter options, and dynamic features enables creating powerful, reusable workflows.

**Key concepts:**

- Markdown file format for commands
- YAML frontmatter for configuration
- Dynamic arguments and file references
- Bash execution for context
- Command organization and namespacing

## Commands Are Instructions FOR Claude

A slash command is a Markdown file containing a prompt that Claude executes when invoked. Commands provide reusability (define once, use repeatedly), consistency (standardize common workflows), sharing (across team or projects), and efficiency (quick access to complex prompts).

**Commands are written for agent consumption, not human consumption.** When a user invokes `/command-name`, the command content becomes Claude's instructions. Write commands as directives TO Claude about what to do, not as messages TO the user describing what will happen.

**Correct approach (instructions for Claude):**

```markdown
Review this code for security vulnerabilities including:

- SQL injection
- XSS attacks
- Authentication issues

Provide specific line numbers and severity ratings.
```

Avoid the inverse -- text like "This command will review your code and you'll receive a report." That tells the user what happens but never instructs Claude. Always write the directive form.

## Command Locations

**Project commands** (shared with team):

- Location: `.claude/commands/`
- Label: "(project)" in `/help`
- Use for: Team workflows, project-specific tasks

**Personal commands** (available everywhere):

- Location: `~/.claude/commands/`
- Label: "(user)" in `/help`
- Use for: Personal workflows, cross-project utilities

**Plugin commands** (bundled with plugins):

- Location: `plugin-name/commands/`
- Label: "(plugin-name)" in `/help`
- Use for: Plugin-specific functionality

Claude Code also ships built-in commands for managing state, sessions, configuration, and plugins (`claude project purge`, `/cd`, `/config`, `/plugin list`). See `references/built-in-commands.md`.

## File Format

Commands are Markdown files with a `.md` extension -- one file per command:

```
.claude/commands/
├── review.md           # /review command
├── test.md             # /test command
└── deploy.md           # /deploy command
```

A basic command needs no frontmatter -- the file body is the prompt:

```markdown
Review this code for security vulnerabilities including SQL injection,
XSS attacks, authentication bypass, and insecure data handling.
```

Add configuration with optional YAML frontmatter:

```markdown
---
description: Review code for security issues
allowed-tools: Read, Grep, Bash(git *)
model: sonnet
---

Review this code for security vulnerabilities...
```

## Frontmatter Fields (Quick Reference)

All fields are optional. Commands work without any frontmatter.

| Field                      | Type         | Purpose                                                                                                   |
| -------------------------- | ------------ | --------------------------------------------------------------------------------------------------------- |
| `description`              | String       | Shown in `/help`; required for Skill-tool visibility. Keep under ~60 chars. Defaults to first prompt line. |
| `allowed-tools`            | String/Array | Tools the command may use (e.g. `Read, Bash(git *)`). Defaults to conversation permissions.               |
| `disallowed-tools`         | String/Array | Tools to remove from the pool while the command runs (e.g. `AskUserQuestion, WebSearch`). (CC 2.1.152)    |
| `model`                    | String       | `haiku`/`sonnet`/`opus` shorthand or full model ID (e.g. `claude-sonnet-4-5-20250929`). Defaults to conversation model. |
| `argument-hint`            | String       | Documents expected args for autocomplete (e.g. `[pr-number] [priority]`).                                 |
| `disable-model-invocation` | Boolean      | When `true`, only the user can invoke the command (not the Skill tool). Default `false`.                  |

For full field specifications, valid values, comparison tables, and a validation checklist, see `references/frontmatter-reference.md`.

## Dynamic Arguments

**`$ARGUMENTS`** captures all arguments as a single string:

```markdown
Fix issue #$ARGUMENTS following our coding standards and best practices.
```

`> /fix-issue 123` expands to `Fix issue #123 following...`.

**Positional arguments** (`$1`, `$2`, `$3`, ...) capture individual arguments:

```markdown
Review pull request #$1 with priority level $2.
After review, assign to $3 for follow-up.
```

`> /review-pr 123 high alice` substitutes each position in order. Positional and trailing arguments combine freely, e.g. `Deploy $1 to $2 environment with options: $3`.

## File References

The `@` syntax injects file contents into the command before Claude processes it:

```markdown
Review @$1 for code quality, best practices, and potential bugs.
```

`> /review-file src/api/users.ts` reads that file first. Reference multiple or static files the same way: `Compare @src/old-version.js with @src/new-version.js`, or `Review @package.json and @tsconfig.json for consistency`.

## Bash Execution in Commands

Commands can execute bash inline to gather context (repository state, environment info) before Claude processes the prompt.

### The `[BANG]` Prefix

In actual command files, put `[BANG]` (an exclamation mark) before the backticks:

```markdown
Current branch: [BANG]`git branch --show-current`
Files changed: [BANG]`git diff --name-only`
Environment: [BANG]`echo $NODE_ENV`
```

Before Claude sees the command, Claude Code executes each `[BANG]`command`` block and replaces the whole expression with its output. Claude then receives the expanded prompt with actual values -- for example, `Review the 3 changed files on branch feature/add-auth.`

Use bash execution to include dynamic context (git status, environment variables), gather project/repository state, and build context-aware workflows.

**Why skill examples omit `[BANG]`:** when skill content loads into Claude's context, `[BANG]` followed by a command name would actually execute. Skill and reference examples therefore show the conceptual pattern with plain backticks (`` `git diff --name-only` ``); add the `[BANG]` prefix when writing real command files.

### Load-Time Injection vs Runtime Execution

The `[BANG]` syntax performs **load-time context injection**: commands execute when the command loads, and their output becomes static text in the prompt Claude receives. This differs from Claude choosing to run commands at runtime via the Bash tool. Use `[BANG]` for gathering starting context (git status, environment variables, config files), not for actions Claude should perform during the task.

**Disable shell execution (CC 2.1.91):** Organizations can disable inline shell execution in skills, custom slash commands, and plugin commands via the `disableSkillShellExecution` setting. When enabled, `[BANG]`command`` blocks are not executed. Design commands to work gracefully when shell execution is unavailable.

For advanced bash patterns, environment-specific configs, and `${CLAUDE_PLUGIN_ROOT}` script execution, see `references/plugin-features-reference.md`.

## Commands vs Skills: When to Use Which

Commands and skills are both invoked via the same **Skill tool**. The difference is organizational complexity:

| Aspect    | Commands                        | Skills                            |
| --------- | ------------------------------- | --------------------------------- |
| Location  | `commands/`                     | `skills/name/`                    |
| Format    | Single `.md` file               | `SKILL.md` + optional resources   |
| Resources | None                            | scripts/, references/, examples/  |
| Best for  | Quick prompts, simple workflows | Complex knowledge, bundled assets |

**Invocation control** (works for both): `disable-model-invocation: true` makes an item user-only (for side effects like deploy or commit); the default lets both Claude and the user invoke it.

**When to graduate a command to a skill:** if you need scripts, reference files, or progressive disclosure, convert the command to a skill. For how the Skill tool discovers and invokes commands (visibility, character budget, permission rules, `user-invocable`), see `references/skill-tool.md`.

## Command Organization

Use a flat structure for small sets (5-15 commands, no clear categories). For 15+ commands with clear categories, group them in subdirectories -- the subdirectory name becomes a namespace shown in `/help` (e.g. `commands/git/commit.md` → `/commit (project:git)`). Plugin commands follow the same auto-discovery and namespacing rules; see `references/plugin-features-reference.md`.

Commands also integrate with other plugin components -- launch agents, trigger skills, coordinate with hooks -- and should validate inputs and resources before processing. See `references/plugin-integration.md` for integration and validation patterns.

## Reference Map

| Reference                                | When to read                                                                                                                                          |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `references/frontmatter-reference.md`    | Need full specs for a frontmatter field, valid values, allowlist vs denylist comparison, or a pre-commit validation checklist                         |
| `references/skill-tool.md`               | Understanding how Claude auto-invokes commands/skills: visibility rules, character budget, permission rules, `user-invocable`                          |
| `references/plugin-features-reference.md`| Writing plugin commands: `${CLAUDE_PLUGIN_ROOT}`, auto-discovery, namespacing, and plugin-specific bash/config/template patterns                       |
| `references/plugin-integration.md`       | Wiring a command to plugin agents, skills, or hooks, or adding argument/file/resource validation                                                      |
| `references/interactive-commands.md`     | The command needs interactive user input via AskUserQuestion (multi-choice, multi-select, conditional flows)                                          |
| `references/advanced-workflows.md`       | Building multi-step/stateful workflows, chaining commands, advanced argument handling (`$IF`, defaults, validation), or command authoring best practices |
| `references/documentation-patterns.md`   | Adding self-documenting comments, help subcommands, changelogs, or a companion README                                                                 |
| `references/testing-strategies.md`       | Validating and testing commands, or troubleshooting a command that will not appear, substitute arguments, run bash, or read file references           |
| `references/marketplace-considerations.md`| Distributing commands: cross-platform compatibility (incl. Windows PowerShell), graceful degradation, discovery, and quality standards               |
| `references/built-in-commands.md`        | Looking up a built-in Claude Code command (`claude project purge`, `/cd`, `/config`, `/plugin list`)                                                   |
| `examples/simple-commands.md`            | Want copy-paste examples of standalone commands (review, test, deploy, compare) plus quick pattern templates                                          |
| `examples/plugin-commands.md`            | Want copy-paste examples of plugin commands using `${CLAUDE_PLUGIN_ROOT}`, scripts, templates, agents, and skills                                     |

## Validation Scripts

Utility scripts for validating commands (execute without loading into context):

```bash
# Validate command file structure
./scripts/validate-command.sh .claude/commands/my-command.md

# Validate YAML frontmatter fields
./scripts/check-frontmatter.sh .claude/commands/my-command.md

# Validate multiple files
./scripts/validate-command.sh commands/*.md
./scripts/check-frontmatter.sh commands/*.md
```
