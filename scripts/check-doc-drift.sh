#!/usr/bin/env bash
# Compare plugin-dev documentation against facts extracted from the Claude Code
# binary (scripts/extract-cc-facts.sh). stdout carries findings and nothing
# else, one per line, so it can be redirected straight into a report file:
#   DRIFT <check-id> <file>:<line> <message>
# Diagnostics and the summary count go to stderr, where a check that could not
# run is named as `ERROR <check-id> <message>`.
# Exit 0 = clean, 1 = every selected check ran and at least one found drift,
# 2 = the run could not reach a verdict.
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
  --only A,B,...    Run only the listed checks (letters below)
  -h, --help        Show this message

Checks: A event-table, B event-sections, C event-counts, D script-allowlist,
E ci-allowlist, F enums, G userconfig-validate, H manifest-examples-validate,
I paths, J denylist, L version-sync, M userconfig-fields, N env-vars.

Selecting only G and/or H together with --skip-validate leaves nothing to run
and is rejected.
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

# Every check runs on bash and python3 alone; checks G and H additionally shell
# out to the claude CLI. Nothing here needs ripgrep, which is absent from
# GitHub's ubuntu-24.04 runner image.
if ! command -v python3 >/dev/null 2>&1; then
  echo "check-doc-drift: required tool 'python3' not found on PATH" >&2
  exit 2
fi

# The facts file is read once, by the checker itself: --facts accepts a process
# substitution, which a preflight read here would drain.

# Only checks G and H shell out to the CLI, so a host without it can still run
# every other check as long as G/H were not asked for.
needs_claude=0
if [ "$SKIP_VALIDATE" -eq 0 ]; then
  if [ -z "$ONLY" ]; then
    needs_claude=1
  else
    case ",${ONLY//[[:space:]]/}," in
    *,[gG],* | *,[hH],*) needs_claude=1 ;;
    esac
  fi
fi

if [ "$needs_claude" -eq 1 ] && ! command -v claude >/dev/null 2>&1; then
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
ALL_CHECKS = list("ABCDEFGHIJLMN")

FACTS_PATH = os.environ["DRIFT_FACTS"]


def fail_tooling(*messages):
    for message in messages:
        print(f"check-doc-drift: {message}", file=sys.stderr)
    sys.exit(2)


# Facts the checks read directly. A file missing any of them cannot produce a
# verdict, so it is rejected before a check runs rather than crashing one.
REQUIRED_FACT_LISTS = (
    "hook_events",
    "hook_types",
    "http_hook_unsupported_events",
    "permission_modes",
    "session_start_sources",
    "session_end_reasons",
    "directory_added_sources",
    "plugin_env_vars",
)
DISPATCH_CLASSES = frozenset({"conversation", "no-context", "outside-repl"})
# The userConfig option schema the M check reads out of the manifest reference.
REQUIRED_USER_CONFIG_LISTS = ("types", "required_fields")


