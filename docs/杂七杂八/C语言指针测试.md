# C 语言指针测试

## 考题：

```c
#include <stdio.h>

int main()
{
    int str[] = {270, 30, 40};
    char *ptr = (char*)&str[0];

    for(int i=0; i<4;i++)
    {
        printf("%2d, %p\n", *ptr, ptr);
        ptr++;
    }
    return 0;
}
```

## 问题

在Linux或Windows平台上运行上面的程序，输出结果是怎样的？

## 答案

```
14, 000000000061FE08
 1, 000000000061FE09
 0, 000000000061FE0A
 0, 000000000061FE0B
```

## 分析

程序中首先定义了一个**int类型的数组**，然后从数组中拿出第一个数，将它**强制转换为char类型的指针**：

```c
int str[] = {270, 30, 40};
char *ptr = (char*)&str[0];
//转化一下
int str = 270;
char *ptr = (char*)&str;
```

下一步，进入循环打印数字。

**观察for语句**发现这是一个**四次循环**，打印输出的是**ptr 地址中的值**以及**ptr 地址**，输出之后**ptr地址加一**：

```c
for(int i=0; i<4;i++)
{
    printf("%2d, %p\n", *ptr, ptr);
    ptr++;
}
```

想要解出这个题的答案，我们需要了解C语言中，**不同类型的数据占用内存地址的大小**：

|     类型      | 32位平台(bytes) | 64位平台(bytes) |
| :-----------: | :-------------: | :-------------: |
|     char      |        1        |        1        |
|   short int   |        2        |        2        |
|      int      |        4        |        4        |
|   long int    |        4        |        8        |
| long long int |        8        |        8        |
|     long      |        4        |        8        |
|   long long   |        8        |        8        |
|     float     |        4        |        4        |
|    double     |        8        |        8        |
|    size_t     |        4        |        8        |
|    ssize_t    |        4        |        8        |

还有一个问题，我们需要了解大小端的概念：

> 大端模式：数据的高字节在低地址，低字节在高地址
> 小端模式：数据的高字节在高地址，低字节在低地址
>
> 一般常见的操作系统（Linux、Windows都是小端，Mac是大端）都是小端，而通讯协议则是大端

那么int类型的270在 Linux和Windows 的内存中怎样表示的呢？

```
表示：0000 1110, 0000 0001, 0000 0000, 0000 0000
字节：    1          2          3          4
```

从表格中我们可以发现，char 类型是占用1个字节的，而 int 类型是占用4个字节的。

那么 int 类型转化为 char 类型时，一个 int 类型就会转化为4个 char 类型的数据。

```
表示：0000 1110, 0000 0001, 0000 0000, 0000 0000
字节：    1          2          3          4
对应数：  14         1          0          0
```

这就是输出结果的由来，大家学废了吗？

![](https://pic.try-hard.cn/blog/aHR0cDovL2ltZy5kb3V0dWxhLmNvbS9wcm9kdWN0aW9uL3VwbG9hZHMvaW1hZ2UvMjAxNy8wNS8yNi8yMDE3MDUyNjgxMjk4NF9pTW1RZXQuanBn)