# Python 学习之路——字符串

# 一、创建字符串

字符串是由数字、字母、下划线组成的一串字符。
在Python中可以用一对单引号或者一对双引号创建字符串类型对象。
长字符串：当需要保留保留字符串中的格式长字符串可以用三重引号表示，在长字符串中可以保留换行等格式。
**注意**：相同引号之间不能嵌套！
# 二、特殊字符
| 转义字符    | 描述                                         |
| ----------- | -------------------------------------------- |
| \(在行尾时) | 续行符                                       |
| \\          | 反斜杠符号                                   |
| \'          | 单引号                                       |
| \"          | 双引号                                       |
| \n          | 换行                                         |
| \a          | 响铃                                         |
| \b          | 退格(Backspace)                              |
| \e          | 转义                                         |
| \000        | 空                                           |
| \v          | 纵向制表符                                   |
| \t          | 横向制表符                                   |
| \r          | 回车                                         |
| \f          | 换页                                         |
| \oyy        | 八进制数，yy代表的字符，例如：\o12代表换行   |
| \xyy        | 十六进制数，yy代表的字符，例如：\x0a代表换行 |
| \other      | 其它的字符以普通格式输出                     |
# 三、字符串常用操作
| 操作符 | 描述                                               |
| ------ | -------------------------------------------------- |
| +      | 字符串连接                                         |
| *      | 重复输出字符串                                     |
| []     | 通过索引获取字符串中字符                           |
| [ : ]  | 截取字符串中的一部分                               |
| in     | 成员运算符 - 如果字符串中包含给定的字符返回 True   |
| not in | 成员运算符 - 如果字符串中不包含给定的字符返回 True |
# 四、字符串格式化输出
### 1.拼串操作
```python
a = 'I '+'Love '+'You'
print(a) #I Love You
```
### 2.多参数输出
```python
a = 'Love'
print('I',a,'You') #I Love You
```
注：print()函数默认每输出一个值就会在打印一个空格，若想改变默认输出，就在print()函数里传递一个sep=的关键字参数。
```python
print('I','Love','You',sep=",") # I,Love,You
```
### 3.使用占位符输出
在创建字符串的时候可以在字符串中指定占位符，然后格式化字符串输出。
```python
# 单参数
a = 'Love'
print('I %s You'%a) #I Love You
# 多参数
b = 'You'
print('I %s %s'%(a,b)) #I Love You
```
常用占位符：
| 符   号 | 描述                                 |
| ------- | ------------------------------------ |
| %c      | 格式化字符及其ASCII码                |
| %s      | 格式化字符串                         |
| %d      | 格式化整数                           |
| %f      | 格式化浮点数字，可指定小数点后的精度 |
### 4.利用{}输出
```python
a = 'Love'
print(f'I {a} You') #I Love You
```
**注意**：字符串前面要加f！
在字符串前加u：后面字符串以 Unicode 格式进行编码
在字符串前加f：在字符串内支持大括号内的python 表达式
在字符串前加b：让后面字符串是bytes 类型
在字符串前加r：去掉反斜杠的转移机制。
### 5.str.format()方法
该方法基本语法是通过 {} 和 : 来代替以前的 % 。
format 函数可以接受不限个参数，位置可以不按顺序
```python
a = 'I'
b = 'Love'
c = 'You'
print('{} {} {}'.format(a,b,c)) #I Love You
print('{2} {1} {0}'.format(c,b,a)) #I Love You
```
# 五、字符串其他常用方法
| 方法                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| str.capitalize()         | 把字符串的第一个字符大写                                 |
| str.count(str,beg=,end=) | 返回 str 在 str 里面出现的次数，如果 beg 或者 end 指定则返回指定范围内 str 出现的次数 |
| str.decode(encoding=,errors=) | 以 encoding 指定的编码格式解码 str，如果出错默认报一个 ValueError 的 异 常 ， 除非 errors 指 定 的 是 'ignore' 或 者'replace' |
| str.encode(encoding=, errors=) | 以 encoding 指定的编码格式编码 str，如果出错默认报一个ValueError 的异常，除非 errors 指定的是'ignore'或者'replace' |
| str.find(str, beg=, end=) | 检测 str 是否包含在 str 中，如果 beg 和 end 指定范围，则检查是否包含在指定范围内，如果是返回开始的索引值，否则返回-1 |
| str.join() | 以 str 作为分隔符，将 seq 中所有的元素(的字符串表示)合并为一个新的字符串 |
| str.lower() | 转换 str 中所有大写字符为小写. |
| str.lstrip() | 截掉 str 左边的空格 |
| max(str) | 返回字符串 str 中最大的字母 |
| min(str) | 返回字符串 str 中最小的字母 |
| str.replace(str1, str2,  num=) | 把 str 中的 str1 替换成 str2,若num 指定，则替换不超过 num 次. |
| str.rstrip() | 删除 str 字符串末尾的空格 |
| str.split(str="", num=) | 以 str 为分隔符切片 str，如果 num 有指定值，则仅分隔 num+ 个子字符串 |
| str.splitlines(keepends=) | 按照行('\r', '\r\n', \n')分隔，返回一个包含各行作为元素的列表，如果参数 keepends 为 False，不包含换行符，如果为 True，则保留换行符 |
| str.strip() | 删除字符串(str)的头和尾的空格，以及位于头尾的\n \t |
| str.swapcase() | 翻转 str 中的大小写 |
| str.upper() | 转换 str 中的小写字母为大写 |
| str.title() | 将分隔的字符串分别进行首字母大写 |