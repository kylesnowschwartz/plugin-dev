# Upstream Change Manifest
## CC Version Range: 2.1.122 - 2.1.126
## Generated: 2026-05-01
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - empty output]

---

### Must Update

- [ ] **New `claude project purge [path]` command** (CC 2.1.126)
  - Source: changelog
  - Confidence: HIGH (verified Stage 2)
  - Affects: command-development (command reference)
  - Details: Deletes all Claude Code state for a project. Supports `--dry-run`, `-y/--yes`, `-i/--interactive`, and `--all` flags. Different from `claude plugin prune` (which removes orphaned plugin dependencies) - this removes ALL project state.
  - Raw: "Added `claude project purge [path]` to delete all Claude Code state for a project"

- [ ] **New file modification budget-exceeded reminder** (CC 2.1.124)
  - Source: system-prompts
  - Confidence: HIGH (verified Stage 2)
  - Affects: hook-development (FileChanged event context)
  - Details: New system reminder tells the agent when a user or linter changed a file but the diff was omitted because other modified files exceeded the snippet budget. Directs agent to read the file if current content is needed. Relevant for PostToolUse/FileChanged hook documentation.
  - Raw: "NEW: System Reminder: File modification detected (budget exceeded)"

- [ ] **Deferred tools fix for context:fork subagents** (CC 2.1.126)
  - Source: changelog
  - Confidence: HIGH (verified Stage 2 - promoted from No Action)
  - Affects: skill-development (context:fork documentation)
  - Details: Fixed deferred tools (WebSearch, WebFetch, etc.) not being available to skills with `context: fork` and other subagents on their first turn. This was a bug affecting documented plugin-dev functionality.
  - Raw: "Fixed deferred tools (WebSearch, WebFetch, etc.) not being available to skills with `context: fork` and other subagents on their first turn"

- [ ] **PowerShell as primary shell on Windows** (CC 2.1.126)
  - Source: changelog
  - Confidence: HIGH (verified Stage 2 - promoted from No Action)
  - Affects: hook-development, command-development (Windows considerations)
  - Details: When PowerShell tool is enabled on Windows, Claude now treats PowerShell as the primary shell instead of defaulting to Bash. Plugin developers writing hooks/commands should consider cross-platform compatibility.
  - Raw: "Windows: when the PowerShell tool is enabled, Claude now treats PowerShell as the primary shell instead of defaulting to Bash"

---

### May Update

*All items demoted to No Action during Stage 2 verification. See No Action section for details.*

---

### No Action

**Demoted from Must Update (Stage 2 verification):**
- Malware analysis reminder removed (CC 2.1.126) - No gap exists in plugin-dev docs (only sample script name found)
- REPL await clarification (CC 2.1.124) - Not documented in plugin-dev, internal Claude behavior
- Plan mode phase-four restructuring (CC 2.1.122) - Not documented in plugin-dev, internal prompt restructuring
- /schedule confidence threshold (CC 2.1.122) - Not documented in plugin-dev, Claude feature

**Demoted from May Update (Stage 2 verification):**
- Model picker uses gateway /v1/models (CC 2.1.126) - User/deployment config, not plugin API
- --dangerously-skip-permissions bypasses protected directories (CC 2.1.126) - Deployment concern
- OAuth code paste support (CC 2.1.126) - Authentication UX
- Red spinner for permission stalls (CC 2.1.126) - UI change
- OpenTelemetry invocation_trigger (CC 2.1.126) - Observability, not plugin API
- ANTHROPIC_BEDROCK_SERVICE_TIER (CC 2.1.122) - Deployment configuration
- Diagnostics formatting change (CC 2.1.122) - Internal prompt change
- Debugging skill daemon context (CC 2.1.122) - Internal Claude skill behavior

**Original No Action (confirmed):**
- Image paste auto-downscaling fix (CC 2.1.126) - Bug fix, no plugin impact
- OAuth login fixes for slow/proxied connections (CC 2.1.126) - Bug fix, no plugin impact
- Stream idle timeout errors after Mac sleep (CC 2.1.126) - Bug fix, no plugin impact
- Terminal rendering issues fix including Japanese/Korean text (CC 2.1.126) - Bug fix, no plugin impact
- OAuth authentication loop fix with CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1 (CC 2.1.123) - Bug fix, no plugin impact
- PR URLs in /resume search locate creating sessions (CC 2.1.122) - Feature improvement, no plugin impact
- OpenTelemetry numeric attributes as numbers not strings (CC 2.1.122) - Internal fix, no plugin impact
- /branch fork tool_use validation errors fix (CC 2.1.122) - Bug fix, no plugin impact
- /model not showing Effort for Bedrock inference profiles fix (CC 2.1.122) - Bug fix, no plugin impact
- Vertex AI/Bedrock structured outputs fix (CC 2.1.122) - Bug fix, no plugin impact
- count_tokens endpoint 400 for proxied users fix (CC 2.1.122) - Bug fix, no plugin impact
- Harness instructions restructuring (CC 2.1.124) - Internal prompt organization, no plugin impact
- No system prompt changes in 2.1.123 (CC 2.1.123) - OAuth fix only release

