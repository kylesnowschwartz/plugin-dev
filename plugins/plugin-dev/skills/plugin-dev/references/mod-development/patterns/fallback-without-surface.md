# Fall back where nothing can be drawn

**Confidence:** Source.

## Problem

A mod's pane or element cannot draw in some hosts: the VS Code chat panel, `claude -p`, the Agent SDK, cloud sessions, mobile.

## API calls

- `$.ui.open(…)` resolves `{ isPlaced }`: whether a surface draws the pane now.
- `$.ui.focus({ requestId, key })` hands focus to a mounted Button.
- `$.clock.after(0, fn)` keeps async work alive past the render.
- `e.surface` (`terminal`, `desktop`, `vscode`, `mobile`) picks the element table.

## Code sketch

```tsx
const opened = await $.ui.open({ id: 'board', title: 'Board' })
if (!opened.isPlaced) {
  return { text: summaryAsText() } // e.g. from a command.run hook
}
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- `mobile` has no `Input`, `Select` or `Client`; `vscode` has no `Client`; only `terminal` has `Raster` and `Image`, and it has no `Svg`. Leave out elements the surface lacks, or the tree is refused.

## Sources

- superfly/sprites-claude-plugin (Source): `register.tsx`. <https://github.com/superfly/sprites-claude-plugin>
- Types: `Elements` in `../vendor/types/claude-code.d.ts`.
