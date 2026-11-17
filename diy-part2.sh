#!/bin/bash

sed -i '/define Device\/qihoo_360t7-ubootmod/,/TARGET_DEVICES += qihoo_360t7-ubootmod/d' target/linux/mediatek/image/filogic.mk

cat << 'EOF' >> target/linux/mediatek/image/filogic.mk

define Device/qihoo_360t7-ubootmod
  DEVICE_VENDOR := Qihoo
  DEVICE_MODEL := 360T7 (custom U-Boot layout)
  DEVICE_DTS := mt7981b-qihoo-360t7-ubootmod
  DEVICE_DTS_DIR := ../dts
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
  KERNEL_LOADADDR := 0x44000000
  KERNEL := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_INITRAMFS := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initramfs
  IMAGES := sysupgrade.itb
  IMAGE_SIZE := 112640k
  IMAGE/sysupgrade.itb := append-kernel | pad-rootfs | append-metadata
endef
TARGET_DEVICES += qihoo_360t7-ubootmod
EOF

if ! grep -q "nmbm/Kconfig" target/linux/mediatek/Makefile; then
cat << 'EOF' >> target/linux/mediatek/Makefile

define Kernel/Prepare/Post
	grep -q "nmbm/Kconfig" $(LINUX_DIR)/drivers/mtd/Kconfig || sed -i 's|^endmenu|source "drivers/mtd/nmbm/Kconfig"\nendmenu|' $(LINUX_DIR)/drivers/mtd/Kconfig
	grep -q "nmbm/" $(LINUX_DIR)/drivers/mtd/Makefile || echo 'obj-$$(CONFIG_MTD_NAND_NMBM) += nmbm/' >> $(LINUX_DIR)/drivers/mtd/Makefile
endef
EOF
fi
