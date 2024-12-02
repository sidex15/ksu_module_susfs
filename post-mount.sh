#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
logfile="$tmpfolder/logs/susfs.log"

# to add mounts
# echo "/system" >> /data/adb/susfs4ksu/sus_mount.txt
# this'll make it easier for the webui to do stuff
for i in $(grep -v "#" $PERSISTENT_DIR/sus_mount.txt); do
	${SUSFS_BIN} add_sus_mount $i && echo "susfs4ksu/post-mount: [add_sus_mount] $i" >> $logfile
done

# EOF
