# Skill Loading, Precedence, and Runtime Behavior

This reference covers how Claude Code discovers, loads, prioritizes, and runs skills — plus settings that control skill availability, dynamic-content injection, and behavior across compaction. It complements the authoring guidance in `skill-creation-workflow.md` and the frontmatter fields in `advanced-frontmatter.md`.

## Invoke Skill Tool (CC 2.1.196)

Claude Code includes a built-in "Invoke skill" tool that loads packaged skills by exact name or explicit user request. Key behaviors:

- **Scoped skill-name resolution** — When both scoped (`apps/web:deploy`) and unscoped (`deploy`) variants exist, the tool resolves based on files being worked on
- **Optional args** — Skills can receive arguments passed through the tool invocation
- **No re-invocation of loaded skills** — The tool does not re-invoke a skill already loaded in the current turn

This tool is how Claude programmatically loads skills — plugin developers don't need to call it directly, but understanding its behavior helps when designing skills that may be invoked automatically vs. manually.

## Model Invocation vs. Explicit Invocation

Model invocation is the **default**. Claude Code builds a model-facing skill listing from every discovered skill's `name` and `description`, and Claude calls the Skill tool when a task matches one. Users can also invoke a skill explicitly by typing `/skillname`. Both paths are live at once.

- **Auto-discovery is the default path** — A skill with a well-written `description` is invoked by Claude without the user typing anything
- **Explicit invocation always works** — `/skillname` loads the skill regardless of what Claude infers
- **Opt out per skill** — Set `disable-model-invocation: true` in frontmatter to make a skill user-invocable only. The opt-out exists precisely because model invocation is the default
- **CC 2.1.215 narrowed auto-execution, not auto-invocation** — Some built-in skills stopped firing on weak signals. That tightened the matching bar; it did not remove the Skill tool or the model-facing listing

**Implications for plugin developers:**

- Write trigger phrases into the description — that text is what auto-discovery matches against
- Document explicit invocation in your README as a fallback, not as the only path
- Reach for `disable-model-invocation: true` only when autonomous invocation would be harmful (destructive operations, actions needing deliberate user intent)

## Invoke Skill Background Guidance (CC 2.1.218)

When skills are invoked for background execution, Claude Code provides specific guidance for handling asynchronous skill results:

- **Initial return is agent name only** — Background skill invocation initially returns just the agent name, not results
- **Results delivered later** — Full results arrive through task notifications when background execution completes
- **Don't wait or re-invoke** — Do not block waiting for background skill results or invoke the same skill again while pending
- **Acknowledge and continue** — Briefly acknowledge the skill launch and continue with other work

**Implications for plugin developers:**

- Skills that may run in background should be designed for asynchronous result delivery
- Document expected latency for skills that perform long-running operations
- Consider providing progress notifications via SendMessageTool "main" for long-running background skills

## Slash-Skill Stacking (CC 2.1.199)

Users can load multiple skills simultaneously using stacked slash-skill invocations:

```text
/skill-a /skill-b /skill-c do the task
```

**Behavior:**

- Up to **5 skills** can be loaded in a single invocation
- All leading skills are loaded (not just the first one)
- Skills load in order and their contexts are combined
- The remaining text after the skill names becomes the task prompt

**Implications for plugin developers:**

- Design skills to compose well with others — avoid conflicting instructions
- Skills may be loaded alongside built-in or other plugin skills
- Keep skill contexts focused to avoid context pollution when stacked
- Test skills in combination with common complementary skills

## Skill Precedence

Skills follow precedence: Enterprise > Personal (`~/.claude/skills/`) > Project (`.claude/skills/`) > Plugin skills. Higher-priority skills with the same name shadow lower-priority ones. Use distinctive, namespaced names for plugin skills to avoid collisions.

**Qualified names in errors (CC 2.1.269):** When a bare skill name matches exactly one plugin skill, the Skill tool's "Unknown skill" error names the skill in its full `plugin-name:skill-name` form. A user who typed the bare name gets told what to type instead, which makes a shadowed plugin skill much easier to diagnose.

**Reserved-ish prefix: `anthropic-skills:` (CC 2.1.269).** Skills synced from claude.ai into cloud sessions are named `anthropic-skills:<name>`, matching Claude Desktop. The bare name still resolves when nothing else claims it. Do not name a plugin `anthropic-skills` — its skills would collide with the synced namespace.

