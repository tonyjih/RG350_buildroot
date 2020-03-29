#############################################################
#
# mininit
#
#############################################################

MININIT_VERSION = 429a1d019a9a1fe5d3662567cd958a54d963e0ff
MININIT_SITE = $(call github,OpenDingux,mininit,$(MININIT_VERSION))

define MININIT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define MININIT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/mininit-syspart $(BINARIES_DIR)/mininit-syspart
endef

$(eval $(generic-package))
