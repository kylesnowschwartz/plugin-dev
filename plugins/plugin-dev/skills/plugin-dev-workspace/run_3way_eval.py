#!/usr/bin/env python3
"""3-way trigger evaluation for plugin-dev skill consolidation.

Uses clean temp directories per query (workaround from anthropics/claude-plugins-official#1357)
to isolate description triggering from competing plugins/tools.

Configs:
1. current-11-skills: All 11 plugin-dev skill descriptions as separate commands
2. consolidated-1-skill: Single consolidated description as one command
3. no-plugin: No commands (baseline - nothing should trigger)
"""

import argparse
import json
import os
import select
import shutil
import subprocess
import tempfile
import time
import uuid
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path


# Current 11-skill descriptions from main branch
CURRENT_SKILLS = {
    "plugin-dev-guide": 'This skill should be used when the user asks about "Claude Code plugins", "plugin development", "how to build a plugin", "what plugin components exist", "plugin architecture", "extending Claude Code", or needs an overview of plugin development capabilities. Acts as a guide to the 9 specialized plugin-dev skills, explaining when to activate each one. Load this skill first when the user is new to plugin development or unsure which specific skill they need.',
    "plugin-structure": 'This skill should be used when the user asks to "create a plugin", "scaffold a plugin", "understand plugin structure", "organize plugin components", "set up plugin.json", "use ${CLAUDE_PLUGIN_ROOT}", "add commands/agents/skills/hooks", "add lspServers", "configure auto-discovery", "headless mode", "CI mode", "plugin in CI", "github actions", "plugin caching", "plugin CLI", "install plugin", "installation scope", "auto-update", "validate plugin", "plugin validate", "debug plugin", "output styles", "outputStyles", "custom output format", "response formatting", "--verbose", "userConfig", "plugin configuration", "sensitive config", or needs guidance on plugin directory layout, manifest configuration, component organization, file naming conventions, or Claude Code plugin architecture best practices.',
    "command-development": 'This skill should be used when the user asks to "create a slash command", "add a command", "write a custom command", "define command arguments", "use command frontmatter", "organize commands", "create command with file references", "interactive command", "use AskUserQuestion in command", "Skill tool", "programmatic command invocation", "disable-model-invocation", "prevent Claude from running command", "debug command", "command debugging", "troubleshoot command", "commands vs skills", "Skill tool mechanism", "load-time injection", "runtime execution", or needs guidance on slash command structure, YAML frontmatter fields, dynamic arguments, bash execution in commands, user interaction patterns, programmatic invocation control, debugging commands, or command development best practices for Claude Code.',
    "agent-development": 'This skill should be used when the user asks to "create an agent", "add an agent", "write a subagent", "agent frontmatter", "when to use description", "agent examples", "agent tools", "agent colors", "autonomous agent", "disallowedTools", "block tools", "agent denylist", "maxTurns", "agent memory", "mcpServers in agent", "agent hooks", "background agent", "resume agent", "initialPrompt", "auto-submit prompt", "agent teams", "permission rules", "permission mode", "delegate mode", "agent team", "team lead", "teammate", "multi-agent", or needs guidance on agent structure, system prompts, triggering conditions, or agent development best practices for Claude Code plugins.',
    "skill-development": 'This skill should be used when the user asks to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", "SKILL.md format", "skill frontmatter", "skill triggers", "trigger phrases for skills", "progressive disclosure", "skill references folder", "skill examples folder", "validate skill", "skill model field", "skill hooks", "scoped hooks in skill", "visibility budget", "context budget", "SLASH_COMMAND_TOOL_CHAR_BUDGET", "skill permissions", "Skill() syntax", "visual output", "skill precedence", "argument-hint", "paths frontmatter", "file-scoped skill", or needs guidance on skill structure, file organization, writing style, or skill development best practices for Claude Code plugins.',
    "hook-development": 'This skill should be used when the user asks to "create a hook", "add a PreToolUse/PostToolUse/Stop hook", "validate tool use", "implement prompt-based hooks", "use ${CLAUDE_PLUGIN_ROOT}", "set up event-driven automation", "block dangerous commands", "scoped hooks", "frontmatter hooks", "hook in skill", "hook in agent", "agent hook type", "async hooks", "once handler", "statusMessage", "hook decision control", or mentions hook events (PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, Stop, StopFailure, SubagentStop, SubagentStart, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, PostCompact, Notification, ConfigChange, TeammateIdle, TaskCompleted, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, InstructionsLoaded, Elicitation, ElicitationResult). Provides comprehensive guidance for creating and implementing Claude Code plugin hooks with focus on advanced prompt-based hooks API.',
    "mcp-integration": 'This skill should be used when the user asks to "add MCP server", "integrate MCP", "configure MCP in plugin", "use .mcp.json", "set up Model Context Protocol", "connect external service", mentions "${CLAUDE_PLUGIN_ROOT} with MCP", discusses MCP server types (SSE, stdio, HTTP, WebSocket), or asks to "find MCP server", "discover MCP servers", "what MCP servers exist", "recommend MCP server for [service]", "MCP prompts", "MCP prompts as commands", "tool search", "tool search threshold", "claude mcp serve", "allowedMcpServers", "deniedMcpServers", "managed MCP", "MCP scope", "MCP output limits", "MCP CLI commands". Provides comprehensive guidance for integrating Model Context Protocol servers into Claude Code plugins for external tool and service integration.',
    "lsp-integration": 'This skill should be used when the user asks to "add LSP server", "configure language server", "set up LSP in plugin", "add code intelligence", "integrate language server protocol", "use pyright-lsp", "use typescript-lsp", "use rust-lsp", "socket transport", "initializationOptions", mentions LSP servers, or discusses extensionToLanguage mappings. Provides guidance for integrating Language Server Protocol servers into Claude Code plugins for enhanced code intelligence.',
    "plugin-settings": 'This skill should be used when the user asks about "plugin settings", "store plugin configuration", "user-configurable plugin", ".local.md files", "plugin state files", "read YAML frontmatter", "per-project plugin settings", "CLAUDE.md imports", "rules system", "memory hierarchy", "memory priority", or wants to make plugin behavior configurable. Documents the .claude/plugin-name.local.md pattern for storing plugin-specific configuration with YAML frontmatter and markdown content.',
    "marketplace-structure": 'This skill should be used when the user asks to "create a marketplace", "set up marketplace.json", "organize multiple plugins", "distribute plugins", "host plugins", "marketplace schema", "plugin marketplace structure", "multi-plugin organization", "strictKnownMarketplaces", "private marketplace", "marketplace auth", "pin plugin version", "hostPattern", or needs guidance on plugin marketplace creation, marketplace manifest configuration, or plugin distribution strategies.',
    "update-from-upstream": 'This skill should be used when the user asks to "sync with upstream", "update from Claude Code", "check for Claude Code changes", "update plugin-dev docs", "sync with latest CC release", "what changed in Claude Code", "audit against upstream", "bring docs up to date", "check upstream changelog", "sync plugin-dev with Claude Code", "update compatibility", or needs to bring plugin-dev documentation current with recent Claude Code releases.',
}

