################################################################################
#
# apitrace
#
################################################################################

APITRACE_VERSION = 5.0
APITRACE_SITE = $(call github,apitrace,apitrace,$(APITRACE_VERSION))
APITRACE_LICENSE = MIT
APITRACE_LICENSE_FILES = LICENSE

APITRACE_DEPENDENCIES = popt binutils host-python

# Gui was never tested, so we prefer to explicitly disable it
APITRACE_CONF_OPTS += -DENABLE_GUI=false

APITRACE_CONF_OPTS = -DPYTHON_EXECUTABLE:STRING="$(HOST_DIR)/usr/bin/python"

ifneq ($(BR2_PACKAGE_XLIB_LIBX11),y)
APITRACE_CONF_OPTS += -DCMAKE_C_FLAGS:STRING="$(TARGET_CFLAGS) -DMESA_EGL_NO_X11_HEADERS"
APITRACE_CONF_OPTS += -DCMAKE_CXX_FLAGS:STRING="$(TARGET_CFLAGS) -DMESA_EGL_NO_X11_HEADERS"
endif

$(eval $(cmake-package))
