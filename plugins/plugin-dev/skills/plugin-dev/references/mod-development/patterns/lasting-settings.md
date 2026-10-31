# Settings that last across sessions

**Confidence:** Source.

## Problem

A mod keeps choices the person made (looks, pins, an intro already seen) after the session ends.

## API calls

- `$.store.get` and `$.store.set` keep values across sessions.
- `$.state` keeps values for the running session only, and survives a mod reload.
- `$.ui.log(text)` prints a one-time intro in the transcript.

## Code sketch

```tsx
on('session.start', async ($, e, next) => {
  if ((await $.store.get('introSeen')) !== 2) {
    $.ui.log('my-mod: press 1 to …')
    await $.store.set('introSeen', 2)
  }
  return next(e)
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- Keep a version number with a one-time flag, so a new intro shows once after an upgrade.
- `$.store.get(key)` resolves the value itself, or `undefined`. `$.store.set` takes JSON data only, and the whole store is at most 4 MiB of JSON text.

## Sources

- patheonsceo/claudinator (Source) stores looks and pins in `$.store`. <https://github.com/patheonsceo/claudinator>
- Akash001uts/claude-mods context-bar (Source) keeps the one-time intro flag. <https://github.com/Akash001uts/claude-mods/blob/main/plugins/context-bar/hooks/register.tsx>
- davidar/claude-idle-compact (Source) keeps its timer state in `$.state`. <https://github.com/davidar/claude-idle-compact/blob/master/hooks/register.ts>
