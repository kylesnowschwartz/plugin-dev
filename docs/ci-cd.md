# CI/CD Workflows

Documentation for GitHub Actions workflows, labels, and templates.

## PR Workflows

| Workflow                   | Trigger                        | Purpose                     |
| -------------------------- | ------------------------------ | --------------------------- |
| `links.yml`                | `**.md` changed                | Check for broken links      |
| `component-validation.yml` | Plugin components changed      | Validate plugin components  |
| `doc-drift.yml`            | Plugin docs, scripts, pipeline, or version files changed | Check docs against the installed CC binary |
| `version-check.yml`        | Version files changed          | Ensure version consistency  |
| `validate-workflows.yml`   | `.github/workflows/**` changed | Lint GitHub Actions         |
| `yaml-lint.yml`            | `.github/workflows/**` changed | Lint YAML files             |

## Scheduled Workflows

| Workflow            | Schedule     | Purpose                                       |
| ------------------- | ------------ | --------------------------------------------- |
| `upstream-sync.yml` | Every 3 days | Sync plugin-dev docs with Claude Code releases |

The `upstream-sync.yml` job installs the latest Claude Code CLI before the agent
run, extracts ground truth from that binary into `docs/claude-code-facts.json`,
and writes `.agent-history/drift-report.txt`. The agent reads both artifacts as
Stage 0 of the sync pipeline. See [Documentation Drift Guard](#documentation-drift-guard).

A run whose changelog range is empty is a drift-only run. It branches as
`claude/doc-drift-<date>` with the pull request title
`docs: fix documentation drift (<date>)`. The housekeeping step that closes
superseded sync pull requests matches `claude/upstream-sync-` only, so drift pull
requests survive it; the pipeline opens at most one at a time.

## Other Workflows

- `claude.yml` - On-demand `@claude` in issues/PRs
- `sync-labels.yml` - Synchronizes repository labels

## Documentation Drift Guard

The plugin's reference docs describe Claude Code's runtime behavior. Two scripts
keep those claims tied to the binary rather than to the changelog, so a fact that
was wrong from the start, or that changed upstream without a changelog line, is
still caught.

| Script                        | Reads                   | Writes                        |
| ----------------------------- | ----------------------- | ----------------------------- |
| `scripts/extract-cc-facts.sh` | The Claude Code binary  | `docs/claude-code-facts.json` |
| `scripts/check-doc-drift.sh`  | The facts file and docs | One `DRIFT` line per finding on stdout, a run summary on stderr |

```bash
# Ground truth from the installed CLI
scripts/extract-cc-facts.sh --out docs/claude-code-facts.json

# Compare the shipped docs against it
scripts/check-doc-drift.sh

# Without a Claude Code CLI: skips checks G and H, the two that shell out to it
scripts/check-doc-drift.sh --skip-validate
```

Findings go to stdout, one `DRIFT <check> <file>:<line> <message>` line each; the
run summary goes to stderr. Redirecting stdout to a file gives a report of findings
and nothing else. Use `--skip-validate` only where no `claude` CLI is available —
it drops the manifest checks, so the drift report is incomplete.

`extract-cc-facts.sh` exits 2 and writes nothing when a sanity check fails.
`check-doc-drift.sh` exits 0 when clean, 1 when it finds drift, and 2 when a check
could not run, printing an `ERROR` line on stderr for each one. Both workflows fail
the job on exit 2 and show the stderr, so a check that silently stopped running
cannot pass as a clean report.

Both feed the upstream sync pipeline in
`.claude/skills/update-from-upstream/SKILL.md`:

- **Stage 0 (ground truth)** runs both scripts. A diff in
  `docs/claude-code-facts.json` outside the `claude_code_version` key is an upstream
  change signal on its own, and each `DRIFT` line becomes a manifest item. Every
  consumer reads `git diff -I '"claude_code_version"' docs/claude-code-facts.json`:
  the key names the binary the facts came from, and `upstream-sync.yml` installs the
  latest CLI on every run, so on its own it would open a content-free pull request
  every three days. A version-only change is committed alongside the next sync that
  has real content.
- **Stage 1b (doc drift audit)** dispatches the `doc-drift-auditor` agent for the
  contradictions a script cannot detect: the same fact stated two ways, claims a
  sibling file refutes, terminology drift.
- **Stage 4** fails the review on any `DRIFT` line and on a stale facts file. That
  staleness check does include `claude_code_version`: the committed facts must match
  the binary they were read from.

`doc-drift.yml` runs the deterministic half on every pull request that touches the
plugin docs, the facts file, the scripts, the sync pipeline in `.claude/`, or the
files checks E and L read (`.github/workflows/component-validation.yml`,
`CLAUDE.md`, `.claude-plugin/marketplace.json`). It installs the latest Claude Code
CLI the same way `upstream-sync.yml` does, extracts facts into `/tmp/facts.json`,
and runs `scripts/check-doc-drift.sh --facts /tmp/facts.json`, so the docs are
judged against the binary users are on and checks G and H run. Both workflows open
with a preflight step that prints the path of `jq`, `python3`, and `strings` and
fails when one is missing.

A separate non-fatal step compares `/tmp/facts.json` with the checked-in
`docs/claude-code-facts.json`, ignoring `claude_code_version`. When they differ it
writes a step-summary note that the facts file is behind the installed CLI and the
next sync refreshes it. It never fails the job — refreshing the facts file is the
sync pipeline's work, not a pull request author's.

## Labels

Issues and PRs use a structured labeling system defined in `.github/labels.yml`:

| Category  | Format        | Examples                                                                                      |
| --------- | ------------- | --------------------------------------------------------------------------------------------- |
| Component | `component:*` | `component:skill`, `component:agent`, `component:hook`, `component:command`, `component:docs` |
| Priority  | `priority:*`  | `priority:critical`, `priority:high`, `priority:medium`, `priority:low`                       |
| Status    | `status:*`    | `status:blocked`, `status:in-progress`, `status:needs-review`                                 |
| Effort    | `effort:*`    | `effort:small` (<1h), `effort:medium` (1-4h), `effort:large` (>4h)                            |

## Issue & PR Templates

The repository includes templates in `.github/`:

**Issue Templates** (4 types):

- `bug_report.yml` - Bug reports with reproduction steps
- `feature_request.yml` - Feature requests with use cases
- `documentation.yml` - Documentation improvements
- `question.yml` - Questions and discussions

**Pull Request Template**: Component-specific checklists with validation requirements.
