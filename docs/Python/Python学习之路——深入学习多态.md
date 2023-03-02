# Python 学习之路——深入学习多态

# 一、多态

### 定义：
> 多态指同一种事物有着多种状态。

在Python中多态指不同类型的实例有相同的调用方法。
### 实现：

```python
class Base():
    def say(self):
        print('I am a animal.')

class Dog(Base):
    pass

class Cat(Base):
    pass


dog = Dog()
cat = Cat()
dog.say()
cat.say()
```
在上面的程序中，定义了一个 **Base类**，在该类中实现了一个 say() 方法，** Cat类和Dog类** 都继承自Base类，同时也继承了say() 方法。故都可以调用say方法。
虽然 **Cat类和Dog类** 是不同的类，但都是 **Base类** 的子类。Base类有着多种状态，这就是多态。
 # 二、鸭子类型
 ### 定义：
> When I see a bird that walks like a duck and swims like a duck and quacks like a duck, I call that bird a duck.

鸭子类型的定义来自美国诗人詹姆斯·惠特科姆·莱利的诗句，它的中文翻译：
>当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。

"鸭子类型"像多态一样工作，但是没有继承。
也就是说，它不关注对象的类型，而是关注对象具有的行为(方法)。
### 实现：
```python
class Dog(object):
    def say(self):
        print("i am Dog")

class Duck(object):
    def say(self):
        print("i am Duck")


animal = []
dog = Dog()
animal.append(dog)
duck = Duck()
animal.append(duck)
for i in animal:
    i.say()
```
在程序中，**Duck类和Dog类** 都定义了 **say()** 方法，因此可以认为是相同的类，因此可以将两个的实例对象添加到 **animal** 列表中，通过 **for循环** 调用 **say()** 方法。
# 三、抽象基类
### 定义：
> 抽象类（abstract baseclass,ABC）是指在类中定义了纯虚成员函数的类。纯虚函数一般只提供了接口，并不会做具体实现，实现由它的派生类去重写。
> 抽象类不能被实例化（不能创建对象），通常是作为基类供子类继承，子类中重写虚函数，实现具体的接口。

简言之，抽象基类是不能用以实例化的，抽象基类存在的意义就是为了让另一个子类来继承的。继承了抽象基类的子类必须重写抽象基类中实现的虚函数。
### 实现：
在Python语言中，通过继承官方库 **abc** 来实现抽象基类。

```python
import abc

class Base(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def say(self):
        pass

class Dog(Base):
    def say(self):
        print('I am a dog.')

class Cat(Base):
    def say(self):
        print('I am a cat.')


animal = []
dog = Dog()
animal.append(dog)
cat = Cat()
animal.append(cat)
for i in animal:
    i.say()
'''
I am a dog.
I am a cat.B
'''
```
在上面的程序中，我们定义了一个抽象基类 **Base类** ，并在这个类中定义了一个虚函数 **say()** 函数，通过代码可以看出在这个类中 say() 函数并没有实现任何功能，这也就是叫虚函数的原因。
**Cat类和Dog类** 都继承了抽象基类 **Base类** ，因此需要重写该类里的虚函数 **say()** 。正因为都重写了 say() 函数，因此才能都添加到 **animal** 这个列表里，并通过 for 循环进行调用 say() 函数。
# 四、isinstance和type的区别
**isinstance函数** 是用来判断实例对象所属类型的；
**type函数** 可以直接返回实例对象的类型。
那么这两个直接又有什么区别呢？

```python
class A:
    pass

class B(A):
    pass


b = B()
print(isinstance(b, B))     # True
print(isinstance(b, A))     # True
print(type(b) is B)         # True
print(type(b) is A)         # False  
```
从上面代码执行的结果中我们可以发现 **isinstance函数** 是考虑了类的继承关系的，但是用 **type函数** 进行判断时，type函数只返回对象实例的类，而不会考虑继承关系。