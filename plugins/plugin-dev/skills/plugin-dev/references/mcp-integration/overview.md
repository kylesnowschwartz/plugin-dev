
# MCP Integration for Claude Code Plugins

## Overview

Model Context Protocol (MCP) enables Claude Code plugins to integrate with external services and APIs by providing structured tool access. Use MCP integration to expose external service capabilities as tools within Claude Code.

**Key capabilities:**

- Connect to external services (databases, APIs, file systems)
- Provide 10+ related tools from a single service
- Handle OAuth and complex authentication flows
- Bundle MCP servers with plugins for automatic setup

This overview is a router. It covers the core concepts (scope, `.mcp.json` basics, server-type comparison, tool naming, environment variables, security, and workflow) and points to the topic's `references/` files and `examples/` for full detail. See the routing table at the end.

## MCP Scope System

MCP server configurations follow scope precedence: Local > Project > User.

| Scope   | File                              | Shared in repo |
| ------- | --------------------------------- | -------------- |
| Local   | `.claude/.mcp.local.json`         | No             |
| Project | `.claude/.mcp.json` or `.mcp.json`| Yes            |
| User    | `~/.claude/.mcp.json`             | No             |

Plugin-bundled MCP servers auto-start and interact with user/project MCP configs.

### Reserved Server Names (CC 2.1.128)

The server name `workspace` is reserved by Claude Code. Do not use `"workspace"` as an MCP server name in plugin configurations — it will conflict with Claude Code's internal workspace server.

## MCP Server Configuration Methods

Plugins can bundle MCP servers in two ways:

### Method 1: Dedicated .mcp.json (Recommended)

Create `.mcp.json` at plugin root:

```json
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "DB_URL": "${DB_URL}"
    }
  }
}
```

**Benefits:**

- Clear separation of concerns
- Easier to maintain
- Better for multiple servers

### Method 2: Inline in plugin.json

Add `mcpServers` field to plugin.json:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

**Benefits:**

- Single configuration file
- Good for simple single-server plugins

## Discovering MCP Servers

Find existing MCP servers for your plugin using PulseMCP, the comprehensive MCP server directory with 6,800+ servers. The workflow: search PulseMCP (Tavily extract on `https://www.pulsemcp.com/servers?q=[keyword]`), evaluate by classification (official vs community), popularity, and relevance, fetch detail pages for GitHub links and config examples, then generate `.mcp.json`.

See `references/server-discovery.md` for detailed search instructions, URL patterns, and curated server recommendations by category.

## MCP Server Types

Claude Code supports four transport types. Pick by where the server runs and how it authenticates.

| Type  | Transport | Best For                    | Auth     |
| ----- | --------- | --------------------------- | -------- |
| stdio | Process   | Local tools, custom servers | Env vars |
| SSE   | HTTP      | Hosted services, cloud APIs | OAuth    |
| HTTP  | REST      | API backends, token auth    | Tokens   |
| ws    | WebSocket | Real-time, streaming        | Tokens   |

- **stdio** executes a local MCP server as a child process (stdin/stdout). Use for file systems, local databases, custom scripts, and NPM-packaged servers bundled with the plugin.
- **SSE** connects to a hosted server over HTTP with server-sent events and automatic OAuth. Use for official hosted servers (Asana, GitHub) and cloud services.
- **HTTP** connects to a RESTful MCP endpoint with token authentication for stateless request/response interactions.
- **ws** connects over WebSocket for real-time bidirectional streaming and push notifications.

For the full decision guide ("Choosing the Right Type"), per-type configuration, process/connection lifecycle, comparison matrix, migration between types, multiple-server setups, and per-transport security, see `references/server-types.md`. Ready-to-copy configs live in `examples/` (`stdio-server.json`, `sse-server.json`, `http-server.json`, `ws-server.json`).

## Environment Variable Expansion

All MCP configurations support environment variable substitution:

**${CLAUDE_PLUGIN_ROOT}** - Plugin directory (always use for portability):

```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server"
}
```

**User environment variables** - From user's shell:

