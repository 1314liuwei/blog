# TCP socket option

## SO_LINGER

`SO_LINGER` 参数用于设置 TCP 延迟关闭的时间。

默认情况下，TCP socket 在调用 close 后，会发送 FIN 并立即进行清理工作。