# 实现自定义 TTL UDP 包发送

```go
package main

import (
	"errors" // 用于返回和处理错误
	"fmt"    // 用于格式化输出
	"log"    // 用于日志记录
	"net/netip" // 提供IP地址和端口解析功能
	"syscall"   // 用于系统调用
	"time"      // 用于时间相关的操作

	"github.com/google/gopacket"    // 用于网络数据包处理
	"github.com/google/gopacket/layers" // 提供网络层协议封装
	"github.com/libp2p/go-netroute"    // 用于路由信息获取
	"golang.org/x/sys/unix"           // 提供Unix系统调用
)

const (
	// 最小TTL值，用于短TTL穿透
	MinShortTTL      = 3
	// 最大TTL值，用于短TTL穿透
	MaxShortTTL      = 10
	// 每次尝试发送的包数量
	PunchPacketCount = 5
	// 每次发送包之间的时间间隔
	PunchInterval    = 5 * time.Millisecond
	// 源端口号
	SrcPort          = 13131
)

func main() {
	// 调用shortTTL函数进行短TTL穿透尝试
	err := shortTTL(netip.MustParseAddrPort("111.9.57.80:3439"))
	if err != nil {
		// 如果有错误，终止程序执行
		panic(err)
	}
}

func shortTTL(dst netip.AddrPort) error {
	log.Printf("attempting short TTL hole punch to %s", dst)

	// 检查目标地址是否为IPv4
	isIPv4 := dst.Addr().Is4()
	// 创建一个新的路由查找器
	r, err := netroute.New()
	if err != nil {
		log.Printf("fail to create netroute: %v", err)
	}

	if r == nil {
		return errors.New("not support use shortTTL")
	}

	// 获取路由信息
	_, _, src, err := r.Route(dst.Addr().AsSlice())
	if err != nil {
		return fmt.Errorf("route lookup failed: %w", err)
	}

	var (
		// 套接字文件描述符
		sockFd  int
		// 网络层（IP层）
		ip      gopacket.NetworkLayer
		// 目的地址的套接字地址结构
		dstSock syscall.Sockaddr
	)

	// 根据地址类型（IPv4或IPv6）进行不同的处理
	if isIPv4 {
		// 创建IPv4原始套接字
		sockFd, err = syscall.Socket(syscall.AF_INET, syscall.SOCK_RAW, syscall.IPPROTO_RAW)
		if err != nil {
			return fmt.Errorf("socket creation failed: %w", err)
		}
		// 确保套接字在函数结束时被关闭
		defer syscall.Close(sockFd)

		// 设置IP头包含选项，以便我们可以自己构建IP头
		if err := syscall.SetsockoptInt(sockFd, syscall.IPPROTO_IP, syscall.IP_HDRINCL, 1); err != nil {
			return fmt.Errorf("failed to set IP_HDRINCL: %w", err)
		}

		// 构造IPv4报文
		ip = &layers.IPv4{
			Version:  4,
			IHL:      5, // 头长度
			SrcIP:    src,
			DstIP:    dst.Addr().AsSlice(),
			Protocol: layers.IPProtocolUDP,
		}
		dstSock = &syscall.SockaddrInet4{
			Port: 0,
			Addr: dst.Addr().Unmap().As4(),
		}
	} else {
		// 创建IPv6原始套接字
		sockFd, err = syscall.Socket(syscall.AF_INET6, syscall.SOCK_RAW, syscall.IPPROTO_RAW)
		if err != nil {
			return fmt.Errorf("IPv6 socket creation failed: %w", err)
		}
		defer syscall.Close(sockFd)

		// 设置IPv6头包含选项
		if err := syscall.SetsockoptInt(sockFd, syscall.IPPROTO_IPV6, unix.IPV6_HDRINCL, 1); err != nil {
			return fmt.Errorf("failed to set IPV6_HDRINCL: %w", err)
		}

		// 构造IPv6报文
		ip = &layers.IPv6{
			Version:    6,
			SrcIP:      src,
			DstIP:      dst.Addr().AsSlice(),
			NextHeader: layers.IPProtocolUDP,
		}
		dstSock = &syscall.SockaddrInet6{
			Port: 0,
			Addr: dst.Addr().Unmap().As16(),
		}
	}

	// 构造UDP层
	udp := &layers.UDP{
		SrcPort: SrcPort,
		DstPort: layers.UDPPort(dst.Port()),
	}

	// 设置序列化选项
	opts := gopacket.SerializeOptions{
		ComputeChecksums: true, // 自动计算校验和
		FixLengths:       true, // 自动修复长度字段
	}

	// 尝试不同TTL/Hop Limit值进行穿透
	for i := MinShortTTL; i <= MaxShortTTL; i++ {

		if isIPv4 {
			// 设置IPv4的TTL
			ip.(*layers.IPv4).TTL = uint8(i)
		} else {
			// 设置IPv6的Hop Limit
			ip.(*layers.IPv6).HopLimit = uint8(i)
		}

		// 为UDP层设置网络层信息，以便计算校验和
		udp.SetNetworkLayerForChecksum(ip)

		// 创建序列化缓冲区
		buf := gopacket.NewSerializeBuffer()
		// 序列化报文层
		err = gopacket.SerializeLayers(buf, opts, ip.(gopacket.SerializableLayer), udp, gopacket.Payload("short ttl pack"))
		if err != nil {
			return fmt.Errorf("packet serialization failed: %w", err)
		}

		// 获取序列化后的报文数据
		packetData := buf.Bytes()
		// 发送多个包以增加穿透成功的概率
		for i := 0; i < PunchPacketCount; i++ {
			err = syscall.Sendto(sockFd, packetData, 0, dstSock)
			if err != nil {
				return fmt.Errorf("failed to send packet %d/%d: %w", i+1, PunchPacketCount, err)
			}
			// 在发送下一个包之前等待一段时间
			if i < PunchPacketCount-1 {
				time.Sleep(PunchInterval)
			}
		}
		log.Printf("successfully sent a short ttl(%d) packet to %s", i, dst)
	}

	// 报告成功发送短TTL包
	log.Printf("successfully sent a short ttl packet to %s", dst)
	return nil
}

```

