#!/bin/bash
set -e  # 遇到错误立即停止，避免编译出问题

# 拉取编译镜像
git clone -b openwrt-25.12 --single-branch --filter=blob:none https://github.com/openwrt/openwrt

# 切换到源代码目录
cd openwrt

# 使用自定义配置
cp -f ../config/openwrt.config .config

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

# 编译
echo "✅ 开始编译"
make -j$(nproc) || make -j1 V=s
echo "======================="
echo "Space usage:"
echo "======================="
df -h
echo "======================="
du -h --max-depth=1 ./ --exclude=build_dir --exclude=bin
du -h --max-depth=1 ./build_dir
du -h --max-depth=1 ./bin