```json
{
  "env": {
    "API_KEY": "${MY_API_KEY}",
    "DATABASE_URL": "${DB_URL}"
  }
}
```

Env vars support fallback values: `${VAR:-default_value}`. Supported in `command`, `args`, `env`, `url`, and `headers` fields.

Claude Code also injects runtime variables: MCP server identity variables for `headersHelper` scripts (`CLAUDE_CODE_MCP_SERVER_NAME`, `CLAUDE_CODE_MCP_SERVER_URL`, CC 2.1.85) — see `references/authentication.md` — and per-session variables (`CLAUDE_CODE_SESSION_ID`, `CLAUDECODE=1`) covered in `references/operations.md`.

**Best practice:** Document all required environment variables in plugin README.

## MCP Connectors vs MCP Servers (CC 2.1.209)

Claude Code distinguishes between **MCP connectors** (hosted by claude.ai) and **MCP servers** (locally configured):

| Type | Configuration | Examples |
| ---- | ------------- | -------- |
| Connectors | claude.ai-hosted, discovered via API | GitHub, Asana, Linear (official connectors) |
| Servers | Locally configured in `.mcp.json` | Custom stdio/SSE/HTTP/ws servers |

**Key distinctions for plugin developers:**

- **Tool naming:** Upstream connector tool names may differ from normalized tool-list names shown in Claude Code
- **Discovery:** Connectors are discovered through the claude.ai API; servers are discovered from local config
- **Availability:** Connectors are unavailable in hermetic/CI sessions or local-only environments
- **Plugin bundling:** Plugins bundle MCP *servers*, not connectors

When designing plugins that integrate with services also available as connectors (e.g., GitHub), be aware that:

- Users may have both a connector and your plugin's server configured
- Tool names from connectors vs servers may differ
- Document which configuration your plugin expects

## MCP Tool Naming

When MCP servers provide tools, they're automatically prefixed:

**Format:** `mcp__plugin_<plugin-name>_<server-name>__<tool-name>`

**Example:**

- Plugin: `asana`
- Server: `asana`
- Tool: `create_task`
- **Full name:** `mcp__plugin_asana_asana__asana_create_task`

Run the `/mcp` command to list every configured server and the exact tool names and schemas it provides. Pre-allow specific MCP tools in command frontmatter (`allowed-tools`), and prefer named tools over wildcards for security. For tool schemas, command/agent usage patterns, batching, and MCP prompts-as-slash-commands, see `references/tool-usage.md`. MCP servers can also expose **resources** via `@server-name:protocol://path` syntax and directory listing — see `references/operations.md`.

## Security Best Practices

### Use HTTPS/WSS

Always use secure connections:

```json
✅ "url": "https://mcp.example.com/sse"
❌ "url": "http://mcp.example.com/sse"
```

### Token Management

**DO:**

- ✅ Use environment variables for tokens
- ✅ Document required env vars in README
- ✅ Let OAuth flow handle authentication

**DON'T:**

- ❌ Hardcode tokens in configuration
- ❌ Commit tokens to git
- ❌ Share tokens in documentation

### Permission Scoping

Pre-allow only necessary MCP tools — specific names, not wildcards:

```markdown
✅ allowed-tools: `mcp__plugin_api_server__read_data`, `mcp__plugin_api_server__create_item`

❌ allowed-tools: mcp__plugin_api_server__*
```

Full authentication patterns (OAuth 2.0 with PKCE, bearer tokens, API keys, custom/dynamic headers, mTLS, JWT, HMAC, multi-tenancy) live in `references/authentication.md`. Organization-level `allowedMcpServers`/`deniedMcpServers` governance controls are documented in `references/operations.md`.

## Configuration Checklist

- [ ] Server type specified (stdio/SSE/HTTP/ws)
- [ ] Type-specific fields complete (command or url)
- [ ] Authentication configured
- [ ] Environment variables documented
- [ ] HTTPS/WSS used (not HTTP/WS)
- [ ] ${CLAUDE_PLUGIN_ROOT} used for paths

