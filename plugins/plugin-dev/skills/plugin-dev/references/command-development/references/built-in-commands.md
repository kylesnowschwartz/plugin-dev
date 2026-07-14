# Built-in Claude Code Commands

Reference for built-in commands and CLI subcommands that Claude Code ships with. These are distinct from the custom slash commands you author (covered in the overview) -- they are provided by Claude Code itself for managing state, sessions, configuration, and plugins.

## State Management Commands

Claude Code provides built-in commands for managing project state:

- **`claude project purge [path]`** (CC 2.1.126) — Deletes all Claude Code state for a project. Supports `--dry-run`, `-y/--yes`, `-i/--interactive`, and `--all` flags. Different from `claude plugin prune` (which removes orphaned plugin dependencies) — this removes ALL project state including conversation history and settings.

## Session Commands

- **`/cd`** (CC 2.1.169) — Relocates the session to a different directory without breaking prompt cache. Use this when you need to change the working directory mid-session while preserving cached context.

## Configuration Commands

- **`/config key=value`** (CC 2.1.181) — Set configuration values directly from the prompt without using the slash command menu. This provides a quick way to adjust settings during a session.

**Examples:**

```text
/config model=opus
/config theme=dark
/config sandbox.allowAppleEvents=true
```

This syntax is an alternative to navigating the `/config` menu interactively. Use it when you know the exact setting key you want to modify.

## Plugin Management Commands

- **`/plugin list`** (CC 2.1.163) — Lists installed plugins with filtering capabilities. Useful for discovering installed plugins and their status.
