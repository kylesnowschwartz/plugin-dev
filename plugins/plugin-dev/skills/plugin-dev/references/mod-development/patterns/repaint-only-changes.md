# Repaint only what changes

**Confidence:** Source, plus Types.

## Problem

A live element (a spinner, a working bar, a frame of video) changes many times a second. A full redraw each time is slow and is throttled.

## API calls

- `$.ui.blit({ requestId, key, cells })` repaints a mounted `Raster`; `$.ui.blit({ requestId, key, source })` swaps a keyed `Image`. No redraw.
- `Raster` from `$.ui.resolve(e)`, terminal only: a grid of colored cells, for example a 1x1 animated spinner.
- `$.ui.invalidate('ui.render')` asks for a full redraw.

## Code sketch

```tsx
$.clock.every(100, () => $.ui.blit({ requestId, key: 'bar', cells: nextFrame() }))
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- `$.ui.invalidate('ui.render')` is throttled to about 10 per second, or 30 per second for the visible pane, the expanded band, and the hint line.
- Blits between frames fold into one: up to 120 a second are taken, about sixty are shown. A resize is a redraw.
- A blit is denied when nothing of the plugin is mounted under that `requestId`, or the size is not the mounted one.

## Sources

- patheonsceo/claudinator (Source): `src/engine/raster.ts` and `hooks/register.ts` near L192. <https://github.com/patheonsceo/claudinator>
- YuvalSarel1/claude-plugins fleet (Source): <https://github.com/YuvalSarel1/claude-plugins/tree/main/plugins/fleet>
- Types: `$.ui.blit` and `RasterProps` in `../vendor/types/claude-code.d.ts`.
