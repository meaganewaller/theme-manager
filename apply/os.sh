#!/usr/bin/env bash
set -euo pipefail

jq -e '.os.appearance' "$THEME_JSON" >/dev/null 2>&1 || exit 0

APPEARANCE=$(jq -r '.os.appearance' "$THEME_JSON")

case "$APPEARANCE" in
  dark)
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    ;;
  light)
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
    ;;
  *)
    echo "Unknown appearance: $APPEARANCE" >&2
    exit 1
    ;;
esac