def load_facts(path):
    try:
        with open(path) as fh:
            data = json.load(fh)
    except (OSError, json.JSONDecodeError) as exc:
        fail_tooling(
            f"facts file {path} could not be read: {exc}",
            "generate it with scripts/extract-cc-facts.sh",
        )
    if not isinstance(data, dict):
        fail_tooling(f"facts file {path} is not a JSON object")

    problems = []
    for key in REQUIRED_FACT_LISTS:
        value = data.get(key)
        if not isinstance(value, list) or not value:
            problems.append(f"'{key}' must be a non-empty array")
        elif not all(isinstance(v, str) for v in value):
            problems.append(f"'{key}' must contain only strings")
    dispatch = data.get("hook_event_dispatch")
    if not isinstance(dispatch, dict) or not dispatch:
        problems.append("'hook_event_dispatch' must be a non-empty object")
        dispatch = {}
    else:
        bad = sorted(k for k, v in dispatch.items() if v not in DISPATCH_CLASSES)
        if bad:
            problems.append(
                "'hook_event_dispatch' has values outside "
                f"{sorted(DISPATCH_CLASSES)} for: {', '.join(bad)}"
            )
    if not problems:
        events = set(data["hook_events"])
        missing = sorted(events - set(dispatch))
        if missing:
            problems.append(
                "'hook_event_dispatch' has no class for: " + ", ".join(missing)
            )
        stray = sorted(set(dispatch) - events)
        if stray:
            problems.append(
                "'hook_event_dispatch' names events absent from 'hook_events': "
                + ", ".join(stray)
            )
        unknown_http = sorted(set(data["http_hook_unsupported_events"]) - events)
        if unknown_http:
            problems.append(
                "'http_hook_unsupported_events' names events absent from "
                "'hook_events': " + ", ".join(unknown_http)
            )

    user_config = data.get("user_config")
    if not isinstance(user_config, dict) or not user_config:
        problems.append("'user_config' must be a non-empty object")
    else:
        fields = user_config.get("fields")
        if not isinstance(fields, dict) or not fields:
            problems.append("'user_config.fields' must be a non-empty object")
        for key in REQUIRED_USER_CONFIG_LISTS:
            value = user_config.get(key)
            if not isinstance(value, list) or not value:
                problems.append(f"'user_config.{key}' must be a non-empty array")
            elif not all(isinstance(v, str) for v in value):
                problems.append(f"'user_config.{key}' must contain only strings")
        if not isinstance(user_config.get("key_pattern"), str):
            problems.append("'user_config.key_pattern' must be a string")

    if not isinstance(data.get("plugin_option_env_prefix"), str) or not data["plugin_option_env_prefix"]:
        problems.append("'plugin_option_env_prefix' must be a non-empty string")

    if problems:
        fail_tooling(
            *(f"facts file {path} is unusable: {problem}" for problem in problems)
        )
    return data


FACTS = load_facts(FACTS_PATH)

SKILL = REPO / "plugins/plugin-dev/skills/plugin-dev"
HOOK_DEV = SKILL / "references/hook-development"
OVERVIEW = HOOK_DEV / "overview.md"
EVENT_SCHEMAS = HOOK_DEV / "references/event-schemas.md"
VALIDATE_SH = HOOK_DEV / "scripts/validate-hook-schema.sh"
PERMISSION_MODES_DOC = SKILL / "references/agent-development/references/permission-modes-rules.md"
CI_WORKFLOW = REPO / ".github/workflows/component-validation.yml"
PLUGIN_STRUCTURE = SKILL / "references/plugin-structure"
MANIFEST_REFERENCE = PLUGIN_STRUCTURE / "references/manifest-reference.md"
PLUGIN_STRUCTURE_OVERVIEW = PLUGIN_STRUCTURE / "overview.md"

EVENTS = list(FACTS["hook_events"])
EVENT_SET = set(EVENTS)
DISPATCH = FACTS["hook_event_dispatch"]
HTTP_UNSUPPORTED = set(FACTS["http_hook_unsupported_events"])
USER_CONFIG = FACTS["user_config"]

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

# A whole inline-code span. Checks F and I both read documents one token at a
# time: enum members and path links are written as inline code, so prose around
# them never reaches the value being judged.
INLINE_CODE_RE = re.compile(r"`([^`\n]+)`")

TABLE_HEADER_RE = re.compile(r"^\|\s*Event\s*\|")
EVENT_TABLE_HEADING_RE = re.compile(r"^#+\s+Hook Events Reference\s*$")
# A heading is an event heading when its only word is a CamelCase name, with an
# optional "(CC x.y.z)" version note that documents when the event shipped.
EVENT_HEADING_RE = re.compile(r"^###\s+([A-Z][A-Za-z0-9]+)\s*(?:\(CC\s+[0-9.]+\))?\s*$")


