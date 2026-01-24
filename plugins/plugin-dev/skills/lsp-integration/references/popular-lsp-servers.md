# Popular LSP Servers by Language

Curated list of recommended Language Server Protocol servers for common programming languages.

## Official/Recommended Servers

### Python

#### Pyright (Recommended)

- Fast, full-featured type checker
- Command: `pyright-langserver --stdio`
- Install: `npm install -g pyright`

```json
{
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

#### Pylsp (Alternative)

- Plugin-based, highly extensible
- Command: `pylsp`
- Install: `pip install python-lsp-server`

### TypeScript/JavaScript

#### TypeScript Language Server (Recommended)

- Official TypeScript server
- Command: `typescript-language-server --stdio`
- Install: `npm install -g typescript-language-server typescript`

```json
{
  "lspServers": {
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
}
```

### Rust

#### rust-analyzer (Recommended)

- Official Rust language server
- Command: `rust-analyzer`
- Install: `rustup component add rust-analyzer`

```json
{
  "lspServers": {
    "rust": {
      "command": "rust-analyzer",
      "extensionToLanguage": {
        ".rs": "rust"
      }
    }
  }
}
```

### Go

#### gopls (Official)

- Official Go language server
- Command: `gopls serve`
- Install: `go install golang.org/x/tools/gopls@latest`

```json
{
  "lspServers": {
    "go": {
      "command": "gopls",
      "args": ["serve"],
      "extensionToLanguage": {
        ".go": "go"
      }
    }
  }
}
```

### Java

#### Eclipse JDT Language Server

- Full-featured Java server
- Command: Varies by installation
- Install: Download from Eclipse

#### jdtls (Wrapper)

- Simplified jdtls wrapper
- Install: Package managers or manual

### C/C++

#### clangd (Recommended)

- LLVM-based, fast
- Command: `clangd`
- Install: Part of LLVM/Clang

```json
{
  "lspServers": {
    "cpp": {
      "command": "clangd",
      "extensionToLanguage": {
        ".c": "c",
        ".cpp": "cpp",
        ".cc": "cpp",
        ".h": "c",
        ".hpp": "cpp"
      }
    }
  }
}
```

### C\#

#### OmniSharp

- .NET/C# language server
- Command: `OmniSharp --languageserver`
- Install: `dotnet tool install -g OmniSharp`

### Ruby

#### Solargraph

- Ruby language server
- Command: `solargraph stdio`
- Install: `gem install solargraph`

```json
{
  "lspServers": {
    "ruby": {
      "command": "solargraph",
      "args": ["stdio"],
      "extensionToLanguage": {
        ".rb": "ruby",
        ".rake": "ruby"
      }
    }
  }
}
```

### PHP

#### Intelephense

- Fast PHP server
- Command: `intelephense --stdio`
- Install: `npm install -g intelephense`

#### Phpactor

- Vim-focused, extensible
- Command: `phpactor language-server`
- Install: Via Composer

## Web Technologies

### HTML/CSS

#### vscode-html-languageserver

- HTML language features
- Command: `html-languageserver --stdio`
- Install: `npm install -g vscode-langservers-extracted`

#### vscode-css-languageserver

- CSS/SCSS/Less support
- Command: `css-languageserver --stdio`
- Install: `npm install -g vscode-langservers-extracted`

### JSON

#### vscode-json-languageserver

- JSON with schema support
- Command: `json-languageserver --stdio`
- Install: `npm install -g vscode-langservers-extracted`

### YAML

#### yaml-language-server

- YAML with schema support
- Command: `yaml-language-server --stdio`
- Install: `npm install -g yaml-language-server`

## Other Languages

### Lua

#### lua-language-server

- Full Lua support
- Install: GitHub releases or package managers

### Kotlin

#### kotlin-language-server

- Kotlin support
- Install: GitHub releases

### Swift

#### sourcekit-lsp

- Official Swift server
- Part of Swift toolchain

### Elixir

#### elixir-ls

- Elixir/Phoenix support
- Install: GitHub releases

### Haskell

#### haskell-language-server

- Full Haskell support
- Install: `ghcup install hls`

## Installation Verification

Test if a server is working:

```bash
# Check if command exists
which <server-command>

# Check version
<server-command> --version

# Test stdio mode (should accept LSP messages)
echo '{"jsonrpc":"2.0","id":1,"method":"initialize"}' | <server-command>
```
