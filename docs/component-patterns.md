# Component Patterns

Reference for plugin component frontmatter and structure.

## Agents

Agents require YAML frontmatter with:

- `name`: kebab-case identifier (3-50 chars)
- `description`: Starts with "Use this agent when...", includes `<example>` blocks
- `model`: inherit/sonnet/opus/haiku
- `color`: blue/cyan/green/yellow/magenta/red
- `tools`: Comma-separated list of allowed tools (optional)
- `skills`: Comma-separated list of skills the agent can load (optional)

## Skills

Skills require:

- Directory in `skills/skill-name/`
- `SKILL.md` with YAML frontmatter (`name`, `description`)
- Strong trigger phrases in description
- Progressive disclosure (detailed content in `references/`)

### Skill Structure

Each skill follows progressive disclosure:

- `SKILL.md` - Core content (1,000-2,200 words, lean)
- `references/` - Detailed documentation loaded into context as needed
- `examples/` - Complete working examples and templates for copy-paste
- `scripts/` - Utility scripts (executable without loading into context)

## Commands

Commands are markdown files with frontmatter:

- `description`: Brief explanation (required)
- `argument-hint`: Optional argument placeholder text
- `allowed-tools`: Comma-separated list of permitted tools (restricts tool access)
- `model`: Model to use for command execution (inherit/sonnet/opus/haiku)
- `disable-model-invocation`: Set to `true` to prevent model invocation in subagents (for workflow commands that delegate to specialized agents)

## Skills/Agents Optional Frontmatter

Both skills and agents support `allowed-tools` to restrict tool access:

```yaml
allowed-tools: Read, Grep, Glob # Read-only skill
```

Use for read-only workflows, security-sensitive tasks, or limited-scope operations.

## Hooks

Hooks defined in `hooks/hooks.json`:

- Events: PreToolUse, PermissionRequest, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification
- Types: `prompt` (LLM-driven) or `command` (bash scripts)
- Use matchers for tool filtering (e.g., "Write|Edit", "\*")

### Plugin hooks.json Format

Plugin hooks use wrapper format with `hooks` field:

```json
{
  "hooks": {
    "PreToolUse": [...],
    "Stop": [...]
  }
}
```
