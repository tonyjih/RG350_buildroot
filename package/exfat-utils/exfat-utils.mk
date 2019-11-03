################################################################################
#
# exfat-utils
#
################################################################################

EXFAT_UTILS_VERSION = 1.3.0
EXFAT_UTILS_SITE = $(call github,relan,exfat,v$(EXFAT_VERSION))
EXFAT_UTILS_SOURCE = exfat-utils-$(EXFAT_VERSION).tar.gz
EXFAT_UTILS_LICENSE = GPLv3+
EXFAT_UTILS_LICENSE_FILES = COPYING
EXFAT_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
