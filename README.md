# openwrt
openwrt编译笔记


手动初始化配置文件
```bash
# 初始化源代码
sh init.sh

# ./scripts/feeds update -a && ./scripts/feeds install -a

make menuconfig
```

## 插件
- https://github.com/stevenjoezhang/luci-app-cloudflarespeedtest
- https://github.com/vernesong/OpenClash