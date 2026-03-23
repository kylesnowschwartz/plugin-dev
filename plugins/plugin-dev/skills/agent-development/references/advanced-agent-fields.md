# Advanced Agent Fields

This reference covers agent frontmatter fields beyond the core fields (name, description, model, color, tools, disallowedTools, skills, permissionMode). These enable turn limits, persistent memory, scoped MCP access, lifecycle hooks, and advanced execution patterns.

## maxTurns

Limit the maximum number of agentic turns (API round-trips) before the agent stops.

```yaml
maxTurns: 50
```

### Choosing Values

| Task Type                     | Suggested Range | Rationale                       |
| ----------------------------- | --------------- | ------------------------------- |
| Quick checks, linting         | 5-15            | Focused, fast completion        |
| Code review, analysis         | 20-40           | Needs to read multiple files    |
| Complex refactoring, creation | 50-100          | Multi-file changes with testing |

If omitted, the agent runs until it completes or is interrupted. Set `maxTurns` to prevent runaway agents from consuming excessive resources, especially for background agents where there's no user to interrupt.

## memory

Enable persistent memory that survives across sessions.

```yaml
memory: user
```

### Scopes

| Scope     | Directory                                  | Use When                         |
| --------- | ------------------------------------------ | -------------------------------- |
| `user`    | `~/.claude/agent-memory/<agent-name>/`     | Personal preferences, defaults   |
| `project` | `.claude/agent-memory/<agent-name>/`       | Codebase-specific knowledge      |
| `local`   | `.claude/agent-memory-local/<agent-name>/` | Gitignored project-specific data |

### How It Works

When `memory` is set:

1. System prompt includes instructions for reading/writing the memory directory
2. First 200 lines of `MEMORY.md` are auto-injected into the agent's system prompt
3. Read, Write, and Edit tools are automatically enabled (even if not in `tools` list)
4. Agent should curate `MEMORY.md` if it exceeds 200 lines

### Best Practices

- Use `user` scope as the default for most agents
- Use `project` or `local` for codebase-specific learning
- Include memory management instructions in the agent's system prompt (e.g., "After completing a task, update your MEMORY.md with key learnings")

## mcpServers

Scope MCP servers to the agent, controlling which external services it can access.

### Reference by Name

Reference an already-configured MCP server:

```yaml
mcpServers:
  slack:
```

The agent inherits the full configuration of the named server from the project/user MCP settings.

### Inline Configuration

Provide full server config scoped to the agent:

```yaml
mcpServers:
  custom-api:
    command: "${CLAUDE_PLUGIN_ROOT}/servers/api-server"
    args: ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"]
    env:
      API_KEY: "${API_KEY}"
```

### Use Cases

- Restrict a code review agent to only read-only MCP tools
- Give a deployment agent access to CI/CD servers but not database servers
- Provide agent-specific server configuration

## hooks

Define lifecycle hooks scoped to the agent. These hooks activate when the agent starts and deactivate when it finishes.

### Format

```yaml
hooks:
  PreToolUse:
    - matcher: Write
      hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
          timeout: 10
  Stop:
    - hooks:
        - type: prompt
          prompt: "Verify all tasks are complete before stopping."
```

### Supported Events

All hook events are supported in agent frontmatter. Key behavior difference:

- **`Stop`** hooks are automatically converted to **`SubagentStop`** at runtime, since agents are subprocesses
- Hooks only run while the agent is active and are cleaned up when the agent finishes

### Comparison with hooks.json

| Aspect   | `hooks.json`                               | Agent frontmatter `hooks`                       |
| -------- | ------------------------------------------ | ----------------------------------------------- |
| Scope    | Global (always active when plugin enabled) | Agent-specific (active only during agent run)   |
| Events   | All hook events                            | All events (Stop auto-converts to SubagentStop) |
| Location | `hooks/hooks.json` file                    | YAML frontmatter in agent .md file              |
| Use case | Plugin-wide validation                     | Agent-specific safety checks                    |

## Execution Modes

### Background vs Foreground

- **Foreground** (default): Blocks the main conversation until the agent completes. User can interact if the agent requests permission.
- **Background**: Runs concurrently with the main conversation. All permissions must be pre-approved at spawn time since the user cannot be prompted.

Background agents that encounter an unapproved permission request will fail. Design tool restrictions (`tools`, `permissionMode`) accordingly when agents may run in background.

### Resuming Agents

Each Task tool invocation creates a new agent instance with a fresh context. To continue with the full prior context preserved, ask Claude to "resume that agent" or "continue that subagent" — it will restore the previous transcript.

Agent transcripts are stored at `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`.

### Restricting Spawnable Agent Types

Use `Task(agent_type1, agent_type2)` syntax in settings.json allow rules to control which agent types can be spawned:

