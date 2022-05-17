LOCAL_PATH := $(call my-dir)

FLASH_IMAGE_TARGET ?= $(PRODUCT_OUT)/recovery.tar
SPRDSIGN := $(LOCAL_PATH)/signimage/prebuilt/bin/sprd_sign
SPRDSIGNCFG := $(LOCAL_PATH)/signimage/config

ifdef TARGET_PREBUILT_DTB
	BOARD_MKBOOTIMG_ARGS += --dt $(TARGET_PREBUILT_DTB)
endif

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(recovery_kernel) $(recovery_ramdisk)
	@echo -e ${CL_GRN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(recovery_ramdisk)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(hide) $(SPRDSIGN) $(INSTALLED_RECOVERYIMAGE_TARGET) $(SPRDSIGNCFG)
	$(hide) tar -C $(PRODUCT_OUT) -H ustar -c recovery.img > $(FLASH_IMAGE_TARGET)
	@echo -e ${CL_CYN}"Made Odin flashable recovery tar: ${FLASH_IMAGE_TARGET}"${CL_RST}
