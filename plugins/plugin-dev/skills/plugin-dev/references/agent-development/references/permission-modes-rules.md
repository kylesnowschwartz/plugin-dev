# Permission Modes & Rules Reference

This reference covers the complete permission system for Claude Code agents, including all permission modes and the permission rule syntax for fine-grained access control.

## Permission Modes

Agents can specify a `permissionMode` in frontmatter to control how permission requests are handled:

```yaml
permissionMode: acceptEdits
```

### All Permission Modes

| Mode                | Behavior                                                                   | Use Case                                                           |
| ------------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `default`           | Standard permission model — prompts user for each action                   | General-purpose agents, untrusted contexts                         |
| `acceptEdits`       | Auto-accept file edit operations (Write, Edit, NotebookEdit)               | Code generation agents that need to write files                    |
| `dontAsk`           | No prompts; anything that would have prompted is denied                    | Agents whose allowed actions are fully covered by allow rules      |
| `bypassPermissions` | Skips permission prompts; a few protections still apply (see Mode Details) | Fully trusted agents only                                          |
| `plan`              | Planning mode — propose changes without executing                          | Architecture/design agents, review agents                          |
| `auto`              | Claude classifies each tool call and runs the lower-risk ones              | Agents that should proceed without prompts but keep a safety check |

### Mode Details

#### default

The standard interactive permission model. Claude asks the user before performing actions that require permission. This is the implicit mode when `permissionMode` is not specified.

**When to use:** General-purpose agents, agents handling sensitive operations, agents in untrusted contexts.

**Manual Default Permission Mode (CC 2.1.200):** The default permission mode across all Claude Code interfaces is now "Manual" (equivalent to `default` above). This is a more conservative default that requires explicit user approval for each action, and it affects both the CLI and programmatic interfaces.

#### acceptEdits

Auto-accepts file writing operations (Write, Edit, NotebookEdit) without prompting. Other operations (Bash, etc.) still require user permission.

**When to use:** Code generation agents, refactoring agents, documentation generators.

#### dontAsk

No permission dialogs are shown. Any action that would have prompted for permission is denied instead — only actions pre-approved by allow rules run.

**When to use:** Automation and CI/CD agents whose full set of permitted actions is already enumerated by allow rules, so a denial never blocks required work.

#### bypassPermissions

