# Output Styles Reference

Output styles customize how Claude formats and structures responses. They modify Claude's system prompt directly, providing persistent formatting instructions that apply throughout a conversation.

## How Output Styles Work

When an output style is active, its markdown content is injected into Claude's system prompt. This means output styles:

- Apply to all responses while active (not just specific tool calls)
- Can override default formatting behavior
- Are selected by the user (not automatically triggered like skills)
- Can coexist with CLAUDE.md instructions (style takes precedence for formatting)

## Frontmatter Schema

Output style files use YAML frontmatter:

```yaml
---
name: concise-reviewer
description: Terse code review output with minimal prose
keep-coding-instructions: true
---
```

| Field                      | Type    | Required | Description                                                                                                                                                       |
| -------------------------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                     | String  | Yes      | Display name shown in style selection                                                                                                                             |
| `description`              | String  | Yes      | Brief explanation of what the style does                                                                                                                          |
| `keep-coding-instructions` | Boolean | No       | When `true`, preserves Claude's default coding instructions alongside the style. When `false` (default), the style replaces default coding instructions entirely. |

**`keep-coding-instructions` guidance:**

- Set to `true` for styles that only modify output format (e.g., "use bullet points", "be more concise")
- Set to `false` (or omit) for styles that fundamentally change Claude's role (e.g., "act as a technical writer", "respond only with code")

## File Locations

Output styles can be defined at multiple levels:

| Level   | Location                                       | Scope          |
| ------- | ---------------------------------------------- | -------------- |
| User    | `~/.claude/output-styles/*.md`                 | All projects   |
| Project | `.claude/output-styles/*.md`                   | Single project |
| Plugin  | Referenced via `outputStyles` in `plugin.json` | Plugin users   |

### Plugin Bundling

Plugins bundle output styles using the `outputStyles` field in `plugin.json`:

```json
{
  "outputStyles": "./styles/"
}
```

Or with explicit paths:

```json
{
  "outputStyles": ["./styles/concise.md", "./styles/detailed.md"]
}
```

Style files in the referenced path are discovered and registered when the plugin loads. Users can then select them from the output style picker.

## Built-in Styles

Claude Code includes built-in output styles that users can select. Plugin-provided styles appear alongside built-in styles in the style selection interface.

## When to Use Output Styles vs Other Components

| Component         | Best For                                | Persistence                    |
| ----------------- | --------------------------------------- | ------------------------------ |
| **Output styles** | Response formatting, tone, structure    | Active until user switches     |
| **Skills**        | Domain knowledge, workflows, procedures | Active during skill invocation |
| **Agents**        | Autonomous multi-step tasks             | Active during agent run        |
| **CLAUDE.md**     | Project context, coding standards       | Always loaded                  |

**Use output styles when:**

- You want to change how Claude formats all responses (not just during a specific task)
- The formatting applies regardless of what task Claude is performing
- Users should be able to toggle the behavior on/off

**Don't use output styles when:**

- The behavior only applies during specific operations (use a skill instead)
- You need tool restrictions or scoped hooks (use an agent)
- The instructions are project-specific standards (use CLAUDE.md)

## Example: Complete Output Style

```markdown
---
name: concise-code-review
description: Minimal code review output focused on actionable findings
keep-coding-instructions: true
---

When reviewing code:

- List only actionable findings
- Use severity labels: [critical], [warning], [nit]
- No praise or filler text
- One line per finding with file:line reference
- Group by severity, highest first
```

## Plugin Developer Tips

- Keep styles focused on a single formatting concern
- Use descriptive names that clearly indicate the style's effect
- Set `keep-coding-instructions: true` unless your style intentionally replaces coding behavior
- Test styles with various task types to ensure they don't interfere with tool use
- Document available styles in your plugin README
