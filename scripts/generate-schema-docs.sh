#!/usr/bin/env bash
# Generates docs/theme-schema.md from schemas/theme.schema.json.
# Run from repo root: scripts/generate-schema-docs.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCHEMA="$ROOT_DIR/schemas/theme.schema.json"
OUT="$ROOT_DIR/docs/theme-schema.md"

[[ -f "$SCHEMA" ]] || { echo "Schema not found: $SCHEMA"; exit 1; }

title=$(jq -r '.title // "Theme"' "$SCHEMA")
required=$(jq -r '.required // [] | join(", ")' "$SCHEMA")

cat > "$OUT" <<HEADER
# Theme schema

This document is auto-generated from \`schemas/theme.schema.json\`. Do not edit by hand.

To regenerate:

\`\`\`bash
scripts/generate-schema-docs.sh
\`\`\`

## Overview

**Schema title:** $title

**Required top-level fields:** ${required:-*(none beyond name)*}

Theme JSON must conform to this schema. Validation is enforced when applying themes and in CI.

## Top-level properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
HEADER

# Top-level required array for "required" check
req_names=$(jq -r '.required[]?' "$SCHEMA")

describe_prop() {
  local key=$1
  local type=$(jq -r --arg k "$key" '.properties[$k].type // "object"' "$SCHEMA")
  local enum=$(jq -r -c --arg k "$key" '.properties[$k].enum // empty' "$SCHEMA")
  local minlen=$(jq -r --arg k "$key" '.properties[$k].minLength // empty' "$SCHEMA")
  local desc=""
  if [[ -n "$enum" && "$enum" != "null" ]]; then
    desc="One of: $(echo "$enum" | jq -r 'join(", ")')."
  elif [[ -n "$minlen" ]]; then
    desc="Non-empty string (minLength $minlen)."
  else
    desc="See below."
  fi
  echo "| \`$key\` | $type | $2 | $desc |"
}

# name (required)
echo "| \`name\` | string | yes | Theme name (non-empty). |" >> "$OUT"

# Other top-level (optional) from schema
for key in terminal editor git macos; do
  if jq -e --arg k "$key" '.properties[$k]' "$SCHEMA" >/dev/null 2>&1; then
    describe_prop "$key" "no" >> "$OUT"
  fi
done

cat >> "$OUT" <<FOOTER

## Nested structures

### \`terminal\`

| Property | Type | Description |
|----------|------|-------------|
| \`background\` | string | Terminal background color. |
| \`foreground\` | string | Terminal foreground color. |

### \`editor\`

| Property | Type | Description |
|----------|------|-------------|
| \`theme\` | string | Editor/IDE theme name. |

### \`git.delta\`

| Property | Type | Description |
|----------|------|-------------|
| \`features\` | string | Delta features (e.g. \`side-by-side\`). |

### \`macos\`

| Property | Type | Description |
|----------|------|-------------|
| \`appearance\` | string | \`dark\` or \`light\` (system appearance). |

## Validation

- Themes are validated before apply (required \`name\`, allowed enums).
- CI validates all \`themes/*/theme.json\` files against this schema (see \`.github/workflows/ci.yml\`).
FOOTER

echo "Generated $OUT"
