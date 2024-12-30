#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

if dmesg | grep -q "susfs"; then
 description="description=status: ✅ SuS ඞ "
 else
 description="description=status: failed ❌ - Make sure you're on a SuSFS patched kernel!"
 touch ${MODDIR}/disable
fi

sed -i "s/^description=.*/$description/g" $MODDIR/module.prop

# hide lineage (almost all custom roms have this)
for i in $(find /system /vendor /system_ext /product -iname *lineage* -o -name *crdroid* ) ; do ${SUSFS_BIN} add_sus_path $i ; done

# hide gapps installation traces
for i in $(find /system /vendor /system_ext /product -iname *gapps*xml -o -type d -iname *gapps*) ; do ${SUSFS_BIN} add_sus_path $i ; done

# hide revanced
count=0 
max_attempts=15 
until grep "youtube" /proc/self/mounts || [ $count -ge $max_attempts ]; do 
    sleep 1 
    ((count++)) 
done
packages="com.google.android.youtube com.google.android.apps.youtube.music"
hide_app () {
	for path in $(pm path $1 | cut -d: -f2) ; do ${SUSFS_BIN} add_sus_mount $path ; ${SUSFS_BIN} add_try_umount $path 1 ; done
}
for i in $packages ; do hide_app $i ; done 