#!/bin/sh

KERNEL=output/images/vmlinuz.bin
ROOTFS=output/images/rootfs.squashfs
MODULES=output/images/modules.squashfs
MININIT=output/images/mininit-syspart

make mininit

# create sha1sums
for f in "$KERNEL" "$ROOTFS" "$MODULES" "$MININIT"; do
	sha1sum -b "$f" | cut -d' ' -f1 > "$f.sha1"
done

cp -f $KERNEL output/images/vmlinuz.bak
cp -f $KERNEL.sha1 output/images/vmlinuz.bak.sha1
cp -f $MODULES $MODULES.bak
cp -f $MODULES.sha1 $MODULES.bak.sha1

# remove previous packages
rm -rf output/images/boot.vfat
rm -rf output/images/apps.ext4
rm -rf output/images/sdcard.img

# Copy OPKs
mkdir -p output/images/apps_partition/apps/
if [ -d output/images/local_pack/ ]; then
	cp output/images/local_pack/*.opk output/images/apps_partition/apps/
fi
cp output/images/opks/*.opk output/images/apps_partition/apps/

# Clear output/images-tmp
rm -rf output/images-tmp

# Empty rootfs
rm -rf output/genimage-empty-root
mkdir output/genimage-empty-root

# Build sdcard.img from board/opendingux/gcw0/genimage.cfg
output/host/usr/bin/genimage \
	    --config board/opendingux/gcw0/genimage.cfg \
	    --rootpath output/genimage-empty-root \
	    --inputpath output/images \
	    --outputpath output/images \
	    --tmppath output/images-tmp

# Clear output/images-tmp
rm -rf output/images-tmp


