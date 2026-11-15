#!/usr/bin/env bash
# 03_remove_lock.sh — delete the screen-lock credential files (Android 5.x / Lollipop).
# Leaves Google accounts (accounts.db) untouched. Run AFTER you have a backup.
set -u

ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"

echo "This will DELETE the lock-screen files on /data/system:"
echo "  gesture.key  password.key  sparepassword.key  locksettings.db(+shm/-wal)"
read -r -p "Type YES to continue: " ans
[ "$ans" = "YES" ] || { echo "Aborted."; exit 1; }

# /data must be mounted for file-level deletion
"$ADB" shell "mount /data 2>/dev/null; mount /system 2>/dev/null; true"

echo "=== Deleting lock files ==="
"$ADB" shell "cd /data/system && rm -f gesture.key password.key sparepassword.key \
  locksettings.db locksettings.db-shm locksettings.db-wal && echo DELETED_OK"

echo
echo "=== Verify they are gone (nothing but maybe an empty fmmpassword.key should list) ==="
"$ADB" shell "ls -la /data/system/ | grep -iE 'gesture|password|locksettings'"

echo
echo "=== Confirm Google accounts survived ==="
"$ADB" shell "ls -la /data/system/users/0/accounts.db 2>/dev/null; ls -la /data/system/sync/accounts.xml 2>/dev/null"

echo
echo "Done. Now run 04_reboot.sh. First boot is slow (several minutes) — be patient."
