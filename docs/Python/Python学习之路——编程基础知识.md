# Python 学习之路——编程基础知识

# 一、计算机语言

### 1.计算机语言的基本概念
计算机语言（Computer Language）指的是人与计算机之间通信的方式。
不同的计算机语言之间有着不同的语法规则。
### 2.高级语言的分类

 - **面向对象**的语言：以对象为核心，将对象的行为与属性封装成类。例：Python，Java等。
   **面向过程**的语言：以函数为核心，将需要完成的任务分成各个最简子任务，将子任务封装成函数，在程序中通过调用一个一个函数来完成任务。例：C语言。
  
 - **强类型**语言：不同类型变量之间不能直接操作。例：Python。 
    **弱类型**语言：不同类型变量之间可以直接操作。例：VB，PHP。

 - **静态型**语言：编写程序时需要在函数开头对所用变量进行声明，程序运行时对变量的类型检查是在运行前的编译阶段。静态型语言便于后期代码的维护。例：Java。
   **动态型**语言：在编写程序时不需要在程序开头对变量进行声明。利用动态型语言编写的程序会在程序运行过程中对变量进行类型检查，于是经常出现程序运行到一半报错的情况。动态型语言减少了开发的难度，但是后期维护时有一定的困难。例：Python。
   
 - **编译型**语言：编译型语言写的程序运行时由编译器处理，然后直接生成计算机可以直接识别的二进制程序，因此编译性语言的运行速度较快。但由于不同的操作系统情况下变量所占字节不同，因此编译性语言所写的程序跨平台性较差。例：C语言。
   **解释型**语言：解释型语言编写的程序运行时先运行翻译成中间代码，再由解释器对中间代码进行解释运行。由于程序只有在运行时才翻译成机器语言，并且每一次运行都要重新解释，因此解释型语言的运行效率比编译型语言慢。但是解释性语言因为有着完备的平台支持，它的跨平台性比编译性语言优秀的多。
   
# 二、Python
### 1.Python简介
Python是一款易于学习且功能强大的编程语言。它具有高效率的数据结构，能够简单又有效地实现面向对象编程。Python 简洁的语法与动态输入之特性，加之其解释性语言的本质，使得它成为一种在多种领域与绝大多数平台都能进行脚本编写与应用快速开发工作的理想语言。
### 2.Python的诞生
Python语言的创始人是来自荷兰的Guido van Rossum。1989年圣诞节期间，在阿萨姆特丹，Guido为了打发圣诞节的无趣，决心开发一个新的脚本解释程序，作为ABC语言的一种继承。之所以选中Python（大蟒蛇的意思）作为该编程语言的名字，是因为他是一个叫Monty Python的喜剧团体的爱好者。
### 3.Python的特点
Python的语法十分简单，可读性极高，和英语差不多。其极高的可读性让它变得易于学习。零基础小白建议可以将Python作为第一门编程语言进行学习。Python是自由且开源的，谁都可以给它做贡献，在Python社区里来自全世界的编程爱好者一起为Python的发展共同努力。它的跨平台性和可嵌入性很好，并且它有着丰富的库，这些库可以让开发者轻而易举地实现很多功能。“**Life is short I use Python！**“，这就是对Python最美的赞誉。
### 4.Python的强大
	软件开发
	科学运算
	自动化运维 
	云计算
	WEB开发 
	网络爬虫 
	人工智能 
### 5.Python之禅

```

​```import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

译文：
翻译：
美胜于丑陋（Python 以编写优美的代码为目标）
明了胜于晦涩（优美的代码应当是明了的，命名规范，风格相似） 
简洁胜于复杂（优美的代码应当是简洁的，不要有复杂的内部实现） 
复杂胜于凌乱（如果复杂不可避免，那代码间也不能有难懂的关系，要保持接口简洁） 
扁平胜于嵌套（优美的代码应当是扁平的，不能有太多的嵌套） 
间隔胜于紧凑（优美的代码有适当的间隔，不要奢望一行代码解决问题） 
可读性很重要（优美的代码是可读的） 
即便假借特例的实用性之名，也不可违背这些规则（这些规则至高无上） 
不要包容所有错误，除非你确定需要这样做（精准地捕获异常） 
当存在多种可能，不要尝试去猜测而是尽量找一种，最好是唯一一种明显的解决方案（如果不确定，就用穷举法） 
虽然这并不容易，因为你不是 Python 之父（这里的 Dutch 是指 Guido ） 
做也许好过不做，但不假思索就动手还不如不做（动手之前要细思量） 
如果你无法向人描述你的方案，那肯定不是一个好方案；反之亦然（方案测评标准） 命名空间是一种绝妙的理念，我们应当多加利用（倡导与号召）
# 三、Python环境搭建
### 1.Python解释器
Python的解释器分类: 
CPython(官方) 用C语言编写的Python解释器 
PyPy 用Python编写的解释器 
IronPython 用.net编写的Python解释器 
JPython 用Java编写的Python解释器
### 2.Python解释器安装
首先到[Python官网](https://www.python.org/)下载合适的解释器安装包（最好选择Python3的版本，Python2官方在2020年1月1日便开始停止更新）。
![Python解释器安装](https://pic.try-hard.cn/blog/20190927000057384.png)
![2](https://pic.try-hard.cn/blog/20190927000138396.png)
![3](https://pic.try-hard.cn/blog/20190927000151922.png)
![4](https://pic.try-hard.cn/blog/20190927000247913.png)
![安装中](https://pic.try-hard.cn/blog/2019092700031044.png)

### 3.Python的两种模式
	交互模式：
![Python的IDLE命令行交互模式](https://pic.try-hard.cn/blog/20190926235217926.png)
	脚本模式（开发者来编写程序的模式）：
![Python的脚本编写模式](https://pic.try-hard.cn/blog/20190926235304428.png)
### 4.PyCharm安装与配置
在[PyCharm的官网](https://www.jetbrains.com/)下载安装包，一般选择社区版。
PyCharm的常规配置：
1.主题的修改  File-settings-apperance-theme 
2.代码字体(控制台)的修改 File -> settings -> Editer -> Font 
3.关闭更新 File -> settings -> Appearance Behavior -> System Settings -> Updates 
4.快捷键的修改 File -> settings -> Keymap 
5.添加API文档悬浮提示 File -> settings -> Editer -> General 
6.自动导包 File -> settings -> Editer -> General -> Auto Import 
7.禁止自动打开上次工程 File-settings -> Appearance Behavior -> System Settings 
8.添加头部文件 Editer-Code Style -> File and Code Templates 
9.修改字体编码 Editer-Code Style -> File Encodings