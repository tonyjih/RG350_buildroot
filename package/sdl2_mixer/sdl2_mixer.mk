################################################################################
#
# sdl2_mixer
#
################################################################################

SDL2_MIXER_VERSION = 2.0.0
SDL2_MIXER_SOURCE = SDL2_mixer-$(SDL2_MIXER_VERSION).tar.gz
SDL2_MIXER_SITE = http://www.libsdl.org/projects/SDL_mixer/release
SDL2_MIXER_INSTALL_STAGING = YES
SDL2_MIXER_LICENSE = zlib
SDL2_MIXER_LICENSE_FILES = COPYING.txt

SDL2_MIXER_DEPENDENCIES = sdl2

SDL2_MIXER_CONF_OPTS = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--disable-static

# MIDI:

ifneq ($(BR2_PACKAGE_TIMIDITY_INSTRUMENTS)$(BR2_PACKAGE_FLUIDSYNTH),)
SDL2_MIXER_CONF_OPTS += --enable-music-midi --disable-music-midi-native
else
SDL2_MIXER_CONF_OPTS += --disable-music-midi
endif

ifeq ($(BR2_PACKAGE_TIMIDITY_INSTRUMENTS),y)
SDL2_MIXER_CONF_OPTS += --enable-music-midi-timidity
SDL2_MIXER_DEPENDENCIES += timidity-instruments
else
SDL2_MIXER_CONF_OPTS += --disable-music-midi-timidity
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH),y)
SDL2_MIXER_CONF_OPTS += --enable-music-midi-fluidsynth
SDL2_MIXER_DEPENDENCIES += fluidsynth
else
SDL2_MIXER_CONF_OPTS += --disable-music-midi-fluidsynth
endif

# MOD:

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
SDL2_MIXER_CONF_OPTS += --enable-music-mod --enable-music-mod-modplug
SDL2_MIXER_DEPENDENCIES += libmodplug
else
SDL2_MIXER_CONF_OPTS += --disable-music-mod --disable-music-mod-modplug
endif

# MP3:

ifeq ($(BR2_PACKAGE_SDL2_MIXER_LIBMAD),y)
SDL2_MIXER_CONF_OPTS += --enable-music-mp3 --enable-music-mp3-mad-gpl
SDL2_MIXER_DEPENDENCIES += libmad
else
SDL2_MIXER_CONF_OPTS += --disable-music-mp3 --disable-music-mp3-mad-gpl
endif

# Ogg:

# prefer tremor over libvorbis
ifeq ($(BR2_PACKAGE_TREMOR),y)
SDL2_MIXER_CONF_OPTS += --enable-music-ogg-tremor
SDL2_MIXER_DEPENDENCIES += tremor
else
ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SDL2_MIXER_CONF_OPTS += --enable-music-ogg
SDL2_MIXER_DEPENDENCIES += libvorbis
else
SDL2_MIXER_CONF_OPTS += --disable-music-ogg
endif
endif

# FLAC:

ifeq ($(BR2_PACKAGE_FLAC),y)
SDL2_MIXER_CONF_OPTS += --enable-music-flac
SDL2_MIXER_DEPENDENCIES += flac
else
SDL2_MIXER_CONF_OPTS += --disable-music-flac
endif

$(eval $(autotools-package))
