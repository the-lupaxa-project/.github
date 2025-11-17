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
# Globals
# --------------------------------------------------------------------------------

failed_jobs=false

# Buckets
success_list=()
failed_list=()
cancelled_list=()
skipped_list=()
timed_out_list=()
other_list=()

summary=""

# --------------------------------------------------------------------------------
# Ensure jq is available (attempt installation if missing)
# --------------------------------------------------------------------------------

ensure_jq()
{
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

# --------------------------------------------------------------------------------
# Parse job results JSON into buckets
# --------------------------------------------------------------------------------

parse_job_results()
{
    local job_results_json=$1
    local parsed_jobs

    if [[ -z "${job_results_json}" ]]; then
        echo "::error title=check-jobs.sh::No job results JSON provided."
        exit 1
    fi

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
}

# --------------------------------------------------------------------------------
# Build multi-line summary text
# --------------------------------------------------------------------------------

format_list_multiline()
{
    local title=$1
    shift
    local items=("$@")

    if ((${#items[@]} == 0)); then
        return 0
    fi

    summary+="${title}:\n"
    for item in "${items[@]}"; do
        summary+="  - ${item}\n"
    done
    summary+="\n"
}

build_summary()
{
    # Reset summary in case this function is called more than once
    summary=""

    format_list_multiline "Successful jobs"   "${success_list[@]}"
    format_list_multiline "Failed jobs"       "${failed_list[@]}"
    format_list_multiline "Timed-out jobs"    "${timed_out_list[@]}"
    format_list_multiline "Cancelled jobs"    "${cancelled_list[@]}"
    format_list_multiline "Skipped jobs"      "${skipped_list[@]}"
    format_list_multiline "Other job results" "${other_list[@]}"
}

# --------------------------------------------------------------------------------
# Emit GitHub Actions annotation (with proper newline escaping)
# --------------------------------------------------------------------------------

emit_annotation()
{
    local rendered

    # Turn the \n sequences into real newlines
    printf -v rendered '%b' "${summary}"

    # For GitHub workflow commands, newlines and % must be percent-encoded
    rendered=${rendered//'%'/'%25'}
    rendered=${rendered//$'\r'/'%0D'}
    rendered=${rendered//$'\n'/'%0A'}

    if [[ "${failed_jobs}" == true ]]; then
        echo "::error title=Job failures::${rendered}"
        return 1
    else
        echo "::notice title=Jobs summary::${rendered}"
        return 0
    fi
}

# --------------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------------

main()
{
    local job_results_json=${1:-}

    ensure_jq
    parse_job_results "${job_results_json}"
    build_summary
    emit_annotation
}

main "$@"