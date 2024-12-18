# libp2p peer ID 识别流程

peer ID 的识别主要是在不安全的连接升级到安全连接阶段完成，peer ID 都是通过连接升级阶段传递公钥获取的。

libp2p 当前支持两种安全连接，Noise 和 TLS。

对于 Noise 连接，公钥通过和 Noise 握手数据一起传输时发送到服务端，服务端提取到公钥后再转换为 peer ID。

对于 TLS 连接，利用 TLS 的 ExtraExtensions 字段携带公钥，服务端从 ExtraExtensions 提取出公钥再转换出客户端 peer ID。