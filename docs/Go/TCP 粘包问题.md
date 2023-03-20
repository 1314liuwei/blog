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

