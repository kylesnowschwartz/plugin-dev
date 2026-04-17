# Plugin Development Toolkit

[![CI](https://github.com/kylesnowschwartz/plugin-dev/actions/workflows/component-validation.yml/badge.svg)](https://github.com/kylesnowschwartz/plugin-dev/actions/workflows/component-validation.yml)
[![Version](https://img.shields.io/github/v/release/kylesnowschwartz/plugin-dev?label=version&color=blue)](https://github.com/kylesnowschwartz/plugin-dev/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A Claude Code plugin that turns Claude into an expert on building Claude Code plugins: hooks, MCP servers, LSP integration, commands, agents, skills, and marketplaces.

Ask a question like "how do I write a PreToolUse hook?" or "add an MCP server to my plugin" and the consolidated `plugin-dev` skill loads the relevant reference automatically.

## Install

```bash
/plugin marketplace add kylesnowschwartz/plugin-dev
/plugin install plugin-dev@kylesnowschwartz/plugin-dev
```

Or for local development:

```bash
claude --plugin-dir /path/to/plugin-dev/plugins/plugin-dev
```

Requires [Claude Code CLI](https://code.claude.com/docs) and `git`. No other configuration.

## What's inside

- **`plugin-dev` skill** — single consolidated reference with a topic index covering plugin structure, commands, skills, agents, hooks, MCP, LSP, marketplaces, and settings. Auto-loads when you mention any of those topics.
- **`update-from-upstream` skill** — keeps this plugin's docs synced with Claude Code releases.
- **6 agents** — `plugin-validator`, `skill-reviewer`, `agent-creator` for building plugins; `changelog-differ`, `update-manifest-verifier`, `update-reviewer` for the upstream sync pipeline.

Topic-by-topic details live in [`plugins/plugin-dev/skills/plugin-dev/SKILL.md`](plugins/plugin-dev/skills/plugin-dev/SKILL.md) — that's the authoritative index, and Claude Code reads it directly.

## Attribution

Originally developed by [Daisy Hollman](mailto:daisy@anthropic.com) at Anthropic ([upstream](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)). This fork adds upstream sync tooling, an expanded consolidated skill, validation agents, and CI workflows. See [CHANGELOG.md](CHANGELOG.md).

## Docs

- [Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Code of conduct](CODE_OF_CONDUCT.md)
- [Claude Code compatibility](docs/claude-code-compatibility.md) · [Component patterns](docs/component-patterns.md) · [Troubleshooting](docs/troubleshooting.md)
- Issues: [GitHub Issues](https://github.com/kylesnowschwartz/plugin-dev/issues)

## License

MIT — see [LICENSE](LICENSE).
