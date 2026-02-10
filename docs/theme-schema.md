# Theme schema

This document is auto-generated from `schemas/theme.schema.json`. Do not edit by hand.

To regenerate:

```bash
scripts/generate-schema-docs.sh
```

## Overview

**Schema title:** Theme Manager Theme

**Required top-level fields:** name

Theme JSON must conform to this schema. Validation is enforced when applying themes and in CI.

## Top-level properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | string | yes | Theme name (non-empty). |
| `terminal` | object | no | See below. |
| `editor` | object | no | See below. |
| `git` | object | no | See below. |
| `macos` | object | no | See below. |

## Nested structures

### `terminal`

| Property | Type | Description |
|----------|------|-------------|
| `background` | string | Terminal background color. |
| `foreground` | string | Terminal foreground color. |

### `editor`

| Property | Type | Description |
|----------|------|-------------|
| `theme` | string | Editor/IDE theme name. |

### `git.delta`

| Property | Type | Description |
|----------|------|-------------|
| `features` | string | Delta features (e.g. `side-by-side`). |

### `macos`

| Property | Type | Description |
|----------|------|-------------|
| `appearance` | string | `dark` or `light` (system appearance). |

## Validation

- Themes are validated before apply (required `name`, allowed enums).
- CI validates all `themes/*/theme.json` files against this schema (see `.github/workflows/ci.yml`).
