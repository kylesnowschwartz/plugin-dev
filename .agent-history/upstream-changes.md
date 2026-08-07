# Upstream Change Manifest
## CC Version Range: 2.1.222 - 2.1.224
## Generated: 2026-08-07
## Sources: changelog [x], system-prompts [x], claude-code-guide [skipped - timeout]

---

### Must Update

- [ ] **PreToolUse hooks can no longer bypass tool restrictions** (CC 2.1.222)
  - Source: changelog (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: hook-development skill (PreToolUse documentation)
  - Details: PreToolUse auto-allow hooks no longer bypass tool restrictions in background agent tasks. This is a security/behavioral change affecting how plugins document hook capabilities and limitations.
  - Raw changelog: "PreToolUse auto-allow hooks no longer bypass tool restrictions in background agent tasks"
  - Gap location: hook-development/overview.md does not document this limitation

- [ ] **Removes the 200-subagent spawn cap** (CC 2.1.224)
  - Source: changelog (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: agent-development skill (resource limits documentation)
  - Details: The previous 200-subagent spawn limit per session has been removed. Concurrency and depth limits remain.
  - Raw changelog: "Maximum subagent-per-session spawn cap removed (concurrency/depth limits remain)"
  - Gap location: `references/agent-development/references/advanced-agent-fields.md` line 435 states "Subagent spawns | 200 per session"

- [ ] **Archive plugin sources from HTTPS** (CC 2.1.224)
  - Source: changelog (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: plugin-structure skill (installation sources, advanced-topics)
  - Details: Plugins can now be installed from HTTPS-hosted zip archives without requiring git or npm, with optional SHA-256 pinning for integrity verification. This is distinct from the existing `--plugin-url` runtime loading.
  - Raw changelog: "Archive plugin source support for installing plugins from HTTPS-hosted zips without git/npm, with optional SHA-256 pinning"
  - Gap location: `references/plugin-structure/references/advanced-topics.md` covers `--plugin-url` but not archive installation sources

- [ ] **Owner wildcard entries for marketplace management** (CC 2.1.223)
  - Source: changelog (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: marketplace-structure skill (enterprise features section)
  - Details: New owner wildcard syntax (`"owner/*"`) for `strictKnownMarketplaces` and `blockedMarketplaces` managed settings enables blocking or allowing all plugins from a specific owner.
  - Raw changelog: "Owner wildcard entries (`\"owner/*\"`) for `strictKnownMarketplaces` and `blockedMarketplaces` managed settings"
  - Gap location: marketplace-structure/overview.md references these settings but lacks wildcard syntax documentation

- [ ] **Worktree isolation prevents destructive git commands against main checkouts** (CC 2.1.222)
  - Source: changelog (verified)
  - Confidence: high (Stage 2 verified)
  - Affects: agent-development skill (worktree/fork documentation)
  - Details: Worktree-isolated sessions and subagents can no longer run destructive git commands against the main checkout. Extends the CC 2.1.221 worktree isolation feature.
  - Raw changelog: "Worktree-isolated sessions and subagents no longer run destructive git commands against main checkout"
  - Gap location: `references/agent-development/references/advanced-agent-fields.md` lines 408-416 document worktree isolation but not this git command restriction

- [ ] **Cross-session messaging capabilities** (CC 2.1.224)
  - Source: changelog (verified, promoted from May Update)
  - Confidence: high (Stage 2 verified)
  - Affects: agent-development skill (orchestration-and-tools, advanced-agent-fields)
  - Details: `SendMessage` and `ListAgents` now support cross-machine communication. New settings `crossSessionInbound` and `dialogExpiry` control approval workflows for inter-session communication.
  - Raw changelog: "Cross-session messaging: `SendMessage` and `ListAgents` allow Claude Code sessions to communicate across machines"
  - Gap location: `references/orchestration-and-tools.md` and `references/advanced-agent-fields.md` cover these tools but not cross-machine capability

---

### May Update

- [ ] **Self-hosted environments via `claude self-hosted-runner`** (CC 2.1.224)
  - Source: changelog (verified, demoted from Must Update)
  - Confidence: medium
  - Affects: deployment documentation (if covering enterprise features)
  - Details: New self-hosted runner capability for Team/Enterprise users. Primarily an enterprise deployment feature, not core plugin-dev scope. Hook-development docs already mention self-hosted runners for PostSession cleanup.
  - Raw changelog: "Self-hosted environments: `claude self-hosted-runner` enables Team/Enterprise users to run Claude Code sessions on their own machines"

- [ ] **Sandbox filesystem deny entry bypasses fix** (CC 2.1.224)
  - Source: changelog (verified, demoted from Must Update)
  - Confidence: medium
  - Affects: sandbox documentation (if covering security fixes)
  - Details: Security fix for sandbox filesystem deny entries with trailing slashes being bypassable. Plugin developers don't configure sandbox deny entries; this is user/admin configuration.
  - Raw changelog: "Sandbox filesystem deny entries with trailing slashes are no longer bypassable on Linux/macOS"

- [ ] **Warnings for restricted subagent models** (CC 2.1.223)
  - Source: changelog (verified)
  - Confidence: medium
  - Affects: agent-development (model selection guidance)
  - Details: New warnings when workflow agents, forked skills, or resumed background agents use restricted models. Informational, not a configuration change.
  - Raw changelog: "Warning when workflow agents, forked skills, or resumed background agents' requested subagent model is restricted"

- [ ] **`/teleport` hints for local continuation** (CC 2.1.223)
  - Source: changelog (verified)
  - Confidence: medium
  - Affects: command documentation (if covering cloud features)
  - Details: Cloud sessions now show hints about continuing locally via `/teleport`. Not a plugin system change.
  - Raw changelog: "`/teleport` hint in cloud sessions showing how to continue locally"

- [ ] **Security fix for Bash permission bypasses** (CC 2.1.223)
  - Source: changelog (verified)
  - Confidence: medium
  - Affects: security documentation (if tracking resolved issues)
  - Details: Fix for Bash permission bypass where crafted commands hid parts from permission checks. Permission prompts no longer allow tab/Unicode padding to hide command portions.
  - Raw changelog: "Bash permission bypass where crafted commands hid parts from permission checks"

- [ ] **Security fix for workflow sandbox escapes** (CC 2.1.223)
  - Source: changelog (verified)
  - Confidence: medium
  - Affects: security documentation (if tracking resolved issues)
  - Details: Workflow scripts no longer use dynamic `import()` to run code outside sandbox.
  - Raw changelog: "Workflow scripts no longer use dynamic `import()` to run code outside sandbox"

---

### System Prompts Changes (for reference)

**From system-prompts CHANGELOG for 2.1.222 (-341 tokens):**
- **NEW:** Artifact comment list framing - injection-safe handling for comments
- Artifact comment thread framing updates

**From system-prompts CHANGELOG for 2.1.223 (+3,316 tokens):**
- **NEW:** Data: SDK query result `modelUsage` field - cumulative token/cost estimates
- **NEW:** Artifact comment decision reformat retry
- **NEW:** Artifact comment reply activation failure reminder
- **NEW:** Tool Description: `memory_list` prompt
- **REMOVED:** Agent Prompt: `/review` slash command
- **REMOVED:** Clarifying question research first
- **REMOVED:** Executing actions with care (fragment)
- Various skill and tool description updates (PR review, prototype, whiteboard)

**Note:** 2.1.224 not yet in system-prompts repo (may be too new).

---

### No Action

**Bug fixes and internal changes (original):**
- `/usage-credits` blocking repeat requests fix (CC 2.1.222) - User-facing bug fix
- Startup connectivity checks behind HTTPS proxies (CC 2.1.222) - Infrastructure fix
- Streaming issues fix (CC 2.1.222) - Internal fix
- MCP server request attribution fix (CC 2.1.222) - Internal fix
- UI/UX problems in fullscreen and Remote Control modes (CC 2.1.222) - IDE-specific
- Model discovery fix (CC 2.1.223) - Internal fix
- Sandboxed command failures fix (CC 2.1.223) - Internal fix
- Forked background agent resumption fix (CC 2.1.223) - Internal fix
- Long project paths resolving incorrectly fix (CC 2.1.224) - Internal fix
- SendMessage delivery failures fix (CC 2.1.224) - Internal fix
- Remote Control connection failure indicators (CC 2.1.224) - IDE-specific
- Compaction progress visibility (CC 2.1.224) - UI enhancement
- Artifact comment handling changes (CC 2.1.222-2.1.223) - Artifact feature, not plugin-dev
- SDK query result modelUsage field (CC 2.1.223) - SDK feature, not plugin-dev
- Clarifying question research first removal (CC 2.1.223) - Internal prompt change
- Executing actions with care fragment removal (CC 2.1.223) - Internal prompt change
- PR review skill updates (CC 2.1.223) - Artifact workflow, not plugin-dev
- Prototype skill updates (CC 2.1.223) - Artifact workflow, not plugin-dev

**Demoted from May Update (Stage 2):**
- Sandbox credential-masking options (CC 2.1.224) - User/admin config, not plugin-dev scope
- MCP tool visibility fixes (CC 2.1.224) - Bug fix, not feature change
- `modelOverrides` keys fix (CC 2.1.223) - Confirms existing documented behavior
- Managed settings merging fix (CC 2.1.223) - Bug fix in settings delivery
- `/review` slash command removal (CC 2.1.223) - Internal CC command, now aliases `/code-review`
- `memory_list` tool added (CC 2.1.223) - Built-in tool, not plugin-specific

---

## Summary

**Critical plugin-dev impact (Must Update):** 6 items (Stage 2 verified)
1. **PreToolUse hook restriction bypass fix** (CC 2.1.222) - Security/behavioral change for hooks
2. **200-subagent spawn cap removed** (CC 2.1.224) - Resource limit change (reverses 2.1.213 limit)
3. **HTTPS archive plugin sources** (CC 2.1.224) - New plugin installation mechanism with SHA-256 pinning
4. **Marketplace owner wildcards** (CC 2.1.223) - Managed settings wildcard syntax
5. **Worktree isolation git command restriction** (CC 2.1.222) - Security enhancement for forks
6. **Cross-session messaging capabilities** (CC 2.1.224) - SendMessage/ListAgents cross-machine support (promoted)

**Moderate impact (May Update):** 6 items (Stage 2 adjusted)
- Self-hosted runner command (demoted from Must Update - enterprise feature)
- Sandbox filesystem deny bypass fix (demoted from Must Update - security fix)
- Restricted subagent model warnings
- /teleport hints
- Bash permission bypass fix
- Workflow sandbox escape fix

**No action needed:** 24 items
- Bug fixes, performance improvements, internal refactors
- IDE-specific features
- Internal prompt changes
- Artifact features (not plugin-dev)
- Demoted from May Update: credential-masking, MCP visibility, modelOverrides, settings merging, /review alias, memory_list tool

---

## Token Deltas from System-Prompts

- 2.1.224: Not yet available in system-prompts repo
- 2.1.223: +3,316 tokens
- 2.1.222: -341 tokens

**Total delta since 2.1.221:** +2,975 tokens (modest release window)

---

## Notes

1. **Single-source confidence**: Most changes in 2.1.222-2.1.224 appear only in the upstream changelog. The system-prompts CHANGELOG for 2.1.222-2.1.223 focuses heavily on Artifact-related features rather than plugin system changes.

2. **Key plugin-relevant changes**:
   - PreToolUse hook restriction bypass fix (security - behavioral change)
   - 200-subagent spawn cap removal (resource limits - reversal)
   - HTTPS archive plugin sources (distribution expansion)
   - Marketplace owner wildcards (manifest change)
   - Self-hosted runner (deployment capability)

3. **claude-code-guide verification**: Skipped due to timeout. Recommend manual verification of high-impact changes before applying updates.

4. **Version 2.1.224 not in system-prompts**: The system-prompts repo has not yet extracted 2.1.224 prompts, limiting cross-reference capability for the newest version. All 2.1.224 changes have single-source confidence.

5. **Compatibility with previous audit**: Previous audit covered 2.1.212-2.1.221. This audit continues from 2.1.222, ensuring no version gap.

6. **Resource limit reversal**: The 200-subagent spawn cap added in 2.1.213 has been removed in 2.1.224. Documentation that mentions this limit should be updated to reflect its removal.

---

## Stage 2: Verification Results
### Verified: 2026-08-07

#### Must Update Verification

- ✓ **PreToolUse hooks can no longer bypass tool restrictions** (CC 2.1.222) — confirmed in CC changelog ("PreToolUse auto-allow hooks no longer bypass tool restrictions in background agent tasks"). Gap exists in hook-development skill. The hook-development/overview.md does not document this security limitation for PreToolUse auto-allow hooks in background contexts.

- ✓ **Removes the 200-subagent spawn cap** (CC 2.1.224) — confirmed in CC changelog ("Maximum subagent-per-session spawn cap removed (concurrency/depth limits remain)"). Gap exists at `references/agent-development/references/advanced-agent-fields.md` line 435 which states "Subagent spawns | 200 per session". This needs updating to reflect the cap removal.

- ✓ **Archive plugin sources from HTTPS** (CC 2.1.224) — confirmed in CC changelog ("Archive plugin source support for installing plugins from HTTPS-hosted zips without git/npm, with optional SHA-256 pinning"). The existing `--plugin-url` documentation at `references/plugin-structure/references/advanced-topics.md` lines 477-485 covers runtime loading but not the new archive installation source with SHA-256 pinning. This is a distinct feature for permanent installation.
  - Affects: plugin-structure skill (installation sources, manifest-reference)

- ✓ **Self-hosted environments via `claude self-hosted-runner`** (CC 2.1.224) — confirmed in CC changelog ("Self-hosted environments: `claude self-hosted-runner` enables Team/Enterprise users to run Claude Code sessions on their own machines"). This is a new deployment capability.
  - Reclassify: Demote to "May Update" — This is primarily an enterprise deployment feature. Plugin-dev documentation does not typically cover enterprise deployment commands. Only relevant if plugins need self-hosted-specific behavior. The hook-development docs mention self-hosted runners for PostSession cleanup (line 174, 193) but do not need extensive new coverage.

- ✓ **Owner wildcard entries for marketplace management** (CC 2.1.223) — confirmed in CC changelog ("Owner wildcard entries (`\"owner/*\"`) for `strictKnownMarketplaces` and `blockedMarketplaces` managed settings"). Gap exists in marketplace-structure docs which reference these settings but do not document the new wildcard syntax.
  - Affects: marketplace-structure skill (enterprise features section)

- ✓ **Sandbox filesystem deny entry bypasses fix** (CC 2.1.224) — confirmed in CC changelog ("Sandbox filesystem deny entries with trailing slashes are no longer bypassable on Linux/macOS"). The sandbox filesystem documentation at `references/plugin-structure/references/advanced-topics.md` lines 560-585 does not cover deny entries. However, this is primarily a security fix rather than a new feature.
  - Reclassify: Demote to "May Update" — This is a security bug fix, not a feature change. Plugin developers do not configure sandbox deny entries (that's a user/admin setting). Only note if documenting sandbox behavior comprehensively.

- ✓ **Worktree isolation prevents destructive git commands against main checkouts** (CC 2.1.222) — confirmed in CC changelog ("Worktree-isolated sessions and subagents no longer run destructive git commands against main checkout"). Gap exists at `references/agent-development/references/advanced-agent-fields.md` lines 408-416 which document worktree isolation but not this additional git command restriction.
  - Affects: agent-development skill (worktree isolation section)

#### Missed Items (promoted from No Action)

None identified. The Stage 1 manifest correctly classified all plugin-relevant changes.

#### May Update Resolution

- = **Warnings for restricted subagent models** (CC 2.1.223) — kept as May Update: This affects agent behavior but is informational (warnings shown to users), not a configuration change plugin developers need to document.

- = **`/teleport` hints for local continuation** (CC 2.1.223) — kept as May Update: This is a cloud-session feature hint, not a plugin system change. No action needed unless documenting cloud-to-local workflows.

- ↑ **Cross-session messaging capabilities** (CC 2.1.224) — **promoted to Must Update**: The changelog shows new `SendMessage` and `ListAgents` capabilities for cross-machine communication, plus new settings `crossSessionInbound` and `dialogExpiry`. The agent-development docs already cover `SendMessageTool` at `references/orchestration-and-tools.md` line 65 and `ListAgents` at `references/advanced-agent-fields.md` line 628. These need updating for cross-session/cross-machine capability.
  - Affects: agent-development skill (orchestration-and-tools, advanced-agent-fields)

- ↓ **Sandbox credential-masking options** (CC 2.1.224) — demoted to No Action: This is a sandbox configuration feature (`decode: "jwt"`, AWS SigV4). Plugin developers don't configure sandbox credential masking; this is user/admin configuration.

- = **Security fix for Bash permission bypasses** (CC 2.1.223) — kept as May Update: The changelog says "Bash permission bypass where crafted commands hid parts from permission checks" and "Permission prompts no longer allow tab/Unicode padding to hide command portions". This is a security fix but has no direct documentation impact unless noting it as a resolved security issue.

- = **Security fix for workflow sandbox escapes** (CC 2.1.223) — kept as May Update: The changelog says "Workflow scripts no longer use dynamic `import()` to run code outside sandbox". This is a security fix with no documentation impact for plugin developers.

- ↓ **MCP tool visibility fixes** (CC 2.1.224) — demoted to No Action: The changelog says "MCP tools connecting mid-turn are no longer deferred without announcement". This is a bug fix, not a feature change.

- ↓ **`modelOverrides` keys fix** (CC 2.1.223) — demoted to No Action: The changelog says "`modelOverrides` keys that aren't Anthropic model IDs now ignored as documented". This confirms existing documented behavior.

- ↓ **Managed settings merging fix** (CC 2.1.223) — demoted to No Action: The changelog says "Managed settings: server-delivered settings no longer disable machine-local env block". This is a bug fix in settings delivery, not a documentation change.

- ↓ **`/review` slash command removed** (CC 2.1.223) — demoted to No Action: The system-prompts changelog shows `/review` now aliases `/code-review`. This is an internal Claude Code command, not a plugin system change. Plugin-dev docs mention `/review` only as an example command name, not as a built-in.

- ↓ **`memory_list` tool added** (CC 2.1.223) — demoted to No Action: This is a new built-in tool for Claude Code's memory feature. Plugin developers don't need to document built-in tools unless they interact with plugin functionality. The tool is not plugin-specific.

#### Summary

- **Must Update: 6 items** (5 confirmed from original 7, 1 promoted from May Update, 2 demoted to May Update)
  1. PreToolUse hooks bypass restriction (CC 2.1.222) — hook-development
  2. 200-subagent spawn cap removed (CC 2.1.224) — agent-development
  3. HTTPS archive plugin sources with SHA-256 (CC 2.1.224) — plugin-structure
  4. Owner wildcard entries for marketplace (CC 2.1.223) — marketplace-structure
  5. Worktree isolation git command restriction (CC 2.1.222) — agent-development
  6. Cross-session messaging capabilities (CC 2.1.224) — agent-development (promoted)

- **May Update: 4 items** (down from 11)
  1. Warnings for restricted subagent models (CC 2.1.223)
  2. `/teleport` hints (CC 2.1.223)
  3. Bash permission bypass fix (CC 2.1.223)
  4. Workflow sandbox escape fix (CC 2.1.223)

- **Demoted to No Action: 7 items**
  - Self-hosted runner (enterprise deployment, not plugin-dev scope)
  - Sandbox deny entry bypass fix (security fix, not config change)
  - Sandbox credential-masking (user config, not plugin-dev)
  - MCP tool visibility fix (bug fix)
  - modelOverrides keys fix (confirms existing docs)
  - Managed settings merging fix (bug fix)
  - /review command removal (internal CC command)
  - memory_list tool (built-in tool, not plugin-specific)

- **Confidence: HIGH** — All Must Update items verified against upstream changelog. Topic mappings validated against reference docs. No missed items found. Changes are well-scoped for plugin-dev documentation.
