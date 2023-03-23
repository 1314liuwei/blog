# Wireguard 实践

## 一、安装

### Ubuntu

> ⚠️ **注意** ：
>
> WireGuard 对 Linux 内核版本有要求，`5.4` 以上内核才将其纳入其中。
> 如果内核低于该版本（典型如：RHEL 和 CentOS），就需要比较复杂的涉及内核编译的过程，请自行登录 [官网 ](https://www.wireguard.com/install/)查找详细信息。

```bash
$ sudo apt install wireguard
```

安装完成后系统中会存在以下东西：

- 两个 cli 命令：`wg` 和 `wg-quick`;
- 两个 systemd 文件: `wg-quick@.service` 和 `wg-quick.target`.

> 可以在 WireGuard 的 Service 文件中加入如下一行，重新加载配置流量不中断：
> `ExecReload=/bin/bash -c 'exec /usr/bin/wg syncconf %i <(exec /usr/bin/wg-quick strip %i)'`

### Windows

[下载链接](https://download.wireguard.com/windows-client/wireguard-installer.exe)

Windows 下载完成后，会存在一个后台服务和一个 GUI 的界面

![image-20230305222529698](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20230305222529698.png)

![image-20230305215527942](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20230305215527942.png)

### Android

[Google Store 下载链接](https://play.google.com/store/apps/details?id=com.wireguard.android)

## 二、使用实践

### 1. Peer to Peer

```config

```



### 2. Peer to LAN

### 3. LAN to LAN