CONSOLIDATED_DESCRIPTION = (
    'MUST use this skill when the user mentions plugins, hooks, skills, commands, agents, '
    'MCP servers, LSP servers, marketplaces, plugin.json, SKILL.md, .mcp.json, .local.md, '
    'allowed-tools, frontmatter, PreToolUse, PostToolUse, SessionStart, event schemas, '
    'prompt-based hooks, plugin settings, output styles, headless mode, CI mode, '
    'CLAUDE_PLUGIN_ROOT, auto-discovery, or any aspect of extending Claude Code. '
    'Use INSTEAD OF answering from general knowledge. Also use when writing hooks for '
    'settings.json, configuring MCP servers outside plugins, or comparing skills vs commands, '
    'since this skill contains the authoritative reference for these Claude Code extension mechanisms.'
)


def create_clean_dir(skill_descs: dict[str, str]) -> str:
    """Create a clean temp directory with skill descriptions as commands."""
    tmpdir = tempfile.mkdtemp(prefix="pd-eval-")
    commands_dir = Path(tmpdir) / ".claude" / "commands"
    commands_dir.mkdir(parents=True)

    # Disable all plugins
    settings = Path(tmpdir) / ".claude" / "settings.json"
    settings.write_text('{"enabledPlugins": {}}')

    # Write each skill as a command
    uid = uuid.uuid4().hex[:6]
    name_map = {}
    for skill_name, desc in skill_descs.items():
        clean = f"pd-{skill_name}-{uid}"
        name_map[clean] = skill_name
        indented = "\n  ".join(desc.split("\n"))
        (commands_dir / f"{clean}.md").write_text(
            f"---\ndescription: |\n  {indented}\n---\n\n"
            f"# {skill_name}\n\nThis skill handles: {desc}\n"
        )

    return tmpdir, name_map


