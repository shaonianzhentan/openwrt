#!/bin/bash
set -e  # 遇到错误立即停止，避免编译出问题

# 拉取编译镜像
git clone -b openwrt-25.12 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt

# 切换到源代码目录
cd immortalwrt

# 使用自定义配置
cp -f ../config/.config .config

# 2. 将你的自定义脚本/文件拷贝到源码目录
if [ -d "../files" ]; then
    echo "✅ 发现自定义 files 目录，正在同步到源码..."
    cp -rf ../files/ ./
    chmod -R +x files/etc/uci-defaults/
else
    echo "⚠️ 未发现 files 目录，将使用固件默认网络配置"
fi

# 检查项目根目录下是否存在自定义的 feeds.conf
if [ -f "../feeds.conf" ]; then
    echo "合并自定义 Feeds 到 feeds.conf.default..."
    # 换行追加，确保格式正确
    echo "" >> feeds.conf.default
    cat ../feeds.conf >> feeds.conf.default
    
    # 再次去重（可选但推荐）
    sort -u feeds.conf.default -o feeds.conf.default
    echo "✅ Feeds 合并完成"
else
    echo "⚠️ 未发现自定义 feeds.conf，跳过合并"
fi

echo -e "\n🎉 操作完成！当前 feeds.conf.default 内容："
cat feeds.conf.default

# 安装cloudflare优选IP
git clone --depth 1 https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest.git package/luci-app-cloudflarespeedtest

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