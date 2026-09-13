#!/usr/bin/env bash
# Compare plugin-dev documentation against facts extracted from the Claude Code
# binary (scripts/extract-cc-facts.sh). Each finding is one line:
#   DRIFT <check-id> <file>:<line> <message>
# Exit 0 = clean, 1 = drift found, 2 = tooling error.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FACTS="$REPO_ROOT/docs/claude-code-facts.json"
SKIP_VALIDATE=0
ONLY=""

usage() {
  cat <<'USAGE'
Usage: scripts/check-doc-drift.sh [options]

  --facts PATH      Facts JSON to check against (default docs/claude-code-facts.json)
  --skip-validate   Skip checks G and H, which shell out to the claude CLI
  --only A,B,...    Run only the listed checks (A-L)
  -h, --help        Show this message

Checks: A event-table, B event-sections, C event-counts, D script-allowlist,
E ci-allowlist, F enums, G userconfig-validate, H manifest-examples-validate,
I paths, J denylist, K removed-events, L version-sync.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
  --facts)
    [ $# -ge 2 ] || {
      echo "check-doc-drift: --facts needs a path" >&2
      exit 2
    }
    FACTS="$2"
    shift 2
    ;;
  --facts=*)
    FACTS="${1#--facts=}"
    shift
    ;;
  --skip-validate)
    SKIP_VALIDATE=1
    shift
    ;;
  --only)
    [ $# -ge 2 ] || {
      echo "check-doc-drift: --only needs a check list" >&2
      exit 2
    }
    ONLY="$2"
    shift 2
    ;;
  --only=*)
    ONLY="${1#--only=}"
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "check-doc-drift: unknown argument '$1'" >&2
    usage >&2
    exit 2
    ;;
  esac
done

for tool in rg jq python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "check-doc-drift: required tool '$tool' not found on PATH" >&2
    exit 2
  fi
done

if [ ! -f "$FACTS" ]; then
  echo "check-doc-drift: facts file not found: $FACTS" >&2
  echo "check-doc-drift: generate it with scripts/extract-cc-facts.sh" >&2
  exit 2
fi

if ! jq empty "$FACTS" >/dev/null 2>&1; then
  echo "check-doc-drift: facts file is not valid JSON: $FACTS" >&2
  exit 2
fi

if [ "$SKIP_VALIDATE" -eq 0 ] && ! command -v claude >/dev/null 2>&1; then
  echo "check-doc-drift: 'claude' CLI not found; rerun with --skip-validate to skip checks G and H" >&2
  exit 2
fi

export DRIFT_REPO_ROOT="$REPO_ROOT"
export DRIFT_FACTS="$FACTS"
export DRIFT_SKIP_VALIDATE="$SKIP_VALIDATE"
export DRIFT_ONLY="$ONLY"

python3 <<'PYTHON'
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(os.environ["DRIFT_REPO_ROOT"])
SKIP_VALIDATE = os.environ["DRIFT_SKIP_VALIDATE"] == "1"
ONLY = {c.strip().upper() for c in os.environ["DRIFT_ONLY"].split(",") if c.strip()}
ALL_CHECKS = list("ABCDEFGHIJKL")

with open(os.environ["DRIFT_FACTS"]) as fh:
    FACTS = json.load(fh)

SKILL = REPO / "plugins/plugin-dev/skills/plugin-dev"
HOOK_DEV = SKILL / "references/hook-development"
OVERVIEW = HOOK_DEV / "overview.md"
EVENT_SCHEMAS = HOOK_DEV / "references/event-schemas.md"
VALIDATE_SH = HOOK_DEV / "scripts/validate-hook-schema.sh"
PERMISSION_MODES_DOC = SKILL / "references/agent-development/references/permission-modes-rules.md"
CI_WORKFLOW = REPO / ".github/workflows/component-validation.yml"
PLUGIN_STRUCTURE = SKILL / "references/plugin-structure"

EVENTS = list(FACTS["hook_events"])
EVENT_SET = set(EVENTS)
DISPATCH = FACTS["hook_event_dispatch"]
HTTP_UNSUPPORTED = set(FACTS["http_hook_unsupported_events"])

findings = []
errors = []


def rel(path):
    try:
        return str(Path(path).resolve().relative_to(REPO))
    except ValueError:
        return str(path)


def report(check, path, line, message):
    findings.append((check, rel(path), int(line), message))


def enabled(check):
    return not ONLY or check in ONLY


