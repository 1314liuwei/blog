# Python 学习之路——列表(list)

列表是最常用的Python数据类型。

# 一、创建列表
```python
# 方式一
list1 = ['Python']
# 方式二
list2 = list()
# 在list()中可传递一个可迭代对象，如果不传参数则生成一个空列表
# 例子:
lis3 = list('Python') # lis3=['P', 'y', 't', 'h', 'o', 'n']
```
# 二、访问列表的值
## 1. 通过索引访问
列表作为Python序列结构的一种，可以通过访问索引值进行访问列表。列表的索引值从0开始。
```python
lis = ['P', 'y', 't', 'h', 'o', 'n']
print(lis[0]) #P
```
当访问的索引值超过列表的最大索引值时就会抛出异常。
```python
lis = ['P', 'y', 't', 'h', 'o', 'n']
print(lis[6])
# IndexError: list index out of range
```
## 2. 切片操作
列表可以进行切片截取操作。
```python
lis = ['P', 'y', 't', 'h', 'o', 'n']
print(lis[1:5:3]) # ['y', 'o']
# list[start:end:step]
# 进行切片操作时可以传递三个值，分别是开始索引，结束索引和步长
# 开始索引默认为0，结束索引默认为最大索引值，步长默认为1
```
### 切片骚操作
1）反转列表
```python
lis = ['P', 'y', 't', 'h', 'o', 'n']
print(lis[::-1]) # ['n', 'o', 'h', 't', 'y', 'P']
```
2）复制列表
```python
lis = ['P', 'y', 't', 'h', 'o', 'n']
li = lis[:]
print(li) # ['P', 'y', 't', 'h', 'o', 'n']
```
# 三、列表的特殊操作
## 1. 列表的拼接
```python
lis1 = [1, 2, 3]
lis2 = [4, 5, 6]
# "+" 可以将两个列表进行首尾相接
lis3 = lis1 + lis2
print(lis3) # [1, 2, 3, 4, 5, 6]
# 魔术方法 面向对象
lis1.__add__(lis2) # [1, 2, 3, 4, 5, 6]

# "*" 可以让一个列表元素进行重复
lis4 = lis1 * 2
print(lis4) # [1, 2, 3, 1, 2, 3]
# 魔术方法 面向对象
lis1.__imul__(2) # [1, 2, 3, 1, 2, 3]
```
## 2. 判断元素是否在列表内部
```python
lis = [1, 2, 3]
2 in lis # True
```
## 3. 列表的遍历
列表作为一种可迭代对象，是可以利用for进行遍历的
```python
lis = [1, 2, 3]
for i in lis:
	print(i)
# 1
# 2
# 3
```
## 4. 列表推导式
Python作为一门及其优雅的语言，可以用极其简单的语言就可以实现强大的功能。列表推导式就是如此：
```python
li = [i for i in range(10)]
print(li)  # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

# 四、列表常用函数
## 1.求取列表长度(len)
```python
lis = [1, 2, 3]
# len()函数
len(lis) # 3
# 魔法方法 面向对象
lis.__len__() # 3
```
## 2.求取列表元素的最值(max,min)
```python
lis = [1, 2, 3]
# max()函数求取列表元素的最大值
max(lis) # 3
# min()函数求取列表元素的最小值
min(lis) # 1
```
## 3. 对列表里的元素排序(sorted)
```python
lis = [1, 2, 3, 6, 4, 5]
# sorted()函数可对可迭代对象进行排序，并返回一个列表
sorted(lis) # [1, 2, 3, 4, 5, 6]
```
## 4. 对列表进行反转(reversed)
```python
lis = [1, 2, 3]
# reversed()函数可以对可迭代对象进行排序，并返回一个迭代器
for i in reversed(lis):
	print(i)
# 3
# 2
# 1
```
# 五、列表常用方法
## 1. 添加列表元素(append)
```python
lis = [1, 2, 3]
# append()方法可以将传入元素添加到列表末尾
lis.append(4) # [1, 2, 3, 4]
```
## 2. 统计某个元素在列表中出现的次数(count)
```python
lis = [1, 2, 3, 3]
# count()方法可以统计元素在列表中的出现次数，并返回次数
# 如果需要统计的元素不在列表则返回 0 而不会抛出异常
lis.count(3) # 2
```
## 3. 一次性添加多个列表值(extend)
```python
lis = [1, 2, 3]
# extend()方法在列表末尾一次性追加另一个序列中的多个值
lis.extend([4, 5, 6]) # [1, 2, 3, 4, 5, 6]
```
## 4. 在列表指定位置插入元素(insert)
```python
lis = [1, 2, 3]
# insert(pobj,index)方法可以将对象插入到列表指定位置
# 指定位置大于列表最大索引时默认插入列表最后而不会抛出异常
lis.insert(4, 3) # [1, 2, 3, 4]
```
## 5. 获取列表元素第一个匹配项的索引位置(index)
```python
lis = [1, 2, 3]
# index()方法可以从列表中找出某个值第一个匹配项的索引位置
lis.index(3) # 2
# 当查找元素不在列表时会抛出异常
lis.index(4)
# ValueError: 4 is not in list
```
## 6. 移除列表指定位置的元素并返回该元素(pop)
```python
lis = [1, 2, 3]
# pop()方法可以移除列表指定位置元素(默认最后一个元素)并返回该元素的值
lis.pop(2) # 3
# 当指定位置大于列表最大索引值时会抛出异常
lis.pop(3)
# IndexError: pop index out of range
```
## 7. 移除列表中某个值的第一个匹配项(remove)
```python
lis = [1, 2, 3]
# remove()方法可以移除列表中某个值的第一个匹配项
lis.remove(1) # lis = [2, 3]
# 当传入元素不在列表时会抛出异常
lis.remove(4)
# ValueError: list.remove(x): x not in list
```
## 8. 对列表进行反转(reverse)
```python
lis = [1, 2, 3]
# reverse()方法可以将列表中元素进行反转
lis.reverse() # lis = [3, 2, 1]
```
## 9. 复制列表(copy）
```python
lis = [1, 2, 3]
# copy()方法可以对列表进行浅复制
lis1.lis() # lis1 = [1, 2, 3]
```
## 10. 清空列表（clear)
```python
lis = [1, 2, 3]
# clear()方法会清空列表
lis.clear() # lis = []
```
## 11. 对列表进行排序(sort)
```python
lis = [1, 2, 3, 6, 5, 4]
# sort()方法可以对列表进行排序
lis.sort() # lis = [1, 2, 3, 4, 5, 6]

# sort()方法中可传入reverse 参数
# 如果将该参数设置为 True则表示反向排序（默认从小到大）
lis.sort() # lis = [6, 5, 4, 3, 2, 1]

# sort()方法中还可以传入key 参数
# 该参数可指定一个函数来生成排序的关键值
lis1 = [1, 2, 3, 4, 5, 6, "0"]
lis.sort(key=int) # lis = ['0', 1, 2, 3, 4, 5, 6]
```