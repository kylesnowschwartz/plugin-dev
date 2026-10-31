# Copy to the system clipboard

**Confidence:** Live (a SimpleClaude spike), plus Source.

## Problem

A mod must put text on the person's clipboard, for example a reply's markdown.

## API calls

- `$.ui.copy({ text, surface })` returns `{ isCopied: true }` or `{ isCopied: false, reason: 'no-surface' | 'no-clipboard' | 'refused' }`. It writes the way `/copy` does: through pbcopy, wl-copy, xclip, or tmux's buffer, or with the OSC 52 terminal escape. It raises a `ui.copy` event that other hooks can deny or rewrite.
- Fallback: `$.process.run(['pbcopy'], { stdin: text, timeoutMs: 5000 })`.

## Code sketch

```tsx
const copied = await $.ui.copy({ text, surface: e.surface })
if (!copied.isCopied) {
  await $.process.run(['pbcopy'], { stdin: text, timeoutMs: 5000 })
}
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- `$.ui.copy` can report `isCopied: true` even when an OSC 52 write was dropped.

## Sources

- SimpleClaude spike (Live): `{"isCopied":true}`, and `pbpaste` matched the reply.
- yash-gadodia/claude-mods copy-band (Source): <https://github.com/yash-gadodia/claude-mods/blob/main/copy-band/hooks/register.tsx>, `copy` near L91. It uses the `pbcopy` fallback, keeps a stash of copied blocks, and has a `/stash` command.
- sc-mods reply-copy: `plugins/sc-mods/hooks/reply-copy.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>.
