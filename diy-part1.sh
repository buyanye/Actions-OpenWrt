
#!/bin/bash
set -e

# 360T7 官方 OpenWrt 编译
# 使用官方设备树和官方分区定义
# 不引入第三方 NMBM 补丁
# 不修改 U-Boot、FIP、Preloader
# 不覆盖 360T7 DTS

echo "======================================"
echo "360T7 官方固件编译配置"
echo "使用官方 qihoo_360t7 设备定义"
echo "跳过第三方 NMBM 和 DTS 修改"
echo "======================================"
# ======================================
# 集成集客 AC 2.2
# ======================================

echo "正在下载集客 AC 2.2 源码..."

git clone --depth=1 \
  https://github.com/lwb1978/openwrt-gecoosac \
  package/openwrt-gecoosac

echo "集客 AC 2.2 源码集成完成"
