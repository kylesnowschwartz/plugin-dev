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

Sync plugin-dev documentation with Claude Code upstream changes using a staged pipeline with independent verification. The pipeline has two discovery sources: the upstream changelog, and ground truth read straight out of the installed Claude Code binary.

## Prerequisites

Before running this skill, ensure:

- The local clone of `claude-code-system-prompts` is up to date: `cd /Users/kyle/Code/meta-claude/claude-code-system-prompts && git pull`
- `docs/claude-code-compatibility.md` exists (the skill creates it on first run if missing)
- A Claude Code binary is available for Stage 0: `claude` on PATH locally, or the executable path exported by the CI workflow

## Pipeline Overview

```
Stage 0:  Ground truth    → extract-cc-facts.sh + check-doc-drift.sh (you, inline)
Stage 1:  Discover        → changelog-differ agent
Stage 1b: Doc drift audit → doc-drift-auditor agent
Stage 2:  Verify plan     → update-manifest-verifier agent
Stage 3:  Apply           → orchestrator (you, inline)
Stage 4:  Verify work     → update-reviewer agent
Release: Commit, bump version, update compatibility log
```

Each stage produces a structured artifact consumed by the next. Stages 2 and 4 are verification gates run by agents with independent context.

## Stage 0: Ground Truth

Establish what the installed Claude Code binary actually does before reading any changelog. This stage catches facts that were wrong from the start and upstream changes that ship without a changelog line.

```bash
# Extract facts from the installed CLI. Locally `claude` is on PATH; in CI the
# workflow exports the path of the CLI it installed.
scripts/extract-cc-facts.sh --out docs/claude-code-facts.json
scripts/extract-cc-facts.sh --binary "$CLAUDE_CODE_EXECUTABLE" --out docs/claude-code-facts.json

# Any diff here is an upstream change signal, changelog line or not
git diff -I '"claude_code_version"' --stat docs/claude-code-facts.json
git diff -I '"claude_code_version"' docs/claude-code-facts.json

# Deterministic drift between the shipped docs and those facts
mkdir -p .agent-history
scripts/check-doc-drift.sh > .agent-history/drift-report.txt
```

**Exit codes:** `extract-cc-facts.sh` exits 2 when a sanity check fails, and writes no output file — stop the pipeline and report. `check-doc-drift.sh` exits 0 when clean, 1 when drift is found (expected — continue), and 2 on a tooling error — stop and report.

**What the outputs mean:**

- A non-empty `git diff -I '"claude_code_version"' docs/claude-code-facts.json` is an upstream change. Keep the full diff: Stage 1 records it in the manifest under "Ground truth changes", one item per changed fact, each mapped to the topic it affects.
- Every line starting with `DRIFT` in `.agent-history/drift-report.txt` becomes a "Must Update" item in the manifest under "Deterministic drift". The lines have the shape `DRIFT <check> <file>:<line> <message>`. Ignore lines that do not start with `DRIFT` — the report can carry progress and summary text that names no finding. Stage 1 reads the file directly.

**Why `claude_code_version` is held out of the signal:** the facts file records which binary it was read from, and CI installs the latest CLI on every run, so that key changes whenever a new release ships even when no documented fact moved. On its own a version-only change is not an upstream change and not a reason to open a pull request. It rides along in the commit of the next sync that has real content.

Stage 0 runs on every sync, including runs where the changelog range turns out to be empty.

**One open drift pull request at a time.** A run that ends up drift-only opens a `claude/doc-drift-<date>` branch, and the housekeeping that closes superseded sync pull requests leaves those alone. Check for an existing one before doing the work:

```bash
gh pr list --state open --search "head:claude/doc-drift-"
```

If that returns an open pull request, stop and report it instead of opening a second one.

## Stage 1: Discover

Dispatch the `changelog-differ` agent with this prompt:

```
Find all Claude Code changes since our last audit. Take the baseline from the
`Last audited: Claude Code X.Y.Z` header line of docs/claude-code-compatibility.md
and from nowhere else — never infer a version from an audit log row. Then:

1. Fetch the CC changelog from https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
2. Read the system-prompts CHANGELOG at /Users/kyle/Code/meta-claude/claude-code-system-prompts/CHANGELOG.md
3. Cross-reference with the claude-code-guide agent for official doc coverage
4. Read .agent-history/drift-report.txt and record every line starting with
   "DRIFT " as a "Must Update" item under a "Deterministic drift" section, with
   the check id, the file:line it cites, and the topic it affects. Ignore lines
   that do not start with "DRIFT "
5. Run `git diff -I '"claude_code_version"' docs/claude-code-facts.json` and
   record every changed fact under a "Ground truth changes" section, with the
   topic it affects. The ignored key tracks which binary the facts came from,
   not a documented fact, so it is never a manifest item
6. Classify all changes and write the manifest to .agent-history/upstream-changes.md

Write the manifest even when the changelog returns no versions after the
baseline, as long as the drift report has a DRIFT line or the facts diff has
content once claude_code_version is ignored.

Follow your agent instructions exactly.
```

**Wait for the agent to complete before proceeding.**

If the agent reports that the CC changelog could not be fetched, stop the pipeline and report to the user.

An empty changelog range on its own does not end the run. See the early-exit rule under Error Handling.

## Stage 1b: Doc Drift Audit

Dispatch the `doc-drift-auditor` agent with this prompt:

```text
Sweep plugin-dev's shipped documentation for internal contradictions and stale
claims that deterministic checks cannot catch. Ground truth is
docs/claude-code-facts.json. Append your findings to
.agent-history/upstream-changes.md as a "Doc Drift Audit" section.

Skip anything scripts/check-doc-drift.sh already owns: event counts and table
membership, broken relative paths, denylisted names, version sync.

Follow your agent instructions exactly.
```

