################################################################################
#
# exfat
#
################################################################################

EXFAT_VERSION = 1.3.0
EXFAT_SITE = $(call github,relan,exfat,v$(EXFAT_VERSION))
EXFAT_SOURCE = fuse-exfat-$(EXFAT_VERSION).tar.gz
EXFAT_DEPENDENCIES = libfuse
EXFAT_LICENSE = GPLv3+
EXFAT_LICENSE_FILES = COPYING
EXFAT_AUTORECONF = YES

$(eval $(autotools-package))
