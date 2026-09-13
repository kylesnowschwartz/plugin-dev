#!/usr/bin/env bash
# Extract machine-checkable facts about hooks, plugin userConfig, and permission
# modes from a Claude Code binary, for the documentation drift guard to compare
# plugin-dev's docs against.
#
# The binary is a minified single-file bundle: every identifier (function names,
# module-local variables) is regenerated on each upstream build, so nothing here
# may key on an identifier. Facts are anchored on literal strings that upstream
# ships for humans (error messages, zod .describe() text, enum members); the
# minified names that carry a fact are resolved from those anchors at runtime.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: extract-cc-facts.sh [--binary PATH] [--out PATH]

  --binary PATH  Claude Code executable to read (default: resolved `claude` on PATH)
  --out PATH     JSON destination (default: docs/claude-code-facts.json)

Exit 0 on success, 2 on a failed sanity check or missing tooling.
USAGE
}

die() {
  printf 'extract-cc-facts: %s\n' "$*" >&2
  exit 2
}

binary=""
out="docs/claude-code-facts.json"

while [ $# -gt 0 ]; do
  case "$1" in
  --binary)
    [ $# -ge 2 ] || die "--binary needs a path"
    binary="$2"
    shift 2
    ;;
  --out)
    [ $# -ge 2 ] || die "--out needs a path"
    out="$2"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *) die "unknown argument: $1" ;;
  esac
done

for tool in rg jq python3 strings; do
  command -v "$tool" >/dev/null 2>&1 || die "required tool not found: $tool"
done

if [ -z "$binary" ]; then
  claude_path="$(command -v claude || true)"
  [ -n "$claude_path" ] || die "no --binary given and no 'claude' on PATH"
  # The PATH entry is a launcher symlink; the bundle lives in the versions dir.
  binary="$(readlink -f "$claude_path" 2>/dev/null || printf '%s' "$claude_path")"
fi
[ -f "$binary" ] || die "not a file: $binary"

version_line="$("$binary" --version 2>/dev/null || true)"
version="$(printf '%s\n' "$version_line" | head -n 1 | sed -nE 's/^[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')"
[ -n "$version" ] || die "could not read a version from: $binary --version"

workdir="$(mktemp -d)"
cleanup() { rm -rf "$workdir"; }
trap cleanup EXIT

dump="$workdir/strings.txt"
strings -n 6 "$binary" >"$dump" || die "strings failed on: $binary"
[ -s "$dump" ] || die "empty strings dump for: $binary"

raw="$workdir/facts.raw.json"

python3 - "$dump" "$version" >"$raw" <<'PYTHON'
import json
import re
import sys

dump_path, version = sys.argv[1], sys.argv[2]
with open(dump_path, encoding="utf-8", errors="replace") as handle:
    blob = handle.read()

problems = []

# Minified function declarations, the anchor for every identifier lookup below.
DECL = re.compile(r"(?:async\s+)?function\s*\*?\s*([A-Za-z_$][\w$]*)\s*\(")
NEXT_DECL = re.compile(r"function\s*\*?\s*[A-Za-z_$][\w$]*\s*\(")


def array_literals(min_items, must_contain):
    """Distinct `["a","b",...]` literals holding every member of must_contain."""
    pattern = re.compile(r'\["[A-Za-z_][\w]*"(?:,"[A-Za-z_][\w]*"){%d,}\]' % (min_items - 1))
    found = []
    for match in pattern.finditer(blob):
        members = re.findall(r'"([^"]+)"', match.group(0))
        if all(name in members for name in must_contain) and members not in found:
            found.append(members)
    return found


def sole_literal(label, min_items, must_contain):
    found = array_literals(min_items, must_contain)
    if len(found) != 1:
        problems.append(
            "%s: expected exactly one array literal containing %s, found %d"
            % (label, ", ".join(must_contain), len(found))
        )
        return []
    return found[0]


