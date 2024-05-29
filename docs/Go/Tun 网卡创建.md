# Tun 网卡创建

> 在 Linux 2.4 及其以后的版本中，有一种名为tun的特殊虚拟网络设备。用户可以直接创建虚拟网卡tun，并通过文件读写方式从该设备处读取到网络层数据包（IP 数据包）。
>
> 使用该虚拟网卡，用户可像配置真实网卡一样设置 IP 地址、配置路由信息并进行数据读写操作。这些数据读写操作需要借助用户编写的程序来完成。
>
> 使用 TUN/TAP 进行读取和写入，与数据报套接字上的读取和写入非常相似，必须针对完整的数据包。如果读入的缓冲区太小而无法容纳完整的数据包，则缓冲区将被填满，数据包的其余部分将被丢弃。对于写入，如果写入部分数据包，驱动程序将认为这是一个完整的数据包，并通过隧道设备传递截断的数据包。

## Linux 环境

```go
package main

import (
	"fmt"
	"os"

	"golang.org/x/sys/unix"
)

func main() {
	tun, err := CreateTUN("tun0")
	if err != nil {
		return
	}

	// read data from tun
	buff := make([]byte, 1500)
	n, err := tun.Read(buff)
	if err != nil {
		panic(err)
	}

	// write data to tun
	_, err = tun.Write(buff[:n])
	if err != nil {
		panic(err)
	}
}

const (
	cloneDevicePath = "/dev/net/tun"
)

func CreateTUN(name string) (*os.File, error) {
	// open the clone device path
	tfd, err := unix.Open(cloneDevicePath, unix.O_RDWR|unix.O_CLOEXEC, 0)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, fmt.Errorf("CreateTUN(%q) failed; %s does not exist", name, cloneDevicePath)
		}
		return nil, err
	}

	// create a new Ifreq instance for the specified device name
	ifreq, err := unix.NewIfreq(name)
	if err != nil {
		return nil, err
	}

	// unix.IFF_TUN: TUN device
	// unix.IFF_NO_PI: no need to provide package information
	ifreq.SetUint16(unix.IFF_TUN | unix.IFF_NO_PI)
	err = unix.IoctlIfreq(tfd, unix.TUNSETIFF, ifreq)
	if err != nil {
		return nil, err
	}

	// set the current file descriptor to non-blocking status to improve concurrency
	err = unix.SetNonblock(tfd, true)
	if err != nil {
		return nil, err
	}

	// Create a new os.File object representing the created TUN device.
	file := os.NewFile(uintptr(tfd), cloneDevicePath)

	return file, nil
}
```

上面的代码中，创建出来的 `*os.File` 对象就是一个 tun 网卡实例，可以对其进行读写操作。

## Windows 环境

Windows 环境下创建 TUN 网卡需要用到一个驱动程序: `wintun.dll`。这个驱动程序是由 WireGuard 团队编写并开源的，官网地址：https://www.wintun.net/。

Windows接口驱动的开发和安装通常比较复杂，需要使用一些常见的驱动安装包，如：.inf文件、.sys文件和.cat文件。此外，在安装过程中还必须进行驱动程序签名，否则无法成功安装。在开发和调试阶段，每次都需要进行签名，这个过程可能会显得繁琐。

但是 wintun.dll 接口用法非常简单高效：

1. 引入头文件：`wintun.h`
2. 加载动态库，解析动态库中的函数指针

它提供了一种基于**动态库**的接口方式，我们可以加载该动态库并调用其中的函数指针来创建、销毁和收发虚拟接口数据包等操作。

WireGuard 官方提供了 `golang.zx2c4.com/wintun` 库，该库已经对 wintun.dll 进行了封装，直接调用该库即可在 Windows 上创建 TUN 网卡：

```go
package main

import (
	"golang.org/x/sys/windows"
	"golang.zx2c4.com/wintun"
)

func main() {
	tun, err := CreateTUN("tun0")
	if err != nil {
		return
	}

	// read data from tun
	packet, err := tun.ReceivePacket()
	if err != nil {
		panic(err)
	}

	// write data to tun
	tun.SendPacket(packet)
}

func CreateTUN(name string) (*wintun.Session, error) {
    // generate a new GUID
	guid, err := windows.GenerateGUID()
	if err != nil {
		return nil, err
	}

	// create a Wintun adapter with the specified name and description
	wt, err := wintun.CreateAdapter(name, "TUNDemo", &guid)

	// start a new Wintun session with a ring capacity of 8 MiB
	session, err := wt.StartSession(0x800000)
	if err != nil {
		return nil, err
	}

    // return a pointer to the session
	return &session, nil
}
```

