# Update From Upstream - Design Spec

## Problem

Claude Code releases frequently (multiple times per week) with minimal documentation investment. Changes to the plugin system, hook events, agent features, and tool behavior are buried in a flat changelog with no dates, mixed categories, and inconsistent coverage. The official docs lag behind. Plugin-dev's accuracy degrades silently as CC evolves.

There is no automated way to detect what changed, assess relevance, or apply updates. Each sync is manual, error-prone, and requires cross-referencing multiple unreliable sources.

## Solution

An orchestrator skill (`update-from-upstream`) that runs a four-stage pipeline with three dedicated agents. Reliability comes from source triangulation and independent verification agents, not human checkpoints.

## Pipeline

```
Stage 1: Discover     → changelog-differ agent
Stage 2: Verify Plan  → update-manifest-verifier agent
Stage 3: Apply        → orchestrator (inline)
Stage 4: Verify Work  → update-reviewer agent
Release: Commit, bump version, update compatibility log
```

Each stage produces a structured artifact consumed by the next. Stages 2 and 4 are verification gates run by agents with independent context from the agent that produced the work they're checking.

## Stage 1: Discover

**Agent:** `changelog-differ`

**Inputs:**
- `docs/claude-code-compatibility.md` — reads `Last audited: Claude Code X.Y.Z` to determine the starting version
- CC changelog fetched via WebFetch from `https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md`. If the fetched content does not contain the expected version range, Stage 1 fails explicitly rather than proceeding with partial data.
- CC system prompts CHANGELOG.md from `/Users/kyle/Code/meta-claude/claude-code-system-prompts` (local read)
- `claude-code-guide` built-in subagent type — cross-references changes against official documentation. This agent has access to WebFetch, WebSearch, Glob, Grep, and Read. If this subagent type is unavailable at runtime, Stage 1 degrades gracefully to two-source triangulation (changelog + system-prompts) with keyword scanning from Stage 2 as the compensating check.

**Process:**
1. Parse last audited version from compatibility file
2. Fetch CC changelog, extract all entries since last audited version
3. Read system-prompts CHANGELOG.md for the same version range (more structured, includes token deltas and explicit NEW/REMOVED markers)
4. Dispatch `claude-code-guide` agent to cross-reference each change against official docs — catches things changelogs understate or omit
5. Classify each change by relevance to plugin-dev:
   - **Affects plugin system** (new plugin.json fields, hook events, agent features, skill format changes) → must update
   - **Affects tool behavior** (Bash, Edit, Grep changes) → may affect examples/references
   - **Irrelevant** (IDE extensions, API headers, internal fixes) → skip

**Three-source triangulation:** If something appears in only one source, it gets flagged as lower confidence.

**Output:** Structured change manifest written to `.agent-history/upstream-changes.md`:

```markdown
# Upstream Change Manifest
## CC Version Range: 2.1.87 - 2.1.92
## Generated: 2026-03-29

### Must Update
- [ ] New hook event `ProjectInit` added (CC 2.1.89)
  - Source: changelog, confirmed in system-prompts
  - Affects: hook-development skill
  - Details: Fires when Claude first enters a new project directory

### May Update
- [ ] Read tool now supports .parquet files (CC 2.1.90)
  - Source: changelog only (not yet in system-prompts)
  - Affects: examples referencing file reading

### No Action
- VSCode extension fix for status bar (CC 2.1.88)
- API header change for proxy support (CC 2.1.87)
```

## Stage 2: Verify Plan

**Agent:** `update-manifest-verifier`

