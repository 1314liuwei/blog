# Scapy编程实例之ping扫描

## 简述

众所周知，我们可以使用 `ping` 一个主机地址的方式来判断我们和这个主机之间的网络连接是否是畅通的。

从另外一个角度思考，只要我们能够 `ping` 通一个主机，则说明这个主机是存活的。

当我们需要知道一个局域网中有哪些主机时，此时就可以使用通过 ping 每个 IP 的方式来找出所有主机。

## ping包
既然我们要构造 ping包,去探测主机那么我们就首先应该知道一个基本的 ping包长什么模样:
```python
###[ Ethernet ]###
  dst= ff:ff:ff:ff:ff:ff
  src= b8:08:cf:b4:ba:e5
  type= 0x9000
###[ ICMP ]###
     type= echo-request
     code= 0
     chksum= None
     id= 0x0
     seq= 0x0
###[ Raw ]###
        load= 'xxx'

```

## ping扫描程序
### 1. Windows

> 由于Windows对于进程的管理太鬼畜了,我只能用线程池的方式编写该程序👻
```python
import logging
import ipaddress
import multiprocessing
from random import randint
from scapy.layers.inet import IP, ICMP
from scapy.sendrecv import sr1

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)


def ping(host, queue=None):
    """
    ping一个主机
    :param host: 主机地址
    :param queue: 成功时将地址放入该队列
    :return:
    """
    print("Testing：", host)
    id_ip = randint(1, 65535)
    id_ping = randint(1, 65535)
    seq_ping = randint(1, 65535)
    pkt = IP(dst=str(host), ttl=1, id=id_ip) / ICMP(id=id_ping, seq=seq_ping) / b"I'm a ping packet "  # 构造ping包
    reply = sr1(pkt, timeout=2, verbose=False)  # 接收一个回复包
    if reply:
        print(host, "success")
        if queue is not None:
            queue.put(host)


def scan(network, sacnFunc, maxPool=0, maxQueue=0):
    """
    对一个局域网进行扫描
    :param network: 扫描一个局域网
    :param sacnFunc: 用到的扫描函数
    :param maxPool: 最大进程数，如果不指定的话为本机CPU数量
    :param maxQueue: 队列最大数量
    :return: 返回
    """
    queue = multiprocessing.Manager().Queue(maxQueue)
    net = ipaddress.ip_network(network)  # 将网段解析为所有地址
    pool = multiprocessing.Pool(maxPool if maxPool else multiprocessing.cpu_count())
    for ip in net:
        pool.apply(sacnFunc, (ip, queue))

    pool.close()
    pool.join()
    successful_ip_list = []
    while not queue.empty():
        host = queue.get()
        successful_ip_list.append(host)

    return sorted(successful_ip_list)


if __name__ == '__main__':
    import time

    start = time.time()
    print("Start scanning ...")
    active_ip = scan("192.168.101.0/24", ping)
    print("Scan complete!")
    print("The hosts successfully scanned are:")
    for i,ip in enumerate(active_ip):
        print("{}: {}".format(i, ip))
    print("\nA total of {} addresses were successful!\n".format(len(active_ip)))
    end = time.time()
    print("This scan takes a total of {} seconds.".format(end - start))
```
### 2. Linux

> - 🈲 Windows!
> - 🈲 Windows!!
> - 🈲 Windows!!!
> - 不要试图在Windows环境下运行该程序!否则出事了本人概不负责!!!

```python
import logging
import ipaddress
import multiprocessing
import os
from random import randint
from scapy.layers.inet import IP, ICMP
from scapy.sendrecv import sr1

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)


def ping(host):
    """
    ping一个主机
    :param host: 主机地址
    :return:
    """
    print("Testing：", host)
    id_ip = randint(1, 65535)
    id_ping = randint(1, 65535)
    seq_ping = randint(1, 65535)
    pkt = IP(dst=str(host), ttl=1, id=id_ip) / ICMP(id=id_ping, seq=seq_ping) / b"I'm a ping packet "
    reply = sr1(pkt, timeout=2, verbose=False)
    if reply:
        os._exit(3)


def scan(network, scanFunc):
    """
    对一个局域网进行扫描
    :param network: 扫描一个局域网
    :param scanFunc: 用到的扫描函数
    :return: 返回
    """
    net = ipaddress.ip_network(network)
    ip_processes = {}
    for ip in net:
        ip = str(ip)
        process = multiprocessing.Process(target=scanFunc, args=(ip,))
        process.start()
        ip_processes[ip] = process

    successful_ip_list = []
    for ip, process in ip_processes.items():
        if process.exitcode == 3:
            successful_ip_list.append(ip)
        else:
            process.terminate()

    return sorted(successful_ip_list)


if __name__ == '__main__':
    import time

    network = input("Please enter the network segment to be scanned：")
    start = time.time()
    print("Start scanning ...")
    active_ip = scan(network, ping)
    print("Scan complete!")
    print("The hosts successfully scanned are:")
    for i, ip in enumerate(active_ip):
        print("{}: {}".format(i, ip))
    print("\nA total of {} addresses were successful!\n".format(len(active_ip)))
    end = time.time()
    print("This scan takes a total of {} seconds.".format(end - start))

```

 