# Java Web 学习：ServletContext 类

## 一、简介

> ServletContext 是一个接口，它代表的是一个 web 应用的环境（上下文）对象，ServletContext对象内部封装是该 web 应用的信息，一个web应用只有一个 ServletContext 对象。
>
> ServletContext 对象是一个域对象。域对象是指可以像 Map 一样存取数据的对象，这里的“域”指的是存储数据的操作范围。

**ServletContext 与 Map 的比较：**

| 对象           | 存储数据       | 取出数据       | 删除数据          |
| -------------- | -------------- | -------------- | ----------------- |
| Map            | put()          | get()          | remove()          |
| ServletContext | setAttribute() | getAttribute() | removeAttribute() |

## 二、ServletContext 四大功能

**ServletContext 的四大功能分别是**：

- 获取 web.xml 中配置的上下文参数 context-param；
- 获取当前 web 工程的工程路径；
- 获取工程部署后的服务器磁盘路径；
- 像 Map 一样存取数据。

首先在 web.xml 中配置 **context-param**：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <context-param>
        <!-- 参数名 -->
        <param-name>username</param-name>
        <!-- 参数值 -->
        <param-value>root</param-value>
    </context-param>

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

接下来就可以验证 ServletContext 的功能了：

```java
public void init(ServletConfig servletConfig) throws ServletException {
    // 获取 ServletContext 对象
    ServletContext context = servletConfig.getServletContext();

    // 1. 获取 web.xml 中配置的上下文参数
    System.out.println("context-param 中配置的 username：" + context.getInitParameter("username"));

    // 2. 获取当前工程的工程路径
    System.out.println("当前工程的工程路径：" + context.getContextPath());
    
    // 3. 获取工程部署后在服务器磁盘上的绝对路径
    System.out.println("工程部署后在服务器磁盘上的绝对路径：" + context.getRealPath("/"));
    
    // 4. 存取值
    context.setAttribute("password", "123456");  // 存值
    System.out.println("password：" + context.getAttribute("password"));  // 取值
    
}
```

**注意**：由于整个 Web 工程只有一个 ServletContext 对象，那么在部署的多个应用中获取的 web.xml 中配置的上下文参数都是一样的；并且只要任意一个应用在 ServletContext 对象中存值了，其他的应用也是可以获取到的。

