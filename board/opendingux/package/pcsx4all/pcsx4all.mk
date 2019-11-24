################################################################################
#
# pcsx4all
#
################################################################################
PCSX4ALL_VERSION = 765c2a9
PCSX4ALL_SITE = $(call github,gameblabla,pcsx4all,$(PCSX4ALL_VERSION))
PCSX4ALL_AUTORECONF = YES
PCSX4ALL_INSTALL_STAGING = YES

PCSX4ALL_MAKE_OPTS = \
	MD="mkdir -p" \
    CC="$(TARGET_CC)" \
    CXX="$(TARGET_CXX)" \
    LD="$(TARGET_CXX)" \

# BEGIN hacks for older buildroot
# Remove -flto
# Remove -mframe-header-opt and replace with -std=c99
# Add -lpthread -lrt
define PCSX4ALL_PREPARE_BUILD
    (   cd $(@D) ; \
		sed -i 's/-flto//g' Makefile.gcw0 ; \
        sed -i 's/-mframe-header-opt/-std=c99/g' Makefile.gcw0 ; \
        sed -i 's/LDFLAGS = /LDFLAGS = -lpthread -lrt /g' Makefile.gcw0)
endef
PCSX4ALL_PRE_CONFIGURE_HOOKS += PCSX4ALL_PREPARE_BUILD
# END hacks

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
