################################################################################
#
# sdl_mixer
#
################################################################################

SDL_MIXER_VERSION = 1.2.12
SDL_MIXER_SOURCE = SDL_mixer-$(SDL_MIXER_VERSION).tar.gz
SDL_MIXER_SITE = http://www.libsdl.org/projects/SDL_mixer/release
SDL_MIXER_LICENSE = zlib
SDL_MIXER_LICENSE_FILES = COPYING

SDL_MIXER_INSTALL_STAGING = YES
SDL_MIXER_DEPENDENCIES = sdl timidity-instruments
SDL_MIXER_CONF_OPTS = \
	--without-x \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--disable-music-mod \
	--disable-music-mp3 \
	--disable-music-flac # configure script fails when cross compiling

ifeq ($(BR2_PACKAGE_TIMIDITY_INSTRUMENTS),y)
SDL_MIXER_CONF_OPTS += \
	--enable-music-midi \
	--enable-music-timidity-midi \
	--disable-music-native-midi \
	--disable-music-native-midi-gpl
else
SDL_MIXER_CONF_OPTS += --disable-music-midi
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
SDL_MIXER_CONF_OPTS += \
	--enable-music-mod-modplug
SDL_MIXER_DEPENDENCIES += libmodplug
else
SDL_MIXER_CONF_OPTS += --disable-music-mod-modplug
endif

ifeq ($(BR2_PACKAGE_SDL_MIXER_LIBMAD),y)
SDL_MIXER_CONF_OPTS += --enable-music-mp3-mad-gpl
SDL_MIXER_DEPENDENCIES += libmad
else
SDL_MIXER_CONF_OPTS += --disable-music-mp3-mad-gpl
endif

# prefer tremor over libvorbis
ifeq ($(BR2_PACKAGE_TREMOR),y)
SDL_MIXER_CONF_OPTS += --enable-music-ogg-tremor
SDL_MIXER_DEPENDENCIES += tremor
else
ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SDL_MIXER_CONF_OPTS += --enable-music-ogg
SDL_MIXER_DEPENDENCIES += libvorbis
else
SDL_MIXER_CONF_OPTS += --disable-music-ogg
endif
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH),y)
SDL_MIXER_CONF_OPTS += \
	--enable-music-fluidsynth-midi \
	--enable-music-fluidsynth-shared
SDL_MIXER_DEPENDENCIES += fluidsynth
else
SDL_MIXER_CONF_OPTS += --disable-music-fluidsynth-midi
endif

$(eval $(autotools-package))
