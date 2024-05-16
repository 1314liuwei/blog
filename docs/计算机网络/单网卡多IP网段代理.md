# 单网卡多IP网段代理

## 效果图

**实现效果：OS-A 通过 OS-B 能够访问 OS-C 。**

![image-20230529113551972](https://pic.try-hard.cn/blog/2023/05/29/20230529-113552.png)

## 实现步骤

OS-A 需要添加路由，将 192.168.1.0/24 网段的流量发送到 OS-B

```bash
ip addr add 192.168.1.0/24 dev eth0
```

OS-B 需要开启数据包转发的能力，并且设置 SNAT，将收到的 192.168.1.0/2 的源 IP 换为 192.168.1.22：

```bash
# 开启包转发能力
sysctl -w net.ipv4.ip_forward=1
sysctl -p /etc/sysctl.conf

# 添加 SNAT
iptables -t nat -A POSTROUTING -d 192.168.1.0/24 -j SNAT --to-source 192.168.1.22
```

