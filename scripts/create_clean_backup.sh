#!/usr/bin/env bash
set -euo pipefail

# Creates a restorable backup without git history:
# - backup/repo-no-history/      (full working snapshot without .git/.venv/backup)
# - backup/project-export/       (project/labels/workflows/secrets metadata, best effort)
# - backup/VictorOPEX-backup-no-history-<timestamp>.tar.gz
#
# Usage:
#   bash scripts/create_clean_backup.sh
#
# Optional env vars:
#   OWNER=VictorOPEX
#   REPO=VictorOPEX/VictorOPEX
#   PROJECT_NUMBER=3

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$ROOT_DIR/backup"
SNAPSHOT_DIR="$BACKUP_DIR/repo-no-history"
PROJECT_EXPORT_DIR="$BACKUP_DIR/project-export"
STAMP="$(date +%F_%H%M%S)"
ARCHIVE_PATH="$BACKUP_DIR/VictorOPEX-backup-no-history-$STAMP.tar.gz"

OWNER="${OWNER:-VictorOPEX}"
REPO="${REPO:-VictorOPEX/VictorOPEX}"
PROJECT_NUMBER="${PROJECT_NUMBER:-3}"

echo "[1/5] Reset backup folder structure..."
mkdir -p "$BACKUP_DIR"
rm -rf "$SNAPSHOT_DIR" "$PROJECT_EXPORT_DIR"
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'VictorOPEX-backup-no-history-*.tar.gz' -delete
rm -f "$BACKUP_DIR/README_BACKUP.txt"
mkdir -p "$SNAPSHOT_DIR" "$PROJECT_EXPORT_DIR"

echo "[2/5] Create no-history repo snapshot..."
rsync -av --delete \
  --exclude='.git' \
  --exclude='.venv' \
  --exclude='backup' \
  "$ROOT_DIR/" "$SNAPSHOT_DIR/"

echo "[3/5] Export project metadata (best effort)..."
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  # Create files first so the manifest always has stable filenames.
  : > "$PROJECT_EXPORT_DIR/project-view.json"
  : > "$PROJECT_EXPORT_DIR/project-fields.json"
  : > "$PROJECT_EXPORT_DIR/project-items.json"
  : > "$PROJECT_EXPORT_DIR/labels.txt"
  : > "$PROJECT_EXPORT_DIR/workflows.txt"
  : > "$PROJECT_EXPORT_DIR/repo-secrets.txt"

  gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json > "$PROJECT_EXPORT_DIR/project-view.json" || true
  gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json > "$PROJECT_EXPORT_DIR/project-fields.json" || true
  gh project item-list "$PROJECT_NUMBER" --owner "$OWNER" --format json > "$PROJECT_EXPORT_DIR/project-items.json" || true
  gh label list --repo "$REPO" --limit 300 > "$PROJECT_EXPORT_DIR/labels.txt" || true
  gh workflow list --repo "$REPO" > "$PROJECT_EXPORT_DIR/workflows.txt" || true
  gh secret list --repo "$REPO" > "$PROJECT_EXPORT_DIR/repo-secrets.txt" || true
else
  echo "gh CLI not authenticated; project export skipped." > "$PROJECT_EXPORT_DIR/EXPORT_STATUS.txt"
fi

echo "[4/5] Create compressed archive..."
(
  cd "$ROOT_DIR"
  tar -czf "$ARCHIVE_PATH" \
    --exclude='.git' \
    --exclude='.venv' \
    --exclude='backup' \
    .
)

echo "[5/5] Write manifest..."
{
  echo "Backup created: $(date -Iseconds)"
  echo "Repo snapshot: $SNAPSHOT_DIR"
  echo "Project export: $PROJECT_EXPORT_DIR"
  echo "Archive (tar.gz): $ARCHIVE_PATH"
  echo
  echo "Project export files:"
  ls -1 "$PROJECT_EXPORT_DIR"
  echo
  echo "Sizes:"
  wc -c "$PROJECT_EXPORT_DIR"/* 2>/dev/null || true
} > "$BACKUP_DIR/README_BACKUP.txt"

echo
echo "Backup completed:"
echo "  Snapshot: $SNAPSHOT_DIR"
echo "  Project export: $PROJECT_EXPORT_DIR"
echo "  Archive: $ARCHIVE_PATH"
echo "  Manifest: $BACKUP_DIR/README_BACKUP.txt"
