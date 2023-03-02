# Python 在创建多进程时抛出 RuntimeError 错误

# 一、错误信息

```python
RuntimeError:
An attempt has been made to start a new process before the
current process has finished its bootstrapping phase.
This probably means that you are not using fork to start your
child processes and you have forgotten to use the proper idiom
in the main module:
　　if name == ‘main‘:
　　　　freeze_support()
　　　　…
The “freeze_support()” line can be omitted if the program
is not going to be frozen to produce an executable.
```
# 二、出错代码

```python
from multiprocessing import Pool
import os
import time
import random


def test(a1):
    t_start = time.time()
    print("%s 开始执行，进程号为%d" % (a1, os.getpid()))
    time.sleep(random.random() * 2)
    t_stop = time.time()
    print("%s 执行完毕，耗时%.2f" % (a1, (t_stop - t_start)))

p1 = Pool(3)
for i in range(0, 10):
    p1.apply_async(test, args=(i,))

print("-----start-----")
p1.close()
p1.join()
print("------end------")
```
# 三、错误原因
Python 解释器在 Windows平台 执行创建多进程的程序时，子进程会读取当前 Python 文件，用以创建进程。
在子进程读取当前文件时，读取到创建子进程的代码时又会创建新的子进程，这样程序就陷入递归创建进程的状态。
由于 Python 解释器中对于创建子进程有一个最大数量限制来保护我们的计算机（为龟叔点赞 :smile:），防止其内存溢出，因此程序会抛出异常。
# 四、改正方法
将程序创建子进程的放进 `if __name__ == '__main__':` 语句内，该语句的作用是判断当前进程是否为主进程，是主进程才执行程序。
# 五、改进后的代码

```python
from multiprocessing import Pool
import os
import time
import random


def test(a1):
    t_start = time.time()
    print("%s 开始执行，进程号为%d" % (a1, os.getpid()))
    time.sleep(random.random() * 2)
    t_stop = time.time()
    print("%s 执行完毕，耗时%.2f" % (a1, (t_stop - t_start)))

if __name__=='__main__':
    p1 = Pool(3)
    for i in range(0, 10):
        p1.apply_async(test, args=(i,))

    print("-----start-----")
    p1.close()
    p1.join()
    print("------end------")
```