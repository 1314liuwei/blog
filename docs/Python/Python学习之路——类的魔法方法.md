# Python 学习之路——类的魔法方法

# 前言

类作为Python中最核心的部分，我们作为作为开发人员不仅仅可以为类自定义方法，在Python内部也为我们提供了众多魔法方法来帮助我们完善类的功能。
# 一、基本方法
### 1. \_\_init_subclass__（创建类）
当创建一个类时，它会自动执行父类的该魔法方法。
```python
class Parent(object):
    def __init_subclass__(cls, **kwargs):  
    # kwargs获取的是子类创建时所传递的额外参数
        print("Parent class executing")
        print(f"__init_subclass__({cls}, {kwargs})")
        for k, v in kwargs.items():
            type.__setattr__(cls, k, v)  # 为类设置属性


class Subclass(Parent, name='Python'):
    pass


print(Subclass.name)
"""
Parent class executing
__init_subclass__(<class '__main__.Subclass'>, {'name': 'Python'})
Python
"""
```
### 2. \_\_new__（创建实例对象）
该方法在创建一个实例对象时调用，用来创建实例对象和为对象分配空间。该方法时继承至**object**类的静态方法。该方法的调用在 __init__  方法之前。

```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __new__(cls, *args, **kwargs):
        print(f'__new__(cls, *{args}, **{kwargs})')
        return super().__new__(cls) # 返回一个实例对象


a = Demo('Python')
print(a.name)
# Python
```
### 3. \_\_init__（初始化实例对象）
该方法在类实例化时会自动调用。用来为实例对象进行初始化操作。
```python
class Demo(object):
    def __init__(self, name):
        self.name = name
        
    
a = Demo('Python')
print(a.name)
# Python
```
### 4. \_\_hash__（hash()）
该方法会由内置函数hash（）调用，用于对哈希集合（包括set，frozenset和dict）的成员执行操作。
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __hash__(self):
        return 1


a = Demo('Python')
print(hash(a))
# 1
```
### 5. \_\_dir__（dir()）
调用 **dir()** 函数时，会自动调用该魔法方法。在**object**类中，该方法会返回实例的属性与方法名。该方法的返回值必须是一个可迭代对象。

```python
class Demo(object):
    def __init__(self):
        self.name = 'demo'

    def __dir__(self) -> Iterable[str](self):
        return 'ABCD'


a = Demo()
print(dir(a))
# ['A', 'B', 'C', 'D']
"""
默认输出格式：
['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', 
'__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', 
'__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', 
'__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__',
'__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 
'__weakref__', 'name']
"""
```
### 6. \_\_sizeof__（分配空间大小）
用以返回对象系统分配空间的大小。
```python
class Demo(object):
    pass


a = Demo()
print(a.__sizeof__())
```
### 7. \_\_format__（format()）
我们知道在字符串的内置方法中有一个fomat()方法，它可以添加任意对象到字符串。当使用str.format()方法或者使用format()函数时，调用的就是这个魔法方法。

```python
class Demo(object):
    def __init__(self):
        self.name = 'demo'

    def __format__(self, format_spec):
    	# format_spec 指的是格式规范，默认为空
        return self.name


a = Demo()
print(format(a)) # Return value.__format__(format_spec)
# demo
print("name:{}".format(a))
# name:demo
```
### 8.\_\_del__（删除对象）
该魔法方法在删除一个实例对象时使用。
```python
class Demo(object):
    def __del__(self):
        print('Have been deleted')

a = Demo()
del a
# Have been deleted
```
### 9.\_\_call__（实例对象像函数一样调用）
该魔法方法可以使实例对象像函数一样被调用。在下面这个例子中，执行 a('Python') 该语句时，实际执行的是 a.\_\_call__('Python')。
```python
class Demo(object):
    def __call__(self, *args, **kwargs):
        print(f'__call__(self, *{args}, **{kwargs}):')

a = Demo()
a('Python')
# Python
```
### 10.\_\_len__（len()）
当调用 len() 方法获取对象长度时，就会调用该方法。
```python
class Demo(object):
    def __len__(self):
        return 10

