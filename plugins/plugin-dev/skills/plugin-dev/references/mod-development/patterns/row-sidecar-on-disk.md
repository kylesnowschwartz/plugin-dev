# Row data on disk, by tool call ID

**Confidence:** Source (read in a published mod; the sc-mods version is under test).

## Problem

A row drawn by a `ToolResult` hook needs data that the model must not read: picture bytes, a full report, layout facts. `result` reaches the model, so the data cannot go there. Module variables are lost on a reload, and a resumed session starts with none.

## API calls

- `e.tool_use_id` in the `tool.call` hook names the call; the row's `e.props.tool_use_id` is the same value.
- `$.fs.write(path, text)` writes the sidecar; `$.fs.read(path)` reads it while drawing. `$.fs.read(path, { as: 'bytes' })` resolves `{ base64 }`.
- `$.env.get('XDG_CACHE_HOME')`, `$.env.get('HOME')`, `$.env.get('TMPDIR')` locate the folder.
- `$.process.run(argv, { timeoutMs })` for pruning old files.

## Code sketch

```tsx
const dirOf = async ($) =>
  `${(await $.env.get('XDG_CACHE_HOME')) ?? `${await $.env.get('HOME')}/.cache`}/my-mod/rows`

on('tool.call', { tool: /^mcp__my-mod__show$/ }, async ($, e) => {
  const dir = await dirOf($)
  await $.fs.write(`${dir}/${e.tool_use_id}.json`, JSON.stringify({ caption: e.caption }))
  return { result: 'Shown inline.' }
})

on('ui.render', { component: 'ToolResult' }, async ($, e, next) => {
  if (e.props.tool !== TOOL) return next(e)
  const shown = await $.fs
    .read(`${await dirOf($)}/${e.props.tool_use_id}.json`)
    .then(JSON.parse)
    .catch(() => undefined)
  if (!shown) return next(e) // sidecar gone: draw the plain result
  …
})
```

## Minimum Claude Code version

2.1.316 is the oldest version this pattern is known to work on.

## Gotchas

- Choose the folder for how long rows must keep drawing. `$TMPDIR` on macOS is cleared on restart and after about three days without use, and an old resumed session then draws only the plain result. A cache folder with a pruning step at `session.start` keeps rows longer.
- `$.fs.write` creates the file and its folders as needed.
- Prune from `session.start` without failing the session: catch the error of the pruning command.

## Sources

- nicolopignatelli/claude-code-inline-images (Source): <https://github.com/nicolopignatelli/claude-code-inline-images>, `outputDir` in `hooks/register.tsx`. It writes `<call>.svg`, `<call>.png.b64` and `<call>.json` to `$TMPDIR/claude-inline-images/`.
- sc-mods `show_image`: `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`. It keeps files in `~/.cache/sc-mods/images/` for 30 days.
