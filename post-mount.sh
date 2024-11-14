#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

#modules for mounting system
${SUSFS_BIN} add_sus_mount /system

#modules for mounting system_ext
${SUSFS_BIN} add_sus_mount /system_ext

#modules for mounting /system/etc
${SUSFS_BIN} add_sus_mount /system/etc

#modules for mounting /product
${SUSFS_BIN} add_sus_mount /product

#modules for mounting /vendor
${SUSFS_BIN} add_sus_mount /vendor