a = Demo()
print(len(a))
# 10
```
### 11.\_\_int__（int()）
调用 int() 方法时会调用类中该方法。
```python
class Demo(object):
    def __int__(self):
        return 10

a = Demo()
print(int(a))
# 10
```
### 12.\_\_float__（float()）
调用 float() 方法时会调用类中该方法。
```python
class Demo(object):
    def __float__(self):
        return 10.0

a = Demo()
print(float(a))
# 10.0
```
### 13.\_\_bytes__（bytes()）
调用 bytes() 方法时会调用类中该方法。
```python
class Demo(object):
    def __bytes__(self):
        return 10

a = Demo()
print(bytes(a))
# 10
```
### 14.\_\_bool__（bool()）
调用 bool() 方法时会调用类中该方法。
```python
class Demo(object):
    def __bool__(self):
        return True

a = Demo()
print(bool(a))
# True
```
### 15.\_\_round__（round()）
调用 round() 方法时会调用类中该方法。
```python
class Demo(object):
    def __round__(self):
        return 10

a = Demo()
print(round(a))
# 10
```
# 二、属性操作
### 1. \_\_delattr__（删除属性）
在删除类的实例属性时，该方法会自动调用。
```python
class Demo(object):
    def __init__(self):
        self.name = 'demo'

    def __delattr__(self, item): # item会传入被删除的属性名
        print(item, ': 该属性已被删除')
        super().__delattr__(item) 
        # 重写该方法后需要继承object类的该方法才能够真正删除实例属性


a = Demo()
del a.name
# name : 该属性已被删除
```
### 2. \_\_getattribute__（访问属性）
**getattribute**是属性访问拦截器。当类中的方法和属性被访问时，就会首先调用这个方法。只要是继承**object**了的类，就默认存在属性拦截器，只是调用后没有进行任何操作，而是直接返回。
```python
class Demo(object):
    def __init__(self):
        self.name = 'demo'

    def test(self):
        print('Hello World!')

    def __getattribute__(self, item):
        print(f"{item} property is called!")
        return super().__getattribute__(item) # 调用object的方法返回


a = Demo()
print(a.name)
a.test()
""""
name property is called!
demo
test property is called!
Hello World!
"""
```
### 3. \_\_setattr__（设置属性）
当我们为实例对象设置属性时会调用该魔法方法。
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __setattr__(self, key, value):
        print(f"__setattr__({self}, {key}, {value})")
        super().__setattr__(key, value)  #必须要调用object的该方法才能成功设置属性


a = Demo('Python')
a.name = 'Java'
"""
__setattr__(<__main__.Demo object at 0x0000032F586D1CC8>, name, Python)
__setattr__(<__main__.Demo object at 0x0000032F586D1CC8>, name, Java)
"""
```
### 4. \_\_repr__（显示对象属性）
该魔法方法的功能是显示实例对象的属性。
当我们采用下面的方式输出时，打印结果为：**类名+object at+内存地址**，这样的结果对我们用处不大，这个时候我们就可以通过重写\_\_repr__方法来输出我们想要的结果。
**重写前：**
```python
class Demo(object):
    pass

a = Demo()
print(a)
# <__main__.Demo object at 0x00000000E70B1208>
```
**重写后：**

```python
class Demo(object):
    def __repr__(self):
        return "I'm a Demo."


a = Demo()
print(a)
# I'm a Demo.
```
### 5. \_\_str__（显示对象属性）
该魔法方法和\_\_repr__方法的功能是极为类似的，都是在查看属性时返回信息。
**不同之处**：
__repe__函数返回的信息是数据的元数据，一般供给程序员查看，通过object和repr（object）来调用；
__str__函数返回的是经过转换过的数据，一般给用户查看，通过print (objects)来调用。

