# 为什么 av_gettime() 返回值有正有负？

# 前言

**av_gettime()** 这个函数在 FFmpeg 的开发中，进行帧处理时最常用的一个函数。但是自己在最开始理解这个函数的时候，发现这个函数返回值十分的神奇。

因为它的 **返回值有时是一个正值，有时又是一个负值！**

为了解开这个神奇的现象，自己研究了半天，最后才发现原来是这么一回事 ......
# 示例
**代码**
```cpp
#include <stdio.h>
#include <libavutil/time.h>

int main(int argc, char const *argv[])
{
    printf("%d\n", av_gettime());
    return 0;
}
```
**运行**

```bash
gcc -o demo demo.c -w -L /usr/local/lib -lavutil && ./demo
```
**现象**
运行之后会打印一个正的十位数（或者是负的十位数），等待一段时间后再运行时你就可能会发现打印的是一个负的十位数（或者正的十位数）。

# 函数声明
想要解决这个问题，我们就需要回归到函数中去：
```cpp
/**
 * Get the current time in microseconds.
 */
int64_t av_gettime(void)
```

函数声明中我们得到了两个信息：

- 功能：**以微秒为单位获取当前时间**
- 返回值：**int64_t**

# 分析
那么当前时间的返回值为多少呢？

**获取当前时间**
```cpp
#include <sys/time.h>
#include <stdio.h>

int main()
{
    
    struct timeval tv;
    gettimeofday(&tv, NULL);
    
    printf("second: %ld\n", tv.tv_sec); // 秒
    printf("millisecond: %ld\n", tv.tv_sec * 1000 + tv.tv_usec / 1000); // 毫秒
    printf("microsecond: %ld\n", tv.tv_sec * 1000000 + tv.tv_usec); // 徽秒
}
```
对比打印结果发现我们这个程序微秒的返回值为一个**16位的数字！**
# 原因
这个时候我们就已经可以知道原因了：
**av_gettime() 返回值为 int64_t，16位的时间戳数字对于它来说已经超出了它的最大表示值了，因此就会出现为负值的现象。**


# 心得
- 以后其他地方如果也出现了负值，那我们就可以考虑是不是范围问题了。
- 涉及到数字的操作时一定要考虑选择的数据类型的范围，以及不同平台下某些数据类型范围不一样的问题。