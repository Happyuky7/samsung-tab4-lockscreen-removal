#!/usr/bin/env bash
# 01_backup_media.sh — pull the important user folders (photos, downloads, docs) to the PC.
# Pulls folders individually to avoid aborting on game-cache files with NTFS-illegal names.
set -u

ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"
DEST="${DEST:-$(dirname "$0")/../../BACKUP_tablet/importante}"

mkdir -p "$DEST"

# Folders worth keeping (skip Android/data = app/game cache)
FOLDERS=(DCIM Pictures Documents "My Documents" Download Movies Music WhatsApp backups Samsung)

for f in "${FOLDERS[@]}"; do
  echo "--- Pulling: $f"
  "$ADB" pull "/data/media/0/$f" "$DEST/$f" 2>&1 | tail -1
done

echo
echo "=== Backup summary ==="
for d in "$DEST"/*/; do
  [ -d "$d" ] || continue
  n=$(find "$d" -type f 2>/dev/null | wc -l)
  echo "$(basename "$d"): $n files"
done
echo "Saved to: $DEST"
