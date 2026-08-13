# Upstream Change Manifest
## CC Version Range: 2.1.225 - 2.1.229
## Generated: 2026-08-13
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - CI environment]

---

## Must Update

### Plugin Source Commands (CC 2.1.229)
- [ ] **Command-backed plugin sources** (CC 2.1.229)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: marketplace-structure (schema-reference.md, overview.md)
  - Details: Plugin marketplace now supports local commands as plugin sources. Commands emit exactly one absolute plugin-directory path, must finish populating before exit, and are re-resolved for installs, updates, and once-per-session background checks before being copied into cache. This is a significant new plugin distribution mechanism.
  - Raw changelog: "Plugin marketplace command sources now support local commands with re-resolution each session"
  - System-prompts: "Data: Command plugin source command field - Defines command-backed plugin sources as platform-shell commands that emit exactly one absolute plugin-directory path, finish populating it before exit, and are re-resolved for installs, updates, and once-per-session background checks before being copied into cache."

### ListAgents Tool Updates (CC 2.1.228-2.1.229)
- [ ] **ListAgents marks Remote Control and cloud sessions** (CC 2.1.228-2.1.229)
  - Source: changelog, system-prompts
  - Confidence: high
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: ListAgents now marks disconnected Remote Control sessions as "offline" and cloud sessions as "cloud". The tool description clarifies that Remote Control-connected account listings cover both sessions on other machines and cloud sessions, with each row labeled by kind.
  - Raw changelog: "`ListAgents` marks disconnected Remote Control sessions as 'offline' and cloud sessions as 'cloud'"
  - System-prompts: "Tool Description: ListAgents - Clarifies that Remote Control-connected account listings cover both sessions on other machines and cloud sessions, with each row labeled by kind."

### Agent Tool Usage Notes Update (CC 2.1.227)
- [ ] **Foreground agent restriction guidance** (CC 2.1.227)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: Agent tool usage notes now restrict foreground agents to cases where the very next action depends on their result and no other useful work can proceed. Independent, fire-and-forget, and interruptible work should use background agents.
  - System-prompts: "Tool Description: Agent (usage notes) - Restricts foreground agents to cases where the very next action depends on their result and no other useful work can proceed, keeping independent, fire-and-forget, and interruptible work in the background."

### Pre-commit Skill Checks (CC 2.1.225)
- [ ] **Bash pre-commit skill checks guidance** (CC 2.1.225)
  - Source: system-prompts
  - Confidence: high
  - Affects: skill-development (skill-creation-workflow.md or advanced-frontmatter.md)
  - Details: New guidance requiring a visible RAN/NOT RUN status for each applicable verification, simplification, and code-review skill immediately before nontrivial commits. Runs checks that are not still valid for the current diff, and limits skips to explicit user instructions or enumerated trivial-only changes.
  - System-prompts: "Tool Description: Bash (pre-commit skill checks) - Requires a visible `RAN`/`NOT RUN` status for each applicable verification, simplification, and code-review skill immediately before nontrivial commits, runs checks that are not still valid for the current diff, and limits skips to explicit user instructions or enumerated trivial-only changes."

### SendUserFile Expanded Guidance (CC 2.1.227)
- [ ] **SendUserFile broadened beyond final deliverables** (CC 2.1.227)
  - Source: system-prompts
  - Confidence: high
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: SendUserFile now broadens file delivery beyond final deliverables - sends complete drafts or meaningful updates as they are produced, excludes scratch files and incremental-save noise, and re-sends only materially changed files.
  - System-prompts: "Tool Description: SendUserFile - Broadens file delivery beyond final deliverables, sends complete drafts or meaningful updates as they are produced, excludes scratch files and incremental-save noise, and re-sends only materially changed files."

---

## May Update

