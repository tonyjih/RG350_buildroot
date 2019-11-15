#############################################################
#
# mono
#
#############################################################

#MONO_VERSION := master
#MONO_SITE := git://github.com/mono/mono.git
MONO_VERSION := 3.2.3
MONO_SOURCE := mono-$(MONO_VERSION).tar.bz2
MONO_SITE := http://download.mono-project.com/sources/mono

MONO_DEPENDENCIES := zlib host-mono
HOST_MONO_DEPENDENCIES := host-zlib

MONO_AUTORECONF := YES
HOST_MONO_AUTORECONF := YES

MONO_DEFAULT_CONF_OPTS := --with-tls=pthread \
	--with-mcs-docs=no --with-sgen=no

HOST_MONO_CONF_OPTS := $(MONO_DEFAULT_CONF_OPT) --disable-system-aot \
	--with-static_mono=yes --with-shared_mono=no --disable-shared \
	--disable-mono-debugger --disable-nls --with-profile4=no --with-profile4_5=no

MONO_CONF_OPTS := $(MONO_DEFAULT_CONF_OPT) --disable-mcs-build \
	--enable-minimal=aot --with-sigaltstack=no \
	--with-static_mono=no --disable-static

ifeq ($(BR2_PACKAGE_MONO),y)
# TODO: Decide what DLLs are good to install and those which could be
# made optional
MONO_DLLS := mscorlib.dll System.dll System.Configuration.dll System.Core.dll \
	System.Net.dll System.Web.dll System.Xml.dll System.Drawing.dll
# XXX: What? $(@D) does not work?
MONO_DLLS := $(addprefix $(BUILD_DIR)/host-mono-$(MONO_VERSION)/mcs/class/lib/net_2_0/,$(MONO_DLLS))

define HOST_MONO_INSTALL_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/mono/2.0
	$(INSTALL) -m 0644 $(MONO_DLLS) $(TARGET_DIR)/usr/lib/mono/2.0
endef
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
