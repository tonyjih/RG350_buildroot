################################################################################
#
# PocketSNES
#
################################################################################
POCKETSNES_VERSION = master
POCKETSNES_SITE = $(call github,soarqin,PocketSNES,$(POCKETSNES_VERSION))
POCKETSNES_AUTORECONF = YES
POCKETSNES_INSTALL_STAGING = YES

CROSS_COMPILE=$(TARGET_CROSS)

define POCKETSNES_BUILD_CMDS
    $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) all
endef

define POCKETSNES_INSTALL_OPK_IMAGES
    cd $(@D) && opk/make_opk.sh
    mkdir -p $(BINARIES_DIR)/opks
    cp -f $(@D)/opk/PocketSNES.opk $(BINARIES_DIR)/opks
endef
POCKETSNES_POST_INSTALL_TARGET_HOOKS += POCKETSNES_INSTALL_OPK_IMAGES


$(eval $(generic-package))
