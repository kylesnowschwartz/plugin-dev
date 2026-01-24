---
name: lsp-integration
description: This skill should be used when the user asks to "add LSP server", "configure language server", "set up LSP in plugin", "add code intelligence", "integrate language server protocol", "use pyright-lsp", "use typescript-lsp", "use rust-lsp", mentions LSP servers, or discusses extensionToLanguage mappings. Provides guidance for integrating Language Server Protocol servers into Claude Code plugins for enhanced code intelligence.
---

# LSP Integration for Claude Code Plugins

## Overview

Language Server Protocol (LSP) servers provide code intelligence features like go-to-definition, find references, and hover information. Claude Code plugins can bundle or configure LSP servers to enhance Claude's understanding of code.

**Key capabilities:**

- Enable go-to-definition for code navigation
- Find all references to symbols
- Get hover information and documentation
- Support language-specific features (completions, diagnostics)

## LSP Server Configuration

Plugins can provide LSP servers in the plugin manifest:

### Basic Configuration

```json
{
  "name": "my-plugin",
  "lspServers": {
    "python": {
      "command": "pyright-langserver",
      "args": ["--stdio"],
      "extensionToLanguage": {
        ".py": "python",
        ".pyi": "python"
      }
    }
  }
}
```

### Configuration Fields

**command** (required): The LSP server executable

**args** (optional): Command-line arguments for the server

**extensionToLanguage** (required): Maps file extensions to language IDs

```json
{
  "extensionToLanguage": {
    ".py": "python",
    ".pyi": "python",
    ".pyw": "python"
  }
}
```

**env** (optional): Environment variables for the server process

```json
{
  "env": {
    "PYTHONPATH": "${CLAUDE_PLUGIN_ROOT}/lib"
  }
}
```

## Pre-built LSP Plugins

Claude Code provides official LSP plugins for common languages:

### pyright-lsp

Python language server using Pyright:

```bash
# Install from marketplace
claude /install-plugin pyright-lsp
```

Features:

- Type checking and inference
- Go-to-definition
- Find references
- Hover documentation
- Completions

### typescript-lsp

TypeScript/JavaScript language server:

```bash
# Install from marketplace
claude /install-plugin typescript-lsp
```

Features:

- TypeScript and JavaScript support
- Type information on hover
- Go-to-definition
- Find references
- Rename symbol

### rust-lsp

Rust language server using rust-analyzer:

```bash
# Install from marketplace
claude /install-plugin rust-lsp
```

Features:

- Full rust-analyzer capabilities
- Trait resolution
- Macro expansion
- Go-to-definition and references

## Creating Custom LSP Integration

### Step 1: Choose or Build LSP Server

Options:

1. **Use existing LSP server** - Most languages have official or community servers
2. **Bundle with plugin** - Include server binary in plugin
3. **Require user installation** - Document server installation in README

### Step 2: Configure in plugin.json

```json
{
  "name": "go-lsp",
  "version": "1.0.0",
  "description": "Go language server integration",
  "lspServers": {
    "go": {
      "command": "gopls",
      "args": ["serve"],
      "extensionToLanguage": {
        ".go": "go",
        ".mod": "go.mod"
      }
    }
  }
}
```

### Step 3: Bundle Server (Optional)

For self-contained plugins, bundle the server:

```
my-lsp-plugin/
├── .claude-plugin/
│   └── plugin.json
└── servers/
    └── my-lsp-server
```

Use `${CLAUDE_PLUGIN_ROOT}` for the command path:

```json
{
  "lspServers": {
    "mylang": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-lsp-server",
      "args": ["--stdio"]
    }
  }
}
```

### Step 4: Document Requirements

In your plugin README:

- List required external dependencies
- Provide installation instructions
- Note supported language versions
- Describe available features

## Extension to Language Mapping

The `extensionToLanguage` field maps file extensions to LSP language identifiers:

### Common Mappings

```json
{
  "extensionToLanguage": {
    ".py": "python",
    ".js": "javascript",
    ".ts": "typescript",
    ".jsx": "javascriptreact",
    ".tsx": "typescriptreact",
    ".rs": "rust",
    ".go": "go",
    ".java": "java",
    ".rb": "ruby",
    ".php": "php",
    ".c": "c",
    ".cpp": "cpp",
    ".h": "c",
    ".hpp": "cpp",
    ".cs": "csharp"
  }
}
```

### Multiple Extensions

A single language can have multiple extensions:

```json
{
  "extensionToLanguage": {
    ".ts": "typescript",
    ".mts": "typescript",
    ".cts": "typescript",
    ".d.ts": "typescript"
  }
}
```

## LSP Server Lifecycle

### Startup

LSP servers start automatically when:

1. Claude Code session begins
2. Plugin with LSP server is enabled
3. User opens a file matching configured extensions

### Communication

- Uses stdio for client-server communication
- Follows LSP specification for messages
- Claude Code manages the connection

### Shutdown

Servers terminate when:

- Claude Code session ends
- Plugin is disabled
- Server crashes (auto-restart may occur)

## Best Practices

### Performance

1. **Lazy initialization** - Servers start when needed, not at session start
2. **Minimal configuration** - Only enable features you need
3. **Resource limits** - Consider memory/CPU impact of servers

### Compatibility

1. **Check LSP version** - Ensure server supports required protocol version
2. **Test cross-platform** - Verify on macOS, Linux, Windows
3. **Handle missing servers** - Gracefully degrade if server not installed

### Documentation

1. **List prerequisites** - External tools, versions required
2. **Provide setup guide** - Step-by-step installation
3. **Document features** - Which LSP capabilities are supported

## Troubleshooting

### Server Not Starting

**Check:**

- Command path is correct
- Server is installed and executable
- Required dependencies are available
- `${CLAUDE_PLUGIN_ROOT}` is used for bundled servers

### No Code Intelligence

**Check:**

- File extension matches `extensionToLanguage` mapping
- Language ID is correct for the server
- Server supports the requested feature

### Debug Mode

Enable debug logging:

```bash
claude --debug
```

Look for:

- LSP server startup messages
- Communication logs
- Error responses

## Quick Reference

### Minimal LSP Configuration

```json
{
  "lspServers": {
    "language": {
      "command": "server-command",
      "extensionToLanguage": {
        ".ext": "language-id"
      }
    }
  }
}
```

### Full LSP Configuration

```json
{
  "lspServers": {
    "language": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/lsp-server",
      "args": ["--stdio", "--log-level", "warn"],
      "extensionToLanguage": {
        ".ext1": "language",
        ".ext2": "language"
      },
      "env": {
        "CONFIG_PATH": "${CLAUDE_PLUGIN_ROOT}/config"
      }
    }
  }
}
```

### Best Practices Summary

**DO:**

- Use `${CLAUDE_PLUGIN_ROOT}` for bundled server paths
- Map all relevant file extensions
- Document external dependencies
- Test on multiple platforms
- Handle server unavailability gracefully

**DON'T:**

- Hardcode absolute paths
- Assume servers are pre-installed
- Bundle large binaries without consideration
- Ignore server startup errors

## Additional Resources

### Reference Files

For detailed information, consult:

- **`references/popular-lsp-servers.md`** - Curated list of LSP servers by language
- **`references/lsp-capabilities.md`** - LSP protocol capabilities reference

### External Resources

- **LSP Specification**: <https://microsoft.github.io/language-server-protocol/>
- **Claude Code Plugins Reference**: <https://docs.claude.com/en/docs/claude-code/plugins-reference>
- **Language Server List**: <https://langserver.org/>