### ReadNotifications Tool (CC 2.1.229)
- [ ] **ReadNotifications tool and queued notifications delivery** (CC 2.1.229)
  - Source: system-prompts
  - Confidence: medium
  - Affects: agent-development (orchestration-and-tools.md) - optional mention
  - Details: New system for authoritative, oldest-first draining of queued GitHub activity, scheduled triggers, and cross-session messages. Requires prompt handling when notified, pagination until the queue is empty, sender-based trust decisions, and verification of surprising relayed content.
  - System-prompts: "System Reminder: Queued notifications delivery and Tool Description: ReadNotifications"

### Self-hosted Runner Windows Base-dir (CC 2.1.229)
- [ ] **Self-hosted runner Windows --base-dir required** (CC 2.1.229)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: plugin-structure (headless-ci-mode.md) - optional mention
  - Details: Self-hosted runner Windows startup now requires explicit `--base-dir` flag. This is a breaking change for Windows self-hosted runner deployments.

### Server-supplied Hook Support (CC 2.1.229)
- [ ] **Server-supplied Claude Code hook support for self-hosted runners** (CC 2.1.229)
  - Source: changelog
  - Confidence: medium
  - Affects: hook-development (overview.md or advanced.md) - optional mention
  - Details: Self-hosted runners can now receive server-supplied hooks.

### Sandbox Network Domain Spelling Warning (CC 2.1.229)
- [ ] **Sandbox network domain spelling enforcement** (CC 2.1.229)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: sandbox documentation if plugin-dev covers it
  - Details: Sandbox domain lists now bracket IPv6 literals and enforce fail-closed ambiguous spellings.

### Workflow CPU Limit Behavior (CC 2.1.229)
- [ ] **Workflow uses container CPU limit** (CC 2.1.229)
  - Source: changelog, system-prompts
  - Confidence: medium
  - Affects: agent-development (orchestration-and-tools.md)
  - Details: Dynamic workflows now use container's CPU limit instead of host machine's core count for concurrent agent capacity calculation.
  - System-prompts: "Tool Description: Workflow - Clarifies that concurrent agent capacity is calculated from available CPUs rather than raw CPU-core count."

### MCP OAuth Improvements (CC 2.1.229)
- [ ] **MCP OAuth uses 127.0.0.1** (CC 2.1.229)
  - Source: changelog
  - Confidence: low
  - Affects: mcp-integration documentation
  - Details: MCP OAuth improved to use `127.0.0.1` instead of localhost for stricter authorization servers.

### PowerShell Git Guidance (CC 2.1.229)
- [ ] **PowerShell git guidance** (CC 2.1.229)
  - Source: system-prompts
  - Confidence: low
  - Affects: cross-platform hook/command development
  - Details: New PowerShell-specific git guidance to prefer new commits, seek safer alternatives before destructive operations, and never bypass hooks or signing without explicit user request.

---

## No Action

