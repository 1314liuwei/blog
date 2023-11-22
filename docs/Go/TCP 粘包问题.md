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

我们接收的时候部分 tcp 数据粘合在一起被我们读出来，这种情况就是 **TCP 粘包问题**。

## 问题解读

“TCP 粘包问题” 准确来说不是一个问题，这本身就是 TCP 的特性：

> **传输控制协议**（英语：**T**ransmission **C**ontrol **P**rotocol，缩写：**TCP**）是一种面向连接的、可靠的、基于[字节流](https://zh.wikipedia.org/wiki/字節流)的[传输层](https://zh.wikipedia.org/wiki/传输层)通信协议，由[IETF](https://zh.wikipedia.org/wiki/IETF)的[RFC](https://zh.wikipedia.org/wiki/RFC) [793](https://tools.ietf.org/html/rfc793)定义。在简化的计算机网络[OSI模型](https://zh.wikipedia.org/wiki/OSI模型)中，它完成第四层传输层所指定的功能。[用户数据报协议](https://zh.wikipedia.org/wiki/用户数据报协议)（UDP）是同一层内另一个重要的传输协议。

TCP 是一种流式传输的协议，数据包在发送和接收的时候都会先存储在缓冲区。TCP 每一次读取数据时会从缓冲区拿到所有数据，如果接收端未及时从缓冲区取出数据，就容易出现粘包现象。

与粘包问题相似的是 TCP 的半包问题：半包问题指 tcp 发送包时数据包只发送了一部分，没有完整发送。

出现半包问题的原因主要在于 TCP 的 Nagle算法，Nagle 算法会让 TCP 在发送缓冲区存放多个小包，然后在发送时一次性将缓冲区内容全部读取出来发送出去。如果数据包在未完全写入缓冲区时，缓冲区已经满了，就会导致 TCP 出现半包现象。

因此粘包和半包实际上都不是 TCP 的问题，是应用层协议没有做好边界解析造成的问题。

## 解决方案

在明白粘包和半包现象出现的根本原因后，我们就可以通过定义上层协议的边界来避免这种问题的出现。

读取数据时将读到的数据放到缓冲区，再按照我们定义的协议对数据进行解析，这样就能避免我们读取时数据解析错误。



代码实现：

```go
package datagram

import (
	"bytes"
	"encoding/binary"
	"errors"
	"io"
)

type Parser struct {
	stream io.ReadWriteCloser
}

var (
	HeaderSize = 6
	HeaderFlag = uint16(0x0d0d)
)

func NewParser(stream io.ReadWriteCloser) *Parser {
	return &Parser{stream: stream}
}

func (p *Parser) Pack(data []byte) error {
	buf := new(bytes.Buffer)

	// 写入包头
	err := binary.Write(buf, binary.BigEndian, HeaderFlag)
	if err != nil {
		return err
	}

	// 写入包长度
	err = binary.Write(buf, binary.BigEndian, uint32(len(data)))
	if err != nil {
		return err
	}

	// 写入原始数据
	_, err = buf.Write(data)
	if err != nil {
		return err
	}

	// 写入流
	_, err = p.stream.Write(buf.Bytes())
	if err != nil {
		return err
	}

	return nil
}

func (p *Parser) Unpack() ([]byte, error) {
	header := make([]byte, HeaderSize)

	// 读取包头
	_, err := io.ReadFull(p.stream, header)
	if err != nil {
		return nil, err
	}

	flag := binary.BigEndian.Uint16(header[:2])
	if flag != HeaderFlag {
		return nil, errors.New("unknown packet")
	}

	// 解析包长度
	packetSize := binary.BigEndian.Uint32(header[2:])

	// 读取包数据
	packetData := make([]byte, packetSize)
	_, err = io.ReadFull(p.stream, packetData)
	if err != nil {
		return nil, err
	}

	return packetData, nil
}
```

