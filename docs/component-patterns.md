# Component Patterns

Reference for plugin component frontmatter and structure.

## Agents

Agents require YAML frontmatter with:

- `name`: kebab-case identifier (3-50 chars)
- `description`: Starts with "Use this agent when...", includes `<example>` blocks
- `model`: inherit/sonnet/opus/haiku
- `color`: blue/cyan/green/yellow/magenta/red
- `tools`: Comma-separated list of allowed tools (optional, allowlist)
- `disallowedTools`: Comma-separated list of blocked tools (optional, denylist — use one or the other)
- `skills`: Comma-separated list of skills the agent can load (optional)
- `permissionMode`: default/acceptEdits/delegate/dontAsk/bypassPermissions/plan (optional)
- `maxTurns`: Number limiting agentic turns (optional)
- `memory`: user/project/local for persistent memory (optional)
- `mcpServers`: Scoped MCP server access (optional)
- `hooks`: Lifecycle hooks scoped to agent (optional)

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

**Skills** use `allowed-tools`:

```yaml
allowed-tools: Read, Grep, Glob # Read-only skill
```

**Agents** use `tools` (allowlist) or `disallowedTools` (denylist):

```yaml
tools: Read, Grep, Glob # Allowlist
# OR
disallowedTools: Bash, Write # Denylist
```

> **Note:** Field names differ — skills use `allowed-tools`, agents use `tools`/`disallowedTools`.

## Hooks

Hooks defined in `hooks/hooks.json`:

- Events: PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure, Stop, SubagentStart, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification, TeammateIdle, TaskCompleted
- Types: `prompt` (LLM-driven), `command` (bash scripts), or `agent` (multi-step with tools)
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