---

## Token Delta Summary (from system-prompts)

| Version | Delta | Key Changes |
|---------|-------|-------------|
| 2.1.126 | -87 | Malware analysis reminder removed |
| 2.1.124 | +166 | File modification budget reminder (NEW), harness restructuring, REPL await clarification |
| 2.1.123 | +0 | No prompt changes |
| 2.1.122 | -122 | Plan mode phase-four removed, schedule confidence raised, diagnostics formatting |

**Net change since 2.1.121**: -43 tokens (slight reduction)

---

## Notes

1. **Two-source triangulation only**: The claude-code-guide agent dispatch returned empty output, so this manifest relies on changelog + system-prompts triangulation only. Changes confirmed by both sources have high confidence; single-source changes have medium confidence.

2. **Version gap**: System-prompts shows 2.1.124 but no 2.1.125 entry. The changelog shows 2.1.126 as the latest. This suggests 2.1.125 may not exist or had no public changes.

3. **No prompt changes in 2.1.123**: System-prompts confirms no changes to prompts in v2.1.123 (OAuth auth loop fix only).

4. **Key patterns observed**:
   - New CLI command: `claude project purge`
   - System prompt removals (malware reminder, plan mode phase-four standalone)
   - Behavior threshold changes (schedule offer confidence 70% -> 85%)
   - REPL tool clarification for await semantics

---

## Summary (Stage 2 corrected)

| Category | Count | Notes |
|----------|-------|-------|
| Must Update | 4 | 2 confirmed, 2 promoted from changelog |
| May Update | 0 | All demoted to No Action |
| No Action | 25 | 4 demoted from Must Update, 8 demoted from May Update, 13 original |

**Version Range**: 2.1.122 - 2.1.126 (5 versions since last audit at 2.1.121)

**High-priority items for plugin-dev** (Stage 2 verified):
1. **`claude project purge [path]`** (CC 2.1.126) - new command for removing all project state
2. **File modification budget-exceeded reminder** (CC 2.1.124) - new system reminder affecting hook context
3. **Deferred tools fix for context:fork subagents** (CC 2.1.126) - affects skill development guidance
4. **PowerShell as primary shell on Windows** (CC 2.1.126) - affects hook/command development

**Documentation targets** (Stage 2 verified):
1. Command reference - add `claude project purge [path]` with flags
2. Hook development - document file modification budget-exceeded reminder context for FileChanged events
3. Skill development - note deferred tools (WebSearch, WebFetch) now available on first turn for context:fork skills
4. Hook/command development - note PowerShell may be primary shell on Windows when enabled

---

## Stage 2: Verification Results
### Verified: 2026-05-01

#### Must Update Verification

- **VERIFIED** `claude project purge [path]` (CC 2.1.126) -- confirmed in CC changelog: "Added `claude project purge [path]` to delete all Claude Code state for a project, supporting `--dry-run`, `-y/--yes`, `-i/--interactive`, and `--all` flags". Gap exists: no command reference documentation in plugin-dev.
  - Affects: command-development (command reference docs)

- **VERIFIED** Malware analysis reminder removed (CC 2.1.126) -- confirmed in system-prompts CHANGELOG line 11: "**REMOVED:** System Reminder: Malware analysis after Read tool call". Gap status: searched plugin-dev for "malware" - only found in `component-patterns.md` as a sample script name (`scan-malware.sh`). No documentation about the malware analysis reminder exists to update.
  - Affects: None (no gap exists) - DEMOTE to No Action

- **VERIFIED** File modification budget-exceeded reminder (CC 2.1.124) -- confirmed in system-prompts CHANGELOG line 17: "**NEW:** System Reminder: File modification detected (budget exceeded)". Gap exists: hook-development does not document this new system reminder. This is relevant for PostToolUse/FileChanged hooks.
  - Affects: hook-development (new system reminder context)

- **REJECTED** REPL await clarification (CC 2.1.124) -- confirmed in system-prompts CHANGELOG line 19. However, plugin-dev does NOT document REPL tool usage (searched for "REPL" - no relevant hits). This is an internal Claude behavior, not a plugin-dev concern.
  - Affects: None - DEMOTE to No Action

- **REJECTED** Plan mode phase-four restructuring (CC 2.1.122) -- confirmed in system-prompts CHANGELOG line 31. However, this is internal Claude prompt restructuring. Plugin-dev only documents plan mode superficially in `advanced-agent-fields.md` (permission modes for teams), not the phase structure. No gap.
  - Affects: None - DEMOTE to No Action

