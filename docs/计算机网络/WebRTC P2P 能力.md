# WebRTC P2P 能力

## P2P 连接流程

> - Signal Server: 用于协助双端数据交换；
> - STUN：用于探测自身节点公网 IP + Port 和 自身所处 NAT 类型；
> - TURN：中继服务器，用于转发中继流量。

![image-20240222192857658](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2024/02/22/20240222-192900.png)

## P2P 能力

| 网络环境                                            | WebRTC P2P 是否支持 |
| --------------------------------------------------- | ------------------- |
| IPv6 - IPv6                                         | 支持                |
| Port Restricted Cone NAT - Port Restricted Cone NAT | 支持                |
| 一端位于 NAT 下，一端位于 NAT 上                    | 支持                |
| Port Restricted Cone NAT - Symmetric NAT            | 不支持              |
| 具有爆破防护规则的防火墙                            | 不支持              |
| 能够依靠 UPnP/NAT-PMP/PCP进行端口映射的路由器       | 不支持              |

## Data Channel

WebRTC 的 Data Channel 底层使用 SCTP 。SCTP 为你提供流，并且每个流都可以独立配置。WebRTC 数据通道只是基于流的简单抽象。有关持久性和顺序的设置会被直接传递到 SCTP Agent 中。

Data Channel 的通道类型具有以下可选属性：

- `DATA_CHANNEL_RELIABLE` (`0x00`) - 没有消息丢失，消息依序到达。
- `DATA_CHANNEL_RELIABLE_UNORDERED` (`0x80`) - 没有消息丢失，但消息可能乱序到达。
- `DATA_CHANNEL_PARTIAL_RELIABLE_REXMIT` (`0x01`) - 按照请求中的次数重试发送后，消息可能会丢失，但消息将依序到达。
- `DATA_CHANNEL_PARTIAL_RELIABLE_REXMIT_UNORDERED` (`0x81`) - 按照请求中的次数重试发送后，消息可能会丢失，且消息可能乱序到达。
- `DATA_CHANNEL_PARTIAL_RELIABLE_TIMED` (`0x02`) - 如果没有在请求的时间内到达，消息可能会丢失，但消息将依序到达。
- `DATA_CHANNEL_PARTIAL_RELIABLE_TIMED_UNORDERED` (`0x82`) - 如果没有在请求的时间内到达，消息可能会丢失，且消息可能乱序到达。

## libp2p 如何使用 WebRTC

### WebRTC Direct

```js
const offerSdp = await peerConnection.createOffer()
const mungedOfferSdp = sdp.munge(offerSdp, ufrag)
await peerConnection.setLocalDescription(mungedOfferSdp)

// construct answer sdp from multiaddr and ufrag
const answerSdp = sdp.fromMultiAddr(ma, ufrag)
await peerConnection.setRemoteDescription(answerSdp)
```

在 WebRTC Direct 中，libp2p 直接使用地址转换成 SDP 进行 WebRTC 连接。

### WebRTC 