This agent operates in a separate context from the differ. It independently fetches its own copy of the CC changelog (fresh WebFetch, not reading from Stage 1's output) to ensure true independence:

1. Fetches the CC changelog and re-reads entries for the version range, confirming each "Must Update" item actually exists and is categorized correctly
2. Scans the changelog for plugin-relevant keywords (`hook`, `plugin`, `agent`, `skill`, `command`, `MCP`, `LSP`, `tool`) that the differ might have classified as "No Action"
3. For each affected skill, reads the current SKILL.md to confirm the gap actually exists (maybe plugin-dev already covers it from a previous manual update)
4. Validates the "Affects" mapping — does the change belong to the identified skill, or a different one?

**Output:** Annotated manifest with verification status:

```markdown
### Verification Results
- ✓ `ProjectInit` hook event — confirmed in CC 2.1.89 changelog,
    not present in hook-development/SKILL.md
- ✗ `.parquet` support — already mentioned in plugin-structure
    examples, downgrade to No Action
- ! Missed: new `permissionMode` value `auto` added in CC 2.1.91,
    affects agent-development skill
```

**On corrections:** The verifier amends the manifest directly. Stage 3 works from the verified version. No re-run of Stage 1 — the pipeline stays linear.

## Stage 3: Apply

**Actor:** The orchestrator skill itself (no dedicated agent — the manifest tells it exactly what to do).

**Process:** For each "Must Update" item in the verified manifest:

1. Read the target SKILL.md (or reference doc)
2. Determine the edit type:
   - **Add** — new capability, event, field → add a new section or bullet in the appropriate place
   - **Modify** — changed behavior → update existing description
   - **Deprecate** — removed feature → mark as deprecated with the CC version it was removed
3. Apply the edit, following existing patterns in the file (heading levels, formatting conventions, example style)
4. If a change spans multiple skills, update all affected files

**After all edits:**

5. Update `docs/claude-code-compatibility.md`:
   - Set `Last audited:` to the newest CC version in the range
   - Append a row to the audit log table
6. Determine version bump based on scope:
   - **Patch** (0.6.1 → 0.6.2): doc corrections, minor additions to existing sections
   - **Minor** (0.6.1 → 0.7.0): new sections, new capabilities documented, structural changes
7. Bump version across plugin.json, marketplace.json, CLAUDE.md
8. Update CHANGELOG.md with the new version entry

**No commit yet** — Stage 4 verifies first.

## Stage 4: Verify Work

**Agent:** `update-reviewer`

**Input:** Verified manifest from Stage 2 + current state of all modified files.

**Checks:**

1. **Completeness** — Walk every "Must Update" item. Grep the target file, confirm new content exists. Flag anything missing.
2. **Accuracy** — Compare each update against source material (CC changelog entry + system-prompts detail). Does the doc accurately describe the feature?
3. **Consistency** — Run existing validation:
   - `markdownlint` on modified .md files
   - Version sync check across plugin.json, marketplace.json, CLAUDE.md
   - CHANGELOG.md has an entry for the new version
4. **Regression** — Read modified SKILL.md files in full. Did edits break surrounding content? Wrong heading nesting, orphaned references, duplicated sections?
5. **Style** — Do new sections match tone and structure of existing content? Third-person descriptions, progressive disclosure pattern, trigger phrases in descriptions.

**Output:**

```markdown
### Review Results: PASS
- Completeness: 5/5 items applied ✓
- Accuracy: all entries match source material ✓
- Lint: clean ✓
- Versions: synced at 0.6.2 ✓
- Regressions: none found ✓
- Style: new hook-development section matches existing pattern ✓
```

**On failure:** The orchestrator applies the reviewer's specific corrections and re-runs Stage 4 (max one retry, then stops and reports what couldn't be resolved).

**On pass:** The orchestrator commits and pushes.

**Stage 4 retry mechanics:** When the reviewer reports failures, its output includes specific corrections (e.g., "missing section X in file Y", "version mismatch in Z"). The orchestrator applies these corrections as targeted edits, then re-dispatches the update-reviewer agent for a full re-check. If the second pass still fails, the orchestrator stops and reports the unresolved items without committing.

## Bootstrap Behavior

On first run, `docs/claude-code-compatibility.md` won't exist. The skill creates it with:

```markdown
# Claude Code Compatibility

Last audited: Claude Code 2.1.86 (2026-03-28)
Plugin-dev version: 0.6.1

## Audit Log
| plugin-dev | CC version range | Date | Notes |
|---|---|---|---|
| v0.6.1 | ≤2.1.86 | 2026-03-28 | Initial compatibility baseline |
```

The initial "Last audited" version is set to the CC version current at the time of implementation. All prior plugin-dev versions are treated as a single baseline row.

## Release Commit Format

Follows conventional commits per project standards:

