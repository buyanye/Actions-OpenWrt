#!/bin/bash

git fetch https://github.com/openwrt/openwrt.git openwrt-23.05 --depth=1
git checkout FETCH_HEAD -- target/linux/mediatek/files-5.15/arch/arm64/boot/dts/mediatek/mt7981b-qihoo-360t7-ubootmod.dts
git checkout FETCH_HEAD -- target/linux/mediatek/filogic/base-files/etc/board.d/02_network
git checkout FETCH_HEAD -- target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh

mkdir -p target/linux/mediatek/files-6.12/arch/arm64/boot/dts/mediatek
sed 's/mt7981b-qihoo-360t7.dts/mt7981-qihoo-360t7.dts/g' target/linux/mediatek/files-5.15/arch/arm64/boot/dts/mediatek/mt7981b-qihoo-360t7-ubootmod.dts > target/linux/mediatek/files-6.12/arch/arm64/boot/dts/mediatek/mt7981b-qihoo-360t7-ubootmod.dts
rm -rf target/linux/mediatek/files-5.15