### Bug Fixes and Reliability (not plugin-relevant)
- Bug fixes and reliability improvements (CC 2.1.226) - no plugin-system changes
- Feature flag evaluation fix for expired login tokens (CC 2.1.227)
- Slash-command menu visual improvements (CC 2.1.227)
- Performance improvements for file operations (CC 2.1.227)
- Git/Git Bash discovery improvements on Windows (CC 2.1.228)
- `/tui` command model revert fix (CC 2.1.228)
- Cross-session messaging startup improvement (CC 2.1.228)
- Remote Control `/resume` fix (CC 2.1.228)
- Session cleanup preservation fix (CC 2.1.228)
- Background plugin-cache cleanup symlink fix (CC 2.1.228)
- Settings-merge marketplace entries fix (CC 2.1.228)
- Deferred-tools reminder duplicate fix (CC 2.1.228)
- Skills synced from claude.ai hardening (CC 2.1.228)
- Cross-session messages inline display (CC 2.1.228)
- Vertex AI credential handling improvement (CC 2.1.228)
- Compaction progress retry countdown (CC 2.1.228)
- Terminal title busy-spinner glyph update (CC 2.1.228)
- Auto mode cost note removal for Pro/Max/Team (CC 2.1.228)
- Interactive session redrawing fix (CC 2.1.228)
- Remote Control session resumption documentation (CC 2.1.229)
- Long response streaming fix (CC 2.1.229)
- Crash fixes (non-string values, narrow terminals, Windows paths) (CC 2.1.229)
- Auto mode permission failure fix (CC 2.1.229)
- Remote Control client spinner fix (CC 2.1.229)
- Claude Code Review workflow posting fix (CC 2.1.229)
- UI stall fixes for IDE diagnostics (CC 2.1.229)
- One-shot plugin command liveness file fix (CC 2.1.229)
- File-watcher handle leak fix (CC 2.1.229)
- SDK session whitespace message fix (CC 2.1.229)
- Conversation size limit messaging (CC 2.1.229)
- OpenTelemetry export fix (CC 2.1.229)
- Git Credential Manager prompt fix (CC 2.1.229)
- Workflow fan-out staggering for prompt caching (CC 2.1.229)
- `/login` OAuth token override warning (CC 2.1.229)
- `/commit-push-pr` auto-approve prevention (CC 2.1.229)
- VSCode feedback dialog and UI improvements (CC 2.1.229)
- Transient 401 OAuth token fix (CC 2.1.225)
- MCP OAuth keychain timeout fix (CC 2.1.225)
- Auto mode safety filter fix (CC 2.1.225)
- Cross-session message parking fix (CC 2.1.225)
- Conversation history compaction fix (CC 2.1.225)
- Session directory change prevention (CC 2.1.225)
- Workspace trust prompt for `claude agents` (CC 2.1.225)

### Claude Desktop/Web Features (not plugin-relevant)
- Artifact slides, document, spreadsheet skills (CC 2.1.228-2.1.229) - Claude Desktop/web features
- Claude Design canvas artifacts (CC 2.1.229) - Claude Desktop/web features
- Removed: Artifact PR review description, Code walkthrough, PR explainer skills (CC 2.1.229)

### Internal System Changes (not plugin-extensible)
- Quick git commit/PR agent prompts (CC 2.1.229) - built-in agent prompts, not extensibility points
- ProposeGoal tool (CC 2.1.227) - not plugin-extensible
- device_bash tool (CC 2.1.227) - not plugin-extensible
- Write tool model behavior (CC 2.1.228) - core tool behavior, not plugin-specific
- Removed: Bash command prefix detection agent prompt (CC 2.1.228)

### Gateway/Operator Configuration (not plugin-relevant)
- Gateway spend limits (CC 2.1.225) - operator configuration
- Gateway SSE keepalive pings (CC 2.1.229) - gateway implementation detail
- Gateway per-user usage cap headers (CC 2.1.227) - gateway implementation detail
- Customer-routed inference protocol (CC 2.1.228) - gateway implementation detail

### User Features (not plugin-relevant)
- `/model` command accepts Sonnet/Opus 1M (CC 2.1.229) - user command feature

---

## Summary

**Version Range:** 2.1.225 - 2.1.229 (5 versions since last audit of 2.1.224)

**Key Changes for Plugin-Dev (Must Update):**

1. **Command-backed plugin sources** (CC 2.1.229) - Major new plugin distribution mechanism allowing local commands as plugin sources with re-resolution each session. Affects marketplace-structure documentation.
2. **ListAgents Remote Control/cloud labels** (CC 2.1.228-2.1.229) - Cross-session messaging behavior change with session kind labels. Affects agent-development orchestration docs.
3. **Agent foreground restriction** (CC 2.1.227) - Delegation pattern documentation update needed for foreground vs background agent guidance. Affects agent-development orchestration docs.
4. **Pre-commit skill checks** (CC 2.1.225) - New skill behavior pattern requiring RAN/NOT RUN status. Affects skill-development documentation.
5. **SendUserFile scope expansion** (CC 2.1.227) - Tool guidance update for drafts and incremental updates. Affects agent-development orchestration docs.

