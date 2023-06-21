# TCP 长连接

## TCP 短连接

使用 TCP 传输数据时，每一次传输都打开一个 socket ，当次数据传输完后就关闭这个 socket。

由于每次打开 socket、关闭 socket 时就会经历 TCP 的三次握手和四次挥手流程，这些流程会消耗大量时间。

## TCP 长连接

如果能够单次传输完成后不关闭 socket，后续传输数据时，可以复用同一个 socket，那么就会节省下大量的 TCP 握手和挥手的时间。

TCP 中的 Keep-Alive 机制就实现了上诉需求。

Linux 端可通过 `sysctl -a | grep keepalive` 命令查看内核的 tcp_keepalive 相关参数：

```bash
root@ubuntu:~# sysctl -a |grep keepalive
net.ipv4.tcp_keepalive_intvl = 75	# 当没有收到对方的确认时，继续发送保活探测报文的间隔时间
net.ipv4.tcp_keepalive_probes = 9	# 当没有收到对方的确认时，继续发送保活探测报文的默认次数
net.ipv4.tcp_keepalive_time = 7200	# 最后一次数据传输结束开始计时起到发送第一个保活探测报文的时间间隔
```

当开启 TCP 的 Keep-Alive 机制后，TCP socket 连接会定期向对端发送心跳保活包。超过 7200s 没有进行收发数据后，TCP socket 向对端发送保活包时，对端有可能处于以下三种状态：

- 对方成功接收，连接正常：以期望的ACK报文段响应；本地 socket 等待 7200s 后又会发送保活包；
- 对方已崩溃且已重新启动：回复 RST 报文响应。本地 socket 的待处理错误被置为 `ECONNRESET`，socket本身则被关闭，断开TCP连接；
- 对方无任何响应：发送保活探测报文的一方，相隔 75s 后，再次重发保活探测报文，重发8次，一共尝试9次。若仍无响应就放弃。socket的待处理错误被置为ETIMEOUT，socket本身则被关闭，断开TCP连接。



其他系统上 keepalive 的默认设置：

- FreeBSD、Mac OS X系统：

  ```bash
  $ sysctl net.inet.tcp | grep -E "keepidle|keepintvl|keepcnt"
    net.inet.tcp.keepidle: 7200000
    net.inet.tcp.keepintvl: 75000
    net.inet.tcp.keepcnt: 8
  ```

- Windows 系统：[官方文档](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd349797(v=ws.10)?redirectedfrom=MSDN#tcpip-related-registry-entries)

  | Registry entry            | Format | Windows Vista® and Windows Server® 2008 default setting | Recommended setting            |
  | :------------------------ | :----- | :------------------------------------------------------ | :----------------------------- |
  | DisableIPSourceRouting    | DWORD  | 1 for IPv4, 0 for IPv6                                  | 2                              |
  | KeepAliveTime             | DWORD  | 7,200,000 (time in milliseconds)                        | 300,000 (time in milliseconds) |
  | PerformRouterDiscovery    | DWORD  | 2                                                       | 0                              |
  | TcpMaxDataRetransmissions | DWORD  | 5                                                       | 3                              |

  

