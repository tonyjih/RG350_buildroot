#############################################################
#
# Allegro 4
#
#############################################################

ALLEGRO_VERSION = 4.4.2
ALLEGRO_SITE = http://downloads.sourceforge.net/project/alleg/allegro/$(ALLEGRO_VERSION)
ALLEGRO_INSTALL_STAGING = YES
ALLEGRO_DEPENDENCIES += alsa-lib zlib libpng libogg libvorbis

ALLEGRO_CONF_OPTS += -DWANT_LINUX_CONSOLE=ON -DWANT_LINUX_FBCON=ON \
					-DWANT_OSS=OFF -DWANT_LINUX_VGA=OFF \
					-DWANT_DOCS=OFF -DWANT_EXAMPLES=OFF \
					-DWANT_TESTS=OFF -DWANT_TOOLS=OFF \
					-DALLEGRO_USE_CONSTRUCTOR_EXITCODE=1

# Fixup prefix= and exec_prefix= in allegro-config, and remove the
# -Wl,-rpath option.
define ALLEGRO_FIXUP_ALLEGRO_CONFIG
	$(SED) 's%prefix=/usr%prefix=$(STAGING_DIR)/usr%' \
		$(STAGING_DIR)/usr/bin/allegro-config
	$(SED) 's%exec_prefix=/usr%exec_prefix=$(STAGING_DIR)/usr%' \
		$(STAGING_DIR)/usr/bin/allegro-config
	$(SED) 's%-Wl,-rpath,\$${libdir}%%' \
		$(STAGING_DIR)/usr/bin/allegro-config
endef

# allegro-config is installed on the target, while it is compiled for the host,
# so we remove it here
define ALLEGRO_REMOVE_ALLEGRO_CONFIG
	rm -f $(TARGET_DIR)/usr/bin/allegro-config
endef

ALLEGRO_POST_INSTALL_STAGING_HOOKS+=ALLEGRO_FIXUP_ALLEGRO_CONFIG
ALLEGRO_POST_INSTALL_TARGET_HOOKS +=ALLEGRO_REMOVE_ALLEGRO_CONFIG

$(eval $(cmake-package))
