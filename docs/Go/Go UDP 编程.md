# Go UDP 编程

## CS 模型

**Server：**

```go
package main

import (
	"fmt"
	"net"
)

func main() {
	listen, err := net.ListenUDP("udp", &net.UDPAddr{IP: net.ParseIP("127.0.0.1"), Port: 12345})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("Local: <%s> \n", listen.LocalAddr().String())
	data := make([]byte, 1024)
	for {
		n, remoteAddr, err := listen.ReadFromUDP(data)
		if err != nil {
			fmt.Printf("error during read: %s", err)
		}
		fmt.Printf("<%s> %s\n", remoteAddr, data[:n])
		_, err = listen.WriteToUDP([]byte("world"), remoteAddr)
		if err != nil {
			fmt.Printf(err.Error())
		}
	}
}
```

**Client：**

```go
package main

import (
	"fmt"
	"net"
)

func main() {
	dstAddr := &net.UDPAddr{IP: net.ParseIP("127.0.0.1"), Port: 12345}
	conn, err := net.DialUDP("udp", nil, dstAddr)
	if err != nil {
		fmt.Println(err)
	}
	defer conn.Close()
	conn.Write([]byte("hello"))
	fmt.Printf("<%s>\n", conn.RemoteAddr())
}
```

## 等价节点

由于 UDP socket 是一个二元组，因为我们可以监听本地套接字，因此可以接收任意地址来的包，也可以向任意地址发包。

双端都监听本地套接字，并接收任意地址的包，因此双端此时都是一个等价的节点。

```go
package main

import (
	"fmt"
	"net"
)

func main() {
	listen, err := net.ListenUDP("udp", &net.UDPAddr{IP: net.ParseIP("127.0.0.1"), Port: 12345})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("Local: <%s> \n", listen.LocalAddr().String())
	data := make([]byte, 1024)
	for {
		n, remoteAddr, err := listen.ReadFromUDP(data)
		if err != nil {
			fmt.Printf("error during read: %s", err)
		}
		fmt.Printf("<%s> %s\n", remoteAddr, data[:n])
		_, err = listen.WriteToUDP([]byte("world"), remoteAddr)
		if err != nil {
			fmt.Printf(err.Error())
		}
	}
}
```

