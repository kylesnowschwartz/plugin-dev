# Headless & CI Mode Plugin Compatibility

Plugins behave differently in headless mode (`claude -p`) versus interactive sessions. Understanding these differences is critical for building plugins that work reliably across all runtime contexts.

## Headless Mode Basics

Headless mode executes Claude Code as a single-shot command-line tool:

```bash
claude -p "Analyze this codebase for security issues" --allowedTools "Read,Grep,Glob"
```

### What Works in Headless Mode

- **Hooks:** Command hooks execute normally. Prompt hooks work for supported events.
- **MCP servers:** Start and connect as usual. Tools are available.
- **CLAUDE.md:** Project and user memory files load normally.
- **Agents:** Can be spawned via Task tool during execution.
- **Skills (as context):** Skill content with `user-invocable: false` loads into context and is available for Claude to use.

### What Does NOT Work in Headless Mode

- **Slash commands:** `/skill-name` invocation requires an interactive session. Skills cannot be invoked via slash commands in `-p` mode.
- **Interactive prompts:** `AskUserQuestion` tool is not available — there's no user to answer.
- **Skill tool (manual):** Users can't type `/` to invoke skills. Instead, describe the task and let Claude use the skill content if loaded.

### Workaround for Skills

Instead of invoking `/review` in headless mode, describe the task:

```bash
# Won't work:
claude -p "/review"

# Works — describe what you want:
claude -p "Review the codebase for code quality issues"
```

If the skill has `user-invocable: false` and is loaded via plugin, Claude can still use its knowledge automatically.

## Permission Control

### --allowedTools

Auto-approve specific tools without interactive prompts:

```bash
claude -p "Fix the bug" --allowedTools "Read,Write,Edit,Bash(git *)"
```

**Permission rule syntax:**

| Pattern                | Matches                                                      |
| ---------------------- | ------------------------------------------------------------ |
| `Read`                 | All Read tool calls                                          |
| `Bash(git *)`          | Bash commands starting with "git " (prefix match with space) |
| `mcp__*`               | All MCP tool calls                                           |
| `mcp__plugin_myplug_*` | Tools from a specific plugin's MCP server                    |
| `Write,Edit`           | Multiple tools (comma-separated)                             |

**Plugin design tip:** Document recommended `--allowedTools` values in your plugin README for CI usage.

### --max-turns

Limit autonomous tool-use iterations to control cost and runtime:

```bash
claude -p "Run tests and fix failures" --allowedTools "Read,Edit,Bash" --max-turns 10
```

Each tool call counts as one turn. Without this limit, Claude may iterate indefinitely on complex tasks.

## Structured Output

### JSON Output

Get machine-readable responses:

```bash
claude -p "List all TODO comments" --output-format json
```

Returns:

```json
{
  "result": "Found 5 TODO comments...",
  "session_id": "abc123",
  "metadata": { ... }
}
```

### JSON Schema Validation

Enforce a specific output structure:

```bash
claude -p "Extract function signatures from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

**Plugin design tip:** If your plugin provides analysis workflows, document example JSON schemas users can use for structured CI output.

## System Prompt Interaction

### --append-system-prompt

Add instructions alongside the default system prompt (and any loaded plugin content):

```bash
claude -p "Review code" --append-system-prompt "Focus on security vulnerabilities only"
```

Plugin skill content loads before system prompt overrides. The append adds to (not replaces) existing context.

### --system-prompt

Replace the default system prompt entirely:

```bash
claude -p "Analyze" --system-prompt "You are a security auditor..."
```

**Caution:** This replaces the default prompt but plugin content still loads. The interaction between `--system-prompt` and plugin skills may produce unexpected behavior.

## Session Management

### Continue Last Session

```bash
claude -p "What was the last change you made?" --continue
```

### Resume Specific Session

```bash
claude -p "Continue fixing the auth bug" --resume "$SESSION_ID"
```

Plugin state (hooks, MCP servers, skill context) reloads when resuming a session.

## Plugin Design Guidelines for CI Compatibility

### 1. Test in Headless Mode

```bash
# Test your plugin works in non-interactive mode
claude -p "Run the plugin's primary workflow" \
  --plugin-dir /path/to/plugin \
  --allowedTools "Read,Write,Edit,Bash"
```

### 2. Avoid Interactive-Only Patterns

- Don't rely on `AskUserQuestion` for critical workflows
- Provide sensible defaults when user input is unavailable
- Design hooks that work without user confirmation

### 3. Document CI Usage

Include a CI section in your plugin README:

```markdown
## CI/Headless Usage

This plugin works in headless mode. Example:

\`\`\`bash
claude -p "Run security audit" \
 --allowedTools "Read,Grep,Glob,Bash(npm:\*)" \
 --max-turns 20 \
 --output-format json
\`\`\`
```

### 4. Handle Missing Environment Gracefully

In CI environments, some tools or context may be unavailable:

- MCP servers may not have authentication tokens
- Git history may be shallow clones
- Environment variables may differ from local dev

Design hooks and skills to handle these cases without failing hard.

### 5. Cost-Conscious Design

CI runs can accumulate significant API costs. Help users control spending:

- Recommend `--max-turns` values for common workflows
- Use `haiku` model for simple analysis skills
- Document expected token usage for key workflows
