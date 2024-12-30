#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder/logs
logfile="$tmpfolder/logs/susfs.log"
logfile1="$tmpfolder/logs/susfs1.log"

dmesg | grep -q "susfs:" > /dev/null && touch $tmpfolder/logs/susfs_active

force_hide_lsposed=0
[ -f $PERSISTENT_DIR/config.sh ] && source $PERSISTENT_DIR/config.sh

echo "susfs4ksu/post-fs-data: [logging_initialized]" > $logfile1

# to add paths
# echo "/system/addon.d" >> /data/adb/susfs4ksu/sus_path.txt
# this'll make it easier for the webui to do stuff
for i in $(grep -v "#" $PERSISTENT_DIR/sus_path.txt); do
	${SUSFS_BIN} add_sus_path $i && echo "[sus_path]: susfs4ksu/post-fs-data $i" >> $logfile1
done

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