# --- hook events -----------------------------------------------------------
# The canonical roster is the only literal naming the whole tool-call family
# plus MessageDisplay; shorter literals elsewhere are capability subsets.
event_candidates = array_literals(
    10, ["PreToolUse", "PostToolUse", "PostToolUseFailure", "PostToolBatch", "MessageDisplay"]
)
hook_events = max(event_candidates, key=len) if event_candidates else []
if not hook_events:
    problems.append("hook_events: no candidate array literal found")


# --- hook executors --------------------------------------------------------
# Two executors decide whether prompt/agent hooks can run at all. Each is found
# by the refusal message it raises, then by walking back to the nearest
# declaration whose parameter object carries both hookInput and sessionHooks.
def executor_root(marker):
    for hit in re.finditer(re.escape(marker), blob):
        start = hit.start()
        enclosing = None
        for decl in DECL.finditer(blob, max(0, start - 60000), start):
            head = blob[decl.end():decl.end() + 500]
            if "hookInput" in head and "sessionHooks" in head:
                enclosing = (decl.group(1), decl.end())
        if enclosing:
            return enclosing
    return (None, None)


in_repl, in_repl_pos = executor_root("no conversation context is available")
outside_repl, outside_repl_pos = executor_root("Prompt stop hooks are not yet supported outside REPL")
if not in_repl:
    problems.append("hook_event_dispatch: in-REPL executor not found")
if not outside_repl:
    problems.append("hook_event_dispatch: outside-REPL executor not found")


def declaration_body(pos):
    """Text from a declaration up to the next declaration keyword."""
    body = blob[pos:pos + 700]
    following = NEXT_DECL.search(body)
    return body[:following.start()] if following else body


def alias_closure(root_name, root_pos):
    """Names that forward their single argument straight to the executor.

    Callers reach the executor through a chain of pass-through generators, and
    the construction sites name the outermost link, not the executor itself.
    Search is bounded to the executor's own bundle region because short
    minified names repeat across unrelated scopes.
    """
    if not root_name:
        return set()
    low, high = max(0, root_pos - 50000), root_pos + 50000
    names = {root_name}
    for _ in range(8):
        alternation = "|".join(re.escape(n) for n in sorted(names, key=len, reverse=True))
        forwards = re.compile(r"\b(?:%s)\(\s*[A-Za-z_$][\w$]*\s*\)" % alternation)
        discovered = set()
        for decl in DECL.finditer(blob, low, high):
            name = decl.group(1)
            if name in names:
                continue
            if forwards.search(declaration_body(decl.end())):
                discovered.add(name)
        if not discovered:
            break
        names |= discovered
    return names


in_names = alias_closure(in_repl, in_repl_pos)
out_names = alias_closure(outside_repl, outside_repl_pos)

declarations = {}
for decl in DECL.finditer(blob):
    declarations.setdefault(decl.group(1), []).append(decl.end())

executor_call = None
if in_names or out_names:
    executor_call = re.compile(
        r"\b(%s)\s*\(" % "|".join(re.escape(n) for n in sorted(in_names | out_names, key=len, reverse=True))
    )


def dispatch_class(pos, depth=0):
    window = blob[pos:pos + 700]
    call = executor_call.search(window) if executor_call else None
    if call:
        if call.group(1) in out_names:
            return "outside-repl"
        # toolUseContext in the call's argument object is what makes
        # prompt/agent hooks legal for the event.
        arguments = window[call.end():call.end() + 500]
        return "conversation" if "toolUseContext" in arguments else "no-context"
    if depth < 2:
        # Some events hand off to a thin wrapper that calls an executor itself.
        handoff = re.search(r"\breturn\s+([A-Za-z_$][\w$]*)\s*\(", window)
        if handoff:
            for wrapper_pos in declarations.get(handoff.group(1), []):
                resolved = dispatch_class(wrapper_pos, depth + 1)
                if resolved:
                    return resolved
    return None


