# 安卓端 net.InterfaceAddrs() 出错

## 问题描述

> 在安卓 10 以上版本中，go 调用 net.InterfaceAddrs() 代码时会抛出 `route ip+net: netlinkrib: permission denied` 问题。

## 出现原因

根据 debug 发现是由于安卓 11 以上版本对 netlink 套接字的能力进行了限制，详情见：[url](https://developer.android.com/training/articles/user-data-ids#mac-11-plus)。

查看 `net.InterfaceAddrs()` 源码，发现在两个地方会存在问题：

（一）在`syscall.NetlinkRIB` 函数中，进行了 netlink 套接字 bind 操作：

```go
// NetlinkRIB returns routing information base, as known as RIB, which
// consists of network facility information, states and parameters.
func NetlinkRIB(proto, family int) ([]byte, error) {
	s, err := Socket(AF_NETLINK, SOCK_RAW|SOCK_CLOEXEC, NETLINK_ROUTE)
	if err != nil {
		return nil, err
	}
	defer Close(s)
	sa := &SockaddrNetlink{Family: AF_NETLINK}
    
    //-------------------------------------------------
    // 进行了 bind 操作
	if err := Bind(s, sa); err != nil {
		return nil, err
	}
    //-------------------------------------------------
    
	wb := newNetlinkRouteRequest(proto, 1, family)
	if err := Sendto(s, wb, 0, sa); err != nil {
		return nil, err
	}
	lsa, err := Getsockname(s)
	if err != nil {
		return nil, err
	}
	lsanl, ok := lsa.(*SockaddrNetlink)
	if !ok {
		return nil, EINVAL
	}
	var tab []byte
	rbNew := make([]byte, Getpagesize())
done:
	for {
		rb := rbNew
		nr, _, err := Recvfrom(s, rb, 0)
		if err != nil {
			return nil, err
		}
		if nr < NLMSG_HDRLEN {
			return nil, EINVAL
		}
		rb = rb[:nr]
		tab = append(tab, rb...)
		msgs, err := ParseNetlinkMessage(rb)
		if err != nil {
			return nil, err
		}
		for _, m := range msgs {
			if m.Header.Seq != 1 || m.Header.Pid != lsanl.Pid {
				return nil, EINVAL
			}
			if m.Header.Type == NLMSG_DONE {
				break done
			}
			if m.Header.Type == NLMSG_ERROR {
				return nil, EINVAL
			}
		}
	}
	return tab, nil
}
```

（二）在 `interfaceTable` 函数中，调用了 Netlink 套接字的 `RTM_GETLINK` 能力：

```go
func interfaceTable(ifindex int) ([]Interface, error) {
    // 调用了 syscall.RTM_GETLINK 套接字
	tab, err := syscall.NetlinkRIB(syscall.RTM_GETLINK, syscall.AF_UNSPEC)
	if err != nil {
		return nil, os.NewSyscallError("netlinkrib", err)
	}
	msgs, err := syscall.ParseNetlinkMessage(tab)
	if err != nil {
		return nil, os.NewSyscallError("parsenetlinkmessage", err)
	}
	var ift []Interface
loop:
	for _, m := range msgs {
		switch m.Header.Type {
		case syscall.NLMSG_DONE:
			break loop
		case syscall.RTM_NEWLINK:
			ifim := (*syscall.IfInfomsg)(unsafe.Pointer(&m.Data[0]))
			if ifindex == 0 || ifindex == int(ifim.Index) {
				attrs, err := syscall.ParseNetlinkRouteAttr(&m)
				if err != nil {
					return nil, os.NewSyscallError("parsenetlinkrouteattr", err)
				}
				ift = append(ift, *newLink(ifim, attrs))
				if ifindex == int(ifim.Index) {
					break loop
				}
			}
		}
	}
	return ift, nil
}
```



## 解决方案

因此通过重写 `net.InterfaceAddrs()` 相关代码，解决上诉问题：

```go
package p2p

import (
	"net"
	"os"
	"syscall"
	"unsafe"
)

func InterfaceAddrs() ([]net.Addr, error) {
	ifat, err := interfaceAddrTable()
	if err != nil {
		err = &net.OpError{Op: "route", Net: "ip+net", Source: nil, Addr: nil, Err: err}
	}
	return ifat, err
}

// If the ifi is nil, interfaceAddrTable returns addresses for all
// network interfaces. Otherwise it returns addresses for a specific
// interface.
func interfaceAddrTable() ([]net.Addr, error) {
	tab, err := NetlinkRIB(syscall.RTM_GETADDR, syscall.AF_UNSPEC)
	if err != nil {
		return nil, os.NewSyscallError("netlinkrib", err)
	}
	msgs, err := syscall.ParseNetlinkMessage(tab)
	if err != nil {
		return nil, os.NewSyscallError("parsenetlinkmessage", err)
	}

	ifat, err := addrTable(msgs)
	if err != nil {
		return nil, err
	}
	return ifat, nil
}

func addrTable(msgs []syscall.NetlinkMessage) ([]net.Addr, error) {
	var ifat []net.Addr
loop:
	for _, m := range msgs {
		switch m.Header.Type {
		case syscall.NLMSG_DONE:
			break loop
		case syscall.RTM_NEWADDR:
			ifam := (*syscall.IfAddrmsg)(unsafe.Pointer(&m.Data[0]))
			attrs, err := syscall.ParseNetlinkRouteAttr(&m)
			if err != nil {
				return nil, os.NewSyscallError("parsenetlinkrouteattr", err)
			}
			ifa := newAddr(ifam, attrs)
			if ifa != nil {
				ifat = append(ifat, ifa)
			}
		}
	}
	return ifat, nil
}

func newAddr(ifam *syscall.IfAddrmsg, attrs []syscall.NetlinkRouteAttr) net.Addr {
	var ipPointToPoint bool
	// Seems like we need to make sure whether the IP interface
	// stack consists of IP point-to-point numbered or unnumbered
	// addressing.
	for _, a := range attrs {
		if a.Attr.Type == syscall.IFA_LOCAL {
			ipPointToPoint = true
			break
		}
	}
	for _, a := range attrs {
		if ipPointToPoint && a.Attr.Type == syscall.IFA_ADDRESS {
			continue
		}
		switch ifam.Family {
		case syscall.AF_INET:
			return &net.IPNet{IP: net.IPv4(a.Value[0], a.Value[1], a.Value[2], a.Value[3]), Mask: net.CIDRMask(int(ifam.Prefixlen), 8*net.IPv4len)}
		case syscall.AF_INET6:
			ifa := &net.IPNet{IP: make(net.IP, net.IPv6len), Mask: net.CIDRMask(int(ifam.Prefixlen), 8*net.IPv6len)}
			copy(ifa.IP, a.Value[:])
			return ifa
		}
	}
	return nil
}

// NetlinkRIB returns routing information base, as known as RIB, which
// consists of network facility information, states and parameters.
func NetlinkRIB(proto, family int) ([]byte, error) {
	s, err := syscall.Socket(syscall.AF_NETLINK, syscall.SOCK_RAW|syscall.SOCK_CLOEXEC, syscall.NETLINK_ROUTE)
	if err != nil {
		return nil, err
	}
	defer syscall.Close(s)
	sa := &syscall.SockaddrNetlink{Family: syscall.AF_NETLINK}
	//if err := syscall.Bind(s, sa); err != nil {
	//	if err != syscall.EACCES {
	//		return nil, err
	//	}
	//}
	wb := newNetlinkRouteRequest(proto, 1, family)
	if err := syscall.Sendto(s, wb, 0, sa); err != nil {
		return nil, err
	}
	lsa, err := syscall.Getsockname(s)
	if err != nil {
		return nil, err
	}
	lsanl, ok := lsa.(*syscall.SockaddrNetlink)
	if !ok {
		return nil, syscall.EINVAL
	}
	var tab []byte
	rbNew := make([]byte, syscall.Getpagesize())
done:
	for {
		rb := rbNew
		nr, _, err := syscall.Recvfrom(s, rb, 0)
		if err != nil {
			return nil, err
		}
		if nr < syscall.NLMSG_HDRLEN {
			return nil, syscall.EINVAL
		}
		rb = rb[:nr]
		tab = append(tab, rb...)
		msgs, err := syscall.ParseNetlinkMessage(rb)
		if err != nil {
			return nil, err
		}
		for _, m := range msgs {
			if m.Header.Seq != 1 || m.Header.Pid != lsanl.Pid {
				return nil, syscall.EINVAL
			}
			if m.Header.Type == syscall.NLMSG_DONE {
				break done
			}
			if m.Header.Type == syscall.NLMSG_ERROR {
				return nil, syscall.EINVAL
			}
		}
	}
	return tab, nil
}

func newNetlinkRouteRequest(proto, seq, family int) []byte {
	rr := &NetlinkRouteRequest{}
	rr.Header.Len = uint32(syscall.NLMSG_HDRLEN + syscall.SizeofRtGenmsg)
	rr.Header.Type = uint16(proto)
	rr.Header.Flags = syscall.NLM_F_DUMP | syscall.NLM_F_REQUEST
	rr.Header.Seq = uint32(seq)
	rr.Data.Family = uint8(family)
	return rr.toWireFormat()
}

// NetlinkRouteRequest represents a request message to receive routing
// and link states from the kernel.
type NetlinkRouteRequest struct {
	Header syscall.NlMsghdr
	Data   syscall.RtGenmsg
}

func (rr *NetlinkRouteRequest) toWireFormat() []byte {
	b := make([]byte, rr.Header.Len)
	*(*uint32)(unsafe.Pointer(&b[0:4][0])) = rr.Header.Len
	*(*uint16)(unsafe.Pointer(&b[4:6][0])) = rr.Header.Type
	*(*uint16)(unsafe.Pointer(&b[6:8][0])) = rr.Header.Flags
	*(*uint32)(unsafe.Pointer(&b[8:12][0])) = rr.Header.Seq
	*(*uint32)(unsafe.Pointer(&b[12:16][0])) = rr.Header.Pid
	b[16] = byte(rr.Data.Family)
	return b
}
```

