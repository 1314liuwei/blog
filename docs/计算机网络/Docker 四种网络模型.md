# Docker 四种网络模型

## 一、简介

为了满足使 Docker 满足复杂业务场景下的网络需求，我们有必要深入了解 Docker 的网络知识，探索 Docker 的多种网络模型。

Docker 的网络模型主要有四种：

- **Bridge 模式**：是 Docker 的默认网络模式，可以使用 `–net=bridge` 指定；
- **Host 模式**：使用 `–net=host` 指定；
- **Container 模式**：使用 `–net=container: 容器名称或ID` 指定；
- **None 模式**：使用 `–net=none` 指定。

下面让我们详细了解一下这几种不同的网络模式！

## 二、Bridge 模式

Bridge 模式是 Docker 默认使用的网络模式。当 Docker 启动时，会自动在主机上创建一个 `docker0` 虚拟网桥，实际上是 Linux 的一个 bridge，可以理解为一个软件交换机。它会在挂载到它的网口之间进行转发。

```bash
# 查看本机网络配置
ip addr 

...
docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:51:82:92:0a brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:51ff:fe82:920a/64 scope link
       valid_lft forever preferred_lft forever
...
```

Docker 随机分配一个本地未占用的私有网段，这里是 `172.17.0.1`，掩码为 `255.255.0.0`。此后启动的容器内的网口也会自动分配一个同一网段（`172.17.0.0/16`）的地址。

当创建一个 Docker 容器的时候，同时会创建了一对 `veth pair` 接口（当数据包发送到一个接口时，另外一个接口也可以收到相同的数据包）。这对接口一端在容器内，即 `eth0`；另一端在本地并被挂载到 `docker0` 网桥，名称以 `veth` 开头：

```bash
# 启动一个容器
docker run -dit ubuntu

# 查看网络配置
ip addr

...
vethc51f579@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether 5e:fd:53:cc:54:58 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::5cfd:53ff:fecc:5458/64 scope link
       valid_lft forever preferred_lft forever
       

# 进入容器
docker exec -it {{ID}} bash
# 安装 net-tools
apt-get update
apt-get install net-tools
# 查看网络配置
ifconfig

...
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:02  txqueuelen 0  (Ethernet)
        RX packets 2452  bytes 13783808 (13.7 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2012  bytes 152399 (152.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

通过这种方式，主机可以跟容器通信，容器之间也可以相互通信。Docker 就创建了在主机和所有容器之间一个虚拟共享网络：![docker网络](https://pic.try-hard.cn/blog/2022/12/13/20221213-141939.png)

## 三、Host 模式

Docker 为了实现网络的隔离，使用了 Network Namespace 对网络进行隔离。但如果启动容器的时候使用host模式，那么这个容器将不会获得一个独立的 Network Namespace，而是和宿主机共用一个 Network Namespace。容器将不会虚拟出自己的网卡，配置自己的IP等，而是使用宿主机的 IP 和端口。

![image-20220114110501693](https://pic.try-hard.cn/blog/image-20220114110501693.png)

```bash
# 查看最开始的网络配置
ip addr

# 以host模式启动一个容器
docker run -dit -p 80:80 --net host nginx

# 查看网络配置
ip addr
# 未发现多出 veth 接口，网络配置与之前没有任何区别
```

而外界访问容器中的应用，则直接使用 `主机IP:80` 即可，不用任何NAT转换，就如直接跑在宿主机中一样。但是，容器的其他方面，如文件系统、进程列表等还是和宿主机隔离的。

## 四、Container 模式

Container 模式指定新创建的容器和已经存在的一个容器共享一个 Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡，配置自己的IP，而是和一个指定的容器共享IP、端口范围等。同样，两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器的进程可以通过 lo 网卡设备通信。

![22](https://pic.try-hard.cn/blog/1631244516713921000.jpg)

```bash
# 以默认模式一个容器
docker run -dit --name u1 ubuntu
# 以 container 模式启动另一个容器
docker run -dit --name u2 --network container:u1 ubuntu

# 查看网络配置
ifconfig
# 发现只多了一个 veth
```

## 五、None 模式

此模式下容器不参与网络通信，运行于此类容器中的进程仅能访问本地环回接口，仅适用于进程无须网络通信的场景中，例如备份，进程诊断及各种离线任务等。

```bash
# 以 None 模式运行一个容器
docker run -dit --network none ubuntu

# 进入容器查看
ifconfig

# 只有 lo 网卡
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 29  bytes 2569 (2.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 29  bytes 2569 (2.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

> 参考资料：
>
> - [高级网络配置 | Docker 从入门到实践 (docker-practice.com)](https://vuepress.mirror.docker-practice.com/advanced_network/)
> - [docker容器的四种网络模型_xbw_linux123的博客-CSDN博客_docker 网络模型](https://blog.csdn.net/xbw_linux123/article/details/81873490)
> - [Docker的docker0网络 - Kit_L - 博客园 (cnblogs.com)](https://www.cnblogs.com/Kit-L/p/13246782.html)

