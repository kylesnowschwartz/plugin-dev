# Poll only when something changed

**Confidence:** Source.

## Problem

A pane shows data from a file that another process writes. Redrawing on every timer tick wastes work.

## API calls

- `$.fs.stat(path)` returns `mtimeMs`.
- `$.clock.every(ms, fn)` for the check.
- `e.props.bodyColumns` on a `Pane` render: the width of the box it draws into.

## Code sketch

```tsx
let seen = 0
$.clock.every(30_000, async () => {
  const { mtimeMs } = await $.fs.stat(path)
  if (mtimeMs !== seen) {
    seen = mtimeMs
    $.ui.invalidate('ui.render')
  }
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- Check at least every 30 seconds.
- A docked pane reopens at the new width when `e.props.bodyColumns` changes.

## Sources

- YuvalSarel1/claude-plugins fleet (Source): `register.tsx` near L266-270 and L353. <https://github.com/YuvalSarel1/claude-plugins/tree/main/plugins/fleet>
