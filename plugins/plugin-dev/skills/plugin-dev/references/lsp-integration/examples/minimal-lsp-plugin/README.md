# Go LSP Plugin

Provides Go language server integration for Claude Code.

## Prerequisites

Install gopls (the Go language server):

```bash
go install golang.org/x/tools/gopls@latest
```

Ensure `gopls` is in your PATH:

```bash
which gopls
```

## Installation

```bash
claude /install-plugin /path/to/go-lsp
```

## Features

Once installed, Claude gains:

- **Automatic diagnostics** - Type errors and issues reported after edits
- **Go to definition** - Jump to where functions and types are defined
- **Find references** - Locate all usages of a symbol
- **Hover information** - See type info and documentation

## Troubleshooting

If you see "Executable not found in $PATH":

1. Verify gopls is installed: `which gopls`
2. Add Go bin to PATH: `export PATH=$PATH:$(go env GOPATH)/bin`
3. Restart Claude Code
