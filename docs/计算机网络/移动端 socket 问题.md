# 移动端 socket 问题

# 说明

下面三种类型 socket 类型在移动端皆会受到影响：

- UDP socket
- TCP client socket
- TCP listen socket

但是由于系统原因，这三种 socket 在 app 前后台状态切换时会受到影响（❗：**当APP在界面上无法看到时即为后台，包括Android上传文件时打开文件选择界面，手机锁屏时；当APP在界面上能够看到时为前台**）。

下面是对三种 socket 在不同手机环境下受到的影响的测试说明文档。

# 测试方案

以下问题均需要在 release 版本下才能复现，debug 模式下不存在问题！

**UDP** **测试**：app 向 Linux UDP server 定时发送数据包，UDP server 回复收到的数据；

**TCP** **Client 测试**：app 向 Linux 端 TCP server 端建立 TCP 连接后，定时发送数据包，TCP server 回复收到的数据；

**TCP** **Serer 测试**：在 app 端建立 TCP server，Linux 端向手机端发起 TCP 连接，并定时发送数据，TCP server回复收到的数据。

# 测试结果

当前能够稳定复现的主要是华为手机和 iOS 手机。其他手机的后台任务管理没有这两个严格，暂未进行测试。

## 华为

### UDP 

**现象**：当 app 从后台恢复前台后，app 端发送会抛错 `write: destination address required`。Linux 端无错误信息。

APP 端：

```Go
// 正常输出
07-04 14:32:44.018 16617 16659 I GoLog   : hello
07-04 14:32:48.756 17961 17999 I GoLog   : hello
07-04 14:32:53.765 17961 17999 I GoLog   : hello
07-04 14:32:58.638 18044 18078 I GoLog   : hello
// APP 从后台恢复到前台
07-04 14:33:03.678 18044 18070 I GoLog   : udp write err:  write udp 10.0.0.159:33322->10.0.1.238:15000: write: destination address required
```

### TCP client

**测试方法**：

**现象**：当 app 从前台进入后台后，系统会立即向已经建立的 socket 连接发出 `RST` 包，Linux 端 socket 会抛出 `read: connection reset by peer` 错误。

当 app 从后台恢复前台后，app 端发送会抛错 `write: software caused connection abort`，当尝试重新 `bind` 相同端口 tcp socket 时，会抛出 `bind: address already in use` (💡：未设置`SO_REUSEADDR` 和 `SO_REUSEPORT`，设置之后可重新 `bind`)。 

Linux 端：

```Go
// 正常输出
2024/07/04 14:52:51 recv new connection from 10.0.0.159:33322
2024/07/04 14:52:51 read 'hello' from 10.0.0.159:33322
2024/07/04 14:53:03 read 'hello' from 10.0.0.159:33322
2024/07/04 14:53:08 read 'hello' from 10.0.0.159:33322
// app 进入后台
2024/07/04 14:53:10 conn 10.0.0.159:33322 read error: read tcp 10.0.1.238:15100->10.0.0.159:33322: read: connection reset by peer
```

