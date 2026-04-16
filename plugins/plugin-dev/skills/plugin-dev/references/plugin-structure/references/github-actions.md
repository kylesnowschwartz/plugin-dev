# GitHub Actions Integration for Plugins

Plugins interact with GitHub Actions through `claude-code-action`, Anthropic's official action for running Claude Code in CI workflows. Understanding this integration helps plugin developers ensure their plugins work seamlessly in automated pipelines.

## Overview

The `claude-code-action@v1` runs Claude Code inside GitHub Actions, enabling:

- Automated code review on PRs
- Issue implementation from comments
- Custom automation triggered by @claude mentions
- Scheduled analysis and reporting

## Setup

### Quick Setup

From inside Claude Code:

```bash
/install-github-app
```

This guides through installing the Claude GitHub app and configuring workflows.

### Manual Setup

1. Install the Claude GitHub App: `https://github.com/apps/claude`
2. Add `ANTHROPIC_API_KEY` to repository secrets
3. Create workflow file at `.github/workflows/claude.yml`

### Basic Workflow

```yaml
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

## How Plugins Work in Actions

### CLAUDE.md Integration

The most direct way plugins interact with CI is through CLAUDE.md. Project-level instructions (`.claude/CLAUDE.md`) load automatically in CI runs, providing:

- Code style requirements
- Review criteria
- Project-specific rules
- Plugin references

### Hooks in CI

Plugin hooks execute in the CI environment:

- **Command hooks:** Run normally (ensure scripts are executable and dependencies available)
- **Prompt hooks:** Work as expected
- **SessionStart hooks:** Fire at the beginning of each CI run
- **Environment:** `$CI=true` is set, use for conditional logic

**CI-aware hook example:**

```bash
#!/bin/bash
# Skip interactive checks in CI
if [ "$CI" = "true" ]; then
  echo '{"continue": true}'
  exit 0
fi
# Full validation in local development
# ...
```

### Skills via prompt Parameter

Reference plugin skills in the workflow's `prompt` parameter:

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Review this PR for security issues following our coding standards"
    claude_args: "--max-turns 15"
```

Since slash commands don't work in headless mode, describe the task instead. If the skill has `user-invocable: false`, Claude will use it automatically based on context.

## Configuration Options

### Key Parameters

| Parameter           | Purpose                 | Example                                |
| ------------------- | ----------------------- | -------------------------------------- |
| `prompt`            | Instructions for Claude | `"Review this PR"`                     |
| `claude_args`       | CLI arguments           | `"--max-turns 10 --model haiku"`       |
| `anthropic_api_key` | API key secret          | `${{ secrets.ANTHROPIC_API_KEY }}`     |
| `github_token`      | GitHub API access       | `${{ secrets.GITHUB_TOKEN }}`          |
| `trigger_phrase`    | Custom trigger          | `"@review-bot"` (default: `"@claude"`) |

### claude_args for Plugin Control

Pass CLI flags through `claude_args`:

```yaml
claude_args: >-
  --max-turns 20
  --model claude-sonnet-4-5-20250929
  --allowedTools "Read,Grep,Glob,Bash(npm *)"
```

### Custom Trigger Phrases

Change the default `@claude` trigger:

```yaml
trigger_phrase: "@security-review"
```

Users then mention `@security-review` in PR comments to trigger the workflow.

## Provider Configurations

### AWS Bedrock

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_bedrock: "true"
    claude_args: "--model us.anthropic.claude-sonnet-4-5-20250929-v1:0"
  env:
    AWS_ROLE_TO_ASSUME: ${{ secrets.AWS_ROLE_TO_ASSUME }}
    AWS_REGION: us-east-1
```

Requires AWS OIDC configuration with Bedrock permissions.

### Google Vertex AI

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_vertex: "true"
    claude_args: "--model claude-sonnet-4@20250514"
  env:
    ANTHROPIC_VERTEX_PROJECT_ID: ${{ secrets.GCP_PROJECT_ID }}
    CLOUD_ML_REGION: us-east5
```

Requires GCP Workload Identity Federation.

## Cost Management

### Limit Turns

```yaml
claude_args: "--max-turns 10"
```

Each tool call is one turn. Start low and increase as needed.

### Use Cheaper Models

```yaml
claude_args: "--model haiku"
```

Use Haiku for routine checks, Sonnet for standard reviews, Opus for complex analysis.

### Set Workflow Timeouts

```yaml
jobs:
  claude:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: anthropics/claude-code-action@v1
        # ...
```

### Restrict Tool Access

```yaml
claude_args: "--allowedTools 'Read,Grep,Glob'"
```

Read-only tools prevent expensive write/execute loops.

## Plugin Design for CI

### Document CI Workflows

Include example workflow snippets in your plugin README:

```markdown
## GitHub Actions Usage

Add to `.github/workflows/claude.yml`:

\`\`\`yaml

- uses: anthropics/claude-code-action@v1
  with:
  anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
  prompt: "Analyze code using [your-plugin] standards"
  claude_args: "--max-turns 15 --allowedTools 'Read,Grep,Glob'"
  \`\`\`
```

### Ensure CI Compatibility

- Test hooks with `CI=true` environment variable
- Ensure scripts don't require interactive input
- Handle missing dependencies gracefully (not all CI images have `jq`, etc.)
- Use `${CLAUDE_PLUGIN_ROOT}` for all paths (cache directories differ in CI)

### MCP Servers in CI

MCP servers bundled with plugins start in CI, but:

- OAuth-based servers won't have tokens (configure environment variables instead)
- Local stdio servers need their dependencies installed in the CI image
- Document required CI setup in README