def parse_event_table():
    """Rows of the Hook Events Reference table as (line_no, event, types_cell)."""
    lines = read_lines(OVERVIEW)
    rows = []
    header_line = None
    in_table = False
    # Other tables in the document also lead with an Event column, so the
    # roster is the one under its own heading, or failing that the one whose
    # header carries the Types column this check reads.
    under_heading = False
    for idx, line in enumerate(lines, start=1):
        if line.startswith("#"):
            under_heading = bool(EVENT_TABLE_HEADING_RE.match(line))
        if header_line is None and TABLE_HEADER_RE.match(line):
            if not (under_heading or "Types" in line):
                continue
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


# Two independent facts decide what an event accepts: whether it is dispatched
# with a conversation (prompt and agent hooks) and whether HTTP hooks are
# filtered out for it. The remaining types run on every event.
ALL_HOOK_TYPES = frozenset(FACTS["hook_types"])
# The roster the capability rules below encode. A type outside it has no rule,
# so the rules stop being a sound basis for a verdict and check A says so.
MODELLED_HOOK_TYPES = frozenset({"command", "mcp_tool", "http", "prompt", "agent"})
CONVERSATION_HOOK_TYPES = frozenset({"prompt", "agent"})
HTTP_HOOK_TYPES = frozenset({"http"})
UNIVERSAL_HOOK_TYPES = ALL_HOOK_TYPES - CONVERSATION_HOOK_TYPES - HTTP_HOOK_TYPES
HOOK_TYPES_MODELLED = ALL_HOOK_TYPES == MODELLED_HOOK_TYPES
TYPES_CELL_TEXT = {
    (True, True): "All",
    (True, False): "Command, MCP tool, Prompt, Agent",
    (False, True): "Command, HTTP",
    (False, False): "Command",
}


def event_capability(event):
    """(Types-cell text, accepted hook types) for an event, from the facts.

    Checks A and D both read this so the table and the validator script can
    never be judged against different rules.
    """
    conversation = DISPATCH.get(event) == "conversation"
    http_ok = event not in HTTP_UNSUPPORTED
    types = set(UNIVERSAL_HOOK_TYPES)
    if conversation:
        types |= ALL_HOOK_TYPES & CONVERSATION_HOOK_TYPES
    if http_ok:
        types |= ALL_HOOK_TYPES & HTTP_HOOK_TYPES
    return TYPES_CELL_TEXT[(conversation, http_ok)], frozenset(types)


def check_hook_types():
    """Guard the hook-type roster the capability rules are written against.

    Reported under A because the Types cells it judges spell the roster out.
    """
    added = sorted(ALL_HOOK_TYPES - MODELLED_HOOK_TYPES)
    dropped = sorted(MODELLED_HOOK_TYPES - ALL_HOOK_TYPES)
    parts = []
    if added:
        parts.append("new type(s) " + ", ".join(added))
    if dropped:
        parts.append("retired type(s) " + ", ".join(dropped))
    report(
        "A", FACTS_PATH, 1,
        "hook types changed: " + "; ".join(parts) + " — the Types column rules "
        f"cover {sorted_join(MODELLED_HOOK_TYPES)}; update them and the docs together",
    )


