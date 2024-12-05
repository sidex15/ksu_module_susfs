#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
logfile="$tmpfolder/logs/susfs.log"
logfile1="$tmpfolder/logs/susfs1.log"
# to add mounts
# echo "/system" >> /data/adb/susfs4ksu/sus_mount.txt
# this'll make it easier for the webui to do stuff
for i in $(grep -v "#" $PERSISTENT_DIR/sus_mount.txt); do
	${SUSFS_BIN} add_sus_mount $i && echo "[sus_mount]: susfs4ksu/post-mount $i" >> $logfile1
done

# EOF
