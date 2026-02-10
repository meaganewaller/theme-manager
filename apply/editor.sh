#!/usr/bin/env bash
set -euo pipefail

jq -e '.editor' "$THEME_JSON" >/dev/null 2>&1 || exit 0

VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
mkdir -p "$(dirname "$VSCODE_SETTINGS")"

THEME=$(jq -r '.editor.theme // empty' "$THEME_JSON")
[ -z "$THEME" ] && exit 0

TMP=$(mktemp)

# Merge editor theme into existing settings (minimal surgery)
jq --arg theme "$THEME" \
  '. + { "workbench.colorTheme": $theme }' \
  "$VSCODE_SETTINGS" 2>/dev/null \
  > "$TMP" || echo '{ "workbench.colorTheme": "'"$THEME"'" }' > "$TMP"

mv "$TMP" "$VSCODE_SETTINGS"
