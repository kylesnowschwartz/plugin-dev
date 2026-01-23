# Workflow Command Security

Security considerations for the plugin creation workflows.

## Required Tool Access

The workflow commands (`/plugin-dev:create-plugin` and `/plugin-dev:create-marketplace`) require broad file system access to perform their scaffolding functions:

```yaml
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(mkdir:*), Bash(git init:*), ...
```

**Why this access is needed:**

- Creating plugin directory structures requires `Write` and `Bash(mkdir:*)`
- Generating manifest files and component templates requires `Write` and `Edit`
- Initializing git repositories requires `Bash(git init:*)`
- Exploring existing code for patterns requires `Read`, `Grep`, `Glob`

## Security Considerations

- These commands can write to any location within the user's permission scope
- The commands prompt for confirmation before creating structures
- Review the target directory before starting a workflow
- In multi-user environments, verify the working directory is appropriate

## Design Contrast with `/plugin-dev:start`

The entry point command uses `disable-model-invocation: true` and restricts tools to `AskUserQuestion, Skill, TodoWrite` since it only routes to other commands. The workflow commands need broader access because they perform the actual file creation work.

## For Security-Sensitive Environments

Review the `allowed-tools` frontmatter in each command file to understand exactly what access is granted. Future Claude Code versions may support path-scoped tool restrictions (e.g., `Write(./plugins/*)`), which would allow tighter scoping.
