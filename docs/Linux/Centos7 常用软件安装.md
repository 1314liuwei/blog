# Centos 常用软件安装

## 一、Development tools 

```bash
yum grouplist | more  						# 查看有那些组安装包可用
yum grouplist | grep Development			# 搜索和 Development 相关的
yum groupinstall -y "Development Tools" 	# 安装 Development Tools 工具包
```

## 二、yum-utils 

```bash
yum -y install yum-utils
```

## 三、Docker 

### 安装

#### 使用官方脚本安装

```bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 换源

编辑 `/etc/docker/daemon.json`文件，写入国内源：

```json
{
  "registry-mirrors" : [
    "http://ovfftd6p.mirror.aliyuncs.com",
    "http://registry.docker-cn.com",
    "http://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com"
  ],
  "insecure-registries" : [
    "registry.docker-cn.com",
    "docker.mirrors.ustc.edu.cn"
  ],
  "debug" : true,
  "experimental" : true
}
```

重启 docker：

```bash
service docker restart
```

查看换源是否成功：

```bash
docker info

output:
...
 Registry Mirrors:
  http://ovfftd6p.mirror.aliyuncs.com/
  http://registry.docker-cn.com/
  http://docker.mirrors.ustc.edu.cn/
  http://hub-mirror.c.163.com/
 ...
```

### 配置 HTTP/HTTPS 网络代理

使用Docker的过程中，因为网络原因，通常需要使用 HTTP/HTTPS 代理来加速镜像拉取、构建和使用。下面是常见的三种场景。

#### 为 dockerd 设置网络代理

"docker pull" 命令是由 dockerd 守护进程执行。而 dockerd 守护进程是由 systemd 管理。因此，如果需要在执行 "docker pull" 命令时使用 HTTP/HTTPS 代理，需要通过 systemd 配置。

为 dockerd 创建配置文件夹：

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
```

为 dockerd 创建 HTTP/HTTPS 网络代理的配置文件，文件路径是 `/etc/systemd/system/docker.service.d/http-proxy.conf `，并在该文件中添加相关环境变量。

```bash
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:8080/"
Environment="HTTPS_PROXY=http://proxy.example.com:8080/"
Environment="NO_PROXY=localhost,127.0.0.1,.example.com"
```

刷新配置并重启 docker 服务：

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### 为 docker 容器设置网络代理

在容器运行阶段，如果需要使用 HTTP/HTTPS 代理，可以通过更改 docker 客户端配置，或者指定环境变量的方式。

更改 docker 客户端配置：创建或更改 `~/.docker/config.json`，并在该文件中添加下面配置：

```json
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://proxy.example.com:8080/",
     "httpsProxy": "http://proxy.example.com:8080/",
     "noProxy": "localhost,127.0.0.1,.example.com"
   }
 }
}
```

指定环境变量：运行 "docker run" 命令时，指定相关环境变量。

| 环境变量    |                  docker run 示例                   |
| :---------- | :------------------------------------------------: |
| HTTP_PROXY  | --env HTTP_PROXY="http://proxy.example.com:8080/"  |
| HTTPS_PROXY | --env HTTPS_PROXY="http://proxy.example.com:8080/" |
| NO_PROXY    | --env NO_PROXY="localhost,127.0.0.1,.example.com"  |

#### 为 docker build 过程设置网络代理

在容器构建阶段，如果需要使用 HTTP/HTTPS 代理，可以通过指定 "docker build" 的环境变量，或者在 Dockerfile 中指定环境变量的方式。

使用 "--build-arg" 指定 "docker build" 的相关环境变量:

```
docker build \
    --build-arg "HTTP_PROXY=http://proxy.example.com:8080/" \
    --build-arg "HTTPS_PROXY=http://proxy.example.com:8080/" \
    --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com" .
```

在 Dockerfile 中指定相关环境变量:

| 环境变量    | Dockerfile 示例                                  |
| :---------- | :----------------------------------------------- |
| HTTP_PROXY  | ENV HTTP_PROXY="http://proxy.example.com:8080/"  |
| HTTPS_PROXY | ENV HTTPS_PROXY="http://proxy.example.com:8080/" |
| NO_PROXY    | ENV NO_PROXY="localhost,127.0.0.1,.example.com"  |

### 设置开机自启动

```bash
systemctl enable docker.service
```

测试运行 `hello-world`:

```bash
docker run hello-world

Output:
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 四、PostgreSQL 13

### 安装

```bash
# 1. 配置yum源
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm  

# 2. 安装 PostgreSQL
yum install -y postgresql13-server 

# 3. 初始化数据库
/usr/pgsql-13/bin/postgresql-13-setup initdb

# 4. 自启动
systemctl enable postgresql-13
systemctl start postgresql-13
```

### 初始化

```bash
# 1. 切换到 postgres 用户
su - postgres

# 2. 启动SQL Shell
psql

# 3. 修改密码
ALTER USER postgres WITH PASSWORD 'NewPassword';
```

### 配置远程访问

```bash
# 1. 开放防火墙端口
firewall-cmd --add-port=5432/tcp --permanent
firewall-cmd --reload

# 2. 修改IP绑定
#修改配置文件
vi /var/lib/pgsql/13/data/postgresql.conf

#将监听地址修改为 *
listen_addresses='*'

# 3. 允许所有IP访问
#修改配置文件
vi /var/lib/pgsql/13/data/pg_hba.conf

# 在文件底部写入：
host    all             all             0.0.0.0/0               md5

