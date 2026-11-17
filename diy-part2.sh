
#!/bin/bash
set -e

# 360T7 官方 OpenWrt 编译
# 不修改官方 filogic.mk
# 不添加 ubootmod 设备
# 不修改官方设备树
# 不修改内核 NMBM 配置
# 保留官方 qihoo_360t7 设备定义

echo "======================================"
echo "360T7 diy-part2"
echo "使用官方设备定义"
echo "跳过第三方设备树和分区修改"
echo "======================================"