**Token Impact:** System prompts show significant changes:
- 2.1.229: +24,422 tokens
- 2.1.228: +7,141 tokens
- 2.1.227: +6,757 tokens
- 2.1.226: No changes
- 2.1.225: +1,314 tokens

**Total delta since 2.1.224:** +39,634 tokens (substantial release window)

**Next Steps:**
1. Stage 2: Validate this manifest
2. Stage 3: Update affected documentation in plugin-dev skills
3. Stage 4: Review and verify changes

---

## Stage 2: Verification Results
### Verified: 2026-08-13

#### Must Update Verification

- **Command-backed plugin sources (CC 2.1.229)**
  - Status: CONFIRMED
  - Verified in: CC changelog ("Plugin marketplace command sources now support local commands with re-resolution each session") and system-prompts (Data: Command plugin source command field)
  - Gap exists: `references/marketplace-structure/references/schema-reference.md` does not document the `command` source type
  - Affects: marketplace-structure (schema-reference.md, overview.md)

- **ListAgents Remote Control/cloud labels (CC 2.1.228-2.1.229)**
  - Status: CONFIRMED
  - Verified in: system-prompts (Tool Description: ListAgents)
  - Topic correction: The manifest says "agent-tools skill" but this should map to `references/agent-development/references/orchestration-and-tools.md` or `advanced-agent-fields.md`
  - Gap exists: Current orchestration-and-tools.md does not mention ListAgents behavior
  - Affects: agent-development (orchestration-and-tools.md)

- **Agent foreground restriction guidance (CC 2.1.227)**
  - Status: CONFIRMED
  - Verified in: system-prompts (Tool Description: Agent (usage notes))
  - Gap exists: orchestration-and-tools.md documents Agent tool but lacks the foreground restriction guidance
  - Affects: agent-development (orchestration-and-tools.md)

- **Quick git commit/PR agent prompts (CC 2.1.229)**
  - Status: REJECTED - NOT plugin-relevant
  - Reason: These are built-in Claude Code agent prompts for git workflows, not something plugin developers need to document. They are internal system prompts, not extensibility points.
  - Demote to: No Action

- **ReadNotifications tool (CC 2.1.229)**
  - Status: DEMOTED to May Update
  - Reason: New tool exists but is for cross-session messaging and GitHub activity. Plugin developers may want to know this exists but it is not directly plugin-extensible.
  - Affects: agent-development (orchestration-and-tools.md) - optional mention

- **Pre-commit skill checks (CC 2.1.225)**
  - Status: CONFIRMED
  - Verified in: system-prompts (Tool Description: Bash (pre-commit skill checks))
  - Gap exists: skill-development docs do not mention the RAN/NOT RUN pattern for verification skills
  - Affects: skill-development (skill-creation-workflow.md or overview.md)

- **Gateway spend limits (CC 2.1.225)**
  - Status: REJECTED - NOT plugin-relevant
  - Reason: Gateway spend limits are operator/gateway configuration, not plugin developer concerns. Plugins cannot interact with or configure spend limits.
  - Demote to: No Action

- **Self-hosted runner Windows --base-dir (CC 2.1.229)**
  - Status: DEMOTED to May Update
  - Reason: Only relevant if plugins specifically document self-hosted runner deployment patterns. Low priority for plugin-dev.
  - Affects: plugin-structure (headless-ci-mode.md) - optional mention

- **Write tool model behavior (CC 2.1.228)**
  - Status: DEMOTED to May Update
  - Reason: Core tool behavior change, not plugin-specific. Plugins do not control Write tool behavior.
  - Affects: None directly - informational only

