#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SMOKE=(
  "00_smoke.exs"
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

OAUTH=(
  "16_oauth_introspect.exs"
  "18_oauth_refresh_and_get_self.exs"
  "17_oauth_bearer_get_self.exs"
)

usage() {
  cat <<'EOF'
usage: ./examples/run_all.sh <suite>

Suites:
  smoke       Run the first real smoke flow.
  content     Run page, block, and comment examples.
  data        Run database and data source examples.
  files       Run file upload examples, including real upload creation.
  all         Run every non-OAuth example.
  oauth       Run the real OAuth examples.
  everything  Run every example, including OAuth.

This runner is strict:
  - missing env vars fail
  - API failures fail
  - the script stops on the first failing example

File suite prerequisite:
  - `files`, `all`, and `everything` require `NOTION_EXAMPLE_FILE_URL`
    for `13_create_external_file_upload.exs`

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
    all)
      printf '%s\n' "${SMOKE[@]}" "${CONTENT[@]}" "${DATA[@]}" "${FILES[@]}"
      ;;
    oauth)
      printf '%s\n' "${OAUTH[@]}"
      ;;
    everything)
      printf '%s\n' "${SMOKE[@]}" "${CONTENT[@]}" "${DATA[@]}" "${FILES[@]}" "${OAUTH[@]}"
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
