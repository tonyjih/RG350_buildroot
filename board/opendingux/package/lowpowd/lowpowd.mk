LOWPOWD_SITE = $(BR2_EXTERNAL)/package/lowpowd
LOWPOWD_SITE_METHOD = local

define LOWPOWD_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(@D)/lowpowd.c -o $(@D)/lowpowd
endef

define LOWPOWD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/lowpowd $(TARGET_DIR)/usr/sbin/lowpowd
	$(INSTALL) -m 0755 -D $(@D)/S99lowpowd.sh $(TARGET_DIR)/etc/init.d/S99lowpowd.sh
endef

$(eval $(generic-package))
