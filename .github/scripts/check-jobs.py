#!/usr/bin/env python3
"""
Central GitHub Actions job status summariser.

Modes:
- No arguments: fetch jobs for the current run via GitHub API.
- One argument: treat as path to a JSON file containing job results
  (either /jobs API shape or toJson(needs) shape).

Writes a markdown summary into GITHUB_STEP_SUMMARY (if set).
"""

import json
import os
import sys
import urllib.request
from datetime import datetime, timezone
from typing import Any, Dict, List, Tuple


def ordinal_suffix(day: int) -> str:
    """Return HTML <sup> suffix for day number (st, nd, rd, th)."""
    if day in (1, 21, 31):
        suf = "st"
    elif day in (2, 22):
        suf = "nd"
    elif day in (3, 23):
        suf = "rd"
    else:
        suf = "th"
    return f"<sup>{suf}</sup>"


def build_human_timestamp() -> str:
    """Build a human-readable UTC timestamp matching the Bash version."""
    now = datetime.now(timezone.utc)
    day = now.day
    suffix = ordinal_suffix(day)
    dow = now.strftime("%A")
    month_name = now.strftime("%B")
    year = now.strftime("%Y")
    time_str = now.strftime("%H:%M:%S")
    return f"{dow} {day}{suffix} {month_name} {year} {time_str}"


def fetch_jobs_json_from_api() -> Dict[str, Any]:
    """Call GitHub API for the current run's jobs (matrix-aware)."""
    repo = os.environ.get("GITHUB_REPOSITORY")
    run_id = os.environ.get("GITHUB_RUN_ID")
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("ACTIONS_RUNTIME_TOKEN")

    if not repo or not run_id:
        print(
            "ERROR: GITHUB_REPOSITORY or GITHUB_RUN_ID not set; cannot call GitHub API.",
            file=sys.stderr,
        )
        sys.exit(1)

    if not token:
        print(
            "ERROR: GITHUB_TOKEN (or ACTIONS_RUNTIME_TOKEN) is not set; cannot call GitHub API.",
            file=sys.stderr,
        )
        sys.exit(1)

    url = f"https://api.github.com/repos/{repo}/actions/runs/{run_id}/jobs?per_page=100"
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "User-Agent": "lupaxa-check-jobs-status",
    }

    req = urllib.request.Request(url, headers=headers)

    try:
        with urllib.request.urlopen(req) as resp:
            status = resp.getcode()
            body_bytes = resp.read()
    except Exception as exc:
        print(f"ERROR: Failed to call GitHub API: {exc}", file=sys.stderr)
        sys.exit(1)

    if status != 200:
        body = body_bytes.decode("utf-8", errors="replace")
        print(f"ERROR: GitHub API returned HTTP {status}", file=sys.stderr)
        print("Response body was:", file=sys.stderr)
        print(body, file=sys.stderr)
        sys.exit(1)

    try:
        return json.loads(body_bytes)
    except json.JSONDecodeError as exc:
        print("ERROR: Failed to decode GitHub API JSON:", file=sys.stderr)
        print(str(exc), file=sys.stderr)
        sys.exit(1)


def load_jobs_json_from_file(path: str) -> Dict[str, Any]:
    """Load jobs JSON from a file path (for future toJson(needs) usage)."""
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"ERROR: JSON file not found: {path}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as exc:
        print(f"ERROR: JSON in file {path} is invalid:", file=sys.stderr)
        print(str(exc), file=sys.stderr)
        sys.exit(1)


def normalise_job_name(raw: str) -> str:
    """
    Normalise job name:
    - If it contains a slash, keep only the right-hand side.
    - Trim whitespace.
    """
    if "/" in raw:
        raw = raw.rsplit("/", 1)[-1]
    return raw.strip()


def should_skip_status_job(name: str) -> bool:
    """
    Skip umbrella 'Status' jobs unless CHECK_JOBS_INCLUDE_STATUS=1.
    """
    if os.environ.get("CHECK_JOBS_INCLUDE_STATUS", "0") == "1":
        return False

    name_stripped = name.strip()
    if (
        name_stripped.endswith(" Status")
        or name_stripped == "Status"
        or name_stripped.endswith("Status")
    ):
        return True
    return False


