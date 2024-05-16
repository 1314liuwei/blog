# Python 学习之路——面向对象入门

# 一、面向对象简介

总所皆知，Python语言是一门面向对象得语言。那么，对象是什么？面向对象又是什么？
万物皆对象。任何一个实体都是对象，例如一个人，一辆车等等，这些都是一个又一个对象。
面向对象也就是描述对象的的过程，比如一个人有身高、年龄等特征，还有睡觉、走路等行为，面向对象就是要把对象的特征及其行为添加到对象的身上，使之丰满具体。

面向对象有着三大特征：
**封装 确保对象中的数据更安全
继承 保证了对象的可扩展性
多态 保证了程序的灵活性**
# 二、对象的结构
在Python中，每一个对象都是由三部分构成的：id（标识）、type（类型）和value（值）。
**id(标识)**：id 用来标识对象的唯一性，每个对象都有唯一的id，id 是由解释器生成的，id就是对象的内存地址。在Python中可以通过id()函数来查看对象的的id。
**type(类型)**：类型就决定了对象有哪些功能，在Python中可以通过type()函数来查看对象的类型。
**value(值)**：值指的就是对象中存储的具体数据，可变对象的值可变，不可变对象的值不可变。
# 五、类
在Python中，类是一个很重要的结构。类是什么？类本质上也是一个对象(类是一个用来创建对象的对象)。类就像是一张白纸，需要我们来对其进行描绘。
## 1. 定义一个类
```python
class Myclass():
	pass
	
a = Myclass()
```
在上面的代码中，我们先是创建了一个名字为Myclass的类，然后创建了一个Myclass类型的对象a。在Python中我们可以用isinstance()函数来检查一个对象是否是一个类的实例。
```python
print(isintance(a, Myclass) # True
```
## 2. 为类添加属性和方法
在类中，可以定义为类定义变量和函数：
在类中的变量将会成为所有实例的公共属性。所有实例都可以访问这些变量；
在类中可以定义函数，类中的函数我们称之为方法，这些方法该类的实例都可以访问， 如果是函数，有几个形参传几个实参，如果是方法 默认传递一个参数 所以类中的方法至少要定义一个形参：self。
```python
class Myclass():
	name = 'Python'
	def speak(self):
		print('Life is short, I use Python')
		
a = Myclass()
print(a.name) # Python
a.speak() # 'Life is short, I use Python'
```
在上面的代码中，我们定义了一个Myclass类，并为其添加了一个name属性和一个speak方法。然后为我们定义的类初始化了一个实例，并访问了属性使用了方法。
## 3. 添加魔术方法
在Python的类中，有着特殊方法，特殊方法都是以“__”双下划线开头，特殊方法不需要我们自己调用，在特殊情况下会自动调用。
### \_\_init__()
在对类进行实例化的过程中，会自动调用__init__()方法，\_\_init__()方法可以用来初始化新建对象的属性。
```python
class Myclass():
    def __init__(self, name):
        self.name = name

    def speak(self):
        print(self.name)
        
a = Myclass("Python")
a.speak()	# Python
```
由于我们在定义__init__()方法时，加入了name参数，所以在初始化实例对象时需要输入一个实参进行初始化。
### \_\_len__()
在定义类时加入__len__()方法，就可以为调用len()方法求取该类的实例化对象的长度。
```python
class Myclass():
    def __len__(self):
        return 10
        
a = Myclass()
print(len(a)) # 10
```
像我们之前之所以可以用len()函数求取列表、元组等这些数据结构的对象的长度，也都是因为在这些类中有着__len__()方法，我们可以通过查看Python源码知道的。
Python的类中还有更多的特殊方法：

 - \_\_init__ : 构造函数，在生成对象时调用
 - \_\_del__ : 析构函数，释放对象时使用
 - \_\_repr__ : 打印，转换
 - \_\_setitem__ : 按照索引赋值
 - \_\_getitem__: 按照索引获取值
 - \_\_len__: 获得长度
 - \_\_cmp__: 比较运算
 - \_\_call__: 函数调用
 - \_\_add__: 加运算
 - \_\_sub__: 减运算
 - \_\_mul__: 乘运算
 - \_\_truediv__: 除运算
 - \_\_mod__: 求余运算
 - \_\_pow__: 乘方