# Every event is built exactly once as `hook_event_name:"<Event>"`, except
# UserPromptSubmit which has a context-carrying path and a bare one.
classes = {}
for site in re.finditer(r'hook_event_name:"([A-Za-z]+)"', blob):
    classes.setdefault(site.group(1), set()).add(dispatch_class(site.end()))

hook_event_dispatch = {}
for event in hook_events:
    seen = classes.get(event, set())
    if "conversation" in seen:
        hook_event_dispatch[event] = "conversation"
    elif len(seen) == 1 and next(iter(seen)) is not None:
        hook_event_dispatch[event] = next(iter(seen))
    else:
        problems.append("hook_event_dispatch: no single dispatch class for %s (%r)" % (event, sorted(map(str, seen))))

unknown_sites = sorted(set(classes) - set(hook_events))
if unknown_sites:
    problems.append("hook_event_dispatch: construction sites for events absent from the roster: %s" % ", ".join(unknown_sites))


# --- hook types ------------------------------------------------------------
# The configurable hook kinds are the zod discriminators described as "... hook type".
hook_types = []
for match in re.finditer(r'type:[A-Za-z_$][\w$]*\("([a-z_]+)"\)\.describe\("[^"]*hook type"\)', blob):
    if match.group(1) not in hook_types:
        hook_types.append(match.group(1))
if len(hook_types) < 3:
    problems.append("hook_types: found %d, expected at least 3" % len(hook_types))

# The guard is a ternary whose condition names the excluded events; only the
# condition counts, since the filter body also compares a hook type to "http".
http_filter = re.search(
    r'((?:[A-Za-z_$][\w$]*\s*===\s*"[A-Za-z]+"\s*\|\|\s*)*[A-Za-z_$][\w$]*\s*===\s*"[A-Za-z]+")\s*\?'
    r"[^?]{0,400}HTTP hooks are not supported for",
    blob,
)
http_hook_unsupported_events = []
if http_filter:
    for name in re.findall(r'===\s*"([A-Za-z]+)"', http_filter.group(1)):
        if name not in http_hook_unsupported_events:
            http_hook_unsupported_events.append(name)
else:
    problems.append("http_hook_unsupported_events: guard for 'HTTP hooks are not supported for' not found")

mcp_tool_skipped = "mcp_tool hooks are not available for the '" in blob


# --- plugin userConfig schema ---------------------------------------------
user_config = {"types": [], "fields": {}, "required_fields": [], "key_pattern": ""}
schema = re.search(
    r'\[((?:"[a-z]+",)*"[a-z]+")\]\)\.describe\("Type of the configuration value"\),(.*?)\}\)\.strict\(\)',
    blob,
    re.DOTALL,
)
if schema:
    user_config["types"] = re.findall(r'"([a-z]+)"', schema.group(1))

    def top_level_fields(text):
        """Split a zod object body into (name, segment) at bracket depth zero."""
        starts, depth, index = [], 0, 0
        while index < len(text):
            char = text[index]
            if char in "([{":
                depth += 1
            elif char in ")]}":
                depth -= 1
            elif depth == 0:
                key = re.match(r"([A-Za-z_]\w*):", text[index:])
                if key and (index == 0 or text[index - 1] in ",{"):
                    starts.append((index, key.group(1)))
                    index += key.end() - 1
            index += 1
        for position, (offset, name) in enumerate(starts):
            end = starts[position + 1][0] if position + 1 < len(starts) else len(text)
            yield name, text[offset:end]

    fields = {"type": "Type of the configuration value"}
    required = ["type"]
    for name, segment in top_level_fields(schema.group(2)):
        described = re.search(r'\.describe\("((?:[^"\\]|\\.)*)"\)', segment)
        if not described:
            continue
        fields[name] = described.group(1).encode("utf-8").decode("unicode_escape")
        if ".optional()" not in segment:
            required.append(name)
    user_config["fields"] = fields
    user_config["required_fields"] = required
