# Memory & Rules System Interaction

Claude Code has a layered memory and rules system that plugins interact with. Understanding this system helps plugin developers design components that complement (rather than conflict with) the user's existing configuration.

## CLAUDE.md Memory Files

### What They Are

CLAUDE.md files provide persistent instructions that Claude reads at the start of every session. They contain project context, coding standards, and behavioral guidance.

### File Locations and Priority

Memory files are loaded in priority order (highest first):

| Priority    | Location                             | Scope                         |
| ----------- | ------------------------------------ | ----------------------------- |
| 1 (highest) | Managed policy (system paths)        | Organization-wide             |
| 2           | `.claude/CLAUDE.md` or `./CLAUDE.md` | Project (shared via git)      |
| 3           | `.claude/rules/*.md`                 | Project rules (modular)       |
| 4           | `~/.claude/CLAUDE.md`                | User (personal, all projects) |
| 5 (lowest)  | `.claude/CLAUDE.local.md`            | Project local (gitignored)    |

Higher-priority instructions take precedence when there are conflicts.

### AGENTS.md fallback (CC 2.1.277)

In a project with **no CLAUDE.md**, Claude Code reads `AGENTS.md` as the project instructions instead. It is a fallback, not an addition: a project that has a CLAUDE.md does not also load AGENTS.md. Users change this under **"Project instructions"** in `/config`. Not yet available on Bedrock, Vertex or Foundry.

Claude Code also attaches **nested** instruction files found below the session's working directory, framing them by path; CC 2.1.275 made that reminder cover CLAUDE.md and AGENTS.md alike.

**Implications for plugin developers:** a plugin that inspects, generates, or instructs users to edit "the project's CLAUDE.md" should handle an AGENTS.md-only repository — writing a new CLAUDE.md into such a project silently takes over as the instruction file and stops AGENTS.md from being read at all. Whether the agent frontmatter field `omitClaudeMd` also suppresses AGENTS.md is undocumented; see `../../agent-development/references/advanced-agent-fields.md`.

**Why local is lowest priority:** Unlike typical configuration systems where ".local" means "override", Claude Code's `.local.md` files are for personal, project-specific notes and preferences that shouldn't override team standards. The hierarchy ensures organizational policy (managed) > team standards (project) > personal preferences (user/local).

### Import Syntax

CLAUDE.md files can import other files:

```markdown
# Project Instructions

@docs/coding-standards.md
@docs/api-conventions.md
```

**Rules:**

- Paths are relative to the importing file
- Absolute paths are also supported
- Maximum recursion depth: 5 hops
- Imports are NOT evaluated inside code blocks or inline code spans
- Circular imports are detected and handled

### Creating CLAUDE.md

The `/init` command generates a starter CLAUDE.md by analyzing the codebase. Alternatively, create one manually:

```markdown
# Project Name

## Code Style

- Use TypeScript strict mode
- Follow Prettier defaults

## Architecture

- Components in src/components/
- API routes in src/api/

## Testing

- Write tests for all new features
- Use Jest with React Testing Library
```

### Auto-Memory (MEMORY.md)

Claude Code can automatically persist learnings between sessions using memory files:

- **`MEMORY.md`**: Auto-generated file where Claude stores session-to-session learnings
- **Topic files**: Claude may create topic-specific memory files (e.g., `MEMORY-debugging.md`) for organized knowledge

**Plugin interaction:**

- Plugins should not write to or modify the user's auto-memory files
- Plugin agents with `memory` frontmatter use a separate, agent-specific memory directory (see the agent-development topic at `../../agent-development/overview.md`)
- If your plugin generates knowledge worth persisting, instruct users to save it to CLAUDE.md rather than relying on auto-memory

**Import syntax note:** The `@path` import syntax works in all CLAUDE.md files (project, user, local), not just the root one. This enables modular configuration:

```markdown
# My CLAUDE.md

@docs/coding-standards.md
@.claude/plugin-config.md
```

## Rules System

### What Rules Are

Rules are modular instruction files in `.claude/rules/` that can optionally target specific file patterns. They provide focused guidance that loads contextually.

