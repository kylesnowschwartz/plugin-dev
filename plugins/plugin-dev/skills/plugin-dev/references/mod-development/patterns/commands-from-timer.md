# Run commands and compaction from a timer

**Confidence:** Live (idle-micro-compact runs), plus Source.

## Problem

A mod runs a slash command or compacts the session in answer to an event. Called from inside a hook, the call is refused or hangs.

## API calls

- `$.clock.after(0, fn)` schedules the call after the hook returns.
- `$.command.run(…)` runs a slash command; `$.session.compact(…)` compacts.

## Code sketch

```tsx
on('command.run', { command: 'tidy' }, async ($, e) => {
  $.clock.after(0, () => $.command.run({ command: 'compact', args: 'keep the plan' }))
  return { text: 'Compacting…' }
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- `$.command.run` and `$.session.compact` called from inside a `command.run` hook are refused or hang.
- Called from a timer, `$.session.compact` skips the calling plugin's own `session.compact` hook. The debug log says `session.compact skipped: re-entry (the plugin's own code raised it; origin <plugin>)`. To reach your own hook, run `/compact <instructions>` with `$.command.run` and match `trigger: 'manual'`.
- `$.command.run` takes the command name without its slash and `args` as the person would type them.

## Sources

- lperezmo/session-relaunch (Source): near L72 and L168. <https://github.com/lperezmo/session-relaunch/tree/main/plugins/session-relaunch>
- idle-micro-compact (Live): Kyle's local project `idle-micro-compact`, `hooks/register.ts`.
