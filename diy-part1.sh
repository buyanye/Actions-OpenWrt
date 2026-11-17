#!/bin/bash

# 1. 从最新开源 MT798x 仓库提取 NMBM 坏块管理驱动与内核补丁
git clone --depth=1 --filter=blob:none --sparse https://github.com/coolsnowwolf/lede.git nmbm_src
if [ ! -d "nmbm_src" ]; then
    git clone --depth=1 -b openwrt-24.10 --filter=blob:none --sparse https://github.com/padavanonly/immortalwrt-mt798x.git nmbm_src
fi

cd nmbm_src
git sparse-checkout set target/linux/mediatek/files-6.12 target/linux/mediatek/patches-6.12 target/linux/mediatek/files-6.6 target/linux/mediatek/patches-6.6
cd ..

# 2. 复制 NMBM 驱动源码与补丁到当前 6.12 编译目录（不覆盖原生 Makefile）
mkdir -p target/linux/mediatek/files-6.12/drivers/mtd
mkdir -p target/linux/mediatek/patches-6.12
for ver in 6.12 6.6; do
    if [ -d "nmbm_src/target/linux/mediatek/files-${ver}/drivers/mtd/nmbm" ]; then
        cp -rf nmbm_src/target/linux/mediatek/files-${ver}/drivers/mtd/nmbm target/linux/mediatek/files-6.12/drivers/mtd/
        cp -f nmbm_src/target/linux/mediatek/patches-${ver}/*nmbm* target/linux/mediatek/patches-6.12/ 2>/dev/null || true
        cp -f nmbm_src/target/linux/mediatek/patches-${ver}/*bmt* target/linux/mediatek/patches-6.12/ 2>/dev/null || true
        break
    fi
done
rm -rf nmbm_src

# 3. 通过标准 999 号补丁安全挂载 NMBM 到内核原生 Makefile 和 Kconfig（避免覆盖原文件导致补丁冲突）
cat << 'EOF' > target/linux/mediatek/patches-6.12/999-mtd-add-nmbm-support.patch
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -42,6 +42,8 @@ config MTD_NAND_CORE
 	tristate
 
+source "drivers/mtd/nmbm/Kconfig"
+
 endmenu
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_MTD_SPI_NOR)	+= spi-nor/
 obj-$(CONFIG_MTD_UBI)		+= ubi/
 
 obj-$(CONFIG_MTD_HYPERBUS)	+= hyperbus/
+obj-$(CONFIG_MTD_NAND_NMBM)	+= nmbm/
EOF

echo "CONFIG_MTD_NAND_MTK_BMT=y" >> target/linux/mediatek/filogic/config-6.12
echo "CONFIG_MTD_NAND_NMBM=y" >> target/linux/mediatek/filogic/config-6.12

# 4. 生成适配 360T7 H大 U-Boot (108M 大分区) 的 6.12 设备树
mkdir -p target/linux/mediatek/dts
cat << 'EOF' > target/linux/mediatek/dts/mt7981b-qihoo-360t7-ubootmod.dts
// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

/dts-v1/;
#include "mt7981b-qihoo-360t7.dts"

/ {
	model = "Qihoo 360T7 (custom U-Boot layout)";
	compatible = "qihoo,360t7-ubootmod", "mediatek,mt7981";
};

&spi0 {
	flash@0 {
		mediatek,nmbm;
		mediatek,bmt-max-ratio = <1>;
		mediatek,bmt-max-reserved-blocks = <64>;

		/delete-node/ partitions;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "BL2";
				reg = <0x0 0x100000>;
				read-only;
			};

			partition@100000 {
				label = "u-boot-env";
				reg = <0x100000 0x80000>;
			};

			partition@180000 {
				label = "Factory";
				reg = <0x180000 0x200000>;
				read-only;
			};

			partition@380000 {
				label = "FIP";
				reg = <0x380000 0x200000>;
				read-only;
			};

			partition@580000 {
				label = "ubi";
				reg = <0x580000 0x6c00000>;
			};
		};
	};
};
EOF
