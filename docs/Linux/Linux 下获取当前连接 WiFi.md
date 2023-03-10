# Linux 下编码获取当前连接 WiFi

## Python 版

```python
# !/usr/bin/env python3
import array
import socket
import struct
from fcntl import ioctl

IFNAMESIZE = 20
ESSODMAXSIZE = 32
SIOCGIWESSID = 0x8B1B

NET_PATH = "/sys/class/net"


class Point(object):
    """ Class to hold iw_point data. """

    def __init__(self, data=None, flags=0):
        if data is None:
            raise ValueError("data must be passed to Iwpoint")
        # P pointer to data, H length, H flags
        self.fmt = 'PHH'
        self.flags = flags
        self.buff = array.array('b', data.encode())
        self.caddr_t, self.length = self.buff.buffer_info()
        self.packed_data = struct.pack(self.fmt, self.caddr_t,
                                       self.length, self.flags)

    def update(self, packed_data):
        """ Updates the object attributes. """
        self.packed_data = packed_data
        self.caddr_t, self.length, self.flags = struct.unpack(self.fmt,
                                                              self.packed_data)


def _fcntl(request, args):
    sockfd = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return ioctl(sockfd.fileno(), request, args)


def iw_get_ext(ifname, request, data=None):
    """ Read information from ifname. """
    buff = IFNAMESIZE - len(ifname)
    ifreq = array.array('b', ifname.encode() + ('\0' * buff).encode())
    # put some additional data behind the interface name
    if data is not None:
        ifreq.frombytes(data)
    else:
        # extend to 32 bytes for ioctl payload
        ifreq.extend('\0' * 16)

    result = _fcntl(request, ifreq)
    return result, ifreq[IFNAMESIZE:]


def get_essid(ifname) -> str:
    point = Point('\x00' * ESSODMAXSIZE)
    iw_get_ext(ifname, SIOCGIWESSID, point.packed_data)
    raw_essid = point.buff.tobytes()
    return raw_essid.strip('\x00'.encode()).decode()


if __name__ == '__main__':
    print(get_essid("wlo1"))
```

## Go 版

```go
import (
	"bytes"
	"unsafe"

	"golang.org/x/sys/unix"
)

// Ioctl 方法：https://man7.org/linux/man-pages/man2/ioctl.2.html
func Ioctl(fd uintptr, request uintptr, argp uintptr) error {
	_, _, err := unix.Syscall(unix.SYS_IOCTL, fd, request, argp)
	if err != 0 {
		return os.NewSyscallError("Ioctl: ", err)
	}
	return nil
}


func GetConnectedWiFi(dev string) (string, error) {
	const (
		SIOCGIWESSID = 0x8B1B
		ESSODMAXSIZE = 32
	)

	ifr := make([]byte, 40)
	fd, err := unix.Socket(unix.AF_INET, unix.SOCK_DGRAM, 0)
	if err != nil {
		return "", err
	}
	defer unix.Close(fd)

	copy(ifr[:], dev)
	buff := make([]byte, ESSODMAXSIZE)
	*(*uintptr)(unsafe.Pointer(&ifr[unix.IFNAMSIZ])) = uintptr(unsafe.Pointer(&buff[0]))
	*(*uint16)(unsafe.Pointer(&ifr[unix.IFNAMSIZ+unsafe.Sizeof(&buff[0])])) = ESSODMAXSIZE
	err = Ioctl(uintptr(fd), SIOCGIWESSID, uintptr(unsafe.Pointer(&ifr[0])))
	if err != nil {
		return "", err
	}

	return string(bytes.Trim(buff, "\x00")), nil
}


func main() {
    ssid, err := GetConnectedWiFi("wlo1")
    if err != nil {
        panic(err)
    }
    fmt.Println(ssid)
}
```

