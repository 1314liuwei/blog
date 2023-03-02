# Python 构建 Web 服务器 3.0

## 一、简介

在上一章中我们已经成功让 Web 服务器能够持续运行和同时支持多用户连接。但是迄今为止我们的 Web 服务器对于所有的路由都只能返回一句 **“Hello World”**。作为一个合格的 Web 服务器，我们需要能够支持解析路由的功能。

那么本节，我们就将实现**解析路由并返回文本资源**的功能。

## 二、解析路由

随意用浏览器抓包一个 HTTP 报文首部进行观察：

```http
GET / HTTP/1.1
Host: www.baidu.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
```

发现浏览器，请求的资源路径所在位置为报文首行。那么我们使用只需要将这个路径提取出来就知道客户端需要的资源是什么了：

```python
def parse_path(data):
    """
    从 HTTP 报文中提取资源路径
    :param data:
    :return:
    """
    # 将二进制报文转换为字符串
    tmp = data.decode()
    # 获取请求首行数据
    tmp = tmp.split("\r\n")
    # 获取请求路径
    path = tmp[0].split()
    # 返回资源请求路径
    return path[1]
```

## 三、提取资源

首先我们在服务端程序所在同级目录下创建 **resource** 文件夹，在 resource 文件夹下创建 **index.html** 文件，并输入以下代码：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello</title>
</head>
<body>
<h1>Hello World</h1>
</body>
</html>
```

这个 index.html 文件就是我们准备请求的资源了。

现在我们通过第二步找到的路径提取资源：

```python
def get_resource(path):
    """
    提取资源的内容
    :param path: 资源路径
    :return: 资源内容
    """
    with open(path, "r", encoding="utf-8") as f:
        data = f.read()
	
	return data
```

## 四、404 页面

注意，这里有一个问题：**客户端请求的资源并不总是存在的！**

当客户端请求一个不存在的资源时，我们应该返回 404 状态码和 404 页面以此来提示用户：

在 resource 文件夹下新建 **404.html** 文件，写入以下代码：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404</title>
</head>
<body>
<h1>Resource Not Found</h1>
</body>
</html>
```

修改我们的 Python 代码：

```python
def get_resource(path):
    """
    提取资源的内容
    :param path: 资源路径
    :return: 状态码，资源内容
    """
    RESOURCE = "resource"
    
    data_404 = RESOURCE + "/404.html"
    path = RESOURCE + path
        
    # 判断资源是否存在
    if os.path.exists(path):
        # 存在则提取资源并设置状态码为 200
        with open(path, "r", encoding="utf-8") as f:
            data = f.read()
            status = 200
    else:
        # 不存在则返回 404 页面并设置状态码为 404
        with open(data_404, "r", encoding="utf-8") as f:
            data = f.read()
            status = 404

    return status, data
```

## 五、报文封装

资源内容提取后，下一步我们需要将它封装到 HTTP 报文中：

```python
def package_message(status, text):
    """
    HTTP 报文封装
    :param status: 状态码
    :param text: 内容
    :return: HTTP 报文
    """
    message = f'HTTP/1.1 {status} OK\r\nContent-Type: text/html\r\n\r\n{text}'
    return message.encode("utf-8")
```

接下来只要像之前一样将 HTTP 报文发送给服务端就可以了。

## 六、完整代码

```python
import socket
import threading
import os


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

    path = parse_path(data)
    status, text = get_resource(path)

    # 给客户端返回响应
    message = package_message(status, text)
    client.sendall(message)
    print("*" * 100)
    client.close()


def package_message(status, text):
    """
    HTTP 报文封装
    :param status: 状态码
    :param text: 内容
    :return: HTTP 报文
    """
    message = f'HTTP/1.1 {status} OK\r\nContent-Type: text/html\r\n\r\n{text}'
    return message.encode("utf-8")


def parse_path(data):
    """
    从 HTTP 报文中提取资源路径
    :param data: 报文数据
    :return: 资源路径
    """
    # 将二进制报文转换为字符串
    tmp = data.decode()
    # 获取请求首行数据
    tmp = tmp.split("\r\n")
    # 获取请求路径
    path = tmp[0].split()
    # 返回资源请求路径
    return path[1]


def get_resource(path):
    """
    提取资源的内容
    :param path: 资源路径
    :return: 状态码，资源内容
    """
    RESOURCE = "resource"

    data_404 = RESOURCE + "/404.html"
    path = RESOURCE + path

    # 判断资源是否存在
    if os.path.exists(path):
        # 存在则提取资源并设置状态码为 200
        with open(path, "r", encoding="utf-8") as f:
            data = f.read()
            status = 200
    else:
        # 不存在则返回 404 页面并设置状态码为 404
        with open(data_404, "r", encoding="utf-8") as f:
            data = f.read()
            status = 404

    return status, data


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
        threading.Thread(target=process_connection, args=(client,)).start()


if __name__ == '__main__':
    main()
```

