################################################################################
#
# Ghouls 'n Ghosts Remix - GNG
#
################################################################################
GNG_VERSION = e5054399
GNG_SITE = $(call github,podulator,ggr_056,$(GNG_VERSION))
GNG_DEPENDENCIES = allegro

GNG_MAKE_OPTS = \
    MD="mkdir -p" \
    CROSS_COMPILE="$(TARGET_CROSS)"

define GNG_BUILD_CMDS
    $(MAKE) $(GNG_MAKE_OPTS) -C $(@D) all \
        -f Makefile.rg-350
endef

define GNG_INSTALL_OPK_IMAGES
    (   cd $(@D) ; \
        ./make_opk.sh ; \
        mkdir -p $(BINARIES_DIR)/opks ; \
        cp -vf ./*.opk $(BINARIES_DIR)/opks )
endef
GNG_POST_INSTALL_TARGET_HOOKS += GNG_INSTALL_OPK_IMAGES

$(eval $(generic-package))
