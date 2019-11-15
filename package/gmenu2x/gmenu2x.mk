################################################################################
#
# gmenu2x
#
################################################################################
GMENU2X_VERSION = master
GMENU2X_SITE = $(call github,tonyjih,gmenu2x-gcw0,$(GMENU2X_VERSION))
GMENU2X_DEPENDENCIES = dejavu libpng sdl sdl_ttf
GMENU2X_AUTORECONF = YES
GMENU2X_CONF_OPTS = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--enable-platform=$(BR2_PACKAGE_GMENU2X_PLATFORM)

ifeq ($(BR2_PACKAGE_LIBOPK),y)
GMENU2X_DEPENDENCIES += libopk
endif

ifeq ($(BR2_PACKAGE_LIBXDGMIME),y)
GMENU2X_DEPENDENCIES += libxdgmime
endif

$(eval $(autotools-package))