**Wait for the agent to complete before proceeding.**

The auditor's findings are manifest items like any other: Stage 2 verifies them, Stage 3 applies them, Stage 4 checks them.

A clean sweep is a valid result. "No contradictions found" ends this stage with no manifest section beyond that statement.

**Severity floor.** An auditor finding counts toward opening a pull request only once Stage 2 confirms it: both cited locations read and the contradiction verified, or `docs/claude-code-facts.json` settles which side is right. An item Stage 2 marks "unknown" stays in the manifest and is reported, but on its own it never triggers a sync.

## Stage 2: Verify Plan

Dispatch the `update-manifest-verifier` agent with this prompt:

```
Independently verify the change manifest at .agent-history/upstream-changes.md.

Re-fetch the CC changelog yourself (do not trust Stage 1's data). Check every
item for correctness, scan for missed changes, and validate topic mappings by
reading the reference docs at plugins/plugin-dev/skills/plugin-dev/references/<topic>/overview.md.

Verify deterministic drift items by re-running scripts/check-doc-drift.sh for the
cited check, and doc drift audit items by reading both cited file:line locations.
Mark every doc drift audit item confirmed, unknown, or rejected — only confirmed
items count toward opening a pull request.

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

- `Last audited:` moves only when the changelog range is non-empty. Set it to the newest CC version in that range. On a drift-only run — no versions after the baseline — leave the header exactly as it is. The baseline is a claim about which changelog entries have been read, and a drift-only run reads none, so advancing it would silently mark unaudited entries as audited.
- Never write the installed binary's version into `Last audited:`. The binary is whatever CI installed, not a point the changelog was audited to.
- Update `Plugin-dev version:` to the new version
- Append a row to the audit log table. The "CC version range" column takes the changelog range, or `none (drift)` on a drift-only run. When the binary version matters to the row, name it in the Notes column.

**Version bump** — determine scope. The same rule covers drift fixes and changelog-driven edits:

- **Patch** (e.g., 0.7.1 → 0.7.2): doc corrections, minor additions to existing sections, including a drift-only run that fixes real `DRIFT` findings or Stage 2-confirmed auditor items
- **Minor** (e.g., 0.7.1 → 0.8.0): new sections, new capabilities documented, structural changes
- **No release**: a drift-only run whose only changes are the facts file's `claude_code_version` key, or auditor items marked "unknown", produces no version bump, no changelog entry, and no pull request

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

Run the deterministic gate as part of the review:
- `scripts/check-doc-drift.sh` must exit 0. Any line of its stdout starting with
  `DRIFT` is a FAIL; ignore lines that do not.
- Re-run `scripts/extract-cc-facts.sh --out /tmp/facts.json` and diff it against
  docs/claude-code-facts.json to confirm the checked-in facts are current.

Check the compatibility header against the manifest: `Last audited:` advances only
on a run whose changelog range is non-empty, and then only to the newest version in
that range.

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

**Branch and title when the run opens a pull request** (CI always does; locally only when asked):

| Run | Branch | Pull request title |
|---|---|---|
| Changelog range non-empty | `claude/upstream-sync-<date>` | `docs: sync plugin-dev with Claude Code vX.Y.Z-vA.B.C` |
| Drift-only (empty changelog range) | `claude/doc-drift-<date>` | `docs: fix documentation drift (<date>)` |

The prefixes are load-bearing. The housekeeping that closes superseded pull requests matches `claude/upstream-sync-` only, because those runs all audit forward from the same merged baseline and the newest is a superset of the rest. A drift-only run carries independent fixes, so its branch keeps a prefix that housekeeping ignores.

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

### Early exit

Stop the pipeline and report "already up to date" only when all four discovery signals are empty:

1. No new Claude Code versions after the `Last audited:` header line in `docs/claude-code-compatibility.md`
2. No output from `git diff -I '"claude_code_version"' docs/claude-code-facts.json`
3. No lines starting with `DRIFT` in `.agent-history/drift-report.txt`
4. No `doc-drift-auditor` findings that Stage 2 confirmed

Signal 4 carries a severity floor: an auditor finding counts only once Stage 2 confirms it — both cited locations read and the contradiction verified, or `docs/claude-code-facts.json` settles which side is right. An item Stage 2 marks "unknown" never triggers a sync on its own.

Any one non-empty signal continues the run. An empty changelog range on its own is not a reason to stop.

| Condition | Action |
|---|---|
| CC changelog fetch fails | Stop pipeline, report to user |
| All four early-exit signals empty | Stop pipeline, report "already up to date" |
| No new versions, but Stage 0 or a Stage 2-confirmed auditor finding has content | Continue — the manifest carries the drift and ground truth items |
| The only auditor findings are marked "unknown" and no other signal has content | Stop pipeline, report the unknown items without opening a PR |
| `scripts/extract-cc-facts.sh` exits 2 (sanity check failed) | Stop pipeline, report the stderr message to user |
| No `claude` binary available for Stage 0 | Stop pipeline, report to user |
| `scripts/check-doc-drift.sh` exits 2 (tooling error) | Stop pipeline, report to user |
| `claude-code-guide` agent unavailable | Continue with two-source triangulation, note degraded confidence |
| System-prompts repo not found | Continue with CC changelog only, note degraded confidence |
| `markdownlint` not installed | Skip lint check in Stage 4, warn in output |
| Stage 4 fails twice | Stop, report unresolved items, do not commit |
| Manifest verifier finds >30% rejections | Note prominently in output, proceed with corrected manifest |
