This directory stores raw upstream snapshot inputs captured by `mix notion.refresh`.

- `reference/` contains the exact markdown pages used to extract OpenAPI fixtures.
- `docs/` contains supporting Notion docs used for default-version, retry, and error-parity checks.
- `notion-sdk-js/` contains the vendored JS SDK oracle files used by parity tests.
- `metadata.json` records the upstream JS SDK version, the bounded parity inventory summary, and the tracked snapshot file lists.
