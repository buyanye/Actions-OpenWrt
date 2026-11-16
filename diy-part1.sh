#!/bin/bash

git fetch https://github.com/openwrt/openwrt.git openwrt-23.05 --depth=1
git checkout FETCH_HEAD -- target/linux/mediatek/dts/mt7981b-qihoo-360t7-ubootmod.dts
git checkout FETCH_HEAD -- target/linux/mediatek/filogic/base-files/etc/board.d/02_network
git checkout FETCH_HEAD -- target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh
git checkout FETCH_HEAD -- target/linux/mediatek/files-5.15/drivers/mtd/nmbm 2>/dev/null || true

