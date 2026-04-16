#!/usr/bin/env python3
"""3-way trigger evaluation for plugin-dev skill consolidation.

Tests whether plugin-dev skills trigger for a set of queries across three configurations:
1. Current 11-skill plugin (main branch)
2. Consolidated single-skill plugin (feature branch)
3. No plugin (vanilla Claude Code baseline)

Uses `claude -p --plugin-dir` with stream-json output to detect Skill tool invocations.
"""

import argparse
import json
import os
import select
import subprocess
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path


def run_single_query(
    query: str,
    plugin_dir: str | None,
    config_name: str,
    timeout: int,
    project_root: str,
    model: str | None = None,
) -> dict:
    """Run a single query and return trigger results.

    Returns dict with:
        triggered: bool - whether any plugin-dev skill was triggered
        skill_name: str | None - which skill was triggered (if any)
        first_tool: str | None - first tool the model tried to use
    """
    cmd = [
        "claude",
        "-p", query,
        "--output-format", "stream-json",
        "--verbose",
        "--include-partial-messages",
        "--max-turns", "2",
    ]
    if plugin_dir:
        cmd.extend(["--plugin-dir", plugin_dir])
    if model:
        cmd.extend(["--model", model])

    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}

    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        cwd=project_root,
        env=env,
    )

    result = {"triggered": False, "skill_name": None, "first_tool": None}
    start_time = time.time()
    buffer = ""
    pending_tool_name = None
    accumulated_json = ""

    try:
        while time.time() - start_time < timeout:
            if process.poll() is not None:
                remaining = process.stdout.read()
                if remaining:
                    buffer += remaining.decode("utf-8", errors="replace")
                break

            ready, _, _ = select.select([process.stdout], [], [], 1.0)
            if not ready:
                continue

            chunk = os.read(process.stdout.fileno(), 8192)
            if not chunk:
                break
            buffer += chunk.decode("utf-8", errors="replace")

            while "\n" in buffer:
                line, buffer = buffer.split("\n", 1)
                line = line.strip()
                if not line:
                    continue

                try:
                    event = json.loads(line)
                except json.JSONDecodeError:
                    continue

                # Detect via stream events
                if event.get("type") == "stream_event":
                    se = event.get("event", {})
                    se_type = se.get("type", "")

                    if se_type == "content_block_start":
                        cb = se.get("content_block", {})
                        if cb.get("type") == "tool_use":
                            tool_name = cb.get("name", "")
                            if result["first_tool"] is None:
                                result["first_tool"] = tool_name
                            if tool_name == "Skill":
                                pending_tool_name = "Skill"
                                accumulated_json = ""

                    elif se_type == "content_block_delta" and pending_tool_name == "Skill":
                        delta = se.get("delta", {})
                        if delta.get("type") == "input_json_delta":
                            accumulated_json += delta.get("partial_json", "")
                            if "plugin-dev" in accumulated_json:
                                # Extract skill name
                                try:
                                    partial = json.loads(accumulated_json)
                                    result["skill_name"] = partial.get("skill", accumulated_json)
                                except json.JSONDecodeError:
                                    result["skill_name"] = accumulated_json
                                result["triggered"] = True
                                return result

                    elif se_type == "content_block_stop" and pending_tool_name == "Skill":
                        if "plugin-dev" in accumulated_json:
                            try:
                                parsed = json.loads(accumulated_json)
                                result["skill_name"] = parsed.get("skill", "")
                            except json.JSONDecodeError:
                                result["skill_name"] = accumulated_json
                            result["triggered"] = True
                        pending_tool_name = None
                        return result

                    elif se_type == "message_stop":
                        return result

                # Fallback: full assistant message
                elif event.get("type") == "assistant":
                    message = event.get("message", {})
                    for block in message.get("content", []):
                        if block.get("type") != "tool_use":
                            continue
                        if block.get("name") == "Skill":
                            skill = block.get("input", {}).get("skill", "")
                            if "plugin-dev" in skill:
                                result["triggered"] = True
                                result["skill_name"] = skill
                        if result["first_tool"] is None:
                            result["first_tool"] = block.get("name", "")
                    return result

                elif event.get("type") == "result":
                    return result

    finally:
        if process.poll() is None:
            process.kill()
            process.wait()

    return result


def run_config(
    eval_set: list[dict],
    plugin_dir: str | None,
    config_name: str,
    num_workers: int,
    timeout: int,
    project_root: str,
    model: str | None = None,
) -> list[dict]:
    """Run all queries for one configuration."""
    results = []

    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        future_to_query = {}
        for item in eval_set:
            future = executor.submit(
                run_single_query,
                item["query"],
                plugin_dir,
                config_name,
                timeout,
                project_root,
                model,
            )
            future_to_query[future] = item

        for future in as_completed(future_to_query):
            item = future_to_query[future]
            try:
                result = future.result()
            except Exception as e:
                result = {"triggered": False, "skill_name": None, "first_tool": None, "error": str(e)}

            results.append({
                "query": item["query"],
                "should_trigger": item["should_trigger"],
                "topic": item.get("topic", ""),
                "config": config_name,
                **result,
            })

    return results


