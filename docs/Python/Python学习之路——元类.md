# Python 学习之路——元类

# 一、什么是元类？

在Python中，一切皆对象。
众所周知，实例化对象是由类创建的。那么类是不是对象？它又是由什么创建的呢？
答案是肯定的，类也是一个对象，**类是由元类创建的**。
```python
class A():
    pass


print(type(A))  # <class 'type'>
print(isinstance(A, type))  # True
```
通过代码我们可以发现，**类的类居然是 type**。
在我们以往的认知中，我们只知道可以用 type() 函数来查看对象的类。没想到 **type 也是一种类**，还是最顶端的元类。
# 二、动态创建类
### 1. 自定义函数
```python
def createClass(name):
    if name == 'teacher':
        class User(object):
            def __str__(self):
                return "teacher"
        return User

    elif name == 'student':
        class Student:
            def __str__(self):
                return "student"
        return Student

User = createClass('teacher')
a = User()
print(str(a))  # teacher
```
在上面的代码中，我们自定义了一个创建的类的函数，通过检测传入的字符串来创建对应的类。因为类也是对象，所以可以通过函数返回，然后再实例化创建对象。
### 2. type()函数
在上面的代码中，我们虽然实现了动态创建类，但是局限性很大，而且也十分不方便，那个我们还有什么更好的方法吗？
当然有！那就是用我们强大的 **type() 函数**。
我们通过查看 type() 函数的源码可以看到下面一段注释：
```python
"""
type(object_or_name, bases, dict)
type(object) -> the object's type
type(name, bases, dict) -> a new type
"""
```
我们平时用的就是它的第二种用法——传入一个实例对象返回对象的类型。现在创建类的话我们就要用 type() 函数的其它用法了。
首先我们先了解一下type() 函数各个参数：
> name：需要创建的类的名称，类型为字符串
> bases：需要继承的父类，类型为元组
> dict：需要给类添加的方法和属性，类型为字典

知道了各个参数的用法后我们就可以动态的创建类了。

```python
def speak(self):
    print(self.name)

Student = type('Student', (), {'name':'Python', 'speak':speak})
print(type(Student))  # <class 'type'>
student = Student()
student.speak()  # Python
print(type(student))  # <class '__main__.Student'>
```
我们可以发现我们成功地利用 type() 函数创建了一个类，并且成功地实例化了。说明利用 type() 方法动态创建类是可行地。