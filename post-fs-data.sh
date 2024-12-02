#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder/logs
logfile="$tmpfolder/logs/susfs.log"

dmesg | grep -q "susfs_init" > /dev/null && touch $tmpfolder/logs/susfs_active

echo "susfs4ksu/post-fs-data: [logging_initialized]" > $logfile

# to add paths
# echo "/system/addon.d" >> /data/adb/susfs4ksu/sus_path.txt
# this'll make it easier for the webui to do stuff
for i in $(grep -v "#" $PERSISTENT_DIR/sus_path.txt); do
	${SUSFS_BIN} add_sus_path $i && echo "susfs4ksu/post-fs-data: [add_sus_path] $i" >> $logfile
done

# LSPosed
# but this is probably not needed if auto_sus_bind_mount is enabled
for i in $(grep "dex2oa" /proc/mounts | cut -f2 -d " "); do 
	${SUSFS_BIN} add_try_umount $i 1 && echo "susfs4ksu/post-fs-data: [add_try_umount] $i" >> $logfile
	${SUSFS_BIN} add_sus_mount $i && echo "susfs4ksu/post-fs-data: [add_sus_mount] $i" >> $logfile
done

# EOF
