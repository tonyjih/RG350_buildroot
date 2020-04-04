UNLOCKVT_SITE = $(BR2_EXTERNAL)/package/unlockvt
UNLOCKVT_SITE_METHOD = local

define UNLOCKVT_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(@D)/unlockvt.c -o $(@D)/unlockvt
endef

define UNLOCKVT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/unlockvt $(TARGET_DIR)/usr/sbin/unlockvt
endef

$(eval $(generic-package))
