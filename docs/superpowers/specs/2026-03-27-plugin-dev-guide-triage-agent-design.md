# Plugin-Dev Guide Triage Agent

## Problem

The `plugin-dev-guide` skill loads its full routing table into the main context window every time someone asks a plugin development question. That content exists only to figure out which of the 9 specialized skills to invoke. Once the right skill is loaded, the routing table is dead weight.

## Solution

Replace the in-context routing with a Haiku triage agent. The agent matches the user's question to the right skill and reports back. The main agent then loads only that skill. Main context gets exactly one skill (the right one), not the guide overhead.

## Components

### 1. New Agent: `agents/plugin-dev-guide.md`

**Frontmatter:**

```yaml
name: plugin-dev-guide
model: haiku
color: blue
tools: Read, Grep
```

**Description:** Triggers on plugin development questions — "how to build a plugin", "what plugin components exist", "plugin architecture", "extending Claude Code", specific component questions (hooks, MCP, LSP, skills, agents, commands, settings, marketplace), and plugin troubleshooting.

Includes 4 `<example>` blocks:
1. New-to-plugins overview question
2. Specific component question (e.g., hooks)
3. Capability exploration ("what can plugins do")
4. Troubleshooting ("my skill isn't loading")

**System prompt structure:**

1. **Role definition** — Triage agent. Match questions to skills. Do not answer questions directly.

2. **Routing table** — Compact, one line per skill:

   | Skill | Domain |
   |-------|--------|
   | plugin-structure | Directory layout, manifest, plugin.json, component auto-discovery, `${CLAUDE_PLUGIN_ROOT}` |
   | command-development | Slash commands, frontmatter, dynamic arguments, `$ARGUMENTS`, bash execution, `@` file references |
   | agent-development | Subagents, agent system prompts, triggering via description/examples, model/color/tools config |
   | skill-development | SKILL.md, progressive disclosure, references/examples/scripts dirs, trigger phrases, `context: fork` |
   | hook-development | PreToolUse, PostToolUse, Stop, SessionStart, prompt-based hooks, command-based hooks, scoped hooks |
   | mcp-integration | MCP servers, stdio/SSE/HTTP/WebSocket, `.mcp.json`, OAuth, MCP tools in commands/agents |
   | lsp-integration | Language servers, go-to-definition, find-references, `extensionToLanguage`, pyright/gopls/rust-analyzer |
   | plugin-settings | `.local.md` pattern, YAML frontmatter in hooks, per-project config, agent state |
   | marketplace-structure | `marketplace.json`, plugin sources (relative/GitHub/git), distribution, plugin collections |

3. **Decision process:**
   - First pass: match the question to one or more candidate skills from the table
   - If exactly one match: report it
   - If ambiguous: use Read to skim the top of candidate SKILL.md files (path: `${CLAUDE_PLUGIN_ROOT}/skills/<skill-name>/SKILL.md`), pick the best fit
   - If the question is a general overview request ("what can plugins do", "list all capabilities", "give me an overview"): report `OVERVIEW` as a special response — the main agent handles these directly from the skill's command/agent tables
   - If no match: report `NO_MATCH`

4. **Also-relevant skills:** If a secondary skill is partially relevant, mention it after the primary recommendation.

5. **Multi-skill workflows:** If the question spans multiple skills ("build a complete plugin with MCP and hooks"), recommend the primary skill to start with and list the others as a suggested sequence.

6. **Output format:**
   ```
   **Recommended skill:** <skill-name>
   **Why:** <one sentence explaining the match>
   **Also relevant:** <optional secondary skill or sequence, or "none">
   ```

   For overview questions:
   ```
   **Recommended skill:** OVERVIEW
   **Why:** User is asking for a general overview of plugin capabilities.
   ```

   For no-match:
   ```
   **Recommended skill:** NO_MATCH
   **Why:** <brief explanation of what was asked>
   ```

7. **Constraints:**
   - Do not answer the user's question. Only recommend which skill to invoke.
   - Do not fabricate skill descriptions. If unsure whether a skill covers a topic, read the file.
   - Keep responses under 100 words.

### 2. Updated Skill: `skills/plugin-dev-guide/SKILL.md`

**Frontmatter:** Same `name` and `description` (triggering conditions unchanged).

**Body:** Replace the current routing table and decision tree with dispatch instructions:

```markdown
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
```

The skill retains command/agent reference tables since those are small and useful for the main agent to have in context. The routing logic (the expensive part) moves to the triage agent. `$ARGUMENTS` is passed through as the triage agent's task prompt.

## What Does NOT Change

- The 9 specialized skills (untouched)
- The 3 existing agents: plugin-validator, skill-reviewer, agent-creator (untouched)
- The 3 commands: start, create-plugin, create-marketplace (untouched)
- `plugin.json` manifest (agents are auto-discovered from `agents/` directory)

## Flow

```
User: "How do I add MCP to my plugin?"
  -> Main agent sees plugin-dev question, loads plugin-dev-guide skill
  -> Skill says: dispatch plugin-dev:plugin-dev-guide agent
  -> Haiku agent: matches "MCP" -> mcp-integration
     (optionally reads SKILL.md to confirm)
  -> Returns: "Recommended skill: mcp-integration. Covers MCP server types, auth, .mcp.json config."
  -> Main agent invokes /mcp-integration
  -> User gets full MCP guidance in main context for follow-up conversation
```

## Design Decisions

**Why Haiku?** This is pattern matching against a 9-row table, not deep reasoning. Haiku is fast and cheap. The specialized skill (loaded afterward) does the actual teaching.

**Why Read/Grep tools?** Insurance against the routing table going stale. If the table drifts from actual skill content, the agent can verify by reading the file. One file read is cheap.

**Why no WebFetch?** Doc fetching is a reasoning task that belongs in the main context after the right skill is loaded, not in a fast triage agent. Haiku's smaller context window makes large web fetches counterproductive.

**Why not `context: fork`?** The `agent` field in skill frontmatter only accepts built-in agent types (`Explore`, `Plan`, `general`). Custom plugin agents can't be referenced. The superpowers plugin confirms this pattern: it dispatches subagents via the Agent tool with crafted prompts, not via `context: fork`.

**Why keep command/agent tables in the skill?** They're small (6 rows total) and the main agent benefits from knowing about `/create-plugin` and the validator agents. Not worth offloading.

**Why drop multi-skill workflow recipes?** The current skill has "Building a Complete Plugin" and similar workflow sections. These are useful but rarely needed — most questions map to a single skill. The triage agent handles multi-skill questions by recommending a primary skill and listing a sequence. If workflow recipes prove valuable enough to keep, they can move to a `references/workflows.md` file in the skill directory.

**Why no `skills` field in agent frontmatter?** The triage agent doesn't need skill content loaded into its context. It uses the routing table in its system prompt for fast matching and falls back to reading SKILL.md files directly via the Read tool when disambiguation is needed. Loading skills would bloat the agent's context, defeating the "fast triage" purpose.

**Why no Glob tool?** The agent knows the exact path pattern for every SKILL.md file (`${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md`). Pattern-based file discovery isn't needed.
