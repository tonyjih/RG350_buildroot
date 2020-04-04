#############################################################
#
# physfs
#
#############################################################

PHYSFS_VERSION = 2.0.3
PHYSFS_SOURCE = physfs-$(PHYSFS_VERSION).tar.bz2
PHYSFS_SITE = https://icculus.org/physfs/downloads

PHYSFS_INSTALL_STAGING = YES
PHYSFS_DEPENDENCIES = zlib

$(eval $(cmake-package))
