#!/bin/sh

DATA_PARTITION=/dev/mmcblk0p2
DATA_PARTITION_FS=auto

[ -r /boot/od.conf ] && . /boot/od.conf

if [ -z "$1" ] || [ "x$1" = "xstart" ]; then

	echo "Mounting data partition..."
	/bin/mount -o remount,rw /media
	/bin/mount -t ${DATA_PARTITION_FS} ${DATA_PARTITION} /media/data
	/bin/mount -o remount,ro /media
fi
