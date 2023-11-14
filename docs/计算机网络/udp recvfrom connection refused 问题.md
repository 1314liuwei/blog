# udp recvfrom: connection refused 问题

## 出错代码

```go
package main

import (
	"net"
)

func main() {
    udp, err := net.DialUDP("udp", nil, &net.UDPAddr{IP: net.ParseIP("192.168.1.2"),Port: 2222})
	if err != nil {
		panic(err)
	}

	_, err = udp.Write([]byte("test"))
	if err != nil {
		panic(err)
	}
	buff := make([]byte, 1024)
	_, _, err = udp.ReadFromUDP(buff)
	if err != nil {
		panic(err)
	}
}
```

错误信息：

```go
panic: read udp 192.168.1.5:45529->192.168.1.2:2222: recvfrom: connection refused

goroutine 1 [running]:
main.main()
        /root/udp.go:20 +0x177
exit status 2
```

## 问题原因

```bash
root@ubuntu:~# tcpdump -i enp1s0 host 192.168.1.2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp1s0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
10:36:06.764008 IP 192.168.1.5.60398 > 192.168.1.2.2222: UDP, length 4
10:36:06.764420 IP 192.168.1.2 > 192.168.1.5: ICMP 10.0.0.1 udp port 2222 unreachable, length 40
```

使用 tcpdump 抓包发现目标主机为给主机回复了一个 ICMP 包，用来指示 2222 端口不可达。

根据《UNIX网络编程卷1：套接字联网API（第3版）》第八章第8.9小结所讲，这个 ICMP 错误被称为异步错误（asynchronous error）。

该错误是由 `sendto` 引起（`udp.Write`函数内部实际调用了 unix 的`sendto`系统接口），但是 `sendto` 本身却返回成功。这个 ICMP 数据被送入了 UDP 套接字的接收缓冲区，当调用 `recvfrom`接口时返回错误。因此当程序调用 `udp.ReadFromUDP`时会抛出错误。

根据错误分析可以发现，如果没有执行`sendto`操作，那么`recvfrom`则不会收到错误信息。