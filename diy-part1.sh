
#!/bin/bash
set -e

# 360T7 官方 OpenWrt 编译
# 保留官方设备树、分区和 NMBM
# 集成集客 AC 2.2

echo "======================================"
echo "360T7 官方固件编译配置"
echo "使用官方 qihoo_360t7 设备定义"
echo "集成集客 AC 2.2"
echo "======================================"

echo "正在下载集客 AC 2.2 源码..."

git clone --depth=1 \
  https://github.com/openwrt-fork/openwrt-gecoosac.git \
  package/openwrt-gecoosac

echo "集客 AC 2.2 源码集成完成"