def expected_types_cell(event):
    return event_capability(event)[0]


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
    if not HOOK_TYPES_MODELLED:
        check_hook_types()
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
            report(
                "A", OVERVIEW, line_no,
                f"table row documents an event that no longer exists: {event}",
            )
            continue
        if not HOOK_TYPES_MODELLED:
            # The Types cell spells out a roster the facts no longer agree with,
            # so comparing cells would report noise on top of the real drift.
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
            report(
                "B", EVENT_SCHEMAS, line,
                f"`### {name}` documents an event that no longer exists",
            )


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

    if not HOOK_TYPES_MODELLED:
        # Arm expectations come from the capability rules the changed hook-type
        # roster invalidated, so only check A's roster finding is trustworthy.
        return

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
    # An arm restricts the hook types its events accept, so an event belongs to
    # the arm whose type list equals the event's accepted types. Events that
    # accept everything belong to no arm at all.
    accepted = {event: event_capability(event)[1] for event in EVENTS}
    listed_anywhere = set()
    for arm in arms:
        arm_line = text[: arm.start()].count("\n") + 1
        arm_events = set(re.findall(r"[A-Za-z]+", arm.group(1)))
        arm_types = frozenset(re.findall(r"[a-z_]+", arm.group(2)))
        listed_anywhere |= arm_events
        expected = {e for e in EVENTS if accepted[e] == arm_types}
        for event in sorted(expected - arm_events):
            report(
                "D", VALIDATE_SH, arm_line,
                f"hook-type switch arm ({sorted_join(arm_types)}) is missing event {event}",
            )
        for event in sorted(arm_events - expected):
            report(
                "D", VALIDATE_SH, arm_line,
                f"hook-type switch arm ({sorted_join(arm_types)}) should not list {event} "
                f"(dispatch={DISPATCH.get(event, 'unknown event')}, accepts "
                f"{sorted_join(accepted.get(event, ALL_HOOK_TYPES))})",
            )
    for event in sorted(e for e in EVENTS if accepted[e] != ALL_HOOK_TYPES):
        if event not in listed_anywhere:
            report(
                "D", VALIDATE_SH, decl_line,
                f"no hook-type switch arm restricts {event} to "
                f"{sorted_join(accepted[event])} (dispatch={DISPATCH.get(event)})",
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


# Enum members are written as whole inline-code tokens. Reading only those
# keeps prose out of the value set: a "(CC 2.1.219)" note on a Matchers line is
# not a matcher, and a member such as `oauth2` keeps its digits.
ENUM_VALUE_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


def matchers_enum_values(line):
    """Backticked whole-word values on a `**Matchers:**` line."""
    return {
        token for token in INLINE_CODE_RE.findall(line)
        if ENUM_VALUE_RE.fullmatch(token)
    }


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
        m = re.search(rf'"{field}":\s*"([a-z0-9_|]+)"', line)
        if m and "|" in m.group(1):
            enum_lines.append((offset + 1, set(m.group(1).split("|"))))
        if line.startswith("**Matchers:**"):
            values = matchers_enum_values(line.split("**Matchers:**", 1)[1])
            # "Not supported" and other prose Matchers lines carry no values.
            if values:
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
        m = re.search(r'"permission_mode":\s*"([A-Za-z0-9|]+)"', line)
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


# A documentation snippet is validated in a throwaway directory and carries no
# marketplace metadata, so some of what the validator says is about the harness
# rather than about the manifest. These entries are advisory: the paths name
# metadata an example is not expected to supply, and the message shapes cover
# the suggestions and the component paths that only exist in a real plugin.
ADVISORY_PATHS = frozenset({"author", "description"})
ADVISORY_MESSAGE_PREFIXES = ("No ", "Consider ")
# An error the harness earns rather than the example: a component path in a
# documentation snippet names a file the throwaway directory does not contain.
ADVISORY_ERROR_SUBSTRINGS = ("Path not found",)
# The harness failed to put a manifest where the validator looks, so nothing
# was validated and the run has no verdict to report.
NO_MANIFEST_MARKER = "No manifest found"


def is_advisory(entry, kind):
    """Whether a validator entry describes the harness rather than the example.

    Only warnings earn the prose-shaped exemptions: an error whose message
    happens to open with "No " is still an error, and discarding it would let a
    check pass having validated nothing.
    """
    message = str(entry.get("message", ""))
    if kind == "warnings":
        if str(entry.get("path", "")) in ADVISORY_PATHS:
            return True
        if message.startswith(ADVISORY_MESSAGE_PREFIXES):
            return True
    return any(marker in message for marker in ADVISORY_ERROR_SUBSTRINGS)


def validator_problems(payload):
    """Validator entries that signal drift, as "<path>: <message>" strings.

    Every error counts. A warning counts too — the CLI exits 0 for a manifest
    that only earns warnings, so a key upstream has started retiring would
    otherwise pass unnoticed — unless it is advisory.
    """
    manifest = payload.get("manifest") or {}
    problems = []
    for kind in ("errors", "warnings"):
        for entry in manifest.get(kind) or []:
            if not isinstance(entry, dict) or is_advisory(entry, kind):
                continue
            problems.append(f"{entry.get('path', '?')}: {entry.get('message', '')}")
    return problems


def harness_failure(payload):
    """Why the validator never reached the example, or None when it did."""
    manifest = payload.get("manifest")
    if not isinstance(manifest, dict) or not manifest:
        return "'claude plugin validate --json' reported no manifest object"
    for entry in manifest.get("errors") or []:
        if isinstance(entry, dict) and NO_MANIFEST_MARKER in str(entry.get("message", "")):
            return f"the validator found no manifest to read: {entry.get('message', '')}"
    return None


def run_plugin_validate(manifest, check, path, line):
    workdir = tempfile.mkdtemp(prefix="drift-validate-")
    try:
        plugin_dir = Path(workdir) / ".claude-plugin"
        plugin_dir.mkdir()
        (plugin_dir / "plugin.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
        proc = subprocess.run(
            ["claude", "plugin", "validate", "--json", workdir],
            capture_output=True, text=True, timeout=120,
        )
    except (OSError, subprocess.SubprocessError) as exc:
        errors.append((check, f"running 'claude plugin validate' failed: {exc}"))
        return
    finally:
        shutil.rmtree(workdir, ignore_errors=True)
    try:
        payload = json.loads(proc.stdout)
    except json.JSONDecodeError:
        errors.append((
            check,
            "'claude plugin validate --json' did not print JSON for "
            f"{rel(path)}:{line}: {(proc.stdout + proc.stderr).strip()[:200]}",
        ))
        return
    failure = harness_failure(payload)
    if failure is not None:
        errors.append((check, f"{failure} for {rel(path)}:{line}"))
        return
    problems = validator_problems(payload)
    if not problems:
        return
    report(
        check, path, line,
        "claude plugin validate faults this example: " + " | ".join(problems),
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


# G and H split the same fences between them — G takes the userConfig ones, H
# the rest — so they read one document set. A root in only one of them would
# leave the other's fences unvalidated.
def validated_markdown_files():
    roots = [
        PLUGIN_STRUCTURE,
        SKILL / "references/lsp-integration",
        SKILL / "references/mcp-integration",
    ]
    return sorted({p for root in roots for p in markdown_files(root)})


def check_userconfig_validate():
    for path in validated_markdown_files():
        for line, body in json_fences(path):
            if "userConfig" not in body:
                continue
            data = candidate_manifest(body)
            if data is None or "userConfig" not in data:
                continue
            run_plugin_validate(as_plugin_manifest(data), "G", path, line)


# Keys that only a plugin.json declares. "description" is deliberately absent
# from both lists: `name` + `description` also describes an MCP tool schema,
# which the plugin validator has no opinion about.
# Source of truth: the component fields documented in
# plugins/plugin-dev/skills/plugin-dev/references/plugin-structure/references/manifest-reference.md,
# which the same check validates against `claude plugin validate`.
MANIFEST_COMPONENT_KEYS = frozenset({
    "hooks", "mcpServers", "lspServers", "agents", "commands", "skills",
    "outputStyles", "workflows", "userConfig", "experimental", "defaultEnabled",
})
MANIFEST_METADATA_KEYS = frozenset({
    "version", "author", "homepage", "repository", "license", "keywords",
})


# A marketplace entry carries name and version too, so it reaches this check
# looking like a manifest. `source` says where a plugin is installed from and
# belongs only to the marketplace entry, which is validated as marketplace.json
# rather than as plugin.json.
MARKETPLACE_ENTRY_KEYS = frozenset({"source"})


def looks_like_plugin_manifest(data):
    keys = set(data)
    if keys & MARKETPLACE_ENTRY_KEYS:
        return False
    has_component = bool(keys & MANIFEST_COMPONENT_KEYS)
    if isinstance(data.get("name"), str):
        # A bare {"name": ...} fence is the minimal manifest the docs show.
        return keys == {"name"} or has_component or bool(keys & MANIFEST_METADATA_KEYS)
    # Component-path and metadata fragments are printed without the surrounding
    # name/version; as_plugin_manifest supplies them so the fragment can still
    # be validated. A fence holding only "description" is prose, not a manifest.
    has_metadata = bool(keys & MANIFEST_METADATA_KEYS)
    return (has_component or has_metadata) and keys <= (
        MANIFEST_COMPONENT_KEYS | MANIFEST_METADATA_KEYS | {"description"}
    )


def check_manifest_examples_validate():
    for path in validated_markdown_files():
        for line, body in json_fences(path):
            data = candidate_manifest(body)
            if data is None or not looks_like_plugin_manifest(data):
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
FENCE_MARKER_RE = re.compile(r"^\s*(`{3,}|~{3,})")


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
        # A fence closes only on a run of the same character at least as long
        # as the one that opened it, so a 4-backtick fence wrapping 3-backtick
        # samples stays open across the inner markers.
        open_marker = None
        for idx, line in enumerate(read_lines(path), start=1):
            marker_match = FENCE_MARKER_RE.match(line)
            if marker_match:
                marker = marker_match.group(1)
                if open_marker is None:
                    open_marker = marker
                elif marker[0] == open_marker[0] and len(marker) >= len(open_marker):
                    open_marker = None
            in_fence = open_marker is not None
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

# The denylist scan reads whole trees rather than a file list, so it has to
# decide what is text. Anything that does not decode as UTF-8 holds no prose to
# drift, and a .git directory holds object data rather than documentation.
# The scopes are also the exclusion: docs/claude-code-compatibility.md and
# CHANGELOG.md record retired names on purpose, and neither lives under a
# scanned tree, so they are never read.
DENYLIST_SCOPES = ("plugins", ".github")


def denylist_files():
    for scope in DENYLIST_SCOPES:
        root = REPO / scope
        if not root.is_dir():
            continue
        for path in sorted(root.rglob("*")):
            if not path.is_file() or path.is_symlink():
                continue
            if ".git" in path.parts:
                continue
            try:
                yield path, path.read_text(encoding="utf-8")
            except (UnicodeDecodeError, OSError):
                continue


def check_denylist():
    names = load_list_file(REPO / "scripts/drift-denylist.txt")
    if not names:
        errors.append(("J", "scripts/drift-denylist.txt is empty or missing"))
        return
    for path, text in denylist_files():
        for idx, line in enumerate(text.splitlines(), start=1):
            for name in names:
                if name in line:
                    report("J", path, idx, f"removed or non-existent name '{name}' appears here")


# --------------------------------------------------------------- L. version-sync

def check_version_sync():
    # .github/workflows/version-check.yml enforces the same agreement in CI.
    # This check is three file reads, so it stays here as well: a local run
    # reports the mismatch without waiting for a push.
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


# ------------------------------------------------------------ M. userconfig-fields

OPTION_FIELDS_MARKER = "**Option fields:**"


def table_rows_after(lines, start_index):
    """(line_no, cells) for the markdown table that opens after start_index."""
    rows = []
    in_table = False
    for offset in range(start_index, len(lines)):
        line = lines[offset]
        if not line.startswith("|"):
            if in_table:
                break
            continue
        in_table = True
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if not cells or set(cells[0]) <= set("- :"):
            continue
        rows.append((offset + 1, cells))
    return rows


def code_tokens(text):
    return {token.strip("`") for token in INLINE_CODE_RE.findall(text)}


def check_userconfig_fields():
    lines = read_lines(MANIFEST_REFERENCE)
    marker = next(
        (i for i, line in enumerate(lines) if line.startswith(OPTION_FIELDS_MARKER)),
        None,
    )
    if marker is None:
        report("M", MANIFEST_REFERENCE, 1, f"'{OPTION_FIELDS_MARKER}' table not found")
        return
    rows = table_rows_after(lines, marker)
    # The header row names the columns rather than a field.
    header = rows[0][1] if rows else []
    if not rows or not header or header[0].strip("`") != "Field":
        report("M", MANIFEST_REFERENCE, marker + 1, "option fields table has no Field column")
        return
    body = rows[1:]

    documented = {}
    required_documented = set()
    for line_no, cells in body:
        field = cells[0].strip("`")
        documented[field] = (line_no, cells)
        if len(cells) > 2 and cells[2].strip().lower() == "yes":
            required_documented.add(field)

    expected_fields = set(USER_CONFIG["fields"])
    for field in sorted(expected_fields - set(documented)):
        report("M", MANIFEST_REFERENCE, marker + 1, f"option fields table has no row for '{field}'")
    for field in sorted(set(documented) - expected_fields):
        report(
            "M", MANIFEST_REFERENCE, documented[field][0],
            f"option fields table documents '{field}', which the schema does not accept",
        )

    expected_required = set(USER_CONFIG["required_fields"])
    for field in sorted(expected_required - required_documented):
        if field in documented:
            report(
                "M", MANIFEST_REFERENCE, documented[field][0],
                f"'{field}' is required by the schema but the table's Required column does not say Yes",
            )
    for field in sorted(required_documented - expected_required):
        report(
            "M", MANIFEST_REFERENCE, documented[field][0],
            f"table marks '{field}' as required, but the schema accepts a manifest without it",
        )

    expected_types = set(USER_CONFIG["types"])
    type_row = documented.get("type")
    if type_row is None:
        report("M", MANIFEST_REFERENCE, marker + 1, "option fields table has no 'type' row")
    else:
        line_no, cells = type_row
        listed = code_tokens(cells[1]) if len(cells) > 1 else set()
        for value in sorted(expected_types - listed):
            report("M", MANIFEST_REFERENCE, line_no, f"'type' row does not list option type '{value}'")
        for value in sorted(listed - expected_types):
            report("M", MANIFEST_REFERENCE, line_no, f"'type' row lists unknown option type '{value}'")

    pattern = USER_CONFIG["key_pattern"]
    if pattern not in Path(MANIFEST_REFERENCE).read_text(encoding="utf-8"):
        report("M", MANIFEST_REFERENCE, marker + 1, f"option key pattern '{pattern}' is not documented")

    # The overview bullet is the short form of the same schema, so it has to
    # name every option type a reader will meet in the full table.
    bullet = next(
        ((idx, line) for idx, line in enumerate(read_lines(PLUGIN_STRUCTURE_OVERVIEW), start=1)
         if line.lstrip().startswith("- ") and "`userConfig`" in line),
        None,
    )
    if bullet is None:
        report("M", PLUGIN_STRUCTURE_OVERVIEW, 1, "no `userConfig` bullet found")
        return
    idx, line = bullet
    listed = code_tokens(line)
    for value in sorted(expected_types - listed):
        report("M", PLUGIN_STRUCTURE_OVERVIEW, idx, f"`userConfig` bullet does not name option type '{value}'")


# ------------------------------------------------------------------- N. env-vars

ENV_SECTION_HEADING_RE = re.compile(r"^#+\s+Plugin Environment Variables\s*$")
HOOK_ENV_MARKER = "**Environment variables**"
# The runtime's own wording for a skipped mcp_tool hook; the docs quote it so a
# reader can match what they see in the log.
MCP_SKIP_PHRASE = "no MCP client context"


def env_var_names():
    return list(FACTS["plugin_env_vars"]) + [FACTS["plugin_option_env_prefix"]]


def manifest_env_section(lines):
    """(heading_line_no, section_text) for the Plugin Environment Variables section."""
    start = next((i for i, line in enumerate(lines) if ENV_SECTION_HEADING_RE.match(line)), None)
    if start is None:
        return None
    end = len(lines)
    for offset in range(start + 1, len(lines)):
        if lines[offset].startswith("#"):
            end = offset
            break
    return start + 1, "\n".join(lines[start:end])


def hook_env_list(lines):
    """(marker_line_no, list_text) for the hook overview's env-var list."""
    start = next((i for i, line in enumerate(lines) if line.startswith(HOOK_ENV_MARKER)), None)
    if start is None:
        return None
    end = len(lines)
    for offset in range(start + 1, len(lines)):
        line = lines[offset]
        # The list runs until the next bold paragraph or heading takes over.
        if line.startswith("#") or line.startswith("**"):
            end = offset
            break
    return start + 1, "\n".join(lines[start:end])


def check_env_vars():
    manifest_lines = read_lines(MANIFEST_REFERENCE)
    section = manifest_env_section(manifest_lines)
    if section is None:
        report("N", MANIFEST_REFERENCE, 1, "'Plugin Environment Variables' section not found")
    else:
        line_no, text = section
        for name in env_var_names():
            if name not in text:
                report(
                    "N", MANIFEST_REFERENCE, line_no,
                    f"'Plugin Environment Variables' section does not document {name}",
                )

    hook_lines = read_lines(OVERVIEW)
    env_list = hook_env_list(hook_lines)
    if env_list is None:
        report("N", OVERVIEW, 1, f"'{HOOK_ENV_MARKER}' list not found")
    else:
        line_no, text = env_list
        for name in env_var_names():
            if name not in text:
                report("N", OVERVIEW, line_no, f"environment-variable list does not document {name}")

    if FACTS.get("mcp_tool_skipped_without_mcp_context"):
        if MCP_SKIP_PHRASE not in "\n".join(hook_lines):
            report(
                "N", OVERVIEW, 1,
                f"mcp_tool hooks are skipped without an MCP client set, but '{MCP_SKIP_PHRASE}' "
                "— the runtime's wording — appears nowhere here",
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
    "L": ("version-sync", check_version_sync),
    "M": ("userconfig-fields", check_userconfig_fields),
    "N": ("env-vars", check_env_vars),
}

unknown = ONLY - set(ALL_CHECKS)
if unknown:
    fail_tooling(f"unknown check(s) in --only: {sorted_join(unknown)}")

ran = []
for check in ALL_CHECKS:
    if not enabled(check):
        continue
    if check in ("G", "H") and SKIP_VALIDATE:
        continue
    ran.append(check)
    try:
        CHECKS[check][1]()
    except Exception as exc:  # a crashed check is a tooling failure, not a verdict
        errors.append((check, f"{CHECKS[check][0]}: {type(exc).__name__}: {exc}"))

# A run that examined nothing has no verdict to give, so exiting 0 here would
# report a clean tree it never looked at. --only G/H with --skip-validate is the
# way to ask for it by accident.
if not ran:
    fail_tooling(
        "no checks left to run: --skip-validate removes G and H, and --only "
        f"selected {sorted_join(ONLY) or 'nothing else'}"
    )

# stdout carries DRIFT lines and nothing else: consumers append it to a report
# file and read every line there as a finding. The findings from the checks
# that did run are still worth printing when another check broke.
for check, path, line, message in sorted(findings):
    print(f"DRIFT {check} {path}:{line} {message}")

for check, message in errors:
    print(f"ERROR {check} {message}", file=sys.stderr)

scope = "".join(ran) if ran else "none"
print(f"check-doc-drift: {len(findings)} finding(s) across checks {scope}", file=sys.stderr)

# A check that could not run leaves the verdict incomplete, so a tooling
# failure outranks the findings the other checks produced. Exit 1 means every
# selected check ran and at least one of them found drift.
if errors:
    print(
        f"check-doc-drift: {len(errors)} check(s) failed to run; verdict is incomplete",
        file=sys.stderr,
    )
    sys.exit(2)
sys.exit(1 if findings else 0)
PYTHON
