# Java Web学习——Tomcat

## 一、简介

> ![Tomcat Home](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2022/12/13/20221213-140931.png)
>
> **Tomcat是一款Apache下面的开源的Servlet容器，实现了对Servlet和JSP规范的支持**。另外 **Tomcat** 本身内含了一个 HTTP 服务器，所以也可以被当作一个 Web 服务器来使用。但是Tomcat作为一个Web服务器，它对静态资源的处理能力要比Apache或者Nginx这类的Web服务器差很多，所以我们经常将Apache和Tomcat（或者是Nginx和Tomcat）组合使用，Apache来充当Web服务器处理静态资源的请求，Tomcat充当Servlet容器来处理动态请求。

官网：[Apache Tomcat® - Welcome!](https://tomcat.apache.org/)

## 二、安装与启动

官网下载链接：[Apache Tomcat® - Apache Tomcat 8 Software Downloads](https://tomcat.apache.org/download-80.cgi)

PS：启动 Tomcat 服务器首先要配置和 **JAVA_HOME** 环境变量！

从官网上下载好 Tomcat 的软件包后，打开 **bi** 目录，点击 **startup.bat** 文件即可启动 Tomcat 服务器。

打开浏览器，输入以下任一地址：

- http://127.0.0.1:8000/
- http://localhost:8080/
- http://本机ip:8080/

出现如下界面则代表 Tomcat 启动成功！

![image-20210708100045665](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2022/12/13/20221213-140954.png)

## 三、目录介绍

Tomcat 安装包下有多个目录，每个目录都有不同作用，下面对各个目录进行一个简单介绍：

- **bin**：专门用来存放 Tomcat 服务器的可执行文件；

- **conf**：存放 Tomcat 的配置文件；

- **lib**：存放 Tomcat 的 jar 包；

- **logs**：存放 Tomcat 的运行日志；

- **temp**：存放 Tomcat 运行时产生的临时数据；

- **webapps**：存放部署的 Web 工程；

- **work**：Tomcat 的工作空间，用来存放 Tomcat 运行时 jsp 翻译为 Servelet 的源码和 Session 钝化的目录。

  ## 四、Tomcat 常用操作

  ### 1. 启动

  法1：点击  bin 目录里的 **startup.bat** 文件进行启动；

  法2：打开终端，切换目录到 bin 目录下，输入命令：**catalina run**

  ### 2. 停止

  法1：直接关闭 Tomcat 运行的窗口；

  法2：打开Tomcat 的运行窗口，按下 **Ctrl+C** 终止运行；

  法3：点击  bin 目录里的 **shutdown.bat** 文件进行启动；

  ### 3. 修改默认端口号

打开 conf 文件夹下的 **server.xml** 文件，找到如下内容：

```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
```

修改 8080 为其他端口号，并重启 Tomcat 即可修改成功修改端口号。

### 4. 部署 Web 应用

**方式一：**

在 webapps 目录下新建文件夹 mydemo ，创建一个 index.html 文件，输入如下内容：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>Hello, World!</h1>
</body>
</html>
```

启动 Tomcat，打开浏览器输入地址：http://127.0.0.1:8080/demo/index.html，即可出现如下景象：

![image-20210708103720444](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2022/12/13/20221213-141009.png)

方式二：

首先将在方式一新建的文件夹放到任意位置。

进入到 Tomcat 安装目录下的 **conf\Catalina\localhost** 文件夹，新建文件 **abc.xml**，输入以下内容：

```xml
<Context path="/demo" docBase="移动的文件夹绝对路径"/>
```

重启 Tomcat，打开浏览器输入地址：http://127.0.0.1:8080/abc/index.html，即可出现如下景象：

![image-20210708103720444](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2022/12/13/20221213-141017.png)



Tomcat 默认访问的页面是 webapps 下的 **ROOT** 文件夹！

