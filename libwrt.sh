rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# Modify default IP
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

#修改版本信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt IPQ6000 ZN-M2 (build time: $(date +%Y%m%d))'/g"  package/base-files/files/etc/openwrt_release

# ttyd免登陆
sed -i -r 's#/bin/login#/bin/login -f root#g' feeds/packages/utils/ttyd/files/ttyd.config

#添加AdGuardHome内核
mkdir -p files/usr/bin/AdGuardHome
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

# 提取并打包 kmod 软件源
if [ -f "$BASE_PATH/extract_kmod_repo.sh" ]; then
  chmod +x "$BASE_PATH/extract_kmod_repo.sh"
  "$BASE_PATH/extract_kmod_repo.sh" "$BASE_PATH/$BUILD_DIR"
fi
# 复制 kmod 压缩包到 firmware 目录，便于发布
find "$BASE_PATH/$BUILD_DIR/bin/targets/qualcommax/ipq60xx" -name "kmod-repo-*.tar.gz" -exec cp {} "$FIRMWARE_DIR/" \;

if [[ -d $BASE_PATH/action_build ]]; then
    make clean
fi
