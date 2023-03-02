# Python 学习之路——函数

函数是组织好的，可重复使用的，用来实现单一，或相关联功能的代码段。函数能提高应用的模块性和代码的重复利用率。函数也是一个对象！

# 一、创建函数
函数的语法：
```python
def 函数名([形参1,形参2,形参3...]):
    # 代码块（代码块不能为空）
```
例子：
```python
# 例如：
def fn():
	print('Python')
```

上面的这个例子就是一个函数，这个函数的功能就是打印字符串 'Python' 。其中需要注意的是，fn() 为调用函数，而 fn 是函数对象。
```python
fn()
# 'Python'
print(fn)
# <function fn at 0x00000294319D22F0>
# 解读：fn是一个function(函数)对象，他在内存中的地址为0x00000294319D22F0
```
# 二、函数的参数
函数传递的参数可以是任意对象，函数的参数分为形参和实参。
定义：
**形参(形式参数)**：定义形参就是相当于在函数内部定义了变量，但是并没有赋值
**实参(实际参数)**：函数定义时指定了形参，那么调用函数的时候也必须传递实参
形参就是定义函数时使用，实参就是调用函数时使用，参数用逗号隔开。
## 1. 位置参数
在定义函数的时候，可以在函数名后面的括号里面定义数量不等的位置参数。
```python
# 定义fn()时写的的a, b就是该函数的两个位置参数
def fn(a, b):
	print(a + b)
fn(1, 2)  # 3
```
## 2. 关键字参数
关键字传参可以不按照形参定义的顺序去传参，而根据参数名来传递参数。关键字参数定义式需要有一个初始值。
```python
def fn(a = 1, b = 2): #a, b就是两个关键字参数
	print(a + b)
fn() # 3
fn(a = 3, b = 4) # 调用函数时可以传递关键字参数
# 7
```
位置参数和关键字参数可以混合使用，混合使用的时候位置参数必须在关键字参数前面：
```python
def fn(a, b = 2): #a是位置参数b是关键字参数
	print(a + b)
fn(1) # 3
```
## 3. 不定长参数
在定义函数的时候，如果函数需要传入位置参数较多，可以在位置参数的前面加上一个 * ，这样这个形参将会获取到所有的位置参数，以元组形式保存。
```python
def fn(*a):
	print(a)
fn(1,2,3) # (1,2,3)
```
当关键字参数较多时也可以使用不定长参数，在参数前面加上 **，那么这个参数就是一个保存所有关键字的不定长参数，以字典形式保存。
```python
def fn(**a):
	print(a)
fn(a = 1, b = 2,c = 3) # {'a' = 1, 'b' = 2, 'c' = 3}
```
## 4. 参数的解包
当调用函数时需要传递的参数较多，可以将需要传递的参数先打包，在调用时进行解包。
```python
def fn(a,b,c):
    print('a =', a)
    print('b =', b)
    print('c =', c)
d = {'a':100,'b':200,'c':300}
fn(**d)
```
# 三、函数的返回值
返回值就是函数执行以后返回的执行结果，一个函数可以有返回值也可以没有返回值，可以有一个返回值也可以有多个返回值。Python语言中用return来指定函数的返回值，return后面可以跟任意对象。函数执行完return语句后就结束调用，return后的语句不再执行。
```python
# 计算传递的参数的和并返回
def fn(*args):
	result = 0
	for i in args:
		result += i
	return result
	print("End!") # 该条语句不会执行
res = fn(1,2,3) # res = 6
```
当函数只写一个return或者不写return时，函数返回值为None。
```python
def fn(a):
	print(a)
res = fn(1) # res = None
```
# 四、函数文档注释
当我们在编写程序时，为了让使用者更好的了解我们这个函数的功能，我们可以编写函数文档注释，对这个函数做一个使用说明。同样我们在使用别人的程序时也可以通过查看文档注释来了解函数。
```python
def fn():
    """
    打印字符串'Python'
    :return: None
    """
    print('Python')
help(fn)
# fn()
#    打印字符串'Python'
#    :return: None
```
# 五、函数作用域
作用域指的就是变量生效的区域。
**全局作用域：**
全局作用域在程序执行时创建，在程序执行结束时销毁，所有函数以外的部分都是全局作用域，在全局作用域中定义的变量，都属于全局变量，全局变量可以在程序的任意位置访问。
**函数作用域：**
函数作用域在函数调用时创建，在调用结束后销毁，函数每调用一次就会产生一个新的作用域，在函数作用域中定义的变量都是局部变量，它只能在函数内部被访问到。
```python
a = 10 # a就是全局变量
def fn():
	b = 20 # b就是局部变量
	print(a, b) # 10,20
fn()
print(b) # 由于b是局部变量，在函数外部不能访问
```
如果希望在函数定义域中定义全局变量，可以添加global关键字:
```python
a = 10 # a就是全局变量
def fn():
	global b
	b = 20 # b就是局部变量
	print(a, b) # 10,20
fn()
print(b) # 20
```
# 六、命名空间
命名空间实际上就是一个字典，专门用来储存该作用域变量的字典。
locals()函数用来获取当前作用域的命名空间。
```python
a = 10
print(locals())
# {'__name__': '__main__', '__doc__': None, '__package__': None, '__loader__': <_frozen_importlib_external.SourceFileLoader object at 0x00000182308D60B8>, '__spec__': None, '__annotations__': {}, '__builtins__': <module 'builtins' (built-in)>, '__file__': 'Python.py', '__cached__': None, 'a': 10}
# 可以通过当前命名空间看到定义在全局定义域的a变量
```
向当前命名空间中添加键值对，可以定义一个位于当前作用域的变量。
```python
a = locals()
a['b'] = 10
print(b) # 10
```
globals()函数可以用来在任意位置获取全局命名空间。
```python
def fn():
	a = globals()
	print(a)
fn()
# {'__name__': '__main__', '__doc__': None, '__package__': None, '__loader__': <_frozen_importlib_external.SourceFileLoader object at 0x000002758A9760B8>, '__spec__': None, '__annotations__': {}, '__builtins__': <module 'builtins' (built-in)>, '__file__': 'Python.py', '__cached__': None, 'a': 10, 'fn': <function fn at 0x000002758AC622F0>}
```