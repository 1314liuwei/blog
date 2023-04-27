# Linux 下 arp_ignore 问题

## 问题描述

在 Linux 主机本地新建一张虚拟网卡（如 TUN、TAP、Bridge等），给主机加上 IP 地址（假设为192.168.123.5）。同一局域网内主机添加相应路由表，执行 `ping 192.168.123.5` 的操作，经过实验发现外部主机能够 ping 通 192.168.123.5。

即使网卡没有启动，依然可以 ping 通。

 ## 问题分析

经过测试，发现有以下几个特征：

- 对执行 ping 的局域网主机进行抓包，发现局域网主机发起 ARP 请求时，Linux 主机回复了 ARP 包，回复的 mac 地址是物理网卡真实的 mac 地址；
- 多次实验发现，只要 Linux 主机上任意网卡配置了相应 IP，不管对应的网卡有没有开启，局域网主机都可以 ping 通（局域网主机添加了相应路由规则）；
- 在 Windows 主机上新建虚拟网卡，执行上面的操作，发现无法 ping 通。

 根据分析猜测应该是 Linux 对 ARP 包的处理逻辑有一些特性。

## Linux 源码分析

为了更好的了解这个问题，遂决定去看一下 Linux 的内核代码。看的是 Linux 3.10 的代码，源码地址：https://elixir.bootlin.com/linux/v3.10/source

```c
// net/ipv4/arp.c

static int arp_process(struct sk_buff *skb)
{
    ...
    /* Special case: IPv4 duplicate address detection packet (RFC2131) */
	if (sip == 0) {
       	// 判断是不是 arp 请求 
		if (arp->ar_op == htons(ARPOP_REQUEST) &&
            // 判断是不是本地地址
		    inet_addr_type(net, tip) == RTN_LOCAL &&
			// 判断是否开启 arp_ignore
		    !arp_ignore(in_dev, sip, tip))
			arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
				 dev->dev_addr, sha);
		goto out;
	}
    ...
}
```

查看路由表：

```bash
root@ubuntu:~# ip r show table 0
...
local 192.168.123.5 dev br0 table local proto kernel scope host src 192.168.123.5 
...
```

192.168.123.5 就是一个本地地址。

```c
static int arp_ignore(struct in_device *in_dev, __be32 sip, __be32 tip)
{
	int scope;

	switch (IN_DEV_ARP_IGNORE(in_dev)) {
	case 0:	/* Reply, the tip is already validated */
		return 0;
	case 1:	/* Reply only if tip is configured on the incoming interface */
		sip = 0;
		scope = RT_SCOPE_HOST;
		break;
	case 2:	/*
		 * Reply only if tip is configured on the incoming interface
		 * and is in same subnet as sip
		 */
		scope = RT_SCOPE_HOST;
		break;
	case 3:	/* Do not reply for scope host addresses */
		sip = 0;
		scope = RT_SCOPE_LINK;
		break;
	case 4:	/* Reserved */
	case 5:
	case 6:
	case 7:
		return 0;
	case 8:	/* Do not reply */
		return 1;
	default:
		return 0;
	}
	return !inet_confirm_addr(in_dev, sip, tip, scope);
}
```

查询内核的 `arp_ignore`参数:

```bash
root@ubuntu:~# cat /proc/sys/net/ipv4/conf/all/arp_ignore 
0
```

发现内核的 `arp_ignore` 参数为 0，那么代表着 Linux 会回复这个包。

```c
// net/ipv4/arp.c

static int arp_process(struct sk_buff *skb)
{
    ...
    /* Special case: IPv4 duplicate address detection packet (RFC2131) */
	if (sip == 0) {
       	// 判断是不是 arp 请求 
		if (arp->ar_op == htons(ARPOP_REQUEST) &&
            // 判断是不是本地地址
		    inet_addr_type(net, tip) == RTN_LOCAL &&
			// 判断是否开启 arp_ignore
		    !arp_ignore(in_dev, sip, tip))
            // 回复网卡 mac
			arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
				 dev->dev_addr, sha);
		goto out;
	}
    ...
}
```

根据 `arp_process` 函数所示，如果内核没有开启 `arp_ignore`，那么哪个网卡收到的 arp 包，就会回复那个网卡的 mac 地址 。

尝试开启 `arp_ignore`：

```bash
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
```

此时再去执行 ping 操作，发现此时无法 ping 通 192.168.123.5.
