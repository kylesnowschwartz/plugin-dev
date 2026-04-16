---
name: plugin-dev
description: MUST use this skill when the user mentions plugins, hooks, skills, commands, agents, MCP servers, LSP servers, marketplaces, plugin.json, SKILL.md, .mcp.json, .local.md, allowed-tools, frontmatter, PreToolUse, PostToolUse, SessionStart, event schemas, prompt-based hooks, plugin settings, output styles, headless mode, CI mode, CLAUDE_PLUGIN_ROOT, auto-discovery, or any aspect of extending Claude Code. Use INSTEAD OF answering from general knowledge. Also use when writing hooks for settings.json, configuring MCP servers outside plugins, or comparing skills vs commands, since this skill contains the authoritative reference for these Claude Code extension mechanisms.
---

# Claude Code Plugin Development

Comprehensive guide for developing Claude Code plugins. Read the relevant reference file(s) before answering. If a question spans multiple topics, read each relevant reference.

## Topic Index

| Topic | Reference | When to read |
|-------|-----------|--------------|
| Plugin structure | `references/plugin-structure/overview.md` | Plugin scaffolding, plugin.json, directory layout, CI/headless mode, output styles, userConfig, auto-discovery, installation, caching, validation |
| Commands | `references/command-development/overview.md` | Slash commands, command frontmatter, arguments, bash execution, allowed-tools, disable-model-invocation, Skill tool mechanism, debugging commands |
| Skills | `references/skill-development/overview.md` | SKILL.md format, skill frontmatter, triggers, progressive disclosure, context:fork, bundled resources, visibility budget, file-scoped skills |
| Agents | `references/agent-development/overview.md` | Agent creation, system prompts, agent frontmatter, teams, permissions, maxTurns, disallowedTools, background agents, initialPrompt |
| Hooks | `references/hook-development/overview.md` | Event hooks, PreToolUse, PostToolUse, Stop, prompt-based hooks, scoped hooks, hook decisions (allow/block/defer), statusMessage, async hooks |
| MCP integration | `references/mcp-integration/overview.md` | MCP servers in plugins, .mcp.json, tool search, MCP prompts, server types (stdio/SSE/HTTP), allowedMcpServers, MCP CLI commands |
| LSP integration | `references/lsp-integration/overview.md` | Language servers, code intelligence, socket transport, initializationOptions, extensionToLanguage |
| Marketplace | `references/marketplace-structure/overview.md` | marketplace.json, multi-plugin distribution, hosting, strictKnownMarketplaces, private marketplaces, version pinning |
| Plugin settings | `references/plugin-settings/overview.md` | .local.md files, YAML frontmatter config, per-project settings, CLAUDE.md imports, rules system, memory hierarchy |

Each topic directory also contains additional references/, examples/, and scripts/ for detailed content. Read those when the overview alone is insufficient.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/plugin-dev:start` | Entry point - choose plugin or marketplace creation |
| `/plugin-dev:create-plugin` | 8-phase guided plugin creation workflow |
| `/plugin-dev:create-marketplace` | 8-phase guided marketplace creation workflow |

## Available Agents

| Agent | Purpose |
|-------|---------|
| **plugin-validator** | Validates plugin structure and manifests |
| **skill-reviewer** | Reviews skill quality and triggering |
| **agent-creator** | Generates new agents from descriptions |
| **changelog-differ** | Discovers upstream Claude Code changes (Stage 1) |
| **update-manifest-verifier** | Validates change manifest (Stage 2) |
| **update-reviewer** | Verifies applied documentation updates (Stage 4) |

## Maintenance Skills

| Skill | Purpose |
|-------|---------|
| **update-from-upstream** | Sync plugin-dev docs with Claude Code upstream releases |

$ARGUMENTS
