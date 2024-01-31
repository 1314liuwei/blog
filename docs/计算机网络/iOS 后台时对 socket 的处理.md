# iOS 后台时对 socket 的处理

在 iOS 平台种，当程序进入后台后会对 TCP/UDP 套接字做处理，这种处理会影响我们在 iOS 端的网络开发，因此需要对其进行了解。

相关技术文档：https://developer.apple.com/library/archive/technotes/tn2277/_index.html#//apple_ref/doc/uid/DTS40010841-RevisionHistory-DontLinkElementID_1

## 基础知识

iOS 将 socket 根据使用划分为 **listening sockets** 和 **data sockets**：

- **listening sockets**：处于 listen 状态的 TCP socket；
- **data sockets**：connect 状态的 TCP socket，UDP socket。 

## listening sockets

对于处于 listen 状态的 TCP 套接字，在应用进入后台后，socket 会被内核挂起，处于一个特殊的"**暂停状态**"。

在"暂停状态"下，内核仍会认为 socket 处于 active 状态。如果有 client 试图连接到该 socket，内核会接收连接，但是该 socket 无法收到连接。在等待一段时间后客户端会放弃连接，返回 "**connection refused**" 错误信息。

## data sockets

对于 data socket，当 APP 被系统挂起（**suspended**）时，内核可能会回收该 socket 资源，回收之后所有在该 socket 上的操作都会失效，应用会收到来自内核的 "**recvmsg: socket is not connected**" 错误信息。

## 总结

因此对于所有类型 socket，最好的处理方式都是在应用进入后台后最好主动关闭它；恢复前台时再重新打开它。