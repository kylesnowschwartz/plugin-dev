# Upstream Change Manifest
## CC Version Range: 2.1.93 - 2.1.98
## Generated: 2026-04-10
## Sources: changelog [OK], system-prompts [OK], claude-code-guide [failed - agent not available in CI]

---

### Must Update

- [ ] **Monitor tool for streaming background events** (CC 2.1.98)
  - Source: changelog, system-prompts (NEW: Tool Description: Background monitor)
  - Confidence: high
  - Affects: agent-development skill (Available Tools section), tool documentation
  - Details: New tool that streams stdout events from long-running scripts as chat notifications. System prompts include guidelines on script quality, output volume, and selective filtering.
  - Raw changelog: "Monitor tool for streaming background events to foreground session"
  - System-prompts: "NEW: Tool Description: Background monitor (streaming events) -- Added description for a background monitor tool that streams stdout events from long-running scripts as chat notifications"
  - Gap: New tool not documented in agent-development or tool references

- [ ] **Agent threads now always require absolute file paths** (CC 2.1.97)
  - Source: system-prompts only
  - Confidence: high
  - Affects: agent-development skill (Agent Best Practices section)
  - Details: Removed conditional logic for relative vs. absolute paths in agent threads. Agents must now always use absolute file paths unconditionally. This reverses/clarifies the 2.1.91 change that added relative path support.
  - System-prompts: "System Prompt: Agent thread notes -- Removed the conditional logic for relative vs. absolute file paths; agent threads now always require absolute file paths unconditionally"
  - Gap: agent-development skill may need to clarify absolute path requirement for agents

- [ ] **Plugin skill hooks and CLAUDE_PLUGIN_ROOT fixes** (CC 2.1.94)
  - Source: changelog
  - Confidence: high
  - Affects: docs/claude-code-compatibility.md, hook-development skill (bug fixes note)
  - Details: Three critical bug fixes: (1) Plugin skill hooks in YAML frontmatter were silently ignored - now fixed; (2) Plugin hooks failed with "No such file or directory" when CLAUDE_PLUGIN_ROOT was not set - now fixed; (3) ${CLAUDE_PLUGIN_ROOT} resolved to marketplace source instead of installed cache for local-marketplace plugins - now fixed.
  - Raw changelog: "Fixed plugin skill hooks defined in YAML frontmatter being silently ignored", "Fixed plugin hooks failing with 'No such file or directory' when CLAUDE_PLUGIN_ROOT was not set", "Fixed ${CLAUDE_PLUGIN_ROOT} resolving to marketplace source instead of installed cache for local-marketplace plugins"
  - Gap: Compatibility tracker needs update; hook-development may note these were fixed

- [ ] **Skill invocation name change** (CC 2.1.94)
  - Source: changelog
  - Confidence: high
  - Affects: skill-development skill (naming section)
  - Details: Plugin skills declared via "skills": ["./"] now use the skill's frontmatter `name` for invocation instead of directory basename. This changes how skills are discovered and invoked.
  - Raw changelog: "Plugin skills declared via 'skills': ['./'] now use the skill's frontmatter name for invocation instead of directory basename"
  - Gap: skill-development should note that frontmatter `name` is used for invocation, not directory name

---

### May Update

- [ ] **Communication style system prompts added** (CC 2.1.98)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: skill-development skill (skill writing best practices)
  - Details: New system prompts for communication style guidelines. May be useful context for skill writing guidance but not a direct plugin API change.

- [ ] **Exploratory questions system prompt** (CC 2.1.98)
  - Source: system-prompts only
  - Confidence: medium
  - Affects: skill-development skill (trigger design best practices)
  - Details: Claude now analyzes before implementing on open-ended questions. May inform skill design but not a documentation gap.

- [ ] **Managed Agents API replaces Agent SDK** (CC 2.1.97)
  - Source: system-prompts
  - Confidence: high
  - Affects: potential future plugin-dev integration
  - Details: Major architectural change in Claude Code's built-in API documentation. Plugin-dev does not currently reference Agent SDK, so no stale references exist. Informational only for now.

- [ ] **CLAUDE_CODE_PERFORCE_MODE environment variable** (CC 2.1.98)
  - Source: changelog only
  - Confidence: medium
  - Affects: potential environment variable documentation
  - Details: New env var for read-only file handling in Perforce environments.
  - Raw changelog: "`CLAUDE_CODE_PERFORCE_MODE` environment variable for read-only file handling"

