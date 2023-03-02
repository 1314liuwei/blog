# Debian 编译安装 qBittorent

```bash
# 下载
wget https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-4.5.0.tar.gz

# 解压
tar xf release-4.5.0.tar.gz

cd release-4.5.0
# 编译配置
./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++14
```



缺失依赖：

```
Q: configure: error: Could not find pkg-config
A: apt install pkg-config

Q: configure: error: Could not find qmake

```

