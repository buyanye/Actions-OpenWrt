#!/bin/bash

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

			factory: partition@180000 {
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
