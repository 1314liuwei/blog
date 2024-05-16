# Python 构建 Web 服务器 1.0

## 一、Web服务器简介

> 当我们在访问网站时，实际上就是向对应网站的Web服务器发出了请求，Web服务器监听到请求后就会向我们返回相对于的资源。Web服务器实际上就是一个接收网络请求，处理网络请求的应用程序。

市面上常见的Web服务器有：**Apache、 Nginx 、IIS** 等。

作为一个 Web 开发人员，理解 Web 服务器的工作流程对于我们而言是有好处的，正所谓 “知己知彼，百战不殆” 。在接下来的教程中我们将使用 Python 语言构建一个简易的 Web 服务器， 以此来深入理解 Web 服务器的工作原理。

## 二、HTTP简介

> HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。
>
> HTTP是一个基于TCP/IP通信协议来传递数据（HTML 文件, 图片文件, 查询结果等）。

Web 页面就是主要通过 HTTP 协议进行传输，Web 服务器需要能够解析 HTTP 协议。

HTTP 通过 TCP 协议进行传输，下面来看一个 HTTP 协议的请求数据包：

请求数据包：

```http
GET / HTTP/1.1
Host: 127.0.0.1:8000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Connection: keep-alive
```

响应数据包：

```http
HTTP/1.1 200 OK
Content-Type: text/html

<h1>Hello World</h1>
```

我们的 Web 服务器就需要通过 HTTP 协议与浏览器进行交互。

更多关于 HTTP 协议的信息大家可以自行学习。

## 三、Web服务器1.0

> 想要进行网络通信，首先要建立网络连接。而 socket 就是用来建立网络连接的，建立一个 socket 则代表一个网络连接。更多关于 socket 的基础知识大家可以进行资料的查阅。

Python 语言中，socket 是作为一个内置库，可以直接进行导入。

首先进行创建套接字并监听网络请求：

```python
# 导入 socket 库
import socket


# 创建 socket 对象
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 绑定 IP 和端口
sock.bind(('127.0.0.1', 8000))
# 监听客户端请求
sock.listen(1)
print("服务器正在监听...")
```

当客户端对服务器进行访问后，我们就需要接收客户端的请求并进行处理：

```python
# 建立 socket 连接
client, addr = sock.accept()
print("客户端信息：", addr)

data = b''
while True:
    # 接收来自客户端的信息
    chunk = client.recv(1024)
    # 拼接字符串
    data += chunk
    # 判断信息是否接收完成
    if len(chunk) < 1024:
    	break

print("收到的信息：", data)
```

现阶段我们对客户端的请求返回统一的结果：

```python
# 向客户端返回数据
client.sendall(b'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>Hello World</h1>')
# 关闭客户端
client.close()
# 关闭 socket 连接
sock.close()
```

完整程序：

```python
# 导入 socket 库
import socket


def main():
    # 创建 socket 对象
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # 绑定 IP 和端口
    sock.bind(('127.0.0.1', 8000))
    # 监听客户端请求
    sock.listen(1)
    print("服务器正在监听...")
    # 建立 socket 连接
    client, addr = sock.accept()
    print("客户端信息：", addr)

    data = b''
    while True:
        # 接收来自客户端的信息
        chunk = client.recv(1024)
        data += chunk
        if len(chunk) < 1024:
            break

    print("收到的信息：", data)

    # 向客户端返回数据
    client.sendall(b'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>Hello World</h1>')
    # 关闭客户端
    client.close()
    # 关闭 socket 连接
    sock.close()


if __name__ == '__main__':
    main()
```

运行程序，打开浏览器，输入地址：http://127.0.0.1:8000/。

浏览器出现以下信息则代表我们的 Web 服务器运行成功：

![image-20210708151410314](https://pic.try-hard.cn/blog/image-20210708151410314.png)

