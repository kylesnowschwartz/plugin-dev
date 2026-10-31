# UI state for each row

**Confidence:** Live (a Hide/Show button in a tool's result row, in tmux).

## Problem

Each drawn row needs its own small state: hidden or shown, a chosen size, "show more". The state must redraw the row when it changes, and it must survive a mod reload.

## API calls

- `atom(ref, initial)`, `read($, atom)` while drawing, and `update($, atom, fn)` from a handler, all from `import { atom, read, update } from 'claude-code'`.
- A `$.state` contract in `types/index.d.ts`, named in `plugin.json` as `"types"`. `claude plugin validate` holds every `$.state` key the module names to it.
- `Button` with `onPress`; the row's `e.props.tool_use_id` (or `e.requestId`) as the state key.

## Code sketch

```tsx
// types/index.d.ts
declare module 'claude-code' {
  interface PluginState {
    'my-mod': { hidden: string[] }
  }
}
export type HiddenIds = string[]
```

```tsx
const hidden = atom({ plugin: 'my-mod', key: 'hidden' } as const, [])

on('ui.render', { component: 'ToolResult' }, async ($, e, next) => {
  if (e.props.tool !== TOOL) return next(e)
  const id = e.props.tool_use_id
  const isHidden = (await read($, hidden)).includes(id)
  const { Box, Text, Button } = $.ui.resolve(e)
  const toggle = (
    <Button
      key="toggle"
      label={isHidden ? 'Show' : 'Hide'}
      onPress={() => update($, hidden, ids => (ids.includes(id) ? ids.filter(x => x !== id) : [...ids, id]))}
    />
  )
  return isHidden ? <Box><Text dimColor>hidden </Text>{toggle}</Box> : <Box flexDirection="column">…{toggle}</Box>
})
```

## Minimum Claude Code version

2.1.316 is the oldest version this pattern is known to work on.

## Gotchas

- A render hook never writes state: `$.state.set` while drawing is denied. Write from `onPress` or another event.
- `update` reads, applies and writes with a version check, so two presses before a redraw both land. Do not write a value that the closure captured at draw time.
- A state contract file exports types and nothing else: `export {}` alone is refused by `claude plugin validate` ("a contract exports types and nothing else"). Export a type.
- `$.state` lasts for the session and survives a reload. For state across sessions, write `$.store` too.
- A button in a transcript row takes mouse clicks; keyboard focus does not reach it (see `links-and-buttons.md`).

## Sources

- sc-mods `show_image` (Live): `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`.
- Built-in examples (Types): `../vendor/examples/pane-state.d.ts`, `../vendor/examples/band.tsx`.
