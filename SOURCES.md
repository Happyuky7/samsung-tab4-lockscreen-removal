# Sources & Credits

All tools belong to their respective authors. Prefer downloading from these sources and verifying
the files yourself rather than trusting bundled copies.

## Tools

- **Odin3 v3.13.1** (Samsung flasher, community-mirrored)
  - <https://odindownload.com/download/>
  - direct: <https://odindownload.com/download/Odin3_v3.13.1.zip>
- **Android platform-tools** (official `adb`/`fastboot`, Google)
  - <https://dl.google.com/android/repository/platform-tools-latest-windows.zip>
- **Samsung USB Driver for Mobile Phones** (official)
  - <https://developer.samsung.com/android-usb-driver>

## TWRP recovery (matteo0026's unified builds)

> There is **no official twrp.me build** for these tablets — only matteo0026's community builds.

- XDA thread — *[RECOVERY][3.7.0_9][UNIFIED][matisse*][millet*][rubenslte] TWRP Recovery*
  - <https://xdaforums.com/t/recovery-3-7-0_9-unified-matisse-millet-rubenslte-twrp-recovery.4019831/>

Downloads per build (pick the one matching your exact model):

| Build | Models | AndroidFileHost | GitHub releases (mirror) |
|-------|--------|-----------------|--------------------------|
| matisse | SM-T530, SM-T530NU, SM-T531, SM-T532, SM-T533, SM-T535 | <https://www.androidfilehost.com/?w=files&flid=319803> | <https://github.com/matteo0026/twrp_device_samsung_matisse/releases/latest> |
| millet | SM-T330, SM-T330NU, SM-T331, SM-T335, SM-T337T | <https://www.androidfilehost.com/?w=files&flid=319808> | <https://github.com/matteo0026/twrp_device_samsung_millet/releases/latest> |
| rubenslte | SM-T365 | <https://www.androidfilehost.com/?w=files&flid=319827> | — |

- (older matisse tars folder also seen at: <https://androidfilehost.com/?w=files&flid=321911>)

### matteo0026 source code (device trees + kernels)

- matisse device: <https://github.com/matteo0026/android_device_samsung_matisse>
- millet device: <https://github.com/matteo0026/android_device_samsung_millet>
- matisse/millet kernel: <https://github.com/matteo0026/android_kernel_samsung_msm8226>
- matissevewifi device: <https://github.com/matteo0026/android_device_samsung_matissevewifi>
- matissevewifi kernel: <https://github.com/matteo0026/android_kernel_samsung_matissevewifi>
- rubenslte device: <https://github.com/matteo0026/android_device_samsung_rubenslte>
- rubenslte kernel: <https://github.com/matteo0026/android_kernel_samsung_rubenslte>
- TWRP device tree (matisse): <https://github.com/matteo0026/twrp_device_samsung_matisse>

## Device trees / reference repos (NOT needed for this procedure — source code only)

- <https://github.com/matteo0026/twrp_device_samsung_matisse>
- <https://github.com/NotNoelChannel/twrp_device_samsung_matissewifi>
- <https://github.com/tgalal/android_device_samsung_matissewifi>
- <https://github.com/sub77-2016/device_samsung_matisse>

## General references

- Odin flashing walkthrough — <https://nerdschalk.com/how-to-install-twrp-recovery-using-odin>
- TWRP devices index — <https://twrp.me/Devices/Samsung/>

## The actual build used in this recovery

- `twrp-3.5.2_9-0-matisse.tar` — contains a single `recovery.img` (8,841,232 bytes), built by
  `matteo` on 2021-04-12. SHA-256 of the `.tar`:
  `731E909A0AE2197491178F592879C802C03E40A0B87CAD7847AD99D2D80D595D`
