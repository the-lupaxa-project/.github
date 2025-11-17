#!/usr/bin/env bash

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
        echo "ERROR: jq could not be installed or found."
        exit 1
    fi
}

# --------------------------------------------------------------------------------
# parse_jobs: parse JSON input into buckets and print per-job text output
# --------------------------------------------------------------------------------

parse_jobs()
{
    local job_results_json="$1"

    echo
    echo "Job results:"
    echo

    # If in GitHub, also append this header to the summary
    if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
        {
            echo "## Per-job Results"
            echo
        } >> "${GITHUB_STEP_SUMMARY}"
    fi

    local parsed
    parsed=$(echo "${job_results_json}" | jq -r 'to_entries[] | "\(.key) \(.value.result)"') || {
        echo "Failed to parse job results JSON via jq."
        exit 1
    }

    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue

        local job_name result
        job_name=$(echo "${line}" | awk '{print $1}')
        result=$(echo "${line}" | awk '{print $2}')

        local msg=""
        case "${result}" in
            success)
                msg="[OK] ${job_name} succeeded."
                success_list+=("${job_name}")
                ;;
            failure)
                msg="[FAIL] ${job_name} failed."
                failed_list+=("${job_name}")
                failed_jobs=true
                ;;
            cancelled)
                msg="[CANCELLED] ${job_name} was cancelled."
                cancelled_list+=("${job_name}")
                ;;
            skipped)
                msg="[SKIPPED] ${job_name} was skipped."
                skipped_list+=("${job_name}")
                ;;
            timed_out)
                msg="[TIMED OUT] ${job_name} timed out."
                timed_out_list+=("${job_name}")
                failed_jobs=true
                ;;
            *)
                msg="[OTHER] ${job_name} has unknown result: ${result}"
                other_list+=("${job_name}:${result}")
                ;;
        esac

        # print to stdout
        echo "  ${msg}"

        # append to job summary
        if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
            echo "- ${msg}" >> "${GITHUB_STEP_SUMMARY}"
        fi

    done <<< "${parsed}"

    echo
    if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
        echo >> "${GITHUB_STEP_SUMMARY}"
    fi
}

# --------------------------------------------------------------------------------
# print_sorted_section: helper for the summary
# --------------------------------------------------------------------------------

print_sorted_section()
{
    local title="$1"
    shift
    local arr=("$@")

    (( ${#arr[@]} == 0 )) && return

    echo "### ${title}"
    printf '%s\n' "${arr[@]}" | sort | while IFS= read -r j; do
        [[ -z "${j}" ]] && continue
        echo "- ${j}"
    done
    echo
}

# --------------------------------------------------------------------------------
# write_step_summary: use GitHub's official job summary API
# --------------------------------------------------------------------------------

write_step_summary()
{
    local file="${GITHUB_STEP_SUMMARY:-}"

    # If not running in GitHub Actions, nothing to do
    [[ -z "${file}" ]] && return 0

    local total_success total_failed total_cancelled total_skipped total_timed_out total_other total_all

    total_success=${#success_list[@]}
    total_failed=${#failed_list[@]}
    total_cancelled=${#cancelled_list[@]}
    total_skipped=${#skipped_list[@]}
    total_timed_out=${#timed_out_list[@]}
    total_other=${#other_list[@]}
    total_all=$(( total_success + total_failed + total_cancelled + total_skipped + total_timed_out + total_other ))

    # GitHub metadata (may be empty if not running in Actions, but that's fine)
    local wf_name run_number ref_short sha_short
    wf_name="${GITHUB_WORKFLOW:-unknown}"
    run_number="${GITHUB_RUN_NUMBER:-unknown}"
    ref_short="${GITHUB_REF##*/}"
    sha_short="${GITHUB_SHA:-unknown}"
    sha_short="${sha_short::7}"

    {
        echo "## Job Status Overview"
        echo
        echo "### Workflow metadata"
        echo "- **Workflow:** ${wf_name}"
        echo "- **Run:** #${run_number}"
        echo "- **Ref:** ${ref_short}"
        echo "- **Commit:** ${sha_short}"
        echo "- **Generated at (UTC):** $(date -u +"%Y-%m-%d %H:%M:%S")"
        echo
        echo "### Total jobs ${total_all}"
        echo

        print_sorted_section "Successful jobs" "${success_list[@]}"
        print_sorted_section "Failed jobs" "${failed_list[@]}"
        print_sorted_section "Timed out jobs" "${timed_out_list[@]}"
        print_sorted_section "Cancelled jobs" "${cancelled_list[@]}"
        print_sorted_section "Skipped jobs" "${skipped_list[@]}"
        print_sorted_section "Other statuses" "${other_list[@]}"

        echo "---"
        if [[ "${failed_jobs}" = true ]]; then
            echo "**One or more jobs failed or timed out.**"
        else
            echo "**All jobs completed successfully.**"
        fi

    } >> "${file}"
}

# --------------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------------

main()
{
    init_colors
    ensure_jq

    local job_results_json="${1:-}"

    if [[ -z "${job_results_json}" ]]; then
        echo "ERROR: No job results JSON provided."
        exit 1
    fi

    parse_jobs "${job_results_json}"
    write_step_summary

    if [[ "${failed_jobs}" = true ]]; then
        echo
        echo "One or more jobs failed or timed out."
        exit 1
    else
        echo
        echo "All jobs completed successfully."
        exit 0
    fi
}

main "$@"