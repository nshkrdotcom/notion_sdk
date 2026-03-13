#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SMOKE=(
  "00_smoke.exs"
  "19_retrieve_user.exs"
)

CONTENT=(
  "01_retrieve_page.exs"
  "02_retrieve_page_property.exs"
  "03_retrieve_page_markdown.exs"
  "04_retrieve_first_child_block.exs"
  "05_list_page_children.exs"
  "06_list_page_comments.exs"
)

DATA=(
  "07_retrieve_database.exs"
  "08_retrieve_data_source.exs"
  "09_query_data_source.exs"
  "10_list_data_source_templates.exs"
  "11_collect_data_source_templates.exs"
)

FILES=(
  "12_list_file_uploads.exs"
  "13_create_external_file_upload.exs"
  "14_retrieve_file_upload.exs"
  "15_upload_small_text_file.exs"
)

MUTATIONS=(
  "20_create_page.exs"
  "21_update_page.exs"
  "22_move_page.exs"
  "23_update_page_markdown.exs"
  "24_append_block_children.exs"
  "25_update_block.exs"
  "26_delete_block.exs"
  "27_create_comment.exs"
  "28_retrieve_comment.exs"
  "29_create_database.exs"
  "30_update_database.exs"
  "31_create_data_source.exs"
  "32_update_data_source.exs"
  "33_complete_file_upload.exs"
)

OAUTH=(
  "16_oauth_introspect.exs"
  "17_oauth_bearer_get_self.exs"
  "18_oauth_refresh_and_get_self.exs"
  "34_oauth_token_exchange.exs"
  "35_oauth_revoke.exs"
)

COOKBOOK=(
  "cookbook/01_create_page_with_blocks.exs"
  "cookbook/02_create_and_query_data_source.exs"
  "cookbook/03_upload_and_attach_file.exs"
  "cookbook/04_search_paginate_and_branch.exs"
  "cookbook/05_oauth_onboard_and_call_api.exs"
)

usage() {
  cat <<'EOF'
usage: ./examples/run_all.sh <suite>

Suites:
  smoke       Run the core auth and users smoke flows.
  content     Run page, block, and comment examples.
  data        Run database and data source examples.
  files       Run file upload examples, including real upload creation.
  mutations   Run write-heavy page, block, comment, database, data source, and file-complete proofs.
  all         Run every non-OAuth example.
  oauth       Run the real OAuth examples.
  cookbook    Run the task-oriented workflow examples.
  everything  Run every example, including OAuth.

This runner is strict:
  - missing env vars fail
  - API failures fail
  - the script stops on the first failing example

File suite prerequisite:
  - `files`, `all`, and `everything` require `NOTION_EXAMPLE_FILE_URL`
    for `13_create_external_file_upload.exs`
  - `mutations`, `all`, and `everything` also include
    `33_complete_file_upload.exs`, which requires a workspace plan that
    supports multipart uploads
  - `34_oauth_token_exchange.exs` uses `NOTION_OAUTH_AUTH_CODE` when set,
    otherwise it prints an authorization URL and prompts for the redirected URL

Read examples/README.md before running anything beyond the smoke flow.
EOF
}

run_example() {
  local script="$1"
  echo
  echo "==> ${script}"
  (
    cd "$ROOT_DIR"
    mix run "examples/${script}"
  )
}

build_suite() {
  local suite="$1"

  case "$suite" in
    smoke)
      printf '%s\n' "${SMOKE[@]}"
      ;;
    content)
      printf '%s\n' "${CONTENT[@]}"
      ;;
    data)
      printf '%s\n' "${DATA[@]}"
      ;;
    files)
      printf '%s\n' "${FILES[@]}"
      ;;
    mutations)
      printf '%s\n' "${MUTATIONS[@]}"
      ;;
    all)
      printf '%s\n' "${SMOKE[@]}" "${CONTENT[@]}" "${DATA[@]}" "${FILES[@]}" "${MUTATIONS[@]}"
      ;;
    oauth)
      printf '%s\n' "${OAUTH[@]}"
      ;;
    cookbook)
      printf '%s\n' "${COOKBOOK[@]}"
      ;;
    everything)
      printf '%s\n' "${SMOKE[@]}" "${CONTENT[@]}" "${DATA[@]}" "${FILES[@]}" "${MUTATIONS[@]}" "${OAUTH[@]}"
      ;;
    *)
      echo "unknown suite: ${suite}" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main() {
  local suite="${1:-all}"

  case "$suite" in
    -h|--help|help)
      usage
      exit 0
      ;;
  esac

  mapfile -t scripts < <(build_suite "$suite")

  echo "Running suite: ${suite}"
  echo "Repo root: ${ROOT_DIR}"

  for script in "${scripts[@]}"; do
    run_example "$script"
  done

  echo
  echo "Suite completed: ${suite}"
}

main "$@"
