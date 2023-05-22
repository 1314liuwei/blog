# Kali 无法连接到网络

## 问题描述

打开 Kali，无法连接到网络，虚拟机配置正常的。

尝试 ping 百度，出错：

```bash
ping: www.baidu.com: Temporary failure in name resolution
```

## 解决办法

### 1. 首先查看本机 IP

```bash
┌──(blogger㉿kali)-[~/Desktop]
└─$ ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 12  bytes 640 (640.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 640 (640.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

未发现虚拟机网卡，应该是虚拟机网卡出问题了。

### 2. 查看所有网卡

```bash
┌──(blogger㉿kali)-[~/Desktop]
└─$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0c:29:d5:a4:ae brd ff:ff:ff:ff:ff:ff
```

发现网卡，那么应该是网卡没有启动起来，将网卡启动，配置好应该就能解决问题。

### 3. 启动网卡并写入配置文件

```bash
┌──(root💀kali)-[/home/blogger/Desktop]
└─#  ip link set dev eth0 up  # 启动网卡                                                                                                                                                                                                                                                               
┌──(root💀kali)-[/home/blogger/Desktop]
└─# ifconfig eth0 192.168.1.201 netmask 255.255.255.0 # 配置IP和网关
                                                                                                                                                            
┌──(root💀kali)-[/home/blogger/Desktop]
└─# route add default gw 192.168.1.1 # 配置路由
                                                                                                                                                            
┌──(root💀kali)-[/home/blogger/Desktop]
└─# echo 'nameserver 114.114.114.114' >> /etc/resolv.conf # 修改DNS
                                                                                                                                                            
┌──(root💀kali)-[/home/blogger/Desktop]
└─# ping www.baidu.com # 再次尝试 ping，成功
```

