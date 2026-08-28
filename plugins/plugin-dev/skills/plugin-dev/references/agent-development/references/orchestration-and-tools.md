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

### Foreground vs Background Agents (CC 2.1.227)

Foreground agents should only be used when the very next action depends on their result and no other useful work can proceed in the meantime:

**Use foreground agents when:**

- The immediate next step requires the agent's output
- No parallel work is possible while waiting
- Synchronous coordination is essential

**Use background agents for:**

- Independent, fire-and-forget tasks
- Interruptible work that doesn't block progress
- Parallel execution of multiple tasks
- Long-running operations

**Design guidance:**

- Default to background agents for most delegated work
- Reserve foreground for critical-path dependencies
- Prefer launching multiple background agents in parallel over sequential foreground calls

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

### Expanded File Delivery Guidance (CC 2.1.227)

SendUserFile usage extends beyond just final deliverables:

**What to send:**

- Complete drafts as they are produced
- Meaningful updates during iterative work
- Materially changed files when re-sending

**What NOT to send:**

- Scratch files and temporary work
- Incremental-save noise (minor auto-saves)
- Unchanged files when re-sending updates

**Re-send behavior:**

- Only re-send files that have materially changed
- Avoid flooding the user with redundant file notifications
- Use discretion for work-in-progress vs final deliverables

**Use cases for plugin agents:**

- Report generators: Surface the final PDF/HTML report
- Export tools: Highlight generated export files
- Build artifacts: Call out compiled outputs or packages
- Iterative work: Share meaningful drafts as milestones are reached
- Background tasks: Send completed outputs to the main conversation

Hooks can match `SendUserFile` via PreToolUse/PostToolUse for validation or logging of deliverable generation.

## ListAgents Session Labels (CC 2.1.228-2.1.232)

The ListAgents tool now provides session kind labels for Remote Control-connected accounts:

**Session kinds:**

- **`offline`** — Disconnected Remote Control sessions on other machines
- **`cloud`** — Cloud-based sessions (e.g., Claude.ai web sessions)
- *(unlabeled)* — Active local sessions

**Behavior:**

- Remote Control-connected account listings cover both sessions on other machines and cloud sessions
- Each row is labeled by kind to help distinguish session types
- Useful for cross-session coordination and monitoring
- Exact live names deliver across local, remote, and cloud sessions; references (`[ref]`) are only needed for ambiguity or lookup failures

**Cloud session reply limitations (CC 2.1.232):** Cloud sessions can receive messages but cannot yet reply to another session. Design workflows that involve cloud sessions accordingly — they can be notified but cannot participate in bidirectional messaging.

**Use cases for plugin agents:**

- Identifying available sessions for cross-session messaging
- Monitoring session status across multiple machines
- Coordinating work between local and cloud sessions
- One-way notifications to cloud sessions

## Cross-Session `notify_when_idle` Parameter (CC 2.1.236)

The SendMessage tool now supports a `notify_when_idle` parameter for one-shot idle notifications when messaging local sessions:

```json
{
  "recipient": "session-name",
  "message": "Let me know when you're available",
  "notify_when_idle": true
}
```

**Behavior:**

- **One-shot subscription** — Registers for a single notification when the target session becomes idle
- **Pure subscriptions** — Can be sent without a message body to just subscribe to idle state
- **Approval-held notices** — Includes notifications when the session is held on an approval dialog
- **Expiry behavior** — Subscriptions expire after the session responds or after a timeout

**Use cases for plugin agents:**

- Polling-free coordination — Use instead of repeatedly checking session status
- Avoid status-chasing messages — Subscribe once instead of sending "are you done yet?" queries
- Async handoffs — Be notified when a background session completes its work
- User interruption awareness — Know when an autonomous session is paused for approval

**Implications for plugin agents:**

- Design multi-session workflows to use `notify_when_idle` instead of polling patterns
- Reduces message noise and improves coordination efficiency
- Works only with local sessions, not cloud or remote sessions

## SendMessage Ambiguous Recipient Display (CC 2.1.239)

SendMessage provides user-facing explanations when messages cannot be sent due to recipient ambiguity:

**"Not sent" scenarios:**

- **Inexact or duplicate agent names** — Multiple sessions match the provided name
- **Unavailable or truncated session searches** — Target session not found in search results
- **Exact-name or pinned-identity required** — Recipient requires confirmation to avoid misdirection

**Implications for plugin agents:**

- Use exact session names from ListAgents output when possible
- Include `[ref]` identifiers for ambiguous targets
- Handle cases where messages may not be delivered due to ambiguity
- Design workflows that gracefully handle failed message delivery

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

## SendFeedback Tool (CC 2.1.247)

The SendFeedback tool enables drafting feedback reports directly within Claude Code sessions:

**Purpose:**

- Draft and send feedback reports about Claude Code behavior
- Supports structured feedback with context and reproduction steps
- Integrates with Anthropic's feedback collection system

**Use cases for plugin agents:**

- Error reporting workflows that collect diagnostic information
- User feedback collection in custom support workflows
- Automated issue reporting from validation agents

**Implications for plugin agents:**

- Plugin agents inherit access to this tool
- Can be used in conjunction with other diagnostic tools
- Useful for agents designed to help users report issues
