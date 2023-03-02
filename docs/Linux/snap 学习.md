# Snap 学习

## 一、任务要求

> 1、描述工具的使用，适配的架构，已知存在的缺陷
> 2、分析工具中应用的配置管理方式
> 3、调研如果在snap上发布集成应用，比如第三方如何制作应用添加上去
> 4、snap自身的对应用的运行过程管理，实现的核心原理

## 二、支持

| 系统\架构 | amd64 | arm64 | armel | armhf | i386 | ppc64el | s390x |
| :-------: | :---: | :---: | :---: | :---: | :--: | :-----: | :---: |
|  Debian   |   √   |   √   |   √   |   √   |  √   |    √    |   √   |
|  Ubuntu   |   √   |   √   |   ×   |   √   |  √   |    √    |   √   |
|   Arch    |   √   |   ×   |   ×   |   ×   |  ×   |    ×    |   ×   |
|  Fedora   |   √   |   √   |       |       |      |         |       |
|           |       |       |       |       |      |         |       |
|           |       |       |       |       |      |         |       |
|           |       |       |       |       |      |         |       |

## 零碎知识

### 1. snap 应用挂载

`.snap`包是`squashfs`文件系统的。 `/var/lib/snapd/snaps/app.snap`文件被挂载到了 `/snap/app`下。

### 2. snap 应用构建生命周期

```
These plugins implement a lifecycle over the following steps:

  - pull:   retrieve the source for the part from the specified location
  - build:  drive the build system determined by the choice of plugin
  - stage:  consolidate desirable files from all the parts in one tree
  - prime:  distill down to only the files which will go into the snap
  - snap:   compress the prime tree into the installable snap file
```

### 3. Ubuntu Core 20

Ubuntu Core 20是一个轻量，容器化，基于Ubuntu 20.04 LTS且为物联网设备和嵌入式系统所打造的版本，现在已经普遍可用。新版本内建的安全更新严格限制策略使创新者能够开发高安全的产品和方案，并完全专注于自己独特的功能和应用程序。Ubuntu Core 20由安全、广泛使用、易开发维护的snap组成，专为企业级生产和大规模部署和运营而设计。

不同于传统的Linux，在Ubuntu Core的架构上使用snap架构即从Linux内核到应用层都是以snap包的形式出现。如下图所示，Linux内核单独是一个snap，上面一层是Core snap，再上一层是snap应用程序。

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2022/12/13/20221213-142244.jpg)



## 三、Snap 缺点

缺点：

- 无法针对单个软件包启用禁止更新，如果该软件包没有向下兼容，那么会导致依赖该软件的其他软件出现问题
- snap的安全机制依赖于 APPArmor，Linux系统只能有一个LSM运行，如果Linux还启用了其他LSM，snap的安全机制无法得到保证