def run_single(
    query: str,
    skill_descs: dict[str, str],
    timeout: int,
    model: str | None = None,
) -> dict:
    """Run one query in a clean temp dir. Returns trigger result."""
    if not skill_descs:
        # No-plugin baseline: still need a clean dir
        tmpdir = tempfile.mkdtemp(prefix="pd-eval-")
        (Path(tmpdir) / ".claude").mkdir()
        (Path(tmpdir) / ".claude" / "settings.json").write_text('{"enabledPlugins": {}}')
        name_map = {}
    else:
        tmpdir, name_map = create_clean_dir(skill_descs)

    result = {"triggered": False, "skill_name": None, "first_tool": None}

    try:
        cmd = ["claude", "-p", query, "--output-format", "stream-json",
               "--verbose", "--include-partial-messages"]
        if model:
            cmd.extend(["--model", model])

        env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}

        proc = subprocess.Popen(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
            cwd=tmpdir, env=env,
        )

        start = time.time()
        buf = ""
        pending = None
        acc_json = ""

        try:
            while time.time() - start < timeout:
                if proc.poll() is not None:
                    rest = proc.stdout.read()
                    if rest:
                        buf += rest.decode("utf-8", errors="replace")
                    break

                ready, _, _ = select.select([proc.stdout], [], [], 1.0)
                if not ready:
                    continue

                chunk = os.read(proc.stdout.fileno(), 8192)
                if not chunk:
                    break
                buf += chunk.decode("utf-8", errors="replace")

                while "\n" in buf:
                    line, buf = buf.split("\n", 1)
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        ev = json.loads(line)
                    except json.JSONDecodeError:
                        continue

                    if ev.get("type") == "stream_event":
                        se = ev.get("event", {})
                        st = se.get("type", "")

                        if st == "content_block_start":
                            cb = se.get("content_block", {})
                            if cb.get("type") == "tool_use":
                                tn = cb.get("name", "")
                                if result["first_tool"] is None:
                                    result["first_tool"] = tn
                                if tn in ("Skill", "Read"):
                                    pending = tn
                                    acc_json = ""
                                else:
                                    return result

                        elif st == "content_block_delta" and pending:
                            delta = se.get("delta", {})
                            if delta.get("type") == "input_json_delta":
                                acc_json += delta.get("partial_json", "")
                                for cn, orig in name_map.items():
                                    if cn in acc_json:
                                        result["triggered"] = True
                                        result["skill_name"] = orig
                                        return result

                        elif st in ("content_block_stop", "message_stop"):
                            if pending:
                                for cn, orig in name_map.items():
                                    if cn in acc_json:
                                        result["triggered"] = True
                                        result["skill_name"] = orig
                                        return result
                                pending = None
                            if st == "message_stop":
                                return result

                    elif ev.get("type") == "assistant":
                        msg = ev.get("message", {})
                        for blk in msg.get("content", []):
                            if blk.get("type") != "tool_use":
                                continue
                            tn = blk.get("name", "")
                            if result["first_tool"] is None:
                                result["first_tool"] = tn
                            if tn in ("Skill", "Read"):
                                target = blk.get("input", {}).get("skill", "") or blk.get("input", {}).get("file_path", "")
                                for cn, orig in name_map.items():
                                    if cn in target:
                                        result["triggered"] = True
                                        result["skill_name"] = orig
                        return result

                    elif ev.get("type") == "result":
                        return result
        finally:
            if proc.poll() is None:
                proc.kill()
                proc.wait()
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

    return result