def read_lines(path):
    return Path(path).read_text(encoding="utf-8").splitlines()


def sorted_join(values):
    return ", ".join(sorted(values))


# ---------------------------------------------------------------- shared parsing

TABLE_HEADER_RE = re.compile(r"^\|\s*Event\s*\|")
# A heading is an event heading when its only word is a CamelCase name, with an
# optional "(CC x.y.z)" version note that documents when the event shipped.
EVENT_HEADING_RE = re.compile(r"^###\s+([A-Z][A-Za-z0-9]+)\s*(?:\(CC\s+[0-9.]+\))?\s*$")


def parse_event_table():
    """Rows of the Hook Events Reference table as (line_no, event, types_cell)."""
    lines = read_lines(OVERVIEW)
    rows = []
    header_line = None
    in_table = False
    for idx, line in enumerate(lines, start=1):
        if TABLE_HEADER_RE.match(line):
            header_line = idx
            in_table = True
            continue
        if in_table:
            if not line.startswith("|"):
                break
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if not cells or set(cells[0]) <= set("- :"):
                continue
            rows.append((idx, cells[0], cells[-1]))
    return header_line, rows


def expected_types_cell(event):
    if DISPATCH.get(event) == "conversation":
        return "All"
    if event in HTTP_UNSUPPORTED:
        return "Command"
    return "Command, HTTP"


def event_headings():
    """(line_no, name) for every `### <Event>`-shaped heading in event-schemas.md."""
    out = []
    for idx, line in enumerate(read_lines(EVENT_SCHEMAS), start=1):
        m = EVENT_HEADING_RE.match(line)
        if m:
            out.append((idx, m.group(1)))
    return out


def markdown_files(root):
    return sorted(p for p in Path(root).rglob("*.md"))


# ---------------------------------------------------------------- A. event-table

def check_event_table():
    header_line, rows = parse_event_table()
    if header_line is None:
        report("A", OVERVIEW, 1, "Hook Events Reference table not found")
        return
    seen = {}
    for line_no, event, types_cell in rows:
        if event in seen:
            report("A", OVERVIEW, line_no, f"duplicate table row for event {event}")
            continue
        seen[event] = (line_no, types_cell)
        if event not in EVENT_SET:
            report("A", OVERVIEW, line_no, f"table row names unknown event {event}")
            continue
        expected = expected_types_cell(event)
        if types_cell != expected:
            report(
                "A", OVERVIEW, line_no,
                f"{event} Types cell is '{types_cell}', expected '{expected}' "
                f"(dispatch={DISPATCH.get(event)})",
            )
    for event in EVENTS:
        if event not in seen:
            report("A", OVERVIEW, header_line, f"table has no row for event {event}")


# ------------------------------------------------------------- B. event-sections

def check_event_sections():
    documented = {name: line for line, name in event_headings()}
    for event in EVENTS:
        if event not in documented:
            report("B", EVENT_SCHEMAS, 1, f"no `### {event}` section for event {event}")
    for name, line in documented.items():
        if name not in EVENT_SET:
            report("B", EVENT_SCHEMAS, line, f"`### {name}` section names unknown event {name}")


# --------------------------------------------------------------- C. event-counts

COUNT_RE = re.compile(r"\b(\d+) (?:hook )?events\b")
# Counts of Claude Code SDK-typed events are unrelated to the hook event total.
COUNT_EXEMPT_SUBSTRINGS = (
    "events are untyped there",
)


def check_event_counts():
    dispatch_sizes = {}
    for cls in set(DISPATCH.values()):
        dispatch_sizes[cls] = sum(1 for v in DISPATCH.values() if v == cls)
    # Docs also group the two classes that lack a conversation into one number.
    no_conversation = dispatch_sizes.get("no-context", 0) + dispatch_sizes.get("outside-repl", 0)
    allowed = {len(EVENTS), no_conversation} | set(dispatch_sizes.values())
    for path in markdown_files(SKILL):
        for idx, line in enumerate(read_lines(path), start=1):
            if any(s in line for s in COUNT_EXEMPT_SUBSTRINGS):
                continue
            for m in COUNT_RE.finditer(line):
                count = int(m.group(1))
                if count not in allowed:
                    report(
                        "C", path, idx,
                        f"'{m.group(0)}' does not match {len(EVENTS)} events "
                        f"or a dispatch class size ({sorted_join(str(c) for c in allowed)})",
                    )


# ------------------------------------------------------------ D. script-allowlist

