# Centos 7 下使用 Apache 配置 Flask

# 一、工具介绍

## 1. Apache

Apache是世界使用排名第一的Web服务器软件。它可以运行在几乎所有广泛使用的计算机平台上，由于其跨平台和安全性被广泛使用，是最流行的Web服务器端软件之一。它快速、可靠并且可通过简单的API扩充，将Perl/Python等解释器编译到服务器中。

## 2. Flask

Flask是一个使用 Python 编写的轻量级 Web 应用框架。其 WSGI 工具箱采用 Werkzeug ，模板引擎则使用 Jinja2 。较其他同类型框架更为灵活、轻便、安全且容易上手,小型团队在短时间内就可以完成功能丰富的中小型网站或Web服务的实现。

## 3. 为什么使用 apache 是配置 flask？

Flask本身支持使用 ```app.run(threaded=True, host='0.0.0.0',)```实现多线程运行，但依然无法实现较高的性能表现。这种时候我们就可以将Flask应用部署到专业的后端服务器。可以使用MOD_WSGI 拓展将应用部署至Apache HTTP Server下。

# 二、所使用的工具版本

- Linux 系统：Centos7.6
- Python 版本：Python3.7.5 与 2.7.5
- Apache 版本：2.4.6
- Flask 版本：1.1.1

# 二、配置

## 1. 安装 Apache

```bash
yum install -y httpd httpd-devel
```
Apache 常用命令：

```bash
systemctl start httpd.service     # 启动
systemctl stop httpd.service      # 关闭
systemctl restart httpd.service   # 重启
systemctl enable httpd.service    # 开机自启
```

如果防火墙没有开启80端口，则可使用下面的命令开启：
```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```

此时外网已经可以通过ip访问Apache的默认页面。

## 2. 安装 Python 及依赖
```
yum install -y python37-devel.x86_64     # 安装环境依赖
yum install -y python36             # 安装 Python37
yum install -y python36-setuptools  # 安装 pip
easy_install-3.6 pip
pip3 install virtualenv             # 安装virtualenv
```

## 3. 创建 flask 项目

```bash
mkdir /var/www/flaskTest
cd /var/www/flaskTest
virtualenv py3env                 # 创建虚拟环境
source py3env/bin/activate        # 进入虚拟环境
(py3env) pip3 install flask       # 安装 flask
(py3env) pip install mod_wsgi     # 安装 mod_wsgi

vim app.py                        # 创建 flask 项目
```

在 app.py 中编写一个简单的 flask 项目：
```python
from flask import Flask, request
  
app = Flask(__name__)

@app.route('/')
def hello_world():
  return 'Hello World'
  
if __name__ == '__main__':
  app.run()
```

## 4. 配置mod_wsgi

创建一个 wsgi 文件：

```bash
vim app.wsgi
```

将下面的程序写入：

```python
activate_this = '/var/www/flaskTest/py3env/bin/activate_this.py'
with open(activate_this) as file_:
  exec(file_.read(), dict(__file__=activate_this))
  
import sys
sys.path.insert(0, '/var/www/flaskTest')
from app import app as application
```

```bash
mod_wsgi-express install-module # 执行该命令得到输出
# 输出
# LoadModule wsgi_module "/usr/lib64/httpd/modules/mod_wsgi-py27.so"
# WSGIPythonHome "/usr"
```

## 5. 配置 Apache

```bash
vi /etc/httpd/conf/httpd.conf
```

将信息追加到配置文件末尾：

```bash
LoadModule wsgi_module "/usr/lib64/httpd/modules/mod_wsgi-py27.so"

<VirtualHost *:80>
  ServerName example.com
  WSGIScriptAlias / /var/www/flaskTest/app.wsgi
  <Directory /var/www/flaskTest>
    Require all granted
  </Directory>
</VirtualHost>
```

## 6. 重启 Apache 服务
```bash
systemctl restart httpd.service
```

到此为止配置过程就已结束，从外网访问本机 IP 就可以看到 **"Hello World!"** 界面了。