def run_config(
    eval_set: list[dict],
    skill_descs: dict[str, str],
    config_name: str,
    num_workers: int,
    timeout: int,
    runs_per_query: int,
    model: str | None = None,
) -> list[dict]:
    """Run all queries for one configuration with multiple runs each."""
    results = []

    with ProcessPoolExecutor(max_workers=num_workers) as pool:
        futures = {}
        for item in eval_set:
            for run_idx in range(runs_per_query):
                f = pool.submit(run_single, item["query"], skill_descs, timeout, model)
                futures[f] = (item, run_idx)

        # Aggregate by query
        query_runs: dict[str, list[dict]] = {}
        query_items: dict[str, dict] = {}
        for f in as_completed(futures):
            item, run_idx = futures[f]
            q = item["query"]
            query_items[q] = item
            if q not in query_runs:
                query_runs[q] = []
            try:
                query_runs[q].append(f.result())
            except Exception as e:
                query_runs[q].append({"triggered": False, "skill_name": None, "first_tool": None, "error": str(e)})

    for q, runs in query_runs.items():
        item = query_items[q]
        trigger_count = sum(1 for r in runs if r["triggered"])
        trigger_rate = trigger_count / len(runs)
        skills_triggered = [r["skill_name"] for r in runs if r["skill_name"]]
        first_tools = [r["first_tool"] for r in runs if r["first_tool"]]

        results.append({
            "query": q[:150],
            "should_trigger": item["should_trigger"],
            "topic": item.get("topic", ""),
            "config": config_name,
            "trigger_count": trigger_count,
            "total_runs": len(runs),
            "trigger_rate": round(trigger_rate, 2),
            "triggered": trigger_rate >= 0.5,  # majority vote
            "skills_triggered": skills_triggered,
            "first_tools": first_tools,
        })

    return results


def score(results: list[dict]) -> dict:
    tp = sum(1 for r in results if r["should_trigger"] and r["triggered"])
    fn = sum(1 for r in results if r["should_trigger"] and not r["triggered"])
    tn = sum(1 for r in results if not r["should_trigger"] and not r["triggered"])
    fp = sum(1 for r in results if not r["should_trigger"] and r["triggered"])
    total = len(results)
    pos = tp + fn
    neg = tn + fp
    return {
        "accuracy": round((tp + tn) / total, 3) if total else 0,
        "trigger_rate": round(tp / pos, 3) if pos else 0,
        "false_pos_rate": round(fp / neg, 3) if neg else 0,
        "tp": tp, "fn": fn, "tn": tn, "fp": fp, "total": total,
    }


def print_config(name: str, results: list[dict], scores: dict):
    print(f"\n{'=' * 70}")
    print(f"  {name}")
    print(f"{'=' * 70}")
    print(f"  Accuracy: {scores['accuracy']:.1%}  |  "
          f"Trigger rate: {scores['trigger_rate']:.1%}  |  "
          f"False pos rate: {scores['false_pos_rate']:.1%}")
    print(f"  TP={scores['tp']}  FN={scores['fn']}  TN={scores['tn']}  FP={scores['fp']}")

    for r in sorted(results, key=lambda x: x["topic"]):
        tag = "should_trigger" if r["should_trigger"] else "should_not  "
        status = f"{r['trigger_count']}/{r['total_runs']}"
        match = "OK" if r["should_trigger"] == r["triggered"] else "MISS"
        skill = r["skills_triggered"][0] if r["skills_triggered"] else "-"
        print(f"    [{match:4s}] {tag} {status:5s}  skill={skill:25s}  {r['query'][:80]}")


