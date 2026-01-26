---
name: plugin-dev-guide
description: This skill should be used when the user asks about "Claude Code plugins", "plugin development", "how to build a plugin", "what plugin components exist", "plugin architecture", "extending Claude Code", or needs an overview of plugin development capabilities. Acts as a guide to the 9 specialized plugin-dev skills, explaining when to activate each one. Load this skill first when the user is new to plugin development or unsure which specific skill they need.
---

# Plugin Development Guide

This meta-skill provides an overview of Claude Code plugin development and routes to specialized skills based on the task at hand.

## Plugin Development Skills Overview

The plugin-dev toolkit provides 9 specialized skills for building Claude Code plugins. Each skill handles a specific domain of plugin development.

### Skill Quick Reference

| Skill                     | Purpose                                            |
| -------                   | ---------                                          |
| **plugin-structure**      | Directory layout, manifest, component organization |
| **command-development**   | Slash commands with frontmatter                    |
| **agent-development**     | Autonomous subagents                               |
| **skill-development**     | Creating skills with progressive disclosure        |
| **hook-development**      | Event-driven automation                            |
| **mcp-integration**       | Model Context Protocol servers                     |
| **lsp-integration**       | Language Server Protocol for code intelligence     |
| **plugin-settings**       | User configuration via .local.md                   |
| **marketplace-structure** | Plugin marketplace creation                        |

## When to Use Each Skill

### Starting a New Plugin

**Skill: `plugin-structure`**

Use when the user needs to:

- Create a new plugin from scratch
- Understand plugin directory layout
- Configure plugin.json manifest
- Learn about component auto-discovery
- Use ${CLAUDE_PLUGIN_ROOT} for portable paths

### Adding User-Facing Commands

**Skill: `command-development`**

Use when the user needs to:

- Create slash commands (/command-name)
- Configure command frontmatter (description, allowed-tools, model)
- Use dynamic arguments ($ARGUMENTS, $1, $2)
- Reference files with @ syntax
- Execute bash inline with `[BANG]` backticks

### Creating Autonomous Agents

**Skill: `agent-development`**

Use when the user needs to:

- Create subagents for complex tasks
- Write agent system prompts
- Configure agent triggering (description with examples)
- Choose agent models and colors
- Restrict agent tool access

### Building Skills

**Skill: `skill-development`**

Use when the user needs to:

- Create skills that extend Claude's capabilities
- Write SKILL.md with proper frontmatter
- Organize skill content with progressive disclosure
- Create references/, examples/, scripts/ directories
- Write effective trigger phrases

### Implementing Event Hooks

**Skill: `hook-development`**

Use when the user needs to:

- React to Claude Code events (PreToolUse, Stop, SessionStart, etc.)
- Create prompt-based or command-based hooks
- Validate tool inputs before execution
- Enforce completion standards
- Block dangerous operations

### Integrating External Services via MCP

**Skill: `mcp-integration`**

Use when the user needs to:

- Add MCP servers to plugins
- Configure stdio, SSE, HTTP, or WebSocket servers
- Set up authentication (OAuth, tokens)
- Use MCP tools in commands and agents
- Discover existing MCP servers on PulseMCP

### Adding Code Intelligence via LSP

**Skill: `lsp-integration`**

Use when the user needs to:

- Add Language Server Protocol servers to plugins
- Enable go-to-definition and find-references
- Configure language-specific servers (pyright, gopls, rust-analyzer)
- Set up extensionToLanguage mappings
- Enhance Claude's code understanding

### Managing Plugin Configuration

**Skill: `plugin-settings`**

Use when the user needs to:

- Store user-configurable settings
- Use .claude/plugin-name.local.md pattern
- Parse YAML frontmatter in hooks
- Create temporarily active hooks
- Manage agent state

### Creating Plugin Marketplaces

**Skill: `marketplace-structure`**

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
├── Add code intelligence/LSP? → lsp-integration
├── Make plugin configurable? → plugin-settings
└── Distribute multiple plugins? → marketplace-structure
```

## Common Multi-Skill Workflows

### Building a Complete Plugin

1. **Start**: Load `plugin-structure` skill to create directory layout
2. **Add features**: Load `command-development` for user-facing commands
3. **Automation**: Load `hook-development` for event-driven behavior
4. **Configuration**: Load `plugin-settings` if user configuration needed
5. **Validation**: Use plugin-validator agent to validate structure

### Creating an MCP-Powered Plugin

1. **Start**: Load `plugin-structure` for basic structure
2. **Integration**: Load `mcp-integration` to configure MCP servers
3. **Commands**: Load `command-development` to create commands that use MCP tools
4. **Agents**: Load `agent-development` for autonomous MCP workflows

### Building a Code Intelligence Plugin

1. **Start**: Load `plugin-structure` for basic structure
2. **LSP**: Load `lsp-integration` to configure language servers
3. **Commands**: Load `command-development` for commands using LSP features

### Building a Skill-Focused Plugin

1. **Start**: Load `plugin-structure` for basic structure
2. **Skills**: Load `skill-development` to create specialized skills
3. **Validation**: Use skill-reviewer agent to validate skill quality

## Available Agents

The plugin-dev plugin also provides 3 agents:

| Agent | Purpose |
|-------|---------|
| **plugin-validator** | Validates plugin structure and manifests |
| **skill-reviewer** | Reviews skill quality and triggering |
| **agent-creator** | Generates new agents from descriptions |

Use agents proactively after creating components to ensure quality.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/plugin-dev:start` | Entry point - choose plugin or marketplace creation |
| `/plugin-dev:create-plugin` | 8-phase guided plugin creation workflow |
| `/plugin-dev:create-marketplace` | 8-phase guided marketplace creation workflow |

---

## User Request

$ARGUMENTS

If the user provided a request above, analyze it and either:

1. **Route to a specific skill** if the request clearly matches one domain
2. **Answer directly** using this guide's overview information
3. **Ask for clarification** if the request is ambiguous

If no request was provided, summarize the available plugin development capabilities and ask what the user wants to build or learn about.