![img](http://pic.try-hard.cn/blog/2024/07/05/20240705-100513)

APP 端：

```Go
// 正常输出
07-04 14:52:51.624 20975 21069 I GoLog   : hello
07-04 14:53:03.266 21302 21338 I GoLog   : hello
07-04 14:53:08.272 21302 21338 I GoLog   : hello
// app 从后台恢复到前台
07-04 14:53:13.310 21302 21333 I GoLog   : tcp write err:  write tcp 10.0.0.159:33322->10.0.1.238:15100: write: software caused connection abort
// 重新 bind 抛错
07-04 14:53:13.310 21302 21333 I GoLog   : panic: dial tcp :33322->10.0.1.238:15100: bind: address already in use
```

### TCP server

**测试方法**：

**现象：**

当 app 从前台进入后台后，手机端会向所有已经建立连接的 TCP 连接发送 `RST` 报文，导致 Linux 端写数据时抛错 `write: connection reset by peer` 。

并且当 APP 恢复前台时，Linux 端继续向 app 端 TCP Server 发起连接建立请求时，app 端无回复包。查看手机端日志，发现手机端无错误信息输出。

Linux 端：

```Go
// 正常输出
hello
hello
// APP 从前台进入后台
2024/07/04 07:21:14 conn 10.0.1.238:52980 write err: write tcp 10.0.1.238:52980->10.0.0.159:33322: write: connection reset by peer
2024/07/04 07:21:14 conn 10.0.1.238:42090 write err: write tcp 10.0.1.238:42090->10.0.0.159:33322: write: connection reset by peer
// Linux 重新 connect 手机端 TCP server
2024/07/04 07:23:24 dial 10.0.0.159:33322 err: dial tcp 10.0.0.159:33322: connect: connection timed out
panic: dial tcp 10.0.0.159:33322: connect: connection timed out
```

![img](http://pic.try-hard.cn/blog/2024/07/05/20240705-100513)

APP 端：

```Go
07-04 15:21:08.573 26359 26396 I GoLog   : recv new connection from 10.0.1.238:34566
07-04 15:21:08.573 26359 26396 I GoLog   : read 'hello' from 10.0.1.238:34566
07-04 15:21:08.624 26359 26396 I GoLog   : read 'hello' from 10.0.1.238:36210
```

## iOS

> ❗ iOS 开发手册中写了对以下问题进行了解释：https://developer.apple.com/library/archive/technotes/tn2277/_index.html

### UDP

**现象：**

当 app 从后台恢复到前台后，udp socket 会抛出 `write: broken pipe`。此时重新 `bind` 相同端口的 udp socket 会抛出 `bind: address already in use` 错误 (💡：未设置`SO_REUSEADDR` 和 `SO_REUSEPORT`，设置之后可重新 `bind`)。

iOS APP 端：

```Go
// 正常输出
hello
hello
// APP 恢复前台
2024/07/04 10:38:01 udp write err:  write udp 10.0.0.110:33322->10.0.1.238:15000: write: broken pipe
2024-07-04 18:38:01.029327+0800 anet[1088:374879] [os_log] 2024/07/04 10:38:01 udp write err:  write udp 10.0.0.110:33322->10.0.1.238:15000: write: broken pipe
// 重新创建 socket，bind 相同端口
panic: dial udp :33322->10.0.1.238:15000: bind: address already in use
```

### TCP Client

**现象**：当 app 进入后台被挂起后，iOS 会给 Linux TCP server 发送 `FIN` 包，让 Linux 端已经建立连接的 socket 关闭。

当 app 从后台恢复到前台后，调用 socket 发送数据时会抛出 `write: broken pipe` 。此时重新 `bind` 相同端口的 tcp socket 会抛出 `bind: address already in use` 错误 (💡：未设置`SO_REUSEADDR` 和 `SO_REUSEPORT`，设置之后可重新 `bind`)。

Linux 端：

```Go
2024/07/04 11:06:27 read 'hello' from 10.0.0.110:33322
2024/07/04 11:06:32 read 'hello' from 10.0.0.110:33322
2024/07/04 11:06:34 conn 10.0.0.110:33322 read err: EOF
```

![img](http://pic.try-hard.cn/blog/2024/07/05/20240705-100513)

iOS APP 端：

```Go
hello
hello
2024/07/04 11:04:49 udp write err:  write tcp 10.0.0.110:33322->10.0.1.238:15100: write: broken pipe
2024-07-04 19:04:49.548568+0800 anet[1156:389115] [os_log] 2024/07/04 11:04:49 tcp write err:  write tcp 10.0.0.110:33322->10.0.1.238:15100: write: broken pipe
panic: dial tcp :33322->10.0.1.238:15100: bind: address already in use
```

### TCP Server

**现象：**

当 app 从前台进入后台后，手机端会向所有已经建立连接的 TCP 连接发送 `FIN` 报文，导致 Linux 端所有 socket 关闭 。

并且当 Linux 端继续向 app 端 TCP Server 发起连接建立请求时，app 端会拒绝连接。当手机端从后端恢复到前台后，查看手机端日志，发现 `accept` 无错误信息输出，但是之前已经建立连接的 TCP socket 会抛出 `read: socket is not connected`，此时 Linux 即使再尝试连接 TCP server，同样会抛出 `connect: connection refused`。

Linux 端日志输出：

```Go
// 正常输出
hello
hello
hello
// APP 退到后台
2024/07/04 10:27:59 conn 10.0.1.238:38314 read err: EOF
2024/07/04 10:27:59 conn 10.0.1.238:38308 read err: EOF
2024/07/04 10:27:59 conn 10.0.1.238:47762 read err: EOF
2024/07/04 10:27:59 conn 10.0.1.238:47778 read err: EOF
2024/07/04 10:27:59 dial 10.0.0.110:33322 err: dial tcp 10.0.0.110:33322: connect: connection refused
panic: dial tcp 10.0.0.110:33322: connect: connection refused
// APP 恢复前台后再次尝试重连
2024/07/04 10:28:12 dial 10.0.0.110:33322 err: dial tcp 10.0.0.110:33322: connect: connection refused
panic: dial tcp 10.0.0.110:33322: connect: connection refused
```

![img](http://pic.try-hard.cn/blog/2024/07/05/20240705-100513)

iOS APP:

```Go
// 正常输出
2024-07-04 18:27:53.941595+0800 anet[1077:371301] [os_log] 2024/07/04 10:27:53 read 'hello' from 10.0.1.238:38308
2024/07/04 10:27:53 read 'hello' from 10.0.1.238:38314
2024-07-04 18:27:53.942296+0800 anet[1077:371301] [os_log] 2024/07/04 10:27:53 read 'hello' from 10.0.1.238:38314
2024/07/04 10:27:53 recv new connection from 10.0.1.238:47778
2024-07-04 18:27:53.960323+0800 anet[1077:371302] [os_log] 2024/07/04 10:27:53 recv new connection from 10.0.1.238:47778
2024/07/04 10:27:53 read 'hello' from 10.0.1.238:47778
2024-07-04 18:27:53.960779+0800 anet[1077:371302] [os_log] 2024/07/04 10:27:53 read 'hello' from 10.0.1.238:47778

// APP 恢复前台后，已经建立连接的 socket 抛错
2024/07/04 10:28:14 conn 10.0.1.238:38308 read err: read tcp 10.0.0.110:33322->10.0.1.238:38308: read: socket is not connected
2024-07-04 18:28:14.703214+0800 anet[1077:371377] [os_log] 2024/07/04 10:28:14 conn 10.0.1.238:38308 read err: read tcp 10.0.0.110:33322->10.0.1.238:38308: read: socket is not connected
```
