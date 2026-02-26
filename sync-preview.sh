#!/bin/bash
# Sync preview repo with the private AI Business OS repository.
# Run this after updating the main repo to keep the preview current.

set -euo pipefail

SOURCE="/Users/larrymaguire/Developer/unpublished/ai-business-os"
PREVIEW="$(cd "$(dirname "$0")" && pwd)"

# Files to sync — add new entries here as needed
FILES=(
  "README.md"
  "CHANGELOG.md"
)

changed=0

for file in "${FILES[@]}"; do
  if [ -f "$SOURCE/$file" ]; then
    if ! cmp -s "$SOURCE/$file" "$PREVIEW/$file" 2>/dev/null; then
      cp "$SOURCE/$file" "$PREVIEW/$file"
      echo "Updated: $file"
      changed=1
    fi
  else
    echo "Warning: $SOURCE/$file not found, skipping"
  fi
done

if [ "$changed" -eq 0 ]; then
  echo "Preview already up to date."
  exit 0
fi

cd "$PREVIEW"
git add -A
git commit -m "Sync preview with AI Business OS $(date +%Y-%m-%d)"
git push

echo "Preview repo synced and pushed."
