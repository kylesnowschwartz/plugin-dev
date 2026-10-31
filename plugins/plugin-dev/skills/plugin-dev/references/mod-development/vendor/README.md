# Vendored plugin-authoring material

Claude Code version: 2.1.316

These files are copied unchanged from Claude Code's built-in `plugin-authoring` skill (the `cc-plugin-plugin-authoring` built-in plugin), except `plugin-authoring-skill.md`:

- `examples/`: six complete hooks modules and state contracts (a pane, a band above the prompt, a tool-call hook, and a test).
- `reference.md`: the long-form mod reference.
- `types/claude-code.d.ts`: the mod API types for this version, about 14,000 lines.
- `plugin-authoring-skill.md`: the skill's main text, as the Skill tool prints it. The bundled folder has no SKILL.md, so this file is the only saved copy. Placeholders stand for the per-session paths.

The files describe the Claude Code version above. The running build can be newer: its own types are in `<mod folder>/.claude-plugin/types/` once a mod has loaded, and in the skill's extracted folder once the skill has loaded.

Refresh this folder from the newest extracted copy with `scripts/sync-mod-api.sh` at the repository root. The script does not change `plugin-authoring-skill.md`.
