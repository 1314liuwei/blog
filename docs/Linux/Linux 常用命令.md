# Linux 常用命令

## 1. 修改用户名和密码

```bash
# 修改用户名
usermod -l new old

# 修改密码
passwd 
```

## 2. 查找文件

```bash
find <指定目录> <指定条件> <指定动作>
```

## 3. 统计文件夹下文件数量

Linux下有三个命令：`ls`、`grep`、`wc`。通过这三个命令的组合可以统计目录下文件及文件夹的个数。

- 统计当前目录下文件的个数（不包括目录）

```bash
$ ls -l | grep "^-" | wc -l
```

- 统计当前目录下文件的个数（包括子目录）

```bash
$ ls -lR| grep "^-" | wc -l
```

- 查看某目录下文件夹(目录)的个数（包括子目录）

```bash
$ ls -lR | grep "^d" | wc -l
```

**命令解析：**

- `ls -l`

长列表输出该目录下文件信息(注意这里的文件是指目录、链接、设备文件等)，每一行对应一个文件或目录，`ls -lR`是列出所有文件，包括子目录。

- `grep "^-"`
  过滤`ls`的输出信息，只保留一般文件，只保留目录是`grep "^d"`。
- `wc -l`
  统计输出信息的行数，统计结果就是输出信息的行数，一行信息对应一个文件，所以就是文件的个数。

## 4. HTTP 压测

编译安装 wrk：

```bash
# 克隆到本地
git clone https://github.com/wg/wrk
# 进入wrk
cd wrk
# 编译
make
```

对 百度 进行压测：

```bash
-- 表示采用了10个线程,连接数300,持续时间20s
./wrk -t10 -c300 -d20s --latency http://www.baidu.com
```

## 5. 关机重启

```bash
# 立即关机
shutdown -h now
init 0 # graceful

# 定时关机
shutdown -h 23:30 # 23:30 关机
shutdown -h +15   # 15分钟后关机

# 重启
shutdown -r now
reboot
init 6 # graceful
```

## 6. WiFi 和 蓝牙 电源管理

```bash
# 关闭
rfkill block wifi # 关闭 wifi 设备
# 开启
rfkill unblock wifi # 开启 wifi 设备
```

## 7. 网络测速

```
apt install iperf3
```

参数：

（1）-s,--server：iperf服务器模式，默认启动的监听端口为5201，eg：iperf -s

（2）-c,--client host：iperf客户端模式，host是server端地址，eg：iperf -c 222.35.11.23

（3）-i，--interval：指定每次报告之间的时间间隔，单位为秒，eg：iperf3 -c 192.168.12.168 -i 2

（4）-p，--port：指定服务器端监听的端口或客户端所连接的端口，默认是5001端口。

（5）-u，--udp：表示采用UDP协议发送报文，不带该参数表示采用TCP协议。

（6）-l，--len：设置读写缓冲区的长度，单位为 Byte。TCP方式默认为8KB，UDP方式默认为1470字节。通常测试 PPS 的时候该值为16，测试BPS时该值为1400。

（7）-b，--bandwidth [K|M|G]：指定UDP模式使用的带宽，单位bits/sec，默认值是1 Mbit/sec。

（8）-t，--time：指定数据传输的总时间，即在指定的时间内，重复发送指定长度的数据包。默认10秒。

（9）-A：CPU亲和性，可以将具体的iperf3进程绑定对应编号的逻辑CPU，避免iperf进程在不同的CPU间调度。

## 8. 查看系统路由表

```bash
ip route list table 0
```

## 9. 查询主机外部 IP

```bash
curl -L ip.tool.lu
```

## 10. 网卡速率

```bash
watch -n 1 ifconfig lo
```

通过比较 RX 和 TX 计算得出：

```
Every 1.0s: ifconfig lo                                                                         Tue Dec 12 10:54:50 2023

lo        Link encap:UNSPEC
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope: Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:46618912 errors:0 dropped:0 overruns:0 frame:0
          TX packets:46618912 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:54983068842 TX bytes:54983068842
```

## 11. 查看端口占用

```bash
ss -ntlp | grep <port>

netstat -ntlp | grep <port>

lsof -i:<port>
```

## 12. 查看最后一个文件

```bash
ls -l | awk '{print $NF}' | tail -n 1 | xargs tail -f
```

## 13. 查询指定文件夹下包含指定内容的文件

```bash
grep -r "关键词" /path/dir
```

## 14. 通过代理执行 ssh 和 scp

```bash
ORIGINAL_HOST="baidu.com" ssh -o ProxyCommand='nc -X 5 -x {ProxyAddr} $ORIGINAL_HOST %p' "root@$ORIGINAL_HOST"

ORIGINAL_HOST="baidu.com" scp -o ProxyCommand='nc -X 5 -x {ProxyAddr} $ORIGINAL_HOST %p' "root@$ORIGINAL_HOST:/path/to/remote/file" /path/to/local/destination
```

## 15. 查看本地 NAT 转换规则

```bash
# 查看 iptables 中的 NAT 规则
iptables -t nat -vL

# 查看连接跟踪表 nf_conntrack
cat /proc/net/nf_conntrack
```

