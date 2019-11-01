################################################################################
#
# gmenunx
#
################################################################################
GMENUNX_VERSION = b37d8954d9e8d
GMENUNX_SITE = $(call github,podulator,gmenunx,$(GMENUNX_VERSION))
GMENUNX_DEPENDENCIES = dejavu libpng sdl sdl_ttf sdl_gfx
GMENUNX_INSTALL_TARGET = YES

GMENUNX_MAKE_OPTS = \
    MD="mkdir -p" \
    CROSS_COMPILE="$(TARGET_CROSS)"
    
ifeq ($(BR2_PACKAGE_LIBOPK),y)
GMENUNX_DEPENDENCIES += libopk
endif

ifeq ($(BR2_PACKAGE_LIBXDGMIME),y)
GMENUNX_DEPENDENCIES += libxdgmime
endif

define GMENUNX_BUILD_CMDS
    $(MAKE) $(GMENUNX_MAKE_OPTS) -C $(@D) all dist \
        -f Makefile.${BR2_PACKAGE_GMENUNX_PLATFORM}
endef

define GMENUNX_INSTALL_GMENUNX
    (   cd $(@D) ; \
	if [ -D $(TARGET_DIR)/usr/share/gmenunx ]; then \
		echo "removing old directory"; \
		rm -rf $(TARGET_DIR)/usr/share/gmenunx ; \
	fi ; \
	cp -r dist/$(BR2_PACKAGE_GMENUNX_PLATFORM)/gmenunx $(TARGET_DIR)/usr/share/ ; \
	if [ -L $(TARGET_DIR)/usr/bin/gmenunx ]; then \
		echo "removing old link"; \
		rm -rf $(TARGET_DIR)/usr/bin/gmenunx ; \
	fi ; \
	ln -rs $(TARGET_DIR)/usr/share/gmenunx/gmenunx $(TARGET_DIR)/usr/bin/gmenunx ; )
endef
GMENUNX_POST_INSTALL_TARGET_HOOKS += GMENUNX_INSTALL_GMENUNX


$(eval $(generic-package))
