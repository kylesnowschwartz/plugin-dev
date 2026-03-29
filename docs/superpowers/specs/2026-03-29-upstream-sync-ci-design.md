# Upstream Sync CI - Design Spec

## Problem

The `update-from-upstream` skill keeps plugin-dev current with Claude Code releases, but it requires manual invocation. Claude Code releases multiple times per week. Without automation, the skill only runs when someone remembers to trigger it.

## Solution

A scheduled GitHub Actions workflow that runs the `update-from-upstream` skill every 3 days, creating a PR for human review.

## Workflow

**File:** `.github/workflows/upstream-sync.yml`

**Trigger:** `schedule` (every 3 days at 06:00 UTC) + `workflow_dispatch` for manual testing.

**Steps:**

1. Checkout plugin-dev repo (fetch-depth 0 for full history)
2. Checkout `Piebald-AI/claude-code-system-prompts` into `./claude-code-system-prompts/`
3. Setup Node.js 22, install markdownlint-cli2 (cached)
4. Run `claude-code-action` with plugin-dev loaded as a plugin

**Plugin loading:** The action's `plugin_marketplaces` input accepts local paths. Since the repo root contains `.claude-plugin/marketplace.json`, pointing it at `"./"` registers the marketplace. Then `plugins: "plugin-dev"` installs the plugin from that marketplace.

**Authentication:** Uses `CLAUDE_CODE_OAUTH_TOKEN` (same as all existing Claude workflows in this repo). Falls back to `ANTHROPIC_API_KEY` if the OAuth token doesn't work for scheduled triggers.

## CI Overrides

The workflow's `prompt` tells Claude to follow the skill but override the release step:

- Create branch `claude/upstream-sync-<date>` instead of committing to main
- Open a PR with the manifest summary in the body
- Exit cleanly with no PR if already up to date

The skill itself is unchanged. The override lives in the workflow prompt, keeping the skill agnostic to its execution context.

## Agent Path Handling

The `changelog-differ` agent checks two paths for the system-prompts repo:

1. `./claude-code-system-prompts/CHANGELOG.md` (CI checkout path)
2. `/Users/kyle/Code/meta-claude/claude-code-system-prompts/CHANGELOG.md` (local dev path)

If neither exists, it degrades to single-source triangulation.

## Permissions

```yaml
permissions:
  contents: write       # Push branches
  pull-requests: write  # Create PRs
  issues: write         # Recommended by claude-code-action
  id-token: write       # Claude GitHub App auth
  actions: read         # Access workflow run data
```

## Patterns Followed

- Pinned action SHAs matching existing workflows (checkout@v6.0.2, setup-node@v6.2.0, cache@v5.0.2, claude-code-action@v1.0.34)
- npm tool caching for markdownlint-cli2
- Concurrency group to prevent overlapping runs
- Commit signing enabled
- 30-minute timeout (longer than validation workflows due to multi-agent pipeline)
- `--max-turns 50` to bound execution cost

## Design Decisions

**Why PR, not direct commit:** The pipeline runs unattended. A PR gives the existing `claude-pr-review.yml` workflow a chance to review changes and lets the maintainer verify accuracy before merging. May be changed to direct-commit once confidence is established.

**Why 3-day interval:** Claude Code releases 2-3 times per week. Every 3 days catches most releases within one cycle. More frequent would waste API calls on "already up to date" results.

**Why load as plugin, not inline prompt:** The skill is the single source of truth for the pipeline logic. The workflow prompt only adds CI-specific overrides (PR instead of commit, path adjustments). If the skill evolves, CI picks up changes automatically.

**Why `--max-turns 50`:** The pipeline dispatches 3 agents and the orchestrator does multi-file edits. 50 turns provides headroom without unbounded execution. Can be tuned based on observed usage.
