# Go 实现端口映射

```go
package main

import (
        "io"
        "net"
)

func main() {
        localIP, localPort := net.ParseIP("0.0.0.0"), 80
        remoteIP, remotePort := net.ParseIP("10.0.2.2"), 8080
        localTCP, err := net.ListenTCP("tcp", &net.TCPAddr{IP: localIP, Port: localPort})
        if err != nil {
                return
        }

        for {
                conn, err := localTCP.Accept()
                if err != nil {
                        return
                }
                NewPortMap(remoteIP, remotePort, conn)
        }
}

func NewPortMap(remoteIP net.IP, remotePort int, conn net.Conn) {
        remoteTCP, err := net.DialTCP("tcp", nil, &net.TCPAddr{IP: remoteIP, Port: remotePort})
        if err != nil {
                panic(err)
                return
        }
        go func() {
                io.Copy(remoteTCP, conn)
        }()
        go func() {
                io.Copy(conn, remoteTCP)
        }()
}
```

