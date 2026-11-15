# Samsung Galaxy Tab 4 10.1 (SM-T530) — Screen-Lock Removal **Without Data Loss**

A step-by-step, reproducible guide to remove a forgotten screen lock (PIN / password / pattern)
from a **Samsung Galaxy Tab 4 10.1 Wi-Fi (SM-T530, codename `matissewifi`, Qualcomm MSM8226)**
running **Android 5.0.1 (Lollipop)** — while keeping **all data, apps, photos, emails and Google
accounts intact** (no factory reset, no FRP prompt).

This repository documents a recovery that was actually performed and succeeded.

---

## ⚠️ DISCLAIMER — READ FIRST

> **USE AT YOUR OWN RISK.** This guide is provided for **educational purposes** and for helping
> owners regain access to **their own devices**.
>
> - Only use this on a device **you own** or have **explicit written authorization** to service.
>   Bypassing a lock on a device that is not yours may be **illegal**.
> - Flashing custom software **can brick your device** and will typically **trip the Knox counter /
>   void your warranty** (`KNOX WARRANTY VOID` may change from `0x0` to `0x1`).
> - Although this procedure is designed to **preserve data**, there is always a risk of data loss.
>   **Always make a full backup first** (this guide does exactly that).
> - If the device's `/data` partition is **encrypted**, this method **will not work** without the
>   original PIN/password — the files cannot be read.
> - The authors / contributors accept **no liability** for any damage, data loss, bricked devices,
>   voided warranties, or legal consequences. **You proceed entirely on your own responsibility.**
>
> All third-party tools (Odin, TWRP, platform-tools, drivers) are property of their respective
> owners and are linked from their official/community sources below. Nothing here is affiliated
> with Samsung, Google, or the TWRP project.

---

## Why this works (and when it does NOT)

Android stores the lock-screen credential in a few small files on the `/data` partition. On
**Android 5.0.1** these are:

| File | Meaning |
|------|---------|
| `/data/system/password.key` | PIN / password hash |
| `/data/system/gesture.key` | Pattern hash |
| `/data/system/sparepassword.key` | Spare/backup credential |
| `/data/system/locksettings.db` (+ `-shm`, `-wal`) | Lock settings database |

Deleting these removes the lock. **Crucially, `/data/system/users/0/accounts.db` (your Google
accounts) is left untouched**, so the tablet boots straight to the home screen, still signed in,
with no Google FRP challenge.

A custom recovery (**TWRP**) is required only to *reach* those files — the stock recovery cannot.
Flashing TWRP replaces **only the recovery partition** (~8 MB); it does **not** touch `/data`.

**This method fails if `/data` is encrypted.** You find out the moment TWRP boots: if it asks for a
*decryption password*, stop — the data is unreadable without the original credential. In our case
TWRP mounted `/data` with no prompt → not encrypted → success.

---

## What you need

