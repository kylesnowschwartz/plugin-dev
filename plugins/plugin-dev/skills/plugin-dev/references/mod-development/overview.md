# Mod Development

A **mod** is a Claude Code plugin whose hooks are TypeScript functions instead of shell commands. Its `hooks/hooks.json` holds `{ "modules": ["./register.tsx"] }`, naming a module that exports `register(on, options)`. A mod can draw a pane, a band above the prompt, a status line entry, a toast, or its own drawing of a transcript row (`ui.render`). It can also register tools the model calls (`$.tool.register`), slash commands, and subagent types, and it can block, rewrite, or react to tool calls and prompts.

## Start Every Mod by Loading `plugin-authoring`

Before writing or debugging a hooks module, load Claude Code's built-in `plugin-authoring` skill (the Skill tool, or `/plugin-authoring`). Loading it does two things that this reference cannot:

- **It writes the API types for the running build** into the skill's extracted folder. Once a mod has loaded, `<mod folder>/.claude-plugin/types/` holds the same, with a `tsconfig.json` for `tsc -p <mod folder>`.
- **It starts hot reload.** Claude Code watches the session's mods folder only after the skill loads. The first file written there asks the person once to turn on the session's mods; only the person can answer. Edits reload when the turn ends.

Use this reference for what the built-in skill does not have: patterns that worked, gotchas, and when to choose a mod.

## When to Choose a Mod

| Need | Choose |
| --- | --- |
| Draw something in Claude Code's interface: a pane, a band, a row, a picture, a button | A mod |
| A tool whose result the person sees as a rich view and the model sees as one line | A mod (`$.tool.register` plus a `ToolResult` render) |
| React to an event with a shell script, in any host, with no drawing | A classic command hook (`../hook-development/overview.md`) |
| A tool or data source shared with other MCP clients | An MCP server (`../mcp-integration/overview.md`) |
| Instructions or a workflow for the model | A skill (`../skill-development/overview.md`) |

Cross-cutting risks of mods (managed machines that skip some events, fail-closed hand-offs, auto mode) and the version history of the mod API are in `../plugin-structure/references/advanced-topics.md`.

## The Vendored Copy

`vendor/` holds the built-in skill's material for one Claude Code version, copied unchanged; `vendor/README.md` names the version.

- `vendor/plugin-authoring-skill.md`: the skill's main text, as the Skill tool prints it.
- `vendor/reference.md`: the long form: every event, `ui.render` in depth, `$.state` contracts, tests, sharing.
- `vendor/examples/`: complete modules for a pane, a band, and a tool-call hook, with state contracts and a test.
- `vendor/types/claude-code.d.ts`: the API, about 14,000 lines. Grep it for the name at hand (`'tool.call'`, `Pane: {`, `export type ImageProps`, `ToolResult: {`).

The copy can lag the running build. When a type or rule matters, check it in the running build's types (the paths above). Refresh the copy with `scripts/sync-mod-api.sh` at the repository root.

## Patterns

Each pattern file has the same parts: the problem, the API calls, a code sketch, the minimum Claude Code version, gotchas, and sources. Each one states its confidence: **Live** (ran in a session), **Source** (read in a published mod), or **Types** (read in the API types).

### Tools and transcript rows

- `patterns/tool-with-own-row.md`: a mod tool that draws its own result row.
- `patterns/row-sidecar-on-disk.md`: row data on disk by tool call ID, so rows draw after a resume.
- `patterns/per-row-state.md`: Hide, size, and other state for each row.
- `patterns/copy-button-under-reply.md`: a button under each assistant reply.
- `patterns/jump-to-prompt.md`: move the view to an earlier prompt.

### Pictures, links, and buttons

- `patterns/image-in-terminal.md`: a real picture in the terminal, also inside tmux.
- `patterns/links-and-buttons.md`: `file://` links and buttons in a row.

### The band and panes

- `patterns/band-hotkey-buttons.md`: numbered hotkey buttons above the prompt.
- `patterns/share-the-band.md`: give the band to surveys and to the hint line.
- `patterns/band-styling.md`: spacing, borders, colors, hover.
- `patterns/prompt-list-pane.md`: a pane that lists prompts.
- `patterns/fallback-without-surface.md`: where nothing can be drawn.

### State, timing, and safety

- `patterns/follow-theme.md`: light and dark palettes.
- `patterns/lasting-settings.md`: `$.store` across sessions, `$.state` for the session.
- `patterns/repaint-only-changes.md`: `$.ui.blit` and throttling.
- `patterns/poll-on-change.md`: redraw only when a file changed.
- `patterns/copy-to-clipboard.md`: `$.ui.copy` and a `pbcopy` fallback.
- `patterns/own-commands-passthrough.md`: skip the mod's own commands.
- `patterns/commands-from-timer.md`: run commands and compaction from a timer.
- `patterns/gotchas.md`: small API rules that cost a turn each.

## Where to Find More

- **Mods docs:** <https://code.claude.com/docs/en/plugins/mods/overview>.
- **Anthropic examples:** <https://github.com/anthropics/claude-code/tree/main/mods> and <https://github.com/anthropics/claude-code-playground/tree/main/claude-code/mods>.
- **Index of community mods:** <https://github.com/karanb192/awesome-claude-code-mods>, browsable at <https://mods.aidojo.si/>. Each entry lists what the mod reads, writes, runs, and sends over the network.
