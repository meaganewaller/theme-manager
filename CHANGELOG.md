# Changelog

All notable changes to this project will be documented in this file.

This project follows:

- [Semantic Versioning](https://semver.org/)
- A **human-readable changelog** philosophy

Behavioral changes are documented explicitly.
Silent changes are considered bugs.

## [0.1.0] - Initial Release

### Added

- Initial `theme-manager` CLI
  - `theme-manager list`
  - `theme-manager current`
  - `theme-manager apply <theme>`
  - `theme-manager explain <theme>`

- Declarative theme system
  - Themes defined as static `theme.json` files
  - One theme name maps to multiple surfaces

- Surface-based application architecture
  - Independent apply scripts per surface
  - Initial supported surfaces:
    - terminal
    - git
    - editor
    - OS appearance (macOS)

- Deterministic apply pipeline
  - Resolve theme → validate JSON → apply surfaces
  - Explicit failures on invalid input

- Idempotent application model
  - Re-applying the same theme is safe
  - No accumulated or hidden state

- State tracking
  - Current theme stored explicitly in config directory
  - No inference or environment detection

- Documentation
  - README with scope and usage
  - Architecture document defining boundaries and non-goals

### Design Constraints (Intentional)

- Theme selection is handled externally
- No environment or profile detection
- No implicit defaults or inference
- No plugin system
- No cross-surface coupling

These constraints are deliberate and define the scope of the tool.

## [0.2.0] - 2025-02-10

### Added

- `theme-manager doctor`: check for common issues (dependencies, directories, apply scripts, state).
- `theme-manager version`: show version information.
- `theme-manager apply --dry-run <theme>`: show resolved theme and which apply scripts would run, without making changes.
- Theme validation: themes must have `name`; `macos.appearance` (when present) must be `dark` or `light`. Invalid themes fail before any apply scripts run.
- Theme schema: `schemas/theme.schema.json` defines the canonical theme structure (JSON Schema).
- macOS appearance surface: `apply/macos.sh` sets system dark/light mode from theme JSON (`macos.appearance`).
- Theme definitions: `themes/dark/theme.json` and `themes/light/theme.json` now include `macos.appearance` (dark/light).

### Changed

- Release workflow (`.github/workflows/release.yml`): build matrix for darwin_arm64 and linux_amd64; release artifacts include darwin_arm64 tarball and checksum.

### Removed

- `apply/os.sh` (replaced by macOS-specific `apply/macos.sh`).

## Unreleased

### Added

### Changed

### Removed

### Fixed

### Planned (not guaranteed)

- Full JSON Schema validation (e.g. via `ajv` or similar) against `schemas/theme.schema.json`
- Explain-diff mode
- Additional surface scripts (explicit, not inferred)
- Cross-platform OS support
- Tests for idempotency and failure modes