def score_results(results: list[dict]) -> dict:
    """Calculate accuracy metrics."""
    true_pos = sum(1 for r in results if r["should_trigger"] and r["triggered"])
    false_neg = sum(1 for r in results if r["should_trigger"] and not r["triggered"])
    true_neg = sum(1 for r in results if not r["should_trigger"] and not r["triggered"])
    false_pos = sum(1 for r in results if not r["should_trigger"] and r["triggered"])

    total = len(results)
    accuracy = (true_pos + true_neg) / total if total else 0
    should_trigger = [r for r in results if r["should_trigger"]]
    trigger_rate = true_pos / len(should_trigger) if should_trigger else 0
    should_not = [r for r in results if not r["should_trigger"]]
    false_pos_rate = false_pos / len(should_not) if should_not else 0

    return {
        "accuracy": round(accuracy, 3),
        "trigger_rate": round(trigger_rate, 3),
        "false_positive_rate": round(false_pos_rate, 3),
        "true_positives": true_pos,
        "false_negatives": false_neg,
        "true_negatives": true_neg,
        "false_positives": false_pos,
        "total": total,
    }


def print_results(config_name: str, results: list[dict], scores: dict):
    """Print formatted results for one configuration."""
    print(f"\n{'=' * 60}")
    print(f"  {config_name}")
    print(f"{'=' * 60}")
    print(f"  Accuracy: {scores['accuracy']:.1%}  |  "
          f"Trigger rate: {scores['trigger_rate']:.1%}  |  "
          f"False positive rate: {scores['false_positive_rate']:.1%}")
    print(f"  TP={scores['true_positives']}  FN={scores['false_negatives']}  "
          f"TN={scores['true_negatives']}  FP={scores['false_positives']}")
    print()

    # Show failures
    failures = [r for r in results if r["should_trigger"] != r["triggered"]]
    if failures:
        print("  FAILURES:")
        for r in failures:
            expected = "trigger" if r["should_trigger"] else "no trigger"
            actual = "triggered" if r["triggered"] else "no trigger"
            skill = f" -> {r['skill_name']}" if r["skill_name"] else ""
            first = f" (first tool: {r['first_tool']})" if r["first_tool"] and not r["triggered"] else ""
            print(f"    [{r['topic']:20s}] expected={expected:10s} actual={actual:10s}{skill}{first}")
            print(f"      {r['query'][:100]}")
    else:
        print("  All queries matched expectations!")


def main():
    parser = argparse.ArgumentParser(description="3-way plugin-dev trigger eval")
    parser.add_argument("--eval-set", required=True, help="Path to trigger-eval.json")
    parser.add_argument("--current-plugin", required=True, help="Path to current 11-skill plugin dir")
    parser.add_argument("--new-plugin", required=True, help="Path to consolidated single-skill plugin dir")
    parser.add_argument("--output", default="trigger-eval-results.json", help="Output file")
    parser.add_argument("--workers", type=int, default=3, help="Parallel workers per config")
    parser.add_argument("--timeout", type=int, default=30, help="Timeout per query in seconds")
    parser.add_argument("--model", default=None, help="Model override")
    parser.add_argument("--skip-baseline", action="store_true", help="Skip no-plugin baseline")
    args = parser.parse_args()

    project_root = str(Path.cwd())

    with open(args.eval_set) as f:
        eval_set = json.load(f)

    print(f"Eval set: {len(eval_set)} queries "
          f"({sum(1 for e in eval_set if e['should_trigger'])} should-trigger, "
          f"{sum(1 for e in eval_set if not e['should_trigger'])} should-not)")

    all_results = {}

    # Config 1: Current 11-skill plugin
    print(f"\n>>> Running: current-11-skills ({args.current_plugin})")
    current_results = run_config(
        eval_set, args.current_plugin, "current-11-skills",
        args.workers, args.timeout, project_root, args.model,
    )
    current_scores = score_results(current_results)
    print_results("Current (11 skills)", current_results, current_scores)
    all_results["current-11-skills"] = {"results": current_results, "scores": current_scores}

    # Config 2: Consolidated single skill
    print(f"\n>>> Running: consolidated-single-skill ({args.new_plugin})")
    new_results = run_config(
        eval_set, args.new_plugin, "consolidated-single-skill",
        args.workers, args.timeout, project_root, args.model,
    )
    new_scores = score_results(new_results)
    print_results("Consolidated (1 skill)", new_results, new_scores)
    all_results["consolidated-single-skill"] = {"results": new_results, "scores": new_scores}

    # Config 3: No plugin baseline
    if not args.skip_baseline:
        print("\n>>> Running: no-plugin (vanilla CC)")
        baseline_results = run_config(
            eval_set, None, "no-plugin",
            args.workers, args.timeout, project_root, args.model,
        )
        baseline_scores = score_results(baseline_results)
        print_results("No Plugin (baseline)", baseline_results, baseline_scores)
        all_results["no-plugin"] = {"results": baseline_results, "scores": baseline_scores}

    # Summary comparison
    print(f"\n{'=' * 60}")
    print("  COMPARISON SUMMARY")
    print(f"{'=' * 60}")
    print(f"  {'Config':<30s} {'Accuracy':>10s} {'Trigger%':>10s} {'FalsePos%':>10s}")
    print(f"  {'-' * 60}")
    for name, data in all_results.items():
        s = data["scores"]
        print(f"  {name:<30s} {s['accuracy']:>9.1%} {s['trigger_rate']:>9.1%} {s['false_positive_rate']:>9.1%}")

    # Save results
    with open(args.output, "w") as f:
        json.dump(all_results, f, indent=2)
    print(f"\nResults saved to {args.output}")


if __name__ == "__main__":
    main()
