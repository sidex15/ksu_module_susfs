#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

#Custom Rom
${SUSFS_BIN} add_sus_path /system/addon.d
${SUSFS_BIN} add_sus_path /vendor/bin/install-recovery.sh
${SUSFS_BIN} add_sus_path /system/bin/install-recovery.sh

#KernelSU
${SUSFS_BIN} add_sus_mount /data/adb/modules
${SUSFS_BIN} add_sus_mount /debug_ramdisk

#LSPosed
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

#Modules for mounting system
${SUSFS_BIN} add_sus_mount /system

