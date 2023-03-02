# Python 学习之路——高阶函数

Python语言中，一切皆对象。函数本身也是一个对象，我们知道函数的参数可以传递任意对象，函数的返回值也可以返回任意对象，那么在Python中函数能不能传递或者返回一个函数呢？答案是当然可以，我们把这种传参为函数或者返回值为函数对象的函数称为高阶函数。

# 一、递归函数
定义：在计算过程中，如果其中后一步都要用到前一步的结果，称为递归的。调用自身的函数称之为递归函数。
递归式函数有两个条件
1.**基线条件：**问题可以被分解为最小的问题，当满足基线条件的时候，递归就不在执行了。
2.**递归条件：**将问题可以分解的条件。
例题：计算100的阶乘结果。
```python
def fn(n):
    if n == 1: # 基线条件
        return 1
    else: # 递归条件
        return n + fn(n-1)
print(fn(100)) # 5050
```
# 二、匿名函数
对于一些功能简单，使用次数不多的函数，我们可以将它定义为匿名函数，来节省内存空间提高代码效率。lambda函数表达式就是用来创建匿名函数的。
语法格式：lambda 参数列表 : 返回值
```python
x = lambda i:i+1
print(x(5)) # 6
```
# 三、函数闭包
当我们有一些函数或者数据，不希望用户知道或者修改的时候，我们就需要对函数或者内部数据进行闭包处理。通过闭包可以创建一些只有当前函数才能访问的对象，还可以将一些私有的数据藏到闭包中。
**形成闭包的条件:**
1. 函数嵌套
2. 将内部函数作为返回值返回
3. 内部函数必须使用到外部函数的变量
```python
def fn():
	def fn1(a):	# fn1函数就是我们想要隐藏的函数
		print(a)
	return fn1
a = fn()
a("Python") # Python
```
# 四、装饰器
在了解装饰器之前，我们先了解一个软件设计模式的开闭原则（OCP）：
OCP全称Open Closed Principle。一个软件实体的模块和函数应该对扩展开放，对修改关闭。
遵守开闭原则可以极大提高提高系统的可维护性和代码的重用性。
为了既不对原有的函数进行修改，又想要拓展原有函数的功能，我们可以通过一个新的函数来拓展原有函数的功能。这个新的函数就叫装饰器函数。
**原则：拓展函数或类的功能，但不影响原来的调用**
```python
def fn1():	# 原函数
    sum = 0
    for i in range(10):
        sum += i
    print(sum)

def fn2(old):	# 装饰器函数
    def fn3(*args,**kwargs):
        print("开始执行函数...")
        old()
        print("函数执行完毕！")
    return fn3
    
fn2(fn1)()
# 开始执行函数...
# 45
# 函数执行完毕！
```
### 装饰器语法糖
为了使装饰器变得更加美观，Python中加入了语法糖，语法糖使程序变得更加整洁美观。

```python
def fn2(old):
    def fn3(*args,**kwargs):
        print("开始执行函数...")
        old()
        print("函数执行完毕！")
    return fn3
    
@fn2
def fn1():
    sum = 0
    for i in range(10):
        sum += i
    print(sum)
    
fn1()
# 开始执行函数...
# 45
# 函数执行完毕！
```
### 1. 函数装饰器
函数装饰器即以函数作为装饰器。
```python
def fn2(old):
    def fn3(*args,**kwargs):
        print("开始执行函数...")
        old()
        print("函数执行完毕！")
    return fn3
    
@fn2
def fn1():
    sum = 0
    for i in range(10):
        sum += i
    print(sum)
    
fn1()
# 开始执行函数...
# 45
# 函数执行完毕！
```
### 2. 类装饰器
类装饰器即以类作为装饰器。
想要以类作为装饰器，则必须要在内中实现**\_\_call__魔法方法和\_\_init__魔法方法**。
```python
class User(object):
    def __call__(self, *args, **kwargs):
        print('Start function...')
        self._fun(*args, **kwargs)
        print('Function end...')

    def __init__(self, fun):
        self._fun = fun

@User
def fun(*args, **kwargs):
    print(*args, **kwargs)

fun('Python')
'''
Start function...
Python
Function end...
'''
```