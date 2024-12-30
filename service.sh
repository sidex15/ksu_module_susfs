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
sus_su=1
sus_su_active=1
[ -f $PERSISTENT_DIR/config.sh ] && source $PERSISTENT_DIR/config.sh

## sus_su ##
enable_sus_su(){
        ## Create a 'overlay' folder in module root directory for storing the 'su' and sus_su_drv_path in /system/bin/ ##
        SYSTEM_OL=${MODDIR}/overlay
        rm -rf ${SYSTEM_OL}  2>/dev/null
        mkdir -p ${SYSTEM_OL}/system_bin 2>/dev/null
         ## Enable sus_su or abort the function if sus_su is not supported ##
        if ! ${SUSFS_BIN} sus_su 1; then
			sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
			return
        fi
        ## Copy the new generated sus_su_drv_path and 'sus_su' to /system/bin/ and rename 'sus_su' to 'su' ##
        cp -f /data/adb/ksu/bin/sus_su ${SYSTEM_OL}/system_bin/su
        cp -f /data/adb/ksu/bin/sus_su_drv_path ${SYSTEM_OL}/system_bin/sus_su_drv_path
		## Generate sus_su_enabled flag ##
		echo 1 > ${MODDIR}/sus_su_enabled
        ## Setup permission ##
        susfs_clone_perm ${SYSTEM_OL}/system_bin /system/bin
        susfs_clone_perm ${SYSTEM_OL}/system_bin/su /system/bin/sh
        susfs_clone_perm ${SYSTEM_OL}/system_bin/sus_su_drv_path /system/bin/sh
        ## Mount the overlay ##
        mount -t overlay KSU -o "lowerdir=${SYSTEM_OL}/system_bin:/system/bin" /system/bin
        ## Hide the mountpoint ##
        ${SUSFS_BIN} add_sus_mount /system/bin
        ## Umount it for no root granted process ##
        ${SUSFS_BIN} add_try_umount /system/bin 1
		sed -i "s/^sus_su=.*/sus_su=1/" ${PERSISTENT_DIR}/config.sh
		sed -i "s/^sus_su_active=.*/sus_su_active=1/" ${PERSISTENT_DIR}/config.sh
}

## Enable sus_su ##
[ $sus_su = 1 ] && {
	enable_sus_su
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
	sepolicy_cil=/vendor/etc/selinux/vendor_sepolicy.cil
	grep -q lineage $sepolicy_cil && {
		grep -v "lineage" $sepolicy_cil > $tmpcustomrom/vendor_sepolicy.cil
		${SUSFS_BIN} add_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $tmpcustomrom/vendor_sepolicy.cil $sepolicy_cil
		mount --bind $tmpcustomrom/vendor_sepolicy.cil $sepolicy_cil
		${SUSFS_BIN} update_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $sepolicy_cil && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
}

# echo "hide_compat_matrix=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_compat_matrix = 1 ] && {
	echo "susfs4ksu/service: [hide_compat_matrix] - compatibility_matrix.device.xml" >> $logfile1
	compatibility_matrix=/system/etc/vintf/compatibility_matrix.device.xml
	grep -q lineage $compatibility_matrix && {
		grep -v "lineage" $compatibility_matrix > $tmpcustomrom/compatibility_matrix.device.xml
		${SUSFS_BIN} add_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $tmpcustomrom/compatibility_matrix.device.xml $compatibility_matrix
		mount --bind $tmpcustomrom/compatibility_matrix.device.xml $compatibility_matrix
		${SUSFS_BIN} update_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $compatibility_matrix && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
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
