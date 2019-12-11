#############################################################
#
# libshake.so.1 (versions below 0.3.1)
# for backwards compatibility with older OPKs.
#
#############################################################
LIBSHAKE1_VERSION = 32174c6
LIBSHAKE1_SITE = $(call github,zear,libShake,$(LIBSHAKE1_VERSION))
LIBSHAKE1_LICENSE = MIT
LIBSHAKE1_LICENSE_FILES = LICENSE.txt
LIBSHAKE1_INSTALL_STAGING = YES

LIBSHAKE1_MAKE_ENV = PREFIX=/usr BACKEND=LINUX AR="$(TARGET_AR)" CC="$(TARGET_CC)" LD="$(TARGET_CC)" STRIP="$(TARGET_STRIP)"

define LIBSHAKE1_BUILD_CMDS
	$(LIBSHAKE1_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBSHAKE1_INSTALL_STAGING_CMDS
	$(LIBSHAKE1_MAKE_ENV) DESTDIR="$(STAGING_DIR)" $(MAKE) -C $(@D) install
endef

define LIBSHAKE1_INSTALL_TARGET_CMDS
	$(LIBSHAKE1_MAKE_ENV) DESTDIR="$(TARGET_DIR)" $(MAKE) -C $(@D) install-lib

	# install-lib above will symlink libshake.so to libshake.so.1
	# restore the symlink to point to libshake.so.2 if it exists:
	if [[ -f "$(TARGET_DIR)/usr/lib/libshake.so.2" ]]; then \
	  ln -sf "$(TARGET_DIR)/usr/lib/libshake.so.2" "$(TARGET_DIR)/usr/lib/libshake.so"; \
	fi
endef

$(eval $(generic-package))