def main():
    parser = argparse.ArgumentParser(description="3-way plugin-dev trigger eval")
    parser.add_argument("--eval-set", required=True)
    parser.add_argument("--output", default="trigger-eval-results.json")
    parser.add_argument("--workers", type=int, default=4)
    parser.add_argument("--timeout", type=int, default=45)
    parser.add_argument("--runs", type=int, default=3, help="Runs per query per config")
    parser.add_argument("--model", default=None)
    parser.add_argument("--skip-baseline", action="store_true")
    args = parser.parse_args()

    with open(args.eval_set) as f:
        eval_set = json.load(f)

    n_pos = sum(1 for e in eval_set if e["should_trigger"])
    n_neg = sum(1 for e in eval_set if not e["should_trigger"])
    total_runs = len(eval_set) * args.runs * (2 if args.skip_baseline else 3)
    print(f"Eval set: {len(eval_set)} queries ({n_pos} should-trigger, {n_neg} should-not)")
    print(f"Runs per query: {args.runs}")
    print(f"Total claude -p invocations: {total_runs}")
    print(f"Workers: {args.workers}")

    all_results = {}

    # Config 1: Current 11 skills
    print(f"\n>>> Config 1: Current 11 skills ({len(CURRENT_SKILLS)} descriptions)")
    t0 = time.time()
    r1 = run_config(eval_set, CURRENT_SKILLS, "current-11-skills",
                     args.workers, args.timeout, args.runs, args.model)
    s1 = score(r1)
    print_config(f"Current (11 skills) [{time.time()-t0:.0f}s]", r1, s1)
    all_results["current-11-skills"] = {"results": r1, "scores": s1}

    # Config 2: Consolidated single skill
    print(f"\n>>> Config 2: Consolidated single skill")
    t0 = time.time()
    r2 = run_config(eval_set, {"plugin-dev": CONSOLIDATED_DESCRIPTION},
                     "consolidated-1-skill", args.workers, args.timeout, args.runs, args.model)
    s2 = score(r2)
    print_config(f"Consolidated (1 skill) [{time.time()-t0:.0f}s]", r2, s2)
    all_results["consolidated-1-skill"] = {"results": r2, "scores": s2}

    # Config 3: No plugin baseline
    if not args.skip_baseline:
        print(f"\n>>> Config 3: No plugin (baseline)")
        t0 = time.time()
        r3 = run_config(eval_set, {}, "no-plugin",
                         args.workers, args.timeout, args.runs, args.model)
        s3 = score(r3)
        print_config(f"No Plugin (baseline) [{time.time()-t0:.0f}s]", r3, s3)
        all_results["no-plugin"] = {"results": r3, "scores": s3}

    # Summary
    print(f"\n{'=' * 70}")
    print("  COMPARISON SUMMARY")
    print(f"{'=' * 70}")
    print(f"  {'Config':<25s} {'Accuracy':>10s} {'TriggerRate':>12s} {'FalsePosRate':>13s}")
    print(f"  {'-' * 60}")
    for name, data in all_results.items():
        s = data["scores"]
        print(f"  {name:<25s} {s['accuracy']:>9.1%} {s['trigger_rate']:>11.1%} {s['false_pos_rate']:>12.1%}")

    with open(args.output, "w") as f:
        json.dump(all_results, f, indent=2)
    print(f"\nResults saved to {args.output}")


if __name__ == "__main__":
    main()