# 4. 重启PostgreSQL服务
systemctl restart postgresql-13
```

使用 Navicat 测试连接，连接成功！

## 五、Redis

### 安装

```bash
# 1. 下载 fedora 的 epel 仓库
yum install epel-release

# 2. 安装 Redis
yum install redis

# 3. 开机自启动
chkconfig redis on

# 4. 其他命令
# 启动redis
service redis start
# 停止redis
service redis stop
# 查看redis运行状态
service redis status
# 查看redis进程
ps -ef | grep redis
```

### 配置远程访问

```bash
# 1. 开放6379端口
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --reload

# 2. 修改配置文件
vi /etc/redis.conf

# 查找 port 修改端口
port 6379
# 查找 requirepass 修改密码
requirepass NewPassword
# 配置远程访问
# 找到 bind 127.0.0.1 将其注释
# 找到 protected-mode yes 将其改为
protected-mode no

# 3. 停止并重启redis服务
# 停止
service redis stop
# 以配置文件重启
redis-server /etc/redis.conf &
```

### 使用

```bash
# 命令行交互
redis-cli
```

也可以使用：[Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager) 在 Windows 管理 Redis 连接

## 六、Python

### Python 2

Centos 自带了 Python 2.7，可直接进行使用

```bash
python2 -V
# Python 2.7.5
```

### Python 3

#### yum 安装

```bash
# 安装 python 和 python3-devel
yum install -y python3 python3-devel

# 使用
python3 -V
# Python 3.6.8
```

pip3 升级与换源

```bash
# 换阿里源
pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple/
pip3 config set install.trusted-host mirrors.aliyun.com

# pip 升级
pip3 install --upgrade pip
```

#### 手动安装最新版

```bash
# 1. 下载安装包
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz

# 2. 解压
tar -zxvf Python-3.9.7.tgz
 
# 3. 下载编译依赖
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

# 4. 编译安装
cd Python-3.9.7
./configure --prefix=/usr/local/python39  # --prefix是Python的安装目录，同时安装了setuptools和pip工具
make && make install

# 5. 建立软连接
ln -s /usr/local/python39 /usr/local/bin/python3

# 6. 建立环境变量
# 编辑环境变量配置文件 $HOME/.bashrc，在文件末尾追加：
export PATH=/usr/local/python27/bin:/usr/local/python39/bin:$PATH

# 使更改生效
source $HOME/.bashrc

# 7. 查看版本
python3 -V
# Python 3.9.7
```

**Hello World！**

新建 `hello.py`文件，写入以下代码：

```python
print("Hello World!")
```

运行该文件：

```bash
python3 hello.py
 # Hello World!
```

## 七、Go

### yum 安装

```bash
# 安装
yum install golang

# 使用
go version
# go version go1.15.14 linux/amd64
```

### 二进制发行版安装

####  安装

```bash
# 1. 去官网下载最新版二进制包
wget https://studygolang.com/dl/golang/go1.20.linux-amd64.tar.gz
 
# 2. 提取压缩包内容
sudo tar -xzf go1.20.linux-amd64.tar.gz -C /usr/local

# 3. 简历软链接
sudo ln -s /usr/local/go/bin/* /usr/bin/

# 4. 验证是否成功
go version
# go version go1.18 linux/amd64
```

####  配置环境变量

```bash
# 编辑环境变量配置文件 $HOME/.bashrc，在文件末尾追加：
export GOROOT=/usr/local/go  #设置为go安装的路径，有些安装包会自动设置默认的goroot
export GOPATH=$HOME/go-work   #默认的Golang项目的工作空间
export GOBIN=$GOPATH/bin   # go install命令生成的可执行文件的路径
export PATH=$PATH:$GOROOT/bin:$GOBIN
```

```bash
# 保存，使配置文件生效
source $HOME/.bashrc
# 查看环境变量
go env
```

**Go Modules 配置**

```bash
# 换源
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=sum.golang.google.cn
```

**Hello World！**

新建 `hello.go`文件，写入以下代码：

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World!")
}
```

运行该文件：

```bash
 go run hello.go
 # Hello World!
```

## 八、NodeJS

### yum 安装

```bash
# 安装
yum install nodejs

# 使用
node -v
# v6.17.1
npm -v
# 3.10.10
```

### 二进制发行版安装

#### 安装

```bash
# 1. 官网下载二进制发行版的压缩包
wget https://nodejs.org/dist/v20.15.1/node-v20.15.1-linux-x64.tar.xz

# 2. 解压
tar -xf node-v20.15.1-linux-x64.tar.xz -C /usr/local/

# 3. 创建软连接
ln -s /usr/local/node-v20.15.1-linux-x64/bin/* /usr/bin/

# 4. 添加环境变量
# 编辑环境变量配置文件 $HOME/.bashrc，在文件末尾追加：
export NODE_HOME=/usr/local/node-v20.15.1-linux-x64
export PATH=$NODE_HOME/bin:$PATH

# 使更改生效
source $HOME/.bashrc
```

#### Hello World！

新建 `hello.go`文件，写入以下代码：

```js
function hello() {
   console.log('Hello World!');
}

hello();
```

运行该文件：

```bash
node hello.js
# Hello World!
```

## 九、Docker-compose 安装

最新发行的版本地址：https://github.com/docker/compose/releases

下载适合自己的版本：

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
```

赋予二进制文件可执行权限：

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

测试安装：

```bash
docker-compose --version

docker-compose version 1.29.2, build 5becea4c
```