```python
class Demo(object):
    def __str__(self):
        return 'Demo'

    def __repr__(self):
        return 'demo'


a = Demo()
print(str(a))
print(repr(a))
"""
Demo
demo
"""
```
# 三、 对象间比较操作
| 魔法方法 | 比较方法 |
| -------- | -------- |
| \_\_eq__ | ==       |
| \_\_ne__ | !=       |
| \_\_ge__ | >=       |
| \_\_gt__ | >        |
| \_\_le__ | <=       |
| \_\_lt__ | <        |
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __eq__(self, other):
        return self.name == other.name
	
	def __ne__(self, other):
        return self.name != other.name
        
    def __ge__(self, other):
        return self.name >= other.name

    def __gt__(self, other):
        return self.name > other.name

    def __lt__(self, other):
        return self.name < other.name

    def __le__(self, other):
        return self.name <= other.name


a = Demo('Python')
b = Demo('Java')
print(a == b)
print(a >= b)
print(a <= b)
print(a > b)
print(a < b)
"""
False
True
False
True
False
"""
```
如果我们想要完善方法，这样一个一个写是比较麻烦的，这个时候我们就可以引入一个外部装饰器来帮助我们完善类比较的方法。
只要我们定义的类中有__ge__、\_\_gt__、\_\_lt__、__le__中任意一个魔法方法，就可以完善所有的方法。

```c
from functools import total_ordering


@total_ordering
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __eq__(self, other):
        return self.name == other.name

    def __le__(self, other):
        return  self.name <= other.name


a = Demo('Python')
b = Demo('Java')
print(a == b)
print(a >= b)
print(a <= b)
print(a > b)
print(a < b)

'''
False
True
False
True
False
'''
```
> 注意：在Python中，当我们只定义一个相反比较时只定义其中一个时，在进行比较时会自动取反。如果两个都定义了就分别调用两个方法。

```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __gt__(self, other):
        print(self.name, other.name)
        return self.name > other.name


a = Demo('Python')
b = Demo('Java')
print(a > b)
print(a < b)
"""
Python Java
True
Java Python
False
"""
```
# 四、运算符方法
### 1. 运算符
可以通过重写下面的魔法方法使实例对象可以进行运算。
```python
class Demo(object):
    def __init__(self, num):
        self.num = num

    def __add__(self, other):  # 加法
        return self.num + other.num

    def __sub__(self, other):  # 减法
        return self.num - other.num

    def __mul__(self, other):  # 乘法
        return self.num * other.num

    def __truediv__(self, other):  # 除法
        return self.num / other.num

    def __floordiv__(self, other):  # 整除
        return self.num // other.num

    def __mod__(self, other):  # 取余
        return self.num % other.num

    def __pow__(self, power, modulo=None):  # 幂运算
        return self.num ** power.num

    def __divmod__(self, other):  # divmod()
        return divmod(self.num, other.num)

    def __lshift__(self, other):  # 左移
        return self.num << other.num

    def __rshift__(self, other):  # 右移
        return self.num >> other.num

    def __and__(self, other):  # 按位与
        return self.num & other.num

    def __or__(self, other):  # 按位或
        return self.num | other.num

    def __xor__(self, other):  # 按位异或
        return self.num ^ other.num


