#############################################################
#
# devil
#
#############################################################

# https://github.com/DentonW/DevIL/pull/68
DEVIL_VERSION = f9ee8110be16e254b4d46dc67edb615dd5fc7c6f
DEVIL_SITE = $(call github,dooglz,DevIL,$(DEVIL_VERSION))
DEVIL_SUBDIR = DevIL
DEVIL_CONF_OPT = -DIL_BUILD_ILUT=OFF

DEVIL_INSTALL_STAGING = YES

# Build at least PNG support
DEVIL_DEPENDENCIES += $(LIBGLES_DEPENDENCIES) libpng

ifeq ($(BR2_PACKAGE_JPEG),y)
	DEVIL_DEPENDENCIES += jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	DEVIL_DEPENDENCIES += tiff
endif

$(eval $(cmake-package))
