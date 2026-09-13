# Version Release Procedure

This document describes the release workflow for plugin-dev.

## How Distribution Works

This repo is a plugin marketplace. Users install by pointing Claude Code at
the git repo — it clones `main` and reads `marketplace.json`. No GitHub
releases, tags, or release branches needed. Push to `main` and users get the
update on next plugin refresh.

## Version Files

Version must be synchronized across these files on release:

- `plugins/plugin-dev/.claude-plugin/plugin.json` (source of truth)
- `.claude-plugin/marketplace.json` (metadata.version AND plugins[0].version)
- `CLAUDE.md` (version line)

```bash
# Verify version consistency
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

## Release Steps

### 1. Update Version Numbers

Update version in **all version files** (must match):

```bash
# Find current version to replace
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json

# Update all version files, then verify
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

### 2. Update CHANGELOG.md

Add release notes following Keep a Changelog format:

1. Review commits since last release: `git log --oneline` (find previous version bump)
2. Organize into sections: Added, Changed, Fixed
3. Group related changes

### 3. Lint and Verify

```bash
# Lint markdown files
markdownlint '**/*.md' --ignore node_modules

# Verify version consistency
rg '"version"' plugins/plugin-dev/.claude-plugin/plugin.json .claude-plugin/marketplace.json
rg 'Version.*v[0-9]' CLAUDE.md
```

### 4. Check Documentation Drift

The reference docs describe Claude Code's runtime behavior, so they can go stale
without anyone editing them. Run the drift guard before every release:

```bash
# Refresh ground truth from the installed Claude Code CLI
scripts/extract-cc-facts.sh --out docs/claude-code-facts.json

# Compare the shipped docs against it — must exit 0
scripts/check-doc-drift.sh
```

Each finding prints to stdout as `DRIFT <check> <file>:<line> <message>`; the run
summary goes to stderr. Fix every `DRIFT` line before releasing, and commit
`docs/claude-code-facts.json` alongside the fixes.

A changed facts file is an upstream change worth documenting, except for the
`claude_code_version` key on its own — it records which binary the facts were read
from, so it moves with every CLI upgrade. Check with
`git diff -I '"claude_code_version"' docs/claude-code-facts.json`.

`scripts/check-doc-drift.sh --skip-validate` skips checks G and H, the two that
shell out to the `claude` CLI. Use it only where no CLI is available — the drift
report is incomplete without them.

`doc-drift.yml` runs the full gate on pull requests: it installs the latest Claude
Code CLI, extracts facts to `/tmp/facts.json`, and runs
`scripts/check-doc-drift.sh --facts /tmp/facts.json`, so the docs are judged
against the binary rather than against the checked-in facts file. It also walks
`jq`, `python3`, and `strings` one at a time first and fails naming the first tool
it cannot find, and posts a non-fatal step-summary note when
`docs/claude-code-facts.json` is behind the installed CLI. That note is
informational: the next upstream sync refreshes the facts file.

The upstream sync opens a drift-only pull request — one whose changelog range is
empty — on a `claude/doc-drift-<date>` branch titled
`docs: fix documentation drift (<date>)`. Real `DRIFT` fixes in such a run are a
patch release; a run whose only change is the facts file's `claude_code_version`
key produces no release at all.

### 5. Commit and Push

```bash
git add -u
git commit -m "feat: release v0.x.x

Brief description of changes."

git push
```

Users receive the update on next plugin refresh or reinstall.
