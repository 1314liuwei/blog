# Wireshark 远程抓包 

Wireshark 支持使用远程接口抓包，想要使用这个能力需要使用 `libpcap` 提供远程抓包服务。

## 自行编译运行 libpcap

`libpcap` 源码可以从  [tcpdump 官网](https://www.tcpdump.org/index.html)  下载：

```bash
# 下载 libpcap
wget https://www.tcpdump.org/release/libpcap-1.10.4.tar.xz

# 安装依赖程序
apt install gcc flex bison make 

# 配置 libpcap, 启用远程抓包能力
./configure --enable-remote

# 编译程序
make

# 运行 rpcapd, 监听 ipv4 地址, 无密码认证
./rpcapd/rpcapd -4 -n     
```

# Wireshark 添加远程接口



![image-20240711142928187](https://pic.try-hard.cn/blog/2024/07/11/20240711-142929.png)

![image-20240711142953630](https://pic.try-hard.cn/blog/2024/07/11/20240711-142954.png)

![image-20240711143025405](https://pic.try-hard.cn/blog/2024/07/11/20240711-143026.png)

![image-20240711143037964](https://pic.try-hard.cn/blog/2024/07/11/20240711-143038.png)

输入远程主机地址，即可拿到所有网卡：

![image-20240711143136528](https://pic.try-hard.cn/blog/2024/07/11/20240711-143137.png)