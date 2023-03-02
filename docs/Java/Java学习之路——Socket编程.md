# Java学习之路——Socket编程

## 概述

> 所谓套接字(Socket)，就是对网络中不同主机上的应用进程之间进行双向通信的端点的抽象。一个套接字就是网络上进程通信的一端，提供了应用层进程利用网络协议交换数据的机制。从所处的地位来讲，套接字上联应用进程，下联网络协议栈，是应用程序通过网络协议进行通信的接口，是应用程序与网络协议根进行交互的接口。

Socket是一个抽象概念，一个应用程序通过一个 Socket 来建立一个远程连接，而 Socket 内部通过 TCP/IP 协议把数据传输到网络。

Socket、TCP 和部分 IP 的功能都是由操作系统提供的，不同的编程语言只是提供了对操作系统调用的简单的封装。

关于计算机网络部分的知识这里不再赘述，本篇博客只是简单介绍在 Java 语言中 Socket 的使用 API。具体的使用细则可以参考其它资料。

## 一、`ServerSocket` 类

服务器应用程序通过使用 `java.net.ServerSocket` 类以获取一个端口,并且侦听客户端请求。

### 构造方法

| 构造方法                                                   | 功能描述                                                     |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| `ServerSocket(int port)`                                   | 创建绑定到特定端口的服务器套接字；                           |
| `ServerSocket(int port, int backlog)`                      | 利用指定的 backlog 创建服务器套接字并将其绑定到指定的本地端口号； |
| `ServerSocket(int port, int backlog, InetAddress address)` | 使用指定的端口、侦听 backlog 和要绑定到的本地 IP 地址创建服务器； |
| `ServerSocket()`                                           | 创建非绑定服务器套接字。                                     |

### 常用方法

| 方法                                    | 功能描述                                              |
| --------------------------------------- | ----------------------------------------------------- |
| `int getLocalPort()`                    | 返回此套接字在其上侦听的端口；                        |
| `Socket accept()`                       | 侦听并接受到此套接字的连接；                          |
| `setSoTimeout(int timeout)`             | 通过指定超时值启用/禁用 `SO_TIMEOUT`，以毫秒为单位；  |
| `bind(SocketAddress host, int backlog)` | 将 `ServerSocket` 绑定到特定地址（IP 地址和端口号）。 |

## 二、`Socket` 类

`ava.net.Socket` 类代表客户端和服务器都用来互相沟通的套接字。客户端要获取一个 `Socket `对象通过实例化 ，而 服务器获得一个 `Socket` 对象则通过 `accept()` 方法的返回值。

### 构造方法

| 构造方法                                                     | 功能描述                                                 |
| ------------------------------------------------------------ | -------------------------------------------------------- |
| `Socket(String host, int port)`                              | 创建一个流套接字并将其连接到指定主机上的指定端口号；     |
| `Socket(InetAddress host, int port)`                         | 创建一个流套接字并将其连接到指定 IP 地址的指定端口号；   |
| `Socket(String host, int port, InetAddress localAddress, int localPort)` | 创建一个套接字并将其连接到指定远程主机上的指定远程端口； |
| `Socket(InetAddress host, int port, InetAddress localAddress, int localPort)` | 创建一个套接字并将其连接到指定远程地址上的指定远程端口； |
| `Socket()`                                                   | 通过系统默认类型的 `SocketImpl` 创建未连接套接字         |

### 常用方法

| 方法                                       | 功能描述                                              |
| ------------------------------------------ | ----------------------------------------------------- |
| `connect(SocketAddress host, int timeout)` | 将此套接字连接到服务器，并指定一个超时值；            |
| `InetAddress getInetAddress()`             | 返回套接字连接的地址；                                |
| `getPort()`                                | 返回此套接字连接到的远程端口；                        |
| `getLocalPort()`                           | 返回此套接字绑定到的本地端口；                        |
| `SocketAddress getRemoteSocketAddress()`   | 返回此套接字连接的端点的地址，如果未连接则返回 null； |
| `InputStream getInputStream()`             | 返回此套接字的输入流；                                |
| `OutputStream getOutputStream()`           | 返回此套接字的输出流；                                |
| `close()`                                  | 关闭此套接字。                                        |

## 三、`InetAddress` 类

这个类表示互联网协议(IP)地址。

### 常用方法

| 方法                                                 | 功能描述                                              |
| ---------------------------------------------------- | ----------------------------------------------------- |
| `InetAddress getByAddress(byte[] addr)`              | 在给定原始 IP 地址的情况下，返回 `InetAddress` 对象； |
| `InetAddress getByAddress(String host, byte[] addr)` | 根据提供的主机名和 IP 地址创建`InetAddress`；         |
| `InetAddress getByName(String host)`                 | 在给定主机名的情况下确定主机的 IP 地址；              |
| `getHostAddress()`                                   | 返回 IP 地址字符串（以文本表现形式）；                |
| `getHostName()`                                      | 获取此 IP 地址的主机名；                              |
| `InetAddress getLocalHost()`                         | 返回本地主机；                                        |
| `toString()`                                         | 将此 IP 地址转换为 String。                           |