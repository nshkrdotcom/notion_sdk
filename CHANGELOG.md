# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- Added `NotionSDK.GovernedAuthority` and governed client construction so
  Notion base URL, credential handles, workspace identity, target identity,
  redaction policy, and credential headers can be materialized by external
  authority before runtime execution.

### Changed

- Clarified that env vars, app-env defaults, OAuth saved-token files,
  request-level auth overrides, and OAuth client credential overrides are
  standalone compatibility only and cannot satisfy governed authority.
- Replaced the upstream snapshot Notion ID helper's pattern-engine parsing
  with fixed delimiter and bounded character checks.

## [0.2.1] - 2026-04-01

### Changed

- Bumped the runtime dependency floor to Hex `pristine ~> 0.2.1`.
- Clarified the ownership split between `pristine`, `NotionSDK.OAuth`, and
  higher-level install and secret-management systems.
- Refreshed README and guide installation snippets to point at `notion_sdk`
  `~> 0.2.1`.

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

[0.2.1]: https://github.com/nshkrdotcom/notion_sdk/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/nshkrdotcom/notion_sdk/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/nshkrdotcom/notion_sdk/releases/tag/v0.1.0