- [ ] **CLAUDE_CODE_USE_MANTLE=1 for Amazon Bedrock via Mantle** (CC 2.1.94)
  - Source: changelog only
  - Confidence: medium
  - Affects: potential environment variable documentation
  - Details: New env var enabling Amazon Bedrock support via Mantle.
  - Raw changelog: "Added Amazon Bedrock support via Mantle with `CLAUDE_CODE_USE_MANTLE=1` environment variable"

- [ ] **Default effort level changed from medium to high** (CC 2.1.94)
  - Source: changelog, system-prompts (Build with Claude API skill update)
  - Confidence: medium
  - Affects: agent-development references (if any mention effort levels)
  - Details: Changed default effort level from medium to high for API-key and Team/Enterprise users. System prompts updated effort parameter guidance.
  - Raw changelog: "Changed default effort level from medium to high for API-key and Team/Enterprise users"

- [ ] **Worker fork agent metadata changes** (CC 2.1.97)
  - Source: system-prompts only
  - Confidence: low
  - Affects: agent-development skill (fork/subagent patterns)
  - Details: Added agent metadata specifying model inheritance, permission bubbling, max turns, full tool access, and description of when forks are triggered. Minor documentation alignment opportunity.
  - System-prompts: "Agent Prompt: Worker fork -- Added agent metadata specifying model inheritance, permission bubbling, max turns, full tool access"

- [ ] **Dream team memory handling** (CC 2.1.98)
  - Source: system-prompts only
  - Confidence: low
  - Affects: potential memory-related skill references
  - Details: New system prompt for handling shared team memories during dream consolidation, including deduplication and conservative pruning rules.

- [ ] **Focus view toggle (Ctrl+O) for NO_FLICKER mode** (CC 2.1.97)
  - Source: changelog only
  - Confidence: low
  - Affects: potential UI/keybinding documentation
  - Details: New keyboard shortcut for focus view displaying prompt and tool summaries.

- [ ] **refreshInterval status line setting** (CC 2.1.97)
  - Source: changelog only
  - Confidence: low
  - Affects: potential configuration documentation
  - Details: New setting for controlling status line refresh interval.

---

### No Action

**Rejected from Must Update:**
- `keep-coding-instructions` frontmatter field (CC 2.1.94) — REJECTED: This field is for OUTPUT STYLES, not skills. Plugin-dev already correctly documents this in `plugins/plugin-dev/skills/plugin-structure/references/output-styles.md`. No gap exists.

**Version 2.1.98:**
- Interactive Google Vertex AI setup wizard -- infrastructure/setup feature
- Subprocess sandboxing with PID namespace isolation on Linux -- internal security
- Bash tool permission bypass security fix (backslash-escaped flags) -- security fix
- Bash tool compound command vulnerability fix -- security fix
- Stalled streaming responses fix -- bug fix
- 429 retry logic improvements -- infrastructure
- MCP OAuth configuration handling fix -- bug fix
- xterm keyboard protocol issues fix -- terminal compatibility
- macOS text replacements fix -- bug fix
- managed-settings persistence fix -- bug fix
- Permission rule matching for wildcards and piped commands fix -- bug fix
- UI issues in fullscreen mode fix -- bug fix
- `/resume` picker functionality fix -- bug fix

**Version 2.1.97:**
- Cedar policy file syntax highlighting -- IDE feature
- Permission bypass fixes -- security fixes
- Bash tool security hardening (env-var prefixes) -- internal security
- MCP HTTP/SSE buffer management fix -- infrastructure
- 429 retry exponential backoff fix -- infrastructure
- MCP OAuth token refresh fix -- bug fix
- `/resume` picker cache miss and lost input fixes -- bug fix
- NO_FLICKER mode UI artifacts fixes -- bug fix
- Build with Claude API skill replaced with new routing version -- built-in CC skill change
- Buddy Mode removed -- built-in CC feature removal
- git_worktree field added to status line setup -- internal telemetry
- Verify skill restructured with probe strategies -- built-in CC skill change

**Version 2.1.96:**
- Bedrock 403 Authorization header hotfix -- bug fix