## Nested Skill Directories (CC 2.1.178)

Skills can be organized in nested directories within `.claude/skills/`. When working on files in a nested directory, skills from that directory's `.claude/skills/` are loaded automatically.

**Collision handling:** When the same skill name exists in multiple nested directories, the skill displays as `<dir>:<name>` format (e.g., `apps/web:deploy`). This prevents name collisions while maintaining clarity about which skill is which.

**Example structure:**

```text
project/
├── .claude/skills/         # Project-level skills
│   └── shared-skill/
├── apps/
│   └── web/
│       └── .claude/skills/ # Nested skills for apps/web
│           └── deploy/     # Appears as "apps/web:deploy" if collision
└── packages/
    └── api/
        └── .claude/skills/ # Nested skills for packages/api
            └── deploy/     # Appears as "packages/api:deploy" if collision
```

## Directory-Scoped Skills (CC 2.1.178)

Skills whose names are prefixed with their directory path (e.g., `apps/web:deploy`) enable targeted skill activation. When both a scoped and unscoped variant exist:

1. **Files being worked on determine precedence** — the most specific directory wins
2. **Otherwise, unscoped skill is used** — when no files provide context

**Use cases:**

- Monorepos with different deployment procedures per app
- Package-specific build or test skills
- Directory-specific conventions that shouldn't apply globally

## Automatic Local Skill Loading (CC 2.1.157)

Skills in `.claude/skills/` directories now load automatically without marketplace installation or explicit configuration. Simply place a skill directory with a `SKILL.md` file in your project's `.claude/skills/` or personal `~/.claude/skills/`, and it becomes available immediately.

**Development workflow:**

1. Create skill directory: `mkdir -p .claude/skills/my-skill`
2. Add `SKILL.md` with frontmatter and content
3. Skill is immediately available — no install step required

This streamlines local plugin development and testing. Skills loaded this way follow the standard precedence rules.

## Verify Skill Auto-Persistence (CC 2.1.200)

The built-in verify skill now automatically creates and persists project skills. After a cold-start verification succeeds, the working build/launch/drive recipe is saved to `.claude/skills/verify/SKILL.md` at the appropriate scope:

- **Repository root** for single-package projects
- **Touched package/app directory** in monorepos

If a verify skill already exists, new learnings are folded into it rather than duplicated.

**Implications for plugin developers:**

- Be aware that the `verify` skill may be auto-created in user projects
- Plugin-provided verify-related skills should avoid naming conflicts with the built-in `verify` skill
- The auto-persistence pattern demonstrates how skills can evolve based on project learnings

## Project Skill Shadowing Warning (CC 2.1.200)

**Important:** Creating new project skills can shadow built-in skills with the same name. Claude Code now includes explicit guidance:

- **Only edit existing project skills** — don't create new ones that could shadow built-ins
- **Exception: `verify` skill** — the only skill that should be auto-created (for build/test recipes)
- **Closest-scoped placement** — verify corrections go in the closest-scoped `.claude/skills/verify/SKILL.md`, never duplicated at broader scopes

**Implications for plugin developers:**

- Use distinctive, namespaced names for plugin skills (e.g., `my-plugin-deploy` not just `deploy`)
- Document clearly when skills might interact with built-in skill names
- Design skills to complement rather than conflict with built-in capabilities

## skillOverrides Setting (CC 2.1.129)

Users can control skill behavior globally via the `skillOverrides` setting in their settings.json:

```json
{
  "skillOverrides": "user-invocable-only"
}
```

**Values:**

