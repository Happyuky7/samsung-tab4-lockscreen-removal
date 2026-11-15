#!/usr/bin/env bash
# 00_check_device.sh — verify ADB sees TWRP, /data mounts, and whether it is ENCRYPTED.
# Run with the tablet sitting in TWRP, connected by USB (Git Bash on Windows).
set -u

# --- edit if your layout differs ---
ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"
# -----------------------------------

echo "=== ADB devices (expect: <serial>  recovery) ==="
"$ADB" kill-server >/dev/null 2>&1
"$ADB" start-server >/dev/null 2>&1
"$ADB" devices
echo

state="$("$ADB" get-state 2>/dev/null)"
if [ "$state" != "recovery" ]; then
  echo "!! Device is not in recovery/TWRP (state: ${state:-none}). Boot TWRP first."
  exit 1
fi

echo "=== Is /data encrypted? (if files below look like real names, it is NOT encrypted) ==="
"$ADB" shell "ls /data/system/ 2>/dev/null | head -20"
echo
echo "   If instead you see garbage/base64-looking names or an empty listing, /data is ENCRYPTED"
echo "   -> STOP: this method cannot read it without the original PIN/password."
echo

echo "=== Lock files present on this device ==="
"$ADB" shell "ls -la /data/system/ | grep -iE 'gesture|password|locksettings|gatekeeper'"
echo

echo "=== Google accounts DB (must exist and should stay untouched) ==="
"$ADB" shell "ls -la /data/system/users/0/accounts.db 2>/dev/null || echo 'accounts.db not found at users/0 (check /data/system/accounts.db)'"
echo

echo "=== Free space on /data ==="
"$ADB" shell "df -h /data 2>/dev/null || df /data"
echo
echo "Done. If /data shows real filenames and lock files are listed, you are good to back up."
