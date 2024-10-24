# 解决 `GLIBC_2.32' not found



```bash
# 1. 下载 glibc-2.32 包
wget http://ftp.gnu.org/gnu/glibc/glibc-2.32.tar.gz

# 2. 解压
tar -zxvf  glibc-2.32.tar.gz && cd glibc-2.32

# 3. 配置
mkdir build && cd build
../configure  --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin

# 4. install
make -j 8 && make install
```