## 4. 封装
**封装是面向对象的三大特性之一**
在我们之前对函数的学习中，我们可以用装饰器对函数进行封装。在类中，我们也可以对其进行封装。对类中的属性和方法进行封装，可以保证数据的安全，隐藏一些私有方法和属性，降低程序出现问题的风险。
### 封装属性
当在类中有一些属性我们不希望在外部知道属性的名字时，可以用下滑线进行隐藏私有属性。
**单下划线**：
```python
class Myclass():
    def __init__(self):
        self._name = 'Python'
        
a = Myclass()
# 从外面不能看到_name属性
# 但是可以通过_name进行访问
print(a._name)  # Python
```
**双下划线**：
```python
class Myclass():
    def __init__(self):
        self.__name = 'Python'
        
a = Myclass()
# 不能从外面看到__name属性，也不能通过__name访问
# 但是可以通过_类名__属性名的方法进行访问
print(a._Myclass__name)  # Python
```
从上面的讲解可以发现，封装并不是绝对的，仍然是可以访问的，只是要麻烦一点。这个麻烦是为了告诉外部调用者该属性为类的私有属性，不要擅自修改。
### 封装方法
**限制访问**：
可以通过下划线的方式将属性进行封装。
```python
class Myclass():
    def __run(self):
        print('Python')
        
a = Myclass()
# 无法从外部看到run()方法
# 但是可以通过_类名__方法名的方法进行调用
a._Myclass__run() # Python
```
**封装成属性**：
在类中可以利用@property装饰器将一个方法转化为属性，我们可以像调用属性一样调用该方法。
```python
class Myclass():
    @property
    def run(self):
        print('Python')
        
a = Myclass()
# 在没有用装饰器之前，我们必须要通过a.run()来调方法
a.run # Python
```
### @property的妙用
当我们想让外部使用者对类中私有属性拥有一定权限时，我们可以通过装饰器来实现。
```python
class Person:
    def __init__(self):
        self._name = 'Python'
        
    # 读取私有属性    
    def name(self):
        return self._name
        
	# 修改私有属性
    def set_name(self,value):
        self._name = value
        
	# 删除私有属性
    def del_name(self):
        del self._name
        
a = Person()
print(a.name()) # Python
a.set_name('Java')
print(a.name()) # Java
a.del_name()
```
通过上面在类中使用的装饰器，我们就实现了对一个私有属性的读取、修改和删除。但是我们通过外部使用时是调用的方法，给人一种不是直接修改属性的感觉。这个时候我们就可以使用property装饰器进行神奇的修改了。
```python
class Person:
    def __init__(self):
        self._name = 'Python'
        
    # 读取私有属性
    @property
    def name(self):
        return self._name
        
    # 修改私有属性
    @name.setter
    def name(self,value):
        self._name = value
        
	# 删除私有属性
    @name.deleter
    def name(self):
        del self._name
        
a = Person()
print(a.name) # 'Python'
a.name = 'Java'
print(a.name) #Java
del a.name
```
通过property装饰器我们就实现了对私有属性的权限的修改，保证了内部属性的安全，并且调用时更加美观。
## 4. 继承
**继承是面向对象的三大特性之一**
继承可以提高代码的复用性，让类与类之间产生关系。
![动物分类](https://pic.try-hard.cn/blog/20191105201303943.jpg)
像上面这个动物分类一样，一条鱼它既属于鱼类，也属于脊椎动物，还属于动物，那么一条鱼它就既有鱼类的特征，也有脊椎动物和动物的特征，它拥有脊椎动物和动物特征的这个现象就叫做继承。
### 单一继承
```python
class Animal():
    def animal(self):
        print("This is an animal.")
        
# 在括号中传入类名，传入的类就作为父类
class Fish(Animal):
    def fish(self):
        print("This is an fish.")
        
a = Fish()
a.fish() # This is an fish.
a.animal() # This is an animal.
```
在上面的代码中，Animal是Fish的父类，Fish的实例a不仅仅拥有Fish类中的方法也有着Animal类中的方法。继承了父类，那么就会拥有父类的所有方法与属性。
当我们调用实例化对象的属性和方法时，会先从之间继承的子类中寻找，如果没有，再从其子类继承的父类中寻找。
```python
class A(object):
    def test(self):
        print('A')
        
class B(A):
    def test(self):
        print('B')
        
a = B()
a.test() # B
```
在上面的代码中，子类A和父类B中都有着相同的方法tset()，对象在调用方法时，因为会先找子类中的方法，所以代码输出就为"B"。
**在创建类的时候省略父类,则默认父类是object，object是所有类的父类，所有类都继承object**
### 多重继承
在Python我们还可以进行多重继承。有几个父类就在括号中写几个类名就行，这就是实现多重继承的方法。如果多个父类中有同名的方法，则会在第一个父类中寻找，然后找第二个。
在实际开发中没有特殊情况，我们一般避免使用多重继承，因为多重继承会让我们代码过于复杂，不易读懂，容易在实际使用中出现故障。
```python
class A(object):
    def test(self):
        print('A')
        
class B():
    def test(self):
        print('B')    
        
class C(A,B):
    def speak(self):
        print('I am C.')
        
a = C() # I am C.
a.test() # A
# 可以通过类名.__bases__获取当前类的所有父类
print(A.__bases__) # (<class '__main__.A'>, <class '__main__.B'>)
```
### 方法重写
在上面中我们讲到，在调用方法时，会先在子类中寻找，找不到才会去父类中寻找，包括特殊方法。当我们不希望调用父类的某种方法时，我们就可以在子类中重新写该方法，来覆盖父类中的方法。
### super()方法
当我们定义一个子类时，希望可以直接调用父类的__init__来初始化父类中的属性，但是在子类中又需要使用__init__方法，直接书写又会覆盖父类的方法。这个时候我们就需要用到super()方法了。
super()可以用来获取当前类的父类，并且通过super()返回的对象调用父类方法时**不需要传递self**。
```python
class Animal(object):
    def __init__(self):
        self.name1 = 'animal'

class Fish(Animal):
    def __init__(self):
        self.name2 = 'fish'
        super().__init__()
        
    def speak(self):
        print("This's a ",self.name2,"and an",self.name1)
        
a = Fish()
a.speak() # This's a  fish and a animal
```
## 多态
**多态是面向对象的三大特征之一**
在自然界中，鱼类有着许多种类，金鱼、鲤鱼、鲫鱼等等，但是他们都属于同一个类别——鱼类。像父类有多种子类的情况就叫做多态。
通过以上关系不难发现**继承是多态的基础**，有了继承才能实现多态。
```python
class A():
    def __init__(self):
        self.name = 'A'

class B():
    def __init__(self):
        self.name = 'B'

def speak(obj):
	if isinstance(obj, object):
		print(obj.name)
		
a = A()
speak(a) # A
b = B()
speak(b) # B
```
在上面的代码中，虽然a和b是两个不同类的对象，但是因为它们都是属于object类，所以它们都可以成功被speak()函数使用，这里就体现出其多态特性。
## 类与实例
**类属性**：直接在类中定义的属性就是类属性，类属性可以通过类或类的实例访问到，它只能通过类对象来修改，无法通过实例对象来修改。
**类方法**：类方法的第一个参数是cls，会被Python自动传递，cls就是当前的类对象，类方法可以通过类去调用，也可以通过实例调用。
**实例属性**：通过实例对象添加的属性属于实例属性，实例属性只能通过实例属性来访问和修改，类对象无法访问和修改。
**实例方法**：在类中定义的，以self为第一个参数的方法都是实例方法，实例方法在调用时，Python会自动将调用对象作为self传入。通过类对象调用时，不会自动传self,必须手动传self。
**静态方法**：静态方法基本上是一个和当前类无关的方法，它只是一个保存到当前类中的函数。静态方法一般都是些工具方法，和当前类无关，无法传递类属性或者实例属性，调用它时和普通函数使用方式一样。
```python
class Myclass(object):
	# 类属性
    name = 'cls'

    def __init__(self, value):
    # 实例属性
        self.value = value

	# 实例方法
    def test1(self):
        print(self.value)
	
	# 类方法
    @classmethod
    def tset2(cls):
        print(cls.name)
        
	# 静态方法
    @staticmethod
    def test3(str1):
        print(str1, 'World!')

a = Myclass('good')
a.name = 'self'

print(a.value) # good
print(a.name, ' || ', Myclass.name) # self  ||  cls

a.test1() # good
Myclass.test1(a) # good

a.tset2() # cls
Myclass.tset2() # cls

a.test3('Hello') # Hello World!
Myclass.test3('Hello') # Hello World!
```
关于面向对象的知识大概就是以上这些了，大家可以多多看看那些大牛写的Python代码，那里面使用面向对象知识点的地方很多，看别人写的代码也是一种学习哦！