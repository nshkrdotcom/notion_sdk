# Repository Guidelines

## Project Structure
- `lib/` contains public `NotionSDK` modules.
- `codegen/` and `build_support/` support OpenAPI generation and dependency resolution.
- `test/` contains ExUnit coverage.
- `doc/` is generated output and should not be edited.

## Execution Plane Stack
- `notion_sdk` consumes `pristine` as the semantic HTTP runtime; do not reach into raw `execution_plane` internals.
- Keep `pristine` dependency resolution publish-aware through `build_support/dependency_resolver.exs`.

## Gates
- Run `mix format`.
- Run `mix compile --warnings-as-errors`.
- Run `mix test`.
- Run `mix credo --strict`.
- Run `mix dialyzer`.
- Run `mix docs --warnings-as-errors`.
