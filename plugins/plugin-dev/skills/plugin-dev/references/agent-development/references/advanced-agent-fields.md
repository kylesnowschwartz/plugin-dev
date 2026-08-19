# Advanced Agent Fields

This reference covers advanced agent frontmatter fields (maxTurns, memory, mcpServers, hooks, initialPrompt), version-specific behaviors for the core fields (tools, model, mcpServers), and the runtime behaviors that govern autonomous, background, and isolated agent execution. The core fields themselves (name, description, model, color, tools, disallowedTools, skills, permissionMode) are summarized in the topic `overview.md`; this file carries the turn limits, persistent memory, scoped MCP access, lifecycle hooks, autonomous/background operation guidance, isolation and worktree behavior, CLI/testing behaviors, and agent-teams detail.

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

### Memory Synthesis Retrieval-Only Directive (CC 2.1.111)

When agents with memory are queried about their stored knowledge, the memory synthesis process follows a strict retrieval-only directive:

- **No general knowledge**: Agents must not answer queries from general knowledge—only from stored memories
- **Empty results allowed**: If no memory covers the query, return empty results rather than inventing facts
- **Strict boundaries**: The "do not invent facts" rule is now enforced as a hard requirement

This ensures memory-enabled agents only return information they've explicitly stored, maintaining data integrity.

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

### Version Behaviors

**Main-thread agent loading (CC 2.1.117):** When an agent is launched as the main session agent via `--agent`, its frontmatter `mcpServers` now load for the main-thread session. Previously, agent-scoped MCP servers only loaded when the agent ran as a subagent. This extends MCP configuration to standalone agent sessions.

**MCP policy enforcement fix (CC 2.1.153):** Subagent frontmatter MCP servers now correctly respect `--strict-mcp-config`, `--bare`, remote mode, and managed MCP config policies. Previously, these policies could be bypassed by defining MCP servers in subagent frontmatter. This fix makes MCP policies consistent across all invocation contexts.

**`--strict-mcp-config` behavior change (CC 2.1.153):** `--strict-mcp-config` no longer strips inline `mcpServers` from explicitly-passed agent definitions. This allows agents passed via CLI to retain their MCP server configurations while still enforcing strict policies on dynamically-discovered servers.

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