def bucket_jobs(
    data: Dict[str, Any],
) -> Tuple[List[str], List[str], List[str], List[str], List[str], List[str]]:
    """
    Bucket jobs into:
      success, failure, cancelled, skipped, timed_out, other (name:result).
    Supports:
      1) GitHub /jobs API format: { "jobs": [ { "name": "...", "conclusion": "success" }, ... ] }
      2) toJson(needs) style: { "job_id": { "result": "success", ... }, ... }
    """
    success: List[str] = []
    failure: List[str] = []
    cancelled: List[str] = []
    skipped: List[str] = []
    timed_out: List[str] = []
    other: List[str] = []

    # Shape 1: /jobs API
    if isinstance(data, dict) and "jobs" in data and isinstance(data["jobs"], list):
        jobs_list = data["jobs"]
        for job in jobs_list:
            if not isinstance(job, dict):
                continue
            raw_name = str(job.get("name", ""))
            conclusion = str(job.get("conclusion", "unknown") or "unknown")

            job_name = normalise_job_name(raw_name)
            if not job_name or should_skip_status_job(job_name):
                continue

            if conclusion == "success":
                success.append(job_name)
            elif conclusion == "failure":
                failure.append(job_name)
            elif conclusion == "cancelled":
                cancelled.append(job_name)
            elif conclusion == "skipped":
                skipped.append(job_name)
            elif conclusion == "timed_out":
                timed_out.append(job_name)
            else:
                other.append(f"{job_name}:{conclusion}")
        return success, failure, cancelled, skipped, timed_out, other

    # Shape 2: toJson(needs) style
    if isinstance(data, dict):
        for key, value in data.items():
            raw_name = str(key)
            # prefer 'result', fallback 'conclusion' if present
            if isinstance(value, dict):
                result = value.get("result") or value.get("conclusion") or "unknown"
            else:
                result = "unknown"

            result = str(result)
            job_name = normalise_job_name(raw_name)
            if not job_name or should_skip_status_job(job_name):
                continue

            if result == "success":
                success.append(job_name)
            elif result == "failure":
                failure.append(job_name)
            elif result == "cancelled":
                cancelled.append(job_name)
            elif result == "skipped":
                skipped.append(job_name)
            elif result == "timed_out":
                timed_out.append(job_name)
            else:
                other.append(f"{job_name}:{result}")

        return success, failure, cancelled, skipped, timed_out, other

    print("ERROR: Unsupported JSON structure for job results.", file=sys.stderr)
    sys.exit(1)


def print_sorted_section(lines: List[str], title: str, out) -> None:
    if not lines:
        return
    print(f"### {title}", file=out)
    for name in sorted(set(lines), key=str.casefold):
        if not name:
            continue
        print(f"- {name}", file=out)
    print(file=out)


def maybe_read_pr_metadata() -> Tuple[str, str]:
    """Read PR number and title from GITHUB_EVENT_PATH if available."""
    event_path = os.environ.get("GITHUB_EVENT_PATH")
    if not event_path or not os.path.isfile(event_path):
        return "", ""

    try:
        with open(event_path, "r", encoding="utf-8") as f:
            payload = json.load(f)
    except Exception:
        return "", ""

    pr = payload.get("pull_request") or {}
    number = pr.get("number")
    title = pr.get("title")

    if number:
        return str(number), str(title or "")
    return "", ""


def write_step_summary(
    success: List[str],
    failure: List[str],
    cancelled: List[str],
    skipped: List[str],
    timed_out: List[str],
    other: List[str],
) -> None:
    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if not summary_path:
        # Not running in GitHub Actions (or summaries disabled)
        return

    repo = os.environ.get("GITHUB_REPOSITORY", "")
    workflow = os.environ.get("GITHUB_WORKFLOW", "")
    run_number = os.environ.get("GITHUB_RUN_NUMBER", "")
    run_attempt = os.environ.get("GITHUB_RUN_ATTEMPT", "")
    event_name = os.environ.get("GITHUB_EVENT_NAME", "")
    actor = os.environ.get("GITHUB_ACTOR", "unknown")
    triggering_actor = os.environ.get("GITHUB_TRIGGERING_ACTOR", "")
    ref_name = os.environ.get("GITHUB_REF_NAME", "")
    sha = os.environ.get("GITHUB_SHA", "")
    run_id = os.environ.get("GITHUB_RUN_ID", "")

    pr_number, pr_title = maybe_read_pr_metadata()
    generated_at = build_human_timestamp()

    with open(summary_path, "a", encoding="utf-8") as out:
        print("## Job Status Overview", file=out)
        print(file=out)

        print_sorted_section(success, "Successful jobs", out)
        print_sorted_section(failure, "Failed jobs", out)
        print_sorted_section(timed_out, "Timed out jobs", out)
        print_sorted_section(cancelled, "Cancelled jobs", out)
        print_sorted_section(skipped, "Skipped jobs", out)
        print_sorted_section(other, "Other statuses", out)

        print("### Workflow metadata", file=out)
        print(file=out)
        print("| Field  | Value   |", file=out)
        print("| :----- | :------ |", file=out)

        print(f"| Repository | {repo} |", file=out)
        print(f"| Workflow | {workflow} |", file=out)
        print(f"| Run number | #{run_number} |", file=out)
        print(f"| Attempt | {run_attempt} |", file=out)
        print(f"| Event | {event_name} |", file=out)

        print(f"| Actor | {actor} |", file=out)
        if triggering_actor and triggering_actor != actor:
            print(f"| Triggering actor | {triggering_actor} |", file=out)

        print(f"| Ref | {ref_name} |", file=out)
        print(f"| Commit SHA | {sha} |", file=out)
        if repo and run_id:
            print(
                f"| Run URL | https://github.com/{repo}/actions/runs/{run_id} |",
                file=out,
            )

        if pr_number:
            print(f"| PR | #{pr_number}: {pr_title} |", file=out)
            if repo:
                print(
                    f"| PR URL | https://github.com/{repo}/pull/{pr_number} |", file=out
                )

        print(f"| Generated at (UTC) | {generated_at} |", file=out)
        print(file=out)


def main() -> None:
    # Decide where to get job JSON from
    if len(sys.argv) > 1:
        data = load_jobs_json_from_file(sys.argv[1])
    else:
        data = fetch_jobs_json_from_api()

    success, failure, cancelled, skipped, timed_out, other = bucket_jobs(data)
    write_step_summary(success, failure, cancelled, skipped, timed_out, other)


if __name__ == "__main__":
    main()
