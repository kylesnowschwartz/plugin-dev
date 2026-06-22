# Upstream Change Manifest
## CC Version Range: 2.1.184 - 2.1.185
## Generated: 2026-06-22
## Sources: changelog [Y], system-prompts [Y], claude-code-guide [skipped - timeout in CI]

---

### Must Update

_No plugin-system changes requiring documentation updates._

---

### May Update

_No changes that may require documentation updates._

---

### No Action

- Stream-stall hint messaging improved with clearer language and extended timeout from 10s to 20s (CC 2.1.185)
  - Source: changelog
  - Relevance: Internal UX improvement, does not affect plugin system or tool behavior

- REMOVED: Skill "Migrate to Claude Code" for OpenAI Codex/Gemini CLI migration (CC 2.1.185)
  - Source: system-prompts
  - Relevance: Built-in skill removal - does not affect plugin development or third-party skills

- Agent Prompt: CLAUDE.md creation no longer offers Codex/Gemini migration (CC 2.1.185)
  - Source: system-prompts
  - Relevance: Internal prompt change, does not affect plugin system

- Skill: /init CLAUDE.md no longer checks for Codex/Gemini config or offers migration (CC 2.1.185)
  - Source: system-prompts
  - Relevance: Built-in skill behavior change, does not affect plugin development

---

## Analysis Summary

Only one version (2.1.185) was released after the last audited version (2.1.183). The changes in 2.1.185 are:

1. **Stream-stall messaging improvement** - Internal UX change with no impact on plugin development
2. **Removal of migration features** - The "Migrate to Claude Code" skill and related Codex/Gemini CLI migration prompts were removed from the /init workflow

None of these changes affect:
- Plugin manifest fields (plugin.json)
- Hook events or behavior
- Agent features (model, tools, permissions)
- Skill format (frontmatter fields, loading behavior)
- Command changes relevant to plugins
- MCP or LSP integration
- Built-in tool behavior that would affect examples or docs

**Recommendation:** No documentation updates required for plugin-dev. The v0.24.0 documentation remains compatible with Claude Code 2.1.185.

---

## Raw Changelog Data

### CC Changelog (2.1.185)
```
Stream-stall hint messaging improved with clearer language and extended timeout from 10s to 20s.
```

### System-Prompts Changelog (2.1.185)
```
_-660 tokens_

- **REMOVED:** Skill: Migrate to Claude Code — Removes the generated skill that guided users through manually migrating leftover OpenAI Codex/Gemini CLI config items that `claude migrate` could not map automatically.
- Agent Prompt: CLAUDE.md creation — Removes the instruction to offer Claude Code migration when OpenAI Codex or Gemini CLI config is found while creating CLAUDE.md.
- Skill: /init CLAUDE.md and skill setup (new version) — Removes the Codex/Gemini config presence check and the Phase 8 migration-offer item, so `/init` no longer prioritizes migration of existing foreign-agent config.
```

---

## Triangulation Notes

- **CC Changelog**: Successfully fetched via WebFetch
- **System-prompts**: Successfully read from ./claude-code-system-prompts/CHANGELOG.md
- **claude-code-guide agent**: Dispatch timed out (expected in CI environment)
- **Confidence level**: HIGH - Both sources agree, changes are clearly non-plugin-impacting

---

## Stage 2: Verification Results
### Verified: 2026-06-22

#### Must Update Verification

_No items to verify — manifest correctly identified zero Must Update items._

#### Missed Items (promoted from No Action)

_No missed items found._

**Scan performed for plugin-relevant keywords in CC 2.1.185:**
- `hook`, `plugin`, `agent`, `skill`, `command`: No new plugin-system changes
- `MCP`, `LSP`, `mcp`, `lsp`: No changes
- `tool`, `permission`, `subagent`: No changes affecting plugin development
- `frontmatter`, `manifest`, `plugin.json`: No changes
- `PreToolUse`, `PostToolUse`, `SessionStart`, `Stop`: No changes

**Version gap verification:**
- CC changelog: 2.1.185 has one entry (stream-stall messaging); 2.1.184 has no entry
- System-prompts changelog: 2.1.185 -> 2.1.182 (no 2.1.183/2.1.184 entries)
- Last audited: 2.1.183 (confirmed via plugin-dev CHANGELOG.md v0.24.0)

#### No Action Verification

- ✓ Stream-stall hint messaging (CC 2.1.185) — confirmed in CC changelog, purely UX improvement
- ✓ REMOVED: Skill "Migrate to Claude Code" (CC 2.1.185) — confirmed in system-prompts changelog, built-in skill removal does not affect third-party skill development
- ✓ Agent Prompt: CLAUDE.md creation (CC 2.1.185) — confirmed in system-prompts changelog, internal prompt change
- ✓ Skill: /init CLAUDE.md (CC 2.1.185) — confirmed in system-prompts changelog, built-in skill behavior, not plugin system

#### May Update Resolution

_No items to resolve — manifest correctly identified zero May Update items._

#### Summary

- Must Update: 0 items (0 confirmed, 0 rejected, 0 added)
- May Update: 0 items remaining
- No Action: 4 items (4 confirmed correct)
- Confidence: HIGH — Independent verification confirms all classifications are accurate

**Verification notes:**
1. Independently fetched CC changelog via WebFetch — confirms only stream-stall change in 2.1.185
2. Read system-prompts changelog (lines 1-50) — confirms three prompt changes in 2.1.185
3. Verified last audited version 2.1.183 via plugin-dev CHANGELOG.md
4. Scanned for plugin-relevant keywords — no missed changes found
5. Cross-referenced reference docs to confirm no existing gaps affected by these changes
