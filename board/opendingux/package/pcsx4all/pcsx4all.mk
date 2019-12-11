################################################################################
#
# pcsx4all
#
################################################################################
PCSX4ALL_VERSION = master
PCSX4ALL_SITE = $(call github,tonyjih,RG350_pcsx4all,$(PCSX4ALL_VERSION))
PCSX4ALL_AUTORECONF = YES
PCSX4ALL_INSTALL_STAGING = YES
PCSX4ALL_DEPENDENCIES = sdl sdl_mixer sdl_image

PCSX4ALL_MAKE_OPTS = \
	MD="mkdir -p" \
    CC="$(TARGET_CC)" \
    CXX="$(TARGET_CXX)" \
    LD="$(TARGET_CXX)" \

define PCSX4ALL_BUILD_CMDS
    $(MAKE) $(PCSX4ALL_MAKE_OPTS) -C $(@D) \
        -f Makefile.${BR2_PACKAGE_PCSX4ALL_PLATFORM}
endef

define PCSX4ALL_INSTALL_OPK_IMAGES
    (   cd $(@D) ; \
        ./make_opk.sh ; \
        mkdir -p $(BINARIES_DIR)/opks ; \
        cp -vf pcsx4all.opk $(BINARIES_DIR)/opks )
endef
PCSX4ALL_POST_INSTALL_TARGET_HOOKS += PCSX4ALL_INSTALL_OPK_IMAGES

$(eval $(generic-package))
