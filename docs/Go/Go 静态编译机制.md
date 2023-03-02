# Go 静态编译机制

## 一、Go 的可移植性

众所周知，Go 具有良好的跨平台可移植性，Go 还提供了交叉编译的功能，运行我们在一个平台上编译出另外一个平台可执行的二进制代码。

在Go 1.7及以后版本中，我们可以通过下面命令查看Go支持OS和平台列表：

```bash
$ go tool dist list
aix/ppc64
android/386
android/amd64
android/arm
android/arm64
darwin/amd64
darwin/arm64
dragonfly/amd64
freebsd/386
freebsd/amd64
freebsd/arm
freebsd/arm64
illumos/amd64
ios/amd64
ios/arm64
js/wasm
linux/386
linux/amd64
linux/arm
linux/arm64
linux/mips
linux/mips64
linux/mips64le
linux/mipsle
linux/ppc64
linux/ppc64le
linux/riscv64
linux/s390x
netbsd/386
netbsd/amd64
netbsd/arm
netbsd/arm64
openbsd/386
openbsd/amd64
openbsd/arm
openbsd/arm64
openbsd/mips64
plan9/386
plan9/amd64
plan9/arm
solaris/amd64
windows/386
windows/amd64
windows/arm
windows/arm64
```

可以发现从 **linux/arm64**的嵌入式系统到 **linux/s390x** 的大型机系统，再到Windows、linux和 darwin(mac)这样的主流操作系统、amd64、386这样的主流处理器体系，Go 对各种平台和操作系统的支持确实十分广泛。

Go 的运行机制发现 Go 程序是通过 `runtime` 这个库实现与操作内核系统交互的。Go 自己实现了 `runtime`，并封装了`syscall`，为不同平台上的`go user level`代码提供封装完成的、统一的go标准库。

![img{512x368}](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/auto-go-runtime-vs-c-runtime.png)

## 二、Go 的静态链接

首先我们来书写两个程序，一个 C语言的一个 Go 语言的：

```c
# hello.c
#include <stdio.h>

int main() {
    printf("Hello, C!\n");
    return 0;
}
```

编译后使用 `ldd` 命令查看其链接库：

```bash
# 1. 编译
gcc -o hc hello.c

# 2. 查看其依赖共享库
ldd hc

linux-vdso.so.1 =>  (0x00007fff85b6e000)
libc.so.6 => /lib64/libc.so.6 (0x00007fe87ff1a000)
/lib64/ld-linux-x86-64.so.2 (0x00007fe8802e8000)
```

我们发现这个 C程序编译出来后的二进制文件会需要这三个库文件，因此如果我们将它做移植时会因为缺失动态库文件而造成无法运行。

接下来我们再试一下 Go 语言的：

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello Go!")
}
```

```bash
# 1. 编译
go build -o hgo hello.go

# 2. 查看依赖
ldd hgo

不是动态可执行文件
```

我们发现 Go 编译出来的二进制文件是没有需要依赖的共享库的。

我们再比较一下两个文件的大小：

```bash
ll -h

-rwxr-xr-x. 1 root root 8.2K 9月  15 10:36 hc
-rwxr-xr-x. 1 root root 1.7M 9月  15 10:42 hgo
```

我们可以发现 Go 编译出来的二进制文件比 C 语言编译出来的文件会大的多，这其实就是因为 Go 在编译时会将依赖库一起编译进二进制文件的缘故。

## 三、cgo 影响可移植性

虽然Go默认情况下是采取的静态编译。但是，**不是所有情况下，Go都不会依赖外部动态共享库**！

我们来看看下面这段代码：

```go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
	})

	http.ListenAndServe(":80", nil)
}
```

```bash
go build -o server server.go
ldd server

linux-vdso.so.1 =>  (0x00007ffd96be5000)
libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f577ade9000)
libc.so.6 => /lib64/libc.so.6 (0x00007f577aa1b000)
/lib64/ld-linux-x86-64.so.2 (0x00007f577b005000)
```

编译后我们发现，默认采用 “静态链接” 的 Go 程序怎么也要依赖外部的动态链接库了呢？问题在于 `Cgo`。

> 自C语言出现，已经累积了无数功能强大、性能卓越的C语言代码库，可以说难以替代；为了方便快捷的使用这些C语言库，Go语言提供 Cgo，可以用以在 Go 语言中调用 C语言库。

默认情况下 Go 语言是使用 Cgo 对 Go 程序进行构建的。当使用 Cgo 进行构建时，如果我们使用的包里用着使用 C 语言支持的代码，那么最终编译的可执行文件都是要有外部依赖的。

正因为这样才会导致我们编译出来的 Go 程序会有着一些外部依赖。

## 四、纯静态编译

为了使我们编译的程序有着更好的可移植性，我们需要进行纯静态编译。有两种方式可以帮助我们进行纯静态编译：

### 1. CGO_ENABLED=0

默认情况下，`CGO_ENABLED=1`，代表着启用 Cgo 进行编译。我们如果将 `CGO_ENABLED` 置为 0，那么就可以关闭 Cgo：

```bash
 CGO_ENABLED=0 go build -o server server.go
 ldd server
 
 不是动态可执行文件
```

### 2. 采用external linker

cmd/link 有两种工作模式：`internal linking`和`external linking`。

- `internal linking`：若用户代码中仅仅使用了 net、os/user 等几个标准库中的依赖 cgo 的包时，cmd/link 默认使用 `internal linking`，而无需启动外部external linker(如:gcc、clang等)；
- `external linking`：将所有生成的.o都打到一个`.o`文件中，再将其交给外部的链接器，比如 gcc 或 clang 去做最终链接处理。

 如果我们在写入参数 `-ldflags '-linkmode "external" -extldflags "-static"'`，那么 gcc/clang 将会去做静态链接，将`.o`中`undefined`的符号都替换为真正的代码，从而达到纯静态编译的目的：

```bash
go build -o server -ldflags '-linkmode "external" -extldflags "-static"' server.go
ldd

 不是动态可执行文件
```

如果在编译时出现以下错误：

```
# ahhub.io/dbox/cmd/app
/usr/local/go/pkg/tool/linux_amd64/link: running gcc failed: exit status 1
/usr/bin/ld: 找不到 -lpthread
/usr/bin/ld: 找不到 -lc
collect2: 错误：ld 返回 1
```

这是因为缺失依赖，下载依赖即可：

```shell
yum install glibc-static.x86_64 -y
```

> 参考链接：
>
> [CGO_ENABLED环境变量对Go静态编译机制的影响 – 碎言碎语 (johng.cn)](https://johng.cn/cgo-enabled-affect-go-static-compile/#internal_linkingexternal_linking)

