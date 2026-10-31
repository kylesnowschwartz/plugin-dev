# A picture in the terminal

**Confidence:** Live (Ghostty 1.4.1 inside tmux 3.8), plus Types.

## Problem

A mod must show a real picture (a screenshot, a chart, a design) in the conversation, a band, or a pane, also when the person runs Claude Code inside tmux.

## API calls

- `Image` from `$.ui.resolve(e)`, on the `terminal` surface only. Props: `source`, `columns` (1 to 255), `rows` (1 to 255), `alt` (required), optional `key`.
- `source` is one of `{ png }` (base64 of a whole PNG), `{ rgba, width, height }`, `{ file, format }`, or `{ shm, format, width, height }`.
- `$.fs.read(path, { as: 'bytes' })` resolves `{ base64 }`, which is the `png` value.
- `$.ui.blit({ requestId, key, source })` swaps a keyed Image's picture without a redraw. A `{ deny }` with `fix: 'tmux-passthrough'` means tmux holds the picture back.

## Code sketch

```tsx
const { base64 } = await $.fs.read('/abs/path/chart.png', { as: 'bytes' })
const { Box, Image } = $.ui.resolve(e)

// Keep the aspect ratio: a cell is about twice as tall as it is wide.
const fit = (w: number, h: number, maxCols: number, maxRows: number) => {
  let columns = maxCols
  let rows = Math.max(1, Math.round((columns * h) / w / 2))
  if (rows > maxRows) {
    rows = maxRows
    columns = Math.max(1, Math.round((rows * 2 * w) / h))
  }
  return { columns, rows }
}

return <Image source={{ png: base64 }} {...fit(width, height, 100, 22)} alt="the p95 chart" />
```

Width and height come from the PNG header: bytes 16 to 23 of the file, two big-endian 32-bit numbers.

## Minimum Claude Code version

2.1.316 for pictures inside tmux. Older versions draw the Image box empty inside tmux, because they send the picture without tmux's passthrough wrapper (<https://github.com/anthropics/claude-code/issues/100146>).

## Gotchas

- **Inside tmux, only byte sources draw** (`png`, `rgba`). A `{ file }` or `{ shm }` source draws its `alt` there.
- **tmux needs two options:** `set -g allow-passthrough on` and `set -g focus-events on`.
- **The protocol:** kitty graphics with Unicode placeholder cells (U+10EEEE) in kitty and Ghostty. tmux keeps the placeholder cells as text, so the picture scrolls with the conversation. iTerm2 3.5 and later draws byte sources under the fullscreen layout only.
- **2 MiB limit** on decoded bytes. Shrink large pictures before drawing, for example with macOS `sips -Z <px>`, and convert other formats with `sips -s format png in --out out`. A mod has no Node; run these with `$.process.run`.
- The picture fills the box: a box with the wrong aspect ratio stretches it.
- Ghostty does not draw sixel, and tmux handles no other image protocol natively, so a sixel path does not help Ghostty users.
- Unverified: whether a picture stays after a switch to another tmux window and back.

## Sources

- sc-mods `show_image` (Live): `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`.
- Types: `ImageProps`, `ImageSource`, and `$.ui.blit` in `../vendor/types/claude-code.d.ts`.
- nicolopignatelli/claude-code-inline-images (Source): <https://github.com/nicolopignatelli/claude-code-inline-images> decodes, crops and shrinks PNGs in plain JavaScript (`hooks/png.ts`) and sizes small, medium and large boxes.
- Ghostty 1.4.0 release notes: <https://ghostty.org/docs/install/release-notes/1-4-0> (full kitty graphics protocol).
