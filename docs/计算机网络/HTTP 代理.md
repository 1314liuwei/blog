# HTTP 代理

HTTP 代理存在两种形式：

- 第一种是 [RFC 7230 - HTTP/1.1: Message Syntax and Routing](http://tools.ietf.org/html/rfc7230)描述的普通代理。这种代理扮演的是 “中间人” 角色，对于连接到它的客户端来说，它是服务端；对于要连接的目标服务器来说，它是客户端。它就负责在两端之间来回传送 HTTP 报文，在传送的过程中需要对 HTTP 数据包进行修改；
- 第二种是 [Tunneling TCP based protocols through Web proxy servers](https://tools.ietf.org/html/draft-luotonen-web-proxy-tunneling-01)描述的隧道代理。它通过使用 HTTP 的 CONNECT 方法建立连接，以 HTTP 的方式实现任意基于 TCP 的应用层协议代理。

## 普通代理

普通代理实际上就是一个中间人，同时扮演者客户端和服务端的角色。普通代理会关心 HTTP 数据包，对于每一个 HTTP 数据包都需要修改之后再发送到服务端。

下图（出自《HTTP 权威指南》）展示了这种行为：

![web_proxy](https://pic.try-hard.cn/blog/2023/11/22/20231122-125032.webp)



对于普通 HTTP 代理，是无法代理 HTTPS 流量的。因为 HTTP 代理本身是一个 HTTP 服务器，没法提供 HTTPS 服务。即使我们将 HTTP 代理直接变成一个 HTTPS 服务器，同样也无法抓取 HTTPS 包。因为 HTTPS 是能够防止中间人攻击的。

普通代理如果想要实现代理 HTTPS 包，必须要在客户端安装根证书，用于窃取 TLS 交换过程中的双端密钥。这个过程就类似于 Fiddler、Charles等 HTTPS 抓包工具的原理。

## 隧道代理

隧道代理在某种程度上来说和 HTTP 关系不大，它只是借用了 HTTP 的 CONNECT 方法建立连接。隧道代理实际上和 SOCK 代理更为相似。

下图（出自《HTTP 权威指南》）展示隧道代理的原理：

![web_tunnel](https://pic.try-hard.cn/blog/web_tunnel.png.webp)

隧道代理无论是 HTTP 的流量还是 HTTPS 的流量，都能够进行代理。不仅是 HTTP 和 HTTPS，只要是 TCP 或者是 UDP 协议的流量，他都能够代理。

隧道代理只会无脑转发流量，而不会查看流量，就像一根管子，将两端连接在一起。这也是为什么叫隧道代理的原因。



参考：

- 《HTTP 权威指南》