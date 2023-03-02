# Python 学习之路——枚举类

# 前言:

首先大家要明白的是：枚举类不是Python的原生类！不是原生类！不是！Python中的枚举类是依靠 **enum模块** 来实现的。
枚举是在 Python3.4 添加的新功能（安装Python解释器后自带的官方模块），3.4以前的版本需要使用`pip install enum`来安装模块后使用。

# 一、枚举
## 什么是枚举？
枚举可看作是一系列符号名称的集合，集合中每一个元素要保证唯一性和不可变（与字典类似）。因此我们可以对枚举中元素进行恒等比较，通俗来讲枚举就是一系列常量的集合，枚举是可迭代的。
## 枚举的作用
首先我们先思考一下，在 Python中我们如何定义常量？

我们最常用的做法是采用变量名大写的方式来定义常量。

这种方式虽然简单，但问题在于我们定义的仍然是变量、是可以被修改的，而常量是什么呢？简单来说就是不可变的量。

枚举就有不可变的特性，因此**枚举的主要作用就来定义常量**。
# 二、代码实现
enum 库中定义了四个枚举类，它们是可被用来定义名称和值的不重复集合: **Enum, IntEnum, Flag 和 IntFlag**。 此外还定义了一个**装饰器 unique()** 和一个**辅助类 auto**。
| 名称     | 功能                                                         |
| -------- | ------------------------------------------------------------ |
| Enum     | 创建枚举常量                                                 |
| IntEnum  | 创建属于 int 的子类的枚举常量                                |
| IntFlag  | 创建可使用按位运算符进行组合而不会丢失其 IntFlag 成员资格的枚举常量。 IntFlag 成员同样也是 int 的子类 |
| Flag     | 创建可使用按位运算符进行组合而不会丢失其 Flag 成员资格的枚举常量 |
| unique() | 确保只将一个名称绑定到任意一个值                             |
| auto     | 实例会被替换为一个可作为 Enum 成员的适当的值。 初始值从 1 开始 |
## 1. Enum类
**继承Enum类进行创建：**
```python
from enum import Enum

class Color(Enum):
    BLACK = '#000000'
    RED = '#FF0000'
    GREEN = '#00FF00'
    BLUE = '#0000FF'
    WHITE = '#FFFFFF'


print(Color)    # <enum 'Color'>
print(Color.RED)    # Color.RED
print(Color.BLACK.name)    # BLACK
print(Color.GREEN.value)    # #00FF00
```

枚举类中不允许有同名的枚举成员，当定义两个同名枚举成员时就会抛出错误：

```python
class Animal(Enum):
    CAT = 1
    CAT = 2

Animal()
# TypeError: Attempted to reuse key: 'CAT'
```

**直接使用Enum进行创建：**

```python
from enum import Enum

Animal = Enum('Animal', 'ANT BEE CAT DOG')
print(Animal)    # <enum 'Animal'>
print(Animal.ANT)    # <Animal.ANT>
print(Animal.ANT.value)   # 1
```
Enum 传入的第一参数是枚举的名称，第二个参数是枚举成员名称的 来源。 它可以是一个用空格分隔的名称字符串、名称序列、键/值对 2 元组的序列，或者名称到值的映射（例如字典）。

最后两种选项使得可以为枚举任意赋值；其他选项会自动以从 1 开始递增的整数赋值（使用 start 形参可指定不同的起始值）。

枚举类可以直接使用 ```for```语句进行遍历:
```python
from enum import Enum

Animal = Enum('Animal', 'ANT BEE CAT DOG')
for i in Animal:
    print(i, '*', i.name, '*', i.value)
'''
Animal.ANT * ANT * 1
Animal.BEE * BEE * 2
Animal.CAT * CAT * 3
Animal.DOG * DOG * 4
'''
```

枚举成员之间可以使用 ```is 和 ==、!=```进行比较，但不能使用```< 、>、>=、<=```进行比较。

```python
from enum import Enum

class Animal(Enum):
    CAT = 1
    DOG = 0


print(Animal.CAT == Animal.DOG)    # False
print(Animal.CAT is Animal.DOG)    # False
```

## 2. IntEnum类
IntEmum 的用法与 Enum 类似，但是 IntEnum 的成员可与整数进行比较：
```python
from enum import IntEnum

class Shape(IntEnum):
    CIRCLE = 1
    SQUARE = 2

class Request(IntEnum):
    POST = 1
    GET = 2

print(Shape == 1)    # False
print(Shape.CIRCLE == 1)    # True
print(Shape.CIRCLE == Request.POST)    # True
```

不过，它们仍然不可与标准 Enum 枚举进行比较:
```python
class Shape(IntEnum):
    CIRCLE = 1
    SQUARE = 2

class Color(Enum):
    RED = 1
    GREEN = 2

print(Shape.CIRCLE == Color.RED)    # False
```

## 3. IntFlag类
IntFlag 类同样是基于 int 的，不同之处在于 IntFlag 成员可使用按位运算符 **&, |, ^, ~** 进行组合且结果仍然为 IntFlag 成员。 
正如名称所表明的，IntFlag 成员同时也是 int 的子类，并能在任何使用 int 的场合被使用。 IntFlag 成员进行除按位运算以外的其他运算都将导致失去 IntFlag 成员资格。
```python
from enum import IntFlag

class Perm(IntFlag):
    R = 4
    W = 2
    X = 1

print(Perm.R | Perm.W)    # Perm.R|W
print(Perm.R + Perm.W)    # 6
RW = Perm.R | Perm.W
print(Perm.R in RW)    # True
print(Perm.R | 8)    # Perm.8|R
```
## 4. Flag类
与 IntFlag 类似，Flag 成员可使用按位运算符 **(&, |, ^, ~)** 进行组合，与 IntFlag 不同的是它们不可与任何其它 Flag 枚举或 int 进行组合或比较。 虽然可以直接指定值，但推荐使用 auto 作为值以便让 Flag 选择适当的值。
```python
from enum import Flag, auto

class Color(Flag):
    RED = auto()
    BLUE = auto()
    GREEN = auto()

print(Color.RED & Color.GREEN)    # Color.0
print(bool(Color.RED & Color.GREEN))    # False
```

# 5. unique装饰器
默认情况下，枚举允许有多个名称作为某个相同值的别名。 如果不想要这样的行为，可以使用 **unique** 装饰器来确保每个值在枚举中只被使用一次:
```python
from enum import Enum, unique

@unique
class Mistake(Enum):
    ONE = 1
    TWO = 2
    THREE = 3
    FOUR = 3
# ValueError: duplicate values found in <enum 'Mistake'>: FOUR -> THREE
```
# 6. auto函数
如果确切的值不重要，你可以使用 auto：
```python
from enum import Enum, auto
class Color(Enum):
    RED = auto()
    BLUE = auto()
    GREEN = auto()

print(list(Color))
# [<Color.RED: 1>, <Color.BLUE: 2>, <Color.GREEN: 3>]
```

# 三、官方文档
有关 Enum模块 的更多信息可以参考官方文档：[官方文档](https://docs.python.org/zh-cn/3/library/enum.html#module-enum)