### File Structure

```
.claude/
└── rules/
    ├── testing.md          # Applies globally
    ├── api-patterns.md     # Applies globally
    └── typescript.md       # Path-specific (see below)
```

### Path-Specific Rules

Rules can target specific files using YAML frontmatter with glob patterns:

```markdown
---
paths:
  - "src/**/*.ts"
  - "lib/**/*.ts"
---

Use strict TypeScript patterns:

- No `any` types
- Explicit return types on all public functions
- Use discriminated unions over type assertions
```

**Glob support:**

- Standard patterns: `*`, `?`, `**`
- Brace expansion: `src/**/*.{ts,tsx}`
- Multiple patterns in the `paths` array
- Patterns match against relative paths from project root

### When Rules Load

Rules load automatically based on file context:

- Global rules (no `paths` frontmatter): Always loaded
- Path-specific rules: Loaded when Claude accesses matching files
- Rules in subdirectories: Organized by topic, all discovered automatically

### User-Level Rules

Personal rules in `~/.claude/rules/` apply across all projects with lower priority than project rules.

## How Plugin Content Fits

### Plugin Content Priority

Plugin content loads differently from the memory/rules hierarchy:

| Content Type          | How It Loads                           | Priority Context                    |
| --------------------- | -------------------------------------- | ----------------------------------- |
| Skill descriptions    | As tool definitions (always available) | Independent of memory hierarchy     |
| Skill body (SKILL.md) | When skill triggers                    | Independent of memory hierarchy     |
| Agent definitions     | As subagent configs                    | Independent of memory hierarchy     |
| Hook configurations   | Merge with user/project hooks          | Parallel execution with other hooks |
| MCP servers           | As tool providers                      | Independent of memory hierarchy     |

Plugin content doesn't directly compete with CLAUDE.md for priority — it operates through different mechanisms (tool definitions, hooks, MCP tools).

### Where They Overlap

Conflicts can arise when:

1. **CLAUDE.md instructions contradict plugin skill guidance** — CLAUDE.md has implicit priority as it's always in context
2. **Project rules specify patterns that conflict with plugin hooks** — Both apply; hooks enforce, rules guide
3. **User settings restrict tools that plugins need** — User settings win; plugins should document requirements

## Design Implications for Plugin Developers

### Don't Duplicate CLAUDE.md Content

If a project's CLAUDE.md already specifies coding standards, your plugin skills shouldn't re-specify them. Instead, reference them:

```markdown
Follow the project's coding standards (see CLAUDE.md) while applying
the additional [domain-specific] patterns below...
```

### Use Rules for File-Type Guidance

If your plugin needs file-type-specific behavior, consider whether it belongs as:

- **A rule** (`.claude/rules/`): For guidance that should always apply to certain file types
- **A skill**: For knowledge that's invoked on demand
- **A hook**: For enforcement that must happen every time

### Understand Override Behavior

Users can override plugin behavior through:

- CLAUDE.md instructions (higher priority context)
- Settings that restrict tools (`permissions.deny`)
- Disabling plugin hooks via settings

Design plugins to be graceful when overridden. Document what settings affect plugin behavior.

### Plugin Settings (.local.md) vs Rules

Plugin settings (`.claude/plugin-name.local.md`) and rules (`.claude/rules/`) serve different purposes:

| Aspect     | Plugin .local.md              | .claude/rules/                        |
| ---------- | ----------------------------- | ------------------------------------- |
| Purpose    | Plugin-specific configuration | Project-wide guidance                 |
| Format     | YAML frontmatter + markdown   | Optional paths frontmatter + markdown |
| Scope      | Single plugin                 | All Claude interactions               |
| Managed by | User configuring plugin       | Project maintainers                   |
| In git     | No (gitignored)               | Yes (shared with team)                |

### Test with Various Configurations

Test your plugin with:

1. Empty CLAUDE.md (no project context)
2. Detailed CLAUDE.md (potential conflicts)
3. Path-specific rules (ensure hooks don't conflict)
4. User-level rules (personal preferences)
5. Managed settings (enterprise restrictions)
