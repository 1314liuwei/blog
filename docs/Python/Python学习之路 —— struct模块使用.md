# Python学习之路——struct 模块使用

## 用途

1. 按照指定格式将 Python 数据类型转换为字节流；
2. 按照指定格式将字节流转换为 Python 数据类型；
3. 解析 C 语言中的结构体；

## 内置函数

| 函数                                  | 返回值 | 功能                                                         |
| :------------------------------------ | :----- | :----------------------------------------------------------- |
| pack(fmt, *args)                      | string | 按照指定格式(**fmt**)，将数据(***args**)转换成字节流，返回字节流 |
| pack_into(fmt, buffer, offset, *args) | None   | 按照给定的格式(**fmt**)，将数据(***args**)转换成字节流，并将字节流写入以 **offset** (起始位)开始的 **buffer** |
| unpack(fmt, string)                   | tuple  | 按照给定的格式(**fmt**)解析字节流(**string**),并返回解析结果 |
| unpack_from(fmt, buffer, offset=0)    | tuple  | 按照给定的格式(**fmt**)解析以 **offset** (起始位置) 开始的缓冲区(**buffer**)，并返回解析结果 |
| calcsize(fmt)                         | int    | 计算给定的格式(**fmt**)占用内存大小                          |

## 格式化字符串

### 字节对齐

由于 C语言 在不同硬件设备上采用的对齐方式不同，因此我们在解析数据流时要考虑字节对齐的问题：

| Character | Byte order    | Size | Alignment       |
| :-------- | :------------ | :--- | :-------------- |
| @(默认)   | 本机          | 本机 | 本机,凑够4字节  |
| =         | 本机          | 标准 | none,按原字节数 |
| <         | 小端          | 标准 | none,按原字节数 |
| >         | 大端          | 标准 | none,按原字节数 |
| !         | network(大端) | 标准 | none,按原字节数 |

### 类型转换

| 格式符     | C语言类型          | Python类型         | Standard size |
| :--------- | :----------------- | :----------------- | :------------ |
| x          | pad byte(填充字节) | no value           |               |
| c          | char               | string of length 1 | 1             |
| b          | signed char        | integer            | 1             |
| B          | unsigned char      | integer            | 1             |
| ?          | _Bool              | bool               | 1             |
| h          | short              | integer            | 2             |
| H          | unsigned short     | integer            | 2             |
| i          | int                | integer            | 4             |
| I(大写的i) | unsigned int       | integer            | 4             |
| l(小写的L) | long               | integer            | 4             |
| L          | unsigned long      | long               | 4             |
| q          | long long          | long               | 8             |
| Q          | unsigned long long | long               | 8             |
| f          | float              | float              | 4             |
| d          | double             | float              | 8             |
| s          | char[]             | string             |               |
| p          | char[]             | string             |               |
| P          | void *             | long               |               |

## 例程

### 从字节流解析数据

```c
struct data
{
    char name[20];
    float capacity;
    float Electricity;
    int status;
};
struct demo data{'Hello', 1.2, 1.2, 1};

// 将结构体转换为字节流的结果为：b'Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00?\x99\x99\x9a?\x99\x99\x9a\x00\x00\x00\x01'
```

```python
import struct

data = b'Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00?\x99\x99\x9a?\x99\x99\x9a\x00\x00\x00\x01'
data = struct.unpack('<20sid', data)  # data为 C程序传递来的字节流
print(data)
# (b'Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00', 1.2000000476837158, 1.2000000476837158, 1)
```

### 数据封装为字节流

```python
import struct

data = struct.pack('>20sffi', 'Hell'.encode('ascii'), 1.2, 1.2, 1)
print(data)
# b'Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00?\x99\x99\x9a?\x99\x99\x9a\x00\x00\x00\x01'

```