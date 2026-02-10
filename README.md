# theme-manager

`theme-manager` is a small, opinionated tool for managing and applying themes
across your development environment.

It provides a single command to apply a named theme consistently to:
- terminal
- editor
- git
- OS-level appearance (where supported)

Theme selection is handled externally (e.g. via `mise`).
Theme Manager only applies themes.

## Core Principles

- **Themes are declarative**
- **Application is deterministic**
- **No hidden state**
- **One theme name → many surfaces**

This tool prefers correctness and clarity over cleverness.

## Installation

Using `mise`:

```toml
[tools]
theme-manager = "github:meaganewaller/theme-manager@v0.1.0"
```

## Usage

Apply a theme:

```bash
theme-manager apply dark
```

Show current theme:

```bash
theme-manager current
```

List available themes:

```bash
theme-manager list
```

Check for common issues (dependencies, directories, apply scripts, state):

```bash
theme-manager doctor
```

Show version information:

```bash
theme-manager version
```

## Configuration

Theme Manager reads configuration from:

```
~/.config/theme-manager`
```

This includes:
- theme definitions
- default settings
- per-surface application scripts

Dotfiles are responsible for selecting which theme to apply (e.g., via `THEME_PROFILE`)

Dotfiles are responsible for selecting which theme to apply (e.g., via `THEME_PROFILE`).

## Themes

Themes live in:

```
themes/<theme-name>/theme.json
```

Themes are declarative and may define values for multiple surfaces.

Example:

```json
{
  "name": "dark",
  "terminal": {
    "background": "#0f172a",
    "foreground": "#e5e7eb"
  },
  "git": {
    "pager": "delta"
  }
}
```

Theme Manager does not infer values. If a surface is not defined, it is not modified.


## Applying Themes

Each surface is applied by a dedicated script in `apply/`

Examples:

- `terminal.sh`
- `git.sh`
- `editor.sh`
- `macos.sh`

These scripts:

- read resolved theme values
- apply them idempotently
- are safe to re-run

## Non-Goals

This tool intentionally does NOT:

- detect environment context
- decide when to switch themes
- manage unrelated dotfiles
- guess missing values

Those concerns belong elsewhere.