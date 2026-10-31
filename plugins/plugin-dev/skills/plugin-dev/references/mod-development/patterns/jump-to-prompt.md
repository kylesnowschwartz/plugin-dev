# Jump the main view to a prompt

**Confidence:** Live (a SimpleClaude spike), plus Source.

## Problem

The person wants to move the conversation view to an earlier prompt from a button, not by scrolling.

## API calls

- `$.ui.scroll({ to: { requestId }, block: 'start' })` resolves `{}` when the view moved, or `{ deny }` with a reason.
- Prompt IDs come from `on('ui.render', { component: 'UserMessage' })`: take `e.requestId` where `e.props.origin.kind === 'composer'`.

## Code sketch

```tsx
const promptIds: string[] = []

on('ui.render', { component: 'UserMessage' }, async ($, e, next) => {
  if (e.props.origin.kind === 'composer' && e.requestId !== 'placeholder' && !promptIds.includes(e.requestId)) {
    promptIds.push(e.requestId)
  }
  return next(e)
})

// from a Button's onPress:
const jumpTo = ($, requestId: string) => $.ui.scroll({ to: { requestId }, block: 'start' }).catch(() => undefined)
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- A prompt still being sent renders with `requestId === 'placeholder'`. Scrolling to it is denied with "nothing drawn under that requestId".
- A transcript row moves only while the call answers the person's own input. A Button's `onPress` qualifies; a timer does not.
- Fullscreen layout only: the classic layout refuses the call, or the row is not mounted.
- The sticky prompt header can cover the row the view jumped to.
- Claude Code's transcript viewer (`Ctrl+O`) already jumps between prompts with `{` and `}`, inside the viewer only.

## Sources

- SimpleClaude spike (Live).
- ruanss4/prompt-jump (Source): <https://github.com/ruanss4/prompt-jump/blob/main/hooks/register.tsx>, `jumpTo` near L165.
- patheonsceo/claudinator (Source): <https://github.com/patheonsceo/claudinator/blob/main/hooks/register.ts> L430-436, which also scrolls to tool rows with `block: 'center'`.
- sc-mods prompt-jump: `plugins/sc-mods/hooks/prompt-jump.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>.
