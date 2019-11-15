#############################################################
#
# devil
#
#############################################################

DEVIL_VERSION = 1.7.8
DEVIL_SOURCE = DevIL-$(DEVIL_VERSION).tar.gz
DEVIL_SITE = http://downloads.sourceforge.net/openil

DEVIL_CONF_OPTS = --disable-game-formats --disable-blp --disable-dcx \
				 --disable-dds --disable-dicom --disable-wad \
				 --disable-fits --disable-gif --disable-hdr --disable-icns \
				 --disable-icon --disable-iff --disable-ilbm --disable-iwi \
				 --disable-lif --disable-mdl --disable-mp3 --disable-pcx \
				 --disable-pcd --disable-pic --disable-pix --disable-pnm \
				 --disable-psd --disable-psp --disable-pxr --disable-raw \
				 --disable-rot --disable-sgi --disable-sun --disable-tpl \
				 --disable-utx --disable-tga --disable-vtf --disable-wal \
				 --disable-wbmp --disable-wdp --disable-texture
DEVIL_INSTALL_STAGING = YES
DEVIL_AUTORECONF = YES

# Build at least PNG support
DEVIL_DEPENDENCIES += libpng

ifeq ($(BR2_PACKAGE_JPEG),y)
	DEVIL_DEPENDENCIES += jpeg
else
	DEVIL_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	DEVIL_DEPENDENCIES += tiff
else
	DEVIL_CONF_OPTS += --disable-tiff
endif

$(eval $(autotools-package))
