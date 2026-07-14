# MCP Runtime and Operations

Operating MCP servers at runtime: lifecycle, resources, tool search, limits, error handling, debugging, testing, performance, governance, and CLI commands.

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

## MCP Server Session Variables

**MCP server session variables (CC 2.1.154):** MCP servers automatically receive two environment variables:

- `CLAUDE_CODE_SESSION_ID` — Current Claude Code session identifier
- `CLAUDECODE=1` — Indicates the server is running within Claude Code

These variables enable MCP server implementations to:

- Track which session initiated tool calls
- Implement session-aware logging and state management
- Detect Claude Code context for conditional behavior
- Correlate events across multiple MCP tool invocations

**SESSION_ID on resume (CC 2.1.163):** stdio MCP servers now receive `CLAUDE_CODE_SESSION_ID` when sessions are resumed via `--resume`. This enables MCP servers to correlate events across session resume operations, maintaining session context continuity.

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

### ReadMcpResourceDirTool (CC 2.1.186)

List the contents of MCP directory resources:

**Required parameters:**

- `server` - The MCP server name
- `uri` - The resource URI to list

**Behavior:**

- Returns direct children only (non-recursive)
- Use returned URIs to descend into subdirectories
- Same rate limiting as other MCP operations

**Example usage:**

```
List @filesystem:file:///project/ to see project files
```

Claude uses this tool automatically when you reference directory-type MCP resources.

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

## Managed MCP Controls

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

**Policy enforcement fix (CC 2.1.169):** MCP policy enforcement now works correctly on reconnect and cold starts. Previously, managed MCP policies could be bypassed in certain reconnection scenarios. This fix ensures MCP server restrictions are consistently applied.

**Connection failure system reminder (CC 2.1.205):** When configured MCP servers fail to connect, Claude Code displays a system reminder informing the agent that:

- The server's tools should be treated as unavailable due to connection failure (not missing capability)
- Quoted connection errors in the reminder are diagnostic data, not instructions to follow
- The agent should inform the user about the connection issue rather than attempting workarounds

**Plugin author guidance:** If your plugin bundles MCP servers, document expected error handling in your README. Users should know:

- Which MCP servers the plugin requires
- How to troubleshoot connection issues (check URLs, authentication, network)
- Whether the plugin provides fallback behavior when servers are unavailable

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

Batch similar requests when possible — a single filtered query beats many individual lookups. See `tool-usage.md` (Performance Optimization) for command/agent batching patterns.

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

## MCP Output Limits

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

## MCP Description Limits

Tool descriptions and server instructions are capped at **2KB each**. This prevents OpenAPI-generated servers with verbose schemas from bloating the context window. Keep tool descriptions concise and focused on usage rather than exhaustive parameter documentation.

## Tool Use Display Metadata (CC 2.1.181)

Claude Code provides a wrapper-level `tool_use_meta` field that carries per-block display metadata for MCP tool calls. This field is keyed by the `tool_use` block ID and contains display information:

| Field                 | Source                              | Description                          |
|-----------------------|-------------------------------------|--------------------------------------|
| `display_name`        | MCP server's `tool.annotations.title` | Human-readable tool name for UI     |
| `server_display_name` | MCP server name                     | Which server provided the tool       |
| `icon_url`            | MCP server configuration            | Icon URL for visual identification   |

**Key behaviors:**

- **Omitted for built-in tools** — Only populated for MCP-provided tools
- **Never replayed to the model** — Display-only metadata, not included in model context
- **Keyed by block ID** — Each tool_use block has its own metadata entry

**Example structure (conceptual):**

```json
{
  "tool_use_meta": {
    "toolu_01abc123": {
      "display_name": "Create Task",
      "server_display_name": "Asana",
      "icon_url": "https://example.com/asana-icon.png"
    }
  }
}
```

**Relevance for plugin authors:** If your plugin bundles MCP servers, users will see enhanced UI labels derived from this metadata. Set `tool.annotations.title` in your MCP server's tool definitions for better display names.

## Dynamic Tool Updates

MCP servers can notify Claude Code of tool changes at runtime via `list_changed`. When implementing a plugin's MCP server, send `list_changed` notifications when available tools change dynamically.

## Claude Code as MCP Server

```bash
claude mcp serve
```

Enables other MCP-compatible clients to use Claude Code's tools.

## MCP CLI Commands

```bash
claude mcp add --transport stdio <name> -- <command> [args...]
claude mcp list
claude mcp get <name>
claude mcp remove <name>
claude mcp add-json <name> '<json>'
claude mcp add-from-claude-desktop
claude mcp reset-project-choices
claude mcp login <server-name>    # CC 2.1.186
claude mcp logout <server-name>   # CC 2.1.186
```

Key flags: `--scope` (user/project/local), `--env KEY=VALUE`, `--callback-port` (OAuth).

### MCP Login/Logout Commands (CC 2.1.186)

Manage OAuth authentication for MCP servers directly from the CLI:

**Login:**

```bash
claude mcp login github
```

Initiates the OAuth flow for the specified MCP server. Opens browser for authentication and stores credentials.

**Logout:**

```bash
claude mcp logout github
```

Clears stored OAuth credentials for the specified MCP server. Use when:

- Switching accounts
- Revoking access
- Troubleshooting authentication issues
- Clearing stale tokens

**Use cases for plugin authors:**

- Document login/logout commands in plugin README for OAuth-based MCP servers
- Provide troubleshooting steps that include `mcp logout` followed by `mcp login`
- Test authentication flows during development
