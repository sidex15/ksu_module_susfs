#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder/logs

echo "susfs4ksu/postfs-data: logging started" > $tmpfolder/logs/susfs.log

#Custom Rom
${SUSFS_BIN} add_sus_path /system/addon.d
${SUSFS_BIN} add_sus_path /vendor/bin/install-recovery.sh
${SUSFS_BIN} add_sus_path /system/bin/install-recovery.sh

# LSPosed
# but this is probably not needed if auto_sus_bind_mount is enabled
for i in $(grep "dex2oa" /proc/mounts | cut -f2 -d " "); do ${SUSFS_BIN} add_try_mount $i 1 ; ${SUSFS_BIN} add_sus_mount $i ; done

#Modules for mounting system
${SUSFS_BIN} add_sus_mount /system
