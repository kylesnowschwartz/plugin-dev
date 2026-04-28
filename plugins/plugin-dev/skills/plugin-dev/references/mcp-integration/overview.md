
# MCP Integration for Claude Code Plugins

## Overview

Model Context Protocol (MCP) enables Claude Code plugins to integrate with external services and APIs by providing structured tool access. Use MCP integration to expose external service capabilities as tools within Claude Code.

**Key capabilities:**

- Connect to external services (databases, APIs, file systems)
- Provide 10+ related tools from a single service
- Handle OAuth and complex authentication flows
- Bundle MCP servers with plugins for automatic setup

## MCP Scope System

MCP server configurations follow scope precedence: Local > Project > User.

| Scope   | File                              | Shared in repo |
| ------- | --------------------------------- | -------------- |
| Local   | `.claude/.mcp.local.json`         | No             |
| Project | `.claude/.mcp.json` or `.mcp.json`| Yes            |
| User    | `~/.claude/.mcp.json`             | No             |

Plugin-bundled MCP servers auto-start and interact with user/project MCP configs.

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

Find existing MCP servers for your plugin using PulseMCP, the comprehensive MCP server directory with 6,800+ servers.

**Discovery workflow:**

1. Search PulseMCP using Tavily extract on `https://www.pulsemcp.com/servers?q=[keyword]`
2. Evaluate results by classification (official vs community), popularity, and relevance
3. Fetch detail pages for GitHub links and configuration examples
4. Generate `.mcp.json` configuration based on server type

**See `references/server-discovery.md`** for detailed search instructions, URL patterns, and curated server recommendations by category.

## MCP Server Types

### stdio (Local Process)

Execute local MCP servers as child processes. Best for local tools and custom servers.

**Configuration:**

```json
{
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"],
    "env": {
      "LOG_LEVEL": "debug"
    }
  }
}
```

**Use cases:**

- File system access
- Local database connections
- Custom MCP servers
- NPM-packaged MCP servers

**Process management:**

- Claude Code spawns and manages the process
- Communicates via stdin/stdout
- Terminates when Claude Code exits

### SSE (Server-Sent Events)

Connect to hosted MCP servers with OAuth support. Best for cloud services.

**Configuration:**

```json
{
  "asana": {
    "type": "sse",
    "url": "https://mcp.asana.com/sse"
  }
}
```

**Use cases:**

- Official hosted MCP servers (Asana, GitHub, etc.)
- Cloud services with MCP endpoints
- OAuth-based authentication
- No local installation needed

**Authentication:**

- OAuth flows handled automatically
- User prompted on first use
- Tokens managed by Claude Code

### HTTP (REST API)

Connect to RESTful MCP servers with token authentication.

**Configuration:**

```json
{
  "api-service": {
    "type": "http",
    "url": "https://api.example.com/mcp",
    "headers": {
      "Authorization": "Bearer ${API_TOKEN}",
      "X-Custom-Header": "value"
    }
  }
}
```

**Use cases:**

- REST API-based MCP servers
- Token-based authentication
- Custom API backends
- Stateless interactions

### WebSocket (Real-time)

Connect to WebSocket MCP servers for real-time bidirectional communication.

**Configuration:**

```json
{
  "realtime-service": {
    "type": "ws",
    "url": "wss://mcp.example.com/ws",
    "headers": {
      "Authorization": "Bearer ${TOKEN}"
    }
  }
}
```

**Use cases:**

- Real-time data streaming
- Persistent connections
- Push notifications from server
- Low-latency requirements

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

**MCP server identity variables (CC 2.1.85):** Claude Code injects `CLAUDE_CODE_MCP_SERVER_NAME` and `CLAUDE_CODE_MCP_SERVER_URL` into `headersHelper` scripts, enabling server self-identification in multi-server setups.

**Best practice:** Document all required environment variables in plugin README.

## MCP Tool Naming

When MCP servers provide tools, they're automatically prefixed:

**Format:** `mcp__plugin_<plugin-name>_<server-name>__<tool-name>`

**Example:**

- Plugin: `asana`
- Server: `asana`
- Tool: `create_task`
- **Full name:** `mcp__plugin_asana_asana__asana_create_task`

## MCP Resources

MCP servers can expose resources that Claude can access using the `@` syntax:

### Resource Syntax

```
@server-name:protocol://path
```

**Examples:**

```
@filesystem:file:///Users/me/project/README.md
@database:postgres://localhost/mydb/users
@github:https://github.com/user/repo
```

### Using Resources in Prompts

Reference resources directly in your prompts:

```
Look at @filesystem:file:///path/to/config.json and suggest improvements
```

Claude will fetch the resource content and include it in context.

### Resource Types

