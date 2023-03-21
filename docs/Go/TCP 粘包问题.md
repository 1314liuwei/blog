# TCP 粘包问题

## 问题复现

先来看一个简单的 tcp cs的例子：

```go
// server.go
package main

import (
	"fmt"
	"net"
)

func main() {
	listen, err := net.Listen("tcp", "127.0.0.1:8080")
	if err != nil {
		return
	}
	defer listen.Close()

	for {
		conn, err := listen.Accept()
		if err != nil {
			return
		}
		fmt.Printf("local: %s -> remote: %s \n", conn.LocalAddr(), conn.RemoteAddr())
		for i := 0; i < 100; i++ {
			_, err := conn.Write([]byte(fmt.Sprintf("hello %d", i)))
			if err != nil {
				return
			}
		}
	}
}
```

```go
// client.go
package main

import (
	"fmt"
	"net"
)

func main() {
	dial, err := net.Dial("tcp", "127.0.0.1:8080")
	if err != nil {
		return
	}
	defer dial.Close()

	for i := 0; i < 100; i++ {
		buff := make([]byte, 1024)
		read, err := dial.Read(buff)
		if err != nil {
			return
		}
		fmt.Println(fmt.Sprintf("length: %d packet: [%s]", read, string(buff[:read])))
	}
}
```

运行两个程序，会发现客户端得到了类似输出：

```bash
length: 7 packet: [hello 0]
length: 71 packet: [hello 1hello 2hello 3hello 4hello 5hello 6hello 7hello 8hello 9hello 10]
length: 32 packet: [hello 11hello 12hello 13hello 14]
length: 16 packet: [hello 15hello 16]
length: 40 packet: [hello 17hello 18hello 19hello 20hello 21]
length: 32 packet: [hello 22hello 23hello 24hello 25]
length: 16 packet: [hello 26hello 27]
length: 24 packet: [hello 28hello 29hello 30]
length: 8 packet: [hello 41]
length: 16 packet: [hello 42hello 43]
length: 16 packet: [hello 44hello 45]
length: 16 packet: [hello 46hello 47]
length: 16 packet: [hello 48hello 49]
length: 16 packet: [hello 50hello 51]
length: 24 packet: [hello 52hello 53hello 54]
length: 24 packet: [hello 55hello 56hello 57]
length: 16 packet: [hello 58hello 59]
length: 16 packet: [hello 60hello 61]
length: 24 packet: [hello 62hello 63hello 64]
length: 120 packet: [hello 65hello 66hello 67hello 68hello 69hello 70hello 71hello 72hello 73hello 74hello 75hello 76hello 77hello 78hello 79]
length: 56 packet: [hello 80hello 81hello 82hello 83hello 84hello 85hello 86]
length: 32 packet: [hello 87hello 88hello 89hello 90]
length: 24 packet: [hello 91hello 92hello 93]
length: 24 packet: [hello 94hello 95hello 96]
length: 24 packet: [hello 97hello 98hello 99]
```

我们发现，客户端出现得到的包**顺序是正确的**，但是存在**多个包重叠在一起被读出来**的情况。

抓包发现 tcp 的每次传输都是分离的：

![image-20230320230014217](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20230320230014217.png)

但是我们接收的时候部分 tcp 粘合在一起被我们读出来，这种情况就是 **TCP 粘包问题**。

## 问题解读

“TCP 粘包问题” 准确来说不是一个问题，这本身就是 TCP 的特性：

> **传输控制协议**（英语：**T**ransmission **C**ontrol **P**rotocol，缩写：**TCP**）是一种面向连接的、可靠的、基于[字节流](https://zh.wikipedia.org/wiki/字節流)的[传输层](https://zh.wikipedia.org/wiki/传输层)通信协议，由[IETF](https://zh.wikipedia.org/wiki/IETF)的[RFC](https://zh.wikipedia.org/wiki/RFC) [793](https://tools.ietf.org/html/rfc793)定义。在简化的计算机网络[OSI模型](https://zh.wikipedia.org/wiki/OSI模型)中，它完成第四层传输层所指定的功能。[用户数据报协议](https://zh.wikipedia.org/wiki/用户数据报协议)（UDP）是同一层内另一个重要的传输协议。

TCP 是一种流式传输的协议，数据包在发送和接收的时候都会先存储在缓冲区。
