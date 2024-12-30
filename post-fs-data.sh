#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder/logs
mkdir -p $tmpfolder
logfile="$tmpfolder/logs/susfs.log"
logfile1="$tmpfolder/logs/susfs1.log"
kernel_ver=$(head -n 1 "$PERSISTENT_DIR/kernelversion.txt")

dmesg | grep -q "susfs:" > /dev/null && touch $tmpfolder/logs/susfs_active

# for people that is on legacy with broken dmesg or disabled logging
# actually first, fuck you
# second, heres your override
# touch /data/adb/susfs4ksu/susfs_force_override
[ -f $PERSISTENT_DIR/susfs_force_override ] && touch $tmpfolder/logs/susfs_active

force_hide_lsposed=0
spoof_uname=0
[ -f $PERSISTENT_DIR/config.sh ] && source $PERSISTENT_DIR/config.sh

echo "susfs4ksu/post-fs-data: [logging_initialized]" > $logfile1

# if spoof_uname is on mode 2, set_uname will be called here
[ $spoof_uname = 2 ] && {
	[ -f "$PERSISTENT_DIR/kernelversion.txt" ] || kernel_ver="default"
	[ -z "$kernel_ver" ] && kernel_ver="default"
    ${SUSFS_BIN} set_uname $kernel_ver 'default'
}

# LSPosed
# but this is probably not needed if auto_sus_bind_mount is enabled
[ $force_hide_lsposed = 1 ] && {
	echo "susfs4ksu/boot-completed: [force_hide_lsposed]" >> $logfile1
	${SUSFS_BIN} add_sus_mount /data/adb/modules/zygisk_lsposed/bin/dex2oat
	${SUSFS_BIN} add_sus_mount /data/adb/modules/zygisk_lsposed/bin/dex2oat32
	${SUSFS_BIN} add_sus_mount /data/adb/modules/zygisk_lsposed/bin/dex2oat64
	${SUSFS_BIN} add_sus_mount /system/apex/com.android.art/bin/dex2oat
	${SUSFS_BIN} add_sus_mount /system/apex/com.android.art/bin/dex2oat32
	${SUSFS_BIN} add_sus_mount /system/apex/com.android.art/bin/dex2oat64
	${SUSFS_BIN} add_sus_mount /apex/com.android.art/bin/dex2oat
	${SUSFS_BIN} add_sus_mount /apex/com.android.art/bin/dex2oat32
	${SUSFS_BIN} add_sus_mount /apex/com.android.art/bin/dex2oat64
	${SUSFS_BIN} add_try_umount /system/apex/com.android.art/bin/dex2oat 1
	${SUSFS_BIN} add_try_umount /system/apex/com.android.art/bin/dex2oat32 1
	${SUSFS_BIN} add_try_umount /system/apex/com.android.art/bin/dex2oat64 1
	${SUSFS_BIN} add_try_umount /apex/com.android.art/bin/dex2oat 1
	${SUSFS_BIN} add_try_umount /apex/com.android.art/bin/dex2oat32 1
	${SUSFS_BIN} add_try_umount /apex/com.android.art/bin/dex2oat64 1
}

