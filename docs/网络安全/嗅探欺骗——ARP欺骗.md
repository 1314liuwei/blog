# 嗅探欺骗——ARP欺骗

# 一、介绍

ARP欺骗（ARP spoofing），又称ARP毒化或ARP攻击。它是针对以太网地址解析协议（ARP）的一种攻击技术。
### 1. 攻击原理
通过欺骗局域网内访问者的网关MAC地址，使访问者错以为攻击者更改后的MAC地址是网关的MAC，导致应当发往网关地数据包发送到攻击者。
### 2. 造成危害
ARP欺骗会导致被攻击者的数据包无法发送到网关，造成被攻击者无法正常上网（从网关发往被攻击者的数据包不受影响）。
由于被攻击者的数据包都发往了攻击者，因此还会泄漏重要个人信息。
# 二、Kali上实现ARP欺骗
### 1. 工具介绍
我们实现ARP攻击需要用到的软件为**Ettercap**。
Ettercap是针对中级攻击者的综合套件。它具有嗅探实时连接，动态过滤内容和许多其他有趣技巧的功能。它支持许多协议的主动和被动解剖，并包括许多用于网络和主机分析的功能。
![Ettercap](https://pic.try-hard.cn/blog/20200209100457590.png)

### 2. 实现攻击
1. 在终端输入`ettercap -G`启动Ettercap界面版
2. 选择**eth0**网卡（若为无线攻击则选择wlan0）
![选择网卡](https://pic.try-hard.cn/blog/20200209100747802.png)
3. 扫描主机
![扫描主机](https://pic.try-hard.cn/blog/20200209101016507.png)
4. 在**Host List**中选择被攻击主机IP
![选择被攻击者主机](https://pic.try-hard.cn/blog/20200209101231241.png)
5. 攻击方式选择ARP欺骗
![选择攻击方式](https://pic.try-hard.cn/blog/2020020910134853.png)
6. 攻击完成
![获取数据](https://img-blog.csdnimg.cn/20200209103015142.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNTgwMTkz,size_16,color_FFFFFF,t_70)
# 三、防范ARP欺骗
- 升级客户端的操作系统和应用程序补丁
- 设置静态的ARP缓存表
- 升级杀毒软件及其病毒库
- 交换机上绑定端口和MAC地址
- 生活中不要在连接公用WIFI时输入账号密码