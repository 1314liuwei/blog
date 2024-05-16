# Java Web学习——Servlet 入门

## 一、Servlet 简介

> Servlet 是 JavaEE 规范之一，同时它也是 JavaWeb三大组件（Servlet 程序、Filter 过滤器、Listener 监听器）之一。
>
> Servlet 是在服务器上运行的小程序，它是运行在 Web 服务器或应用服务器上的程序，它是作为来自 Web 浏览器或其他 HTTP 客户端的请求和 HTTP 服务器上的数据库或应用程序之间的中间层。。其主要功能在于交互式地浏览和修改数据，生成动态Web内容。

## 二、创建 Servlet 程序

配置好 Servlet 项目依赖后，按照下图所示创建文件夹和文件如下：

![image-20210708231051818](https://pic.try-hard.cn/blog/2022/12/13/20221213-140839.png)

HelloServlet.java：

```java
package com.example.servelet;

import javax.servlet.*;
import java.io.IOException;

public class HelloServlet implements Servlet {
    @Override
    public void init(ServletConfig servletConfig) throws ServletException {

    }

    @Override
    public ServletConfig getServletConfig() {
        return null;
    }

    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("Servlet 被访问");
    }

    @Override
    public String getServletInfo() {
        return null;
    }

    @Override
    public void destroy() {

    }
}
```

web.xml：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <!--给 Tomcat 配置 Servlet 程序-->
    <servlet>
        <!--给 Servlet 程序起别名(一般是类名)-->
        <servlet-name>HelloServlet</servlet-name>
        <!--Servlet 程序的全类名-->
        <servlet-class>com.example.servelet.HelloServlet</servlet-class>
    </servlet>
    
    <!--给 Servlet 程序配置访问地址-->
    <servlet-mapping>
        <!-- 告诉 Tomcat 当前配置地址给哪个 Servlet 程序使用-->
        <servlet-name>HelloServlet</servlet-name>
        <!-- 配置的访问地址 -->
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>
</web-app>
```

index.jsp：

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
  </head>
  <body>
  $END$
  </body>
</html>
```

运行程序，浏览器访问地址：http://127.0.0.1:8080，网页出现如下信息：

![image-20210708100045665](https://pic.try-hard.cn/blog/2022/12/13/20221213-140757.png)

浏览器访问地址：http://127.0.0.1:8080/hello，控制台打印出：**Servlet 被访问**。

至此第一个 Servlet 程序就已经运行成功了！

## 三、Servlet 生命周期

与 Servlet 生命周期有关的方法一般有以下三个：

- 1、init()：
  init() 方法是在创建 Servlet 对象时被调用，而且只能被调用一次，用于 Servlet 对象在整个生命周期内的唯一一次初始化。只有在 init() 方法调用成功后，Servlet 才会处于服务状态，才能够去处理客户端的请求；
- 2、service()：
  service() 方法是 Servlet 工作的核心方法。当客户端请求访问 Servlet 时，Servlet 容器就会调用 service() 方法去处理来自客户端的请求，并把处理后的响应返回给客户端；
- 3、destroy()：
  destory() 方法是 Servlet 容器回收 Servlet 对象之前调用的，且只会调用一次，而此时的服务器处于停止状态或者访问资源已经被移除。

## 四、Servlet 请求分发

当我们使用不同的方式去请求 Servlet 的同一个地址时，例如使用 POST 和 GET 方法去请求同一个路由地址，我们希望在使用 GET 方法时 Servlet 程序返回页面信息，使用 POST 方法向 Servlet 程序提交数据。

要实现这种效果，我们可以通过判断客户端请求的方法来进行不同的处理：

```java
@Override
public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    // 类型转换
    HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
    // 获取请求方式
    String method = httpServletRequest.getMethod();

    // 判断请求方式
    if ("GET".equals(method)) {
        System.out.println("客户端以 GET 方法访问");
    } else if ("POST".equals(method)) {
        System.out.println("客户端以 POST 方式访问");
    }
}
```

分别使用 GET 方法和 POST 方法访问地址，可以发现 Servlet 程序可以对不同方法分别进行处理。