else:
    problems.append("user_config: zod option schema not found")

key_pattern = re.search(r'regex\(/([^/]+)/,\s*"Option keys must be valid identifiers', blob)
if key_pattern:
    user_config["key_pattern"] = key_pattern.group(1)
else:
    problems.append("user_config.key_pattern: option-key regex not found")


# --- enums -----------------------------------------------------------------
# Several literals spell the permission modes in different orders; the set is
# the fact, so the output is sorted and disagreement between them is an error.
permission_candidates = array_literals(4, ["dontAsk", "bypassPermissions", "auto"])
permission_modes = []
if not permission_candidates:
    problems.append("permission_modes: no candidate array literal found")
elif len({frozenset(c) for c in permission_candidates}) != 1:
    problems.append("permission_modes: candidate literals disagree: %r" % permission_candidates)
else:
    permission_modes = sorted(permission_candidates[0])

session_start_sources = sole_literal("session_start_sources", 4, ["startup", "compact", "fork"])
session_end_reasons = sole_literal("session_end_reasons", 4, ["prompt_input_exit", "logout"])
directory_added_sources = sole_literal("directory_added_sources", 2, ["register_repo_root"])


# --- plugin environment ----------------------------------------------------
plugin_env_vars = []
for match in re.finditer(r'\["\$\{CLAUDE_[A-Z_]+\}"(?:,"\$\{CLAUDE_[A-Z_]+\}")+\]', blob):
    names = re.findall(r"\$\{(CLAUDE_[A-Z_]+)\}", match.group(0))
    if len(names) > len(plugin_env_vars):
        plugin_env_vars = names
if not plugin_env_vars:
    problems.append("plugin_env_vars: no ${CLAUDE_*} array literal found")

option_prefix = re.search(r"\b(CLAUDE_[A-Z_]+_)<KEY> env vars", blob)
if not option_prefix:
    problems.append("plugin_option_env_prefix: '<KEY> env vars' marker not found")


# --- sanity checks ---------------------------------------------------------
if not 30 <= len(hook_events) <= 60:
    problems.append("hook_events: %d events, expected between 30 and 60" % len(hook_events))
for required_event in ("PreToolUse", "Stop", "SessionStart"):
    if required_event not in hook_events:
        problems.append("hook_events: %s missing" % required_event)
if len(permission_modes) < 5:
    problems.append("permission_modes: %d modes, expected at least 5" % len(permission_modes))
for name in http_hook_unsupported_events:
    if name not in hook_events:
        problems.append("http_hook_unsupported_events: %s is not a hook event" % name)
if "string" not in user_config["types"]:
    problems.append('user_config.types: "string" missing')

if problems:
    for problem in problems:
        sys.stderr.write("extract-cc-facts: %s\n" % problem)
    sys.exit(2)

json.dump(
    {
        "claude_code_version": version,
        "hook_events": hook_events,
        "hook_event_dispatch": hook_event_dispatch,
        "hook_types": hook_types,
        "http_hook_unsupported_events": http_hook_unsupported_events,
        "mcp_tool_skipped_without_mcp_context": mcp_tool_skipped,
        "user_config": user_config,
        "permission_modes": permission_modes,
        "session_start_sources": session_start_sources,
        "session_end_reasons": session_end_reasons,
        "directory_added_sources": directory_added_sources,
        "plugin_env_vars": plugin_env_vars,
        "plugin_option_env_prefix": option_prefix.group(1),
    },
    sys.stdout,
)
PYTHON

out_dir="$(dirname "$out")"
[ -d "$out_dir" ] || mkdir -p "$out_dir"
jq -S . "$raw" >"$out" || die "invalid JSON produced for: $out"
printf 'extract-cc-facts: wrote %s from Claude Code %s\n' "$out" "$version" >&2