- **REJECTED** /schedule confidence threshold (CC 2.1.122) -- confirmed in system-prompts CHANGELOG line 33. However, plugin-dev does NOT document /schedule behavior (searched - no hits). This is a Claude feature, not a plugin system feature.
  - Affects: None - DEMOTE to No Action

#### Missed Items (promoted from No Action)

- **PROMOTED** Deferred tools fix for context:fork subagents (CC 2.1.126) -- CC changelog states: "Fixed deferred tools (WebSearch, WebFetch, etc.) not being available to skills with `context: fork` and other subagents on their first turn". This directly affects skill development with `context: fork`, which IS documented in plugin-dev.
  - Affects: skill-development
  - Details: Skills using `context: fork` should now correctly have access to deferred tools (WebSearch, WebFetch) on first turn. This was a bug fix but represents behavioral change worth noting.

- **PROMOTED** PowerShell as primary shell (CC 2.1.126) -- CC changelog states: "Windows: when the PowerShell tool is enabled, Claude now treats PowerShell as the primary shell instead of defaulting to Bash". This affects command hooks and scripts in plugin development on Windows.
  - Affects: hook-development, command-development
  - Details: Windows plugin developers should be aware that Claude may now use PowerShell by default. Hook scripts and commands using Bash syntax should account for this.

#### May Update Resolution

- **DEMOTED** Model picker uses gateway /v1/models (CC 2.1.126) -- This is user/deployment configuration, not plugin development. Plugin-dev does not document model picker behavior.
  - Status: No Action

- **DEMOTED** --dangerously-skip-permissions bypasses protected directories (CC 2.1.126) -- Already partially documented in `advanced-agent-fields.md` (mentions the flag). The extension to protected directories is a deployment/testing concern, not core plugin development.
  - Status: No Action

- **DEMOTED** OAuth code paste support (CC 2.1.126) -- Authentication UX, not plugin-related.
  - Status: No Action

- **DEMOTED** Red spinner for permission stalls (CC 2.1.126) -- UI change, not plugin API.
  - Status: No Action

- **DEMOTED** OpenTelemetry invocation_trigger (CC 2.1.126) -- Observability/telemetry, not core plugin system.
  - Status: No Action

- **DEMOTED** ANTHROPIC_BEDROCK_SERVICE_TIER (CC 2.1.122) -- Deployment configuration, not plugin development.
  - Status: No Action

- **DEMOTED** Diagnostics formatting change (CC 2.1.122) -- Internal prompt change, diagnostics handled by LSP integration which IS documented, but this change doesn't affect the plugin API.
  - Status: No Action

- **DEMOTED** Debugging skill daemon context (CC 2.1.122) -- Internal Claude skill behavior, not plugin API.
  - Status: No Action

#### Summary

- **Must Update**: 4 items (2 confirmed from original 6, 2 promoted from changelog)
  - `claude project purge [path]` (confirmed)
  - File modification budget-exceeded reminder (confirmed)
  - Deferred tools fix for context:fork (promoted)
  - PowerShell primary shell on Windows (promoted)
- **Rejected from Must Update**: 4 items demoted to No Action
  - Malware analysis reminder removed (no gap)
  - REPL await clarification (not documented)
  - Plan mode phase-four (not documented)
  - /schedule confidence (not documented)
- **May Update**: 0 items remaining (all demoted)
- **Confidence**: HIGH - dual-source verification (CC changelog + system-prompts) with gap analysis against plugin-dev docs

#### Notes

1. The original manifest included several items that affect Claude's internal behavior but NOT the plugin system. These have been demoted.

2. Two items were missed in Stage 1 that DO affect plugin development:
   - Deferred tools fix (affects `context: fork` skills)
   - PowerShell primary shell (affects Windows hook/command development)

3. The CC changelog contains more detail than the WebFetch summary captured. Direct reading revealed important behavioral changes.

4. Version gap: 2.1.125 confirmed missing from both CC changelog and system-prompts (no such version exists).

---

## Data Quality Notes

- Two-source triangulation (CC changelog + system-prompts changelog) - both sources accessible
- claude-code-guide agent dispatch failed (empty output after multiple retries)
- System-prompts changelog provides structured detail with token counts and NEW/REMOVED markers
- Confidence is HIGH for system-prompts items due to explicit change markers
- Confidence is MEDIUM for changelog-only items due to WebFetch summarization (no raw text)
- This is a relatively small delta covering 5 versions with net -43 tokens

---

## Comparison to Previous Audit

Previous audit (2.1.121) had:
- 4 Must Update items
- 1 May Update item
- -13 tokens net change

This audit (2.1.122-2.1.126) has:
- 6 Must Update items
- 8 May Update items
- -43 tokens net change

The version range is larger (5 versions vs 1) but still represents routine maintenance with some targeted feature additions. The `claude project purge` command and malware reminder removal are the most significant plugin-relevant changes.
