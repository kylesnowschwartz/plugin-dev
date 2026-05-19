# Upstream Change Manifest
## CC Version Range: 2.1.144 - 2.1.144
## Generated: 2026-05-19
## Sources: changelog [OK], system-prompts [PARTIAL - not yet updated to 2.1.144], claude-code-guide [skipped - single version with no plugin-system changes]

---

**Note:** The system-prompts repository has not yet been updated with 2.1.144 extractions. The latest available system-prompts version is 2.1.143, which was already audited in the previous sync (v0.16.0). This manifest is based on the official CC changelog only. Confidence is lower than typical due to single-source triangulation.

---

### Must Update

_None identified._ All changes in 2.1.144 appear to be bug fixes, IDE/terminal improvements, or internal enhancements that do not affect the plugin system, skill format, hooks, or agent features documented in plugin-dev.

---

### May Update

- [ ] `/resume` command support for background sessions (CC 2.1.144)
  - Source: CC changelog only
  - Confidence: low (single source, no system-prompt details available)
  - Affects: Possibly agent-related documentation if `/resume` has implications for background agent workflows
  - Details: New `/resume` command can resume background sessions. May be worth documenting in agent or background-session guidance if system-prompts reveal plugin-relevant details. Currently flagged for follow-up once system-prompts are updated.

- [ ] MCP paginated tools/list fix (CC 2.1.144) [Stage 2 promoted]
  - Source: CC changelog
  - Confidence: medium
  - Affects: mcp-integration
  - Details: "MCP servers with paginated `tools/list` responses now return all pages instead of silently dropping tools". Behavior fix for MCP servers with many tools. Low priority but worth documenting in Tool Search section.

- [ ] MCP images with unsupported MIME types (CC 2.1.144) [Stage 2 promoted]
  - Source: CC changelog
  - Confidence: low
  - Affects: mcp-integration
  - Details: "MCP images with unsupported MIME types (e.g., SVG) are saved to disk and referenced in tool results". Edge case fallback behavior for image handling.

- [ ] Plugin update timestamps in marketplace (CC 2.1.144) [Stage 2 promoted]
  - Source: CC changelog
  - Confidence: medium
  - Affects: marketplace-structure
  - Details: "Plugin marketplace now displays when each plugin was last updated". Informational for plugin authors.

---

### No Action

- `/model` command session-scoped behavior change (CC 2.1.144) - User-facing command, not plugin-related [Stage 2 demoted from May Update]
- Elapsed duration in notifications (CC 2.1.144) - UI/notification improvement
- Startup hang fix when API is unreachable (CC 2.1.144) - Bug fix
- Terminal corruption fixes (CC 2.1.144) - Terminal/display bug fix
- Background session macOS Full Disk Access fix (CC 2.1.144) - Platform-specific bug fix
- File handling for mismatched image extensions (CC 2.1.144) - File handling bug fix
- Tool error reductions during search operations (CC 2.1.144) - Internal error handling improvement

_Note: "Plugin update timestamps" moved to May Update by Stage 2 verification._

---

## Raw Changelog Data

### CC 2.1.144 (from official changelog via WebFetch)

> Key improvements include `/resume` support for background sessions, elapsed duration in notifications, and plugin update timestamps. The `/model` command now changes only the current session's model. Notable fixes: startup no longer hangs when API is unreachable, terminal corruption issues resolved, and background sessions on macOS no longer crash under Full Disk Access-protected folders. File handling improved for mismatched image extensions, and tool errors reduced during search operations.

---

## Triangulation Status

| Source | Status | Notes |
|--------|--------|-------|
| CC Changelog | OK | Retrieved via WebFetch from upstream |
| System-prompts | PARTIAL | Latest version is 2.1.143 (already audited); 2.1.144 not yet extracted |
| claude-code-guide | Skipped | Single version with no apparent plugin-system changes; cross-reference not needed |

---

## Summary

**Version Range:** 2.1.144 (1 version since last audit at 2.1.143)

**Total Changes Analyzed:** 9 items from CC changelog

**Must Update: 0 items**
- No plugin-system, hook, skill, or agent changes identified

**May Update: 4 items** [Updated by Stage 2]
1. `/resume` command for background sessions - pending system-prompts update for details
2. MCP paginated tools/list fix - behavior fix for multi-tool MCP servers [Stage 2 promoted]
3. MCP unsupported MIME types - edge case image handling [Stage 2 promoted]
4. Plugin update timestamps in marketplace - informational [Stage 2 promoted]

**No Action: 7 items** [Updated by Stage 2]
- Bug fixes and internal improvements
- `/model` command demoted from May Update (not plugin-related)

**Token delta from system-prompts:** N/A (2.1.144 not yet available)

**Triangulation Notes:**
- Single-source triangulation (CC changelog only)
- System-prompts repo lags behind CC releases; 2.1.144 extraction not yet available
- Re-audit recommended once system-prompts are updated to 2.1.144

---

## Recommendations

