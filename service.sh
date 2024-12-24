#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/data/adb/susfs4ksu
tmpcustomrom=/debug_ramdisk/susfs4ksu
logfile1="$tmpfolder/logs/susfs1.log"
logfile="$tmpfolder/logs/susfs.log"

hide_loops=1
hide_vendor_sepolicy=0
hide_compat_matrix=0
susfs_log=1
sus_su=2
[ -f $PERSISTENT_DIR/config.sh ] && source $PERSISTENT_DIR/config.sh

# SUS_SU 2#
sus_su_2(){
	# Enable sus_su or abort the function if sus_su is not supported #
	if ! ${SUSFS_BIN} sus_su 2; then
		sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		return
	fi
	sed -i "s/^sus_su=.*/sus_su=2/" ${PERSISTENT_DIR}/config.sh
	sed -i "s/^sus_su_acitve=.*/sus_active=2/" ${PERSISTENT_DIR}/config.sh
	return
}

# uncomment it below to enable sus_su with mode 2 #
[ $sus_su = 2 ] && {
	sus_su_2
}

## Disable susfs kernel log ##
[ $susfs_log = 1 ] && {
	${SUSFS_BIN} enable_log 1
}

## Props ##
resetprop -w sys.boot_completed 0

check_reset_prop "ro.boot.vbmeta.device_state" "locked"
check_reset_prop "ro.boot.verifiedbootstate" "green"
check_reset_prop "ro.boot.flash.locked" "1"
check_reset_prop "ro.boot.veritymode" "enforcing"
check_reset_prop "ro.boot.warranty_bit" "0"
check_reset_prop "ro.warranty_bit" "0"
check_reset_prop "ro.debuggable" "0"
check_reset_prop "ro.force.debuggable" "0"
check_reset_prop "ro.secure" "1"
check_reset_prop "ro.adb.secure" "1"
check_reset_prop "ro.build.type" "user"
check_reset_prop "ro.build.tags" "release-keys"
check_reset_prop "ro.vendor.boot.warranty_bit" "0"
check_reset_prop "ro.vendor.warranty_bit" "0"
check_reset_prop "vendor.boot.vbmeta.device_state" "locked"
check_reset_prop "vendor.boot.verifiedbootstate" "green"
check_reset_prop "sys.oem_unlock_allowed" "0"

# MIUI specific
check_reset_prop "ro.secureboot.lockstate" "locked"

# Realme specific
check_reset_prop "ro.boot.realmebootstate" "green"
check_reset_prop "ro.boot.realme.lockstate" "1"

# Hide that we booted from recovery when magisk is in recovery mode
contains_reset_prop "ro.bootmode" "recovery" "unknown"
contains_reset_prop "ro.boot.bootmode" "recovery" "unknown"
contains_reset_prop "vendor.boot.bootmode" "recovery" "unknown"

# Set vbmeta verifiedBootHash from file (if present and not empty)
HASH_FILE="/data/adb/VerifiedBootHash/VerifiedBootHash.txt"
if [ -s "$HASH_FILE" ]; then
    resetprop -v -n ro.boot.vbmeta.digest "$(cat $HASH_FILE)"
fi

# echo "hide_loops=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_loops = 1 ] && {
	echo "susfs4ksu/service: [hide_loops]" >> $logfile1
	for device in $(ls -Ld /proc/fs/jbd2/loop*8 | sed 's|/proc/fs/jbd2/||; s|-8||'); do
		${SUSFS_BIN} add_sus_path /proc/fs/jbd2/${device}-8 && echo "[sus_path]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_path /proc/fs/ext4/${device} && echo "[sus_path]: susfs4ksu/service $i" >> $logfile1
	done
}


# echo "hide_vendor_sepolicy=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_vendor_sepolicy = 1 ] && {
	echo "susfs4ksu/service: [hide_vendor_sepolicy]" >> $logfile1
	[ ! -f $MODDIR/overlay/vendor/etc/selinux/vendor_sepolicy.cil ] && { 
		mkdir -p $MODDIR/overlay/vendor/etc/selinux
		grep -v lineage /vendor/etc/selinux/vendor_sepolicy.cil > $MODDIR/overlay/vendor/etc/selinux/vendor_sepolicy.cil
		susfs_clone_perm $MODDIR/overlay/vendor/etc/selinux/vendor_sepolicy.cil /vendor/etc/selinux/vendor_sepolicy.cil
		}
	mount -t overlay -o "lowerdir=$MODDIR/overlay/vendor/etc:/vendor/etc" overlay /vendor/etc
	${SUSFS_BIN} add_sus_mount /vendor/etc
}

# echo "hide_compat_matrix=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_compat_matrix = 1 ] && {
	echo "susfs4ksu/service: [hide_compat_matrix] - compatibility_matrix.device.xml" >> $logfile1
	[ ! -f $MODDIR/overlay/system/etc/vintf/compatibility_matrix.device.xml ] && { 
		mkdir -p $MODDIR/overlay/system/etc/vintf
		grep -v lineage /system/etc/vintf/compatibility_matrix.device.xml > $MODDIR/overlay/system/etc/vintf/compatibility_matrix.device.xml
		susfs_clone_perm $MODDIR/overlay/system/etc/vintf/compatibility_matrix.device.xml /system/etc/vintf/compatibility_matrix.device.xml
		}
	mount -t overlay -o "lowerdir=$MODDIR/overlay/system/etc:/system/etc" overlay /system/etc
	${SUSFS_BIN} add_sus_mount /vendor/etc
}

sleep 15;
dmesg | grep ksu_susfs > ${MODDIR}/susfslogs.txt
dmesg | grep susfs_auto_add > $logfile
dmesg | grep ksu_susfs >> $logfile
# susfs stats
rm ${tmpfolder}/susfs_stats.txt
echo sus_path=$(dmesg | grep 'SUS_PATH_HLIST' | wc -l) >> ${tmpfolder}/susfs_stats.txt
echo sus_mount=$(dmesg | (grep -we 'set SUS_MOUNT' -we 'LH_SUS_MOUNT') | wc -l) >> ${tmpfolder}/susfs_stats.txt
echo try_umount=$(dmesg | grep 'LH_TRY_UMOUNT_PATH' | wc -l) >> ${tmpfolder}/susfs_stats.txt
rm ${tmpfolder}/susfs_stats1.txt
echo sus_path=$(grep -i 'sus_path'  $logfile1 | wc -l) >> ${tmpfolder}/susfs_stats1.txt
echo sus_mount=$(grep -i 'sus_mount'  $logfile1 | wc -l) >> ${tmpfolder}/susfs_stats1.txt
echo try_umount=$(grep -i 'try_umount'  $logfile1 | wc -l) >> ${tmpfolder}/susfs_stats1.txt
