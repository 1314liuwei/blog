# UnboundLocalError local variable ‘xxx‘ referenced before assignment

# 错误详情

在Python程序中引用函数时，有时会出现这样的错误：
> UnboundLocalError: local variable 'xxx' referenced before assignment

这个错误的意思是：**局部变量赋值前被引用**

先看一下出错程序：
```python
def demo():
    num += 1

num = 1
demo()
```
按照Python的内部空间分配来说，num是属于全局变量，在函数内部是能够读取到的。在下面的例子中就可以体现：
```python
def demo():
    print(num)

num = 1
demo()  # 1
```
那么为什么还会出现异常呢？
原来在Python中，函数内部对变量赋值进行修改后，该变量就会被Python解释器认为是局部变量而非全局变量。
（将**num += 1**重新书写为**num = num + 1**）当程序执行 **num = num + 1** 的时候，由于需要修改**num** 变量，因此**num** 已经成了局部变量。但在这之前 **num** 变量在函数空间中还没有定义，因此 **num + 1**中的**num** 变量出现错误。
# 解决办法
### 1. 使用全局变量
```python
def demo():
    global num
    num += 1

num = 1
demo()
```
通过 **global** 关键字将 **num** 声明为全局变量，这样解释器就不会出现分辨不清楚变量的错误。
### 2. 重新命名
```python
def demo():
    num1 = num + 1

num = 1
demo()
```
将 **num** 重新命名为 **num1** ，**num1** 就为局部变量，Python解释器就不会将 **num** 误认为是局部变量。