def check_script_allowlist():
    text = Path(VALIDATE_SH).read_text(encoding="utf-8")
    lines = text.splitlines()
    m = re.search(r"^VALID_EVENTS=\((.*?)\)\s*$", text, re.M | re.S)
    if not m:
        report("D", VALIDATE_SH, 1, "VALID_EVENTS array not found")
        return
    decl_line = text[: m.start()].count("\n") + 1
    listed = set(re.findall(r'"([^"]+)"', m.group(1)))
    for event in sorted(EVENT_SET - listed):
        report("D", VALIDATE_SH, decl_line, f"VALID_EVENTS is missing event {event}")
    for event in sorted(listed - EVENT_SET):
        report("D", VALIDATE_SH, decl_line, f"VALID_EVENTS names unknown event {event}")

    # The hook-type support switch: each arm lists events, then restricts the
    # hook types they accept. Derive the expected event set from the arm's types.
    arm_re = re.compile(
        r"^\s{6}((?:[A-Za-z]+(?:\s*\|\s*)?|\\\s*\n\s*)+?)\)\s*\n"
        r"\s+case \"\$hook_type\" in\s*\n"
        r"\s+([a-z_ |]+)\)\s*;;",
        re.M,
    )
    arms = list(arm_re.finditer(text))
    if not arms:
        report("D", VALIDATE_SH, decl_line, "hook-type support switch arms not found")
        return
    for arm in arms:
        arm_line = text[: arm.start()].count("\n") + 1
        arm_events = set(re.findall(r"[A-Za-z]+", arm.group(1)))
        arm_types = set(re.findall(r"[a-z_]+", arm.group(2)))
        accepts_http = "http" in arm_types
        expected = {
            e for e in EVENTS
            if DISPATCH.get(e) != "conversation"
            and (e not in HTTP_UNSUPPORTED) == accepts_http
        }
        for event in sorted(expected - arm_events):
            report(
                "D", VALIDATE_SH, arm_line,
                f"hook-type switch arm ({sorted_join(arm_types)}) is missing event {event}",
            )
        for event in sorted(arm_events - expected):
            report(
                "D", VALIDATE_SH, arm_line,
                f"hook-type switch arm ({sorted_join(arm_types)}) should not list {event} "
                f"(dispatch={DISPATCH.get(event, 'unknown event')})",
            )


# ---------------------------------------------------------------- E. ci-allowlist

def check_ci_allowlist():
    for idx, line in enumerate(read_lines(CI_WORKFLOW), start=1):
        if "Event types are valid:" not in line:
            continue
        listed = {t.strip() for t in line.split("Event types are valid:", 1)[1].split(",")}
        listed.discard("")
        for event in sorted(EVENT_SET - listed):
            report("E", CI_WORKFLOW, idx, f"event checklist is missing event {event}")
        for event in sorted(listed - EVENT_SET):
            report("E", CI_WORKFLOW, idx, f"event checklist names unknown event {event}")
        return
    report("E", CI_WORKFLOW, 1, "'Event types are valid:' checklist line not found")


# ---------------------------------------------------------------------- F. enums

def section_bounds(lines, event):
    start = None
    for idx, line in enumerate(lines):
        m = EVENT_HEADING_RE.match(line)
        if m and m.group(1) == event:
            start = idx
            continue
        if start is not None and EVENT_HEADING_RE.match(line):
            return start, idx
    if start is None:
        return None
    return start, len(lines)


ENUM_VALUE_RE = re.compile(r"[A-Za-z_][A-Za-z_]*")


def check_enum_in_section(event, field, fact_key):
    expected = set(FACTS[fact_key])
    lines = read_lines(EVENT_SCHEMAS)
    bounds = section_bounds(lines, event)
    if bounds is None:
        report("F", EVENT_SCHEMAS, 1, f"no `### {event}` section to check {fact_key}")
        return
    start, end = bounds
    enum_lines = []
    for offset in range(start, end):
        line = lines[offset]
        m = re.search(rf'"{field}":\s*"([a-z_|]+)"', line)
        if m and "|" in m.group(1):
            enum_lines.append((offset + 1, set(m.group(1).split("|"))))
        if line.startswith("**Matchers:**"):
            values = set(ENUM_VALUE_RE.findall(line.split("**Matchers:**", 1)[1]))
            enum_lines.append((offset + 1, values))
    if not enum_lines:
        report("F", EVENT_SCHEMAS, start + 1, f"no {field} enum line found in {event} section")
        return
    for line_no, values in enum_lines:
        for value in sorted(expected - values):
            report("F", EVENT_SCHEMAS, line_no, f"{event} {field} enum is missing '{value}'")
        for value in sorted(values - expected):
            report("F", EVENT_SCHEMAS, line_no, f"{event} {field} enum has unknown value '{value}'")


