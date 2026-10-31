# Do not intercept your own commands

**Confidence:** Source.

## Problem

A `command.run` hook that rewrites or blocks commands also sees the commands that its own mod runs, and can loop.

## API calls

- `e.origin` on `command.run`: `{ kind: 'plugin', name }` for a command a plugin ran.
- `$.plugin.name` is the mod's own name.

## Code sketch

```tsx
on('command.run', async ($, e, next) => {
  if (e.origin?.kind === 'plugin' && e.origin.name === $.plugin.name) return next(e)
  …
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- None known beyond the check above.

## Sources

- manueldelgado/manueldelgado-mods exit-memory-update (Source): near L77. <https://github.com/manueldelgado/manueldelgado-mods/tree/main/exit-memory-update>
