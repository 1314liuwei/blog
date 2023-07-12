# BPF 使用

## BPF 介绍

在使用 RawSocket 时，Linux 内核会将符合 RawSocket 捕获协议的包直接复制到 RawSocket。

由于 RawSocket 只能单纯的指定协议，没法指定更详细的过滤条件，这会导致有大量无用的包被送到与用户程序中进行处理，这极大的影响了程序的处理效率。

BPF 的作用就是使用更为详细的条件对包进行过滤。

### 编写 BPF 程序

在 Go 中，可通过 `golang.org/x/net/bpf` 包编写 BPF 程序。

例如在官方给出的实例中，就定义了一个过滤 ARP 包的语法：

```go
bpf.Assemble([]bpf.Instruction{
    // 加载协议类型到寄存器
	bpf.LoadAbsolute{Off: 12, Size: 2},
	// 如果值为 0x0806 （ARP），则执行下一行。否则跳过下一行
	bpf.JumpIf{Cond: bpf.JumpNotEqual, Val: 0x0806, SkipTrue: 1},
	// 返回这个包的最多 4096 字节的数据
	bpf.RetConstant{Val: 4096},
	// 返回这个包的最多 0 字节的数据，即忽略这个包
	bpf.RetConstant{Val: 0},
})
```

根据官方示例，我们可以写一个过滤 UDP 端口为 8080 包的过滤器：

```go
bpf.Assemble([]bpf.Instruction{
    // 加载端口值到寄存器
	bpf.LoadAbsolute{Off: 22, Size: 2},
	// 如果值为 8080，则执行下一行。否则跳过下一行
	bpf.JumpIf{Cond: bpf.JumpNotEqual, Val: 8080, SkipTrue: 1},
	// 返回这个包的最多 0xffff 字节的数据
	bpf.RetConstant{Val: 0xffff},
	// 返回这个包的最多 0 字节的数据，即忽略这个包
	bpf.RetConstant{Val: 0},
})
```

同时 bpf 包还支持直接使用原始 BPF 语法编写过滤器。在 `tcpdump`程序中，`-ddd`（`-d`生成BPF 汇编代码，`-dd`生成以 C 语言结构体的形式表示的 BPF 过滤器程序）参数将 BPF 过滤器程序以 BPF 指令的形式输出。

如下面的示例中，过滤 TCP 协议，端口为8080的包：

```bash
[root@Aliyun ~]# tcpdump -d tcp port 8080
(000) ldh      [12]
(001) jeq      #0x86dd          jt 2    jf 8
(002) ldb      [20]
(003) jeq      #0x6             jt 4    jf 19
(004) ldh      [54]
(005) jeq      #0x1f90          jt 18   jf 6
(006) ldh      [56]
(007) jeq      #0x1f90          jt 18   jf 19
(008) jeq      #0x800           jt 9    jf 19
(009) ldb      [23]
(010) jeq      #0x6             jt 11   jf 19
(011) ldh      [20]
(012) jset     #0x1fff          jt 19   jf 13
(013) ldxb     4*([14]&0xf)
(014) ldh      [x + 14]
(015) jeq      #0x1f90          jt 18   jf 16
(016) ldh      [x + 16]
(017) jeq      #0x1f90          jt 18   jf 19
(018) ret      #262144
(019) ret      #0
[root@Aliyun ~]# tcpdump -dd tcp port 8080
{ 0x28, 0, 0, 0x0000000c },
{ 0x15, 0, 6, 0x000086dd },
{ 0x30, 0, 0, 0x00000014 },
{ 0x15, 0, 15, 0x00000006 },
{ 0x28, 0, 0, 0x00000036 },
{ 0x15, 12, 0, 0x00001f90 },
{ 0x28, 0, 0, 0x00000038 },
{ 0x15, 10, 11, 0x00001f90 },
{ 0x15, 0, 10, 0x00000800 },
{ 0x30, 0, 0, 0x00000017 },
{ 0x15, 0, 8, 0x00000006 },
{ 0x28, 0, 0, 0x00000014 },
{ 0x45, 6, 0, 0x00001fff },
{ 0xb1, 0, 0, 0x0000000e },
{ 0x48, 0, 0, 0x0000000e },
{ 0x15, 2, 0, 0x00001f90 },
{ 0x48, 0, 0, 0x00000010 },
{ 0x15, 0, 1, 0x00001f90 },
{ 0x6, 0, 0, 0x00040000 },
{ 0x6, 0, 0, 0x00000000 },
[root@Aliyun ~]# tcpdump -ddd tcp port 8080
20
40 0 0 12
21 0 6 34525
48 0 0 20
21 0 15 6
40 0 0 54
21 12 0 8080
40 0 0 56
21 10 11 8080
21 0 10 2048
48 0 0 23
21 0 8 6
40 0 0 20
69 6 0 8191
177 0 0 14
72 0 0 14
21 2 0 8080
72 0 0 16
21 0 1 8080
6 0 0 262144
6 0 0 0
```

