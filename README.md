# openwrt
openwrt编译笔记


编译配置文件
```bash
git clone https://github.com/Lienol/openwrt.git

cd openwrt

git clone https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest.git package/luci-app-cloudflarespeedtest

src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main

./scripts/feeds update -a && ./scripts/feeds install -a

make menuconfig
```