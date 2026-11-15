#!/usr/bin/env bash
# 04_reboot.sh — reboot the tablet into Android.
set -u
ADB="${ADB:-$(dirname "$0")/../tools/platform-tools/adb.exe}"

echo "Rebooting to system..."
"$ADB" reboot
echo "Sent. The FIRST boot after editing /data is slow (several minutes) — do not force it off."
echo "It should reach the home screen with NO lock, accounts/apps/photos intact."
