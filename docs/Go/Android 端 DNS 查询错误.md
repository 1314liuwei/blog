# Android 端 DNS 查询错误

下面这段代码在 Android 端执行会抛错：

```go
package main

import (
	"log"
	"net"
)

func main() {
	ip, err := net.LookupIP("baidu.com")
	if err != nil {
		return
	}
	log.Println(ip)
}
```

错误信息：**read udp [::1]:46548->[::1]:53: read: connection refused**

通过分析后发现错误原因是 Go 在 linux 环境下是默认通过 **/etc/resolve.conf** 文件获取的系统 DNS 服务器地址，但是在 Android 端没有这个文件，会导致 Go 获取不到本机 DNS 服务器，然后 Go 就会使用默认设置的本机 DNS 服务器地址。

 相关代码：

```go
// net/dnsclient_unix.go

func getSystemDNSConfig() *dnsConfig {
	resolvConf.tryUpdate("/etc/resolv.conf")
	return resolvConf.dnsConfig.Load()
}
```

```go
// net/dnsconfig.go
var (
	defaultNS   = []string{"127.0.0.1:53", "[::1]:53"}
)
```

```go
// net/dnsconfig_unix.go
// See resolv.conf(5) on a Linux machine.
func dnsReadConfig(filename string) *dnsConfig {
	...
	file, err := open(filename)
	if err != nil {
		conf.servers = defaultNS
		conf.search = dnsDefaultSearch()
		conf.err = err
		return conf
	}
	...
}
```



为了解决这个问题，需要自行设置 DNS 服务器地址。可通过修改全局变量 `net.DefaultResolver` 实现效果：

```go
&net.Resolver{
    Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
    	dial := net.Dialer{}
    	var dns []string
    	for _, server := range custom.DNSServers {
    		if _, _, err := net.SplitHostPort(server); err != nil {
    			dns = append(dns, net.JoinHostPort(server, defaultDNSPort))
    		} else {
    			dns = append(dns, server)
    		}
    	}
    	return dial.DialContext(ctx, network, dns[rand.Intn(len(dns))])
    },
}
```

