# Styling the band

**Confidence:** Types.

## Problem

A band or pane needs spacing, borders, color, and hover feedback.

## API calls

- `Box` takes Ink's `padding*`, `margin*`, `gap`, `flexDirection`, `borderStyle`, and `backgroundColor`, plus a `hover` style while the mouse is over it.
- `Text` and `Button` take `color`, `backgroundColor`, `dimColor`, `bold`, `italic`, `underline`, and `strikethrough`.

## Code sketch

```tsx
<Box key="row" flexDirection="row" gap={1} paddingX={1} borderStyle="round" marginBottom={1} hover={{ backgroundColor: 'gray' }}>
  <Text bold color="cyan">sc-mods</Text>
  <Text dimColor>3 prompts</Text>
</Box>
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- A mod can add space toward the prompt with `marginBottom`. The prompt's border and the rows around it belong to Claude Code and cannot be moved or restyled.
- A `hover` style needs a keyed Box in the hook's own answer.
- A `borderStyle` that the terminal does not have (the styles are `single`, `double`, `round`, `bold`, `singleDouble`, `doubleSingle`, `classic`, `arrow`, `dashed`, `quote`) draws no border.

## Sources

- Types: `BoxProps` in `../vendor/types/claude-code.d.ts`; border styles in `../vendor/reference.md`.
