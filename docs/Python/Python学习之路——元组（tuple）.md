# Python 学习之路——元组(tuple)

元组是Python序列中一种不可变序列。当我们希望数据不变的时候我们就用元组，其余情况都用列表。

# 一、创建元组
```python
# 方式一 
tup1 = ("1",)
# 方式二
tup2 = "1", # 注意要有逗号
# 方式三
tup3 = tuple()
# 在tuple()中可传递一个可迭代对象，如果不传参数则生成一个空元组
# 实例：
tup4 = tuple("123") # tup4 = ('1', '2', '3')
```
# 二、访问元组的值
## 1. 通过索引访问
元组作为Python序列结构的一种，可以通过访问索引值进行访问元组。元组的索引值从0开始。
```python
tup = tuple("Python")
print(tup[0]) # "P"
```
当访问的索引值超过元组的最大索引值时就会抛出异常
```python
tup = tuple("Python")
print(tup[6]) 
# IndexError: tuple index out of range
```
## 2. 切片操作
列表可以进行切片截取操作。
```python
tup = tuple("Python")
print(tup[1:5:3]) # ['y', 'o']
# list[start:end:step]
# 进行切片操作时可以传递三个值，分别是开始索引，结束索引和步长
# 开始索引默认为0，结束索引默认为最大索引值，步长默认为1
```
# 三、元组的特殊操作
## 1. 元组的拼接
元组虽然无法直接对元组内的对象进行删增操作，但是可以通过元组之间相加的方式进行增添。
```python
tup1 = (1,2)
tup2 = (3,4)
# "+" 可以将两个列表进行首尾相接
tup3 = tup1+tup2 # tup3 = (1, 2, 3, 4)
# 魔术方法 面向对象
tup3 = tup2.__add__(tup1) # tup3 = (1, 2, 3, 4)

# "*" 可以让一个列表元素进行重复
tup3 = tup1*2 # tup3 = (1, 2, 1, 2)
# 魔术方法 面向对象
tup3 = tup1.__imul__(2) # tup3 = (1, 2, 1, 2)
```
## 2. 判断元素是否在元组内部
```python
tup = tuple("Python")
"P" in tup # True
```
## 3. 元组的遍历
元组作为一种可迭代对象，是可以利用for进行遍历的
```python
tup = tuple("Python")
for i in tup:
	print(i)
# P
# y
# t
# h
# o
# n
```
## 4. 元组的解包
元组有着一个特殊的使用方法——解包。
解包，顾名思义就是将打包的元组解开，将元组当中每一个元素都赋值给一个变量。
### 1）全部提取
在对一个元组进行全部解包时，变量的数量要和元组中元素保持一致。
```python
a, b, c = (1, 2, 3) # a = 1, b = 2, c = 3
```
### 2）部分提取
当我们只想取出元组中的部分参数时，我们可以在变量前面添加一个 *，元组中的其他值将会以列表的形式赋值给加了 * 的这个参数。
```python
tup = tuple("Python")
*a, b, c = tup # a = ['P', 'y', 't', 'h'], b = 'o', c = 'n'
a, *b, c = tup # a = 'P', b = ['y', 't', 'h', 'o'], c ='n'
a, b, *c = tup # a = 'P', b = 'y', c = ['t', 'h', 'o', 'n']
```
# 四、元组常用函数
## 1.求取元组长度(len)
```python
tup = (1, 2, 3)
# len()函数
len(tup) # 3
# 魔法方法 面向对象
tup.__len__() # 3
```
## 2.求取元组元素的最值(max,min)
```python
tup = (1, 2, 3)
# max()函数求取列表元素的最大值
max(tup) # 3
# min()函数求取列表元素的最小值
min(tup) # 1
```
## 3. 对元组里的元素排序(sorted)
```python
tup = (1, 2, 3, 6, 4, 5)
# sorted()函数可对可迭代对象进行排序，并返回一个列表
sorted(lis) # [1, 2, 3, 4, 5, 6]
```
## 4. 对元组进行反转(reversed)
```python
tup = (1, 2, 3)
# reversed()函数可以对可迭代对象进行排序，并返回一个迭代器
for i in reversed(tup):
	print(i)
# 3
# 2
# 1
```
# 五、元组常用方法
## 1. 统计某个元素在元组中出现的次数(count)
```python
tup = (1, 2, 3, 3)
# count()方法可以统计元素在元组中的出现次数，并返回次数
# 如果需要统计的元素不在元组则返回 0 而不会抛出异常
tup.count(3) # 2
```
## 2. 获取元组元素第一个匹配项的索引位置(index)
```python
tup = (1, 2, 3)
# index()方法可以从元组中找出某个值第一个匹配项的索引位置
tup.index(3) # 2
# 当查找元素不在列表时会抛出异常
tup.index(4)
# ValueError: tuple.index(x): x not in tuple
```
# 六、== 与 is的区别
Python中每一个对象都是由值(value)、类型(type)和地址(id)组成。
## 1. == 与 !=
用 == 和 != 比较的时候比较的是对象的值
```python
a = [1,2,3]
b = [1,2,3]
a == b # True
```
## 2. is 与 is not
用 is 和 is not 比较的时候比较的是对象的地址
```python
a = [1,2,3]
b = [1,2,3]
a is b # False
```