Runs actions without asking for permission, which makes it the most permissive mode. It is not a bypass of every check, though. The security monitor still blocks the categories listed under [Blocked Categories](#blocked-categories), and `permissions.blockReadsOutsideWorkingDirectories` still makes recognized file-reading commands prompt (see Bash Patterns). As of CC 2.1.273, a subshell can no longer hide a dangerous `rm` in this mode.

**When to use:** Only for fully trusted agents in controlled environments. Never for plugins distributed to unknown users.

#### plan

Planning mode restricts the agent to read-only operations. The agent can explore the codebase and propose changes but cannot execute them. Requires user approval before any modifications.

**When to use:** Architecture planning, design review, impact analysis agents.

#### auto

Claude checks each tool call for risky actions and prompt injection before executing, runs the ones it assesses as lower-risk, and blocks the rest. No permission dialogs are shown.

**When to use:** Agents that need to run unattended but should still refuse clearly risky actions. Use `dontAsk` instead when every action the agent can take is already enumerated by allow rules — `dontAsk` gives a deterministic deny on anything outside those rules, while `auto` leaves the decision to the risk classifier.

```yaml
# Unattended agent with automatic risk checks
permissionMode: auto
```

## Permission Specifier Syntax

Permission specifiers define exactly which tool invocations a rule matches. Each tool type has its own pattern syntax.

### Bash Patterns

| Pattern          | Behavior                     | Example Match             | Non-Match          |
| ---------------- | ---------------------------- | ------------------------- | ------------------ |
| `Bash(npm test)` | Exact match                  | `npm test`                | `npm test --watch` |
| `Bash(npm *)`    | Prefix with word boundary    | `npm test`, `npm install` | `npmx build`       |
| `Bash(git*)`     | Prefix without word boundary | `git`, `git push`, `gitk` | —                  |

Space before `*` means word boundary: `Bash(ls *)` matches `ls -la` but NOT `lsof`. No space means substring: `Bash(git*)` matches both `git push` and `gitk`.

**Commands that write files are matched on their destination too (CC 2.1.269).** A `Bash(tee:*)` allow rule no longer covers destinations outside the working directories, and the write-path check plus any `Edit()` deny rule now apply to the file a `tee` command writes. A rule pair like `Bash(tee:*)` allow plus `Edit(//etc/**)` deny behaves as an author would expect: the allow does not smuggle a write past the deny.

**Deny rules do NOT cover unanalyzable Bash command lines (reverted in CC 2.1.273).** CC 2.1.268 made a `Read` or `Edit` deny rule apply even when an unanalyzable command such as `env -C` or `eval` shared the command line. CC 2.1.273 reverted that check: commands like `time -p make build` prompt again instead of being denied. Do not rely on a `Read`/`Edit` deny rule to cover a Bash line the permission checker cannot parse — write an explicit `Bash(...)` deny rule for the wrapper forms you need to block.

**Unanalyzable commands no longer skip the prompt under `blockReadsOutsideWorkingDirectories` (CC 2.1.273).** Two gaps in the Bash permission path were closed alongside the revert above. A command the checker cannot fully analyze no longer bypasses the prompt when `permissions.blockReadsOutsideWorkingDirectories` is set, and a subshell can no longer hide a dangerous `rm` in `bypassPermissions` mode.

`permissions.blockReadsOutsideWorkingDirectories` is a boolean setting that makes the file tools refuse paths outside the working directories in **every** permission mode. It is an explicit exception to the mode table above: with it on, recognized file-reading Bash commands prompt even in `auto` and `bypassPermissions` mode. As of CC 2.1.273 it also excludes a memory directory chosen by a repository's settings from the prompt, recall, indexing, and memory extraction.

### Path Patterns for Edit/Read

Path specifiers follow the gitignore specification:

| Pattern  | Meaning                                      | Example                |
| -------- | -------------------------------------------- | ---------------------- |
| `//path` | Absolute from filesystem root                | `Edit(//etc/config)`   |
| `~/path` | Relative to home directory                   | `Read(~/Documents/**)` |
| `/path`  | Relative to settings file location           | `Edit(/src/**)`        |
| `./path` | Relative to current directory                | `Edit(./output/*)`     |
| `path`   | Relative to current directory (same as `./`) | `Edit(src/**)`         |
| `*`      | Single directory level wildcard              | `Read(src/*)`          |
| `**`     | Recursive directory wildcard                 | `Edit(src/**)`         |

**Write path rules with `Edit(path)` or `Read(path)` only.** File permission checks match `Edit(path)` for every file-writing tool (Write, Edit, NotebookEdit) and `Read(path)` for reads. A `Write(path)`, `NotebookEdit(path)`, or `Glob(path)` path rule is never matched, so it silently allows or denies nothing. CC 2.1.275 fixed `/update-config`, which had been writing `Write(path)` rules. Settings a plugin's README tells users to add, or rules generated with an older `/update-config`, may contain such rules and should be rewritten as `Edit(path)`. Bare tool names (`Write`), `Tool(param:value)` rules, and hook `if` conditions still use each tool's own name.

**Symlinked directories resolve to their real location (CC 2.1.268).** Deny and ask rules on directories that are symlinks — `/etc`, `/tmp`, `/var` on macOS, `/bin` on Linux — apply when a path is supplied by its real location, and Bash commands honor deny rules written using the symlinked spelling. A rule written either way covers both. This behavior was **not** affected by the CC 2.1.273 revert described under Bash Patterns.

**False symlink rejections on macOS fixed (CC 2.1.273).** Read no longer refuses a dragged-in screenshot, or any file the system reports under a second path, with `Refusing to read <path>: its symlink resolution changed after permission was checked`. The error still fires on a genuine mid-check resolution change.

### WebFetch Patterns

Restrict by domain:

```text
WebFetch(domain:example.com)
```

**A plain `WebFetch` rule does not gate Artifact reads and updates (CC 2.1.268).** A domainless `WebFetch` deny or ask rule no longer applies to the Artifact tool. To block or gate Artifact access, write an `Artifact` rule, or scope the WebFetch rule to the host:

```text
Artifact
WebFetch(domain:claude.ai)
```

### MCP Tool Patterns

| Pattern             | Matches                   |
| ------------------- | ------------------------- |
| `mcp__server`       | All tools from server     |
| `mcp__server__*`    | All tools from server     |
| `mcp__server__tool` | Specific tool from server |

### Task (Agent) Patterns

| Pattern              | Matches                      |
| -------------------- | ---------------------------- |
| `Task(agent-name)`   | Only the named agent type    |
| `Task(name1, name2)` | Only listed agent types      |
| `Task`               | All subagent types           |
| _(omit entirely)_    | No subagent spawning allowed |

### Skill Patterns

| Pattern         | Matches                     |
| --------------- | --------------------------- |
| `Skill(name)`   | Exact skill name match      |
| `Skill(name *)` | Prefix match with arguments |

### Evaluation Order

Rules are evaluated in a strict order — first match wins within each tier:

1. **Deny** rules checked first
2. **Ask** rules checked second
3. **Allow** rules checked last

**Rules beginning with `"!"` are scoped to their own settings source (CC 2.1.269).** A deny or ask rule written with a leading `"!"` applies only within the settings file that declared it; it no longer leaks into rules contributed by other sources. A bare `"!"` with nothing after it is ignored entirely. The `"!"` prefix is not part of the officially documented permission-rule syntax — do not build plugin guidance on it. If your plugin needs a rule to apply only in one scope, say so in your README rather than relying on the prefix.

### Blocked Categories

Claude Code's security monitor blocks certain categories of operations regardless of permission mode. These require explicit user approval:

- **Production Reads (CC 2.1.85):** Reading inside running production systems via remote shell, dumping environment variables or configs from production, and direct production database queries. Agent developers building ops-focused or deployment agents should be aware that no allow rule or permission mode pre-approves these operations. In interactive modes they prompt the user. In `dontAsk` mode, where nothing prompts, they are denied.

### Default Permission Tiers

Tools fall into three default permission tiers:

| Tier              | Tools                     | Behavior                                           |
| ----------------- | ------------------------- | -------------------------------------------------- |
| Read-only         | Read, Glob, Grep          | No approval needed                                 |
| Bash commands     | Bash                      | Manual approval on first use per directory/command |
| File modification | Write, Edit, NotebookEdit | Approval required per session                      |

## Permission Rules

Permission rules provide fine-grained control over specific tool access. They are configured in settings files (not agent frontmatter) and apply based on precedence.

### Rule Syntax

Rules are specified in `settings.json` under `permissions`:

```json
{
  "permissions": {
    "allow": ["Read", "Bash(npm test)", "Edit(src/**)"],
    "deny": ["Bash(rm *)", "Bash(git push --force*)"]
  }
}
```

### Tool Specifiers

| Pattern              | Matches                                                                 | Example                              |
| -------------------- | ----------------------------------------------------------------------- | ------------------------------------ |
| `ToolName`           | Any use of that tool                                                    | `Read` — all file reads              |
| `ToolName(argument)` | Tool with specific argument                                             | `Bash(npm test)` — only this command |
| `ToolName(pattern*)` | Tool with wildcard argument                                             | `Bash(npm *)` — any npm command      |
| `Edit(path)`         | Any file write (Write, Edit, NotebookEdit) under a gitignore-style path | `Edit(tests/**)` — writes in tests/  |
| `Read(path)`         | File reads under a gitignore-style path                                 | `Read(docs/**)` — reads in docs/     |

`Write(path)` is not a working path rule: file permission checks never match it (see Path Patterns above).

### MCP Tool Patterns

```json
{
  "permissions": {
    "allow": ["mcp__servername__toolname", "mcp__servername__*"]
  }
}
```

- `mcp__server__tool` — specific MCP tool
- `mcp__server__*` — all tools from a server
- `mcp__*` — all MCP tools (use sparingly)

### Task (Agent) Patterns

Control which agent types can be spawned:

```json
{
  "permissions": {
    "allow": ["Task(code-reviewer, test-runner)"]
  }
}
```

- `Task(type1, type2)` — only listed agent types
- `Task` — allow any subagent
- Omitting `Task` — no subagent spawning

### Rule Precedence

When multiple rules match:

1. **deny** rules always take precedence over **allow** rules
2. More specific rules take precedence over general ones
3. Explicit rules override `permissionMode` settings
4. A `"!"`-prefixed deny or ask rule is confined to its own settings source (CC 2.1.269)

**Auto-mode denials name the blocking rule (CC 2.1.268).** When `permissionMode: auto` refuses an operation, the message identifies which rule blocked it, so a plugin author can tell a policy denial from a security-monitor denial.

### Plugin Developer Guidance

**Document required permissions:** If your plugin's agents need specific tool access, document the minimum required permissions in your README:

```markdown
## Required Permissions

This plugin's agents need:

- `Edit(src/**)` — to modify source files
- `Bash(npm test)` — to run tests
- `mcp__plugin_myserver__*` — for MCP tool access
```

**Configure agent permissions:** Use `permissionMode` in agent frontmatter for broad access control. For fine-grained restrictions, document the settings users should configure.

**Principle of least privilege:** Request only the permissions your agent actually needs. `dontAsk` is the tighter mode for unattended agents: it runs only what allow rules pre-approve and denies everything else. `acceptEdits` auto-approves every file write and still prompts for other actions, so use it only when a user is present and blanket write approval is acceptable.
