#############################################################
#
# openal-soft
#
#############################################################

OPENAL_SOFT_VERSION = 1.15.1
OPENAL_SOFT_SOURCE = openal-soft-$(OPENAL_SOFT_VERSION).tar.bz2
OPENAL_SOFT_SITE = http://downloads.sourceforge.net/project/openal-soft/openal-soft
OPENAL_SOFT_INSTALL_STAGING = YES
OPENAL_SOFT_CONF_OPTS = -DEXAMPLES=OFF -DOSS=OFF -DUTILS=OFF

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
OPENAL_SOFT_DEPENDENCIES = alsa-lib
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
OPENAL_SOFT_DEPENDENCIES = pulseaudio
endif

$(eval $(cmake-package))
