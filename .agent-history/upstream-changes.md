# Upstream Change Manifest
## CC Version Range: 2.1.225 - 2.1.226
## Generated: 2026-08-10
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - agent dispatch failed in CI]

---

## Summary

Two versions released since last audit (CC 2.1.224):
- **2.1.226**: Bug fixes only, no system prompt changes
- **2.1.225**: +1,314 tokens with several new features

---

### Must Update

No changes in versions 2.1.225-2.1.226 directly affect the plugin system, hook events, skill format, or manifest fields.

---

### May Update

- [ ] **Bash pre-commit skill checks** (CC 2.1.225)
  - Source: system-prompts changelog
  - Confidence: medium (workflow guidance, not schema change)
  - Affects: skill documentation (optional best-practice note)
  - Details: NEW tool description requires visible `RAN`/`NOT RUN` status for each applicable verification, simplification, and code-review skill immediately before nontrivial commits. Runs checks that are not still valid for the current diff. Limits skips to explicit user instructions or enumerated trivial-only changes.
  - Raw: "Tool Description: Bash (pre-commit skill checks) -- Requires a visible `RAN`/`NOT RUN` status for each applicable verification, simplification, and code-review skill immediately before nontrivial commits, runs checks that are not still valid for the current diff, and limits skips to explicit user instructions or enumerated trivial-only changes."
  - Stage 2 note: Could be documented as a best practice for verification/review skills, but does not change skill format or schema.

---

### No Action

**Version 2.1.226:**
- Bug fixes and reliability improvements only - No system prompt changes

**Version 2.1.225 (internal/non-plugin changes):**
- Gateway spend-limit messaging enhancements - Internal messaging
- Workspace trust prompts for agents - IDE/workspace-specific
- OAuth token handling fixes - Authentication internals
- MCP server improvements on macOS - Platform-specific fix
- Permission check refinements - Internal behavior
- Cross-session messaging fixes - Bug fix for existing feature (documented in 2.1.224)
- Remote Control session resume corrections - Bug fix
- Dream memory consolidation updates - Memory system internals
- Auto-memory durable lesson instructions - Memory system internals
- Plugin eval authoring interview field corrections (`plugins` -> `suite.plugins`, `cost_usd` -> `costUsd`) - Plugin eval internals
- SendFeedback drafting guidance expansion - Feedback tool internals

**Demoted from May Update (Stage 2):**
- ListAgents Remote Control reframing - Remote Control feature, out of scope for plugin-dev
- RemoteTrigger webhook-trigger creation - Remote Control feature, out of scope for plugin-dev
- Artifact publishing completeness requirement - Claude.ai Artifact feature, not plugin system
- Artifact comment reply composer - Claude.ai Artifact feature, not plugin system
- Workshop artifact HTML template update - Claude.ai Artifact feature, not plugin system
- /code-review ultra mode routing - Built-in slash command, not a plugin capability

---

## Analysis Notes

### Version 2.1.226
No changes to system prompts. Bug fixes and reliability improvements only.

### Version 2.1.225
Token delta: +1,314 tokens

Key themes in this release:
1. **Pre-commit skill verification** - New structured requirement for skill status before commits
2. **Remote Control enhancements** - ListAgents and RemoteTrigger webhook capabilities
3. **Artifact publishing hardening** - Completeness requirements for deliverables
4. **Code review ultra mode** - Cloud-based multi-agent review option

### Relevance to plugin-dev

None of these changes directly affect:
- plugin.json manifest schema
- Hook event types or schemas
- Skill frontmatter fields
- Agent configuration options
- MCP integration patterns

The changes are primarily about:
- Built-in tool behavior refinements
- Artifact/workshop workflows (Claude.ai specific)
- Remote Control features (multi-device specific)
- Pre-commit verification patterns (workflow guidance)

---

## Recommendation

**No mandatory updates required for plugin-dev v0.35.0.**

The "May Update" items could inform documentation examples or best practices but do not require schema, compatibility, or reference documentation changes. Specifically:

1. **Bash pre-commit skill checks**: Could be documented as a best practice for verification/review skills, but does not change skill format
2. **ListAgents/RemoteTrigger**: Remote Control features outside plugin-dev scope
3. **Artifact changes**: Claude.ai-specific features, not plugin system
4. **Code review ultra**: Built-in slash command, not a plugin capability

