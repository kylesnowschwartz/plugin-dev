---
name: plugin-dev-guide
description: This skill should be used when the user asks about "Claude Code plugins", "plugin development", "how to build a plugin", "what plugin components exist", "plugin architecture", "extending Claude Code", or needs an overview of plugin development capabilities. Acts as a guide to the 9 specialized plugin-dev skills, explaining when to activate each one. Load this skill first when the user is new to plugin development or unsure which specific skill they need.
---

# Plugin Development Guide

Spawn the `plugin-dev:plugin-dev-guide` agent (subagent_type: `plugin-dev:plugin-dev-guide`) with the user's question as the prompt. Pass `$ARGUMENTS` as the agent's task.

When the agent reports back, follow its recommendation:

1. **Skill recommended** — invoke that skill using the Skill tool (e.g., `Skill("plugin-dev:mcp-integration")`)
2. **OVERVIEW** — the user wants a general overview; summarize the available skills, commands, and agents from the tables below
3. **NO_MATCH** — no plugin-dev skill covers this topic; answer directly or ask for clarification
4. **Also-relevant skills mentioned** — note these to the user as follow-up options
5. **Agent fails or returns unrecognized output** — fall back to asking the user which area they need help with, listing the skill domains: plugin structure, commands, agents, skills, hooks, MCP, LSP, settings, marketplace

## Available Commands

| Command                          | Purpose                                             |
| -------------------------------- | --------------------------------------------------- |
| `/plugin-dev:start`              | Entry point - choose plugin or marketplace creation |
| `/plugin-dev:create-plugin`      | 8-phase guided plugin creation workflow             |
| `/plugin-dev:create-marketplace` | 8-phase guided marketplace creation workflow        |

## Available Agents

| Agent                | Purpose                                    |
| -------------------- | ------------------------------------------ |
| **plugin-validator** | Validates plugin structure and manifests   |
| **skill-reviewer**   | Reviews skill quality and triggering       |
| **agent-creator**    | Generates new agents from descriptions     |

$ARGUMENTS