- **file://** - Local file system paths
- **https://** - HTTP resources
- **Custom protocols** - Server-specific (postgres://, s3://, etc.)

## Tool Search

For MCP servers with many tools, use Tool Search to find relevant tools:

**When to use:**

- Server provides 10+ tools
- You don't know exact tool names
- Exploring server capabilities

**How it works:**

1. Claude Code indexes MCP tool names and descriptions
2. Search by natural language or partial names
3. Get filtered list of matching tools

This feature is automatic - just ask Claude about available tools or describe what you want to do.

### Tool Search Auto-Enable

When MCP servers provide more tools than fit in context (default threshold: 10%), Claude Code activates tool search automatically. Control with `ENABLE_TOOL_SEARCH=auto:5` (custom percentage) or `ENABLE_TOOL_SEARCH=false` (disable).

For plugins bundling many-tool MCP servers, document which tools are most commonly needed so users can pre-allow them.

### Using MCP Tools in Commands

Pre-allow specific MCP tools in command frontmatter:

```markdown
---
allowed-tools: mcp__plugin_asana_asana__asana_create_task, mcp__plugin_asana_asana__asana_search_tasks
---
```

**Wildcard (use sparingly):**

```markdown
---
allowed-tools: mcp__plugin_asana_asana__*
---
```

**Best practice:** Pre-allow specific tools, not wildcards, for security.

## Lifecycle Management

**Automatic startup:**

- MCP servers start when plugin enables
- Connection established before first tool use
- Restart required for configuration changes

**Lifecycle:**

1. Plugin loads
2. MCP configuration parsed
3. Server process started (stdio) or connection established (SSE/HTTP/WS)
4. Tools discovered and registered
5. Tools available as `mcp__plugin_...__...`

**Viewing servers:**
Use `/mcp` command to see all servers including plugin-provided ones.

## Authentication Patterns

### OAuth (SSE/HTTP)

OAuth handled automatically by Claude Code:

```json
{
  "type": "sse",
  "url": "https://mcp.example.com/sse"
}
```

User authenticates in browser on first use. No additional configuration needed.

### Token-Based (Headers)

Static or environment variable tokens:

```json
{
  "type": "http",
  "url": "https://api.example.com",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

Document required environment variables in README.

### Environment Variables (stdio)

Pass configuration to MCP server:

```json
{
  "command": "python",
  "args": ["-m", "my_mcp_server"],
  "env": {
    "DATABASE_URL": "${DB_URL}",
    "API_KEY": "${API_KEY}",
    "LOG_LEVEL": "info"
  }
}
```

## Integration Patterns

### Pattern 1: Simple Tool Wrapper

Commands use MCP tools with user interaction:

```markdown
# Command: create-item.md

---

allowed-tools: `mcp__plugin_name_server__create_item`

Steps:

1. Gather item details from user
2. Use `mcp__plugin_name_server__create_item`
3. Confirm creation
```

**Use for:** Adding validation or preprocessing before MCP calls.

### Pattern 2: Autonomous Agent

Agents use MCP tools autonomously:

```markdown
# Agent: data-analyzer.md

Analysis Process:

1. Query data via `mcp__plugin_db_server__query`
2. Process and analyze results
3. Generate insights report
```

**Use for:** Multi-step MCP workflows without user interaction.

### Pattern 3: Multi-Server Plugin

Integrate multiple MCP servers:

```json
{
  "github": {
    "type": "sse",
    "url": "https://mcp.github.com/sse"
  },
  "jira": {
    "type": "sse",
    "url": "https://mcp.jira.com/sse"
  }
}
```

**Use for:** Workflows spanning multiple services.

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

Pre-allow only necessary MCP tools:

```markdown
✅ allowed-tools: `mcp__plugin_api_server__read_data`, `mcp__plugin_api_server__create_item`

❌ allowed-tools: mcp__plugin_api_server__*
```

### Managed MCP Controls

Organizations can restrict MCP server usage via managed settings:

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverCommand": ["npx", "-y", "@company/mcp-server"] },
    { "serverUrl": "https://mcp.company.com/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "untrusted-server" }
  ]
}
```

Three matcher types: `serverName`, `serverCommand`, `serverUrl`.

These settings are configured by administrators and cannot be overridden by users or plugins.

## Error Handling

### Connection Failures

Handle MCP server unavailability:

- Provide fallback behavior in commands
- Inform user of connection issues
- Check server URL and configuration

**Auto-retry (CC 2.1.121):** MCP servers now auto-retry up to 3 times for transient startup errors, reducing spurious connection failures.

### Tool Call Errors

Handle failed MCP operations:

- Validate inputs before calling MCP tools
- Provide clear error messages
- Check rate limiting and quotas

### Configuration Errors

Validate MCP configuration:

- Test server connectivity during development
- Validate JSON syntax
- Check required environment variables

## Performance Considerations

### Lazy Loading

MCP servers connect on-demand:

- Not all servers connect at startup
- First tool use triggers connection
- Connection pooling managed automatically

### Always Load (CC 2.1.121)

Use `alwaysLoad: true` to bypass lazy loading and tool-search deferral:

```json
{
  "my-server": {
    "command": "node",
    "args": ["${CLAUDE_PLUGIN_ROOT}/servers/server.js"],
    "alwaysLoad": true
  }
}
```

**Use cases:**

- Servers whose tools are needed immediately at session start
- Servers that should always be available regardless of context
- Avoiding tool-search delays for critical integrations

**Note:** Use sparingly — loading all servers unconditionally increases startup time and resource usage.

### Batching

Batch similar requests when possible:

```
# Good: Single query with filters
tasks = search_tasks(project="X", assignee="me", limit=50)

# Avoid: Many individual queries
for id in task_ids:
    task = get_task(id)
```

## Testing MCP Integration

### Local Testing

1. Configure MCP server in `.mcp.json`
2. Install plugin locally (`.claude-plugin/`)
3. Run `/mcp` to verify server appears
4. Test tool calls in commands
5. Check `claude --debug` logs for connection issues

### Validation Checklist

- [ ] MCP configuration is valid JSON
- [ ] Server URL is correct and accessible
- [ ] Required environment variables documented
- [ ] Tools appear in `/mcp` output
- [ ] Authentication works (OAuth or tokens)
- [ ] Tool calls succeed from commands
- [ ] Error cases handled gracefully

## Debugging

### Enable Debug Logging

```bash
claude --debug
```

Look for:

- MCP server connection attempts
- Tool discovery logs
- Authentication flows
- Tool call errors

### Common Issues

**Server not connecting:**

- Check URL is correct
- Verify server is running (stdio)
- Check network connectivity
- Review authentication configuration

**Tools not available:**

- Verify server connected successfully
- Check tool names match exactly
- Run `/mcp` to see available tools
- Restart Claude Code after config changes

**Authentication failing:**

- Clear cached auth tokens
- Re-authenticate
- Check token scopes and permissions
- Verify environment variables set

## Quick Reference

### MCP Server Types

| Type  | Transport | Best For                    | Auth     |
| ----- | --------- | --------------------------- | -------- |
| stdio | Process   | Local tools, custom servers | Env vars |
| SSE   | HTTP      | Hosted services, cloud APIs | OAuth    |
| HTTP  | REST      | API backends, token auth    | Tokens   |
| ws    | WebSocket | Real-time, streaming        | Tokens   |

### Configuration Checklist

- [ ] Server type specified (stdio/SSE/HTTP/ws)
- [ ] Type-specific fields complete (command or url)
- [ ] Authentication configured
- [ ] Environment variables documented
- [ ] HTTPS/WSS used (not HTTP/WS)
- [ ] ${CLAUDE_PLUGIN_ROOT} used for paths

### Best Practices

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

### Claude Code as MCP Server

```bash
claude mcp serve
```

Enables other MCP-compatible clients to use Claude Code's tools.

### Dynamic Tool Updates

MCP servers can notify Claude Code of tool changes at runtime via `list_changed`. When implementing a plugin's MCP server, send `list_changed` notifications when available tools change dynamically.

### MCP Output Limits

- Warning threshold: 10,000 tokens
- Default maximum: 25,000 tokens
- Configure with `MAX_MCP_OUTPUT_TOKENS` environment variable

**Large result override (CC 2.1.91):** MCP servers can return larger results (up to 500K characters) by setting `_meta["anthropic/maxResultSizeChars"]` in the tool result annotation. Useful for large database schemas or similar payloads:

```json
{
  "content": [...],
  "_meta": {
    "anthropic/maxResultSizeChars": 500000
  }
}
```

Design plugin MCP tools to return concise results. Paginate or summarize large outputs.

### MCP Description Limits

Tool descriptions and server instructions are capped at **2KB each**. This prevents OpenAPI-generated servers with verbose schemas from bloating the context window. Keep tool descriptions concise and focused on usage rather than exhaustive parameter documentation.

## MCP CLI Commands

```bash
claude mcp add --transport stdio <name> -- <command> [args...]
claude mcp list
claude mcp get <name>
claude mcp remove <name>
claude mcp add-json <name> '<json>'
claude mcp add-from-claude-desktop
claude mcp reset-project-choices
```

Key flags: `--scope` (user/project/local), `--env KEY=VALUE`, `--callback-port` (OAuth).

## Additional Resources

### Reference Files

For detailed information, consult:

- **`references/server-discovery.md`** - Find MCP servers using PulseMCP directory
- **`references/server-types.md`** - Deep dive on each server type
- **`references/authentication.md`** - Authentication patterns and OAuth
- **`references/tool-usage.md`** - Using MCP tools in commands and agents

### Example Configurations

Working examples in `examples/`:

- **`stdio-server.json`** - Local stdio MCP server
- **`sse-server.json`** - Hosted SSE server with OAuth
- **`http-server.json`** - REST API with token auth
- **`ws-server.json`** - WebSocket server for real-time communication

### External Resources

- **Official MCP Docs**: <https://modelcontextprotocol.io/>
- **Claude Code MCP Docs**: <https://code.claude.com/docs/en/mcp>
- **MCP SDK**: @modelcontextprotocol/sdk
- **Testing**: Use `claude --debug` and `/mcp` command

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

Focus on stdio for custom/local servers, SSE for hosted services with OAuth.
