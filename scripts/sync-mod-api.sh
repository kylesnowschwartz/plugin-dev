#!/usr/bin/env bash
# Refresh the vendored copy of Claude Code's built-in plugin-authoring skill
# (main text, examples, reference.md, API types) from the installed CLI.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/sync-mod-api.sh

Copy Claude Code's built-in plugin-authoring skill into the vendor folder of
plugin-dev's mod reference, and write the Claude Code version into the vendor
README.

The script starts a one-turn headless Claude Code session that loads the skill,
in a fresh temp root, and copies from what that session extracted: examples/,
reference.md, types/claude-code.d.ts, and the skill's main text from the
session transcript. The session makes one model call, so it needs a login
(CLAUDE_CODE_OAUTH_TOKEN in CI). The CLI is $CLAUDE_CODE_EXECUTABLE, or
`claude` on PATH.

Exit codes:
  0  vendor folder refreshed
  1  the skill did not load, or its copy is incomplete
  2  usage error, or a required tool is missing
EOF
}

die() {
  echo "sync-mod-api: $*" >&2
  exit 1
}

case "${1:-}" in
-h | --help)
  usage
  exit 0
  ;;
esac
if [[ $# -gt 0 ]]; then
  usage >&2
  exit 2
fi

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
vendor="$repo_root/plugins/plugin-dev/skills/plugin-dev/references/mod-development/vendor"
claude_bin=${CLAUDE_CODE_EXECUTABLE:-claude}

workdir=""
transcript=""
cleanup() {
  if [[ -n "$workdir" ]]; then rm -rf "$workdir"; fi
  if [[ -n "$transcript" ]]; then
    rm -f "$transcript"
    rmdir "$(dirname "$transcript")/memory" "$(dirname "$transcript")" 2>/dev/null || true
  fi
}
trap cleanup EXIT

for tool in jq python3 "$claude_bin"; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "sync-mod-api: required tool not found: $tool" >&2
    exit 2
  }
done

# The skill prints its paths with symlinks resolved, so the temp root is too.
workdir=$(cd "$(mktemp -d)" && pwd -P)
mkdir -p "$workdir/cwd"
session_id=$(python3 -c 'import uuid; print(uuid.uuid4())')

# The working folder is empty, so no project settings or CLAUDE.md load.
# The exit status is not the verdict: the files the session leaves behind are.
set +e
(cd "$workdir/cwd" && CLAUDE_CODE_TMPDIR="$workdir" "$claude_bin" -p "/plugin-authoring" \
  --session-id "$session_id" --max-turns 1 --model sonnet \
  </dev/null >"$workdir/session-output.txt" 2>&1)
session_status=$?
set -e

src=$(find "$workdir" -path '*/bundled-skills/*/*/plugin-authoring' -type d -print -quit)
if [[ -z "$src" ]]; then
  echo "sync-mod-api: the headless session (exit $session_status) extracted no plugin-authoring skill. Its output:" >&2
  head -n 20 "$workdir/session-output.txt" | sed 's/^/sync-mod-api: session: /' >&2
  exit 1
fi

config_dir=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
transcript=$(find "$config_dir/projects" -name "$session_id.jsonl" -type f -print -quit 2>/dev/null || true)
[[ -n "$transcript" ]] || die "no transcript for session $session_id under $config_dir/projects"

# The skill's main text is the one meta user message the session recorded.
skill_text=$(jq -r 'select(.type == "user" and .isMeta == true)
    | .message.content | if type == "array" then map(.text // "") | join("\n") else . end' "$transcript")
[[ "$skill_text" == "Base directory for this skill: $src"* ]] ||
  die "the transcript's skill text does not start with the skill's base directory"

for need in examples reference.md types/claude-code.d.ts; do
  [[ -e "$src/$need" ]] || die "$src has no $need"
done

version=$(basename "$(dirname "$(dirname "$src")")")
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "could not read a version from $src"

# Drop the base-directory line, and put placeholders where the text names
# this session's own folders or describes the session itself.
skill_text=${skill_text#*$'\n'}
skill_text=${skill_text//"$src"/<SKILL_DIR>}
skill_text=${skill_text//"$config_dir/dev-mods/$session_id"/<SESSION_MODS>}
skill_text=$(printf '%s\n' "$skill_text" | sed 's/^THIS SESSION .*/<THIS_SESSION>/')
if [[ "$skill_text" == *"$workdir"* || "$skill_text" == *"$session_id"* ]]; then
  die "the skill text still names a path of the headless session"
fi

rm -rf "$vendor/examples" "$vendor/types"
mkdir -p "$vendor/examples" "$vendor/types"
cp "$src"/examples/* "$vendor/examples/"
cp "$src/reference.md" "$vendor/reference.md"
cp "$src/types/claude-code.d.ts" "$vendor/types/claude-code.d.ts"
chmod 644 "$vendor"/examples/* "$vendor/reference.md" "$vendor/types/claude-code.d.ts"

{
  cat <<'EOF'
<!--
The main text of Claude Code's built-in plugin-authoring skill, as the Skill tool prints it.
The bundled skill folder holds no SKILL.md, so this text exists only in that tool output.
Placeholders stand for text that differs per session:
  <SKILL_DIR>     the skill's extracted folder, <temp root>/claude-<uid>/bundled-skills/<version>/<hash>/plugin-authoring
  <SESSION_MODS>  the session's mods folder, ~/.claude/dev-mods/<session-id>
  <THIS_SESSION>  a paragraph about the session that loaded the skill: its terminal, hot reload, and sharing
-->
EOF
  printf '%s\n' "$skill_text"
} >"$vendor/plugin-authoring-skill.md"

readme="$vendor/README.md"
readme_text=$(sed "s/^Claude Code version: .*/Claude Code version: $version/" "$readme")
printf '%s\n' "$readme_text" >"$readme"

echo "sync-mod-api: vendored plugin-authoring from Claude Code $version"
