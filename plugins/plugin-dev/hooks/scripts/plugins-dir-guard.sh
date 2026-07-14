#!/bin/bash
# PreToolUse guard: when Claude reads from the Claude Code plugins directory
# (~/.claude/plugins or $CLAUDE_CONFIG_DIR/plugins), inject context instructing
# it to invoke the plugin-dev skill. Fires once per session to avoid re-firing
# on every reference read after the skill loads (the skill itself lives under
# the plugins directory).
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

target=$(jq -r '.tool_input.file_path // .tool_input.path // .tool_input.command // empty' <<<"$input")
[[ -z "$target" ]] && exit 0

plugins_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins"
case "$target" in
"$plugins_dir" | "$plugins_dir"/* | *"$plugins_dir"*) ;;
*".claude/plugins"*) ;;
*) exit 0 ;;
esac

session_id=$(jq -r '.session_id // "unknown"' <<<"$input")
marker="${TMPDIR:-/tmp}/plugin-dev-plugins-dir-guard-${session_id}"
[[ -e "$marker" ]] && exit 0
touch "$marker" 2>/dev/null || true

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "This tool call reads from the Claude Code plugins directory. Before interpreting plugin manifests, skills, hooks, agents, or marketplace files found there, invoke the plugin-dev skill (Skill tool: plugin-dev:plugin-dev) and consult its references instead of answering from general knowledge. For questions about Claude Code's own runtime behavior or features, also consult the built-in claude-code-guide subagent (Agent tool) if it is available in this session."
  }
}
JSON
