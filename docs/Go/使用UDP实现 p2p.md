# 使用 UDP 实现 p2p

建立 UDP 的核心是向对端不同的 UDP 地址发送请求，在 Go 中可使用下面的代码实现功能：

```go
package main

import (
	"net"
)

func main() {
	packet, err := net.ListenPacket("udp", "")
	if err != nil {
		panic(err)
	}

	peerAddress := []*net.UDPAddr{}

	for _, address := range peerAddress {
		packet.WriteTo([]byte("attempt"), address)
	}
}
```

