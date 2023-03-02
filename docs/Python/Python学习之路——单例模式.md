# Python 学习之路——单例模式

# 一、定义：

单例模式（Singleton Pattern）是最简单的设计模式之一。这种类型的设计模式属于**创建型模式**，它提供了一种**创建对象的最佳方式**。
这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保**只有单个对象**被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。
# 二、举例：
1. 中国的婚姻制度其实就是一个活生生的单例模式。在你和一位女性结婚时，你需要去民政局登记（**实例化**）。当你还想要像封建时代那样再找一个老婆时，你去民政局时就没法登记结婚（**无法创建新的实例**），并且民政局还会告诉你你的合法妻子是谁（**返回最先创建的实例对象**）。
2.  Windows 的任务管理器也是一种典型的单例模式。我们知道当我们打开多个任务管理器窗口（**实例化**），它们显示的内容完全一致的。
如果每打开一个窗口就创建一个对象，对象之间又是一模一样的。那这些就是重复对象，就造成了内存的浪费；相反，如果两个窗口的内容不一致（**创建了不同的实例**），那就会至少有一个窗口展示的内容是错误的，会给用户造成误解。因此实际上在打开多个任务管理器窗口时，展现的都是同一个实例对象。
3. 如果我们在一个项目中的多个地方都需要读取同一份配置文件。如果每次使用都是导入重新创建实例，读取文件，用完后再销毁，这样做的话，就造成不必要的IO浪费，可以使用单例模式只生成一份配置在内存中。
# 三、代码实现：
### 思路：
第一次成功创建实例，利用容器保存这个实例；
后面创建实例时，返回容器中的这个实例，不另外创建实例。
### 1. 加载模块实现

```python
class Singleton(object):
	pass

demo = Singleton()
```
> singleton.py
```python
from singleton import demo
```
在Python中，模块只加载一次，因此只会创建一次实例。
### 2. \_\_new__方法实现
```python
class User:
    _instance = None  # 储存类的实例
    
    def __new__(cls, *args, **kwargs):  # 创建实例之前调用
        print('Implement ...')
        if not cls._instance:  # 判断类是否是第一次创建实例
            print("Create examples")
            cls._instance = super().__new__(cls)  # 创建实例
        return cls._instance  # 返回唯一实例
    
    def __init__(self):
        print('Initialization')

a = User()
b = User()
print(a is b)  # True
```
### 3. 装饰器实现
```python
instances = {}  # 存储类的唯一实例

def Singleton(cls):
    def get_instance(*args, **kw):
        cls_name = cls.__name__  # 获得类的名字
        if not cls_name in instances:  # 判断类是否是第一次创建实例
            instance = cls(*args, **kw)  # 创建实例
            instances[cls_name] = instance  # 将类和实例存进字典
        return instances[cls_name]
    return get_instance

@Singleton
class User:
    _instance = None
    def __init__(self):
        print('Initialization')


a = User()
b = User()
print(a is b)  # True
```
### 4. 元类实现
```python
class MetaSingleton(type):
    def __call__(cls, *args, **kwargs):  # __call__方法控制实例的生成
        print('Implement ...')  # 创建实例时首先执行元类的此方法
        if not hasattr(cls, "_instance"):  # 判断类中是否有“_instance”属性，如果有说明不是第一次创建
            print("Create examples")
            cls._instance = super().__call__()  # 创建实例
        return cls._instance  # 返回第一次创建的实例


class User(metaclass=MetaSingleton):
    def __init__(self):
        print('Initialization')


a = User()
b = User()
print(a is b)  # True
```
# 四、并发场景下
```python
import time
import threading

class User:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            time.sleep(1)
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        pass

def task():
    u = User()
    print(u)

for i in range(10):
    t = threading.Thread(target=task)
    t.start()
```
> 结果：
> <__main__.User object at 0x000001A9FF387A88>
> <__main__.User object at 0x000001A9FF30CF08>
> <__main__.User object at 0x000001A9FF30F948>
> <__main__.User object at 0x000001A9FF305588>
> <__main__.User object at 0x000001A9FF305C48>
> <__main__.User object at 0x000001A9FF30F948>
> <__main__.User object at 0x000001A9FF305C48>
> <__main__.User object at 0x000001A9FF305588>
> <__main__.User object at 0x000001A9FF305C48>
> <__main__.User object at 0x000001A9FF30F948>

在上面的代码中，当我们开启十个线程创建单例时出现了问题。结果是创建了十个对象而非一个。
### 原因：
因为在一个对象创建的过程中，另外一个对象也创建了。在它判断的时候，会先去获取**类的_instance属性**。因为这个时候进入等待，没有创建实例对象。因此每一个线程都会创建一个实例对象，故创建了十次实例对象。
究其原因是速度不匹配引发的资源问题，当延时越小时创建的对象越少。
### 解决办法
可以用加锁的方式来解决这个问题。
```python
import time
import threading

def task():
    u = User()
    print(u)

def synchronized(func):
    func.__lock__ = threading.Lock()

    def lock_func(*args, **kwargs):
        with func.__lock__:
            return func(*args, **kwargs)

    return lock_func

class User:
    _instance = None

    @synchronized
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            time.sleep(1)
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        pass


if __name__ == '__main__':
    for i in range(10):
        t = threading.Thread(target=task)
        t.start()
```
# 五、优缺点
### 优点：
1. 数据同步
2. 减少内存占用
### 缺点：
1. 全局变量，维护应当小心
2. 没有抽象层，拓展不便