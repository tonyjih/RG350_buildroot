################################################################################
#
# tiff
#
################################################################################

TIFF_VERSION = 4.0.3
TIFF_SITE = http://download.osgeo.org/libtiff
TIFF_LICENSE = tiff license
TIFF_LICENSE_FILES = COPYRIGHT
TIFF_INSTALL_STAGING = YES
TIFF_CONF_OPTS = \
	--disable-cxx \
	--without-x \

TIFF_DEPENDENCIES = host-pkgconf

TIFF_TOOLS_LIST =
ifeq ($(BR2_PACKAGE_TIFF_TIFF2PDF),y)
	TIFF_TOOLS_LIST += tiff2pdf
endif
ifeq ($(BR2_PACKAGE_TIFF_TIFFCP),y)
	TIFF_TOOLS_LIST += tiffcp
endif

ifneq ($(BR2_PACKAGE_TIFF_CCITT),y)
	TIFF_CONF_OPTS += --disable-ccitt
endif

ifneq ($(BR2_PACKAGE_TIFF_PACKBITS),y)
	TIFF_CONF_OPTS += --disable-packbits
endif

ifneq ($(BR2_PACKAGE_TIFF_LZW),y)
	TIFF_CONF_OPTS += --disable-lzw
endif

ifneq ($(BR2_PACKAGE_TIFF_THUNDER),y)
	TIFF_CONF_OPTS += --disable-thunder
endif

ifneq ($(BR2_PACKAGE_TIFF_NEXT),y)
	TIFF_CONF_OPTS += --disable-next
endif

ifneq ($(BR2_PACKAGE_TIFF_LOGLUV),y)
	TIFF_CONF_OPTS += --disable-logluv
endif

ifneq ($(BR2_PACKAGE_TIFF_MDI),y)
	TIFF_CONF_OPTS += --disable-mdi
endif

ifneq ($(BR2_PACKAGE_TIFF_ZLIB),y)
	TIFF_CONF_OPTS += --disable-zlib
else
	TIFF_DEPENDENCIES += zlib
endif

ifneq ($(BR2_PACKAGE_TIFF_PIXARLOG),y)
	TIFF_CONF_OPTS += --disable-pixarlog
endif

ifneq ($(BR2_PACKAGE_TIFF_JPEG),y)
	TIFF_CONF_OPTS += --disable-jpeg
else
	TIFF_DEPENDENCIES += jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF_OLD_JPEG),y)
	TIFF_CONF_OPTS += --disable-old-jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF_JBIG),y)
	TIFF_CONF_OPTS += --disable-jbig
endif

define TIFF_INSTALL_TARGET_CMDS
	-cp -a $(@D)/libtiff/.libs/libtiff.so* $(TARGET_DIR)/usr/lib/
	for i in $(TIFF_TOOLS_LIST); \
	do \
		$(INSTALL) -m 755 -D $(@D)/tools/$$i $(TARGET_DIR)/usr/bin/$$i; \
	done
endef

$(eval $(autotools-package))
