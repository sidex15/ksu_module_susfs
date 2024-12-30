#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

# hide revanced
sleep 10s
packages="com.google.android.youtube com.google.android.apps.youtube.music"
hide_app () {
	for path in $(pm path $1 | cut -d: -f2) ; do ${SUSFS_BIN} add_sus_mount $path ; ${SUSFS_BIN} add_try_umount $path 1 ; done
}
for i in $packages ; do hide_app $i ; done 