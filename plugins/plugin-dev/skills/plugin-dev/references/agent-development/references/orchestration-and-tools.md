# Orchestration and Runtime Tools

This reference covers the built-in tools and orchestration behaviors agents use at runtime: delegating to sub-agents, surfacing deliverables, messaging the main conversation, driving workflows, and uploading files in browser automation. Plugin authors designing skills or agents that spawn or coordinate other agents should reference this guidance.

## Agent Tool Usage Notes (CC 2.1.140)

The Agent tool (Task tool in SDK parlance) includes simplified usage guidance that clarifies:

- **When to delegate**: Use subagents for tasks requiring focused context or parallel execution
- **Fork behavior**: Each Agent invocation starts fresh; context is not automatically inherited
- **Resumption**: Ask Claude to "resume that agent" to restore prior transcript context
- **Worktree isolation**: Background agents may run in isolated worktrees (controlled by `worktree.bgIsolation`)
- **Remote isolation (CC 2.1.178)**: Use `isolation: "remote"` to run agents in a CCR (Claude Code Runner) sandbox
- **Background execution**: Use `run_in_background` parameter for concurrent agent work
- **Parallel launches**: Send multiple Agent calls in one message for concurrent execution
- **Context restrictions**: Background agents cannot prompt for permissions

## Sub-Agent Nesting and Spawn Limits

### Nested Subagent Spawning Disabled by Default (CC 2.1.217)

**Breaking change:** As of CC 2.1.217, subagents **no longer spawn nested subagents by default**. Previously (CC 2.1.172), sub-agents could spawn their own sub-agents up to 5 levels deep.

**To enable nested spawning:** Set `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` to the desired depth (e.g., `5` for the previous default behavior).

**Why the change:** The default restriction prevents unbounded agent proliferation and encourages more deliberate orchestration design. Agents relying on nested spawning without this environment variable will silently fail to spawn sub-sub-agents.

**Impact on existing agents:**

- Agents designed for CC 2.1.172-2.1.216 that spawn nested subagents need updating
- Either set `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` in the environment
- Or redesign to use flatter coordination patterns

### Concurrent Subagent Cap (CC 2.1.217)

Claude Code now enforces a **hard limit of 20 concurrently-running subagents** (default). Override with `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`.

**Design implications:**

- Large parallel fan-outs may hit this cap
- Design orchestration to process in batches if needed
- Monitor concurrent agent count in complex workflows

### Per-Session Subagent Spawn Limit (CC 2.1.212)

A per-session cap of **200 subagent spawns** (default) prevents runaway agent creation. Combined with WebSearch limits (200/session), these caps protect against resource exhaustion.

### Coordinator Worker Instructions Update (CC 2.1.217)

Workers can now use the Agent tool for **bounded parallel work** when spawn depth permits:

- **Changed from:** Workers should not spawn subagents
- **Changed to:** Workers can fan out through Agent tool for bounded parallel research, review, and cleanup

Worker fan-out is conditional on:

