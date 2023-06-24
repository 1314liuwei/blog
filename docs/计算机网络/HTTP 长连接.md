# HTTP 长连接

## HTTP 短连接

请求 HTTP 时，发送一个HTTP请求就打开一个 TCP 连接，收到响应后就关闭 TCP 连接。

这种方式就被称为 HTTP 短连接。

## HTTP 长连接

HTTP 短连接会在每次请求时都新建一个 TCP 连接，这种重复建立 TCP 连接会耗费大量资源。

如果后续的 HTTP 请求能够复用第一次 HTTP 请求时建立的 TCP 连接，那么就不用浪费大量的资源在 TCP 的建立和销毁上。

HTTP 长连接技术就实现了这种优化策略。

HTTP 请求头中，有一个 `Connection` 字段，如果要开启长连接，那么就设置 `Connection: Keep-Alive`。如果服务器支持 HTTP 长连接，那么也会在响应头中设置`Connection: Keep-Alive`；如果服务器不支持长连接，那么则会响应`Connection: close`。

如果服务器支持长连接，那么客户端会复用 TCP 连接，将后续的 HTTP 请求也用同一个 TCP 连接进行发送。

`Keep-Alive` 这个功能在 HTTP 1.0 中默认是关闭的；在 HTTP 1.1 开始则是默认开启的。