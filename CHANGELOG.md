# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-03-27

### Added

- Added the shared provider-compiler integration through
  `codegen/notion_sdk/codegen/provider.ex`, source plugins, provider IR output,
  `generation_manifest.json`, `docs_inventory.json`, `source_inventory.json`,
  and generated runtime schema artifacts.
- Added `NotionSDK.OAuth` and the internal provider profile runtime wiring to
  align the SDK with the current `pristine` runtime boundary.
- Added artifact freshness, provider contract, and generated-surface contract
  tests around the new compiler and runtime integration.

### Changed

- Migrated generated request execution to the
  `Pristine.SDK.OpenAPI.Client` and `Pristine.execute_request/3` boundary.
- Refreshed the generated Notion surface, regeneration workflow, and docs to
  match the shared `pristine` codegen/runtime stack.
- Updated local dependency resolution so sibling checkouts still win while
  non-workspace installs default to Hex `pristine ~> 0.2.0`.

### Fixed

- Improved error, retry, pagination, OAuth, and low-level request behavior
  across the rebuilt generated surface.

## [0.1.0] - 2026-03-14

Initial release.

[0.2.0]: https://github.com/nshkrdotcom/notion_sdk/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/nshkrdotcom/notion_sdk/releases/tag/v0.1.0