a = Demo(2)
b = Demo(3)
print(a + b)
print(a - b)
print(a * b)
print(a / b)
print(a // b)
print(a % b)
print(a ** b)
print(divmod(a, b))
print(a << b)
print(a >> b)
print(a & b)
print(a | b)
print(a ^ b)
"""
5
-1
6
0.6666666666666666
0
2
8
(0, 2)
16
0
2
3
1
"""
```
### 2. 反运算符
在运算符魔法方法前加一个 **r** 即构成反运算符方法。
例如：
在 a + b 时，如果a有 \_\_add__() 方法，那么就执行 a.\_\_add__(b) 操作；如果 a 没有 \_\_add__() 魔法方法，就调用 b的 \_\_radd__() 方法，执行 b.\_\_radd__(a) 操作；如果以上条件都不满足，则抛出 TypeError。
```python
class Demo(object):
    def __init__(self, num):
        self.num = num

    def __radd__(self, other):
        print(self.num, other.num)
        return self.num + other.num


class De(object):
    def __init__(self, num):
        self.num = num


a = Demo(2)
b = De(3)
print(b + a)
"""
2 3
5
"""
```
### 3. 增量赋值运算符
在运算符前面加一个 **i**即可实现增量赋值运算。
例如：
i
```python
class Demo(object):
    def __init__(self, num):
        self.num = num

    def __iadd__(self, other):
        return self.num + other.num

a = Demo(2)
b = Demo(3)
a += b
print(a)
"""
5
"""
```
### 4. 一元操作符
下列方法可以实现一元操作。
```python
class Demo(object):
    def __init__(self, num):
        self.num = num

    def __pos__(self):
        return abs(self.num)

    def __neg__(self):
        return -self.num

    def __abs__(self):
        return abs(self.num)

    def __invert__(self):
        return ~self.num

a = Demo(2)
print(+a)
print(-a)
print(abs(a))
print(~a)
"""
2
-2
2
-3
"""
```
# 五、描述符
关于描述符的介绍可以参照下面这位大佬的文章：
[大佬的文章](https://www.cnblogs.com/Jimmy1988/p/6808237.html)
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __get__(self, instance, owner):
        print('get', instance, owner)

    def __set__(self, instance, value):
        print('set', instance, value)

    def __delete__(self, instance):
        print('delete', instance)


class demo(object):
    x = Demo('Python')

a = demo()
print(a.x)
a.x = 1
del a.x
```
# 六、容器操作
### 1. \_\_len__（获取对象长度）
使用 len() 函数时会调用该魔法方法。
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __len__(self):
        return len(self.name)


a = Demo('Python')
print(len(a))
# 6
```
### 2. \_\_iter__（定义迭代器）
用该方法创建一个迭代器对象。
```python
class Demo(object):
    def __init__(self, data):
        self.data = data

    def __iter__(self):
        return self

    def __next__(self):
        self.data += 1
        return self.data


a = iter(Demo(1))
print(next(a))
print(next(a))
# 2
# 3
```
### 3. 对容器指定元素的操作
对容器内指定元素操作时调用下列方法（字典操作）。
```python
class Demo(object):
    def __getitem__(self, item):
        print('__getitem__', item)

    def __setitem__(self, key, value):
        print('__setitem__', key, value)

    def __delitem__(self, key):
        print('__delitem__', key)


a = Demo()
a['a']
a['b'] = 123
del a['c']
"""
__getitem__ a
__setitem__ b 123
__delitem__ c
"""
```
### 4. \_\_reversed__（反转）
当调用 **reversed()** 函数时调用该魔法方法。

```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __reversed__(self):
        return self.name[::-1]


a = Demo('Python')
print(reversed(a))
# nohtyP
```
### 5. \_\_contains__（判断元素位置）
当调用 **in** 或者 **not in** 判断元素是否在对象中时会调用该魔法方法。
```python
class Demo(object):
    def __init__(self, name):
        self.name = name

    def __contains__(self, item):
        return item in self.name


a = Demo('Python')
print('P' in a)
print('P' not in a)
```
# 七、with语句
with语句是Python中的上下文管理器，可以利用魔法方法来实现自定义。

```python
class Demo(object):
    def __enter__(self):
        print("start")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print('end')
        print(exc_type, exc_val, exc_tb)

    def __init__(self):
        self.name = 'Python'


a = Demo()
with a as b:
    print(b.name)
'''
start
Python
end
None None None
'''
with a:
    raise ImportError
'''
start
end
<class 'ImportError'>  <traceback object at 0x0000026C1C391F88>
'''
```
\_\_enter__()方法管理上文（即开始时刻），\_\_exit__()方法管理下文（即退出时刻）。
\_\_enter__()方法的返回值可以通过as语句接收；
\_\_exit__()方法的参数**exc_type,  exc_val,  exc_tb**用以接收异常类型，异常值，异常跟踪信息。当没有异常时三个参数都为**None**。