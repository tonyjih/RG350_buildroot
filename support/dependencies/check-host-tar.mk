TAR ?= tar

ifeq (,$(call suitable-host-package,tar,$(TAR)))
TAR = $(HOST_DIR)/usr/bin/tar
BR2_TAR_HOST_DEPENDENCY = host-tar
endif
