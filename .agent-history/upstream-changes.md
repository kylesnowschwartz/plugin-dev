# Upstream Change Manifest
## CC Version Range: 2.1.201 - 2.1.202
## Generated: 2026-07-07
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - no significant doc-related changes requiring verification]

---

## Summary

Only one new version (2.1.202) was found after the last audited version (2.1.201). The changes are primarily bug fixes, internal improvements, and a new `/code-review` command variant. No breaking changes to the plugin system were identified.

---

### Must Update

No changes requiring mandatory plugin-dev updates were found.

---

### May Update

(All items demoted to No Action by Stage 2 verification - see Stage 2 results below)

---

### No Action

**Demoted from May Update (Stage 2):**
- `/code-review` command added as multi-agent variant of `/review` (CC 2.1.202) - documents built-in CC commands, not plugin development
- Governed GitHub CLI shim for agent proxy (CC 2.1.202) - internal enterprise/proxy infrastructure
- Re-invoking loaded skills fix (CC 2.1.202) - already documented in skill-development/overview.md line 46
- Loop re-arming behavior change (CC 2.1.202) - built-in loop/wakeup system prompt behavior, not plugin APIs
- PR explainer skill enhancement (CC 2.1.202) - built-in CC skill behavior

**Original No Action items:**
- Dynamic workflow size setting added (CC 2.1.202) - internal setting, not plugin-related
- `workflow.run_id` and `workflow.name` OpenTelemetry attributes (CC 2.1.202) - telemetry internals
- Fixed inline Ctrl+R history search crashes (CC 2.1.202) - UI bug fix
- Fixed `/rename` on background sessions being reverted during job restarts (CC 2.1.202) - bug fix
- Fixed transient mTLS handshake failures during certificate rotation (CC 2.1.202) - infrastructure
- Fixed Remote Control commands failing in interactive sessions (CC 2.1.202) - bug fix
- Fixed images/files from Remote Control being silently dropped without captions (CC 2.1.202) - bug fix
- Fixed sign-in URLs not displaying reliably when wrapping over SSH (CC 2.1.202) - UI fix
- Fixed chat opening from `claude agents` causing errors (CC 2.1.202) - bug fix
- Fixed workflow scripts with unicode quote escapes being corrupted (CC 2.1.202) - bug fix
- Fixed voice dictation retrying unboundedly on microphone failures (CC 2.1.202) - bug fix
- Fixed `/remote-control` sessions showing incorrect permission modes (CC 2.1.202) - bug fix
- Fixed session resumption taking minutes with many git worktrees (CC 2.1.202) - performance fix
- Fixed installer/updater downloads failing on mid-connection drops (CC 2.1.202) - installer fix
- Improved `/workflows` agent list layout (CC 2.1.202) - UI improvement
- Improved MCP error messages for misconfigured servers (CC 2.1.202) - error messaging
- Clarification that `.md` Claude docs URLs are for fetching only (CC 2.1.202) - doc URL handling
- Security monitor clarifications for unknown repository visibility (CC 2.1.202) - internal security
- Agent Prompt: /review slash command rework (CC 2.1.202) - built-in CC command, not plugin development

---

## Raw Changelog Data

### CC 2.1.202 (from upstream changelog)
```
- Added "Dynamic workflow size" setting for controlling Claude workflow scale
- Added `workflow.run_id` and `workflow.name` OpenTelemetry attributes
- Fixed inline Ctrl+R history search crashes
- Fixed `/rename` on background sessions being reverted during job restarts
- Fixed transient mTLS handshake failures during certificate rotation
- Fixed Remote Control commands failing in interactive sessions
- Fixed images/files from Remote Control being silently dropped without captions
- Fixed sign-in URLs not displaying reliably when wrapping over SSH
- Fixed chat opening from `claude agents` causing "currently running as background agent" errors
- Fixed workflow scripts with unicode quote escapes being corrupted
- Fixed voice dictation retrying unboundedly on microphone failures
- Fixed `/remote-control` sessions showing incorrect permission modes
- Fixed session resumption taking minutes with many git worktrees
- Fixed installer/updater downloads failing on mid-connection drops
- Fixed re-invoking loaded skills appending duplicate instructions
- Improved `/workflows` agent list layout
- Improved MCP error messages for misconfigured servers
- Changed `/review` back to single-pass; use `/code-review` for multi-agent reviews
```

