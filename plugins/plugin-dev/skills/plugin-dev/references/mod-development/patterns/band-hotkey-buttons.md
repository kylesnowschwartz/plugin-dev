# Numbered hotkey buttons in the band

**Confidence:** Live (a SimpleClaude spike), plus Source.

## Problem

The band above the prompt has actions that the person wants to press from the keyboard.

## API calls

- `on('ui.render', { component: 'AbovePrompt' })` returning a tree of `Button`s, each with a `hotkey` (see `../vendor/examples/band.tsx`).
- `$.clock.every(ms, fn)` for a countdown or a live label.

## Code sketch

```tsx
on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
  const { Box, Button } = $.ui.resolve(e)
  return (
    <Box>
      <Button key="exit" label="Exit now (1)" hotkey="1" onPress={exitNow} />
      <Button key="stay" label="Stay (2)" hotkey="2" onPress={stay} />
    </Box>
  )
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- A bare digit typed into an empty prompt box presses the matching band button. In a non-empty prompt box the digit is typed. Only buttons wholly inside the band's visible rows count.
- `ctrl+x tab` focuses the band. Tab moves between buttons, Enter presses, and Esc returns to the prompt.
- With vim mode on, Esc leaves the prompt box in normal mode. Type `i` first.

## Sources

- SimpleClaude spike (Live).
- manueldelgado/manueldelgado-mods exit-memory-update (Source): <https://github.com/manueldelgado/manueldelgado-mods/tree/main/exit-memory-update>. It has "Exit now (1)" and "Stay (2)" buttons and a `$.clock.every(1000)` countdown.
