# Java学习之路——注释

## 一、基本概念

> 注释就是对代码的解释和说明，其目的是让人们能够更加轻松地了解代码。注释是编写程序时，写程序的人给一个语句、程序段、函数等的解释或提示，能提高程序代码的可读性。

说白了，注释就是给人看的，计算机是不需要注释的，它是方便看代码的人理解这段代码的意思。（就如同自己小时候读不到英文单词，在下面写拼音一样🙃）

在 Java程序中，在 **xxx.java** 程序中书写的注释，编译到 **xxx.class** 字节码文件中后是不会再存在注释的。

## 二、注释的分类及其使用

在 Java 程序中，注释可以分为三种，分别是：**单行注释**、**多行注释**和**文档注释**。

### 单行注释

```java
// 这是一行单行注释
```

### 多行注释

```java
/*
* 这是多行注释
* 这是多行注释
*/
```

### 文档注释

在 **xxx.java** 文件中书写的文档注释可以使用 **javadoc** 工具软件来生成信息，并输出到**HTML文件中**。

我们先创建一个 **Demo.java** 程序，然后在程序中书写一个小demo：

```java
public class Demo {
    public static void main(String[] args) {
        /**
         * @Description: This is my first document comment.
         * @author: An ascetic writer
         */
        System.out.println("Hello World!");
    }
}
```

打开命令行，进入包含 xxx.java 文件的路径下，输入命令：

```bash
javadoc Demo.java
```

随即在当前文件夹下就生成了一堆文件：

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20201121161751214.png)

打开 **index.html** 文件：

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20201121162056720.png)

通过 javadoc 程序就生成了一份完整的API文档。大大节省了开发人员的时间。

### javadoc 标签

**javadoc** 工具能识别以下标签：

| **标签**      |                        **描述**                        |                           **示例**                           |
| :------------ | :----------------------------------------------------: | :----------------------------------------------------------: |
| @author       |                    标识一个类的作者                    |                     @author description                      |
| @deprecated   |                 指名一个过期的类或成员                 |                   @deprecated description                    |
| {@docRoot}    |                指明当前文档根目录的路径                |                        Directory Path                        |
| @exception    |                  标志一个类抛出的异常                  |            @exception exception-name explanation             |
| {@inheritDoc} |                  从直接父类继承的注释                  |      Inherits a comment from the immediate surperclass.      |
| {@link}       |               插入一个到另一个主题的链接               |                      {@link name text}                       |
| {@linkplain}  |  插入一个到另一个主题的链接，但是该链接显示纯文本字体  |          Inserts an in-line link to another topic.           |
| @param        |                   说明一个方法的参数                   |              @param parameter-name explanation               |
| @return       |                     说明返回值类型                     |                     @return explanation                      |
| @see          |               指定一个到另一个主题的链接               |                         @see anchor                          |
| @serial       |                   说明一个序列化属性                   |                     @serial description                      |
| @serialData   | 说明通过writeObject( ) 和 writeExternal( )方法写的数据 |                   @serialData description                    |
| @serialField  |             说明一个ObjectStreamField组件              |              @serialField name type description              |
| @since        |               标记当引入一个特定的变化时               |                        @since release                        |
| @throws       |                 和 @exception标签一样.                 | The @throws tag has the same meaning as the @exception tag.  |
| {@value}      |         显示常量的值，该常量必须是static属性。         | Displays the value of a constant, which must be a static field. |
| @version      |                      指定类的版本                      |                        @version info                         |

### 在IDEA中生成 JavaDocument

在导航栏中找到 **Tools**，选择 **Generate JavaDoc**：

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2020112116275244.png)

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20201121163555283.png)

对几个区域简单介绍一下：

1. 选择生成整个项目的文档还是单个文件的
2. 文档输出路径
3. 语言地区，如果是 **zh_CN** 即代表输出中文的文档
4. 传入JavaDoc的参数