def check_permission_modes():
    expected = set(FACTS["permission_modes"])
    for idx, line in enumerate(read_lines(EVENT_SCHEMAS), start=1):
        m = re.search(r'"permission_mode":\s*"([A-Za-z|]+)"', line)
        if not m or "|" not in m.group(1):
            continue
        values = set(m.group(1).split("|"))
        for value in sorted(expected - values):
            report("F", EVENT_SCHEMAS, idx, f"permission_mode enum is missing '{value}'")
        for value in sorted(values - expected):
            report("F", EVENT_SCHEMAS, idx, f"permission_mode enum has unknown value '{value}'")

    lines = read_lines(PERMISSION_MODES_DOC)
    documented = {}
    in_table = False
    for idx, line in enumerate(lines, start=1):
        if line.startswith("| Mode"):
            in_table = True
            continue
        if in_table:
            if not line.startswith("|"):
                in_table = False
                continue
            cell = line.strip().strip("|").split("|")[0].strip()
            if set(cell) <= set("- :"):
                continue
            documented[cell.strip("`")] = idx
    if not documented:
        report("F", PERMISSION_MODES_DOC, 1, "permission modes table not found")
        return
    for mode in sorted(expected - set(documented)):
        report("F", PERMISSION_MODES_DOC, 1, f"permission modes table is missing '{mode}'")
    for mode, idx in sorted(documented.items()):
        if mode not in expected:
            report("F", PERMISSION_MODES_DOC, idx, f"permission modes table has unknown mode '{mode}'")


def check_enums():
    check_enum_in_section("SessionStart", "source", "session_start_sources")
    check_enum_in_section("SessionEnd", "reason", "session_end_reasons")
    check_enum_in_section("DirectoryAdded", "source", "directory_added_sources")
    check_permission_modes()


# ---------------------------------------------- G/H. manifest examples validation

FENCE_RE = re.compile(r"```json\n(.*?)```", re.S)
# `//` that starts a line comment rather than a URL scheme or a path separator.
LINE_COMMENT_RE = re.compile(r"(?<![:/])//(?!/)\s*(.*)$")


def strip_json_comments(body):
    """Remove `//` line comments outside strings; return (clean, comment_texts)."""
    clean_lines = []
    comments = []
    for line in body.splitlines():
        in_string = False
        escaped = False
        cut = None
        for i, ch in enumerate(line):
            if escaped:
                escaped = False
                continue
            if ch == "\\":
                escaped = True
                continue
            if ch == '"':
                in_string = not in_string
                continue
            if not in_string and ch == "/" and line[i : i + 2] == "//":
                cut = i
                break
        if cut is None:
            clean_lines.append(line)
        else:
            comments.append(line[cut + 2 :].strip())
            clean_lines.append(line[:cut].rstrip())
    return "\n".join(clean_lines), comments


def json_fences(path):
    text = Path(path).read_text(encoding="utf-8")
    for m in FENCE_RE.finditer(text):
        yield text[: m.start()].count("\n") + 1, m.group(1)


