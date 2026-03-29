# Troubleshooting

Extended debugging guide for plugin development.

## Common Issues

| Problem                   | Cause                       | Solution                                                             |
| ------------------------- | --------------------------- | -------------------------------------------------------------------- |
| Plugin not loading        | Wrong directory path        | Use `plugins/plugin-dev`, not root                                   |
| Skill not triggering      | Weak trigger phrases        | Add specific user queries to description                             |
| Hook not firing           | Incorrect matcher pattern   | Check regex syntax, test with `test-hook.sh`                         |
| Validation script fails   | Missing dependencies (`jq`) | Install required tools (see [README.md](../README.md#prerequisites)) |
| Shell execution in skills | Using `!` backtick pattern  | Replace with `[BANG]` placeholder                                    |

## Debug Mode

Run Claude Code with debug output:

```bash
claude --debug --plugin-dir plugins/plugin-dev
```

## Validation Failures

If components fail validation:

1. **Run the specific validator** for the component type
2. **Check frontmatter** - ensure all required fields are present
3. **Verify file location** - components must be in correct directories
4. **Check naming** - use kebab-case for names (e.g., `my-agent`, not `myAgent`)

## Utility Scripts

Paths relative to `plugins/plugin-dev/`:

```bash
# Agent development
./skills/agent-development/scripts/validate-agent.sh agents/agent-name.md
./skills/agent-development/scripts/test-agent-trigger.sh agents/agent-name.md

# Command development
./skills/command-development/scripts/validate-command.sh .claude/commands/my-command.md
./skills/command-development/scripts/check-frontmatter.sh .claude/commands/my-command.md

# Hook development
./skills/hook-development/scripts/validate-hook-schema.sh hooks/hooks.json
./skills/hook-development/scripts/test-hook.sh hooks/my-hook.sh input.json

# Plugin settings
./skills/plugin-settings/scripts/validate-settings.sh .claude/plugin.local.md
```

## Getting More Help

- Check [README.md FAQ](../README.md#faq) for common questions
- Review [CONTRIBUTING.md](../CONTRIBUTING.md#common-mistakes-to-avoid) for common mistakes
- Open an [issue](https://github.com/kylesnowschwartz/plugin-dev/issues) if you're stuck
