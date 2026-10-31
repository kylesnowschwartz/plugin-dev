# Gotchas

**Confidence:** Live unless marked.

## Problem

Small API rules that cost a turn each when missed.

## API calls and rules

- **A mod tool's result is a string or an array.** A `tool.call` answer `{ result: { … } }` for a `$.tool.register` tool is refused: `tool.call step resolved mcp__<plugin>__<name> with a result that does not match its output shape` (`invalid_union`: expected string, array, or undefined). Return `JSON.stringify(…)` or a short line.
- **The model reads `result`.** A `text` field beside it does not replace what the model reads.
- **Plugin tool names in a `tool.call` matcher are regexes.** `{ tool: 'mcp__my-mod__x' }` fails `tsc` (the matcher type lists only built-in tools); `{ tool: /^mcp__my-mod__x$/ }` type-checks.
- **Tool arguments are spread on `e`** in `tool.call`: read `e.paths`, not `e.input.paths`.
- **A registered tool is available from the next prompt**, not in the turn in which the mod loaded.
- **Mod edits reload when the turn ends**, not when the file is written. A fix and its retry need two turns.
- **`$.fs.read(path, { as: 'bytes' })` resolves `{ base64 }`.** Some examples show `bytes.toBase64()`; the `FsReadCall` type has `{ base64 }`.
- **A state contract exports types only.** A contract whose only export is `export {}` is refused.
- **Hot reload needs the person's yes.** Loading the built-in `plugin-authoring` skill starts the watch; the first file written asks the person once.

## Code sketch

```tsx
on('tool.call', { tool: /^mcp__my-mod__show$/ }, ($, e) => {
  const paths = (e as { paths?: unknown }).paths
  return { result: JSON.stringify({ paths }) }
}).catch(() => ({ deny: 'show failed' }))
```

## Minimum Claude Code version

2.1.316 is the oldest version these rules are known to hold on.

## Sources

- sc-mods `show_image` and its spike (Live): `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`.
- Types: `FsReadCall`, `ToolSpec`, `ToolCallResult` in `../vendor/types/claude-code.d.ts`.
