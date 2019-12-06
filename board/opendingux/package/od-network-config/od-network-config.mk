#############################################################
#
# od-network-config
#
#############################################################

OD_NETWORK_CONFIG_SITE = $(BR2_EXTERNAL)/package/od-network-config
OD_NETWORK_CONFIG_SITE_METHOD = local

OD_NETWORK_CONFIG_DEPENDENCIES = python-pygame

ifeq ($(BR2_PACKAGE_GMENU2X),y)
OD_NETWORK_CONFIG_DEPENDENCIES += gmenu2x
define OD_NETWORK_CONFIG_INSTALL_TARGET_GMENU2X
	$(INSTALL) -m 0644 -D $(@D)/gmenu2x $(TARGET_DIR)/usr/share/gmenu2x/sections/settings/60_network
	$(INSTALL) -m 0644 -D $(@D)/icon.png $(TARGET_DIR)/usr/share/gmenu2x/skins/Default/icons/network.png
endef
endif

define OD_NETWORK_CONFIG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/od-network-config.py $(TARGET_DIR)/usr/bin/od-network-config
	$(OD_NETWORK_CONFIG_INSTALL_TARGET_GMENU2X)
endef

$(eval $(generic-package))
