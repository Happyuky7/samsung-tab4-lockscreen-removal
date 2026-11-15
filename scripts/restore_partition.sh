#!/usr/bin/env bash
# restore_partition.sh — write a gzip-compressed dd image back to a partition.
# Run from Git Bash with the tablet in TWRP. DESTRUCTIVE: overwrites the target partition.
#
# Usage:
#   restore_partition.sh <image.img.gz> <block-device>
# Example (restore userdata):
#   restore_partition.sh ../../BACKUP_tablet/userdata.p26.img.gz /dev/block/mmcblk0p26
set -u

ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"

IMG="${1:-}"; DEV="${2:-}"
if [ -z "$IMG" ] || [ -z "$DEV" ]; then
  echo "Usage: $0 <image.img.gz> <block-device>"
  echo "  e.g. $0 ../../BACKUP_tablet/userdata.p26.img.gz /dev/block/mmcblk0p26"
  exit 1
fi
[ -f "$IMG" ] || { echo "Image not found: $IMG"; exit 1; }

echo "About to WRITE  $IMG  ->  $DEV  on the device."
echo "This ERASES the current contents of $DEV. This cannot be undone."
read -r -p "Type RESTORE to proceed: " ans
[ "$ans" = "RESTORE" ] || { echo "Aborted."; exit 1; }

# Unmount the target if it is /data or /system (best effort)
"$ADB" shell "umount $DEV 2>/dev/null; true"

echo "=== Streaming and writing (this takes a while) ==="
# Decompress on the PC, pipe raw bytes into adb shell's stdin; dd on the device writes them.
# Modern adb (no -t) passes stdin as raw binary, so this is byte-safe. Run from Git Bash.
gzip -dc "$IMG" | "$ADB" shell "dd of=$DEV bs=4M"

echo "=== Sync ==="
"$ADB" shell "sync; echo SYNCED"
echo "Done. Reboot and verify."
