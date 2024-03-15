| **网络事件**                 | **造成影响**                                                 | **能否感知** | **处理**                                                     |
| ---------------------------- | ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ |
| 非默认路由网卡IP变更         | 和变更网卡相关的局域网连接断开                               | 能           | 重新进行mDNS广播                                             |
| 默认路由网卡IP变更           | 1.    PMP 映射失效  2.    P2P 映射失效，相关连接断开  3.    局域网连接断开  4.    DHT 记录失效 | 能           | 1.    重新建立PMP映射  2.    重新获取网卡接口地址和外网出口地址  3.    重新进行mDNS广播  4.    重新广播到DHT网络 |
| 路由器LAN口IP改变WAN口IP不变 | 1.    PMP网关地址失效                                        | 能           | 重新获取默认路由地址，刷新缓存                               |
| 路由器WAN口IP改变            | 1.    PMP 映射失效  2.    P2P 映射失效，相关连接断开  3.    DHT 记录失效 | 不能         | 1.    重新建立PMP映射  2.    重新获取外网出口地址  3.    重新广播到DHT网络 |
|                              |                                                              |              |                                                              |



| network event                                                | affect                                                       | can capture? | process                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ |
| Non-default routing network card IP change                   | The LAN connection related to changing the network card is disconnected | Yes          | Restart mDNS broadcast                                       |
| Default routing network card IP change                       | 1. PMP mapping is invalid <br />2. P2P mapping is invalid and related connections are disconnected <br />3. LAN connection is disconnected <br />4. DHT records are invalid | Yes          | 1. Re-establish PMP mapping. <br />2. Re-obtain the network card interface address and external network egress address <br />3. Re-broadcast mDNS <br />4. Re-broadcast to the DHT network |
| The router LAN port IP changes and the WAN port IP remains unchanged. | PMP gateway address invalid                                  | Yes          | Retrieve gateway address                                     |
| Router WAN port IP changed                                   | 1. PMP mapping is invalid <br />2. P2P mapping is invalid and related connections are disconnected <br />3. DHT record is invalid | No           | 1. Re-establish PMP mapping <br />2. Re-obtain the external network egress address <br />3. Re-broadcast to the DHT network |
|                                                              |                                                              |              |                                                              |