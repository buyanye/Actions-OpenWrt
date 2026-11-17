#!/bin/bash

sed -i '/define Device\/qihoo_360t7-ubootmod/,/TARGET_DEVICES += qihoo_360t7-ubootmod/d' target/linux/mediatek/image/filogic.mk

cat << 'EOF' >> target/linux/mediatek/image/filogic.mk

define Device/qihoo_360t7-ubootmod
  DEVICE_VENDOR := Qihoo
  DEVICE_MODEL := 360T7 (custom U-Boot layout)
  DEVICE_DTS := mt7981b-qihoo-360t7-ubootmod
  DEVICE_DTS_DIR := ../dts
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE_SIZE := 112640k
  KERNEL_IN_UBI := 1
  IMAGES += factory.bin
  IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += qihoo_360t7-ubootmod
EOF
