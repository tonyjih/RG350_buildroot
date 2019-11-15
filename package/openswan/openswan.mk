################################################################################
#
# openswan
#
################################################################################

OPENSWAN_VERSION = 2.6.41
OPENSWAN_SITE = http://download.openswan.org/openswan
OPENSWAN_LICENSE = GPLv2+, BSD-3c
OPENSWAN_LICENSE_FILES = COPYING LICENSE

OPENSWAN_DEPENDENCIES = host-bison host-flex gmp iproute2
OPENSWAN_MAKE_OPTS = ARCH=$(BR2_ARCH) CC="$(TARGET_CC)" \
	USERCOMPILE="$(TARGET_CFLAGS) -fPIE" INC_USRLOCAL=/usr \
	USE_KLIPS=false USE_MAST=false USE_NM=false

ifeq ($(BR2_PACKAGE_LIBCURL),y)
	OPENSWAN_DEPENDENCIES += libcurl
	OPENSWAN_MAKE_OPTS += USE_LIBCURL=true
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	OPENSWAN_DEPENDENCIES += openssl
	OPENSWAN_MAKE_OPTS += HAVE_OPENSSL=true
ifeq ($(BR2_PACKAGE_OCF_LINUX),y)
	OPENSWAN_MAKE_OPTS += HAVE_OCF=true
endif
endif

define OPENSWAN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(OPENSWAN_MAKE_OPT) programs
endef

define OPENSWAN_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(OPENSWAN_MAKE_OPT) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
