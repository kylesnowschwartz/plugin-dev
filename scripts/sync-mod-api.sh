#!/usr/bin/env bash
# Refresh the vendored copy of Claude Code's built-in plugin-authoring skill
# (examples, reference.md, API types) from an extracted copy on this machine.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/sync-mod-api.sh [<plugin-authoring folder>]

Copy examples/, reference.md and types/claude-code.d.ts from Claude Code's
built-in plugin-authoring skill into the vendor folder of plugin-dev's mod
reference, and write the Claude Code version into the vendor README.

With no argument, the newest folder that matches
/private/tmp/claude-*/bundled-skills/<version>/<hash>/plugin-authoring
is used. Claude Code extracts that folder only when the plugin-authoring
skill loads in a session, so load the skill once (/plugin-authoring) if
none is found.

The vendored plugin-authoring-skill.md is not changed: it is captured by
hand from the Skill tool's output.

Exit codes:
  0  vendor folder refreshed
  1  no extracted copy found, or the copy is incomplete
  2  usage error
EOF
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac
if [[ $# -gt 1 ]]; then
  usage >&2
  exit 2
fi

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
vendor="$repo_root/plugins/plugin-dev/skills/plugin-dev/references/mod-development/vendor"

if [[ $# -eq 1 ]]; then
  src=$1
else
  # Highest version first; the version is the folder above <hash>.
  src=$(
    for dir in /private/tmp/claude-*/bundled-skills/*/*/plugin-authoring; do
      [[ -d "$dir" ]] || continue
      version=$(basename "$(dirname "$(dirname "$dir")")")
      printf '%s\t%s\n' "$version" "$dir"
    done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2
  )
  if [[ -z "$src" ]]; then
    echo "sync-mod-api: no extracted plugin-authoring skill under /private/tmp/claude-*/bundled-skills/." >&2
    echo "Load the skill once in a Claude Code session (/plugin-authoring), then run this again." >&2
    exit 1
  fi
fi

for need in examples reference.md types/claude-code.d.ts; do
  if [[ ! -e "$src/$need" ]]; then
    echo "sync-mod-api: $src has no $need" >&2
    exit 1
  fi
done

version=$(basename "$(dirname "$(dirname "$src")")")
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  version=$(claude --version 2>/dev/null | awk '{print $1}')
fi

rm -rf "$vendor/examples" "$vendor/types"
mkdir -p "$vendor/examples" "$vendor/types"
cp "$src"/examples/* "$vendor/examples/"
cp "$src/reference.md" "$vendor/reference.md"
cp "$src/types/claude-code.d.ts" "$vendor/types/claude-code.d.ts"
chmod 644 "$vendor"/examples/* "$vendor/reference.md" "$vendor/types/claude-code.d.ts"

readme="$vendor/README.md"
tmp=$(mktemp)
sed "s/^Claude Code version: .*/Claude Code version: $version/" "$readme" >"$tmp"
mv "$tmp" "$readme"

echo "sync-mod-api: vendored plugin-authoring from Claude Code $version ($src)"
