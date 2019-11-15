################################################################################
#
# lightning
#
################################################################################

LIGHTNING_VERSION = 2.0.4
LIGHTNING_SITE = http://ftp.gnu.org/gnu/lightning/
LIGHTNING_LICENSE = GPLv3
LIGHTNING_LICENSE_FILES = COPYING
LIGHTNING_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_BINUTILS),y)
LIGHTNING_DEPENDENCIES += binutils
LIGHTNING_CONF_OPTS += --enable-disassembler
endif

$(eval $(autotools-package))
