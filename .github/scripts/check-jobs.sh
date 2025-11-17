#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------------------------------------------------
# Globals (job buckets)
# --------------------------------------------------------------------------------

success_list=()
failed_list=()
cancelled_list=()
skipped_list=()
timed_out_list=()
other_list=()

# ------------------------------------------------------------------------
# GitHub Actions environment variables (defined at runtime)
# Declared here only to silence ShellCheck warnings (SC2154 etc.)
# ------------------------------------------------------------------------
: "${GITHUB_REPOSITORY:=}"
: "${GITHUB_WORKFLOW:=}"
: "${GITHUB_RUN_NUMBER:=}"
: "${GITHUB_RUN_ATTEMPT:=}"
: "${GITHUB_EVENT_NAME:=}"
: "${GITHUB_ACTOR:=}"
: "${GITHUB_TRIGGERING_ACTOR:=}"
: "${GITHUB_REF_NAME:=}"
: "${GITHUB_SHA:=}"
: "${GITHUB_RUN_ID:=}"
: "${GITHUB_STEP_SUMMARY:=}"
: "${GITHUB_EVENT_PATH:=}"

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

        case "${result}" in
            success)
                success_list+=("${job_name}")
                ;;
            failure)
                failed_list+=("${job_name}")
                ;;
            cancelled)
                cancelled_list+=("${job_name}")
                ;;
            skipped)
                skipped_list+=("${job_name}")
                ;;
            timed_out)
                timed_out_list+=("${job_name}")
                ;;
            *)
                other_list+=("${job_name}:${result}")
                ;;
        esac

    done <<< "${parsed}"
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

    {
        echo "## Job Status Overview"
        echo

        print_sorted_section "Successful jobs" "${success_list[@]}"
        print_sorted_section "Failed jobs" "${failed_list[@]}"
        print_sorted_section "Timed out jobs" "${timed_out_list[@]}"
        print_sorted_section "Cancelled jobs" "${cancelled_list[@]}"
        print_sorted_section "Skipped jobs" "${skipped_list[@]}"
        print_sorted_section "Other statuses" "${other_list[@]}"

        echo
        echo "### Workflow metadata"
        echo
        echo "| Field | Value |"
        echo "|-------|--------|"

        echo "| Repository | ${GITHUB_REPOSITORY} |"
        echo "| Workflow | ${GITHUB_WORKFLOW} |"
        echo "| Run number | #${GITHUB_RUN_NUMBER} |"
        echo "| Attempt | ${GITHUB_RUN_ATTEMPT} |"
        echo "| Event | ${GITHUB_EVENT_NAME} |"

        actor="${GITHUB_ACTOR:-unknown}"
        trigger="${GITHUB_TRIGGERING_ACTOR:-}"

        echo "| Actor | ${actor} |"
        if [[ -n "${trigger}" && "${trigger}" != "${actor}" ]]; then
            echo "| Triggering actor | ${trigger} |"
        fi

        echo "| Ref | ${GITHUB_REF_NAME} |"
        echo "| Commit SHA | ${GITHUB_SHA} |"
        echo "| Run URL | https://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID} |"

        # Pull Request metadata (if applicable)
        if [[ -f "${GITHUB_EVENT_PATH}" ]]; then
            pr_number=$(jq -r '.pull_request.number // empty' "${GITHUB_EVENT_PATH}")
            pr_title=$(jq -r '.pull_request.title // empty' "${GITHUB_EVENT_PATH}")

            if [[ -n "${pr_number}" ]]; then
                echo "| PR | #${pr_number}: ${pr_title} |"
                echo "| PR URL | https://github.com/${GITHUB_REPOSITORY}/pull/${pr_number} |"
            fi
        fi

        generated_at="$(date -u +"%Y-%m-%d %H:%M:%S")"
        echo "| Generated at (UTC) | ${generated_at} |"
        echo

    } >> "${file}"
}

# --------------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------------

main()
{
    ensure_jq

    local job_results_json="${1:-}"

    if [[ -z "${job_results_json}" ]]; then
        echo "ERROR: No job results JSON provided."
        exit 1
    fi

    parse_jobs "${job_results_json}"
    write_step_summary
}

main "$@"