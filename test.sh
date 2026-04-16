rm -rf openwrt

git clone --depth 1 https://github.com/Lienol/openwrt.git

cd openwrt

cp -f ../.config .config

cat ../feeds.conf >> feeds.conf.default
sort -u feeds.conf.default -o feeds.conf.default

# 2. 将你的自定义脚本/文件拷贝到源码目录
if [ -d "../files" ]; then
    echo "✅ 发现自定义 files 目录，正在同步到源码..."
    cp -rf ../files/ ./
    chmod -R +x files/etc/uci-defaults/
else
    echo "⚠️ 未发现 files 目录，将使用固件默认网络配置"
fi

rm -rf package/luci-app-cloudflarespeedtest

git clone --depth 1 https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest.git package/luci-app-cloudflarespeedtest