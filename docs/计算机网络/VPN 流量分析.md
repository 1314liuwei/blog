# VPN 流量分析

## 正常网络

![image-20230322140816515](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/03/22/20230322-140818.png)

## TUN 网卡 VPN

TUN 网卡是一个工作在三层网络（IP）的虚拟网卡。

注意：下图中的 eth0 代表的 eth0 是在三层的 IP 地址，准确来说 eth0 是工作在二层网络的。

![image-20230322144439296](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/03/22/20230322-144442.png)

## TAP 网卡 VPN

TAP 网卡是一个工作在二层（数据链路层）的虚拟网卡，拥有自己的 MAC 地址和 IP 地址。TAP 网卡此时和物理网卡是极其相似的，只不过物理网卡拿到数据后会交给真实的物理设备，让物理设备将数据以信号的方式传递出去；TAP 拿到数据后不会将数据交给真实的物理设备，而是交给用户态的软件。

TAP 网卡的 VPN 和 TUN 网卡工作流程是极其相似的，如下图所示：

![image-20230426184858603](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/04/26/20230426-184902.png)

## TAP 与 TUN 的区别

TAP 网卡与 TUN 最大的区别在于他们工作的层次不一样：**TAP 网卡工作在数据链路层，TUN 网卡工作在网络层**。