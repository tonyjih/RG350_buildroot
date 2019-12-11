################################################################################
#
# utf8cpp
#
################################################################################

UTF8CPP_VERSION = c3f9261eb8e793fa6c6a62309d3a3942ee03486a
UTF8CPP_SITE = $(call github,nemtrif,utfcpp,$(UTF8CPP_VERSION))
UTF8CPP_INSTALL_STAGING = YES
UTF8CPP_INSTALL_TARGET = NO

UTF8CPP_CONF_OPT += -DUTF8_TESTS=OFF -DUTF8_SAMPLES=OFF

$(eval $(cmake-package))
