#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: scripts/release.sh <version>"
  echo "Example: scripts/release.sh 0.1.1"
  exit 1
fi

VERSION="$1"
TAG="v$VERSION"

git diff --quiet || {
  echo "Working tree not clean. Commit or stash first."
  exit 1
}

git fetch origin

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Tag $TAG already exists."
  exit 1
fi

echo "→ Tagging $TAG"
git tag -a "$TAG" -m "$TAG"

echo "→ Pushing tag"
git push origin "$TAG"

echo "✓ Release $TAG triggered"