1. **Wait for system-prompts update**: The system-prompts repository typically updates within 24-48 hours of a CC release. Re-running this audit after the 2.1.144 extraction is available will provide higher-confidence change detection.

2. **No immediate action required**: None of the 2.1.144 changes appear to affect plugin manifests, hooks, skills, or agent features that plugin-dev documents.

3. **Monitor for follow-up releases**: If 2.1.145+ is released before the next audit, those changes should be included in the next run.

4. **Low confidence flag**: This manifest has lower confidence than typical due to single-source triangulation. The May Update items should be re-evaluated once system-prompts are available.

---

## Stage 2: Verification Results
### Verified: 2026-05-19

#### Must Update Verification

Stage 1 identified 0 items for Must Update. Verification found this assessment **incomplete**. The following items were missed:

#### Missed Items (promoted from No Action)

- ! **MCP paginated tools/list fix** (CC 2.1.144) — missed because it was buried in changelog description
  - Affects: mcp-integration
  - Details: "MCP servers with paginated `tools/list` responses now return all pages instead of silently dropping tools". This is a significant behavior fix affecting MCP servers that expose many tools. Plugin authors relying on tool discovery should be aware of this fix. Current mcp-integration/overview.md does not mention pagination behavior.
  - Gap verified: Searched `/home/runner/work/plugin-dev/plugin-dev/plugins/plugin-dev/skills/plugin-dev/references/mcp-integration/overview.md` - no mention of pagination or `tools/list` behavior.
  - **Action: May Update** — Low priority since this is a bug fix users benefit from automatically, but worth documenting in "Tool Search" section as context.

- ! **MCP images with unsupported MIME types** (CC 2.1.144) — missed due to narrow categorization
  - Affects: mcp-integration
  - Details: "MCP images with unsupported MIME types (e.g., SVG) are saved to disk and referenced in tool results". MCP servers returning images now have a fallback behavior for unsupported types.
  - Gap verified: No mention of image handling or MIME types in mcp-integration docs.
  - **Action: May Update** — Edge case behavior, low priority.

- ! **Plugin update timestamps in marketplace** (CC 2.1.144) — incorrectly classified as internal
  - Affects: marketplace-structure
  - Details: "Plugin marketplace now displays when each plugin was last updated". This is visible to plugin consumers and plugin authors should know their last-updated timestamp is displayed.
  - Gap verified: `/home/runner/work/plugin-dev/plugin-dev/plugins/plugin-dev/skills/plugin-dev/references/marketplace-structure/overview.md` does not mention update timestamps.
  - **Action: May Update** — Informational, low priority.

#### May Update Resolution

- = `/resume` command support for background sessions (CC 2.1.144) — kept as May Update: Per Stage 1 analysis, this is a command-level feature. The current plugin-dev docs do not cover background session commands in detail. May be relevant for agent-development docs if background agents use `/resume`. Awaiting system-prompts extraction for details.

- downarrow `/model` command session-scoped behavior change (CC 2.1.144) — demoted to No Action: This is user-facing command behavior, not plugin-related. Plugin developers do not need to document `/model` command behavior changes.

#### Verification of "No Action" Items

Spot-checked the following No Action items:
- ✓ "Elapsed duration in notifications" — Correct, UI feature not plugin-related
- ✓ "Startup hang fix when API is unreachable" — Correct, bug fix not plugin-related
- ✓ "Terminal corruption fixes" — Correct, terminal bug fix
- ✓ "Background session macOS Full Disk Access fix" — Correct, platform bug fix
- ✓ "File handling for mismatched image extensions" — Correct, internal file handling
- ✓ "Tool error reductions during search operations" — Correct, internal error handling

**Correction needed:** "Plugin update timestamps" was incorrectly in No Action - moved to May Update.

#### Summary

- Must Update: 0 items (0 confirmed, 0 rejected, 0 promoted from below)
- May Update: 4 items remaining
  - `/resume` command (original) — kept
  - MCP paginated tools/list fix (promoted from No Action)
  - MCP unsupported MIME types (promoted from No Action)
  - Plugin update timestamps (promoted from No Action)
- No Action: 5 items (1 demoted from May Update, 3 promoted to May Update)
- Confidence: **Medium-Low**
  - Single-source triangulation (CC changelog only, no system-prompts for 2.1.144)
  - Stage 1 missed 3 plugin-relevant items in initial categorization
  - No critical documentation gaps identified — all missed items are informational/edge-case

#### Recommendations

1. **Proceed with caution**: The 4 May Update items are all low-priority and informational. No urgent documentation updates required.

2. **Re-audit when system-prompts updated**: Once system-prompts extracts 2.1.144, re-verify the `/resume` command and check for any prompt-level changes affecting plugins.

3. **Consider documenting MCP pagination**: The `tools/list` pagination fix is a good candidate for a brief note in the MCP integration docs' "Tool Search" section to help users understand tool discovery behavior.

4. **No Stage 1 quality concerns**: Despite missing 3 items, the misclassifications were borderline cases (bug fixes that happen to affect MCP, marketplace metadata). Stage 1's core methodology is sound.
