#!/usr/bin/env bash
# 02_backup_partitions.sh — stream full, compressed partition images to the PC.
# MUST run from Git Bash (binary-safe '>' redirect). PowerShell would corrupt the images.
#
# Partition map for SM-T530 (matissewifi) — verify yours:
#   adb shell ls -l /dev/block/platform/*/by-name/
set -u

ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"
DEST="${DEST:-$(dirname "$0")/../../BACKUP_tablet}"
mkdir -p "$DEST"

# name : block-device
PARTS=(
  "boot.p14:/dev/block/mmcblk0p14"
  "system.p23:/dev/block/mmcblk0p23"
  "userdata.p26:/dev/block/mmcblk0p26"
)

# For a clean userdata image, unmount /data first (ignore errors; TWRP may auto-remount).
echo "=== Unmounting /data for a consistent image ==="
"$ADB" shell "umount /data 2>/dev/null; umount /data 2>/dev/null; mount | grep -c mmcblk0p26"

for p in "${PARTS[@]}"; do
  name="${p%%:*}"; dev="${p##*:}"
  out="$DEST/${name}.img.gz"
  echo "=== Backing up $dev -> $out ==="
  # pigz -f : force (pigz refuses to write to what it thinks is a terminal via adb exec-out)
  "$ADB" exec-out "dd if=$dev bs=4M 2>/dev/null | pigz -1 -f" > "$out"
  if gzip -t "$out" 2>/dev/null; then
    echo "   OK  $(du -h "$out" | cut -f1)  $out"
  else
    echo "   !! GZIP ERROR for $out — check device has pigz/gzip and retry"
  fi
done

echo
echo "=== Final backup set ==="
ls -la "$DEST"/*.img.gz