| Tool | Version used | Source |
|------|--------------|--------|
| Windows PC | Win 10/11 | — |
| Samsung USB drivers | latest | [developer.samsung.com/android-usb-driver](https://developer.samsung.com/android-usb-driver) |
| Odin (flasher) | Odin3 v3.13.1 | [odindownload.com](https://odindownload.com/download/) · direct: [Odin3_v3.13.1.zip](https://odindownload.com/download/Odin3_v3.13.1.zip) |
| TWRP recovery (`.tar`) | twrp-3.5.2_9-0-matisse | see **TWRP sources** below |
| Android platform-tools (adb) | 37.0.1 | [dl.google.com/.../platform-tools-latest-windows.zip](https://dl.google.com/android/repository/platform-tools-latest-windows.zip) |
| A USB cable | — | — |

> On modern Windows the Samsung **CDC / download-mode** driver often installs automatically — the
> device shows up as *"SAMSUNG Mobile USB CDC Composite Device"*. If Odin does not detect the
> tablet, install the official driver above.

Copies of Odin, the TWRP `.tar`, and platform-tools are included in [`tools/`](tools/) for
convenience, but **prefer re-downloading from the official sources** and verifying them yourself.

### TWRP sources (SM-T530 has **no official** twrp.me build — community only)

- XDA thread (unified matisse recovery): <https://xdaforums.com/t/recovery-3-7-0_9-unified-matisse-millet-rubenslte-twrp-recovery.4019831/>
- AndroidFileHost (matisse TWRP tars): <https://androidfilehost.com/?w=files&flid=319803> · (alt folder: <https://androidfilehost.com/?w=files&flid=321911>)
- Device tree used to build it: <https://github.com/matteo0026/twrp_device_samsung_matisse>

> **Pick the `matisse` build for the T530 Wi-Fi.** Do **not** use `degaswifi`, `T531`, `T532` or
> `T535` builds — those are different hardware variants.

---

## Procedure

> Scripts for every step are in [`scripts/`](scripts/). They assume **Git Bash** on Windows (the
> binary-safe `>` redirect matters — see *Gotchas*). Edit the paths at the top of each script if
> your layout differs.

### 0. Install tools on the PC
1. Install the **Samsung USB drivers**.
2. Unzip **platform-tools** somewhere (gives you `adb.exe`).
3. Unzip **Odin**.
4. Download the **TWRP `.tar`** for `matisse`.

### 1. Enter Download (Odin) mode on the tablet
1. Power the tablet **off**.
2. Hold **Volume Down + Home + Power** together.
3. At the warning screen (*"A custom OS can cause critical problems…"*), press **Volume Up** to continue.
4. You should see **ODIN MODE** / **"Downloading…"**. Confirm `PRODUCT NAME: SM-T530`.

### 2. Flash TWRP with Odin
1. Open **Odin as Administrator**.
2. Connect the tablet → a blue **`0:[COM x]`** box + **`Added!!`** appears in the log.
3. Click **AP** → select `twrp-3.5.2_9-0-matisse.tar`. Leave BL / CP / CSC empty.
4. **Options → UNCHECK "Auto Reboot"** ← *important* (so Android can't restore the stock recovery).
5. Click **Start** → wait for **PASS!**

### 3. Boot **straight** into TWRP (do NOT let Android boot)
This is the step people fail. If Android boots even once, Samsung's `recovery-from-boot.p`
**restores the stock recovery** and you must re-flash.

1. With Odin showing PASS (Auto-Reboot was off, tablet still in download mode):
2. Force-off: hold **Power + Volume Down** ~8 s until the screen goes black.
3. **The instant it goes black**, switch to holding **Power + Home + Volume Up** until TWRP appears.
4. At *"Keep System Read Only?"* tap **"Keep Read Only"** (do **not** swipe to allow modifications —
   we only touch `/data`).

### 4. Verify, then back up EVERYTHING (from the PC)
With the tablet sitting in TWRP, connected by USB:

```bash
scripts/00_check_device.sh      # adb sees "recovery", /data mounts, lists lock files
scripts/01_backup_media.sh      # pulls DCIM, Pictures, Download, Documents… to BACKUP_tablet/importante
scripts/02_backup_partitions.sh # full compressed images of userdata + system + boot
```

`00_check_device.sh` also tells you whether `/data` is **encrypted**. If it is, **stop here.**

### 5. Remove the lock
```bash
scripts/03_remove_lock.sh       # deletes the key files + locksettings.db, confirms accounts.db survives
```

### 6. Reboot and test
```bash
scripts/04_reboot.sh            # adb reboot  (first boot is slow — several minutes, be patient)
```
The tablet should boot **straight to the home screen, no lock**, with all accounts/apps/photos.

> ### 🚫 CRITICAL: keep the tablet OFFLINE until you've checked everything
>
> As soon as it boots, **do NOT connect it to Wi-Fi / mobile data yet.** First, while still offline,
> open what matters to you — Gmail and old emails, Photos, WhatsApp, other accounts — and confirm
> the content is actually there.
>
> **Why:** if a lot of time has passed, the moment the device goes online Google (and other
> services like Samsung, WhatsApp, social apps) may **invalidate the old saved session and force a
> fresh login / re-verification**. If you don't know that account's current password — or can't pass
> 2-step verification / a security challenge — you can get **locked out of content you could still
> read while offline**. Cached emails, for example, are readable offline but may disappear behind a
> login wall once the app syncs online.
>
> So: **verify offline first → note down what you need / export it → only then connect to the
> internet**, and do it when you actually have the account passwords ready.

### 7. Afterwards
- Set a **new** lock you will remember (Settings → Lock screen).
- While still offline, **write down / export anything you only have on this device** (old emails,
  contacts, notes) before the first sync.
- Make sure you know the **current passwords** of every account on the device *before* going online.
- Back photos up to the cloud (Google Photos) once you're confident the accounts are stable.
- Keep `BACKUP_tablet/` somewhere safe.

---

## Restoring from the backup (if something ever goes wrong)

The partition images are raw `dd` dumps, gzip-compressed. To write one back, boot into TWRP and:

```bash
scripts/restore_partition.sh BACKUP_tablet/userdata.p26.img.gz /dev/block/mmcblk0p26
```

Partition map on this device (confirm yours with `adb shell ls -l /dev/block/platform/*/by-name/`):

| Partition | Block device | Backup file |
|-----------|--------------|-------------|
| boot      | `mmcblk0p14` | `boot.p14.img.gz` |
| recovery  | `mmcblk0p15` | (not backed up; re-flash TWRP/stock) |
| system    | `mmcblk0p23` | `system.p23.img.gz` |
| userdata  | `mmcblk0p26` | `userdata.p26.img.gz` |

> Restoring `userdata` overwrites **all** current data with the backup's contents. Be sure.

---

## Gotchas we hit (so you don't)

- **Stock recovery kept coming back.** Letting Android boot after flashing runs
  `recovery-from-boot.p`, which overwrites TWRP. Fix: go download → recovery *without* a system boot
  (step 3). From the stock recovery menu, *"reboot to bootloader"* returns to download mode without
  booting Android.
- **`pigz: trying to write compressed data to a terminal`.** When piping through `adb exec-out`,
  add **`-f`** → `pigz -1 -f`. (Same idea for `gzip -f`.)
- **PowerShell corrupts binary redirects.** `adb exec-out "…" > file.img.gz` in **PowerShell**
  mangles the bytes (encoding/CRLF). Use **Git Bash** (or `cmd /c`) for binary streams. All scripts
  here are Bash for this reason.
- **`adb pull /data/media/0` aborted on Windows.** Game caches (e.g. Free Fire) have filenames with
  characters illegal on NTFS (`~2F`, etc.) → *"Not a directory"*. Pull the real folders individually
  (`01_backup_media.sh`) instead of the whole tree.
- **`/data` was 96 % full.** A TWRP backup can't be stored on the device itself — stream the images
  straight to the PC (`02_backup_partitions.sh`).
- **`sort -h` / GNU flags** don't exist in TWRP's BusyBox. Use `sort -rn` with `-k`.
- **No emulator.** You cannot run this tablet's data/system in a PC Android emulator — it's ARM +
  Samsung-specific (TouchWiz, MSM8226 kernel/drivers); AVDs are x86 and won't boot it.

---

## Compatibility — other models (⚠️ UNTESTED)

This guide was **tested and confirmed only on the SM-T530** (`matissewifi`, Android 5.0.1). The same
procedure **should** work on the rest of the Galaxy Tab 4 family, because matteo0026's TWRP is a
**unified build** covering several models — **but we have not verified them**, so treat anything
below as *"probably works, do your own research first"*.

| TWRP build | Models it targets | TWRP download |
|-----------|-------------------|---------------|
| **matisse** | SM-T530, SM-T530NU, SM-T531, SM-T532, SM-T533, **SM-T535** | [AndroidFileHost flid=319803](https://www.androidfilehost.com/?w=files&flid=319803) · [GitHub releases](https://github.com/matteo0026/twrp_device_samsung_matisse/releases/latest) |
| **millet** | SM-T330, SM-T330NU, SM-T331, SM-T335, SM-T337T | [AndroidFileHost flid=319808](https://www.androidfilehost.com/?w=files&flid=319808) · [GitHub releases](https://github.com/matteo0026/twrp_device_samsung_millet/releases/latest) |
| **rubenslte** | SM-T365 | [AndroidFileHost flid=319827](https://www.androidfilehost.com/?w=files&flid=319827) |

Notes that may differ per model:

- **Pick the build that matches YOUR exact model.** The wrong build can brick the device. The lock
  files and the whole data-preservation logic are the same across these Android 5.x models, but the
  **partition numbers** (`mmcblk0pXX` for boot/system/userdata) may differ — always re-check with
  `adb shell ls -l /dev/block/platform/*/by-name/` before backing up or restoring.
- Per matteo0026's own notes: **a boot password enables encryption, which this TWRP does not
  support** — i.e. if the device was encrypted you cannot read `/data`. This matches our *"fails if
  encrypted"* warning.
- On some variants (e.g. `matissevewifi`) *reboot → recovery* in TWRP boots to **system** instead;
  use `adb reboot recovery` or type `reboot recovery` in TWRP's terminal.

### If you succeed on a different model — please contribute back 🙏

If you follow this on a model other than the SM-T530 and it works (or needs tweaks), consider
helping the next person:

1. Note **exactly** what differed: your model, the TWRP build used, the partition map
   (`/dev/block/platform/*/by-name/`), the Android version, and which lock files existed
   (`gatekeeper.*` on Android 6+ vs `password.key`/`gesture.key` on 5.x).
2. Share it where this community already lives — the **XDA thread**
   (<https://xdaforums.com/t/recovery-3-7-0_9-unified-matisse-millet-rubenslte-twrp-recovery.4019831/>)
   or matteo0026's GitHub — so it reaches people searching for the same fix.
3. Keep the **disclaimer** attached and make clear it's *"worked for me, use at your own risk"* — do
   not present an untested model as guaranteed.

> Credit where due: the TWRP builds and device trees used here are **matteo0026's** work. This guide
> only documents a lock-removal workflow on top of them.

## Device facts (this unit)

```
Model:            SM-T530  (Galaxy Tab 4 10.1 Wi-Fi)
Codename:         matissewifi
SoC:              Qualcomm MSM8226 (Snapdragon 400)
Android:          5.0.1 Lollipop  (build LRX22G.T530XXS1BPL3)
Bootloader:       KNOX WARRANTY VOID: 0x0 (unlocked, flashable)
Encryption:       none (data mounted in TWRP without a password)
TWRP flashed:     3.5.2_9-0 (matisse, by matteo0026)
```

See [`SOURCES.md`](SOURCES.md) for the complete list of references.
