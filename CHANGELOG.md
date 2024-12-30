## v1.4.2 Revision 9
* **WebUI: Introduce Custom Settings page**
  This includes:
  * Hide custom ROM paths
  * Hide Gapps
  * Hide Revanced (Youtube/Youtube Music)
  * Spoof CMDLINE (v1.5.2 only)
  * Hide KSU Loops
  * Hide LSPosed Mounts
  * Custom SUS Paths
  * Custom SUS Mounts
* WebUI: Add @backslashxx @rifsxd to credits page
* WebUI: White Mode
* Scripts: Complete rework to provide more customizability of sus_path and sus_mounts to WebUI (Big thanks to @backslashxx)
  * The settings are in /data/adb/susfs4ksu or use WebUI custom settings menu
* Scripts: Improve logging for WebUI stats
  * If the stats don't show in WebUI it could be your logd are disabled or there is a low log buffer size in the kernel
  * If the WebUI Stats finds no susfs paths and mounts inside the main susfs.log, it will fall off to susfs1.log which logs for susfs paths/mounts executed from the boot scripts.
* Hide custom rom and gapps are off by default

## v1.4.2 Revision 8
* Introducing SUSFS WebUI 1.4.2
  * SUS_PATH, SUS_MOUNT, and TRY_UMOUNT Stats
  * SUSFS Logs toggle
  * SUS SU toggle
  * SUS SU on boot toggle
  * Spoof Kernel Version
* Move addon.d and install-recovery.sh sus_path to post-fs-data.sh
* Remove comment on susfs enable log and make susfslogs.txt
* Change to 'susfs:' string on susfs detection

If you have a kernel patched to susfs 1.5.2 download the 1.5.2 version here
[Download](https://github.com/sidex15/ksu_module_susfs/releases/latest/download/ksu_module_susfs_1.5.2.zip)

## v1.4.2 Revision 7
* Hide lineage vendor sepolicy traces (thanks @backslashxx)
* Hide Custom ROM related paths
* Hide Gapps releated paths
* Move addon.d and install-recovery.sh sus_path to boot-completed.sh
* Reduce false positives on module status description

## v1.4.2 Revision 6
* Move hide sus loopdev paths to service.sh

## v1.4.2 Revision 5
* Hide sus loopdev paths to fix Holmes 1.5.x futile hide (thanks simon punk and @backslashxx)
* Hide system_ext (thanks @rifsxd)
* Add status description if susfs is implemented in the kernel
* sus_su will not mount/installed if sus_su is not supported/turned on in the kernel

## v1.4.2 Revision 4
* Revert props command from susfs_hexpatch_props to resetprop

## v1.4.2 Revision 3
* Add related props from Shamiko using susfs_hexpatch_props
* Add VerifiedBootHash directory for devices with missing `ro.boot.vbmeta.digest` value
	* Located at `/data/adb/VerifiedBootHash/VerifiedBootHash.txt`
* Enable SUS_SU for SUS_SU enabled kernel (uses kprobe hook)
	* for kernel that manually implemented the KSU instead of kprobes, if you have abnormal environment detected try comment the `enable_sus_su` in `service.sh`
* Move /system/etc mount to post-mount script
	* This will only work if the module executed before the SUSFS module
	* For systemless hosts module you need to use [sidex15's fork](https://github.com/sidex15/systemless-hosts-KernelSU-module)

## v1.4.2 Revision 2
* Hide /vendor
* Add a script that checks if YouTube Revanced is mounted 15 times
	* This will ensure YouTube Revanced is hidden after the boot is completed
	* Thanks "silvzr" from telegram for this workaround

## v1.4.2 Revision 1
* Hide Custom Rom-specific files
- Remove unnecessary hosts hide sus-fs commands

## v1.4.2-SUSFS
* Initial release