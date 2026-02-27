#!/usr/bin/env bash
set -euo pipefail

# Prepares a clean, no-history folder ready to push to a newly created GitHub repo.
#
# It copies from backup/repo-no-history and initializes a fresh git history with 1 commit.
#
# Usage:
#   bash scripts/prepare_clean_restore.sh /absolute/path/to/VictorOPEX-clean
#
# Example:
#   bash scripts/prepare_clean_restore.sh /mnt/d/GitHub/VictorOPEX-clean
#
# Then inside target folder:
#   git remote add origin https://github.com/VictorOPEX/VictorOPEX.git
#   git push -u origin main

if [[ "${1:-}" == "" ]]; then
  echo "Usage: bash scripts/prepare_clean_restore.sh /absolute/path/to/target-folder"
  exit 1
fi

TARGET_DIR="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/backup/repo-no-history"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source backup not found at: $SOURCE_DIR"
  echo "Run: bash scripts/create_clean_backup.sh"
  exit 1
fi

echo "[1/4] Recreate target folder: $TARGET_DIR"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "[2/4] Copy no-history snapshot..."
rsync -av "$SOURCE_DIR/" "$TARGET_DIR/"

echo "[3/4] Initialize fresh git history..."
(
  cd "$TARGET_DIR"
  rm -rf .git
  git init
  git branch -M main
  git add -A
  git commit -m "Initial clean import (no prior history)"
)

echo "[4/4] Done."
echo
echo "Next commands:"
echo "  cd $TARGET_DIR"
echo "  git remote add origin https://github.com/VictorOPEX/VictorOPEX.git"
echo "  git push -u origin main"