```json
{
  "permissions": {
    "allow": ["Task(code-reviewer, test-runner)"]
  }
}
```

- `Task(type1, type2)` — only these agent types can be spawned
- `Task` (no parentheses) — allow any subagent
- Omitting `Task` entirely — cannot spawn any subagents

## Built-in Agent Types

Claude Code includes several built-in agent types that can be referenced in the `agent` field of skills or used as targets for `Task()` restrictions:

| Agent Type          | Model   | Tools     | Purpose                             |
| ------------------- | ------- | --------- | ----------------------------------- |
| `Explore`           | Haiku   | Read-only | Fast codebase exploration/search    |
| `Plan`              | Inherit | Read-only | Codebase research during planning   |
| `general-purpose`   | Inherit | All       | Complex multi-step tasks            |
| `Bash`              | Inherit | Bash      | Terminal commands in isolation      |
| `statusline-setup`  | Haiku   | Read/Edit | Status line configuration           |
| `Claude Code Guide` | Haiku   | Read-only | Documentation and feature questions |

## Agent Teams (Experimental)

Agent teams enable multi-agent coordination where a team lead spawns and manages multiple independent Claude Code sessions as teammates. This is an experimental feature requiring `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

### Key Concepts

- **Team lead**: Main session that creates the team, spawns teammates, and coordinates work
- **Teammates**: Independent Claude Code instances with their own context windows
- **Shared task list**: Coordinated work items that teammates claim and complete
- **Messaging**: Direct messages and broadcasts between team members

### Designing Team Lead Agents

Team leads coordinate work across multiple teammates. Key design considerations:

- **Use `permissionMode: delegate`** to restrict the lead to coordination-only tools (spawn, message, shut down teammates, manage tasks). This prevents the lead from implementing tasks directly.
- **System prompt focus**: Task decomposition, work assignment, progress monitoring, quality review
- **Tools**: Team leads automatically get access to `TeamCreate`, `TaskCreate`, `TaskUpdate`, `TaskList`, `SendMessage`, and `Task` (for spawning)

```yaml
# Example team lead agent
permissionMode: delegate
```

### Permission Inheritance

Teammates inherit the team lead's permission settings. If the lead runs with `--dangerously-skip-permissions`, all teammates inherit that too. Plan permission modes accordingly — a permissive lead creates permissive teammates.

### Context Isolation

Teammates load CLAUDE.md, MCP servers, and skills from the project, but do NOT inherit the lead's conversation history. Each teammate starts with a fresh context window; the spawn prompt provides initial task context.

### Token Cost

Each teammate is a separate Claude Code session with its own context window. Token costs scale linearly with team size. Worth the extra cost for genuinely parallel work, but avoid spawning teammates for tasks that could be done sequentially.

### Designing Teammate Agents

Teammates are spawned by the team lead and work independently on assigned tasks:

- **Self-contained context**: Each teammate has its own context window; don't assume shared state
- **Task-focused prompts**: System prompt should focus on a specific type of work (e.g., "you are a test writer")
- **Tool restrictions**: Use `tools` to limit what each teammate can do based on their role
- **Plan mode for review**: Use `permissionMode: plan` for teammates that should propose changes for lead approval

### Display Modes

The `teammateMode` setting controls how agent teams display in the terminal:

| Mode         | Behavior                                                  |
| ------------ | --------------------------------------------------------- |
| `in-process` | All teammates in main terminal; Shift+Up/Down to navigate |
| `tmux`       | Split panes, each teammate in its own pane                |
| `auto`       | Split panes if in tmux, in-process otherwise (default)    |

### Team Hooks

Use hook events to enforce quality standards in team workflows:

| Event           | Fires When                   | Use Case                                      |
| --------------- | ---------------------------- | --------------------------------------------- |
| `TeammateIdle`  | A teammate finishes its turn | Trigger code review, run tests on changes     |
| `TaskCompleted` | A task is marked complete    | Validate deliverables, update documentation   |
| `SubagentStart` | A teammate spawns            | Log team activity, enforce naming conventions |
| `SubagentStop`  | A teammate finishes          | Clean up resources, collect metrics           |

### Plan Approval Mode

Teammates can be configured to require plan approval from the team lead before implementing:

1. Teammate uses `permissionMode: plan`
2. Teammate explores codebase and creates a plan
3. Teammate calls `ExitPlanMode`, which sends plan to team lead
4. Team lead reviews and approves/rejects via `SendMessage` with `plan_approval_response`
5. On approval, teammate exits plan mode and proceeds with implementation

This pattern is useful for complex tasks where the lead wants to review approach before execution.

For complete documentation, see the [official agent teams guide](https://code.claude.com/docs/en/agent-teams).
