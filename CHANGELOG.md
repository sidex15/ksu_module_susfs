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