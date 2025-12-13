## Description

<!-- Provide a clear and concise description of your changes -->

## Type of Change

<!-- Mark the relevant option with an "x" -->

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update (improvements to README, CLAUDE.md, or component docs)
- [ ] Refactoring (code change that neither fixes a bug nor adds a feature)
- [ ] Test (adding or updating tests)
- [ ] Configuration change (changes to .markdownlint.json, plugin.json, etc.)

## Component(s) Affected

<!-- Mark all that apply -->

- [ ] Commands (`/plugin-dev:*`)
- [ ] Skills (methodology and best practices)
- [ ] Agents (plugin-validator, skill-reviewer, agent-creator)
- [ ] Hooks (event-driven automation)
- [ ] Marketplace (marketplace.json, distribution)
- [ ] Documentation (README.md, CLAUDE.md, SECURITY.md)
- [ ] Configuration (.markdownlint.json, plugin.json)
- [ ] Issue/PR templates
- [ ] Other (please specify):

## Motivation and Context

<!-- Why is this change required? What problem does it solve? -->
<!-- If it fixes an open issue, please link to the issue here using one of these formats: -->
<!-- Fixes #123 - closes issue when PR merges -->
<!-- Closes #123 - same as Fixes -->
<!-- Resolves #123 - same as Fixes -->
<!-- Related to #123 - links without closing -->

Fixes # (issue)

## How Has This Been Tested?

<!-- Describe the tests you ran to verify your changes -->

**Test Configuration**:

- Claude Code version:
- GitHub CLI version: `gh --version`
- OS:
- Testing repository: <!-- public repo you tested with, if applicable -->

**Test Steps**:

1. <!-- e.g., Load plugin with `claude --plugin-dir plugins/plugin-dev` -->
2. <!-- e.g., Run command `/plugin-dev:create-plugin` -->
3. <!-- e.g., Verify plugin created successfully -->
4. <!-- etc. -->

## Checklist

### General

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas (if applicable)
- [ ] My changes generate no new warnings or errors

### Documentation

- [ ] I have updated the documentation accordingly (README.md, CLAUDE.md, or component docs)
- [ ] I have updated YAML frontmatter (if applicable)
- [ ] I have verified all links work correctly

### Markdown

- [ ] I have run `markdownlint` and fixed all issues
- [ ] My markdown follows the repository style (ATX headers, dash lists, fenced code blocks)
- [ ] I have verified special HTML elements are properly closed (`<p>`, `<img>`, `<example>`, `<commentary>`)

### Shell Scripts (if applicable)

- [ ] Shell scripts pass `shellcheck`
- [ ] Scripts are executable (`chmod +x`)
- [ ] Scripts use `${CLAUDE_PLUGIN_ROOT}` for portable paths

### Component-Specific Checks

<!-- Only relevant if you modified commands, skills, agents, or hooks -->

<details>
<summary><strong>Commands</strong> (click to expand)</summary>

- [ ] Command uses imperative form ("Do X", not "You should do X")
- [ ] Error handling is included for common failure modes
- [ ] GitHub CLI commands are properly formatted
- [ ] Success/failure messages are clear and helpful

</details>

<details>
<summary><strong>Skills</strong> (click to expand)</summary>

- [ ] Description uses third-person with specific trigger phrases
- [ ] SKILL.md is 1,000-2,200 words (progressive disclosure)
- [ ] Detailed content is in `references/` subdirectory
- [ ] Templates follow the established format

</details>

<details>
<summary><strong>Agents</strong> (click to expand)</summary>

- [ ] Agent includes 3-4 `<example>` blocks
- [ ] Examples demonstrate triggering conditions clearly
- [ ] System prompt is clear and focused
- [ ] Tool list is minimal and appropriate
- [ ] YAML frontmatter includes required fields (name, description, model, color)
- [ ] Optional frontmatter configured correctly (tools, skills, allowed-tools)

</details>

<details>
<summary><strong>Hooks</strong> (click to expand)</summary>

- [ ] Hook uses correct event type (PreToolUse, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification)
- [ ] Matchers are properly configured for tool filtering
- [ ] Hook type is appropriate (prompt for LLM-driven, command for scripts)
- [ ] Prompt-based hooks have clear, focused instructions
- [ ] Command-based hooks handle errors gracefully

</details>

### Testing

- [ ] I have tested the plugin locally with `claude --plugin-dir plugins/plugin-dev`
- [ ] I have tested the full workflow (if applicable)
- [ ] I have verified GitHub CLI integration works (if applicable)
- [ ] I have tested in a clean repository (not my development repo)
- [ ] I have run relevant validation scripts (validate-agent.sh, validate-command.sh, validate-hook-schema.sh, etc.)

### Version Management (if applicable)

- [ ] I have updated version numbers in all version files:
  - [ ] `plugins/plugin-dev/.claude-plugin/plugin.json` (source of truth)
  - [ ] `.claude-plugin/marketplace.json` (metadata.version AND plugins[0].version)
  - [ ] `CLAUDE.md` (Quick Reference section)
- [ ] I have updated CHANGELOG.md with relevant changes

## Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

## Additional Notes

<!-- Add any other context about the pull request here -->

## Reviewer Notes

<!-- Information specifically for the reviewer -->

**Areas that need special attention**:
<!-- List any specific areas you'd like reviewers to focus on -->

**Known limitations or trade-offs**:
<!-- Describe any known issues or compromises made -->

---

## Pre-Merge Checklist (for maintainers)

- [ ] All CI checks pass
- [ ] Documentation is accurate and complete
- [ ] Changes align with project architecture and design patterns
- [ ] No security vulnerabilities introduced
- [ ] Breaking changes are clearly documented
- [ ] Labels are appropriate for the change type
- [ ] Version numbers are updated in all version files (if applicable)
- [ ] CHANGELOG.md is updated (if applicable)