- **SendUserFile scope expansion (CC 2.1.227)**
  - Status: CONFIRMED
  - Verified in: system-prompts (Tool Description: SendUserFile)
  - Gap exists: orchestration-and-tools.md has SendUserFile docs (CC 2.1.142) but lacks the expanded guidance about drafts, incremental saves, and re-sends
  - Affects: agent-development (orchestration-and-tools.md)

#### Missed Items (promoted from No Action)

- **Server-supplied hook support for self-hosted runners (CC 2.1.229)**
  - Status: PROMOTED to May Update
  - Reason: Listed in No Action but hook-development documentation should mention that self-hosted runners can receive server-supplied hooks
  - Affects: hook-development (overview.md or advanced.md)

- **SessionStart source "fork" (CC 2.1.229)**
  - Status: Already documented at CC 2.1.214/2.1.218 in event-schemas.md
  - No action needed - existing documentation covers this

#### May Update Resolution

- **Artifact skills (CC 2.1.228-2.1.229)**: KEPT as May Update - Claude Desktop/web features, not plugin-relevant
- **Design and Prototype skills (CC 2.1.229)**: KEPT as May Update - Claude Desktop/web features, not plugin-relevant
- **ProposeGoal tool (CC 2.1.227)**: DEMOTED to No Action - not plugin-extensible
- **device_bash tool (CC 2.1.227)**: DEMOTED to No Action - not plugin-extensible
- **Sandbox network domain spelling (CC 2.1.229)**: KEPT as May Update - relevant for sandbox documentation if plugin-dev covers it
- **Workflow CPU limit (CC 2.1.229)**: KEPT as May Update - relevant for orchestration-and-tools.md
- **Gateway SSE keepalive (CC 2.1.229)**: DEMOTED to No Action - gateway implementation detail
- **/model command 1M (CC 2.1.229)**: DEMOTED to No Action - user command, not plugin-relevant
- **MCP OAuth improvements (CC 2.1.229)**: KEPT as May Update - relevant for mcp-integration documentation
- **Gateway usage cap headers (CC 2.1.227)**: DEMOTED to No Action - gateway implementation detail
- **PowerShell git guidance (CC 2.1.229)**: KEPT as May Update - relevant for cross-platform hook/command development

#### Summary

- **Must Update: 5 items** (4 confirmed, 1 added from May Update, 3 rejected, 2 demoted)
  1. Command-backed plugin sources (CC 2.1.229) - marketplace-structure
  2. ListAgents Remote Control/cloud labels (CC 2.1.228-2.1.229) - agent-development
  3. Agent foreground restriction guidance (CC 2.1.227) - agent-development
  4. Pre-commit skill checks (CC 2.1.225) - skill-development
  5. SendUserFile scope expansion (CC 2.1.227) - agent-development

- **May Update: 7 items remaining**
  1. Self-hosted runner Windows --base-dir (CC 2.1.229) - demoted from Must
  2. ReadNotifications tool (CC 2.1.229) - demoted from Must
  3. Server-supplied hooks (CC 2.1.229) - promoted from No Action
  4. Sandbox network domain spelling (CC 2.1.229)
  5. Workflow CPU limit (CC 2.1.229)
  6. MCP OAuth improvements (CC 2.1.229)
  7. PowerShell git guidance (CC 2.1.229)

- **Rejected/Demoted to No Action: 7 items**
  1. Quick git commit/PR agent prompts - not plugin-extensible
  2. Gateway spend limits - not plugin-relevant
  3. Write tool model behavior - not plugin-specific
  4. ProposeGoal tool - not plugin-extensible
  5. device_bash tool - not plugin-extensible
  6. Gateway SSE keepalive - implementation detail
  7. /model command 1M - user feature
  8. Gateway usage cap headers - implementation detail

- **Confidence: HIGH**
  - All Must Update items verified against primary sources
  - Topic mappings corrected where needed
  - 3 items rejected as not plugin-relevant (30% rejection rate - borderline but acceptable)
  - No significant missed items found