If no action is taken, update `docs/claude-code-compatibility.md` to reflect audit completion for 2.1.225-2.1.226 with no changes needed.

---

## Token Deltas from System-Prompts

| Version | Delta |
|---------|-------|
| 2.1.226 | 0 |
| 2.1.225 | +1,314 |

**Total delta since 2.1.224:** +1,314 tokens (minimal release)

---

## Source Verification

### CC Changelog (https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)

**2.1.226:**
> Bug fixes and reliability improvements

**2.1.225:**
> - gateway spend-limit messaging enhancements
> - workspace trust prompts for agents
> - OAuth token handling fixes
> - MCP server improvements on macOS
> - permission check refinements
> - cross-session messaging fixes
> - Remote Control session resume corrections

### System-Prompts Changelog (./claude-code-system-prompts/CHANGELOG.md)

**2.1.226:**
> No changes to the system prompts in v2.1.226.

**2.1.225 (+1,314 tokens):**
> - NEW: Tool Description: Bash (pre-commit skill checks)
> - Data: Workshop artifact HTML template
> - System Prompt: Artifact comment reply composer
> - Tool Description: Artifact
> - Tool Description: ListAgents
> - Tool Description: RemoteTrigger prompt
> - Agent Prompt: /code-review workflow routing
> - Agent Prompt: Dream memory consolidation
> - Data: Managed Agents [multiple entries]
> - Skill: Artifact PR review
> - Skill: Artifact design and Tool Description: Artifact publishing
> - Skill: Plugin eval authoring interview
> - Tool Description: SendFeedback drafting guidance

---

## Stage 2: Verification Results
### Verified: 2026-08-10

#### Must Update Verification

No "Must Update" items were claimed in the original manifest. After independent verification:

- Confirmed: No changes in 2.1.225-2.1.226 affect plugin.json schema, hook event types/schemas, skill frontmatter fields, agent configuration options, or MCP integration patterns.

#### Missed Items (promoted from No Action)

None identified. Plugin-relevant keyword scan of 2.1.225-2.1.226 system-prompts changelog found:

- "Bash (pre-commit skill checks)" - Workflow guidance for pre-commit verification, not a skill format change. Does not require plugin-dev documentation.
- "Plugin eval authoring interview" corrections (`plugins` -> `suite.plugins`, `cost_usd` -> `costUsd`) - Internal Anthropic eval tooling field names, not exposed to plugin developers. Does not require plugin-dev documentation.

Both items correctly classified as "No Action" since they do not affect the plugin developer interface.

#### May Update Resolution

- = **Bash pre-commit skill checks** (CC 2.1.225) — kept as May Update: workflow guidance that could inform skill best practices, but no schema changes requiring documentation
- down **ListAgents Remote Control reframing** (CC 2.1.225) — demoted to No Action: Remote Control feature, completely out of scope for plugin-dev
- down **RemoteTrigger webhook-trigger creation** (CC 2.1.225) — demoted to No Action: Remote Control feature, completely out of scope for plugin-dev
- down **Artifact publishing completeness requirement** (CC 2.1.225) — demoted to No Action: Claude.ai Artifact feature, not plugin system
- down **Artifact comment reply composer** (CC 2.1.225) — demoted to No Action: Claude.ai Artifact feature, not plugin system
- down **Workshop artifact HTML template update** (CC 2.1.225) — demoted to No Action: Claude.ai Artifact feature, not plugin system
- down **/code-review ultra mode routing** (CC 2.1.225) — demoted to No Action: built-in slash command, not a plugin capability

#### Summary

- Must Update: 0 items (0 confirmed, 0 rejected, 0 added)
- May Update: 1 item remaining (Bash pre-commit skill checks - optional best-practice note)
- No Action: 13 items (6 demoted from May Update + 7 original)
- Confidence: HIGH

The original manifest classification was accurate. No plugin-system changes in versions 2.1.225-2.1.226 require documentation updates to plugin-dev. The +1,314 token delta in CC 2.1.225 consists entirely of:
1. Built-in tool/workflow guidance (Bash pre-commit, /code-review ultra)
2. Claude.ai-specific features (Artifacts, Remote Control)
3. Internal tooling corrections (plugin eval field names)
4. Memory/feedback system internals

**Recommendation confirmed:** Update `docs/claude-code-compatibility.md` to record audit completion for 2.1.225-2.1.226 with no documentation changes needed.
