# LSP Configuration Patterns

Copy-paste ready `.lsp.json` configurations for common scenarios.

## Minimal Configuration

The simplest possible LSP configuration:

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python"
    }
  }
}
```

## Multiple Languages

Configure multiple language servers in one file:

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    }
  },
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact",
      ".js": "javascript",
      ".jsx": "javascriptreact"
    }
  }
}
```

## With Environment Variables

Pass environment variables to the server:

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python"
    },
    "env": {
      "PYTHONPATH": "${CLAUDE_PLUGIN_ROOT}/lib",
      "VIRTUAL_ENV": "${CLAUDE_PLUGIN_ROOT}/.venv"
    }
  }
}
```

## With Initialization Options

Pass options during server initialization:

```json
{
  "rust": {
    "command": "rust-analyzer",
    "extensionToLanguage": {
      ".rs": "rust"
    },
    "initializationOptions": {
      "cargo": {
        "buildScripts": {
          "enable": true
        }
      },
      "procMacro": {
        "enable": true
      }
    }
  }
}
```

## With Runtime Settings

Pass settings after initialization:

```json
{
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript"
    },
    "settings": {
      "typescript": {
        "inlayHints": {
          "parameterNames": {
            "enabled": "all"
          }
        }
      }
    }
  }
}
```

## With Timeouts and Restart Policy

Configure server lifecycle:

```json
{
  "java": {
    "command": "jdtls",
    "extensionToLanguage": {
      ".java": "java"
    },
    "startupTimeout": 60000,
    "shutdownTimeout": 5000,
    "restartOnCrash": true,
    "maxRestarts": 3
  }
}
```

## Bundled Server

Reference a server bundled with the plugin:

```json
{
  "custom": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-lsp-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".custom": "custom-lang"
    },
    "env": {
      "CONFIG_PATH": "${CLAUDE_PLUGIN_ROOT}/config/server.json"
    }
  }
}
```

## Socket Transport

Use socket instead of stdio:

```json
{
  "php": {
    "command": "intelephense",
    "args": ["--socket=6000"],
    "transport": "socket",
    "extensionToLanguage": {
      ".php": "php"
    }
  }
}
```

## Full Configuration Example

All options together:

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve", "-rpc.trace"],
    "transport": "stdio",
    "extensionToLanguage": {
      ".go": "go",
      ".mod": "go.mod",
      ".sum": "go.sum"
    },
    "env": {
      "GOFLAGS": "-mod=vendor"
    },
    "initializationOptions": {
      "usePlaceholders": true,
      "completeUnimported": true
    },
    "settings": {
      "gopls": {
        "staticcheck": true,
        "analyses": {
          "unusedparams": true
        }
      }
    },
    "workspaceFolder": "${workspaceFolder}",
    "startupTimeout": 30000,
    "shutdownTimeout": 5000,
    "restartOnCrash": true,
    "maxRestarts": 5
  }
}
```

## Inline in plugin.json

Instead of a separate `.lsp.json`, configure inline:

```json
{
  "name": "my-lsp-plugin",
  "version": "1.0.0",
  "description": "Language server integration",
  "lspServers": {
    "python": {
      "command": "pyright-langserver",
      "args": ["--stdio"],
      "extensionToLanguage": {
        ".py": "python"
      }
    }
  }
}
```

Or reference an external file:

```json
{
  "name": "my-lsp-plugin",
  "version": "1.0.0",
  "description": "Language server integration",
  "lspServers": "./.lsp.json"
}
```
