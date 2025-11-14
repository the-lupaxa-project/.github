#!/usr/bin/env bash

# This script receives a JSON string containing job results (from `toJson(needs)`)
# and:
#   - prints per-job status (success, failure, cancelled, skipped, timed_out)
#   - emits a single GitHub Actions annotation summarising the result
#   - exits 1 if any job failed/timed_out, otherwise 0
#
# Example usage in a GitHub Actions step:
#   - name: Check Job Statuses
#     run: .github/scripts/check-jobs.sh '${{ toJson(needs) }}'

# --------------------------------------------------------------------------------
# Ensure jq is available (attempt installation if missing)
# --------------------------------------------------------------------------------

ensure_jq() {
    if command -v jq >/dev/null 2>&1; then
        return 0
    fi

    echo "jq not found, attempting to install..." >&2

    # Try a few common package managers – this script is primarily intended
    # for GitHub-hosted runners (ubuntu-latest), where apt-get is available.
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update -y >/dev/null 2>&1 || true
        sudo apt-get install -y jq >/dev/null 2>&1 || true
    elif command -v apk >/dev/null 2>&1; then
        sudo apk add --no-cache jq >/dev/null 2>&1 || true
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y jq >/dev/null 2>&1 || true
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "::error title=check-jobs.sh::jq could not be installed or found on PATH."
        exit 1
    fi
}

ensure_jq

# --------------------------------------------------------------------------------
# Input handling
# --------------------------------------------------------------------------------

job_results_json=$1

if [[ -z "${job_results_json}" ]]; then
    echo "::error title=check-jobs.sh::No job results JSON provided."
    exit 1
fi

failed_jobs=false

# Buckets
success_list=()
failed_list=()
cancelled_list=()
skipped_list=()
timed_out_list=()
other_list=()

echo "Job results:"
echo

parsed_jobs=$(echo "${job_results_json}" | jq -r 'to_entries[] | "\(.key) \(.value.result)"') || {
    echo "Failed to parse job results JSON via jq."
    exit 1
}

# Format from jq: "<job_name> <result>"
# where result ∈ { success, failure, cancelled, skipped, timed_out, ... }
while IFS= read -r line; do
    job_name=$(echo "${line}" | awk '{print $1}')
    result=$(echo "${line}" | awk '{print $2}')

    case "${result}" in
        success)
            echo "  ✓ ${job_name} succeeded."
            success_list+=("${job_name}")
            ;;
        failure)
            echo "  ✗ ${job_name} FAILED."
            failed_list+=("${job_name}")
            failed_jobs=true
            ;;
        cancelled)
            echo "  ! ${job_name} was cancelled."
            cancelled_list+=("${job_name}")
            ;;
        skipped)
            echo "  - ${job_name} was skipped."
            skipped_list+=("${job_name}")
            ;;
        timed_out)
            echo "  ⏱ ${job_name} TIMED OUT."
            timed_out_list+=("${job_name}")
            failed_jobs=true
            ;;
        *)
            echo "  ? ${job_name} has unknown result: ${result}"
            other_list+=("${job_name}:${result}")
            ;;
    esac
done <<< "${parsed_jobs}"

echo

# --------------------------------------------------------------------------------
# Build and emit summary annotation
# --------------------------------------------------------------------------------

join_by_comma() {
    local IFS=', '
    echo "$*"
}

summary=""

if ((${#success_list[@]} > 0)); then
    summary+="Success: $(join_by_comma "${success_list[@]}"). "
fi
if ((${#failed_list[@]} > 0)); then
    summary+="Failed: $(join_by_comma "${failed_list[@]}"). "
fi
if ((${#timed_out_list[@]} > 0)); then
    summary+="Timed out: $(join_by_comma "${timed_out_list[@]}"). "
fi
if ((${#cancelled_list[@]} > 0)); then
    summary+="Cancelled: $(join_by_comma "${cancelled_list[@]}"). "
fi
if ((${#skipped_list[@]} > 0)); then
    summary+="Skipped: $(join_by_comma "${skipped_list[@]}"). "
fi
if ((${#other_list[@]} > 0)); then
    summary+="Other: $(join_by_comma "${other_list[@]}"). "
fi

if [[ "${failed_jobs}" = true ]]; then
    # This will show up as a red annotation in the workflow summary
    echo "::error title=Lint job failures::${summary}"
    exit 1
else
    # Notice still appears in the Annotations section but does not fail the job
    echo "::notice title=Lint jobs summary::${summary}"
    exit 0
fi