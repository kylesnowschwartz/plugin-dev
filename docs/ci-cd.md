# CI/CD Workflows

Documentation for GitHub Actions workflows, labels, and templates.

## PR Workflows

| Workflow                   | Trigger                        | Purpose                    |
| -------------------------- | ------------------------------ | -------------------------- |
| `markdownlint.yml`         | `**.md` changed                | Lint markdown files        |
| `links.yml`                | `**.md` changed                | Check for broken links     |
| `component-validation.yml` | Plugin components changed      | Validate plugin components |
| `version-check.yml`        | Version files changed          | Ensure version consistency |
| `validate-workflows.yml`   | `.github/workflows/**` changed | Lint GitHub Actions        |
| `claude-pr-review.yml`     | All PRs (non-draft)            | AI-powered code review     |

## Other Workflows

- `claude.yml` - Main Claude Code workflow
- `stale.yml` - Manages stale issues/PRs (Mon/Wed/Fri)
- `semantic-labeler.yml` - Auto-labels issues/PRs
- `ci-failure-analysis.yml` - Analyzes CI failures
- `weekly-maintenance.yml` - Scheduled maintenance tasks
- `sync-labels.yml` - Synchronizes repository labels
- `greet.yml` - Greets new contributors

## Labels

Issues and PRs use a structured labeling system defined in `.github/labels.yml`:

| Category  | Format        | Examples                                                                                      |
| --------- | ------------- | --------------------------------------------------------------------------------------------- |
| Component | `component:*` | `component:skill`, `component:agent`, `component:hook`, `component:command`, `component:docs` |
| Priority  | `priority:*`  | `priority:critical`, `priority:high`, `priority:medium`, `priority:low`                       |
| Status    | `status:*`    | `status:blocked`, `status:in-progress`, `status:needs-review`                                 |
| Effort    | `effort:*`    | `effort:small` (<1h), `effort:medium` (1-4h), `effort:large` (>4h)                            |

The `semantic-labeler.yml` workflow auto-labels PRs based on file paths changed.

## Issue & PR Templates

The repository includes templates in `.github/`:

**Issue Templates** (4 types):

- `bug_report.yml` - Bug reports with reproduction steps
- `feature_request.yml` - Feature requests with use cases
- `documentation.yml` - Documentation improvements
- `question.yml` - Questions and discussions

**Pull Request Template**: Component-specific checklists with validation requirements. See [CONTRIBUTING.md](../CONTRIBUTING.md) for PR guidelines.
