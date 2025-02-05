#!/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/data/adb/ksu/susfs4ksu
mntfolder=/debug_ramdisk/susfs4ksu
logfile1="$tmpfolder/logs/susfs1.log"
logfile="$tmpfolder/logs/susfs.log"
version=$(${SUSFS_BIN} show version)
SUSFS_DECIMAL=$(echo "$version" | sed 's/^v//; s/\.//g')

hide_loops=1
hide_vendor_sepolicy=0
hide_compat_matrix=0
fake_service_list=0
susfs_log=1
sus_su=2
[ -f $PERSISTENT_DIR/config.sh ] && . $PERSISTENT_DIR/config.sh

# SUS_SU 2#
sus_su_2(){
	# Enable sus_su or abort the function if sus_su is not supported #
	if ! ${SUSFS_BIN} sus_su 2; then
		sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		return
	fi
	sed -i "s/^sus_su=.*/sus_su=2/" ${PERSISTENT_DIR}/config.sh
	sed -i "s/^sus_su_active=.*/sus_active=2/" ${PERSISTENT_DIR}/config.sh
	return
}

# sus_su #
[ $sus_su = 2 ] && {
	# Check for susfs version (1.5.3 and above)
	if [ -n "$version" ] && [ "$SUSFS_DECIMAL" -gt 152 ] 2>/dev/null; then
		# Check if sus_su is supported
		if ${SUSFS_BIN} show enabled_features 2>/dev/null | grep -q "CONFIG_KSU_SUSFS_SUS_SU"; then
			${SUSFS_BIN} sus_su 2
			sed -i "s/^sus_su=.*/sus_su=2/" ${PERSISTENT_DIR}/config.sh
			sed -i "s/^sus_su_active=.*/sus_active=2/" ${PERSISTENT_DIR}/config.sh
		else
			sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		fi
	else
	# this one is for older verisons of susfs
		sus_su_2
	fi
}

[ $sus_su = 0 ] && {
	if [ -n "$version" ] && [ "$SUSFS_DECIMAL" -gt 152 ] 2>/dev/null; then
		# Check if sus_su is supported
		if ! ${SUSFS_BIN} show enabled_features 2>/dev/null | grep -q "CONFIG_KSU_SUSFS_SUS_SU"; then
			sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		else
			${SUSFS_BIN} sus_su 0
			sed -i "s/^sus_su_active=.*/sus_active=0/" ${PERSISTENT_DIR}/config.sh
		fi
	else
		if ! ${SUSFS_BIN} sus_su 0; then
			sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		else
			sed -i "s/^sus_su_active=.*/sus_active=0/" ${PERSISTENT_DIR}/config.sh
		fi
	fi
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

# fake encryption status
check_reset_prop "ro.crypto.state" "encrypted"

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
		grep -v "lineage" $sepolicy_cil > $mntfolder/vendor_sepolicy.cil
		${SUSFS_BIN} add_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $mntfolder/vendor_sepolicy.cil $sepolicy_cil
		mount --bind $mntfolder/vendor_sepolicy.cil $sepolicy_cil
		${SUSFS_BIN} update_sus_kstat $sepolicy_cil && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $sepolicy_cil && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
}

# echo "hide_compat_matrix=1" >> /data/adb/susfs4ksu/config.sh
[ $hide_compat_matrix = 1 ] && {
	echo "susfs4ksu/service: [hide_compat_matrix] - compatibility_matrix.device.xml" >> $logfile1
	compatibility_matrix=/system/etc/vintf/compatibility_matrix.device.xml
	grep -q lineage $compatibility_matrix && {
		grep -v "lineage" $compatibility_matrix > $mntfolder/compatibility_matrix.device.xml
		${SUSFS_BIN} add_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		susfs_clone_perm $mntfolder/compatibility_matrix.device.xml $compatibility_matrix
		mount --bind $mntfolder/compatibility_matrix.device.xml $compatibility_matrix
		${SUSFS_BIN} update_sus_kstat $compatibility_matrix && echo "[update_sus_kstat]: susfs4ksu/service $i" >> $logfile1
		${SUSFS_BIN} add_sus_mount $compatibility_matrix && echo "[sus_mount]: susfs4ksu/service $i" >> $logfile1
	}
}

# echo "fake_service_list=1" >> /data/adb/susfs4ksu/config.sh
[ $fake_service_list = 1 ] && {
	# feed fake service list
	# this is bs but what can we do
	mkdir -p "$mntfolder/system_bin"
	echo "#!/bin/sh" > "$mntfolder/system_bin/service"
	echo "FAKELIST=\"$(/system/bin/service list | sed 's/lineage//g; s/Lineage//g' | base64 -w 0)"\" >> "$mntfolder/system_bin/service"
	echo "echo \$FAKELIST | base64 -d" >> "$mntfolder/system_bin/service"
	susfs_clone_perm "$mntfolder/system_bin/service" /system/bin/service
	${SUSFS_BIN} add_sus_kstat /system/bin/service
	mount --bind "$mntfolder/system_bin/service" /system/bin/service
	${SUSFS_BIN} update_sus_kstat /system/bin/service
	${SUSFS_BIN} add_sus_mount /system/bin/service
}

sleep 15;
dmesg | grep ksu_susfs > ${MODDIR}/susfslogs.txt
dmesg | grep susfs_auto_add > $logfile
dmesg | grep ksu_susfs >> $logfile
# susfs stats
rm ${tmpfolder}/susfs_stats.txt
echo sus_path=$(dmesg | grep -c 'SUS_PATH_HLIST') >> ${tmpfolder}/susfs_stats.txt
echo sus_mount=$(dmesg | grep -cE "set SUS_MOUNT|LH_SUS_MOUNT" ) >> ${tmpfolder}/susfs_stats.txt
echo try_umount=$(dmesg | grep -c 'LH_TRY_UMOUNT_PATH') >> ${tmpfolder}/susfs_stats.txt
rm ${tmpfolder}/susfs_stats1.txt
echo sus_path=$(grep -ci 'sus_path' $logfile1 ) >> ${tmpfolder}/susfs_stats1.txt
echo sus_mount=$(grep -ci 'sus_mount' $logfile1 ) >> ${tmpfolder}/susfs_stats1.txt
echo try_umount=$(grep -ci 'try_umount' $logfile1 ) >> ${tmpfolder}/susfs_stats1.txt
rm -rf $mntfolder
# EOF