- **Patch bump:** `docs: sync plugin-dev with Claude Code vX.Y.Z-vA.B.C`
- **Minor bump:** `feat: sync plugin-dev with Claude Code vX.Y.Z-vA.B.C`

The commit body includes a summary of what changed (generated from the manifest).

## Component Inventory

### New Skill (1)

| Component | Path |
|---|---|
| `update-from-upstream` | `plugins/plugin-dev/skills/update-from-upstream/SKILL.md` |

### New Agents (3)

| Agent | Stage | Purpose |
|---|---|---|
| `changelog-differ` | 1 | Fetches and triangulates changes across three sources |
| `update-manifest-verifier` | 2 | Independently validates the change manifest |
| `update-reviewer` | 4 | Verifies applied changes against manifest |

### New Files (1)

| File | Purpose |
|---|---|
| `docs/claude-code-compatibility.md` | Version tracking with audit log table |

### Modified Files (existing)

| File | Change |
|---|---|
| `.claude-plugin/marketplace.json` | Version bump |
| `CLAUDE.md` (root) | Version bump, update component counts (11 skills, 7 agents), reference to new skill |
| `plugins/plugin-dev/skills/plugin-dev-guide/SKILL.md` | Add `update-from-upstream` to available skills listing |

Note: `plugins/plugin-dev/.claude-plugin/plugin.json` and agent/skill directories use auto-discovery — no registration needed. The plugin-dev-guide _agent_ routing table is not modified because `update-from-upstream` is a maintenance skill, not a user-facing plugin development question.

### External Dependencies

| Dependency | Type | Used In | Fallback |
|---|---|---|---|
| `claude-code-guide` subagent | Built-in subagent type | Stage 1 (doc cross-referencing) | Degrade to two-source triangulation |
| `markdownlint` | CLI tool | Stage 4 (lint check) | Skip lint check, warn in output |
| `claude-code-system-prompts` | Local repo at `/Users/kyle/Code/meta-claude/claude-code-system-prompts` | Stage 1 (structured changelog) | Degrade to single-source + claude-code-guide |
| `anthropics/claude-code` CHANGELOG.md | Remote file via `https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md` | Stage 1 (upstream changelog) | Fail — this is the primary source |

## Design Decisions

**Why no shell scripts:** The ambiguous parts of this workflow (interpreting changelog entries, classifying relevance, deciding where content fits) are semantic, not mechanical. LLMs handle this better than regex parsers. The changelog format is loose enough that a script would miss context.

**Why no human gates:** Reliability comes from three mechanisms: source triangulation (three independent sources in Stage 1), independent verification (Stages 2 and 4 use fresh agent context), and existing tooling (markdownlint, version sync checks). This is sufficient for doc updates where the worst case is a slightly inaccurate description that gets caught in the next audit.

**Why the orchestrator applies edits (not an agent):** Stage 3 has the least ambiguity — the manifest says exactly what to change and where. The creative judgment is limited to "where in this file does new content fit" and "match existing style." This doesn't need the overhead of a separate agent context.

**Why patch-default versioning:** Most upstream syncs will add a few bullets to existing sections. Minor bumps are reserved for structural additions (new sections, new skills).

## SKILL.md Frontmatter (sketch)

```yaml
---
name: update-from-upstream
version: 0.1.0
description: >-
  This skill should be used when the user asks to "sync with upstream",
  "update from Claude Code", "check for Claude Code changes",
  "update plugin-dev docs", "sync with latest CC release",
  "what changed in Claude Code", "audit against upstream",
  or needs to bring plugin-dev documentation current with recent
  Claude Code releases.
---
```

## Agent Tool Allowlists

| Agent | Tools | Why |
|---|---|---|
| `changelog-differ` | Read, Grep, Glob, WebFetch, Agent (for claude-code-guide dispatch) | Needs to fetch remote changelog, read local files, dispatch subagent |
| `update-manifest-verifier` | Read, Grep, Glob, WebFetch, Edit | Needs to read changelogs and skill files, amend the manifest |
| `update-reviewer` | Read, Grep, Glob, Bash (for markdownlint) | Needs to read modified files, run lint, verify content |
