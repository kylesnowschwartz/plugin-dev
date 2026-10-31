# Links and buttons in a row

**Confidence:** Live (Ghostty 1.4.1 inside tmux 3.8, main-screen layout).

## Problem

A drawn row needs actions: open a file, hide the row, change a size.

## API calls

- `Link` from `$.ui.resolve(e)`: `href` and optional `label`. The terminal draws an OSC 8 hyperlink. An address outside `https:`, `http:` or `file:` draws as text.
- `Button`: `key`, `label`, `onPress`, optional `hotkey`. A click, the hotkey, or Enter under the focus raises `ui.press`, which runs `onPress`.
- `$.process.run(['open', path])` for an "Open" action that does not depend on hyperlinks (macOS).

## Code sketch

```tsx
const { Box, Link, Button } = $.ui.resolve(e)
return (
  <Box flexDirection="column">
    <Link href={`file://${encodeURI(path)}`} label={`open ${path.split('/').pop()}`} />
    <Button key="open" label="Open" onPress={() => $.process.run(['open', path])} />
  </Box>
)
```

## Minimum Claude Code version

2.1.316 is the oldest version this pattern is known to work on.

## Gotchas

- **Links through tmux** need tmux's `hyperlinks` terminal feature for the outer terminal, for example `set -as terminal-features 'xterm-ghostty:hyperlinks'`. Check with `tmux display -p '#{client_termfeatures}'`. Cmd-click opens a `file://` link in Ghostty.
- **Buttons in a transcript row take mouse clicks**, also in tmux's main-screen layout. Tab does not move the focus to them. Hotkeys work only while the band or a pane has focus (see `band-hotkey-buttons.md`), so a row button is mouse-only.
- `$.process.run(argv, init)` takes `cwd`, `env`, `stdin`, and `timeoutMs` in `init`, and resolves `exitCode` and `stdout`. Pass a `timeoutMs` so a stuck command cannot hang the press.

## Sources

- sc-mods `show_image` (Live): `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`.
- samuelpatro/claude-code-inline-images (Source): <https://github.com/samuelpatro/claude-code-inline-images> has an "Open" button on each picture.
- Types: `LinkProps` and `ButtonProps` in `../vendor/types/claude-code.d.ts`.
