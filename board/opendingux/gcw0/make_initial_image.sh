#!/bin/sh

# Builds a full SD card image
#
# If you want the localpack apps included in the image, run this first:
# board/opendingux/gcw0/download_local_pack.sh

set -e

make world mininit host-od-imager

# Data image (OPKs):
cd output/images
mkdir -p od-imager/apps/
rm -f od-imager/apps/*
if [ -d ../../dl/od_local_pack/ ]; then
	cp ../../dl/od_local_pack/*.opk od-imager/apps/
fi
if [ -d opks ]; then
	cp opks/*.opk od-imager/apps/
fi

# System image
cp mininit-syspart od-imager/
cp vmlinuz.bin od-imager/
cp modules.squashfs od-imager/
cp rootfs.squashfs od-imager/
# Fallbacks are empty as this is the initial image.
echo -n > od-imager/vmlinuz.bak
echo -n > od-imager/modules.squashfs.bak

# Bootloader
cp ubiboot/ubiboot-rg350.bin od-imager/ubiboot.bin
cd -

# Assemble partitions and the final image
cd output/images/od-imager/
./create_mbr.sh
./create_system_image.sh
./create_data_image.sh
./assemble_images.sh
cd -

echo
echo 'SD card image created in:'
echo output/images/od-imager/images/sd_image.bin
echo Size:
du -sh output/images/od-imager/images/sd_image.bin
