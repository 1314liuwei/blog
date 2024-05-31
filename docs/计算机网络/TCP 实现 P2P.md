# TCP 实现 P2P

## 简介

市面上实现 P2P 的产品主要都是以 UDP 协议为主。因为 UDP 是无连接的，能够往任意地址发包，便于实现 P2P 的能力。

但是 UDP 同时也是不可靠的，如果想要实现可靠传输得自己基于 UDP 去实现可靠传输协议，例如 QUIC、KCP、SCTP 等基于 UDP 实现的可靠连接。

但是基于 UDP 实现的可靠传输是位于应用层，运行在用户态的。

而 TCP 协议是操作系统网络栈原生支持的，而且经过这么多年在操作系统内核层面的优化，TCP 性能是十分能打的，如果我们能够基于 TCP 建立 P2P 连接，对于我们应用层来说就会省事很多了。

## 实现

要想实现基于 TCP 的 P2P，那么 TCP 也必须像 UDP 那样向不同地址建立连接时使用同一个 Src IP + Src Port。

要实现这个效果就需要使用 Linux 中的端口重用技术。端口重用技术运行我们使用同一个 Src IP + Src Port 向不同的目的地址发起 TCP 连接。

下面是用 Go 实现的 Demo:

```go
package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"syscall"
	"time"
)

func main() {
	addr, err := net.ResolveTCPAddr("tcp", ":34567")
	if err != nil {
		panic(err)
	}

	dialer := net.Dialer{
		LocalAddr: addr,
		Control: func(network, address string, c syscall.RawConn) error {
			return c.Control(func(fd uintptr) {
				syscall.SetsockoptInt(int(fd), syscall.SOL_SOCKET, syscall.SO_REUSEADDR, 1)
				syscall.SetsockoptInt(int(fd), syscall.SOL_SOCKET, 0xf, 1)
			})
		},
	}

	go func() {
		listen := net.ListenConfig{
			Control: func(network, address string, c syscall.RawConn) error {
				return c.Control(func(fd uintptr) {
					syscall.SetsockoptInt(int(fd), syscall.SOL_SOCKET, syscall.SO_REUSEADDR, 1)
					syscall.SetsockoptInt(int(fd), syscall.SOL_SOCKET, 0xf, 1)
				})
			},
		}

		tcp, err := listen.Listen(context.Background(), "tcp", ":34567")
		if err != nil {
			panic(err)
		}
		log.Printf("start listen at %s ...", tcp.Addr())

		for {
			conn, err := tcp.Accept()
			if err != nil {
				panic(err)
			}

			log.Printf("accept new conn: %s -> %s", conn.RemoteAddr(), conn.LocalAddr())
		}
	}()

	conn1, err := dialer.Dial("tcp", "stun server")
	if err != nil {
		panic(err)
	}
	log.Printf("%s -> %s", conn1.LocalAddr(), conn1.RemoteAddr())

	log.Println("输入对端地址: ")
	var peer string
	fmt.Scanln(&peer)
	log.Printf("对端地址: %s", peer)

	for i := 0; i < 10; i++ {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		conn, err := dialer.DialContext(ctx, "tcp", peer)
		cancel()
		if err != nil {
			log.Printf("第 %d 次连接 %s 失败: %s", i, peer, err)
			time.Sleep(5 * time.Second)
			continue
		}
		log.Printf("%s -> %s", conn.LocalAddr(), conn.RemoteAddr())
        break
	}
}

```

上面的 Demo 中，TCP dial 和 listen 在同一个 Src IP + Src Port 上，进行多次尝试之后就能达到与 UDP 一样的 P2P 打洞效果。