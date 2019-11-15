#############################################################
#
# libgdiplus
#
#############################################################
LIBGDIPLUS_VERSION := master
LIBGDIPLUS_SITE := git://github.com/pcercuei/libgdiplus.git
LIBGDIPLUS_DEPENDENCIES := cairo freetype
LIBGDIPLUS_INSTALL_STAGING := YES
LIBGDIPLUS_AUTORECONF := YES
LIBGDIPLUS_CONF_OPTS := --disable-tests

$(eval $(autotools-package))
