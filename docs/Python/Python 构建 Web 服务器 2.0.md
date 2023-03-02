# Python 构建 Web 服务器 2.0

## 1. 简介

在上一节中，我们使用 socket 构建了一个可以被浏览器访问的 Web 服务器。但是我们构建的 Web 服务器客户端连接一次后就结束程序了，并且这个 Web 服务器同时只允许一个客户端进行连接。

本节会对上一次的 Web 服务器进行优化，使其能够持续运行并且能够支持多用户同时连接！

## 2. 持续运行

在实际开发中，Web 服务器是 24 小时持续运行的，想要实现这个效果我们可以使用 `while` 循环达到。

我们将与客户端建立连接部分的代码放入 `while` 循环中，这样我们就可以多次和服务器建立连接。

```python
import socket

def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # 端口复用
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(('127.0.0.1', 8000))
    sock.listen(5)
    print("服务器正在进行监听...")

    while True:
        client, addr = sock.accept()
        print("客户端信息：", addr)

        # 获取客户端请求
        data = b''
        while True:
            chunk = client.recv(1024)
            data += chunk
            if len(chunk) < 1024:
                break

        print("客户端发送的数据：", data)

        # 给客户端返回响应
        client.sendall(b'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>Hello World</h1>')
        print("*" * 100)
        client.close()


if __name__ == '__main__':
    main()
```

打开浏览器，访问：http://127.0.0.1:8000，出现 “Hello World” 字样。多次访问地址，能够实现多次访问。

## 三、多用户同时连接

由于我们的程序是单线程的，那么每次只能处理一个客户端的请求。在和一个客户端进行交互的过程中，无法和其他的客户端进行建立连接。

为了同时和多个用户建立连接，我们需要使用多线程技术，为每一个客户端建立一个线程用于建立连接。

```python
import socket
import threading


def process_connection(client):
    """
    处理客户端连接
    :param client: 客户端
    :return:
    """
    # 获取客户端请求
    data = b''
    while True:
        chunk = client.recv(1024)
        data += chunk
        if len(chunk) < 1024:
            break

    print("客户端发送的数据：", data)

    # 给客户端返回响应
    client.sendall(b'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>Hello World</h1>')
    print("*" * 100)
    client.close()


def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # 端口复用
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(('127.0.0.1', 8000))
    sock.listen(5)
    print("服务器正在进行监听...")

    while True:
        client, addr = sock.accept()
        print("客户端信息：", addr)

        # 创建新的线程用户处理客户端连接
        threading.Thread(target=process_connection, args=(client, )).start()


if __name__ == '__main__':
    main()
```

通过多线程技术和 `while` 语句我们成功让 Web 服务器能够持续运行和支持同时处理多客户端请求！

