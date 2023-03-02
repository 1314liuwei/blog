# 入门，从实现 Hello World! 开始

> 万丈高楼从地起！
>
> 学习任何一门编程语言都是从实现一句 "Hello World!" 开始。我的 Java 学习之路同样是从这里开始......

## 一、Hello World 程序

首先，新建一个 **.class** 后缀的文件，然后在里面输入下面的代码：

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

打开命令行窗口，进入到包含 **HelloWorld.class** 文件的文件夹路径下，依次运行下面的命令：

```bash
> javac HelloWorld.class
> java HelloWorld
Hello World!
```

最终就会看到最后 **Hello World!** 的输出。这就标明我们已经成功实现了第一个 Java 程序！我们已经成功踏入了 Java 语言的事件！

## 二、程序分析

下面我们来对这个程序做一个简单的分析：

1.  第一行：

   1. **public** 表示公开的

   2. **class** 表示这是一个类

   3. **HelloWorld** 表示这个类的名字叫做 **HelloWorld**

      第一行表示定义一个公开的类，这个类的名字叫做 **HelloWorld**

2. 第二行：

   1. **public** 表示公开的

   2. **static** 表示静态的

   3. **void** 表示函数返回值的类型，**void** 代表着函数返回值为**空**，即不返回任何值

   4. **main** 代表着函数的名称

   5. **(String[] args)**  括号中代表着该函数接收的形参，传入的参数类型为字符串数组，形参名为 **args**

      第二行表示定义一个公开的、静态的主方法，该方法名称为 **main**，返回值为空。

3. 第三行：

   代表向控制台输出，输出的东西为：**Hello World!**

### 重点归纳：

1. 一个 **xxx.java** 文件中只能有一个 **public class**，并且该类的名字必须和文件名相同！
2. "**public static void main**" 是 Java程序的入口方法。在执行 Java 程序时，虚拟机首先就会寻找这个函数。因此这部分是不可变的
3. "**System.out.println("Hello World!");**" 代表着一句 Java语句。在 Java程序中，每一句语句后面都必须以半角分号  **";"** 或者 **"{}"** 结尾。