将上面的 `-ddd`输出的 BPF 程序转换为 Go 代码：

```go
var assembled = []bpf.RawInstruction{
	{40, 0, 0, 12},
	{21, 0, 6, 34525},
	{48, 0, 0, 20},
	{21, 0, 15, 6},
	{40, 0, 0, 54},
	{21, 12, 0, 8080},
	{40, 0, 0, 56},
	{21, 10, 11, 8080},
	{21, 0, 10, 2048},
	{48, 0, 0, 23},
	{21, 0, 8, 6},
	{40, 0, 0, 20},
	{69, 6, 0, 8191},
	{177, 0, 0, 14},
	{72, 0, 0, 14},
	{21, 2, 0, 8080},
	{72, 0, 0, 16},
	{21, 0, 1, 8080},
	{6, 0, 0, 262144},
	{6, 0, 0, 0},
}
```

## 设置 BPF 过滤

要为 Go 标准库的 `net.PacketConn` 设置BPF过滤，有两种种方法，

1. 调用`syscall.SetsockoptInt`进行设置；
2. [golang.org/x/net/ipv4](https://pkg.go.dev/golang.org/x/net/ipv4#PacketConn.SetBPF)提供了`SetBPF`方法，可以直接将标准库的 `net.PacketConn`转换成`ipv4.PacketConn`，再进行设置。



**调用 `syscall.SetsockoptInt`进行设置：**

```go
package main

import (
	"net"
	"unsafe"

	"golang.org/x/net/bpf"
	"golang.org/x/sys/unix"
)

func main() {
	filter, err := bpf.Assemble([]bpf.Instruction{
		// 加载端口值到寄存器
		bpf.LoadAbsolute{Off: 22, Size: 2},
		// 如果值为 8080，则执行下一行。否则跳过下一行
		bpf.JumpIf{Cond: bpf.JumpNotEqual, Val: 8080, SkipTrue: 1},
		// 返回这个包的最多 0xffff 字节的数据
		bpf.RetConstant{Val: 0xffff},
		// 返回这个包的最多 0 字节的数据，即忽略这个包
		bpf.RetConstant{Val: 0},
	})
	if err != nil {
		panic(err)
	}

	conn, err := net.ListenPacket("ip:17", "")
	if err != nil {
		panic(err)
	}

	raw, err := conn.(*net.IPConn).SyscallConn()
	if err != nil {
		panic(err)
	}

	prog := &unix.SockFprog{
		Len:    uint16(len(filter)),
		Filter: (*unix.SockFilter)(unsafe.Pointer(&filter[0])),
	}

	var setErr error
	err = raw.Control(func(fd uintptr) {
		setErr = unix.SetsockoptSockFprog(int(fd), unix.SOL_SOCKET, unix.SO_ATTACH_FILTER, prog)
	})
	if err != nil {
		panic(err)
	}
	if setErr != nil {
		panic(err)
	}
}
```



**通过 SetPBF设置：**

```go
package main

import (
	"net"

	"golang.org/x/net/bpf"
	"golang.org/x/net/ipv4"
)

func main() {
	filter, err := bpf.Assemble([]bpf.Instruction{
		// 加载端口值到寄存器
		bpf.LoadAbsolute{Off: 22, Size: 2},
		// 如果值为 8080，则执行下一行。否则跳过下一行
		bpf.JumpIf{Cond: bpf.JumpNotEqual, Val: 8080, SkipTrue: 1},
		// 返回这个包的最多 0xffff 字节的数据
		bpf.RetConstant{Val: 0xffff},
		// 返回这个包的最多 0 字节的数据，即忽略这个包
		bpf.RetConstant{Val: 0},
	})
	if err != nil {
		panic(err)
	}

	conn, err := net.ListenPacket("ip:17", "")
	if err != nil {
		panic(err)
	}

	pc := ipv4.NewPacketConn(conn)
	err = pc.SetBPF(filter)
	if err != nil {
		panic(err)
	}
}
```

