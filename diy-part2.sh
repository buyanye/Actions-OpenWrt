
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
# ======================================
# 预设 LuCI 简体中文
# ======================================

mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-default-language <<'EOF'
#!/bin/sh

uci set luci.main.lang='zh_cn'
uci commit luci

exit 0
EOF

chmod +x files/etc/uci-defaults/99-default-language

echo "已设置 LuCI 默认简体中文"
