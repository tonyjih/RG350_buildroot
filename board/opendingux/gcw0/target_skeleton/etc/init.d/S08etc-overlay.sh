#!/bin/sh

if [ -z "$1" ] || [ "x$1" = "xstart" ]; then
	echo "Mounting overlay filesystem to /etc..."
	mkdir -p /usr/local/share/overlayfs/workdirs/etc
	mount overlay -t overlay -olowerdir=/etc,upperdir=/usr/local/etc,workdir=/usr/local/share/overlayfs/workdirs/etc /etc
fi
