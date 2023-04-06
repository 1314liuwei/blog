# Go IP 套接字编程

## ICMP 监听

```go
package main

import (
	"fmt"
	"net"

	"golang.org/x/net/icmp"
)

func main() {
	// 这里的ipv4地址是指该程序运行的操作系统的网卡地址
	netaddr, _ := net.ResolveIPAddr("ip4", "127.0.0.1")
	// 这里可以指定"网络层协议:子协议"参数，前者可以取ip4/ip6，后者主要有icmp/igmp/tcp/udp/ipv6/icmp
	conn, _ := net.ListenIP("ip4:icmp", netaddr)
	for {
		buf := make([]byte, 1024)
		n, addr, _ := conn.ReadFrom(buf)
		msg, _ := icmp.ParseMessage(1, buf[0:n])
		fmt.Println(n, addr, msg.Type, msg.Code, msg.Checksum)
	}
}
```

## TCP 监听

```go
package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
)

func main() {
	netaddr, _ := net.ResolveIPAddr("ip4", "172.17.0.3")
	// 注意，这里修改了监听协议
	conn, _ := net.ListenIP("ip4:tcp", netaddr)
	for {
		// 缓冲区大小和TCP包大小匹配
		buf := make([]byte, 1480)
		n, addr, _ := conn.ReadFrom(buf)
		// 这里用别人写好的函数解析了一下TCP首部，默认20字节
		tcpheader := NewTCPHeader(buf[0:n])
		fmt.Println(n, addr, tcpheader)
	}
}

/*
Copyright 2013-2014 Graham King
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License (GPLv3)
*/

type TCPHeader struct {
	Source      uint16
	Destination uint16
	SeqNum      uint32
	AckNum      uint32
	DataOffset  uint8 // 4 bits
	Reserved    uint8 // 3 bits
	ECN         uint8 // 3 bits
	Ctrl        uint8 // 6 bits
	Window      uint16
	Checksum    uint16 // Kernel will set this if it's 0
	Urgent      uint16
}

// Parse packet into TCPHeader structure
func NewTCPHeader(data []byte) *TCPHeader {
	var tcp TCPHeader
	r := bytes.NewReader(data)
	binary.Read(r, binary.BigEndian, &tcp.Source)
	binary.Read(r, binary.BigEndian, &tcp.Destination)
	binary.Read(r, binary.BigEndian, &tcp.SeqNum)
	binary.Read(r, binary.BigEndian, &tcp.AckNum)

	var mix uint16
	binary.Read(r, binary.BigEndian, &mix)
	tcp.DataOffset = byte(mix >> 12)  // top 4 bits
	tcp.Reserved = byte(mix >> 9 & 7) // 3 bits
	tcp.ECN = byte(mix >> 6 & 7)      // 3 bits
	tcp.Ctrl = byte(mix & 0x3f)       // bottom 6 bits

	binary.Read(r, binary.BigEndian, &tcp.Window)
	binary.Read(r, binary.BigEndian, &tcp.Checksum)
	binary.Read(r, binary.BigEndian, &tcp.Urgent)

	return &tcp
}

func (tcp *TCPHeader) String() string {
	if tcp == nil {
		return "<nil>"
	}
	return fmt.Sprintf("Source=%v Destination=%v SeqNum=%v AckNum=%v DataOffset=%v Reserved=%v ECN=%v Ctrl=%v Window=%v Checksum=%v Urgent=%v", tcp.Source, tcp.Destination, tcp.SeqNum, tcp.AckNum, tcp.DataOffset, tcp.Reserved, tcp.ECN, tcp.Ctrl, tcp.Window, tcp.Checksum)
}
```

