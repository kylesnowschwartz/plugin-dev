---
name: plugin-dev-guide
description: This skill should be used when the user asks about "Claude Code plugins", "plugin development", "how to build a plugin", "what plugin components exist", "plugin architecture", "extending Claude Code", or needs an overview of plugin development capabilities. Acts as a guide to the 8 specialized plugin-dev skills, explaining when to activate each one. Load this skill first when the user is new to plugin development or unsure which specific skill they need.
---

# Plugin Development Guide

This meta-skill provides an overview of Claude Code plugin development and routes to specialized skills based on the task at hand.

## Plugin Development Skills Overview

The plugin-dev toolkit provides 8 specialized skills for building Claude Code plugins. Each skill handles a specific domain of plugin development.

### Skill Quick Reference

| Skill | Purpose | Activate When User Says |
|-------|---------|------------------------|
| **plugin-structure** | Directory layout, manifest, component organization | "create a plugin", "scaffold plugin", "plugin.json" |
| **command-development** | Slash commands with frontmatter | "create a command", "slash command", "command arguments" |
| **agent-development** | Autonomous subagents | "create an agent", "subagent", "agent triggering" |
| **skill-development** | Creating skills with progressive disclosure | "create a skill", "SKILL.md", "skill triggers" |
| **hook-development** | Event-driven automation | "create a hook", "PreToolUse", "validate tool use" |
| **mcp-integration** | Model Context Protocol servers | "add MCP server", "integrate external service" |
| **plugin-settings** | User configuration via .local.md | "plugin configuration", "store settings" |
| **marketplace-structure** | Plugin marketplace creation | "create a marketplace", "distribute plugins" |

## When to Use Each Skill

### Starting a New Plugin

**Activate: `plugin-structure`**

Use when the user needs to:
- Create a new plugin from scratch
- Understand plugin directory layout
- Configure plugin.json manifest
- Learn about component auto-discovery
- Use ${CLAUDE_PLUGIN_ROOT} for portable paths

### Adding User-Facing Commands

**Activate: `command-development`**

Use when the user needs to:
- Create slash commands (/command-name)
- Configure command frontmatter (description, allowed-tools, model)
- Use dynamic arguments ($ARGUMENTS, $1, $2)
- Reference files with @ syntax
- Execute bash inline with `!` backticks

### Creating Autonomous Agents

**Activate: `agent-development`**

Use when the user needs to:
- Create subagents for complex tasks
- Write agent system prompts
- Configure agent triggering (description with examples)
- Choose agent models and colors
- Restrict agent tool access

### Building Skills

**Activate: `skill-development`**

Use when the user needs to:
- Create skills that extend Claude's capabilities
- Write SKILL.md with proper frontmatter
- Organize skill content with progressive disclosure
- Create references/, examples/, scripts/ directories
- Write effective trigger phrases

### Implementing Event Hooks

**Activate: `hook-development`**

Use when the user needs to:
- React to Claude Code events (PreToolUse, Stop, SessionStart, etc.)
- Create prompt-based or command-based hooks
- Validate tool inputs before execution
- Enforce completion standards
- Block dangerous operations

### Integrating External Services

**Activate: `mcp-integration`**

Use when the user needs to:
- Add MCP servers to plugins
- Configure stdio, SSE, HTTP, or WebSocket servers
- Set up authentication (OAuth, tokens)
- Use MCP tools in commands and agents
- Discover existing MCP servers on PulseMCP

### Managing Plugin Configuration

**Activate: `plugin-settings`**

Use when the user needs to:
- Store user-configurable settings
- Use .claude/plugin-name.local.md pattern
- Parse YAML frontmatter in hooks
- Create temporarily active hooks
- Manage agent state

### Creating Plugin Marketplaces

**Activate: `marketplace-structure`**

Use when the user needs to:
- Create a marketplace for multiple plugins
- Configure marketplace.json
- Set up plugin sources (relative, GitHub, git URL)
- Distribute plugins to teams
- Organize plugin collections

## Decision Tree for Skill Selection

```
User wants to...
├── Create/organize a plugin structure? → plugin-structure
├── Add a slash command? → command-development
├── Create an autonomous agent? → agent-development
├── Add domain expertise/knowledge? → skill-development
├── React to Claude Code events? → hook-development
├── Integrate external service/API? → mcp-integration
├── Make plugin configurable? → plugin-settings
└── Distribute multiple plugins? → marketplace-structure
```

## Common Multi-Skill Workflows

### Building a Complete Plugin

1. **Start**: Load `plugin-structure` to create directory layout
2. **Add features**: Load `command-development` for user-facing commands
3. **Automation**: Load `hook-development` for event-driven behavior
4. **Configuration**: Load `plugin-settings` if user configuration needed
5. **Validation**: Use plugin-validator agent to validate structure

### Creating an MCP-Powered Plugin

1. **Start**: Load `plugin-structure` for basic structure
2. **Integration**: Load `mcp-integration` to configure MCP servers
3. **Commands**: Load `command-development` to create commands that use MCP tools
4. **Agents**: Load `agent-development` for autonomous MCP workflows

### Building a Skill-Focused Plugin

1. **Start**: Load `plugin-structure` for basic structure
2. **Skills**: Load `skill-development` to create specialized skills
3. **Validation**: Use skill-reviewer agent to validate skill quality

## Plugin Components Summary

A Claude Code plugin can include:

| Component | Location | Purpose |
|-----------|----------|---------|
| Manifest | `.claude-plugin/plugin.json` | Plugin metadata and configuration |
| Commands | `commands/*.md` | User-invoked slash commands |
| Agents | `agents/*.md` | Autonomous subagents |
| Skills | `skills/*/SKILL.md` | Domain expertise and guidance |
| Hooks | `hooks/hooks.json` | Event-driven automation |
| MCP Servers | `.mcp.json` | External service integration |
| Settings | `.claude/plugin.local.md` | User configuration (per-project) |

## Getting Started

For users new to plugin development:

1. **Read this overview** to understand available capabilities
2. **Load `plugin-structure`** to create your first plugin
3. **Add components** by loading relevant skills as needed
4. **Use workflows** like `/plugin-dev:create-plugin` for guided development

## Skill Activation Instructions

When a user's request matches a specific domain, activate the corresponding skill:

- **Structure/scaffolding questions**: Activate `plugin-structure`
- **Command/slash command questions**: Activate `command-development`
- **Agent/subagent questions**: Activate `agent-development`
- **Skill/SKILL.md questions**: Activate `skill-development`
- **Hook/event/validation questions**: Activate `hook-development`
- **MCP/external service questions**: Activate `mcp-integration`
- **Settings/configuration questions**: Activate `plugin-settings`
- **Marketplace/distribution questions**: Activate `marketplace-structure`

Multiple skills can be loaded simultaneously when tasks span domains.

## Available Agents

The plugin-dev plugin also provides 3 agents:

| Agent | Purpose |
|-------|---------|
| **plugin-validator** | Validates plugin structure and marketplace.json |
| **skill-reviewer** | Reviews skill quality and triggering |
| **agent-creator** | Generates new agents from descriptions |

Use agents proactively after creating components to ensure quality.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/plugin-dev:start` | Entry point - choose plugin or marketplace creation |
| `/plugin-dev:create-plugin` | 8-phase guided plugin creation workflow |
| `/plugin-dev:create-marketplace` | 8-phase guided marketplace creation workflow |
