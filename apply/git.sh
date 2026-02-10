#!/usr/bin/env bash
set -euo pipefail

jq -e '.git' "$THEME_JSON" >/dev/null 2>&1 || exit 0

DELTA_FEATURES=$(jq -r '.git.delta.features // empty' "$THEME_JSON")

if [ -n "$DELTA_FEATURES" ]; then
  git config --global delta.features "$DELTA_FEATURES"
fi
