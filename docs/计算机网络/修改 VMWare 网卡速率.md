# 修改 VMWare 虚拟机速率

## 物理机上的 VMnet8 和 VMnet1

在设备管理器上查看两个网卡会发现这两个网卡显示的都是百兆。

<center class="half">
    <img src="https://pic.try-hard.cn/blog/2023/06/21/20230621-092901.png" alt="image-20230621092858154" style="zoom:50%;" />
    <img src="https://pic.try-hard.cn/blog/2023/06/21/20230621-093338.png" alt="image-20230621093337424" style="zoom:50%;" />
</center>
但是，实际上这里的网卡速率是没有影响的，在这里显示的速度仅是一个展示的网络速度，是可以被忽略。详细表述可查看：https://serverfault.com/questions/366704/vmware-server-reports-100mb-nic-when-its-actually-1gb/366707#366707。

虚拟网卡实际上没有线速度，因为处理是由主机的物理 CPU 完成的。https://communities.vmware.com/t5/VMware-Workstation-Pro/VMware-Workstation-Pro-network-adapter-settings/m-p/515293/highlight/true#M27737

## 虚拟机默认网卡驱动

创建虚拟机的时候默认使用的是 `e1000` 网络驱动，`e1000` 网络驱动支持到千兆网络：

```bash
root@Ubuntu:~# ethtool ens33 
Settings for ens33:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: off (auto)
        Supports Wake-on: d
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
root@Ubuntu:~# ethtool -i ens33 
driver: e1000
version: 5.15.0-72-generic
firmware-version: 
expansion-rom-version: 
bus-info: 0000:02:01.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no
```

## 修改虚拟机网卡驱动

可以通过修改虚拟机安装目录下的 `虚拟机.vmx` 配置（通过记事本打开），将 `ethernet0.virtualDev = "e1000" ` 修改为 `ethernet0.virtualDev = "vmxnet3"`。

打开虚拟机，此时可以发现虚拟机的网卡驱动变成了 `vmxnet3`，`vmxnet3`是一个万兆网卡驱动：


```bash
root@Ubuntu:~# ethtool ens192 
Settings for ens192:
        Supported ports: [ TP ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Full
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Supports Wake-on: uag
        Wake-on: d
        Link detected: yes
root@Ubuntu:~# ethtool -i ens192 
driver: vmxnet3
version: 1.6.0.0-k-NAPI
firmware-version: 
expansion-rom-version: 
bus-info: 0000:0b:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no
```