## Best Practices

**DO:**

- ✅ Use ${CLAUDE_PLUGIN_ROOT} for portable paths
- ✅ Document required environment variables
- ✅ Use secure connections (HTTPS/WSS)
- ✅ Pre-allow specific MCP tools in commands
- ✅ Test MCP integration before publishing
- ✅ Handle connection and tool errors gracefully

**DON'T:**

- ❌ Hardcode absolute paths
- ❌ Commit credentials to git
- ❌ Use HTTP instead of HTTPS
- ❌ Pre-allow all tools with wildcards
- ❌ Skip error handling
- ❌ Forget to document setup

## Implementation Workflow

To add MCP integration to a plugin:

1. Choose MCP server type (stdio, SSE, HTTP, ws)
2. Create `.mcp.json` at plugin root with configuration
3. Use ${CLAUDE_PLUGIN_ROOT} for all file references
4. Document required environment variables in README
5. Test locally with `/mcp` command
6. Pre-allow MCP tools in relevant commands
7. Handle authentication (OAuth or tokens)
8. Test error cases (connection failures, auth errors)
9. Document MCP integration in plugin README

Focus on stdio for custom/local servers, SSE for hosted services with OAuth. For server lifecycle, testing/validation, debugging (`claude --debug`, `/mcp`), error handling, performance (`alwaysLoad`, lazy loading), output/description limits, and the full `claude mcp` CLI (including `login`/`logout` and `serve`), see `references/operations.md`.

## Routing Table

| Reference | When to read |
| --------- | ------------ |
| `references/server-discovery.md` | Finding or recommending an MCP server: PulseMCP search patterns, parsing results, curated servers by category (databases, productivity, dev tools, cloud, AI, storage), the PulseMCP MCP server. |
| `references/server-types.md` | Configuring a specific transport: full stdio/SSE/HTTP/ws config, process and connection lifecycle, comparison matrix, choosing between types, migration, multiple-server and conditional configs, per-transport security. |
| `references/authentication.md` | Wiring up auth: OAuth 2.0 + PKCE flow and token storage, bearer/API-key/custom headers, `headersHelper` dynamic headers (identity vars CC 2.1.85, auth retry CC 2.1.193), CLI OAuth setup, env-var auth for stdio, multi-tenancy, mTLS/JWT/HMAC, auth troubleshooting. |
| `references/tool-usage.md` | Using MCP tools inside commands and agents: tool naming, `allowed-tools`, tool schemas and parameters, response/error handling, batching/caching/parallel calls, CRUD and multi-step patterns, integration patterns by consumer, testing, MCP prompts as slash commands. |
| `references/operations.md` | Running MCP servers at runtime: lifecycle and `/mcp`, session env vars (CC 2.1.154, CC 2.1.163), resources and `ReadMcpResourceDirTool` (CC 2.1.186), tool search auto-enable, managed `allowedMcpServers`/`deniedMcpServers`, error handling (CC 2.1.121, CC 2.1.169, CC 2.1.205), debugging, testing checklist, performance and `alwaysLoad` (CC 2.1.121), output/description limits and large-result override (CC 2.1.91), `tool_use_meta` (CC 2.1.181), dynamic tool updates and RefreshMcpTools for on-demand tool resync (CC 2.1.211), `claude mcp` CLI, login/logout (CC 2.1.186), `claude mcp serve`. |
| `examples/stdio-server.json` | Copying a local stdio server config (child process, env vars). |
| `examples/sse-server.json` | Copying a hosted SSE server config with OAuth. |
| `examples/http-server.json` | Copying a REST/HTTP server config with token auth. |
| `examples/ws-server.json` | Copying a WebSocket server config for real-time communication. |

## External Resources

- **Official MCP Docs**: <https://modelcontextprotocol.io/>
- **Claude Code MCP Docs**: <https://code.claude.com/docs/en/mcp>
- **MCP SDK**: @modelcontextprotocol/sdk
- **Testing**: Use `claude --debug` and `/mcp` command
