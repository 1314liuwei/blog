# Python 学习之路——迭代器与生成器

# 一、迭代

### 定义：
> 迭代是重复反馈过程的活动，其目的通常是为了逼近所需目标或结果。

在前面的学习中，我们知道 **list、tuple、str** 等这些对象是可以用 **for** 循环进行遍历的，这种遍历的方式我们就称之为**迭代**。能够进行迭代行为的对象我们就称之为**可迭代对象（Iterable）**。
我们可以用Python的内置模块来判断一个对象是不是可迭代对象：
```python
from collections.abc import Iterable

print(isinstance('Python', Iterable))  # True
print(isinstance([1, 2], Iterable))  # True
print(isinstance((1, ), Iterable))  # True
print(isinstance({1:1}, Iterable))  # True
print(isinstance({1}, Iterable))  # True
```
通过代码验证，我们之前常用的**字符串、列表、元组、字典和集合**都属于可迭代对象。
# 二、迭代器
在Python中，我们可以自定义迭代器。想要定义迭代器，那么我们就需要在我们的类中添加  **\_\_iter__() 与 \_\_next__()** 这两个魔法方法。
**\_\_iter__() 方法**：返回一个特殊的迭代器对象；
**\_\_next__() 方法**：调用next() 函数时调用此方法。
下面我们就用迭代器来实现输出斐波那契数列：
> 斐波那契数列：1、1、2、3、5、8、13、21、34......
```python
class Demo:
    def __iter__(self):
        self.a = 0
        self.b = 1
        return self

    def __next__(self):
        self.a, self.b = self.b, self.a + self.b
        return self.a


num = Demo()
myiter = iter(num)
print(next(myiter))  # 1
print(next(myiter))  # 1
print(next(myiter))  # 2
print(next(myiter))  # 3
```
使用上面的代码我们成功实现了利用迭代器输出斐波那契数列。
### 迭代器的优点：
为什么在Python中我们有那么多的可迭代的容器我们却还要弄一个迭代器呢？像列表、元组等这些容器都能够实现迭代输出，为什么我们还需要自定义迭代器呢？
首先我们思考一个问题，如果我们要遍历输出 1~100000 的数字，我们用列表怎样输出呢？我们可以用列表推导式——`[i for i in range(100000)]`，像这样就可以输出。但是这样有一个问题，那就是这样使用时Python解释器会将整个列表放入到内存中，这庞大的数据量必定会占用极大的内存空间。
首先就会**拖累程序的运行速度**，而且很有可能会**产生内存溢出的风险**。这就是列表的坏处。
但是如果我们使用迭代器输出，就不会有这种风险了。因为迭代器是调用的函数，输出一次调用一次函数。因此**迭代器消耗的内存始终是固定的**，不会有内存溢出的风险。
因此在数据较为庞大时我们应当采用迭代器输出。
# 三、生成器
### 定义：
>在Python中，使用了 **yield** 的函数被称为生成器（generator）

生成器函数跟普通函数不同的是，生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器。
在调用生成器运行的过程中，每次遇到 yield 时函数会**暂停并保存**当前所有的运行信息，**返回 yield 的值**（这里和return类似）, 并在下一次执行 next() 方法时从当前位置继续运行。
### 用列表推导式创建生成器
创建列表和生成器的区别仅在于最外层的 **[]** 和 **()**，[]创建的是一个列表，而 () 创建的是一个生成器。
```python
a = (i for i in range(10))
print(next(a))  # 0
print(next(a))  # 1
print(next(a))  # 2
```
### 自定义生成器
利用生成器来实现输出斐波那契数列：
```python
def Fibonacci():
    a, b, counter = 0, 1, 0
    while True:
        yield a
        a, b = b, a + b
        counter += 1
        
f = Fibonacci() # f 是一个迭代器，由生成器返回生成
print(next(f))  # 0
print(next(f))  # 1
print(next(f))  # 2
```
生成器和迭代器极为相似，生成器也像迭代器那样有着占据内存空间少的优点，同样适合在数据量较为庞大时使用。