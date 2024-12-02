#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder

#Custom Rom
${SUSFS_BIN} add_sus_path /system/addon.d
${SUSFS_BIN} add_sus_path /vendor/bin/install-recovery.sh
${SUSFS_BIN} add_sus_path /system/bin/install-recovery.sh

# LSPosed
# but this is probably not needed if auto_sus_bind_mount is enabled
for i in $(grep "dex2oa" /proc/mounts | cut -f2 -d " "); do ${SUSFS_BIN} add_try_mount $i 1 ; ${SUSFS_BIN} add_sus_mount $i ; done

# no idea if helpful but lets abuse this new feature
sed 's|androidboot.verifiedbootstate=orange|androidboot.verifiedbootstate=green|g' /proc/cmdline > /debug_ramdisk/susfs4ksu/cmdline
${SUSFS_BIN} set_proc_cmdline /debug_ramdisk/susfs4ksu/cmdline

# EOF
