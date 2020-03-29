#############################################################
#
# od-imager
#
#############################################################

OD_IMAGER_VERSION = a95b368b35e979a1cfefb0fb2b81e5ee3bab9064
OD_IMAGER_SITE = $(call github,glebm,imager,$(OD_IMAGER_VERSION))

define HOST_OD_IMAGER_INSTALL_CMDS
	mkdir -p $(BINARIES_DIR)/od-imager
	cp $(@D)/*.* $(BINARIES_DIR)/od-imager
endef

$(eval $(host-generic-package))
