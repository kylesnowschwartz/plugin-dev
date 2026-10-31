# Share the band with other mods

**Confidence:** Source, plus Types.

## Problem

The band above the prompt is one strip shared by every mod and by Claude Code's surveys. A mod must not take it when another use needs it.

## API calls

- `e.props.hasSurvey` on `AbovePrompt`: return `next(e)` while it is true.
- `PromptHint` render: its `tail` prop adds dim text at the end of the line under the prompt.
- `e.props.bodyColumns` (the width to lay out in) and `maxRows` (how tall the band can be).

## Code sketch

```tsx
on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
  if (e.props.hasSurvey || (await placement($)) === 'hint') return next(e)
  if (e.surface !== 'terminal') return next(e)
  …
})

on('ui.render', { component: 'PromptHint' }, async ($, e, next) =>
  (await placement($)) === 'hint' ? next({ ...e, props: { ...e.props, tail: summary() } }) : next(e))
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- The order of mods in the band cannot be set.
- Claude Code draws a `[-]` collapse marker in the band's last 5 columns, and an `n more` row when the content is too tall.
- In fullscreen, the band and the prompt together get at most half the terminal height.

## Sources

- Akash001uts/claude-mods context-bar (Source): <https://github.com/Akash001uts/claude-mods/blob/main/plugins/context-bar/hooks/register.tsx>. It draws in `PromptHint` when the person chose the line under the prompt, and branches on `e.surface`.
- Types: `AbovePrompt` and `PromptHint` in `../vendor/types/claude-code.d.ts`.
