# Scapy编程实例之ARP扫描

## 简述

ARP协议（全称：**A**ddress **R**esolution **P**rotocol，中文名称：**地址解析协议**）是一个通过解析网络层地址来找寻数据链路层地址的网络传输协议（通过 IP 地址找到 Mac地址）。

ARP 协议作为一个重要的寻址协议，只要是运行在以太网上的主机，都必定不会屏蔽它，因此 ARP 是一个扫描局域网行之有效的办法，它比 ping扫描效率更高，结果更准确。

## ARP 包

```python
###[ Ethernet ]###
  dst= e4:d3:32:d2:3b:cc 
  src= b8:08:cf:b4:ba:e5
  type= ARP
###[ ARP ]###
     hwtype= 0x1
     ptype= IPv4
     hwlen= None
     plen= None
     op= who-has
     hwsrc= b8:08:cf:b4:ba:e5  # 源MAC地址
     psrc= 192.168.0.109       # 源IP地址
     hwdst= 00:00:00:00:00:00  # 目的Mac地址
     pdst= 0.0.0.0			  # 目的IP地址
```

## ARP扫描程序

> **注意：**由于Windows和Linux对于进程的管理方式不同，因此该程序不能在Windows系统上运行，否则会出现内存溢出的状况！

```python
import ipaddress
import logging
import time
from multiprocessing import Queue, Process

from scapy.layers.l2 import Ether, ARP
from scapy.sendrecv import srp

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)


def scapy_arp_requests(host, queue=None, ifname="eth0"):
    """
    构造ARP包进行扫描
    :param host: 需要扫描的主机
    :param queue: 存储数据的队列
    :param ifname: 网卡名称
    :return: 无队列时返回 IP 和 Mac 地址，否则返回 None
    """
    # 构造ARP包
    result_raw = srp(Ether(dst="FF:FF:FF:FF:FF:FF")
                     / ARP(op=1, hwdst="00:00:00:00:00:00", pdst=host),
                     timeout=1, iface=ifname, verbose=False)

    try:
        # 取出成功响应的ARP包数据
        result_list = result_raw[0].res
        if queue == None:
            return result_list[0][1].getlayer(ARP).fields['hwsrc']
        else:
            # 将数据加入队列
            queue.put((host, result_list[0][1].getlayer(ARP).fields['hwsrc']))
    except:
        return


def scan(network, func):
    """
    扫描主机
    :param network: 扫描的网段
    :param func: 扫描调用的函数
    :return:
    """
    queue = Queue()
    net = ipaddress.ip_network(network)
    for ip in net:
        ip = str(ip)
        arp = Process(target=func, args=(ip, queue))  # 创建进程
        arp.start()  # 开始进程
    time.sleep(3)

    successful_mac_list = []
    while not queue.empty():
        ip, mac = queue.get()
        successful_mac_list.append((ip, mac))
    return successful_mac_list


if __name__ == '__main__':
    network = input("Please enter the network segment to be scanned：")
    start = time.time()
    print("Start scanning ...")
    active_ip = scan(network, scapy_arp_requests)
    print("Scan complete!")
    print("The hosts successfully scanned are:")
    for i, (ip, mac) in enumerate(active_ip):
        print("{}: IP:{} -- Mac:{}".format(i, ip, mac))
    print("\nA total of {} addresses were successful!\n".format(len(active_ip)))
    end = time.time()
    print("This scan takes a total of {} seconds.".format(end - start))

```

