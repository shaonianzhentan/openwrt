#!/bin/bash
set -e  # 遇到错误立即停止，避免编译出问题

# 拉取编译镜像
git clone https://github.com/Lienol/openwrt.git

# 使用自定义配置
cp -f .config openwrt/.config


cd openwrt

# 定义要添加的源内容
FEED_CONTENT1="src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main"
FEED_CONTENT2="src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main"

# 检查并追加第一条源
if ! grep -qxF "$FEED_CONTENT1" feeds.conf.default; then
    echo "$FEED_CONTENT1" >> feeds.conf.default
    echo "✅ 已添加：passwall_packages 源"
else
    echo "ℹ️ 已存在：passwall_packages 源，跳过添加"
fi

# 检查并追加第二条源
if ! grep -qxF "$FEED_CONTENT2" feeds.conf.default; then
    echo "$FEED_CONTENT2" >> feeds.conf.default
    echo "✅ 已添加：passwall_luci 源"
else
    echo "ℹ️ 已存在：passwall_luci 源，跳过添加"
fi

echo -e "\n🎉 操作完成！当前 feeds.conf.default 内容："
cat feeds.conf.default

# 安装cloudflare优选IP
git clone https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest.git package/luci-app-cloudflarespeedtest

# 更新
./scripts/feeds update -a
./scripts/feeds install -a

# 初始化配置
make defconfig

# Download packages
make download -j16

# 编译
make -j$(nproc) || make -j1 V=s
echo "======================="
echo "Space usage:"
echo "======================="
df -h
echo "======================="
du -h --max-depth=1 ./ --exclude=build_dir --exclude=bin
du -h --max-depth=1 ./build_dir
du -h --max-depth=1 ./bin