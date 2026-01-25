# LSP Protocol Capabilities

Overview of Language Server Protocol capabilities and what they enable for Claude Code.

## Core Capabilities

### Text Document Synchronization

How the client and server keep document content in sync.

| Capability               | Description                        |
| ------------------------ | ---------------------------------- |
| `textDocument/didOpen`   | Notify server when document opens  |
| `textDocument/didChange` | Send document changes to server    |
| `textDocument/didSave`   | Notify server on save              |
| `textDocument/didClose`  | Notify server when document closes |

### Diagnostics

Server-pushed notifications about code issues.

| Capability                        | Description                     |
| --------------------------------- | ------------------------------- |
| `textDocument/publishDiagnostics` | Receive errors, warnings, hints |

**Diagnostic severities:**

- Error (1) - Compilation errors, type mismatches
- Warning (2) - Unused variables, deprecated APIs
- Information (3) - Style suggestions
- Hint (4) - Minor suggestions

## Navigation Capabilities

### Go to Definition

Jump to where a symbol is defined.

| Capability                    | Description                                    |
| ----------------------------- | ---------------------------------------------- |
| `textDocument/definition`     | Find definition location                       |
| `textDocument/typeDefinition` | Find type definition                           |
| `textDocument/implementation` | Find interface implementations                 |
| `textDocument/declaration`    | Find declaration (if separate from definition) |

### Find References

Locate all usages of a symbol.

| Capability                    | Description                         |
| ----------------------------- | ----------------------------------- |
| `textDocument/references`     | Find all references to a symbol     |
| `callHierarchy/incomingCalls` | Find callers of a function          |
| `callHierarchy/outgoingCalls` | Find functions called by a function |

### Symbol Information

Get information about code symbols.

| Capability                    | Description                     |
| ----------------------------- | ------------------------------- |
| `textDocument/hover`          | Get documentation and type info |
| `textDocument/documentSymbol` | List symbols in a document      |
| `workspace/symbol`            | Search symbols across workspace |
| `textDocument/signatureHelp`  | Get function signature info     |

## Code Intelligence Capabilities

### Completions

| Capability                | Description                       |
| ------------------------- | --------------------------------- |
| `textDocument/completion` | Get completion suggestions        |
| `completionItem/resolve`  | Get additional completion details |

### Code Actions

| Capability                | Description                          |
| ------------------------- | ------------------------------------ |
| `textDocument/codeAction` | Get available fixes and refactorings |
| `codeAction/resolve`      | Get full edit for a code action      |

### Refactoring

| Capability                     | Description                  |
| ------------------------------ | ---------------------------- |
| `textDocument/rename`          | Rename a symbol across files |
| `textDocument/prepareRename`   | Validate rename is possible  |
| `textDocument/formatting`      | Format entire document       |
| `textDocument/rangeFormatting` | Format selected range        |

## Workspace Capabilities

| Capability                         | Description                           |
| ---------------------------------- | ------------------------------------- |
| `workspace/didChangeConfiguration` | Notify server of settings changes     |
| `workspace/didChangeWatchedFiles`  | Notify server of file system changes  |
| `workspace/applyEdit`              | Server requests client to apply edits |

## Capability Support by Server

Not all servers support all capabilities. Common support levels:

### Full Support (Most Servers)

- Diagnostics
- Go to definition
- Find references
- Hover
- Document symbols
- Completions

### Partial Support (Varies)

- Rename
- Code actions
- Call hierarchy
- Type hierarchy
- Formatting

### Limited Support (Few Servers)

- Semantic tokens
- Inlay hints
- Linked editing ranges

## Checking Server Capabilities

Servers declare supported capabilities during initialization. Claude Code automatically uses available features.

To see what a server supports, check the server's documentation or the initialize response:

```json
{
  "capabilities": {
    "textDocumentSync": 2,
    "completionProvider": { "triggerCharacters": ["."] },
    "hoverProvider": true,
    "definitionProvider": true,
    "referencesProvider": true,
    "documentSymbolProvider": true,
    "renameProvider": true
  }
}
```

## Claude Code Usage

Claude Code primarily uses these capabilities:

1. **Diagnostics** - Automatic error detection after edits
2. **Definition** - Understanding code structure
3. **References** - Finding all usages for safe refactoring
4. **Hover** - Getting type information and documentation
5. **Document symbols** - Navigating file structure

These provide more precise code understanding than text-based search alone.
