# Scapy 介绍

## 简介

> **Scapy **是一种用于计算机网络的数据包处理工具，由 Philippe Biondi 用 Python 编写。它可以伪造或解码数据包，通过网络发送它们，捕获它们，并匹配请求和响应。它还可以用于处理扫描、跟踪路由、探测、单元测试、攻击和网络发现等任务。
>
> Scapy 为 libpcap（Windows 上是 WinPCap/Npcap）提供了一个Python接口，与 Wireshark 提供视图和捕获GUI的方式类似。它可以与许多其他程序接口来提供可视化，包括用于解码数据包的 Wireshark、用于提供图形的GnuPlot、用于可视化的 graphviz 或 VPython 等。
>
> Scapy自2018年起开始支持Python 3（Scapy 2.4.0+）。
>
> Kamene是Scapy的一个独立分支。最初，创建它的目的是向 Scapy 添加 Python 3 的支持，并将其命名为scapy3k。自2018年更名为Kamene，继续独立发展。
>
> ——维基百科

## Scapy 简单使用

Scapy是一个Python程序，使用户能够发送，嗅探，剖析和伪造网络数据包。此功能允许构建可探测，扫描或攻击网络的工具。更多内容可以查看 Scapy 的[官方文档](https://scapy.readthedocs.io/en/latest/introduction.html)。

首先我们需要通过 pip 的方式安装 scapy 包：`pip install scapy`

Scapy 不仅仅可以做为 Python 库进行程序的编写，它同时也为我们提供了一种命令行的交互方式，下面我们通过的方式来对 Scapy 进行简单使用：

### 构造一个网络包

```python
>>> scapy
>>> a = Ether()/IP()/TCP()  # 使用默认参数构造一个TCP数据包
>>> a.show() # 显示包的信息
###[ Ethernet ]###
  dst= e5:d3:32:d7:6b:4c
  src= b7:58:7f:44:7a:e5
  type= IPv4
###[ IP ]###
     version= 4
     ihl= None
     tos= 0x0
     len= None
     id= 1
     flags=
     frag= 0
     ttl= 64
     proto= tcp
     chksum= None
     src= 192.168.0.110
     dst= 127.0.0.1
     \options\
###[ TCP ]###
        sport= ftp_data  # 默认源端口为ftp_data的20端口
        dport= http  	 # 默认目的端口是http的80端口
        seq= 0
        ack= 0
        dataofs= None
        reserved= 0
        flags= S
        window= 8192
        chksum= None
        urgptr= 0
        options= []
```

### 使用 scapy 实现 ping

```python
>>> packet = IP(dst='192.168.0.106')/ICMP()/b"I'm a ping bag"  # 构造一个 ping 包
>>> reply = sr1(packet)  # 发送包并接收一个回应的包
Begin emission:
..Finished sending 1 packets.
........................*
Received 27 packets, got 1 answers, remaining 0 packets
>>> reply.show()  # 显示接收包的信息
###[ IP ]###
  version= 4
  ihl= 5
  tos= 0x0
  len= 42
  id= 55515
  flags=
  frag= 0
  ttl= 64
  proto= icmp
  chksum= 0x1fd0
  src= 192.168.0.106
  dst= 192.168.0.109
  \options\
###[ ICMP ]###
     type= echo-reply
     code= 0
     chksum= 0x87fd
     id= 0x0
     seq= 0x0
###[ Raw ]###
        load= "I'm a ping bag"  # 可以发现返回的数据和我们发送的是一样的

```

## 结语

通过上面的两个例子，我们简单的使用了一下 scapy，能够很明确的体会到 scapy 功能的强大与使用的简单，想要学习更多 scapy 的命令行使用可以查看[官方文档](https://scapy.readthedocs.io/en/latest/introduction.html)进行学习。

在后面的学习中，我们将使用 scapy 用编写 Python 程序的方式来完成我们的各种需求。