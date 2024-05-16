# Centos7下部署Flask应用

## 一、安装 Python3

```bash
yum install python3 -y

# 验证Python安装是否完成
python3 -V
pip3 -V

# 更新pip
pip3 install --upgrade pip
```

## 二、安装uWSGI

安装依赖：

```bash
yum install python3-devel
```

如果出现下面的错误：

```
Transaction check error:
  file /etc/rpm/macros.python from install of python-rpm-macros-3-34.el7.noarch conflicts with file from package python-devel-2.7.5-80.el7_6.x86_64

Error Summary
```

则执行下面的命令后再次进行安装：

```
yum update python-devel
```

安装uWSGI：

```bash
pip3 install uwsgi

# 验证安装uwsgi是否完成
uwsgi --version
```

## 三、安装nginx

```bash
yum install nginx -y
```

启动 nginx：

```bash
systemctl start nginx
```

通过 IP 直接访问服务器，访问成功说明 nginx 开启成功：

![image-20210706142809083](https://pic.try-hard.cn/blog/2022/12/13/20221213-141628.png)

常用命令：

```bash
# 设置nginx开机自启动
systemctl enable nginx
# 开启nginx
systemctl start nginx
# 查看nginx运行状态
systemctl status nginx
# 关闭nginx
systemctl stop nginx
# 重启nginx
systemctl restart nginx
# 重载配置文件
systemctl reload nginx
```

## 四、创建flask应用

首先安装flask库：

```
pip3 install flask
```

创建 flask 应用：

```python
# /var/www/app.py

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()
```

使用 Python 启动 flask 应用：

```bash
python3 app.py
```

运行成功：

```bash
* Serving Flask app 'app' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

## 五、使用uwsgi启动flask

编写配置文件：

```python
# /var/www/conf/config.ini

[uwsgi]

# uwsgi 启动时所使用的地址与端口
socket = 127.0.0.1:8000

# python 调用的模块
module = app

# python 启动程序文件
wsgi-file = /var/www/app.py

# python 程序内用以启动的 application 变量名
callable = app

# 处理器数
processes = 4

# 线程数
threads = 8

# 输出日志文件
daemonize = /var/www/log/server.log
```

使用 uwsgi启动flask：

```bash
uwsgi /var/www/conf/config.ini

out:
[uWSGI] getting INI configuration from conf/config.ini
```

启动成功！

## 六、使用nginx启动uwsgi

编辑 nginx.conf ：

```bash
# 备份配置文件
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# 编辑配置文件
vim /etc/nginx/nginx.conf
```

```
server {
	listen 80;
	location / {
        include uwsgi_params;
        uwsgi_pass 127.0.0.1:8000;
        uwsgi_param UWSGI_CHDIR /var/www;
    }
}
```

重启 nginx ：

```bash
# 重载配置文件
systemctl reload nginx
# 重启nginx
systemctl restart nginx
```

直接访问服务器 IP：

![image-20210706152141259](https://pic.try-hard.cn/blog/2022/12/13/20221213-141624.png)

配置完成！