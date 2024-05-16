# 靶机渗透：coyfefe

## 0x00：靶机安装与启动

靶机地址：[covfefe: 1 ~ VulnHub](https://www.vulnhub.com/entry/covfefe-1,199/)

在 VM 上安装好靶机后，将靶机与攻击机配置到同一局域网内，启动靶机：

![image-20210709230521173](https://pic.try-hard.cn/blog/image-20210709230521173.png)

## 0x01：渗透过程

### 1. 搜索靶机地址

首先使用 **netdiscover** 工具找到靶机 IP 地址：

```
sudo netdiscover -r 192.168.1.0/24

Output:
Currently scanning: Finished!   |   Screen View: Unique Hosts                                                                                                                              
                                                                                                                                                                                            
 286 Captured ARP Req/Rep packets, from 7 hosts.   Total size: 17160                                                                                                                        
 _____________________________________________________________________________
   IP            At MAC Address     Count     Len  MAC Vendor / Hostname      
 -----------------------------------------------------------------------------
 192.168.1.1     bc:54:fc:2c:60:2c    230   13800  SHENZHEN MERCURY COMMUNICATION TECHNOLOGIES CO.,LTD.                                                                                                                                                                                
 192.168.1.105   00:0c:29:38:64:81     40    2400  VMware, Inc.                                                                                                                             
```

找到靶机地址为：192.168.1.105；

### 2. 扫描靶机开放端口

使用 **namp** 扫描靶机开放端口：

```
nmap -sV 192.168.1.105

output:
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 7.4p1 Debian 10 (protocol 2.0)
80/tcp    open  http    nginx 1.10.3
31337/tcp open  http    Werkzeug httpd 0.11.15 (Python 3.5.3)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

通过 nmap 的扫描我们发现靶机开启了两个 http 的服务端口和一个 ssh 的服务端口。

### 3. http 目录扫描

接下来我们使用 dirb 工具对靶机进行目录和文件扫描，看看有没有什么有用的信息：

```
dirb http://192.168.1.105:80/

output：
---- Scanning URL: http://192.168.1.105:80/ ----
                                                                                                                                                        
-----------------
```

```
dirb http://192.168.1.105:31337/

output：
---- Scanning URL: http://192.168.1.105:31337/ ----
+ http://192.168.1.105:31337/.bash_history (CODE:200|SIZE:19)                                                                                                                               
+ http://192.168.1.105:31337/.bashrc (CODE:200|SIZE:3526)                                                                                                                                   
+ http://192.168.1.105:31337/.profile (CODE:200|SIZE:675)                                                                                                                                   
+ http://192.168.1.105:31337/.ssh (CODE:200|SIZE:43)                                                                                                                                        
+ http://192.168.1.105:31337/robots.txt (CODE:200|SIZE:70)                                                                                                                                  
                                                                                                                                                                                            
-----------------
```

对两个端口进行扫描，我们发现在 31337 端口的 web 目录下存在几个敏感文件。

### 4. robots.txt

> robots.txt是一个协议，而不是一个命令。robots.txt是搜索引擎中访问网站的时候要查看的第一个文件。robots.txt文件告诉蜘蛛程序在服务器上什么文件是可以被查看的。

robots.txt 是我们渗透测试人员重点的查看对象，因为在这个文件下很有可能写有网站的敏感目录或者文件。

浏览器访问：http://192.168.1.105:31337/robots.txt，发现有如下内容：

```
User-agent: *
Disallow: /.bashrc
Disallow: /.profile
Disallow: /taxes
```

我们在 robots.txt 目录下发现了一个隐藏目录：**taxes**，浏览器访问这个隐藏目录：http://192.168.1.105:31337/taxes/

发现如下内容，很幸运我们发现了第一个 flag：

```
Good job! Here is a flag: flag1{make_america_great_again}
```

