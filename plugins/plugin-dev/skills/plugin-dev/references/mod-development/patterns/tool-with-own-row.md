# A tool that draws its own row

**Confidence:** Live (ran in a session in Ghostty and tmux).

## Problem

A tool's result is visual or long: a picture, a chart, a diff, a test report. The model needs one short line, and the person needs a rich view in the conversation, at the place where the call happened.

## API calls

- `$.tool.register({ name, description, inputSchema, isDeferred })` in `session.start`. The model sees the tool as `mcp__<plugin>__<name>`. No MCP server runs: a hook in the mod answers it.
- `on('tool.call', { tool: /^mcp__<plugin>__<name>$/ }, ($, e) => ({ result }))` answers the call. The tool's arguments are spread on `e`, beside `tool_use_id`.
- `on('ui.render', { component: 'ToolResult' }, ...)` draws the call's result row. `e.props` carries `tool`, `tool_use_id`, `output`, `isErrored`, and `isExpanded` (the ctrl+o transcript). Return a tree to replace the row, or `next(e)` to keep the engine's drawing.

## Code sketch

```tsx
const TOOL = 'mcp__my-mod__show_chart'

on('session.start', async ($, e, next) => {
  await $.tool.register({
    name: 'show_chart',
    description: 'Show a chart to the person inline. The chart is not returned to you.',
    inputSchema: { type: 'object', properties: { series: { type: 'array' } }, required: ['series'] },
    isDeferred: false, // in the prompt's tool list, not behind ToolSearch
  })
  return next(e)
})

on('tool.call', { tool: /^mcp__my-mod__show_chart$/ }, async ($, e) => {
  // do the work, keep row data on disk (see row-sidecar-on-disk.md)
  return { result: 'Showed the chart inline.' } // a string: what the model reads
}).catch(() => ({ deny: 'show_chart failed' }))

on('ui.render', { component: 'ToolResult' }, async ($, e, next) => {
  if (e.surface !== 'terminal' || e.props.tool !== TOOL || e.props.isErrored) return next(e)
  const { Box, Text } = $.ui.resolve(e)
  return <Box flexDirection="column"><Text>…the rich view…</Text></Box>
})
```

## Minimum Claude Code version

2.1.316 is the oldest version this pattern is known to work on.

## Gotchas

- `result` must be a string or an array. An object is refused with a schema error (`invalid_union`), and the model sees the error. See `gotchas.md`.
- The model reads `result`. A `text` field beside it does not replace what the model reads, so keep `result` short and free of drawing data.
- A string tool name in the `tool.call` matcher fails `tsc`: the matcher's type lists only built-in tools. Use a regex.
- The tool is in the model's tool list from the next prompt after `session.start` registers it, not in the turn that loaded the mod.
- The `tool.call` hook answers the call, so it is a gating hook: add `.catch`, or `claude plugin validate` reports it.

## Sources

- sc-mods `show_image` (Live): `plugins/sc-mods/hooks/show-image.tsx` in <https://github.com/kylesnowschwartz/SimpleClaude>, branch `feat/sc-mods-show-image`.
- nicolopignatelli/claude-code-inline-images (Source): <https://github.com/nicolopignatelli/claude-code-inline-images>, `hooks/register.tsx`. It matches the row with `{ component: 'ToolResult', props: { tool: TOOL } }`.
- jenkinv/claude-img-viewer (Source): <https://github.com/jenkinv/claude-img-viewer> registers a `show_image` tool and draws in a pane instead of the row.
