# Lxd 安装 Windows 虚拟机

## 准备工作

```bash
// 1. 运行环境准备
sudo snap install distrobuilder --classic
sudo snap install lxd
sudo apt install libguestfs-tools wimtools virt-viewer

// 2. 下载 windows iso 镜像文件
wget https://software-download.microsoft.com/db/Win10_20H2_English_x64.iso?t=d94b7d1c-76a5-4fc9-9372-0c7e2b74c388&e=1640042095&h=efb6561a35f49728f432c77a95eed3fe

// 3. 制作 lxc 镜像文件
sudo distrobuilder repack-windows Win10_20H2_English_x64.iso win.iso
INFO	Mounting Windows ISO
INFO	Downloading drivers ISO
INFO	Mounting driver ISO
INFO	Modifying WIM file	{"file": "boot.wim", "index": 2}
INFO	Modifying WIM file	{"file": "install.wim", "index": 1}
INFO	Modifying WIM file	{"file": "install.wim", "index": 2}
INFO	Modifying WIM file	{"file": "install.wim", "index": 3}
INFO	Modifying WIM file	{"file": "install.wim", "index": 4}
INFO	Modifying WIM file	{"file": "install.wim", "index": 5}
INFO	Modifying WIM file	{"file": "install.wim", "index": 6}
INFO	Modifying WIM file	{"file": "install.wim", "index": 7}
INFO	Modifying WIM file	{"file": "install.wim", "index": 8}
INFO	Modifying WIM file	{"file": "install.wim", "index": 9}
INFO	Modifying WIM file	{"file": "install.wim", "index": 10}
INFO	Modifying WIM file	{"file": "install.wim", "index": 11}
INFO	Generating new ISO
INFO	Removing cache directory
```

## 创建与运行虚拟机

```bash
// 1. 使用默认项初始化 lxc 配置


// 2. 创建一个空的虚拟机
lxc init win10 --empty --vm -c security.secureboot=false

// 3. 为虚拟机分配磁盘
lxc config device override win10 root size=50GiB

// 4. 加载打包好的 iso 镜像
lxc config device add win10 iso disk source=win.iso boot.priority=10

// 5. 开始运行虚拟机
lxc start win10 --console=vga
```

开始运行虚拟机后就会进入到这个界面：

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1640310873445822500.png)

然后完成 windows 的安装流程后就可以正常使用 windows 虚拟机了。

后续可以使用 `lxc console --type=vga`启动虚拟机。



> reference：
>
> 1. [lxc/distrobuilder: System container image builder for LXC and LXD (github.com)](https://github.com/lxc/distrobuilder)
> 2. [LXD documentation (linuxcontainers.org)](https://linuxcontainers.org/lxd/docs/master/)
