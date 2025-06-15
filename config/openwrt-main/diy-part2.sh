#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Set default hostname and timezone to China
sed -i "s/hostname='OpenWrt'/hostname='OpenWrt-China'/g" package/base-files/files/bin/config_generate
sed -i "s/timezone='UTC'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a\ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# Optional: use domestic NTP servers
sed -i "s/0.openwrt.pool.ntp.org/ntp.aliyun.com/g" package/base-files/files/bin/config_generate
sed -i "s/1.openwrt.pool.ntp.org/cn.ntp.org.cn/g" package/base-files/files/bin/config_generate
sed -i "s/2.openwrt.pool.ntp.org/time1.cloud.tencent.com/g" package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic

# Add luci-app-openclash
rm -rf package/luci-app-openclash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# Replace luci-theme-argon
rm -rf package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# 添加 FTP 支持（选一个）
# vsftpd:
git clone https://github.com/immortalwrt/luci.git temp-luci
cp -rf temp-luci/applications/luci-app-vsftpd package/luci-app-vsftpd
rm -rf temp-luci

# AdGuardHome（1.8-11）
rm -rf package/luci-app-adguardhome
git clone https://github.com/kenzok8/luci-app-adguardhome.git package/luci-app-adguardhome

# msd_lite（可能在 openwrt-passwall 仓库中）
rm -rf package/luci-app-msd_lite
git clone https://github.com/kenzok8/small-package.git
cp -r small-package/luci-app-msd_lite package/
rm -rf small-package

# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------


