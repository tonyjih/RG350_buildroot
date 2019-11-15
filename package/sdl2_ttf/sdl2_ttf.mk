################################################################################
#
# sdl2_ttf
#
################################################################################

SDL2_TTF_VERSION = 2.0.12
SDL2_TTF_SOURCE = SDL2_ttf-$(SDL2_TTF_VERSION).tar.gz
SDL2_TTF_SITE = http://www.libsdl.org/projects/SDL_ttf/release
SDL2_TTF_INSTALL_STAGING = YES
SDL2_TTF_LICENSE = zlib
SDL2_TTF_LICENSE_FILES = COPYING.txt

SDL2_TTF_DEPENDENCIES = sdl2 freetype

SDL2_TTF_CONF_OPTS = --without-x \
		--with-freetype-prefix=$(STAGING_DIR)/usr \
		--with-sdl-prefix=$(STAGING_DIR)/usr

#SDL2_TTF_MAKE_OPTS = INCLUDES="-I$(STAGING_DIR)/usr/include/SDL2"  LDFLAGS="-L$(STAGING_DIR)/usr/lib"

$(eval $(autotools-package))
