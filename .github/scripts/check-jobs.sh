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

# Colours (initially empty; set in init_colors)
BOLD=""
RESET=""
GREEN=""
RED=""
YELLOW=""
CYAN=""

# --------------------------------------------------------------------------------
# init_colors: set up colour variables if supported
# --------------------------------------------------------------------------------

init_colors()
{
    if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
        BOLD="$(tput bold || true)"
        RESET="$(tput sgr0 || true)"
        GREEN="$(tput setaf 2 || true)"
        RED="$(tput setaf 1 || true)"
        YELLOW="$(tput setaf 3 || true)"
        CYAN="$(tput setaf 6 || true)"
    else
        BOLD=""
        RESET=""
        GREEN=""
        RED=""
        YELLOW=""
        CYAN=""
    fi
}

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
    echo "${CYAN}Job results:${RESET}"
    echo

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
                echo "  ${GREEN}[OK]${RESET} ${job_name} succeeded."
                success_list+=("${job_name}")
                ;;
            failure)
                echo "  ${RED}[FAIL]${RESET} ${job_name} failed."
                failed_list+=("${job_name}")
                failed_jobs=true
                ;;
            cancelled)
                echo "  ${YELLOW}[CANCELLED]${RESET} ${job_name} was cancelled."
                cancelled_list+=("${job_name}")
                ;;
            skipped)
                echo "  ${YELLOW}[SKIPPED]${RESET} ${job_name} was skipped."
                skipped_list+=("${job_name}")
                ;;
            timed_out)
                echo "  ${RED}[TIMED OUT]${RESET} ${job_name} timed out."
                timed_out_list+=("${job_name}")
                failed_jobs=true
                ;;
            *)
                echo "  [OTHER] ${job_name} has unknown result: ${result}"
                other_list+=("${job_name}:${result}")
                ;;
        esac
    done <<< "${parsed}"

    echo
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

    {
        echo "## Job Status Summary"
        echo

        echo "### Totals"
        echo "- Total jobs: ${total_all}"
        echo "- Successful: ${total_success}"
        echo "- Failed: ${total_failed}"
        echo "- Timed out: ${total_timed_out}"
        echo "- Cancelled: ${total_cancelled}"
        echo "- Skipped: ${total_skipped}"
        echo "- Other: ${total_other}"
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
        echo "${RED}One or more jobs failed or timed out.${RESET}"
        exit 1
    else
        echo
        echo "${GREEN}All jobs completed successfully.${RESET}"
        exit 0
    fi
}

main "$@"