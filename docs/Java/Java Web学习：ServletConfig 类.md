# Java Web学习：ServletConfig 类

## 一、简介

> 当 servlet 程序配置了初始化参数后，web 容器在创建 servlet 实例对象时，会自动将这些初始化参数封装到 ServletConfig 对象中。在调用 servlet 程序的 init 方法时，我们可以获取到 ServletConfig 对象，此时就可以得到当前 servlet 的初始化参数信息。

## 二、配置 servlet 初始参数

servlet 程序的初始参数在 web.xml 文件中，使用 **init-param** 标签进行配置：

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

        <init-param>
            <!-- 参数名 -->
            <param-name>username</param-name>
            <!-- 参数值 -->
            <param-value>root</param-value>
        </init-param>

        <init-param>
            <param-name>password</param-name>
            <param-value>123456</param-value>
        </init-param>
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

## 三、获取初始参数值

ServletConfig 实例主要有三大功能：

- 获取 servlet 程序别名；
- 获取 servlet 的初始化参数；
- 获取 ServletContext 上下文对象。

```java
@Override
public void init(ServletConfig servletConfig) throws ServletException {
    System.out.println("init 程序被执行");

    // 1. 获取 servlet 程序的别名
    System.out.println(servletConfig.getServletName());

    // 2. 获取 init-param 的参数
    // 获取所有参数名
    System.out.println("所有参数名: " + servletConfig.getInitParameterNames());
    // 获取指定参数的参数值
    System.out.println("username: " + servletConfig.getInitParameter("username"));

    // 3. 获取 ServletContext
    System.out.println(servletConfig.getServletContext());
}
```
Output：


```
init 程序被执行
HelloServlet
所有参数名: java.util.Collections$3@6c07a310
username: root
org.apache.catalina.core.ApplicationContextFacade@62c040e0
```

