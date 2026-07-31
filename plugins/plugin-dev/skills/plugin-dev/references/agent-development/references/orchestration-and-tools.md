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

## Sub-Agent Nesting (CC 2.1.172)

Sub-agents can now spawn their own sub-agents, enabling complex orchestration patterns. Previously, sub-agents could not spawn further sub-agents.

**Nesting limit:** Sub-agents can nest up to **5 levels deep**. Attempts to spawn beyond 5 levels will fail.

**Reconciliation with worker fork guidance:** The CC 2.1.169 guidance that forked workers should not spawn subagents still applies — forked workers should execute their directive directly. The 5-level nesting capability is for orchestrator patterns where a top-level agent spawns sub-agents that themselves need to coordinate further sub-tasks.

**Use cases:**

- Multi-stage code review: orchestrator → file analyzers → specialized checkers
- Complex refactoring: coordinator → module workers → dependency resolvers
- Test generation: planner → test writers → validation agents

**Design guidance:**

- Keep nesting shallow when possible (2-3 levels is typical)
- Top-level orchestrators handle coordination; leaf agents do the work
- Avoid recursive patterns that could hit the 5-level limit

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

## EndConversation Tool (CC 2.1.214)

The EndConversation tool allows agents to terminate conversations, primarily for handling sustained abusive behavior:

**Purpose:**

- Handles situations where users engage in sustained abusive or harassing behavior
- Terminates the conversation gracefully
- Should only be used after persistent abuse, not for single incidents

**Usage restrictions:**

- Reserved for egregious, sustained abuse (not occasional rudeness)
- Agent should attempt de-escalation first
- Should not be used for technical disagreements or user frustration with results

**Implications for plugin agents:**

- Plugin agents inherit access to this tool
- Design agents to use it sparingly and only when genuinely necessary
- Document any use of EndConversation in agent system prompts if explicitly needed

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
