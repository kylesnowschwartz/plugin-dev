# A copy button under each reply

**Confidence:** Live (a SimpleClaude spike), plus Source.

## Problem

Each assistant reply needs its own action button, for example "copy", drawn under Claude Code's own drawing of the reply.

## API calls

- `on('ui.render', { component: 'AssistantMessage' })`. `await next(e)` returns Claude Code's own drawing, which can go in a Box with your own elements.
- `Button` with a `key` that includes `e.requestId`, so buttons on different replies stay apart.

## Code sketch

```tsx
on('ui.render', { component: 'AssistantMessage' }, async ($, e, next) => {
  const { Box, Button } = $.ui.resolve(e)
  const text = replyText(e) // keep the text from draw time
  return (
    <Box flexDirection="column">
      {await next(e)}
      <Button key={`copy:${e.requestId}`} label="⧉ copy" onPress={() => $.ui.copy({ text, surface: e.surface })} />
    </Box>
  )
})
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- The press event carries only the element key and surface. The `onPress` function keeps the reply text from when the button was drawn.
- Keyboard focus does not reach it: a hotkey works only while the band or a pane has focus, and transcript rows cannot take focus. A button inside a reply is mouse-only. Give the keyboard a band button instead, for example "copy last" (digit `3` in an empty prompt box).
- Unverified: prior art says a press that lands during a redraw is dropped when it goes through an `onPress` closure, and a `ui.press` hook matched on the element key may handle it better.

## Sources

- SimpleClaude spike (Live).
- yash-gadodia/claude-mods copy-band (Source): in-reply buttons use keys `inline:<digest>:N` and its band buttons use `copy:N`. <https://github.com/yash-gadodia/claude-mods/blob/main/copy-band/hooks/register.tsx>
