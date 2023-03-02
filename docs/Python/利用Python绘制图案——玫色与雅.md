# 利用Python绘制图案——玫色与雅

# 一、效果图

![效果图](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20190929131801893.png)
# 二、程序分析
在介绍代码之前我们先简单介绍一下turtle库。
**turtle库**是Python的基础绘图库（[官方手册](https://docs.python.org/2/library/turtle.html)），turtle库是Python标准库之一，不需要自己再另外安装。turtle库被介绍为一个最常用的用来给孩子们介绍编程知识的方法库，其主要是用于程序设计入门，利用turtle可以制作很多复杂的绘图。好了，turtle库的介绍到此为止，接下来开始分析我们的程序：
因为这个程序将会用到turtle库，因此我们先在程序的开头加载turtle库：
```python
import turtle
```
仔细观察图形，我们可以发现这是由许许多多**逐渐变大的正方形**，每个正方形**偏转一定的角度**叠加而成。
通过简单的分析，我们的程序实现需要完成两个两个部分，第一就是**绘制不断变大的正方形**，第二就是使**正方形偏转一定角度**。
首先绘制正方形，这里我们用到turtle库的内置函数:turtle.forward()，这个函数的功能是向当前画笔方向移动distance像素长度。我们利用这个函数来画正方形的边。每画完一条边画笔就旋转90度，这样循环四次就完成了一个正方形的绘制了，我们利用turtle.left()使画笔向左旋转90度（向右旋转用turtle.right()）。那我们先来绘制一个边长为100像素的正方形：
```python
for i in range(4):
    turtle.forward(100)
    turtle.left(90)
```
运行代码后大家可能会发现，正方形是画出来了，但是程序运行完了，窗口它自己就关闭了，根本没有停留啊！别慌，在上面程序的最后再添加一行turtle.done()，就可以不让窗口自动关闭了。
一个正方形我们已经可以绘制了，接下来我们需要让正方形不断变大，且不断旋转，变大我们利用range()函数，每画一条边，画下一条边的时候就变长一点：
```python
for i in range(200):
    turtle.forward(i)
    turtle.left(90)
turtle.done()
```
这样我们这个逐渐变大的正方形就已经完成（其实上面这个图形也挺好看的(●ˇ∀ˇ●)），下一步我们就要让正方形不断旋转。我们每一次在正方形直角边进行转折的时候我们不转90度，我们转折91度，这样便可以实现整个正方形的旋转了（准确来说已经不叫正方形了）。将上面的的分析综合起来，我们的程序就完成了：
```python
for i in range(300):
    turtle.forward(i)
    turtle.left(91)
turtle.done()
```
再给大家介绍一个十分强大的函数：**exec()**
exec()函数可以动态执行python代码，简单来说可以在这个函数里面执行Python程序，具体用法可以参看[exec()函数官方文档](https://docs.python.org/3/library/functions.html#exec)。
下面我们就将我们的代码添加进exec()函数：
```python
exec("""import turtle\nfor i in range(300): \n    turtle.forward(i)\n    turtle.left(91)\nturtle.done()\n""")
```
# 三、源代码
普通模式
```python
import turtle
for i in range(300):
    turtle.forward(i)
    turtle.left(91)
turtle.done()
```
装13模式
```python
exec("""import turtle\nfor i in range(300): \n    turtle.forward(i)\n    turtle.left(91)\nturtle.done()\n""")
```

今天的代码分析就到这里了，小伙伴们快去试一下吧！