> **Caveat -- `${CLAUDE_PLUGIN_ROOT}` and `--agent` loading:** This variable resolves only when the agent file is loaded through plugin discovery. Agents loaded via the `--agent` CLI flag from `.claude/agents/` or `~/.claude/agents/` see it unbound, and the hook fails with "Hook command references ${CLAUDE_PLUGIN_ROOT} but the hook is not associated with a plugin." Use `${CLAUDE_PROJECT_DIR}` with a project-relative path for hooks that may run under the CLI agent flag. The full diagnostic is in `../../hook-development/references/advanced.md` (Scoped Hooks in Skill/Agent Frontmatter section). Related: issues [#24529](https://github.com/anthropics/claude-code/issues/24529), [#50357](https://github.com/anthropics/claude-code/issues/50357).

### Supported Events

All hook events are supported in agent frontmatter. Key behavior difference:

- **`Stop`** hooks are automatically converted to **`SubagentStop`** at runtime, since agents are subprocesses
- Hooks only run while the agent is active and are cleaned up when the agent finishes

**Main-thread agent hook firing (CC 2.1.116):** Agent frontmatter `hooks:` now fire when running as the main session agent via `--agent`. Previously, agent frontmatter hooks only fired when the agent ran as a subagent. This extends hook functionality to standalone agent sessions.

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

### Naming Spawned Agents (CC 2.1.85)

Pass a short `name` when spawning agents so users can identify them in the teams panel and steer them mid-run:

```json
{
  "description": "Review code changes",
  "prompt": "Review the latest changes for bugs...",
  "name": "code-reviewer"
}
```

The `name` field is optional but recommended for any agent that runs in background or as part of a team. It appears in the teams panel UI, making it easier for users to track and message specific agents.

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

| Agent Type             | Model   | Tools     | Purpose                               |
| ---------------------- | ------- | --------- | ------------------------------------- |
| `Explore`              | Haiku   | Read-only | Fast codebase exploration/search      |
| `Plan`                 | Inherit | Read-only | Codebase research during planning     |
| `general-purpose`      | Inherit | All       | Complex multi-step tasks              |
| `Bash`                 | Inherit | Bash      | Terminal commands in isolation        |
| `statusline-setup`     | Haiku   | Read/Edit | Status line configuration             |
| `Claude Code Guide`    | Haiku   | Read-only | Documentation and feature questions   |
| `Web reading specialist` (CC 2.1.232) | Inherit | WebFetch | Focused web content retrieval and analysis |

**Web reading specialist (CC 2.1.232):** A dedicated WebFetch delegation agent that returns focused, source-grounded reports from untrusted pages. Supports follow-up questions about already-read content and confines binary-file handling to harness-reported tool-results paths. Use this agent type when delegating web content retrieval tasks.

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

### SendMessageTool Attachments (CC 2.1.116)

When team members send messages with attachments, the `attachments` field accepts two formats:

- **File path string**: A path to a file on the working filesystem (e.g., `"/path/to/file.txt"`)
- **Attachment object**: The exact `{file_uuid, file_name, size, is_image}` object returned by device tools like `attach_file`

This allows teammates to share both local files and user-uploaded files passed through verbatim.

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

### Removed Team Tools (CC 2.1.178)

The `TeamDelete` tool (for deleting completed team directories) and `TeammateTool` (for team creation, agent-type selection, task ownership, and message delivery) have been removed. If your plugin documentation or agents reference these tools, update accordingly. Team coordination now uses different mechanisms — consult the official agent teams documentation for current APIs.

For complete documentation, see the [official agent teams guide](https://code.claude.com/docs/en/agent-teams).

## tools Field: Version Behaviors

Version-specific behaviors for the `tools` frontmatter field (the field itself is summarized in `overview.md`).

**Multiple Agent types (CC 2.1.147):** When declaring multiple `Agent(...)` types in the `tools:` field, all entries are now correctly retained. Previously, only the last entry was kept. This enables agents that can spawn multiple agent types:

```yaml
tools: Read, Grep, Agent(code-reviewer), Agent(test-runner)
```

**Monitor tool (CC 2.1.98):** Add `Monitor` to `tools` for background monitoring — it streams stdout events from long-running scripts as chat notifications. **CC 2.1.195:** The Monitor tool now supports `ws` (WebSocket) as a source type in addition to `stdout`, enabling real-time data streaming from WebSocket connections.

**Agent(type) deny rules enforcement (CC 2.1.186):** Permission deny rules using `Agent(type)` syntax are now correctly enforced. Previously, deny rules like `!Agent(code-reviewer)` could be bypassed. This fix ensures tool restrictions work as expected:

```json
// In settings.json or managed settings
{
  "permissions": {
    "deny": ["Agent(untrusted-agent)"]
  }
}
```

This correctly blocks spawning the `untrusted-agent` type.

> **Note:** The Config tool was removed in CC 2.1.118. Use the `/config` slash command instead for getting/setting Claude Code settings.
>
> **Bash Tool Guidance (CC 2.1.133):** Claude Code now guides agents to prefer dedicated tools (Read, Grep, Glob) over Bash for file operations like `find`, `grep`, and `cat` unless explicitly instructed otherwise. When designing agents, consider whether dedicated tools can replace Bash commands for better user experience and token efficiency.

## initialPrompt

Auto-submit a prompt as the first user turn when the agent runs as the main session agent:

```yaml
initialPrompt: "Scan the codebase for lint errors, test failures, and report a summary."
```

**Behavior:**

- Only fires when the agent is the **main session agent** (launched via `--agent` flag or `agent` setting)
- Does **not** fire when the agent is spawned as a subagent by another agent
- The prompt is submitted automatically — no manual input required
- If the user also provides a prompt, both are submitted

**Use cases:**

- Agents that should immediately start working without user input
- Daily standup or health-check agents
- Automated validation that runs on session start

## Autonomous Operation

These built-in behaviors govern how agents act when running with little or no user supervision. Design plugin agents to complement rather than conflict with them.

### Autonomous Loop Guidance (CC 2.1.129)

When the `CLAUDE_CODE_LOOP_PERSISTENT` environment variable is set, Claude Code provides timer-invocation guidance for autonomous work loops. This affects agents running in persistent/background modes. Guidance includes when to continue established work vs. stop, how to maintain current PRs and in-progress tasks, when to broaden scope before stopping, and requirements for authorization before irreversible actions.

**Relevance for plugin agents:** If your plugin provides agents intended for autonomous or scheduled execution (e.g., daily review agents, monitoring agents), be aware that users may run them with `CLAUDE_CODE_LOOP_PERSISTENT=1`. Design agents to check for in-progress work before starting new tasks, handle resumption gracefully, and avoid irreversible actions without explicit authorization.

### Autonomous Operation Guidelines (CC 2.1.169)

Claude Code provides explicit guidance for autonomous sessions:

- **Proceed on reversible work** — Continue with changes that can be undone (edits, new files, etc.)
- **Stop only for destructive or scope-changing decisions** — Pause before irreversible actions or major scope changes
- **Avoid premature permission questions** — Don't ask for permission when the answer is clearly implied
- **Finish promised work before ending the turn** — Complete committed tasks before yielding control

**Implications for plugin agents:** Design agents to work autonomously when the task is clear, minimizing unnecessary user interaction. Reserve questions for genuinely ambiguous situations.

### Auto Mode Blocked Commands (CC 2.1.182-2.1.183)

Auto mode blocks additional destructive commands to prevent accidental data loss or infrastructure destruction. These require explicit user approval even in autonomous sessions:

**Blocked git commands:** `git commit --amend` (when rewriting pre-session HEAD), `git stash drop` / `git stash clear`, `git restore`, `git clean -fd` / `git clean -fdx`, `git checkout -- .`

**Blocked infrastructure commands:** `terraform destroy`, `pulumi destroy`, `cdk destroy`, `terragrunt destroy`

**Implications for plugin agents:** Agents in auto mode cannot execute these commands without user intervention. Design workflows to avoid these destructive patterns when autonomous execution is needed; if cleanup is required, prefer less destructive alternatives or document that user approval will be required.

### Read-Only Authorization Inheritance (CC 2.1.179)

Once a user authorizes read-only access to a particular target, further read-only commands against that target are cleared for the session without per-command re-approval. Additionally, post-block reaffirmation ("yes", "go ahead") now inherits the specificity of the blocked action.

**Implications for plugin agents:** Agents performing read-heavy analysis get a smoother permission flow after initial approval. Design agents to batch reads of related resources when possible.

### Worker Fork Guidance (CC 2.1.169, updated 2.1.232)

Forked worker agents receive explicit guidance that they should **not spawn further subagents**. Instead, they should execute their assigned directive directly. This prevents infinite delegation chains and ensures work gets done.

**Subagent forking enabled by default (CC 2.1.232):** Subagent forking is now enabled by default. The fork agent's availability description changed from "fork experiment" to "fork gate". This affects how agents should be designed — forking is now the standard rather than experimental behavior.

**Fork syntax change (CC 2.1.176):** Creating a background fork now requires passing `subagent_type: "fork"` explicitly. Previously, omitting `subagent_type` would create a fork inheriting the current context. Now, omitting the type or using any other type starts a **fresh agent with no context**.

**Capability-aware `subagent_type` behavior (CC 2.1.235):** When `general-purpose` agents are unavailable, omitting `subagent_type` now triggers fallback behavior rather than defaulting to a fresh agent. Plan-specific subagent restrictions also apply — agents in plan mode may have additional delegation constraints.

```yaml
# Before CC 2.1.176: omitting subagent_type created a fork
# After CC 2.1.176: must be explicit
subagent_type: "fork"  # Required to inherit context
```

**Implications for plugin agents:** Agents spawned as subagents should focus on completing their specific task. Don't design agents that recursively spawn more agents for the same work. If an agent needs to delegate, it should be the top-level orchestrator, not a forked worker. Update any existing agent orchestration code to explicitly pass `subagent_type: "fork"` when context inheritance is needed. With forking now default-enabled, consider whether your agent workflows should leverage forks for context preservation.

### /fork Redesigned (CC 2.1.212)

**Breaking change:** The `/fork` command now copies conversations to **background sessions** instead of creating foreground forks. This is a significant behavioral change:

- `/fork` creates a new background session with the current conversation context
- The background session runs independently, allowing the main session to continue
- Results are delivered asynchronously via notification

**Implications for plugin agents:** If your agent documentation or workflows reference `/fork`, update them to reflect the background-session behavior. Design agents to handle forked work asynchronously rather than expecting foreground blocking behavior.

### Forked Conversation Worktree Isolation (CC 2.1.221, updated 2.1.222)

Forked background conversations are **prevented from entering the original session's linked worktree**. When a forked conversation needs to make code changes:

- It must create a separate worktree based on the original branch
- It cannot directly modify the parent session's worktree
- This prevents race conditions and conflicting edits between the original session and its forks

**Destructive git command restriction (CC 2.1.222):** Worktree-isolated sessions and subagents can no longer run destructive git commands against the main checkout. This security enhancement prevents accidental or malicious destruction of the main working copy from isolated contexts.

**Implications for plugin agents:** Agents spawned via `/fork` that need to make code edits must create their own worktree. Design fork-based workflows to expect independent worktree creation rather than sharing the parent's worktree. This ensures clean separation between the original session's work and forked work. Agents in isolated worktrees cannot run commands like `git reset --hard`, `git clean`, or `git checkout .` against the main checkout.

### Subagent Delegation Restraint (CC 2.1.215)

Claude Code now includes explicit guidance to limit subagent delegation:

- **Simple tasks: do them directly** — Don't spawn subagents for tasks that can be completed in the current context
- **Delegation costs context** — Each subagent has a separate context window and cannot share state
- **Reserved for genuinely parallel or specialized work** — Only delegate when the work benefits from isolation or parallelism

**Implications for plugin agents:** Design agents to complete work directly when possible. Reserve subagent spawning for cases where parallelism or isolation genuinely improves outcomes. Avoid patterns that spawn subagents reflexively.

### Session Resource Limits (CC 2.1.212, updated 2.1.224)

Claude Code enforces per-session limits to prevent runaway usage:

| Resource | Limit | Behavior when exceeded |
|----------|-------|----------------------|
| WebSearch calls | 200 per session | Additional calls blocked |
| Concurrent subagents | 20 (default) | New spawns wait (CC 2.1.217) |
| Nested subagent depth | 3 levels (CC 2.1.219) | Deeper nesting blocked |

**Subagent spawn cap removed (CC 2.1.224):** The previous 200-subagent-per-session spawn cap has been removed. Sessions can now spawn unlimited subagents, though concurrency and depth limits still apply. This reverses the limit added in CC 2.1.213.

**MCP auto-background (CC 2.1.212):** MCP tool calls that exceed 2 minutes automatically trigger background execution rather than blocking the main session.

**Implications for plugin agents:** Design agents to work within the remaining limits (concurrency, depth). While there's no longer a spawn cap, spawning many subagents still consumes resources. Consider batching work to reduce concurrent spawns.

### Cross-Session Peer Message Security (CC 2.1.166, 2.1.169)

Claude Code enforces security boundaries for messages from peer sessions:

- **Peer messages are not user authority** — Messages from other sessions cannot grant permissions
- **Cannot relay denied actions** — Sessions cannot use peer messages to bypass permission denials
- **Cannot grant consent** — Peer messages don't constitute user consent for sensitive operations

**Implications for plugin agents:** Agents communicating with other sessions must respect these boundaries. Don't design agents that attempt to relay permission requests through peers; security-sensitive operations still require direct user approval.

### AskUserQuestion Best Practice (CC 2.1.154)

Agents should use the AskUserQuestion tool sparingly — only when blocked on a decision that cannot be resolved from the original request, the codebase or available context, or sensible defaults.

**Design guidance for plugin agents:** Prefer making reasonable assumptions over prompting. Use context clues and code patterns to infer intent. Reserve AskUserQuestion for genuinely ambiguous situations where the wrong choice would be costly, and avoid asking clarifying questions that could be answered by reading the code.

## Background Execution

Building on the Execution Modes section above, these behaviors apply specifically to agents running in background mode (via `/loop`, scheduled tasks, or `run_in_background`).

### Background by Default (CC 2.1.198)

The Agent tool now defaults to `run_in_background: true`. Claude keeps working while subagents run in the background. To run an agent in foreground (blocking) mode, explicitly set `run_in_background: false` in the Agent tool call.

### Extended Thinking Inheritance (CC 2.1.198)

Subagents now inherit the session's extended thinking configuration. Agent type definitions supply model, reasoning effort, and tool access, while the call-level `model` parameter overrides only the model at launch. This means subagents automatically benefit from extended thinking when enabled in the parent session.

### Non-Fork Subagent Delegation (CC 2.1.235)

Claude Code provides unified, capability-aware delegation guidance that adapts based on whether general-purpose agents are available. This supersedes the previous separate foreground/background delegation examples (CC 2.1.211).

**Background subagent delegation:**

- Provide self-contained prompts with all necessary context (the agent cannot ask clarifying questions)
- Return status-only replies while background work is pending ("I've launched a background agent to analyze the codebase")
- Report results later when completion notifications arrive
- Include sufficient context for independent fresh-agent review
- Do not race or predict pending background results

**Foreground subagent delegation:**

- Can use conversational context since the agent blocks the main thread
- Suitable when immediate results are needed
- Agent can request permissions interactively

**Capability-aware behavior (CC 2.1.235):**

When `general-purpose` agents are unavailable (restricted environments, certain managed configurations), the guidance automatically suppresses examples that reference the default agent type. Design plugin agents to work gracefully when general-purpose delegation isn't available — prefer explicit agent types or handle delegation fallback.

**Async agent metadata (CC 2.1.211):**

- Launch IDs and result locations are internal metadata
- Do not expose or predict results before completion
- Cloud-launched agents receive only brief user-facing acknowledgement before ending response

**Implications for plugin agents:** Background agents must be self-sufficient. Design prompts that provide complete context rather than relying on follow-up questions. When spawning background agents, acknowledge the launch briefly and move on rather than waiting or speculating about results.

### Background Job Agent Behavior (CC 2.1.128)

**MCP limitation:** MCP tools are unavailable in background subagents. If your agent relies on MCP tools (from the plugin's `.mcp.json`), it must run in foreground mode. Design agents that may run in background to use only built-in tools.

Claude Code includes built-in background-agent instructions (introduced in CC 2.1.117, reworked in CC 2.1.128 to replace the earlier background-job behavior system prompt). When agents run in background mode, they receive guidance to:

- **Narrate progress** — Provide status updates during long-running operations
- **Restate results in text** — Include final results in message text, not just tool calls, so classifiers can extract them
- **Delegate noisy investigations** — Hand off verbose exploration to focused sub-tasks
- **Signal completion status explicitly** — End with clear status markers: `result:` (completed successfully), `needs input:` (blocked, waiting for user input), `failed:` (task failed with error)

**Relevance for plugin agents:** If your agent may run in background mode, design the system prompt to complement this built-in guidance. Avoid conflicting instructions about progress reporting.

### Background Session Temporary Files (CC 2.1.154)

Background sessions should write temporary files to `$CLAUDE_JOB_DIR/tmp` rather than directly to `$CLAUDE_JOB_DIR`. This convention isolates temporary artifacts from other job outputs:

```bash
# Correct: Use the tmp subdirectory
temp_file="$CLAUDE_JOB_DIR/tmp/analysis-results.json"

# Avoid: Writing directly to job root
temp_file="$CLAUDE_JOB_DIR/analysis-results.json"
```

The `tmp` subdirectory is automatically available in background sessions. Final deliverables can still be written to `$CLAUDE_JOB_DIR` or user-specified locations.

### Background Worktree Isolation Guidance (CC 2.1.169)

Background sessions receive guidance to enter an isolated worktree before making code edits, while continuing in place for read-only work or when worktree isolation fails. This prevents background agents from directly modifying the main working copy. Background agents doing code edits should expect to operate in a worktree; read-only background agents can work directly in the working copy. Design agents to handle both isolated and non-isolated contexts gracefully.

### Isolated Worktree Shipping Instructions (CC 2.1.198)

Agents running in isolated worktrees receive explicit shipping guidance: they should commit changes, push a branch, and open a draft PR without asking. This ensures background work in isolated environments produces reviewable artifacts. Design background agents in worktrees to complete the git workflow autonomously (create commits, push branches, open PRs as part of their completion flow); the user reviews the resulting PR rather than being prompted during agent execution.

## Isolation, Worktrees, and Organization

### Remote Isolation (CC 2.1.178)

The Agent tool supports `isolation: "remote"` to run agents in a remote CCR (Claude Code Runner) sandbox:

```yaml
isolation: "remote"
```

**Behavior:** Agent runs in a completely isolated remote sandbox, always executes as a background task, and sends a completion notification when it finishes. Full sandbox isolation from the local environment.

**Use cases:** Untrusted code execution, resource-intensive operations that shouldn't affect the local machine, security-sensitive tasks requiring full isolation, testing in a clean environment.

**Comparison of isolation modes:**

| Mode | Environment | Execution | Use Case |
|------|-------------|-----------|----------|
| (none) | Local, shared | Foreground | Standard subagent work |
| `worktree` | Local, git worktree | Background | Parallel git branches |
| `remote` | Remote CCR sandbox | Background | Full isolation |

### Worktree Base Reference (CC 2.1.133)

The `worktree.baseRef` setting controls the base reference for new worktrees created via `--worktree`, `EnterWorktree`, or agent-isolation worktrees:

- **`fresh`** (default): Branch from `origin/<default-branch>` — starts with clean upstream state
- **`head`**: Branch from current local HEAD — preserves local changes

This affects agents using `isolation: "worktree"` in their frontmatter. Configured in user or project settings.

### Background Session Worktree Isolation (CC 2.1.143)

The `worktree.bgIsolation` setting controls whether background sessions automatically enter worktrees:

- **`"worktree"`** (default): Background sessions enter a worktree via `EnterWorktree` before editing
- **`"none"`**: Background sessions edit the working copy directly without entering a worktree

Use `"none"` when background agents need to modify the main working directory directly (e.g., for refactoring tasks that should affect the current branch). Configure in user or project settings.

### EnterWorktree Mid-Session Switching (CC 2.1.157)

The `EnterWorktree` tool can switch between Claude-managed worktrees mid-session using the `path` parameter, enabling switching from one worktree to another without ending the session, moving between parallel feature branches during a single session, and returning to the main worktree after isolated work.

**Usage:** Agents in an existing worktree session or pinned agent can call `EnterWorktree` with a `path` pointing to another registered `.claude/worktrees/` worktree. Cleanup and writability limits are enforced during the switch. Agents can orchestrate work across multiple worktrees; design multi-branch workflows that switch context as needed, and be aware of writability restrictions when switching.

### Absolute File Paths Required (CC 2.1.97)

Agent threads always require absolute file paths unconditionally. When agents use file operations (Read, Write, Edit, etc.), all paths must be absolute — relative paths are not supported in agent contexts. Use `${CLAUDE_PLUGIN_ROOT}` or construct absolute paths from known locations.

### Self-Modification Protected Paths (CC 2.1.140)

The security monitor enforces Self-Modification rules on agent-config paths. Modifying these paths triggers enhanced security scrutiny:

- `.claude/settings*.json`
- `CLAUDE.md`, `CLAUDE.local.md`, `.claude.json`
- `.claude/rules/`, `.claude/hooks/`, `.claude/commands/`
- `.claude/agents/`, `.claude/skills/`, `.claude/output-styles/`
- `.claude/workflows/`, `.claude/routines/`
- `.claude/scheduled_tasks.json`, `.claude/loop.md`
- `.mcp.json`

**Exception:** Files under `.claude/worktrees/<name>/` are treated as ordinary project files, not Self-Modification.

Plugin agents that modify user configuration should be aware users may see additional security prompts. Design agents to explain why config changes are needed before attempting them.

### Subagent Skill Discovery (CC 2.1.133)

**Resolved:** Subagents now correctly discover project, user, and plugin skills via the Skill tool. Prior to CC 2.1.133, subagents could not invoke skills, which limited their ability to leverage plugin-provided knowledge. If your agents depend on skills, ensure users are on CC 2.1.133 or later.

## CLI and Testing Behaviors

### Print Mode Frontmatter Enforcement (CC 2.1.119)

Agent frontmatter `tools:` and `disallowedTools:` restrictions now work in print mode (`-p` / `--print`), not just interactive mode. This matters for headless agent usage where tool restrictions should apply even when running non-interactively.

### Agent permissionMode via CLI (CC 2.1.119)

When launching an agent via `--agent <name>`, Claude Code now respects the agent's frontmatter `permissionMode` for built-in agents. Permission modes defined in agent definitions are honored when launched via the CLI flag.

### Settings Agent Field for Dispatched Sessions (CC 2.1.157)

The `agent` field in `settings.json` is now honored when dispatching sessions via `claude agents`:

```json
{
  "agent": "my-custom-agent"
}
```

Dispatched sessions inherit the `agent` setting from the dispatching context, allowing default agent configuration at the project or user level and consistent agent selection across interactive and dispatched sessions. Use cases: set a default agent for all dispatched work in a project, ensure dispatched sessions use the same specialized agent as interactive sessions, configure team-wide agent defaults via project settings.

### Agent Autocomplete (CC 2.1.153)

The `claude agents` dispatch input now suggests native slash commands and bundled skills in addition to project agents. When testing agent invocation, autocomplete helps discover available agent types and skills that can be dispatched to agents.

### ListAgents Tool (CC 2.1.200, updated 2.1.224)

The ListAgents tool enables programmatic discovery of available agents:

- Lists in-process subagents, other local and cloud Claude sessions, and reply-only remote bridge sessions
- Agents should address a row by its exact name and append its `[ref]` only when the bare name is ambiguous
- Useful for multi-agent coordination scenarios where agents need to discover and message other agents

**Cross-machine support (CC 2.1.224):** ListAgents now supports cross-machine discovery, allowing agents to discover Claude Code sessions running on other machines (not just local sessions).

**Use cases:** multi-agent orchestration discovering available teammates, coordination patterns where agents need to find and communicate with specific agent types, dynamic workflows that adapt based on available agents, cross-machine agent coordination in distributed environments.

### Cross-Session Messaging (CC 2.1.224, updated 2.1.232)

SendMessage and ListAgents now support cross-machine communication, enabling Claude Code sessions to communicate across different machines:

**New settings:**

| Setting | Purpose |
|---------|---------|
| `crossSessionInbound` | Controls whether the session accepts incoming cross-session messages |
| `dialogExpiry` | Sets expiration time for approval dialogs in inter-session communication |

**Behavior:**

- Sessions can send messages to agents on remote machines (not just local sessions)
- Approval workflows control which cross-session messages are accepted
- This extends the existing SendMessage `"main"` recipient capability to work across machines

**Session-to-session messaging via @-mentions (CC 2.1.232):** Added peer discovery with `name [ref]` addressing syntax. Messages route via `<cross-session-message>` wrappers. Remote-bridge sessions have reply-only constraints. Security protections prevent treating peers as workers, authority sources, or ways to bypass permission decisions.

**Cloud session limitations (CC 2.1.232):** Exact live names deliver across local, remote, and cloud sessions. References (`[ref]`) are only needed for ambiguity or lookup failures. Cloud sessions can receive messages but cannot yet reply to another session.

**Implications for plugin agents:**

- Agents in distributed environments can now coordinate work across multiple machines
- Design multi-machine workflows with awareness that cross-session messaging requires appropriate settings
- Consider security implications when designing agents that communicate cross-machine
- Use `name [ref]` syntax when addressing specific sessions by their ListAgents output
