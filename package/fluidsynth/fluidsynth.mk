#############################################################
#
# FluidSynth
#
#############################################################
FLUIDSYNTH_VERSION = 1.1.6
FLUIDSYNTH_SOURCE = fluidsynth-$(FLUIDSYNTH_VERSION).tar.bz2
FLUIDSYNTH_SITE = http://downloads.sourceforge.net/project/fluidsynth/fluidsynth-$(FLUIDSYNTH_VERSION)

FLUIDSYNTH_INSTALL_STAGING = YES

FLUIDSYNTH_CONF_OPTS = -DCMAKE_BUILD_TYPE=Release -Denable-floats=on
FLUIDSYNTH_DEPENDENCIES = libglib2

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FLUIDSYNTH_CONF_OPTS += -Denable-alsa=on
FLUIDSYNTH_DEPENDENCIES += alsa-lib
else
FLUIDSYNTH_CONF_OPTS += -Denable-alsa=off
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
FLUIDSYNTH_CONF_OPTS += -Denable-dbus=on
FLUIDSYNTH_DEPENDENCIES += dbus
else
FLUIDSYNTH_CONF_OPTS += -Denable-dbus=off
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
FLUIDSYNTH_CONF_OPTS += -Denable-libsndfile=on
FLUIDSYNTH_DEPENDENCIES += libsndfile
else
FLUIDSYNTH_CONF_OPTS += -Denable-libsndfile=off
endif

# Note: Disable OSS if we have ALSA.
#       It would be better to have a dedicated OSS switch though.
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FLUIDSYNTH_CONF_OPTS += -DCMAKE_DISABLE_FIND_PACKAGE_OSS=TRUE
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FLUIDSYNTH_CONF_OPTS += -Denable-pulseaudio=on
FLUIDSYNTH_DEPENDENCIES += pulseaudio
else
FLUIDSYNTH_CONF_OPTS += -Denable-pulseaudio=off
endif

# Note: readline is disabled because it is licensed under GPL, while FluidSynth
#       itself is licensed under LGPL; by disabling the readline functionality
#       a wider range of programs can link with FluidSynth.
FLUIDSYNTH_CONF_OPTS += -Denable-readline=off

$(eval $(cmake-package))
