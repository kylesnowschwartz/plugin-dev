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
- CC changelog from `anthropics/claude-code` repo (fetched via WebFetch)
- CC system prompts CHANGELOG.md from `/Users/kyle/Code/meta-claude/claude-code-system-prompts` (local read)
- `claude-code-guide` built-in agent — cross-references changes against official documentation

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

This agent operates in a separate context from the differ. It independently:

1. Re-reads the CC changelog entries for the version range and confirms each "Must Update" item actually exists and is categorized correctly
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
| `plugin.json` | Register new skill and agents |
| `marketplace.json` | Version bump |
| `CLAUDE.md` | Reference to new skill |
| `plugin-dev-guide.md` | Add `update-from-upstream` to routing table |

### External Dependencies

| Dependency | Type | Used In |
|---|---|---|
| `claude-code-guide` agent | Built-in subagent | Stage 1 (doc cross-referencing) |
| `markdownlint` | CLI tool | Stage 4 (lint check) |
| `claude-code-system-prompts` | Local repo | Stage 1 (structured changelog) |
| `anthropics/claude-code` | GitHub repo | Stage 1 (upstream changelog) |

## Design Decisions

**Why no shell scripts:** The ambiguous parts of this workflow (interpreting changelog entries, classifying relevance, deciding where content fits) are semantic, not mechanical. LLMs handle this better than regex parsers. The changelog format is loose enough that a script would miss context.

**Why no human gates:** Reliability comes from three mechanisms: source triangulation (three independent sources in Stage 1), independent verification (Stages 2 and 4 use fresh agent context), and existing tooling (markdownlint, version sync checks). This is sufficient for doc updates where the worst case is a slightly inaccurate description that gets caught in the next audit.

**Why the orchestrator applies edits (not an agent):** Stage 3 has the least ambiguity — the manifest says exactly what to change and where. The creative judgment is limited to "where in this file does new content fit" and "match existing style." This doesn't need the overhead of a separate agent context.

**Why patch-default versioning:** Most upstream syncs will add a few bullets to existing sections. Minor bumps are reserved for structural additions (new sections, new skills).
