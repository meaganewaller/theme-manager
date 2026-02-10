#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: scripts/release.sh <version>"
  echo "Example: scripts/release.sh 0.1.1"
  exit 1
fi

VERSION="$1"
TAG="v$VERSION"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CHANGELOG="$ROOT_DIR/CHANGELOG.md"

git diff --quiet || {
  echo "Working tree not clean. Commit or stash first."
  exit 1
}

git fetch origin

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Tag $TAG already exists."
  exit 1
fi

# Update changelog: move Unreleased to new version, add blank Unreleased
RELEASE_DATE=$(date +%Y-%m-%d)
echo "→ Updating CHANGELOG for $TAG ($RELEASE_DATE)"
sed -i.bak "1,/^## Unreleased$/s/^## Unreleased$/## [$VERSION] - $RELEASE_DATE/" "$CHANGELOG"
rm -f "$CHANGELOG.bak"
printf '\n\n## Unreleased\n\n' >> "$CHANGELOG"

git add "$CHANGELOG"
git commit -m "Changelog for $TAG"

echo "→ Tagging $TAG"
git tag -a "$TAG" -m "$TAG"

echo "→ Pushing branch and tag"
git push origin HEAD
git push origin "$TAG"

echo "✓ Release $TAG triggered"
