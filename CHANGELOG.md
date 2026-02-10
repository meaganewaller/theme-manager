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

## Unreleased

Planned (not guaranteed):

- Theme JSON schema validation
- Dry-run / explain-diff mode
- Additional surface scripts (explicit, not inferred)
- Cross-platform OS support
- Tests for idempotency and failure modes

