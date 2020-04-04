#############################################################
#
# bar
#
#############################################################
BAR_VERSION = 1.4
BAR_SOURCE = bar-$(BAR_VERSION)-src.tar.bz2
BAR_SITE = http://www.theiling.de/downloads

define BAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/bar $(TARGET_DIR)/usr/bin/bar
endef

$(eval $(generic-package))
