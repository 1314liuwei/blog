# Centos minimal 网络配置

## 一、下载 && 安装

版本选择：Centos 7.9 minimal 

下载地址：[Index of /centos/7.9.2009/isos/x86_64/ (aliyun.com)](http://mirrors.aliyun.com/centos/7.9.2009/isos/x86_64/)

安装：这里自己选择 VM 进行安装（安装过程这里就不赘述了）

## 二、Centos 网络配置相关文件

### 1. /etc/resolv.conf 

它是 DNS 客户机配置文件，用于设置DNS服务器的IP地址及DNS域名，同时还包含了主机的域名搜索顺序。该文件是由域名解析器（resolver，一个根据主机名解析IP地址的库）使用的配置文件。

resolv.conf 的关键字主要有四个，分别是：

- **nameserver**：定义DNS服务器的IP地址
- **domain**：定义本地域名
- **search**：定义域名的搜索列表
- **sortlist**：对返回的域名进行排序

### 2. /etc/hosts 

hosts 文件是 Linux 系统中负责 IP 地址与域名快速解析的文件。

hosts 文件包含了 IP 地址和主机名之间的映射，包括主机名的别名。在没有域名服务器的情况下，系统上的所有网络程序都通过查询该文件来解析对应于某个主机名的ip地址，否则就需要使用DNS服务程序来解决。

**优先级：DNS 缓存 > hosts > DNS 服务**

### 3. /etc/sysconfig/network

该文件可用于设定本机主机名，：

```bash
NETWORKING=yes    # 网络是否可用
HOSTNAME=minimal  # 主机名
```

### 4. /etc/sysconfig/network-script/ifcfg-\<interface-name>

这是每一个网络接口的配置信息。每一个网卡只能使用一个配置文件，当有多个配置文件时，后面读取的配置文件信息会覆盖前面的配置信息。

## 三、查看本机网卡信息

由于 Centos 最小化安装后是没有 ifconfig 命令的，因此没有办法通过 ifconfig 查看网卡相关配置信息的。

这个时候我们需要通过 ip 命令来查看网卡信息。

```
ip addr 或 ip addr show
```

![image-20210831160307101](https://pic.try-hard.cn/blog/image-20210831160307101.png)

在输出内容中我们可以发现两块网卡：**lo 和 ens33**。

- `lo`表示`local`，`lo` 网卡是用于回环地址的网卡，并不是真正有这样的物理网卡，它的地址一般是`127.0.0.1`，回环地址一般是用于网络程序开发、网络组件测试时会用到。

- > 新版的 CentOS 7 开始对于网卡的编号有另外一套规则，网卡的代号与网卡的来源有关
  >
  > - eno1：代表由主板 bios 内置的网卡；
  > - ens1:代表有主板 bios 内置的 PCI-E 网卡；
  > - enp2s0: PCI-E 独立网卡；
  > - eth0：如果以上都不使用，则回到默认的网卡名。

  ens33 则属于第二种类型，是一块 PCI-E 网卡。当前系统的 ens33 网卡并没有 ipv4 及 ipv6，因此当前 Linux 系统是没有办法上网的。

## 四、配置双网卡

### 1. 添加网卡

在上面我们发现我们的 Linux 只有一张网卡，想要配置双网卡的话需要在虚拟机设置里再添加一张网卡：

![image-20210831161959391](https://pic.try-hard.cn/blog/image-20210831161959391.png)

添加好后重启进入系统就可以发现我们已经有了两张网卡了（ens33 和 ens36）：

![image-20210831162131115](https://pic.try-hard.cn/blog/image-20210831162131115.png)

### 2. 配置 DHCP

查看 ens33 的配置信息：

```bash
[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-ens33 
TYPE=Ethernet               # 网卡类型：为以太网
PROXY_METHOD=none           # 代理方式：关闭状态
BROWSER_ONLY=no             # 只是浏览器：否
BOOTPROTO=dhcp              # 网卡的引导协议：DHCP[中文名称: 动态主机配置协议]
DEFROUTE=yes                # 默认路由：是, 不明白的可以百度关键词 `默认路由` 
IPV4_FAILURE_FATAL=no       # 是不开启IPV4致命错误检测：否
IPV6INIT=yes                # IPV6是否自动初始化: 是[不会有任何影响, 现在还没用到IPV6]
IPV6_AUTOCONF=yes           # IPV6是否自动配置：是[不会有任何影响, 现在还没用到IPV6]
IPV6_DEFROUTE=yes           # IPV6是否可以为默认路由：是[不会有任何影响, 现在还没用到IPV6]
IPV6_FAILURE_FATAL=no       # 是不开启IPV6致命错误检测：否
IPV6_ADDR_GEN_MODE=stable-privacy  # IPV6地址生成模型：stable-privacy [这只一种生成IPV6的策略]
NAME=en3         			# 网络接口名称，即配置文件名后半部分。
UUID=f47bde51-fa78-4f79-b68f-d5dd90cfc698   # 通用唯一识别码,每一个网卡都会有,不能重复,否两台linux只有一台网卡可用
DEVICE=ens33                # 网卡设备名称
ONBOOT=no                   # 是否开机启动，要想网卡开机就启动或通过 `systemctl restart network`控制网卡,必须设置为 `yes`
```

我们将 ens33 网卡配置为**开机启动、动态获取 IP 方式**，编辑 ifcfg-ens33 文件，修改以下几项：

```bash
ONBOOT=yes 			#设置为开机启动
BOOTPROTO=dhcp      # 网卡的引导协议：DHCP[动态主机配置协议]
DEVICE=ens33 		# 要配置的网卡名
```

修改完成后重启网络服务：

```bash
systemctl restart network 
# 或 
service network restart
```

此时再查看，可以发现 ens33 已经获取到 IP 地址了：

![image-20210831164201457](https://pic.try-hard.cn/blog/image-20210831164201457.png)

### 3. 配置静态地址

由于我们是在系统安装完成之后再添加的网卡，因此在 `/etc/sysconfig/network-scripts/`目录下会找不到  `ifcfg-ens36` 配置文件，因此这时我们需要先将 `ifcfg-ens33` 的文件拷贝一份，重命名为`ifcfg-ens36`，再进行网卡配置。

我们将 ens36 网卡配置为**开机启动、设置静态 IP 方式**，编辑 ifcfg-ens36 文件，修改以下几项：

```bash
DEVICE=ens36		  			# 要配置的网卡
ONBOOT=yes    					# 开机自启动
BOOTPROTO=static	  			# 静态ip方式
IPADDR=192.168.153.134 			# ipv4地址
GATEWAY0=192.168.153.2 			# 设置网关
DNS1=255.5.5.5					# 设置DNS
```

配置完成后重启网络服务即可。