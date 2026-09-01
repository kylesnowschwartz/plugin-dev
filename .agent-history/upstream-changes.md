# Upstream Change Manifest
## CC Version Range: 2.1.252
## Generated: 2026-09-01
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped]

**Note:** The claude-code-guide agent was not dispatched as the changes in this version range are exclusively bug fixes with no plugin-system-relevant changes. Cross-referencing with official documentation is not required for this audit.

---

### Must Update

_No must-update changes in this version range._

---

### May Update

_No may-update changes in this version range._

---

### No Action

- **Bash commands failing on macOS** (CC 2.1.252)
  - Source: CC changelog
  - Type: Bug fix
  - Details: Fix for Bash commands that were failing on macOS. Internal bug fix with no plugin system impact.

- **"Always allow" not saving in projects** (CC 2.1.252)
  - Source: CC changelog
  - Type: Bug fix
  - Details: Fix for permission "always allow" settings not persisting in project settings. Internal bug fix with no plugin system impact.

- **Remote Control stalling issues** (CC 2.1.252)
  - Source: CC changelog
  - Type: Bug fix
  - Details: Fix for Remote Control clients experiencing stalling. Internal bug fix with no plugin system impact.

- **Background task notifications with large output exceeding API limits** (CC 2.1.252)
  - Source: CC changelog
  - Type: Bug fix
  - Details: Fix for background task notifications failing when output was too large for API limits. Internal bug fix with no plugin system impact.

- **System Reminder: Session context refresh reason formatting** (CC 2.1.252)
  - Source: system-prompts changelog (+100 tokens)
  - Type: Minor prompt refinement
  - Details: Identifies when session context was re-read and includes the formatted refresh reason, while continuing to mark refreshed values as replacements for earlier ones. This is an internal prompt refinement that does not affect plugin authoring guidance.

---

## Summary

**Version range**: 2.1.252 (single version since last audit on 2026-08-31)

**Token delta** (from system-prompts):
- 2.1.252: +100 tokens (minor refinement only)

**Key findings**:
- Version 2.1.252 contains **only bug fixes** and one minor internal prompt refinement
- No changes to plugin manifest schema (plugin.json)
- No new or modified hook events
- No changes to agent features (model, tools, permissions, teams)
- No changes to skill format (frontmatter fields, loading behavior)
- No command changes
- No MCP or LSP integration changes
- No built-in tool behavior changes

**Triangulation status**:
- CC changelog: Confirms 4 bug fixes
- system-prompts CHANGELOG: Confirms +100 tokens for session context refinement
- claude-code-guide: Skipped (no plugin-relevant changes to verify)

**Recommendation**: No updates required for plugin-dev documentation. Update `docs/claude-code-compatibility.md` to reflect 2.1.252 as the last audited version with a note that this version contains bug fixes only.

---

## Raw Changelog Data

### CC Changelog (v2.1.252)
```
Key fixes include Bash commands failing on macOS, "always allow" not saving in
projects, Remote Control stalling issues, and background task notifications with
large output exceeding API limits.
```

### System Prompts CHANGELOG (v2.1.252)
```
# [2.1.252](https://github.com/Piebald-AI/claude-code-system-prompts/commit/2a3cec9)

_+100 tokens_

- System Reminder: Session context - Identifies when session context was re-read
  and includes the formatted refresh reason, while continuing to mark refreshed
  values as replacements for earlier ones.
```

---

## Total changes requiring action

- **Must Update**: 0 items
- **May Update**: 0 items
- **No Action**: 5 items (all bug fixes or internal refinements)

---

## Stage 2: Verification Results
### Verified: 2026-09-01

#### Must Update Verification

_No Must Update items to verify (correct - Stage 1 found none)._

#### No Action Verification

- **Bash commands failing on macOS** (CC 2.1.252)
  - VERIFIED: Confirmed in CC changelog. Fix for "task output swap refused" message on certain Mac systems. Internal bug fix with no plugin system impact.

- **"Always allow" not saving in projects** (CC 2.1.252)
  - VERIFIED: Confirmed in CC changelog. Fix for permission persistence in projects lacking `.claude/settings.local.json`. Internal bug fix with no plugin system impact.

- **Remote Control stalling issues** (CC 2.1.252)
  - VERIFIED: Confirmed in CC changelog. Fix for stalling after tool completion with degraded claude.ai connection. Internal bug fix with no plugin system impact.

- **Background task notifications with large output exceeding API limits** (CC 2.1.252)
  - VERIFIED: Confirmed in CC changelog. Fix for extremely large failure output (e.g., git errors on full disk). Internal bug fix with no plugin system impact.

- **System Reminder: Session context refresh reason formatting** (CC 2.1.252)
  - VERIFIED: Confirmed in system-prompts CHANGELOG (+100 tokens). Internal prompt refinement for session context re-read formatting. Does not affect plugin authoring guidance.

#### Missed Items (promoted from No Action)

_None found._

Scanned changelog entries for plugin-relevant keywords:
- `hook`, `plugin`, `agent`, `skill`, `command` - No new matches in 2.1.252
- `MCP`, `LSP`, `mcp`, `lsp` - No new matches in 2.1.252
- `tool`, `permission`, `subagent` - Bug fixes only (already classified)
- `frontmatter`, `manifest`, `plugin.json` - No matches in 2.1.252
- `PreToolUse`, `PostToolUse`, `SessionStart`, `Stop` - No new features in 2.1.252

Note: Initial WebFetch output appeared to combine 2.1.251 and 2.1.252 entries (showing PreModelSwitch/PostModelSwitch, symlink fixes, etc. under both versions). Cross-referencing with:
1. System-prompts CHANGELOG (shows only +100 tokens for 2.1.252)
2. Compatibility doc (shows these features were audited in v0.40.0 for 2.1.251)
3. Hook development overview (already documents 31 hook events including PreModelSwitch/PostModelSwitch)

Confirms Stage 1 correctly identified that 2.1.252 contains only bug fixes and internal refinements.

#### May Update Resolution

_No May Update items to resolve (correct - Stage 1 found none)._

#### Summary
- Must Update: 0 items (0 confirmed, 0 rejected, 0 added)
- May Update: 0 items remaining
- No Action: 5 items (all 5 verified as correctly classified)
- Confidence: HIGH

Stage 1 correctly identified that Claude Code 2.1.252 contains only bug fixes and one minor internal prompt refinement. No plugin-dev documentation updates are required for this version. The manifest is accurate and ready for Stage 3 processing.
