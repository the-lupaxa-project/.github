#!/usr/bin/env bash

# This script receives a JSON string containing job results (from `toJson(needs)`)
# and checks for any failures. It prints a line per job and a summary by status.

set -euo pipefail

# Check if jq is available
if ! command -v jq > /dev/null 2>&1; then
    echo "jq could not be found, please install jq to run this script."
    exit 1
fi

# Read the JSON string from the first argument
job_results_json="${1:-}"

# Handle no dependencies
if [[ -z "${job_results_json}" || "${job_results_json}" == "null" ]]; then
    echo "No upstream jobs to check — skipping status inspection."
    exit 0
fi

# Counters
success_count=0
failure_count=0
cancelled_count=0
skipped_count=0
timed_out_count=0
other_count=0

failed_jobs=false

echo "Checking upstream job results..."
echo

# Expect lines like: "<job_name>\t<result>"
while IFS=$'\t' read -r job_name result; do
    case "${result}" in
        success)
            echo "${job_name}: succeeded."
            success_count=$((success_count + 1))
            ;;
        failure)
            echo "${job_name}: FAILED."
            failure_count=$((failure_count + 1))
            failed_jobs=true
            ;;
        cancelled)
            echo "${job_name}: cancelled."
            cancelled_count=$((cancelled_count + 1))
            failed_jobs=true
            ;;
        skipped)
            echo "${job_name}: skipped."
            skipped_count=$((skipped_count + 1))
            ;;
        timed_out)
            echo "${job_name}: timed out."
            timed_out_count=$((timed_out_count + 1))
            failed_jobs=true
            ;;
        *)
            echo "${job_name}: had unexpected result '${result}'."
            other_count=$((other_count + 1))
            failed_jobs=true
            ;;
    esac
done <<< "$(
    echo "${job_results_json}" \
      | jq -r 'to_entries[] | "\(.key)\t\(.value.result)"'
)"

echo
echo "Summary:"
echo "  success  : ${success_count}"
echo "  failure  : ${failure_count}"
echo "  cancelled: ${cancelled_count}"
echo "  skipped  : ${skipped_count}"
echo "  timed_out: ${timed_out_count}"
echo "  other    : ${other_count}"
echo

if [[ "${failed_jobs}" == true ]]; then
    echo "One or more upstream jobs did not succeed — failing."
    exit 1
fi

echo "All upstream jobs are in acceptable states."
exit 0