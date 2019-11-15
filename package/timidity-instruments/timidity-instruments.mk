#############################################################
#
# Timidity instruments
#
#############################################################
TIMIDITY_INSTRUMENTS_VERSION:=unversioned
TIMIDITY_INSTRUMENTS_SOURCE:=timidity.tar.gz
TIMIDITY_INSTRUMENTS_SITE:=http://www.libsdl.org/projects/SDL_mixer/timidity

define TIMIDITY_INSTRUMENTS_INSTALL_TARGET_CMDS
	install -d -m 755 $(TARGET_DIR)/usr/share/midi/instruments
	install -m 644 $(@D)/instruments/* $(TARGET_DIR)/usr/share/midi/instruments
	install -m 644 $(@D)/timidity.cfg $(TARGET_DIR)/etc
endef

$(eval $(generic-package))