- `off` - Disable all skills entirely (skills won't load or trigger)
- `user-invocable-only` - Only allow skills that users explicitly invoke via `/skillname`
- `name-only` - Show skill names in menus but don't load full descriptions (reduces context usage)

**Implications for plugin developers:**

- Skills may not trigger automatically if users have restrictive `skillOverrides` settings
- Design skills to work well when user-invoked (clear `/skillname` entry point)
- Keep skill names descriptive since they may be the only visible identifier
- Test skills with `skillOverrides: "user-invocable-only"` to ensure they work when explicitly invoked

## disableBundledSkills Setting (CC 2.1.169)

The `disableBundledSkills` managed setting hides bundled skills, workflows, and slash commands from the model:

```json
{
  "disableBundledSkills": true
}
```

**When enabled:**

- Built-in Claude Code skills are hidden from the model
- Plugin-provided skills remain available
- User-defined skills remain available

**Implications for plugin developers:**

- This setting gives plugins more control over the skill landscape
- Useful for enterprise environments with custom skill sets
- Plugin skills should be self-contained and not rely on bundled skills

## Dynamic Content in Skills

Skills support dynamic content injection and variable substitution for context-aware behavior.

### String Substitutions

Use variables in skill content that get replaced at runtime:

```markdown
The session ID is: ${CLAUDE_SESSION_ID}
Arguments passed: $ARGUMENTS
```

**Available substitutions:**

- `$ARGUMENTS` - Arguments passed when skill is invoked (e.g., `/skill-name arg1 arg2`)
- `$ARGUMENTS[0]`, `$ARGUMENTS[1]` - Individual positional arguments (0-indexed)
- `$1`, `$2`, `$3` - 1-indexed shorthand for positional arguments
- `${CLAUDE_SESSION_ID}` - Current session identifier
- `${CLAUDE_PLUGIN_ROOT}` - Plugin directory path

**Literal dollar sign escape (CC 2.1.163):** Use `\$` to output a literal dollar sign before digits without argument substitution:

```markdown
The regex pattern is \$1 for the first capture group.
```

This outputs `$1` literally instead of substituting the first argument.

### Dynamic Context Injection

Execute commands to inject their output into skill context using backtick syntax:

```markdown
## Current Project Status

The git status is:
[BANG]`git status --short`

Recent commits:
[BANG]`git log --oneline -5`
```

**Syntax:** `` [BANG]`command` ``

**Use cases:**

- Load current project state (git status, package.json)
- Include dynamic configuration
- Fetch environment-specific information

**Security note:** Commands execute in the user's environment. Only use trusted commands.

**Disable shell execution (CC 2.1.91):** Organizations can disable inline shell execution in skills, custom slash commands, and plugin commands via the `disableSkillShellExecution` setting. When enabled, `[BANG]`command`` blocks are not executed. Design skills to work gracefully when shell execution is unavailable.

## Auto-Discovery

Claude Code automatically discovers skills:

- Scans `skills/` directory
- Finds subdirectories containing `SKILL.md`
- Loads skill metadata (name + description) always
- Loads SKILL.md body when skill triggers
- Loads references/examples when needed

## No Packaging Needed

Plugin skills are distributed as part of the plugin, not as separate ZIP files. Users get skills when they install the plugin.

## Testing in Plugins

Test skills by installing plugin locally:

```bash
# Test with --plugin-dir
claude --plugin-dir /path/to/plugin

# Ask questions that should trigger the skill
# Verify skill loads correctly
```

## Hot-Reloading Skills During Development (CC 2.1.152, 2.1.174)

Use the `/reload-skills` command to re-scan skill directories without restarting your session. This is useful during skill development when you're iterating on skill content:

1. Edit your SKILL.md or references
2. Run `/reload-skills` in Claude Code
3. Test the updated skill immediately

Changes to skill content, frontmatter, and references are picked up. No need to restart Claude Code.

**Performance optimization (CC 2.1.174):** Skill hot-reload now only re-sends changed skills instead of the entire skill listing. When you modify a single skill, only that skill is re-announced to Claude, reducing token overhead during rapid iteration. This makes the edit-reload-test cycle faster for developers working on individual skills.

## /skills Menu Display (CC 2.1.86)

Two separate caps apply to a skill description, and they are easy to conflate:

- **Model-facing skill listing** — Each description is truncated at **1,536 characters** (`skillListingMaxDescChars`) in the listing Claude sees. Text past that point is not available for auto-discovery matching
- **`/skills` menu display** — The interactive menu truncates long descriptions for display only

Place the most important trigger phrases early in the description so they survive both cuts.

Skills are listed **alphabetically** and in the `/skills` menu. Name skills with discoverability in mind — a skill named `api-testing` appears near the top, while `zsh-config` appears at the bottom.

**Token Count Sorting (CC 2.1.111):** Press `t` in the `/skills` menu to sort by token count. This helps identify large skills that consume significant context budget. Optimize large skills by moving content to references/ or using progressive disclosure.

## Context Management for Plugins

After auto-compaction, skill descriptions survive (they're re-injected), but skill body content may be lost. Users can re-invoke the skill to reload it. The `PreCompact` hook can preserve critical state before compaction occurs.

When multiple plugins are installed, their skill descriptions share the same budget. Design descriptions to be distinctive and concise.

## Subagent Skill Discovery (CC 2.1.133)

**Resolved:** Subagents now correctly discover project, user, and plugin skills via the Skill tool. Prior to CC 2.1.133, subagents could not invoke skills, which limited their ability to leverage plugin-provided knowledge. Skills used by agents should work correctly on CC 2.1.133 or later.

## Previously Invoked Skills (CC 2.1.119, updated 2.1.239)

After conversation compaction, skills invoked before compaction are restored as context only via a "Previously invoked skills" reminder. This reminder warns not to re-execute setup actions or treat prior inputs as current instructions. The old "Invoked skills" reminder was replaced by this more explicit context-only framing.

**Context broadening (CC 2.1.239):** The post-compaction warning now applies more broadly — request or argument text appearing anywhere in restored skill bodies, including "User Request" sections, is treated as historical context rather than a new live instruction. This prevents Claude from re-executing tasks described in restored skill bodies.

**Implications for skill design:**

- Skills should be idempotent where possible
- Setup actions (file creation, initialization) should check if already done
- Skills should not assume prior context survives compaction unchanged
- Do not embed executable instructions in skill body sections labeled as "User Request" or similar — these are treated as historical after compaction
- Design skills to clearly separate instructional content from contextual examples

## Skill Doctor (`/skill-doctor`) — Generally Available (CC 2.1.261)

The `/skill-doctor` command diagnoses skill issues and identifies unused skills consuming context budget:

**Capabilities:**

- Identifies unused skills and calculates their context cost in tokens
- Diagnoses triggering problems (why a skill wasn't being invoked)
- Analyzes description effectiveness
- Suggests trigger phrase improvements
- Validates frontmatter configuration

**Use cases:**

- Optimizing skill descriptions for better trigger matching
- Reducing context window consumption by identifying bloated or unused skills
- Debugging why a skill isn't triggering as expected
- Auditing plugin skills for efficiency

**History:** `/skill-doctor` was in early access (CC 2.1.233-2.1.235), briefly removed from bundled prompts (CC 2.1.251), and restored as generally available in CC 2.1.261.

## Plugin Eval (`claude plugin eval`) — Generally Available (CC 2.1.269)

`claude plugin eval` runs a plugin's eval suite against Claude Code and reports scored, reproducible results. It became generally available in CC 2.1.269; no enablement environment variable is needed (the former `CLAUDE_CODE_WALNUT_SPIRE=1` gate is gone).

```bash
claude plugin eval                  # run every case in the eval dir
claude plugin eval init             # scaffold a new case
claude plugin eval --json report.json
```

**Where cases live.** The eval directory defaults to `evals/` at the plugin root. Override it per-run with `--eval-dir <dir>`, or per-plugin with the `experimental.evals` key in `plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "experimental": {
    "evals": "evals"
  }
}
```

`experimental.evals` is a path relative to the plugin root. A list is accepted; its first entry is the case directory. Because it sits under `experimental`, its shape may change without a deprecation cycle.

**Case layout:**

```text
evals/
├── my-case/
│   ├── prompt.md            # the prompt, plus case frontmatter
│   ├── case.yaml            # optional: alternative/extended case definition
│   └── graders/
│       ├── triggered.md     # one grader per file
│       └── output.md
└── mocks/
    └── <server>/<tool>.md   # optional MCP mocks
```

A case needs a prompt — either the `prompt.md` body or `execution.prompt` in `case.yaml`. Useful `prompt.md` frontmatter keys include `runs`, `max_turns`, `timeout_seconds`, `allowed_tools`, `model`, and `append_system_prompt`. `case.yaml` carries a required `schema_version` plus keys such as `scaffold_script`, `history_file`, and `add_dirs`.

**Grader types.** Each file in `graders/` must declare `type:` in its frontmatter, one of:

| Type          | Checks                                         |
| ------------- | ---------------------------------------------- |
| `regex`       | Output matches a pattern                       |
| `tool_used`   | A specific tool was called                     |
| `tool_order`  | Tools were called in a given order             |
| `file_exists` | A file was created at a path                   |
| `llm`         | A model judges the transcript against criteria |
| `baseline`    | Compared against a recorded baseline run       |

Graders also accept `weight` (relative contribution to the score) and `arm` (which run arm the grader applies to).

**MCP mocks.** `--mocks record` (the default) reads stand-ins from `<eval dir>/mocks/`. A plugin MCP server with no mock is **not** started, and its tools are unavailable for that run — add `mocks/<server>/` to cover it. `--mocks off` disables mocking.

**Reports.** Results land in `<eval dir>/results/`. `--json [path]` prints the full machine-readable result; a self-contained HTML report (scores, prompts, grader verdicts) can be written to a path of your choosing.

**Trust.** `claude plugin eval` loads the plugin and runs its suite on your machine as you. A plugin directory must be trusted before the first run; a piloted run started from a non-interactive session cannot stop to ask, so it writes cases without running them.

## Built-in Skill Patterns (CC 2.1.247-2.1.248 — Removed in CC 2.1.251)

> **Note (CC 2.1.251):** The following built-in skills and references have been **removed** from Claude Code's bundled prompts:
>
> - **Workflow authoring reference**
> - **Cost optimization skill**
> - **Admin API reference**
> - **Claude API references and model catalog**
> - **Artifact and visual-authoring bundle**
> - **Design sync and variants**
>
> This was part of a major documentation removal (-743,949 tokens). Plugin developers should no longer reference these as "built-in Claude Code resources." The patterns they demonstrated remain valuable — the documentation below is retained for historical reference and to illustrate the patterns themselves.

Claude Code previously included several built-in skills that demonstrated advanced patterns useful for plugin developers:

### Workflow Authoring Reference (CC 2.1.248) — Removed

The **Workflow authoring reference** skill demonstrated a pattern of moving detailed technical content from tool descriptions into dedicated reference skills:

**What it covered:**

- Detailed Workflow APIs and syntax
- Concurrency and budgeting rules
- Orchestration patterns for multi-step automation
- Ultracode guidance and resume behavior

**Pattern value for plugin developers:**

- Reduces tool description size by extracting details into a skill
- Makes technical reference content available on-demand rather than always in context
- Demonstrates progressive disclosure at the tool level — basic guidance in the tool, full reference in the skill
- Consider this pattern for plugins that add complex MCP tools

### Cost Optimization Skill (CC 2.1.247) — Removed

The **Cost optimization** skill demonstrated advanced integration patterns:

**What it covered:**

- Cost-per-completed-task workflow design
- Traffic class profiling from Admin API data
- Application usage log analysis
- Multi-model tradeoff evaluation

**Pattern value for plugin developers:**

- Shows how to build skills that integrate with external APIs
- Demonstrates data-driven workflow design
- Illustrates evaluation patterns where the skill helps analyze and optimize
- Useful as a template for skills that perform business analysis or optimization tasks

### Admin API Reference (CC 2.1.247) — Removed

The **Admin API reference** provided documentation for enterprise integrations:

**What it covered:**

- Organization-admin authentication
- Workspace and API-key management
- Rate limits and usage tracking
- Service accounts and workload identity federation
- Customer-managed keys (CMK)

**Pattern value for plugin developers:**

- Enterprise plugin integrations can reference external Admin API documentation
- Shows how to document complex API integrations in skill format
- Useful context for plugins targeting enterprise environments

## Removed Skill Variants (CC 2.1.248)

### /loop Fixed-Interval Variant

The older fixed/default-interval prompt variant of the `/loop` command has been removed. The dynamic-mode prompt remains. If your plugin documentation references `/loop` behavior, update it to reflect that only the dynamic-mode variant exists.

### Writing for the User (CC 2.1.247)

Claude Code now includes strict formatting requirements for user-facing output in the "Writing for the user" system prompt:

**Requirements:**

- Standalone, answer-first final messages
- Concise complete sentences
- Prohibits em dashes, parentheticals, arrows, reasoning commentary, and session-invented labels

**Implications for skill authors:**

- Skills that produce user-facing output should follow these formatting guidelines
- Avoid meta-commentary about the skill's own process
- Lead with answers, not explanations
- Keep output clean and direct
