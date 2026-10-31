# A pane that lists prompts

**Confidence:** Source, plus Types.

## Problem

The person wants a table of contents for the session: a pane that lists earlier prompts and jumps to one.

## API calls

- `$.ui.open({ id, title })` and a `ui.render` hook on `{ component: 'Pane', requestId: id }` (see `../vendor/examples/pane.tsx`).
- `$.session.messages()` returns `{ role, text, toolUses }` for the newest 4,096 entries, with no message IDs (Types).
- Message IDs for jumping come only from the `UserMessage` render (see `jump-to-prompt.md`).

## Code sketch

```tsx
// a pure view function keeps the pane testable
const view = (els, style, data, actions) => (
  <els.Box flexDirection="column">
    {data.prompts.map((p, i) => (
      <els.Button key={`p${i}`} label={p.title} onPress={() => actions.jump(p.requestId)} />
    ))}
  </els.Box>
)
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- `$.session.messages()` has no IDs, so a list built from it cannot jump without the `UserMessage` IDs.
- Unverified: how claudinator writes each chapter headline (`src/looks/*`).

## Sources

- patheonsceo/claudinator (Source): `src/panes/navigator.ts`, a pane drawn by a pure view function `(els, style, data, actions)` with tabs, hotkey Buttons, and a heavy underline rule. Its Chapters, Ledger, and Pins panes are under `src/panes/`. <https://github.com/patheonsceo/claudinator>
