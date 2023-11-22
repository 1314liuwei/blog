# HTTP 代理

HTTP 代理存在两种形式：

- 第一种是 [RFC 7230 - HTTP/1.1: Message Syntax and Routing](http://tools.ietf.org/html/rfc7230)描述的普通代理。这种代理扮演的是“中间人”角色，对于连接到它的客户端来说，它是服务端；对于要连接的目标服务器来说，它是客户端。它就负责在两端之间来回传送 HTTP 报文，在传送的过程中需要对 HTTP 数据包进行修改；
- 第二种是 [Tunneling TCP based protocols through Web proxy servers](https://tools.ietf.org/html/draft-luotonen-web-proxy-tunneling-01)描述的隧道代理。它通过使用 HTTP 的 CONNECT 方法建立连接，以 HTTP 的方式实现任意基于 TCP 的应用层协议代理。

## 普通代理

普通代理实际上就是一个中间人，同时扮演者客户端和服务端的角色。普通代理会关心 HTTP 数据包，对于每一个 HTTP 数据包都需要修改之后再发送到服务端。

下图（出自《HTTP 权威指南》）展示了这种行为：

![web_proxy](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/11/22/20231122-125032.webp)

对于普通 HTTP 代理，是无法代理 HTTPS 流量的。