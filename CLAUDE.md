# CLAUDE.md

Guidance for Claude Code working in this repository.

## What This Is

Plugin marketplace containing the **plugin-dev** plugin - a toolkit for developing Claude Code plugins. Provides 8 skills, 3 agents, 3 slash commands.

**Version**: v0.2.1 | [CHANGELOG.md](CHANGELOG.md)

## Critical: Two-Level Architecture

This repo has TWO `.claude-plugin/` directories:

| Level  | Path                                             | Purpose              |
| ------ | ------------------------------------------------ | -------------------- |
| Root   | `/.claude-plugin/marketplace.json`               | Marketplace manifest |
| Plugin | `/plugins/plugin-dev/.claude-plugin/plugin.json` | Plugin manifest      |

**Testing**: `claude --plugin-dir plugins/plugin-dev` (NOT root)

## Essential Commands

```bash
# Test plugin locally
claude --plugin-dir plugins/plugin-dev

# Lint markdown
markdownlint '**/*.md' --ignore node_modules

# Lint shell scripts
shellcheck plugins/plugin-dev/skills/*/scripts/*.sh
```

## Key Conventions

- **Paths**: Use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- **Skills**: Progressive disclosure (SKILL.md + references/ + examples/)
- **Descriptions**: Third-person ("This skill should be used when...")
- **Versions**: Sync across plugin.json, marketplace.json, CLAUDE.md

## On-Demand Documentation

| Topic              | File                                                     |
| ------------------ | -------------------------------------------------------- |
| Version releases   | [docs/release-procedure.md](docs/release-procedure.md)   |
| Component patterns | [docs/component-patterns.md](docs/component-patterns.md) |
| CI/CD workflows    | [docs/ci-cd.md](docs/ci-cd.md)                           |
| Troubleshooting    | [docs/troubleshooting.md](docs/troubleshooting.md)       |
| Workflow security  | [docs/workflow-security.md](docs/workflow-security.md)   |

## Quick Fixes

| Problem              | Solution                           |
| -------------------- | ---------------------------------- |
| Plugin not loading   | Use `plugins/plugin-dev`, not root |
| Skill not triggering | Add trigger phrases to description |
| Validation fails     | Run component validator script     |

## Validation Agents

- **plugin-validator**: Validates plugin structure and manifests
- **skill-reviewer**: Reviews skill quality and triggering
- **agent-creator**: Generates agents from descriptions