**Version 2.1.94:**
- Compact Slack headers with clickable channel links -- notification formatting
- Plugin hook execution issues fix -- bug fix (operational)
- Marketplace update problems with git submodules fix -- bug fix (operational)
- Console login failures on macOS fix -- bug fix
- Agents appearing stuck after rate-limit responses fix -- bug fix
- Scrollback duplication and multiline prompt indentation UI crashes -- bug fix
- Dream memory consolidation changes -- built-in CC memory system
- Dream memory pruning agent added -- built-in CC memory system
- Memory synthesis agent added -- built-in CC memory system
- Onboarding guide generator agent added -- built-in CC onboarding
- Session search agent (lightweight replacement) -- built-in CC feature
- Memory staleness verification system prompt -- built-in CC memory system
- Memory description of user details prompt -- built-in CC memory system
- Team onboarding guide skill -- built-in CC skill
- Worker fork prompt streamlined -- built-in CC agent change
- Build with Claude API subcommand dispatch -- built-in CC skill change
- Verify skill CI assumption relaxation -- built-in CC skill change
- Agent tool usage notes streamlined -- tool description change
- Worker fork execution prompt removed (replaced) -- internal refactor
- Session Search Assistant prompt removed (replaced) -- internal refactor
- Agent "when to launch" tool description folded into main -- internal refactor

**Version 2.1.97 (system-prompts):**
- /dream nightly schedule skill -- built-in CC skill
- Live documentation sources updated (Managed Agents URLs) -- built-in CC docs
- Build with Claude API reference guide routing updated -- built-in CC skill
- Verify skill "Get a handle" and "Push on it" sections -- built-in CC skill
- ReadFile tool simplified to always require absolute paths (agent context) -- aligns with agent thread note change
- Write tool "prefer Edit" guidance made unconditional -- tool description change

---

## Stage 2: Verification Results
### Verified: 2026-04-10

#### Must Update Verification

- X **`keep-coding-instructions` frontmatter field for skills** (CC 2.1.94) — **REJECTED**: This field is for OUTPUT STYLES, not skills. The changelog entry mentions it alongside "compact Slack headers", and the system-prompts changelog for 2.1.94 does not mention this field at all. Plugin-dev already documents `keep-coding-instructions` correctly in `plugins/plugin-dev/skills/plugin-structure/references/output-styles.md` as an output style frontmatter field. No gap exists.

- CHECK **Monitor tool for streaming background events** (CC 2.1.98) — confirmed in changelog and system-prompts ("NEW: Tool Description: Background monitor"). Gap exists in agent-development skill (Available Tools section does not mention Monitor tool).

- INFO **Managed Agents API replaces Agent SDK** (CC 2.1.97) — confirmed in system-prompts (massive +23,865 token addition). However, plugin-dev does not reference Agent SDK anywhere. This is informational for potential future integration. **Reclassify to No Action** - no current gap exists in plugin-dev documentation.

- CHECK **Agent threads now always require absolute file paths** (CC 2.1.97) — confirmed in system-prompts: "System Prompt: Agent thread notes -- Removed the conditional logic for relative vs. absolute file paths; agent threads now always require absolute file paths unconditionally." Gap exists - agent-development skill should note this requirement for agents.

- ARROW_DOWN **Communication style system prompts** (CC 2.1.98) — confirmed in system-prompts. **Demote to May Update**: These are Claude Code behavioral guidelines, not plugin API changes. May be useful context for skill writing but not a direct gap.

- ARROW_DOWN **Exploratory questions system prompt** (CC 2.1.98) — confirmed in system-prompts. **Demote to May Update**: This is Claude Code behavior, not plugin-specific. May inform skill design but not a documentation gap.

#### Missed Items (promoted from No Action)

- ! **Plugin skill hooks fixed in CC 2.1.94** — The changelog states "Fixed plugin skill hooks defined in YAML frontmatter being silently ignored" and "Fixed plugin hooks failing with 'No such file or directory' when CLAUDE_PLUGIN_ROOT was not set" and "Fixed ${CLAUDE_PLUGIN_ROOT} resolving to marketplace source instead of installed cache for local-marketplace plugins". These are CRITICAL bug fixes for plugin developers. While they don't require doc updates (bugs are now fixed), they should be noted in the compatibility tracker.
  - Affects: docs/claude-code-compatibility.md
  - Details: These fixes resolve issues with scoped hooks in skill frontmatter and CLAUDE_PLUGIN_ROOT path resolution that affected plugin developers.

- ! **Skill invocation names changed (CC 2.1.94)** — "Plugin skills declared via 'skills': ['./'] now use the skill's frontmatter `name` for invocation instead of directory basename". This affects how skills are invoked.
  - Affects: skill-development skill (skill naming section)
  - Details: Skills now use frontmatter `name` for invocation, not directory name. This is relevant for skill naming guidance.

