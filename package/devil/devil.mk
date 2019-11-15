#############################################################
#
# devil
#
#############################################################

DEVIL_VERSION = 8f24648fb88dafcbad28d4e91e9c9b1ad5142069
DEVIL_SITE = https://github.com/DentonW/DevIL.git
DEVIL_SITE_METHOD = git

DEVIL_CONF_OPTS = DevIL
DEVIL_INSTALL_STAGING = YES
DEVIL_AUTORECONF = YES

# Build at least PNG support
DEVIL_DEPENDENCIES += libpng

ifeq ($(BR2_PACKAGE_JPEG),y)
	DEVIL_DEPENDENCIES += jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	DEVIL_DEPENDENCIES += tiff
endif

$(eval $(cmake-package))
