# 利用Python绘制图案——螺旋丸

# 一、效果图

![真·彩色螺旋丸](https://pic.try-hard.cn/blog/20191001182134516.png)
# 二、程序分析
本次程序我们依然是使用turtle库进行绘制的，因此在我们的程序第一行就是加载我们Python的turtle库了，不了解的同学可以参看我的[上一篇博客](https://blog.csdn.net/qq_43580193/article/details/101686487)哦。
接下来就是对我们的程序进行分析了，观察我们的效果图，发现本次的程序和上一次的程序有着一个相同之处——螺旋。上次我们绘制了螺旋的正方形，我们这一次绘制螺旋的正七边形，那么绘制正七边形的程序和上一次绘制正方形的程序就是大同小异了：
```python
for i in range(300):
    turtle.forward(i)
    turtle.left(360/7+1)
turtle.done()
```
螺旋的正七边形我们已经绘制完毕，下一步就是给我们的正七边形进行上色了。改变画笔颜色我们这里将要用到turtle的内置函数：turtle.pencolor()，给这个函数传递一个颜色名字，我们的画笔颜色就会发生改变。
```python
# 直接传递颜色名字
turtle.pencolor('red')
turtle.pencolor('#33cc8c')
# RGB模式首先要改变模式再传递RGB值
turtle.colormode(255)
turtle.pencolor(255,25,25)
```
我们本次程序使用的颜色有：'red','orange','yellow','green','cyan','blue','purple'
然后将我们的颜色添加进列表里面：
```python
colors = ['red','orange','yellow','green','cyan','blue','purple']
```
接下来我们让每一次画一条边的时候都改变一次颜色，把pencolor添加进循环，这样每一次循环就改变一次颜色：
```python
colors = ['red','orange','yellow','green','cyan','blue','purple']
for x in range(300):
    turtle.pencolor(colors[x%len(colors)])
    turtle.forward(x)
    turtle.left(360/len(colors)+1)
turtle.done()
```
大家这个时候可能会发现我们的画作颜色太不显眼了，而且每一条边的宽度都是一个样样的，一点都不够炫酷啊！我们通过下面的方式来解决这两个问题。
首先解决对比度的问题，要么我们就一个一个为花朵找颜色，找到对比度强的颜色。另一种解决方式就是更换画布，也就是背景，既然白色太显眼了，那我们就用黑色，这下对比度应该就高了吧。改变画布颜色我们使用turtle.bgcolor()函数，使用方法和改变画笔颜色类似，来将我们的画布换成黑色的：
```python
turtle.bgcolor('black')
```
下一个问题是改变画笔的宽度，这一次我们需要使用turtle.pensize()这个函数，为它传递一个数字就能改变画笔的宽度：
```python
for x in range(300):
	turtle.forward(x)
	turtle.left(360/7+1)
    pen.width(x*0.03) # 这个比例是我自己试的
    				  # 大家可以尝试其他比例找到自己最欢的
```
# 三、源代码
```python
import turtle
turtle.bgcolor('black')
colors = ['red','orange','yellow','green','cyan','blue','purple']
turtle.speed(10)
for x in range(300):
    turtle.pencolor(colors[x%len(colors)])
    turtle.forward(x)
    turtle.left(360/len(colors)+1)
    turtle.width(x*0.03)
turtle.done()
```
今天的代码分析就到这里了，小伙伴们快去试一下吧！