# Socket Takeover

在 Meta 的[《Zero Downtime Release:Disruption-free Load Balancing of a Multi-Billion User Website》](https://dl.acm.org/doi/pdf/10.1145/3387514.3405885)论文中提到了一种 **Socket Takeover** 技术，

该技术能够 **将一个打开的 Socket FD 从旧进程传递到新进程**。

## 相关技术

###  file descriptor

要理解这项技术，首先要明白 Linux 的 file descriptor。file descriptor （简称 fd）是一个抽象的指示符，以一个非负整数来表示。fd 和底层文件系统中的文件进行绑定，fd 只在打开文件的进程有效。

如果把 fd 当作一个普通的值传递给其他进程用于打开，其他进程是无法使用这个 fd 的。

### Unix domain socket

Unix domain socket（简称 uds）是在 unix 环境下的一种特殊的 socket。uds 地址采用路径名的形式。与网络套接字不同，跨 Unix 域套接字的 I/O 不涉及底层设备上的操作（这使得 Unix 域套接字比在同一主机上执行 IPC 的网络套接字要快得多）。

uds 在传输数据时，除了能够像普通的 socket 那样传输数据，还能够进行特殊的 **辅助数据传输（Ancillary Data Transfer ）**。

在 Linux 上可以进行三种类型的辅助数据传输：

- `SCM_RIGHTS`
- `SCM_CREDENTIALS`
- `SCM_SECURITY`

在实现 Socket Takeover 时就需要使用到 `SCM_RIGHTS`。

`SCM_RIGHTS`  能够在不同进程之间传递 file descriptor（更准确来说是传递的文件所有权，类似于父子进程之间能够共享文件）。

## 实现

下面是用 Go 实现的 Socket Takeover demo，该demo中包含三个模块：client（TCP 客户端）、server（TCP server）和forward（UDS Server）。



```go
// client.go
package main

import (
	"fmt"
	"log"
	"net"
)

func main() {
	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:8080")
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < 20; i++ {
		conn, err := net.DialTCP("tcp", nil, addr)
		if err != nil {
			return
		}

		conn.Write([]byte(fmt.Sprintf("seq num %d", i)))
		buff := make([]byte, 1024)
		n, err := conn.Read(buff)
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("recv data: %s\n", buff[:n])
		conn.Close()
	}
}
```



```go
// server.go
package main

import (
	"log"
	"net"
	"syscall"
)

const (
	forwardSocket = "/tmp/forward_demo.sock"
)

func main() {
	addr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:8080")
	if err != nil {
		log.Fatal(err)
	}

	tcp, err := net.ListenTCP("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}

	for {
		conn, err := tcp.AcceptTCP()
		if err != nil {
			log.Fatal(err)
		}
		handle(conn)
	}
}

func handle(conn *net.TCPConn) {
	defer conn.Close()

	err := forwardConn(conn)
	if err != nil {
		log.Printf("fail to forward conn: %v", err)

		buff := make([]byte, 1024)
		n, err := conn.Read(buff)
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("recv data: %s\n", buff[:n])
		conn.Write([]byte("process by server"))
	}
}

func forwardConn(conn *net.TCPConn) error {
	addr := &net.UnixAddr{
		Name: forwardSocket,
		Net:  "unix",
	}

	unixConn, err := net.DialUnix("unix", nil, addr)
	if err != nil {
		return err
	}
	defer unixConn.Close()

	file, err := conn.File()
	if err != nil {
		return err
	}

	datan, oobn, err := unixConn.WriteMsgUnix([]byte("forward"), syscall.UnixRights(int(file.Fd())), nil)
	if err != nil {
		return err
	}
	log.Printf("%d bytes and %d oob written successfully", datan, oobn)

	return nil
}
```



```go
// forward.go
package main

import (
	"errors"
	"fmt"
	"log"
	"net"
	"os"
	"syscall"
)

const (
	forwardSocket = "/tmp/forward_demo.sock"
)

func main() {
	syscall.Unlink(forwardSocket)
	unixListener, err := net.ListenUnix("unix", &net.UnixAddr{Name: forwardSocket, Net: "unix"})
	if err != nil {
		panic(err)
	}

	for {
		unixConn, err := unixListener.AcceptUnix()
		if err != nil {
			panic(err)
		}

		tcp, err := unixToTCP(unixConn)
		if err != nil {
			panic(err)
		}

		buff := make([]byte, 1024)
		n, err := tcp.Read(buff)
		if err != nil {
			panic(err)
		}
		log.Printf("tcp %s -> %s: %s", tcp.LocalAddr(), tcp.RemoteAddr(), buff[:n])
		tcp.Write([]byte("process by forward"))
		tcp.Close()
	}
}

func unixToTCP(conn *net.UnixConn) (*net.TCPConn, error) {
	msg, oob := make([]byte, 128), make([]byte, 128)

	msgn, oobn, flag, addr, err := conn.ReadMsgUnix(msg, oob)
	if err != nil {
		return nil, err
	}
	log.Println(msgn, oobn, flag, addr)
	log.Printf("recv msg: %s", msg[:msgn])

	cmsgs, err := syscall.ParseSocketControlMessage(oob[0:oobn])
	if err != nil {
		return nil, err
	}

	if len(cmsgs) != 1 {
		return nil, fmt.Errorf("expected 1 control message; got %d", len(cmsgs))
	}

	fds, err := syscall.ParseUnixRights(&cmsgs[0])
	if err != nil {
		return nil, err
	} else if len(fds) != 1 {
		return nil, errors.New("invalid number of fds received")
	}

	fd := os.NewFile(uintptr(fds[0]), "")
	if fd == nil {
		return nil, errors.New("could not open fd")
	}

	fileConn, err := net.FileConn(fd)
	if err != nil {
		return nil, err
	}

	return fileConn.(*net.TCPConn), nil
}
```

