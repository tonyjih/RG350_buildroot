ifeq (,$(call suitable-host-package,lzip,$(LZCAT)))
BR2_LZIP_HOST_DEPENDENCY = host-lzip
LZCAT = $(HOST_DIR)/usr/bin/lzip -d -c
endif