#### May Update Resolution

- = **CLAUDE_CODE_PERFORCE_MODE** — kept as May Update: Environment variable for read-only file handling. Not directly plugin-related but could be mentioned in environment variables reference if one exists.

- = **CLAUDE_CODE_USE_MANTLE=1** — kept as May Update: Amazon Bedrock support env var. Not directly plugin-related.

- = **Default effort level changed from medium to high** — kept as May Update: Affects API-key and Team/Enterprise users. May be relevant if agent-development mentions effort levels (it does not currently).

- = **Worker fork agent metadata changes** — kept as May Update: Internal agent system changes. Minor documentation alignment opportunity.

- = **Dream team memory handling** — kept as May Update: Built-in CC memory system, not plugin-related.

- = **Focus view toggle (Ctrl+O)** — kept as May Update: UI feature, not plugin-related.

- = **refreshInterval status line setting** — kept as May Update: Configuration setting, not directly plugin-related.

#### Summary

- Must Update: 6 items originally -> 2 confirmed, 1 rejected, 2 demoted, 2 added = **4 items total**
  - Confirmed: Monitor tool, Agent absolute paths
  - Promoted: Plugin hook fixes (compatibility note), Skill invocation names
- May Update: 7 items originally + 2 demoted = **9 items remaining**
- Confidence: **HIGH** — The manifest's main error was misattributing `keep-coding-instructions` to skills when it's an output style field. Plugin-dev already documents this correctly.

---

## Notes

1. **Degraded triangulation**: The claude-code-guide agent was not available in this CI environment, so cross-referencing against official docs was not performed. Changes are confirmed via changelog and system-prompts sources only.

2. **High-priority items for plugin-dev** (verified):
   - The Monitor tool is a new tool that agents can use (CC 2.1.98)
   - Agent threads now unconditionally require absolute file paths (CC 2.1.97)
   - Plugin skill hooks and CLAUDE_PLUGIN_ROOT fixes are critical bug fixes (CC 2.1.94)
   - Skill invocation now uses frontmatter `name` instead of directory basename (CC 2.1.94)
   - Note: `keep-coding-instructions` is for output styles, NOT skills (already documented correctly)

3. **System-prompts changelog is more authoritative** for prompt/tool description changes, while the GitHub changelog captures user-facing features and settings.

4. **Token delta summary**:
   - 2.1.94: +2,000 tokens (Dream agents, memory synthesis, onboarding guide, session search)
   - 2.1.96: +0 tokens (hotfix only)
   - 2.1.97: +23,865 tokens (Managed Agents documentation - massive addition)
   - 2.1.98: +2,045 tokens (Communication style, dream team memory, exploratory questions, background monitor)

5. **Note on version 2.1.93/2.1.95**: Neither the upstream changelog nor the system-prompts changelog show entries for versions 2.1.93 or 2.1.95. These versions may have been internal releases, skipped, or contained only infrastructure changes not reflected in public changelogs.

---

## Raw Changelog Excerpts

### Version 2.1.98
```
- Interactive Google Vertex AI setup wizard
- CLAUDE_CODE_PERFORCE_MODE environment variable for read-only file handling
- Monitor tool for streaming background events to foreground session
- Subprocess sandboxing with PID namespace isolation on Linux
- Security: Bash tool permission bypass (backslash-escaped flags, compound commands)
- Fixes: stalled streaming, 429 retry, MCP OAuth, xterm keyboard, macOS text replacements,
  managed-settings persistence, permission rules, fullscreen UI, /resume picker
```

### Version 2.1.97
```
- Focus view toggle (Ctrl+O) for NO_FLICKER mode
- refreshInterval status line setting
- Cedar policy file syntax highlighting
- Security: Permission bypass fixes, Bash tool env-var prefix hardening
- Fixes: MCP HTTP/SSE buffer, 429 retry, OAuth token refresh, /resume picker, NO_FLICKER UI
```

### Version 2.1.96
```
- Hotfix: Bedrock requests failing with 403 Authorization header is missing
```

### Version 2.1.94
```
- Amazon Bedrock support via Mantle (CLAUDE_CODE_USE_MANTLE=1)
- Default effort level changed from medium to high
- Compact Slack headers with clickable channel links
- keep-coding-instructions frontmatter field support
- Fixes: agents stuck after rate-limit, Console login on macOS, plugin hook execution,
  marketplace updates with git submodules, scrollback duplication, multiline prompt indentation
```