1. Remaining spawn depth (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`)
2. Agent tool availability (not blocked by `disallowedTools`)

**Use cases for worker fan-out:**

- Parallel file analysis across multiple modules
- Concurrent test execution
- Multi-angle code review

### Design Guidance

- Keep nesting shallow when possible (2-3 levels is typical)
- Top-level orchestrators handle coordination; leaf agents do the work
- Set explicit spawn depth limits rather than relying on defaults
- Consider the 20-concurrent cap when designing parallel patterns

## SendUserFile Tool (CC 2.1.142)

The SendUserFile tool surfaces generated deliverable files to users with enhanced visibility. When agents create reports, exports, or other artifact files, use SendUserFile instead of just writing them silently:

```json
{
  "file_path": "/path/to/report.pdf",
  "caption": "Analysis report for Q4 metrics",
  "status": "normal"
}
```

**Parameters:**

- `file_path`: Absolute path to the generated file
- `caption`: Optional description shown to the user
- `status`: `"normal"` (default) or `"proactive"` (for unsolicited deliverables)
- `display` (CC 2.1.196): Controls rendering mode — `"inline"` for charts, HTML pages, diagrams, and images that should render directly in chat; `"attachment"` for files meant to be saved and opened elsewhere

**Use cases for plugin agents:**

- Report generators: Surface the final PDF/HTML report
- Export tools: Highlight generated export files
- Build artifacts: Call out compiled outputs or packages

Hooks can match `SendUserFile` via PreToolUse/PostToolUse for validation or logging of deliverable generation.

## SendMessageTool "main" Recipient (CC 2.1.178)

Background subagents can now message the main conversation using `"main"` as the recipient in SendMessageTool:

```json
{
  "recipient": "main",
  "message": "Background task completed: processed 150 files"
}
```

**Behavior:**

- Only available to background subagents
- Messages appear in the main conversation thread
- Enables coordination between background agents and the primary session
- Useful for progress updates and completion notifications

**Use cases for plugin agents:**

- Progress reporting from long-running background tasks
- Alerting the user when background work completes
- Requesting user input from a background context (though the agent cannot receive the response directly)

## Workflow Tool Limits (CC 2.1.163)

The Workflow tool's `parallel()` and `pipeline()` functions have a **4096 item limit**. Calls exceeding this limit will error explicitly. Design workflows to stay within this constraint:

- Break large item sets into chunks of 4096 or fewer
- Use pagination for processing large datasets
- Consider sequential processing for very large workloads

## Workflow Tool Effort Option (CC 2.1.178)

The Workflow tool's `agent()` spawns now accept an `effort` option that overrides reasoning effort.

**Values:** `'low'` | `'medium'` | `'high'` | `'xhigh'` | `'max'`

**Behavior:**

- **Omit** — Inherit the session's current effort level
- **`'low'`** — Use for cheap mechanical stages (formatting, simple transforms)
- **Higher tiers** — Reserve for the hardest verify/judge stages that need maximum reasoning

**Example:**

```javascript
workflow.agent({
  prompt: "Verify the refactoring is correct",
  effort: "high"  // Use higher effort for verification
})
```

**Design guidance:**

- Default to inheriting session effort (omit the option)
- Use `'low'` for stages that don't require deep reasoning
- Reserve `'high'`/`'xhigh'`/`'max'` for critical validation steps

## Browser File Upload Tool (CC 2.1.163)

A new browser file upload tool uploads shared session files directly to page file inputs by element reference:

**Key features:**

- Uploads files to browser page file input elements
- Combined upload limit of **10 MB**
- Uses element refs to target specific inputs

**Use cases for plugin agents:**

- Automating file uploads in web testing scenarios
- Browser automation workflows that require file inputs
- Form-filling agents that handle attachments

## Session Forking and Subtask Commands (CC 2.1.212)

Two new commands manage session and subagent context:

### /fork Command

The `/fork` command copies the current conversation into a **new background session**:

- Creates a separate session with the conversation history
- Background session runs independently
- Useful for long-running work while continuing in the foreground
- Returns a session ID for later reference

**Use cases:**

- Starting a large refactoring job while continuing other work
- Running extensive tests in the background
- Parallel investigation of different approaches

### /subtask Command

The `/subtask` command replaces the in-session subagent functionality from the old `/fork` behavior:

- Creates a subagent within the current session
- Subagent has access to current context
- For in-session parallel work, not background sessions

**Migration note:** If you previously used `/fork` for in-session subagent work, use `/subtask` instead. `/fork` is now exclusively for background session creation.

## Subagent Delegation Restraint (CC 2.1.215)

Claude Code includes guidance limiting when to use subagent delegation. Plugin developers designing orchestration patterns should follow these constraints:

**When to use subagents:**

- Genuinely independent, sizeable tasks
- Parallel work that benefits from concurrent execution
- Tasks requiring focused, isolated context

**When NOT to use subagents:**

- Small tasks that can be done inline
- Inline verification of recent work
- Redundant fan-out that duplicates work
- Tasks where parent context is essential

**Design implications:**

- Favor a few precisely briefed agents over many shallow ones
- Keep inline verification in the parent agent
- Don't spawn subagents for tasks under a few hundred tokens of work
- Consider whether the overhead of spawning justifies the parallelism

## Agent Tool Conditional Steering (CC 2.1.215)

Agent tool usage notes are now conditional on the **default subagent steering mode**. Mode-specific guidance for fork behavior, prompt writing, examples, and remote isolation is injected contextually.

**Implications for plugin authors:**

- Agent dispatch patterns may behave differently depending on steering mode
- Document steering mode assumptions in plugin README if relevant
- Test plugins with different steering mode configurations
