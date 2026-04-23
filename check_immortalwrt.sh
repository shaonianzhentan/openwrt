#!/bin/bash
set -e  # 遇到错误立即停止，避免编译出问题

# 拉取编译镜像
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt

# 切换到源代码目录
cd immortalwrt

# 使用自定义配置
cp -f ../config/immortalwrt.config .config

# 2. 将你的自定义脚本/文件拷贝到源码目录
if [ -d "../files" ]; then
    echo "✅ 发现自定义 files 目录，正在同步到源码..."
    cp -rf ../files/ ./
    chmod -R +x files/etc/uci-defaults/
else
    echo "⚠️ 未发现 files 目录，将使用固件默认网络配置"
fi

# 安装cloudflare优选IP
git clone --depth 1 https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest.git package/luci-app-cloudflarespeedtest

# 更新
./scripts/feeds update -a
./scripts/feeds install -a

# Download packages
make download -j16