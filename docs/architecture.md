# Theme Manager Architecture

This document describes the architecture and design constraints of `theme-manager`.

If a proposed change contradicts this document, the change should not be made
without updating this document first.

## Purpose

`theme-manager` exists to apply a named theme consistently across multiple
surfaces of a development environment.

It answers one question:

> Given a theme name, how should the environment look?

It intentionally does **not** answer:
- when a theme should be applied
- which theme should be active
- how themes are selected based on context

Those concerns belong to external orchestration tools (e.g. `mise`, dotfiles).

## High-Level Flow

```
theme-manager apply [--dry-run] <theme>
↓
resolve theme definition
↓
validate (required name; macos.appearance enum when present)
↓
if --dry-run: print resolved theme and script list, exit
↓
invoke surface apply scripts
↓
exit
```

Each step is explicit and observable. With `--dry-run`, no apply scripts run and no state is written.

## Key Architectural Decisions

### 1. Declarative Themes

Themes are defined as static JSON documents.

They:
- describe values, not behavior
- are easy to inspect and diff
- are safe to version control

Theme Manager does not infer values or derive themes dynamically.

### 2. Surface Isolation

Each surface (terminal, editor, git, OS, etc.) is applied by an independent script.

Benefits:
- surfaces can be added or removed freely
- failures are localized
- behavior is easier to reason about
- scripts remain small and testable

No script should depend on another script having run.

### 3. External Orchestration

Theme Manager does not:
- detect work vs personal context
- read shell state
- infer environment variables beyond its inputs

Theme selection is handled by orchestration (dotfiles, `mise`, login hooks).

This prevents hidden coupling and makes behavior predictable.

### 4. Idempotency by Default

All apply scripts must be safe to run multiple times.

Re-applying the same theme should:
- not change behavior
- not accumulate state
- not degrade performance

This allows Theme Manager to be used:
- at login
- on shell startup
- after system wake
- manually

Without fear.

### 5. Explicit Failure

Theme Manager prefers explicit failure over silent partial success.

Examples:
- invalid theme schema → error
- unknown OS appearance value → error
- missing required theme file → error

Silently guessing is considered a bug.

## Configuration Boundaries

### What Theme Manager Owns

- Theme definitions
- Theme schema
- Surface apply scripts
- CLI behavior
- Validation and resolution

### What Theme Manager Does Not Own

- Profile selection
- Context detection
- Conditional logic based on host or user
- Cross-tool coordination
- Dotfiles or shell logic

These boundaries are intentional and enforced.

## Directory Responsibilities

```
themes/       → declarative theme definitions
schemas/      → theme JSON schema (canonical structure)
apply/        → surface-specific application logic
bin/          → CLI entry point
config/       → tool-level defaults
docs/         → design documentation
```

Each directory has a single responsibility.

## Extending Theme Manager

### Adding a New Surface

1. Add a new top-level key in the theme schema
2. Create a corresponding script in `apply/`
3. Document the surface in the README
4. Add tests (if applicable)

Do not modify existing scripts to handle new surfaces.

### Adding a New Theme

1. Create a new directory under `themes/`
2. Add a `theme.json`
3. Validate against schema
4. Apply and verify

No code changes should be required.

## Anti-Patterns (Hard No’s)

The following are explicitly discouraged:

- Inferring themes from context
- Embedding shell logic in theme definitions
- Writing to unrelated config files
- Combining multiple surfaces in one script
- Implicit defaults that override user config

If a feature requires any of the above, it does not belong here.

## Why This Matters

Theme management seems trivial until it isn’t.

Without clear boundaries:
- tools accumulate hidden state
- behavior becomes non-deterministic
- users stop trusting the system

This architecture prioritizes trust, clarity, and long-term maintainability.

## Future Considerations

Potential future extensions (explicitly out of scope for v0):

- Dry-run mode
- Theme diffing
- Per-surface enable/disable flags
- Cross-platform abstractions
- Plugin system for surfaces

These should only be added if they preserve the core principles above.

## Summary

`theme-manager` is intentionally small.

It does one thing:
> apply themes deterministically

Everything else is someone else’s problem.
