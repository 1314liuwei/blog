# rsylog 保存到 sqlite

## 一、编译 rsylog

由于系统自带的 rsylog 默认是没有启用保存到数据库的模块的，因此我们需要手动编译安装 rsylog：

```bash
# 1. 下载 rsylog 源码
wget https://www.rsyslog.com/download/files/download/rsyslog/rsyslog-8.2208.0.tar.gz

# 2. 解压
tar xvf rsyslog-8.2208.0.tar.gz

# 3. 配置
cd rsyslog-8.2208.0/
./configure --enable-libdbi --enable-mysql

# 4. 编译安装
make && make install
```

编译过程中可能会遇到环境缺失错误，下面列举一下自己编译过程中遇到的错误：

- ```bash
  error: 
  configure: error: The pkg-config script could not be found or is too old.  Make sure it
  is in your PATH or set the PKG_CONFIG environment variable to the full
  path to pkg-config.
  
  solution:
  apt install pkg-config
  ```

- ```bash
  error:
  configure: error: Package requirements (libestr >= 0.1.9) were not met:
  No package 'libestr' found
  
  solution:
  apt install libestr-dev
  ```

- ```bash
  error:
  configure: error: Package requirements (libfastjson >= 0.99.8) were not met:
  No package 'libfastjson' found
  
  solution:
  apt install libfastjson-dev
  ```

- ```bash
  error:
  configure: error: libdbi is missing
  
  solution:
  apt install libdbi-dev
  ```

- ```bash
  error:
  configure: error: Package requirements (uuid) were not met:
  No package 'uuid' found
  
  solution:
  apt install uuid-dev
  ```

- ```bash
  error:
  configure: error: libgcrypt-config not found in PATH
  
  solution:
  apt install libgcrypt20-dev
  ```

- ```bash
  error:
  configure: error: Package requirements (libcurl) were not met:
  No package 'libcurl' found
  
  solution:
  apt install libcurl4-openssl-dev
  ```

- ```bash
  error:
  configure: error: zlib library and headers not found
  
  solution:
  apt install zlib1g-dev
  ```
  
- ```bash
  error:
  config.status: error: Something went wrong bootstrapping makefile fragments
      for automatic dependency tracking.  Try re-running configure with the
      '--disable-dependency-tracking' option to at least be able to build
      the package (albeit without support for automatic dependency tracking).
      
  solution:
  apt install make
  ```
  
- ```
  
  apt-get install libmysqlclient-dev
  ```
  
  

```
apt install libdbd-sqlite3
```

