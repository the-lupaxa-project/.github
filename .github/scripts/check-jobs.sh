#!/usr/bin/env bash

# This script receives a JSON string containing job results (from `toJson(needs)`)
# and:
#   - prints per-job status (success, failure, cancelled, skipped, timed_out)
#   - emits a GitHub Actions workflow summary (via $GITHUB_STEP_SUMMARY)
#   - emits a single GitHub Actions annotation (error/notice)
#   - exits 1 if any job failed/timed_out, otherwise 0
#
# Example usage in a GitHub Actions step:
#   - name: Check Job Statuses
#     run: .github/scripts/check-jobs.sh '${{ toJson(needs) }}'

set -euo pipefail

# --------------------------------------------------------------------------------
# Globals (job buckets)
# --------------------------------------------------------------------------------

failed_jobs=false

success_list=()
failed_list=()
cancelled_list=()
skipped_list=()
timed_out_list=()
other_list=()

# --------------------------------------------------------------------------------
# ensure_jq: make sure jq is available (attempt installation if missing)
# --------------------------------------------------------------------------------

ensure_jq()
{
    if command -v jq >/dev/null 2>&1; then
        return 0
    fi

    echo "jq not found, attempting to install..." >&2

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

# --------------------------------------------------------------------------------
# parse_jobs: parse JSON input into buckets and print per-job text output
# --------------------------------------------------------------------------------

parse_jobs()
{
    local job_results_json="$1"

    echo "Job results:"
    echo

    local parsed
    parsed=$(echo "${job_results_json}" | jq -r 'to_entries[] | "\(.key) \(.value.result)"') || {
        echo "Failed to parse job results JSON via jq."
        exit 1
    }

    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue

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
    done <<< "${parsed}"

    echo
}

# --------------------------------------------------------------------------------
# write_step_summary: use GitHub's official job summary API
# --------------------------------------------------------------------------------

write_step_summary()
{
    local file="${GITHUB_STEP_SUMMARY:-}"

    [[ -z "${file}" ]] && return 0

    {
        echo "## Job Status Summary"

        if ((${#success_list[@]} > 0)); then
            echo "### Successful jobs"
            for j in "${success_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi

        if ((${#failed_list[@]} > 0)); then
            echo "### Failed jobs"
            for j in "${failed_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi

        if ((${#timed_out_list[@]} > 0)); then
            echo "### Timed out jobs"
            for j in "${timed_out_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi

        if ((${#cancelled_list[@]} > 0)); then
            echo "### Cancelled jobs"
            for j in "${cancelled_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi

        if ((${#skipped_list[@]} > 0)); then
            echo "### Skipped jobs"
            for j in "${skipped_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi

        if ((${#other_list[@]} > 0)); then
            echo "### Other results"
            for j in "${other_list[@]}"; do
                echo "- ${j}"
            done
            echo
        fi
    } >> "${file}"
}

# --------------------------------------------------------------------------------
# emit_annotation: emit a single error/notice annotation summarising everything
# --------------------------------------------------------------------------------

emit_annotation()
{
    local message=""

    if ((${#success_list[@]} > 0)); then
        message+="Success: ${success_list[*]}%0A"
    fi
    if ((${#failed_list[@]} > 0)); then
        message+="Failed: ${failed_list[*]}%0A"
    fi
    if ((${#timed_out_list[@]} > 0)); then
        message+="Timed out: ${timed_out_list[*]}%0A"
    fi
    if ((${#cancelled_list[@]} > 0)); then
        message+="Cancelled: ${cancelled_list[*]}%0A"
    fi
    if ((${#skipped_list[@]} > 0)); then
        message+="Skipped: ${skipped_list[*]}%0A"
    fi
    if ((${#other_list[@]} > 0)); then
        message+="Other: ${other_list[*]}%0A"
    fi

    if [[ "${failed_jobs}" = true ]]; then
        echo "::error title=Job failures::${message}"
    else
        echo "::notice title=Jobs summary::${message}"
    fi
}

# --------------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------------

main()
{
    ensure_jq

    local job_results_json="${1:-}"

    if [[ -z "${job_results_json}" ]]; then
        echo "::error title=check-jobs.sh::No job results JSON provided."
        exit 1
    fi

    parse_jobs "${job_results_json}"
    write_step_summary
    emit_annotation

    if [[ "${failed_jobs}" = true ]]; then
        exit 1
    fi
}

main "$@"