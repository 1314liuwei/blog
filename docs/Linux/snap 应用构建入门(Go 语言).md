# snap 应用构建入门(Go 语言)

## 一、介绍

> snap是Canoncial公司提出的新一代linux包管理工具，致力于将所有linux发行版上的包格式统一，做到“一次打包，到处使用”。目前snap已经可以在包括Ubuntu、Fedora、Mint等多个Linux发行版上使用。
>
> snapcraft 是一个正在为其在 Linux 中的地位而奋斗的包管理系统，它为你重新设想了分发软件的方式。这套新的跨发行版的工具可以用来帮助你构建和发布 snap 软件包。

## 二、准备工作

```bash
# 1. 安装 snap
sudo apt install snapd
snap version

output:
snap    2.53+21.10ubuntu1
snapd   2.53+21.10ubuntu1
series  16
ubuntu  21.10
kernel  5.13.0-22-generic

# 2. 安装 snapcraft
sudo snap install --classic snapcraft
snapcraft version

output:
snapcraft, version 6.0
```

## 三、初始化 snacraft 项目

```bash
# 1. 创建目录
mkdir gosnap
cd gosnap
mkdir hello
cd snap

# 2. 初始化项目
snapcraft init
# 当前目录如下:
.
└── snap
    └── snapcraft.yaml
```

`snapcraft.yaml`文件就是我们构建项目时需要使用的配置文件：

```yaml
name: my-snap-name # you probably want to 'snapcraft register <name>'
base: core18 # the base snap is the execution environment for this snap
version: '0.1' # just for humans, typically '1.2+git' or '1.3.2'
summary: Single-line elevator pitch for your amazing snap # 79 char long summary
description: |
  This is my-snap's description. You have a paragraph or two to tell the
  most important story about your snap. Keep it under 100 words though,
  we live in tweetspace and your description wants to look good in the snap
  store.

grade: devel # must be 'stable' to release into candidate/stable channels
confinement: devmode # use 'strict' once you have the right plugs and slots
```

关于这个配置文件的更多信息可以查看官方手册：[Snapcraft.yaml reference | Snapcraft documentation](https://snapcraft.io/docs/snapcraft-yaml-reference)

## 四、创建 Go 项目

```bash
# 1. 创建文件夹
mkdir src
cd src

# 2. 创建 go 项目
go mod init gohello
vim main.hello
```

输入以下代码：

```go
package main

import "fmt"

func main() {
    fmt.Println("hello world")
}
```

当前项目文件如下：

```
.
└── hello
    └── snap
        ├── snapcraft.yaml
        └── src
            ├── go.mod
            └── main.go
```

## 五、修改配置文件

```yaml
name: gohello
base: core20
version: '0.1'
summary: Hello World!
description: |
  This is my-snap's description.

grade: devel 
confinement: devmode

parts:
  my-part:
    source: src/
    plugin: go

apps:
  gohello:
    command: bin/gohello
```

## 六、构建 snap 应用

```bash
cd snap
ls

output:
snapcraft.yaml  src

# 开始构建
snapcraft
```

第一次构建的时候会出现选择使用 `multipass`，输入 `y`。

紧接着就会开始进行构建：

```
Snapcraft is running in directory 'snap'.  If this is the snap assets directory, please run snapcraft from /root/gosnap/hello.
Launching a VM.
.......
```

构建过程十分缓慢，构建完成后则会在当前文件夹下出现一个 `gohello_0.1_amd64.snap` 文件。

## 七、安装 snap 应用

```bash
sudo snap install --devmode gohello_0.1_amd64.snap

output:
gohello 0.1 installed
```

执行应用：

```bash
gohello

output:
hello world
```



至此我们的snap应用就已经构建安装完毕。

## 八、问题总结

### 1. multipass 问题

当构建过程中遇到 multipass 问题时，如这种：

```
An error occurred with the instance when trying to launch with 'multipass': returned exit code 2.
Ensure that 'multipass' is setup correctly and try again.
```

可以选择重启 multipass 服务，再重新构建：

```bash
sudo systemctl restart snapd.multipass.multipassd.service
```

