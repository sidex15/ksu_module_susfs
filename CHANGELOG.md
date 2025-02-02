## v1.5.2-v1.5.4 Revision 14
### This fix is for GKI/SUS_SU Enabled SUSFS Users that mistakenly showed `SUSFS Is not available in your kernel` in WebUI <br> For GKI/SUS_SU Enabled Users please change to `sus_su=2` in /data/adb/susfs4ksu/config.sh then reboot to see if it persists

### WebUI
* fix susfs logs location and remove susfs_stats is zero condition
### Scripts
* scripts/service: Rework sus_su checks
  * For SUSFS v1.5.3+ it will use the `show enabled_features` feature to check if sus_su is supported or not
  * For SUSFS v1.5.2 will use the traditional check if sus_su throws an error or not
  * Add Check if sus_su is in mode 0
* scripts/boot-completed: use susfs version to check different set cmdline command

### Note
If you want to get newer updates or nightly updates, check the actions tab of [susfs4ksu module Here](https://github.com/sidex15/susfs4ksu-module/actions)

## v1.5.2-v1.5.4 Revision 13
### WebUI
* Implement Auto Hide Settings For SUSFS v1.5.4
  * Auto Hide Default Mounts
  * Auto Hide Bind Mounts
  * Auto Try Umount Bind Mounts
  * Try Umount For Zygote System Process
* move tmpfolder location to /data/adb/ksu/susfs4ksu
* Change 'not supported' to 'not available' in sus_su support to ease up confusion
### Scripts
* Add fake_service_list for custom rom hiding
  * Set fake_service_list=1 in config.sh
  * Not available in WebUI Custom settings yet as it's untested
* module: add SUSFS v1.5.4 userspace binaries
* module: make dynamic install more friendly for continuous integration
* cmdline hw device name spoof (Proof of Concept)
* scripts/service: fake encryption status
* Script/boot-completed: replace hard coded path to mntfolder
* Script/boot-completed: add cmdline compatibility for newer susfs binaries
* scripts: add mntfolder for functions/features that's using mount and sus_mount
* move tmpfolder to /data/adb/susfs4ksu 
* txtfiles: remove redundant /debug_ramdisk
* txtfiles: remove /data/adb/modules on try_umount list
* module: drop META-INF
* scripts/customize: susfs is ksu only
* scripts: remove bashism
* scripts/service: prevent grep to wc -l piping
* module: drop 32-bit arm support

## v1.5.2-v1.5.3 Revision 12
### Highly Recommend to delete `/data/adb/susfs4ksu/config.sh` first before updating to prevent unwanted issues (You only do this once, you don't need to do it again in future versions)
### WebUI
* Introduce spoof kernel version uname on boot
  * also has an option "Execute on post-fs-data" for better hiding (Dangerous if used improperly)
* Deprecate SUS_SU 1 and only use SUS_SU 2
* Change SUS_SU Toggles the same as v1.4.2
* Remove `su -c` in all of run and exec functions to fix some devices that kernel panics when opening the webui
* Use /data/adb/ksu/bin/ksu_susfs for features that use ksu_susfs commands
* Auto detects SUS_SU support from sus_su, and sus_su_active values
* Warning will show if SUS_SU 1 is forcefully enabled.
* Replace error symbol to warning symbol if sus_fs is not installed in your kernel (to avoid confusion)
* Minor loading improvements

### Scripts
* Implement Dynamic install for v1.5.2+
  * Currently v1.5.2-v1.5.3
* Use Dynamic version in module version
* Fix try_umount param (thanks @etnperlong)
* Implement susfs_log, sus_su, and sus_su_active, and spoof_uname functions and configs
* Add ability to override for susfs activation (thanks @backslashxx)
	* `touch /data/adb/susfs4ksu/susfs_force_override`
* Add kernelversion.txt for kernel uname spoofing on boot
* Add new configs if the config doesn't exist on /data/adb/susfs4ksu/config.sh
* Other misc fixes (thanks @backslashxx)

## v1.5.2 Revision 11
### WebUI
* Implement Try Umount Section in custom settings page
* Implement additional custom rom settings
  * Hide vendor sepolicy (disabled by default)
  * Hide Compat Matrix (disabled by default)
* Significant code refactor on the stats menu to reduce lag when lauching.
* Significant code refactor custom toggles of custom settings menu to reduce lag when going to custom settings.
* Very minor UI adjustments.
* UI adjust for MMRL
### Scripts
* Implement Compat Matrix hide for the latest native detector (6.5.7) (thanks @AzyrRuthless)
* Add hide_vendor_sepolicy, hide_compat_matrix, and try_umount configurations
* Count the number of sus_path sus_mount and try_umount for WebUI stats on dmesg instead of logs
* Remove the webroot folder if SUSFS is not supported in the kernel
### KSU_SUSFS
* update susfs userspace tool

## v1.5.2 Revision 10
* change again the module status check from 'susfs_init' to 'susfs:'
* Fix sus_su installation

## v1.5.2 Revision 9
* **WebUI: Introduce Custom Settings page**
  This includes:
  * Hide custom ROM paths
  * Hide Gapps
  * Hide Revanced (Youtube/Youtube Music)
  * Spoof CMDLINE (Experimental)
  * Hide KSU Loops
  * Force Hide LSPosed Mounts
  * Custom SUS Paths
  * Custom SUS Mounts
* WebUI: Add @backslashxx @rifsxd to credits page
* WebUI: White Mode
* Scripts: Complete rework to provide more customizability of sus_path and sus_mounts to WebUI (Big thanks to @backslashxx)
  * The settings are in /data/adb/susfs4ksu
* Scripts: Improve logging for WebUI stats
  * If the stats don't show in WebUI it could be your logd are disabled or there is a low log buffer size in the kernel
  * If the WebUI Stats finds no susfs paths and mounts inside the main susfs.log, it will fall off to susfs1.log which logs for susfs paths/mounts executed from the boot scripts.
* Implement dynamic install of ksu_susfs bins for gki and non-gki
* Introduce Spoof CMDLINE (experimental)
* Use auto susfs hide by default by removing susfs mounts in the script and sus_path.txt
* Hide custom rom, gapps, cmdline, and force LSPosed are off by default

## v1.5.2 Revision 8
* Introducing SUSFS WebUI 1.5.2
	* SUS_PATH, SUS_MOUNT, and TRY_UMOUNT Stats
	* SUSFS Logs toggle
	* SUS SU modes (0,1,2)
	* SUS SU modes on boot (1,2)
	* Spoof Kernel Version
* Move addon.d and install-recovery.sh sus_path to post-fs-data.sh
* Remove comment on susfs enable log and make susfslogs.txt
* Change to 'susfs:' string on susfs detection

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