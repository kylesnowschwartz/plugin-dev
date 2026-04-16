---
name: update-from-upstream
version: 0.1.0
description: >-
  This skill should be used when the user asks to "sync with upstream",
  "update from Claude Code", "check for Claude Code changes",
  "update plugin-dev docs", "sync with latest CC release",
  "what changed in Claude Code", "audit against upstream",
  "bring docs up to date", "check upstream changelog",
  "sync plugin-dev with Claude Code", "update compatibility",
  or needs to bring plugin-dev documentation current with recent
  Claude Code releases.
---

# Update From Upstream

Sync plugin-dev documentation with Claude Code upstream changes using a four-stage pipeline with independent verification.

## Prerequisites

Before running this skill, ensure:
- The local clone of `claude-code-system-prompts` is up to date: `cd /Users/kyle/Code/meta-claude/claude-code-system-prompts && git pull`
- `docs/claude-code-compatibility.md` exists (the skill creates it on first run if missing)

## Pipeline Overview

```
Stage 1: Discover     → changelog-differ agent
Stage 2: Verify Plan  → update-manifest-verifier agent
Stage 3: Apply        → orchestrator (you, inline)
Stage 4: Verify Work  → update-reviewer agent
Release: Commit, bump version, update compatibility log
```

Each stage produces a structured artifact consumed by the next. Stages 2 and 4 are verification gates run by agents with independent context.

## Stage 1: Discover

Dispatch the `changelog-differ` agent with this prompt:

```
Find all Claude Code changes since our last audit. Read the last audited
version from docs/claude-code-compatibility.md, then:

1. Fetch the CC changelog from https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
2. Read the system-prompts CHANGELOG at /Users/kyle/Code/meta-claude/claude-code-system-prompts/CHANGELOG.md
3. Cross-reference with the claude-code-guide agent for official doc coverage
4. Classify all changes and write the manifest to .agent-history/upstream-changes.md

Follow your agent instructions exactly.
```

**Wait for the agent to complete before proceeding.**

If the agent reports that the CC changelog could not be fetched or the version range is empty (already up to date), stop the pipeline and report to the user.

## Stage 2: Verify Plan

Dispatch the `update-manifest-verifier` agent with this prompt:

```
Independently verify the change manifest at .agent-history/upstream-changes.md.

Re-fetch the CC changelog yourself (do not trust Stage 1's data). Check every
item for correctness, scan for missed changes, and validate topic mappings by
reading the reference docs at skills/plugin-dev/references/<topic>/overview.md.

Follow your agent instructions exactly.
```

**Wait for the agent to complete before proceeding.**

Read the updated manifest after Stage 2 completes. The verified manifest is your source of truth for Stage 3.

## Stage 3: Apply

You execute this stage directly. Work through the verified manifest:

### For each "Must Update" item

1. Read the target reference doc at `plugins/plugin-dev/skills/plugin-dev/references/<topic>/overview.md` (or its sub-references)
2. Determine the edit type:
   - **Add** — new capability, event, field: add a new section or bullet in the appropriate place
   - **Modify** — changed behavior: update existing description
   - **Deprecate** — removed feature: mark as deprecated with the CC version it was removed
3. Apply the edit. Match the existing patterns in the file:
   - Same heading levels as sibling sections
   - Same formatting (code blocks, tables, bullet styles)
   - Same tone (third-person, imperative)
4. If a change spans multiple skills, update all affected files

### For each "May Update" item

Use judgment. If the change materially affects examples or references that users rely on, update them. Otherwise skip.

### After all edits, update metadata

**Compatibility file** (`docs/claude-code-compatibility.md`):
- Set `Last audited:` to the newest CC version in the range
- Update `Plugin-dev version:` to the new version
- Append a row to the audit log table

**Version bump** — determine scope:
- **Patch** (e.g., 0.7.1 → 0.7.2): doc corrections, minor additions to existing sections
- **Minor** (e.g., 0.7.1 → 0.8.0): new sections, new capabilities documented, structural changes

**Bump version in all three locations:**
- `plugins/plugin-dev/.claude-plugin/plugin.json` — `"version"` field
- `.claude-plugin/marketplace.json` — both `metadata.version` and the plugin entry `version`
- `CLAUDE.md` (root) — version line, component counts if changed

**Update CHANGELOG.md:**
- Add a new version entry following Keep a Changelog format
- Organize changes into Added/Changed/Fixed sections
- Reference the CC version range in the entry

**Do not commit yet** — Stage 4 verifies first.

## Stage 4: Verify Work

Dispatch the `update-reviewer` agent with this prompt:

```
Review the applied documentation updates against the verified manifest at
.agent-history/upstream-changes.md.

Check completeness, accuracy, lint (run markdownlint), version sync, regressions,
and style. Report PASS or FAIL with specific fix instructions.

Follow your agent instructions exactly.
```

**Wait for the agent to complete.**

### On PASS

Commit and push:

```bash
# Stage files selectively
git add -u

# Commit with conventional format
# For patch bumps:
git commit -m "docs: sync plugin-dev with Claude Code vX.Y.Z-vA.B.C"
# For minor bumps:
git commit -m "feat: sync plugin-dev with Claude Code vX.Y.Z-vA.B.C"

git push
```

### On FAIL

1. Read the reviewer's specific fix instructions
2. Apply each fix as a targeted edit
3. Re-dispatch the `update-reviewer` agent for a second check
4. If the second check still fails, **stop and report** the unresolved items to the user. Do not commit broken changes.

## First Run Bootstrap

If `docs/claude-code-compatibility.md` does not exist, create it before Stage 1:

```markdown
# Claude Code Compatibility

Last audited: Claude Code 2.1.84 (2026-03-27)
Plugin-dev version: 0.7.0

## Audit Log

| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.5.0 | ≤2.1.84 | 2026-03-27 | Initial compatibility baseline |
```

Then proceed with Stage 1 as normal.

## Error Handling

| Condition | Action |
|---|---|
| CC changelog fetch fails | Stop pipeline, report to user |
| No new versions since last audit | Stop pipeline, report "already up to date" |
| `claude-code-guide` agent unavailable | Continue with two-source triangulation, note degraded confidence |
| System-prompts repo not found | Continue with CC changelog only, note degraded confidence |
| `markdownlint` not installed | Skip lint check in Stage 4, warn in output |
| Stage 4 fails twice | Stop, report unresolved items, do not commit |
| Manifest verifier finds >30% rejections | Note prominently in output, proceed with corrected manifest |