### System-prompts 2.1.202 (key items, +3,217 tokens)
```
- **NEW:** Agent Prompt: /code-review part 2 low effort minimum findings mode -- Adds a low-effort `/code-review` mode that reads the diff once, skips test and fixture hunks, avoids subagents and full-file reads, and targets hunk-visible runtime-correctness findings with one extra pass before returning `(none)`.
- **NEW:** Data: Governed GitHub CLI shim header and routing -- Adds the per-session governed `gh` shim text that routes github.com requests without customer credentials through the agent proxy while letting customer-token and GitHub Enterprise invocations use the real `gh`, including host/repo/origin detection, proxy/CA setup, and proxy-injected tokens.
- Agent Prompt: /review slash command -- Replaces the medium-effort JSON-findings review flow with a concise, sectioned PR review covering overview, code quality/style, improvement suggestions, risks, correctness, project conventions, performance, tests, and security.
- Agent Prompt: Security monitor for autonomous agent actions (second part) -- Clarifies that unknown repository visibility is not itself a blocking reason for data exfiltration or out-of-place publication checks, while keeping content sensitivity and same-session remote repoints as separate risk signals.
- Data: Claude Code live documentation sources; Data: Claude Tag (Claude in Slack) reference; and Skill: Claude Code configuration guide -- Clarify that `.md` Claude docs URLs are for fetching only and user-facing links should drop the trailing `.md` so they open the rendered docs page.
- Skill: Dynamic pacing loop execution; Skill: /loop self-pacing mode; System Prompt: Monitor fallback heartbeat guidance; and Tool Description: Snooze (delay and reason guidance) -- Make loop re-arming an explicit per-turn decision, handle task notifications before deciding whether to continue, and end loops by calling the wakeup tool with `stop: true` instead of omitting the wakeup call.
- Skill: PR explainer -- Requires PR walkthrough artifacts to answer what problem the PR solves, why it matters, how the PR solves it, what alternatives were considered, and why the chosen approach is better, or state plainly when the PR materials do not provide that evidence.
```

---

## Notes

1. **Version 2.1.201** had no system prompt changes per system-prompts CHANGELOG.

2. **Triangulation**: The `/code-review` vs `/review` change is confirmed across both sources. The skill-reinvocation fix appears only in CC changelog but is a bug fix rather than a feature change.

3. **No breaking changes**: All changes in 2.1.202 are additive or bug fixes. No plugin manifest fields, hook events, or skill format changes were identified.

4. **Agent cross-reference skipped**: The claude-code-guide agent was not dispatched because the changes found do not significantly affect plugin-dev documentation (no new tools, hooks, or manifest fields). The changes are primarily command variants and bug fixes.

---

## Previous Audit Reference

The prior manifest (2.1.198-2.1.201) has been archived. Key items from that audit that were marked "Must Update" have been addressed in plugin-dev v0.27.0.

---

## Stage 2: Verification Results
### Verified: 2026-07-07

#### Must Update Verification
- (none) — Stage 1 correctly identified no mandatory updates

#### May Update Resolution
- (downward arrow) `/code-review` command — demoted to No Action: This documents built-in CC commands, not plugin development. The plugin-dev docs teach how to create plugin commands, not document CC's built-in slash commands. Plugin developers don't need to know `/review` vs `/code-review` distinction.
- (downward arrow) Governed GitHub CLI shim — demoted to No Action: Internal enterprise/proxy infrastructure. Not relevant to plugin development or any plugin-dev reference topic.
- (downward arrow) Re-invoking loaded skills fix — demoted to No Action: Already documented at `references/skill-development/overview.md` line 46: "No re-invocation of loaded skills - The tool does not re-invoke a skill already loaded in the current turn." The bug fix confirms expected behavior that is already documented.
- (downward arrow) Loop re-arming behavior change — demoted to No Action: This is about CC's built-in loop/wakeup system prompt behavior. Plugin-dev does not document loop execution internals or the wakeup tool.
- (downward arrow) PR explainer skill enhancement — demoted to No Action: Built-in CC skill behavior, not plugin development guidance.

#### Missed Items (promoted from No Action)
- (none) — No missed plugin-relevant changes found

#### Summary
- Must Update: 0 items (correct)
- May Update: 0 items remaining (5 demoted to No Action)
- Confidence: High — All 2.1.202 changes are either bug fixes, internal improvements, or built-in CC feature changes that don't affect plugin development guidance.

#### Verification Notes
1. **Sources independently fetched**: CC changelog via WebFetch, system-prompts CHANGELOG.md read directly
2. **Version range confirmed**: 2.1.201 had no system prompt changes, 2.1.202 is current
3. **Topic mapping checked**: Read `references/skill-development/overview.md` and `references/command-development/overview.md` to verify existing documentation
4. **Keyword scan performed**: Searched for hook, plugin, agent, skill, command, MCP, tool, permission patterns - no additional items found
