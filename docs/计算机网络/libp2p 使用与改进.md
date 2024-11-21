# 一、使用

## 1.1 网络可见性

libp2p 节点在默认情况下，其节点的网络可见性由 [AutoNAT ](https://docs.libp2p.io/concepts/nat/autonat/)模块和其他节点交互而自动确定。但是 AutoNAT 存在发现时间确认网络可见性时间较长，且需要和较多节点交互的缺点。

对于设备端、移动端和云端中继节点，网络可见性是预知的，因此需要预设节点网络可见性：

- 设备端、移动端：设备端和移动端节点默认是工作在 NAT 之后的，预设其网络可见性为 `private`；
- 云端中继：云端中继节点是具有公网 IP 的，需要预设其网络可见性为 `public`。

## 1.2 手动配置地址

默认情况下，libp2p 节点的地址列表由本地监听地址列表、NAT 映射地址、节点连接中继地址和 AutoNAT 发现地址组成。其中 AutoNAT 发现地址是通过和其他节点交互而确定的（主要是用于发现 NAT 映射地址，类似于传统 NAT 穿透中与 STUN 服务器交互发现 NAT 映射地址）。

但是 AutoNAT 存在发现时间确认网络可见性时间较长，且需要和较多节点交互的缺点，会导致节点无法第一时间探测到自身外部地址。并且 AutoNAT 发现的地址皆为 IP 形式，无法发现域名形式的地址。

 通过在地址列表中增加手动配置地址的方式可以解决 AutoNAT 存在的问题。

- 云端中继：手动配置节点公网地址；
- 设备端：手动配置节点外部节点能力作为可选项配置。

## 1.3 取消中继节点资源限制

libp2p 节点在启用 Relay 能力时，默认情况下会存在资源限制：[source code](https://github.com/libp2p/go-libp2p/blob/76b266558bb77d71106788f68931ce1ad0adf38a/p2p/protocol/circuitv2/relay/resources.go#L44)。

```Go
// DefaultResources returns a Resources object with the default filled in.
func DefaultResources() Resources {
        return Resources{
                Limit: DefaultLimit(),

                ReservationTTL: time.Hour,

                MaxReservations: 128,
                MaxCircuits:     16,
                BufferSize:      2048,

                MaxReservationsPerPeer: 4,
                MaxReservationsPerIP:   8,
                MaxReservationsPerASN:  32,
        }
}

// DefaultLimit returns a RelayLimit object with the defaults filled in.
func DefaultLimit() *RelayLimit {
        return &RelayLimit{
                Duration: 2 * time.Minute,
                Data:     1 << 17, // 128K
        }
}
```

对于我们的公网中继节点来说，需要取消该限制才能让上层业务正常使用。

## 1.4 启用 NATPortMap

NATPortMap 用于在路由器上通过 PCP / NAT-PMP / UPnP 协议进行端口映射。默认情况下，libp2p 未启用 NATPortMap 能力。为了提高打洞成功率，对于设备端默认启用 NATPortMap 能力。

## 1.5 启用 mDNS

mDNS 用于在局域网发现 libp2p 节点。默认情况下 libp2p 未启用 mDNS 能力。为了方便快速发现局域网中 libp2p 节点信息，对于设备端和移动端默认启用 mDNS 能力。

# 二、相关改进

## 2.1 holepunch

libp2p 的 holepunch 模块只是实现了相对基础的 P2P 能力，对于**带有具有防护能力的路由器** 和 **Port Restricted Cone** **NAT** **- Symmetric NAT** 的打洞能力不足。

根据调查发现带有具有防护能力的路由器在国内家用环境较为常见。因此对 libp2p holepunch 模块进行了优化，在 libp2p 的 holepunch 打洞阶段结束且打洞失败后，尝试进行高级打洞。流程如下图所示：

![image-20241121141630693](https://pic.try-hard.cn/blog/2024/11/21/20241121-141632.png)

## 2.2 中继选择与切换

由于 libp2p 原生 AutoRelay 模块选择逻辑过于简单，不符合实际需求。因此需要自行实现中继选择逻辑，再通过实例传递的方式覆盖原有中继选择模块。

## 2.3 地址解析服务

libp2p 原生提供从 mDNS 解析地址和 DHT 解析地址。由于 IPFS 节点大部分在国外，国内用户通过访问 IPFS 速度较慢。因此需要在国内需要提供查询优化服务。

## 2.4 移动端适配优化

由于手机操作系统对于 APP 后台管理策略较为严格，因此 libp2p 在手机端运行时遇到了底层 socket 被销毁问题。

## 2.5 mDNS domain 替换

libp2p 默认是采用一个由 32 ~ 64 字符长度的随机字符串作为 mDNS doamin：[source code](https://github.com/libp2p/go-libp2p/blob/76b266558bb77d71106788f68931ce1ad0adf38a/p2p/discovery/mdns/mdns.go#L60)。

为了实现通过 `<peer id>.local` 的方式能够直接访问到主机（mDNS标准用法），需要用 peer id 替换该随机字符串。