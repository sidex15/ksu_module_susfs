#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
source ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
logfile1="$tmpfolder/logs/susfs1.log"
logfile="$tmpfolder/logs/susfs.log"

hide_loops=1
hide_vendor_sepolicy=1
hide_compat_matrix=1
[ -f $PERSISTENT_DIR/config.sh ] && source $PERSISTENT_DIR/config.sh

#### Enable sus_su ####
enable_sus_su_mode_1(){
  ## Here we manually create an system overlay an copy the sus_su and sus_su_drv_path to ${MODDIR}/system/bin after sus_su is enabled,
  ## as ksu overlay script is executed after all post-fs-data.sh scripts are finished

  rm -rf ${MODDIR}/system 2>/dev/null
  # Enable sus_su or abort the function if sus_su is not supported #
  if ! ${SUSFS_BIN} sus_su 1; then
    return
  fi
  mkdir -p ${MODDIR}/system/bin 2>/dev/null
  # Copy the new generated sus_su_drv_path and 'sus_su' to /system/bin/ and rename 'sus_su' to 'su' #
  cp -f /data/adb/ksu/bin/sus_su ${MODDIR}/system/bin/su
  cp -f /data/adb/ksu/bin/sus_su_drv_path ${MODDIR}/system/bin/sus_su_drv_path
  echo 1 > ${MODDIR}/sus_su_mode
  return
}
# uncomment it below to enable sus_su with mode 1 #
#enable_sus_su_mode_1

# SUS_SU 2#
sus_su_2(){
  if ! ${SUSFS_BIN} sus_su 2; then
    return
  fi
echo 2 > ${MODDIR}/sus_su_mode
return
}

# uncomment it below to enable sus_su with mode 2 #
sus_su_2

if_both_sus_su_disabled(){
	if grep -q '^#enable_sus_su_mode_1$' $MODDIR/service.sh && grep -q "^#sus_su_2$" $MODDIR/service.sh; then
		if ! ${SUSFS_BIN} sus_su 0; then
			return
		fi
		echo 0 > ${MODDIR}/sus_su_mode;
	fi
}

# if both sus_su are disabled (Do not remove)#
if_both_sus_su_disabled

## Disable susfs kernel log ##
${SUSFS_BIN} enable_log 1

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
		grep -v "lineage" $sepolicy_cil > $tmpfolder/vendor_sepolicy.cil
		${SUSFS_BIN} add_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $tmpfolder/vendor_sepolicy.cil $sepolicy_cil
		mount --bind $tmpfolder/vendor_sepolicy.cil $sepolicy_cil
		${SUSFS_BIN} update_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $sepolicy_cil && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
}

# echo "hide_compat_matrix=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_compat_matrix = 1 ] && {
	echo "susfs4ksu/service: [hide_compat_matrix] - compatibility_matrix.device.xml" >> $logfile1
	compatibility_matrix=/system/etc/vintf/compatibility_matrix.device.xml
	grep -q lineage $compatibility_matrix && {
		grep -v "lineage" $compatibility_matrix > $tmpfolder/compatibility_matrix.device.xml
		${SUSFS_BIN} add_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $tmpfolder/compatibility_matrix.device.xml $compatibility_matrix
		mount --bind $tmpfolder/compatibility_matrix.device.xml $compatibility_matrix
		${SUSFS_BIN} update_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $compatibility_matrix && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
}

sleep 15;
dmesg | grep ksu_susfs > ${MODDIR}/susfslogs.txt
dmesg | grep susfs_auto_add > $logfile
dmesg | grep ksu_susfs >> $logfile