def run_plugin_validate(manifest, check, path, line):
    workdir = tempfile.mkdtemp(prefix="drift-validate-")
    try:
        plugin_dir = Path(workdir) / ".claude-plugin"
        plugin_dir.mkdir()
        (plugin_dir / "plugin.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
        proc = subprocess.run(
            ["claude", "plugin", "validate", workdir],
            capture_output=True, text=True, timeout=120,
        )
    except (OSError, subprocess.SubprocessError) as exc:
        errors.append(f"check {check}: running 'claude plugin validate' failed: {exc}")
        return
    finally:
        shutil.rmtree(workdir, ignore_errors=True)
    output = proc.stdout + proc.stderr
    if "Invalid input" not in output and "Validation failed" not in output:
        return
    problems = []
    for raw in output.splitlines():
        text = raw.strip()
        if not (text.startswith("❯") or "Invalid input" in text):
            continue
        text = text.lstrip("❯").strip()
        # The example is validated on its own, without the plugin tree it
        # describes, so missing component directories say nothing about drift.
        if "Path not found" in text:
            continue
        problems.append(text)
    if not problems:
        return
    report(
        check, path, line,
        "claude plugin validate rejects this example: " + " | ".join(problems),
    )


def candidate_manifest(body):
    """Parsed manifest for a fence, or None when the fence is not a plugin.json."""
    clean, comments = strip_json_comments(body)
    # Fences annotated with ❌ demonstrate invalid manifests on purpose.
    if any("❌" in c for c in comments):
        return None
    try:
        data = json.loads(clean)
    except json.JSONDecodeError:
        return None
    if not isinstance(data, dict):
        return None
    return data


def as_plugin_manifest(data):
    manifest = dict(data)
    manifest.setdefault("name", "drift-check-plugin")
    manifest.setdefault("version", "1.0.0")
    manifest.setdefault("description", "Documentation example under drift check")
    return manifest


def check_userconfig_validate():
    for path in markdown_files(PLUGIN_STRUCTURE):
        for line, body in json_fences(path):
            if "userConfig" not in body:
                continue
            data = candidate_manifest(body)
            if data is None or "userConfig" not in data:
                continue
            run_plugin_validate(as_plugin_manifest(data), "G", path, line)


def check_manifest_examples_validate():
    targets = [PLUGIN_STRUCTURE / "references/manifest-reference.md"]
    targets += sorted((PLUGIN_STRUCTURE / "examples").glob("*.md"))
    for path in targets:
        for line, body in json_fences(path):
            data = candidate_manifest(body)
            if data is None or not isinstance(data.get("name"), str):
                continue
            if "userConfig" in data:
                continue  # already covered by check G
            run_plugin_validate(as_plugin_manifest(data), "H", path, line)


# ---------------------------------------------------------------------- I. paths

# A whole inline-code token that addresses a bundled reference, example, or
# script. Anchored end to end so a path fragment inside a longer string is not
# mistaken for a link the document is making.
PATH_TOKEN_RE = re.compile(
    r"^(?:\.\./|\./)*(?:[A-Za-z0-9_-]+/)*(?:references|examples|scripts)/[A-Za-z0-9_./-]+$"
)
LINK_RE = re.compile(r"\]\(([^)\s]+)\)")
INLINE_CODE_RE = re.compile(r"`([^`\n]+)`")
FENCE_MARKER_RE = re.compile(r"^\s*(```|~~~)")


def load_list_file(path):
    entries = []
    if not Path(path).exists():
        return entries
    for line in read_lines(path):
        line = line.split("#", 1)[0].strip() if line.lstrip().startswith("#") else line
        line = line.split(" #", 1)[0].strip()
        if line:
            entries.append(line)
    return entries


def parse_allowlist():
    """Entries as (document_glob_or_None, target_glob)."""
    entries = []
    for raw in load_list_file(REPO / "scripts/drift-allowlist.txt"):
        parts = raw.split()
        if len(parts) == 1:
            entries.append((None, parts[0]))
        else:
            entries.append((parts[0], parts[1]))
    return entries


def check_paths():
    import fnmatch

    allow = parse_allowlist()
    for path in markdown_files(SKILL):
        base = path.parent
        in_fence = False
        for idx, line in enumerate(read_lines(path), start=1):
            if FENCE_MARKER_RE.match(line):
                in_fence = not in_fence
            targets = set()
            for m in LINK_RE.finditer(line):
                target = m.group(1)
                if re.match(r"^[a-z][a-z0-9+.-]*:", target) or target.startswith("#"):
                    continue
                targets.add(target)
            # Inside a fence, backticks are literal sample content rather than
            # inline code, so only the document's own links are checked there.
            if not in_fence:
                for token in INLINE_CODE_RE.findall(line):
                    if PATH_TOKEN_RE.match(token):
                        targets.add(token)
            for target in sorted(targets):
                clean = target.split("#", 1)[0].rstrip(".,;:").strip()
                if not clean:
                    continue
                doc = rel(path)
                if any(
                    (doc_glob is None or fnmatch.fnmatch(doc, doc_glob))
                    and (clean == target_glob or fnmatch.fnmatch(clean, target_glob))
                    for doc_glob, target_glob in allow
                ):
                    continue
                if (base / clean).exists():
                    continue
                report("I", path, idx, f"relative path '{clean}' does not resolve")


# ------------------------------------------------------------------- J. denylist

def check_denylist():
    names = load_list_file(REPO / "scripts/drift-denylist.txt")
    if not names:
        errors.append("check J: scripts/drift-denylist.txt is empty or missing")
        return
    scopes = [str(REPO / "plugins"), str(REPO / ".github")]
    for name in names:
        proc = subprocess.run(
            ["rg", "--fixed-strings", "--line-number", "--no-heading", "--", name, *scopes],
            capture_output=True, text=True,
        )
        if proc.returncode not in (0, 1):
            errors.append(f"check J: rg failed for '{name}': {proc.stderr.strip()}")
            continue
        for hit in proc.stdout.splitlines():
            parts = hit.split(":", 2)
            if len(parts) < 3:
                continue
            report("J", parts[0], parts[1], f"removed or non-existent name '{name}' appears here")


# ------------------------------------------------------------- K. removed-events

def check_removed_events():
    for line, name in event_headings():
        if name not in EVENT_SET:
            report("K", EVENT_SCHEMAS, line, f"`### {name}` documents an event that no longer exists")
    _, rows = parse_event_table()
    for line_no, event, _types in rows:
        if event not in EVENT_SET:
            report("K", OVERVIEW, line_no, f"table row documents an event that no longer exists: {event}")


# --------------------------------------------------------------- L. version-sync

def check_version_sync():
    plugin_json = REPO / "plugins/plugin-dev/.claude-plugin/plugin.json"
    marketplace_json = REPO / ".claude-plugin/marketplace.json"
    claude_md = REPO / "CLAUDE.md"

    versions = {}
    with open(plugin_json) as fh:
        versions[str(plugin_json)] = (json.load(fh).get("version"), 1)

    with open(marketplace_json) as fh:
        marketplace = json.load(fh)
    metadata_version = marketplace.get("metadata", {}).get("version")
    if metadata_version is not None:
        versions[f"{marketplace_json}#metadata"] = (metadata_version, 1)
    for entry in marketplace.get("plugins", []):
        if entry.get("name") == "plugin-dev":
            versions[f"{marketplace_json}#plugins"] = (entry.get("version"), 1)

    claude_version, claude_line = None, 1
    for idx, line in enumerate(read_lines(claude_md), start=1):
        m = re.search(r"\*\*Version\*\*:\s*v?([0-9][0-9A-Za-z.+-]*)", line)
        if m:
            claude_version, claude_line = m.group(1), idx
            break
    versions[str(claude_md)] = (claude_version, claude_line)

    distinct = {v for v, _ in versions.values()}
    if len(distinct) > 1:
        reference = versions[str(plugin_json)][0]
        for where, (value, line) in sorted(versions.items()):
            if value != reference:
                path, _, anchor = where.partition("#")
                suffix = f" ({anchor})" if anchor else ""
                report(
                    "L", path, line,
                    f"version{suffix} is '{value}' but plugin.json declares '{reference}'",
                )


# ------------------------------------------------------------------------ driver

CHECKS = {
    "A": ("event-table", check_event_table),
    "B": ("event-sections", check_event_sections),
    "C": ("event-counts", check_event_counts),
    "D": ("script-allowlist", check_script_allowlist),
    "E": ("ci-allowlist", check_ci_allowlist),
    "F": ("enums", check_enums),
    "G": ("userconfig-validate", check_userconfig_validate),
    "H": ("manifest-examples-validate", check_manifest_examples_validate),
    "I": ("paths", check_paths),
    "J": ("denylist", check_denylist),
    "K": ("removed-events", check_removed_events),
    "L": ("version-sync", check_version_sync),
}

unknown = ONLY - set(ALL_CHECKS)
if unknown:
    print(f"check-doc-drift: unknown check(s) in --only: {sorted_join(unknown)}", file=sys.stderr)
    sys.exit(2)

ran = []
for check in ALL_CHECKS:
    if not enabled(check):
        continue
    if check in ("G", "H") and SKIP_VALIDATE:
        continue
    ran.append(check)
    try:
        CHECKS[check][1]()
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        errors.append(f"check {check} ({CHECKS[check][0]}): {type(exc).__name__}: {exc}")

for check, path, line, message in sorted(findings):
    print(f"DRIFT {check} {path}:{line} {message}")

for message in errors:
    print(f"check-doc-drift: {message}", file=sys.stderr)

scope = "".join(ran) if ran else "none"
print(f"check-doc-drift: {len(findings)} finding(s) across checks {scope}")

if errors:
    sys.exit(2)
sys.exit(1 if findings else 0)
PYTHON
