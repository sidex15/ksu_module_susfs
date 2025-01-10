#!/bin/sh
PATH=/data/adb/ksu/bin:$PATH
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. ${MODDIR}/utils.sh
PERSISTENT_DIR=/data/adb/susfs4ksu
tmpfolder=/debug_ramdisk/susfs4ksu
mkdir -p $tmpfolder/logs
mkdir -p $tmpfolder
logfile="$tmpfolder/logs/susfs.log"
logfile1="$tmpfolder/logs/susfs1.log"
kernel_ver=$(head -n 1 "$PERSISTENT_DIR/kernelversion.txt")

# use 1.5.3+ feature
if [ $(${SUSFS_BIN} show version | head -n1 | sed 's/v//; s/\.//g') -ge 153 ]; then
	touch $tmpfolder/logs/susfs_active
else
	dmesg | grep -q "susfs:" > /dev/null && touch $tmpfolder/logs/susfs_active
fi

# for people that is on legacy with broken dmesg or disabled logging
# actually first, fuck you
# second, heres your override
# touch /data/adb/susfs4ksu/susfs_force_override
[ -f $PERSISTENT_DIR/susfs_force_override ] && touch $tmpfolder/logs/susfs_active

force_hide_lsposed=0
spoof_uname=0
[ -f $PERSISTENT_DIR/config.sh ] && . $PERSISTENT_DIR/config.sh

echo "susfs4ksu/post-fs-data: [logging_initialized]" > $logfile1

# if spoof_uname is on mode 2, set_uname will be called here
[ $spoof_uname = 2 ] && {
	[ -f "$PERSISTENT_DIR/kernelversion.txt" ] || kernel_ver="default"
	[ -z "$kernel_ver" ] && kernel_ver="default"
    ${SUSFS_BIN} set_uname $kernel_ver 'default'
}

#### Enable sus_su ####
enable_sus_su_mode_1(){
  ## Here we manually create an system overlay an copy the sus_su and sus_su_drv_path to ${MODDIR}/system/bin after sus_su is enabled,
  ## as ksu overlay script is executed after all post-fs-data.sh scripts are finished

  rm -rf ${MODDIR}/system 2>/dev/null
  # Enable sus_su or abort the function if sus_su is not supported #
  # Enable sus_su or abort the function if sus_su is not supported #
	if ! ${SUSFS_BIN} sus_su 1; then
		sed -i "s/^sus_su=.*/sus_su=-1/" ${PERSISTENT_DIR}/config.sh
		return
	fi
	# Enable sus_su or abort the function if sus_su is not supported #
	sed -i "s/^sus_su=.*/sus_su=1/" ${PERSISTENT_DIR}/config.sh
	sed -i "s/^sus_su_acitve=.*/sus_active=1/" ${PERSISTENT_DIR}/config.sh
	echo 'sus_su=1' >> ${PERSISTENT_DIR}/config.sh
	mkdir -p ${MODDIR}/system/bin 2>/dev/null
	# Copy the new generated sus_su_drv_path and 'sus_su' to /system/bin/ and rename 'sus_su' to 'su' #
	cp -f /data/adb/ksu/bin/sus_su ${MODDIR}/system/bin/su
	cp -f /data/adb/ksu/bin/sus_su_drv_path ${MODDIR}/system/bin/sus_su_drv_path
	echo 1 > ${MODDIR}/sus_su_mode
	return
}
# uncomment it below to enable sus_su with mode 1 #
#enable_sus_su_mode_1

# LSPosed
# but this is probably not needed if auto_sus_bind_mount is enabled
[ $force_hide_lsposed = 1 ] && {
	echo "susfs4ksu/boot-completed: [force_hide_lsposed]" >> $logfile1
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
}

# if global_whiteouts.txt has contents and toggle is enabled
# echo "global_whiteouts=1" >> /data/adb/susfs4ksu/config.sh
# then we do the whiteout routine
if [ $(grep -vc "#" $PERSISTENT_DIR/global_whiteouts.txt) -ge 1 ] && [ $global_whiteouts = 1 ]; then
	[ -w /mnt ] && basefolder=/mnt
	[ -w /mnt/vendor ] && basefolder=/mnt/vendor
	
	# global mount
	global_mount() {
		mkdir $basefolder/whiteouts
		${SUSFS_BIN} add_sus_path $basefolder/whiteouts
		cd $tmpfolder/overlay
		for i in $(ls -d */*); do
			mkdir -p $basefolder/whiteouts/$i
			mount --bind $tmpfolder/overlay/$i $basefolder/whiteouts/$i
			mount -t overlay -o "lowerdir=$basefolder/whiteouts/$i:/$i" overlay /$i
			${SUSFS_BIN} add_sus_mount /$i
		done
	}

	# whiteout_create
	whiteout_create() {
		mkdir -p "$tmpfolder/overlay/${1%/*}"
	  	busybox mknod "$tmpfolder/overlay/$1" c 0 0
	  	busybox setfattr -n trusted.overlay.whiteout -v y "$tmpfolder/overlay/$1"
	  	chmod 644 "$tmpfolder/overlay/$1"
	}
	
	# create whiteouts on a loop
	for file in $(sed '/#/d' $PERSISTENT_DIR/global_whiteouts.txt); do
		whiteout_create "$file" > /dev/null 2>&1
	done
	global_mount
fi

# EOF
