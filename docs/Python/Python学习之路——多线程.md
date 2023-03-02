# Python 学习之路——多线程

# 一、线程

### 1. 定义
进程可以简单的理解为一个可以独立运行的程序单位，它是线程的集合，进程就是有一个或多个线程构成的。而线程是进程中的实际运行单位，是操作系统进行运算调度的最小单位。可理解为线程是进程中的一个最小运行单元。
### 2. 解释器
Python 解释器的主要作用是将我们在 .py 文件中写好的代码交给机器去执行，比较常见的解释器包括如下几种：
- **CPython**：官方解释器，我们从官网下载安装后获得的就是这个解释器，它使用 C 语言开发，是使用范围最广泛的 Python 解释器。
- **Jython**：由 Java 编写，它可以将 Python 代码编译成 Java 字节码，再由 JVM 执行对应的字节码。
- **IronPython**：与 Jython 类似，它由 C# 编写，是运行在 .Net 平台上的解释器。
- **IPython**：基于 CPython 的一个交互式解释器，它主要增强了 CPython 的交互方式。
- **PyPy**：采用了 JIT 技术，它是一个关注执行速度的 Python 解释器，该解释器可以明显提升 Python 代码的执行速度。
### 3. GIL
GIL（global interpreter lock）即全局解释器锁。GIL就是一把锁，当有多个线程时，只有拿到这把锁的线程能够执行Python代码。
在CPython 解释器中，通过GIL机制来确保同一时刻只有一个线程执行 Python 代码的。这样做十分方便的帮助 CPython 解决了并发访问的线程安全问题，但却牺牲了在多处理器上的并行性。因此，**CPython 解释器下的多线程并不是真正意义上的多线程**。
GIL在以前是完全没有问题的，因为当时的计算机性能还十分落后；但是现在计算机的硬件性能已经发展十分迅速，完全可以实现多个线程并发执行。因此现在GIL反而成了制约Python并发的一堵墙。
但是为什么现在没有去掉GIL呢？这是因为Python的历史已经很久了，如果现在去掉GIL的话，以前很多依靠Python的程序都需要重新架构，这是一项十分庞大的工程。因此现在依然还没有去掉GIL。
# 二、threading模块
Python的标准库提供了两个模块：**_thread**和t**hreading**。
在Python2.x的版本里，多线程使用的都是thread模块，thread模块在Python3.x的版本中已经废除，为了程序的兼容性，Python3将thread模块重命名为_thread。
threading模块对_thread进行了封装。绝大多数情况下，我们只需要使用threading这个模块。
### 1. 方法属性
1. `active_count() -> int`：返回当前存活的线程类 Thread 对象的数量。返回的计数等于 enumerate() 返回的列表长度。
2. `enumerate() -> List[Thread]`：以列表形式返回当前所有存活的 Thread 对象。该列表包含守护线程、current_thread() 创建的虚拟线程对象和主线程，不包含已终结的线程和尚未开始的线程。
3. `current_thread() -> Thread`：返回当前对应调用者的控制线程的 Thread 对象。如果调用者的控制线程不是利用 threading 创建，会返回一个功能受限的虚拟线程对象。
4. `get_ident() -> int`：返回当前线程的线程标识符，它是一个非零的整数。它的值没有直接含义，主要是用作 magic cookie，比如作为含有线程相关数据的字典的索引。线程标识符可能会在线程退出，新线程创建时被复用。
5. `threading.main_thread() -> Thread`：返回主 Thread 对象。
6. `settrace(func: _TF) -> None`：为所有 threading 模块开始的线程设置追踪函数。每个线程的 run() 方法被调用前，func会被传递给 sys.settrace() 。
7. `setprofile(func: _PF) -> None`：为所有 threading 模块开始的线程设置性能测试函数。在每个线程的 run() 方法被调用前，func 会被传递给 sys.setprofile() 。
8. `stack_size(size: int = ...) -> int`：返回创建线程时用的堆栈大小（size可指定之后新建的线程的堆栈大小，在0~32768[32kb]之间）。
9. `TIMEOUT_MAX: float`：阻塞函数中形参 timeout 允许的最大值。
### 2. 线程对象（Thread）
Thread类可用来创建线程对象。
**参数：**
- `group: None`：为了日后扩展 ThreadGroup 类实现而保留
- `target: Optional[Callable[..., Any]]`：用于 run() 方法调用的可调用对象（如函数等）
- `name: Optional[str]`：线程名称。默认情况下为 "Thread-N" 格式
- `args: Iterable`：用于调用目标函数的参数元组
- `kwargs: Mapping[str, Any]`：用于调用目标函数的关键字参数字典
- `daemon: Optional[bool]`：设置线程是否为守护模式。默认为None，守护模式
**补充——守护模式与非守护模式：**
- 守护线程：守护线程会随主线程的退出而退出。即使当时正在执行任务，如果主线程退出了的话守护线程会立即停止并退出。这有可能会导致资源不能被正确释放的的问题（如：已经打开的文档等）。
- 非守护线程：Python 程序退出时，如果还有非守护线程在运行，程序会等待所有非守护线程运行完毕才会退出（默认创建的就是非守护线程）。

**常用方法：**
-  `start() -> None`：开始线程
- `run() -> None`：线程活动的方法
- `join(timeout: Optional[float] = ...) -> None`：阻塞主线程，直到线程结束（timeout 参数可以设置阻塞时间）
- `getName() -> str`：得到线程名字
- `setName(name: str) -> None`：设置线程名字
6. `is_alive() -> bool`：判断线程是否存活
- `isAlive() -> bool`：判断线程是否存货
- `isDaemon() -> bool`：判断线程是否是守护线程
- `setDaemon(daemonic: bool) -> None`：设置线程为守护线程（必须在start()方法之前执行）

**例子：**
```python
import threading

def say(name, num):
    for i in range(num):
        print(name, ':', i)

if __name__ == '__main__':
    t1 = threading.Thread(target=say, args=('t1', 10))
    t2 = threading.Thread(target=say, args=('t2', 50), daemon=True)
    t1.start()
    t2.start()
    t1.join()
```
### 3. 锁（Lock、RLock）
在多线程中，当数据在不同的线程中同时进行读写时，就会因为线程间速度不匹配而导致数据紊乱。此时就需要加锁来保证数据的一致性。
Lock类返回一个（只能单次加锁）原始锁 对象，RLock类返回一个（可以重复加锁）递归锁对象。锁支持上下文管理器。
**常用方法：**
- `acquire(blocking: bool, timeout: float) -> bool`：如果成功获得锁，则返回 True，否则返回 False (例如发生 超时 的时候)。（参数 blocking为 True（默认值），阻塞直到锁被释放，然后将锁锁定并返回 True ；
当blocking为 False 时，锁不会发生阻塞。如果调用时 blocking 设为 True 会阻塞，并立即返回 False ；否则，将锁锁定并返回 True。timeout 可以设置阻塞时间。当 blocking 为 false 时，timeout 指定的值将被忽略）
- `release() -> None`：释放锁（这个方法可以在任何线程中调用）
- `locked() -> bool`：判断是否获得锁

**例子：**
```python
import threading

def say(name, lock):
    lock.acquire()
    print(name)
    lock.release()

if __name__ == '__main__':
    lock = threading.Lock()
    t1 = threading.Thread(target=say, args=('t1', lock))
    t2 = threading.Thread(target=say, args=('t2', lock), daemon=True)
    t1.start()
    t2.start()
    t1.join()
```
### 4. 条件对象（Condition）
当我们需要等到特定条件才释放锁时，这个时候就试用于条件对象。
条件变量总是与某种类型的锁对象相关联，锁对象可以通过传入获得，或者在缺省的情况下自动创建。
**参数：**
- `lock: Union[Lock, _RLock, None]`：传入一个锁，默认会自动生成一个锁。

**常用方法：**
- `acquire(blocking: bool, timeout: float) -> bool`：与锁对象的该方法相同
- `release() -> None`：与锁对象的该方法相同
- `wait(timeout: Optional[float]) -> bool`：等待直到被通知或发生超时（timeout为超时参数）
- `wait_for(predicate: Callable[[], _T], timeout: Optional[float]) -> _T`：等待，直到条件计算为真（predicate 一个可调用对象并且其返回值可被解释为一个布尔值； timeout 参数给出最大等待时间）
- `notify(n: int) -> None`：默认唤醒一个等待这个条件的线程（n可以设置最多唤醒的线程数，默认为1）
- `notify_all() -> None`：唤醒所有等待的线程

**例子：**
```python
import threading

def say(con):
    con.acquire()
    for _ in range(5):
        print('say')
    con.notify()
    con.wait()

def listen(con):
    con.acquire()
    for _ in range(5):
        print('listen')
    con.release()

if __name__ == '__main__':
    con = threading.Condition()
    t1 = threading.Thread(target=say, args=(con, ), daemon=True)
    t2 = threading.Thread(target=listen, args=(con, ))
    t1.start()
    t2.start()
    t2.join()
```
### 5. 信号量（Semaphore）
一个信号量管理一个内部计数器，该计数器因 acquire() 方法的调用而递减，因 release() 方法的调用而递增。 计数器的值永远不会小于零；当 acquire() 方法发现计数器为零时，将会阻塞，直到其它线程调用 release() 方法。
**参数：**
`value: int`：设置最多引用的锁的数量

**常用方法：**
- `acquire(blocking: bool, timeout: float) -> bool`：加锁，计数器减1
- `release() -> None`：释放锁，计数器加1

**例子：**
```python
import threading
import time

def say(name, se):
    se.acquire()
    print(name)
    time.sleep(1)
    se.release()

if __name__ == '__main__':
    se = threading.Semaphore(3)
    for i in range(10):
        t = threading.Thread(target=say, args=(i, se))
        t.start()
```

### 6. 事件对象（Event）
实现事件对象的类。
事件对象管理一个内部标志，调用 set() 方法可将其设置为True。调用 clear() 方法可将其设置为False。调用 wait() 方法将进入阻塞直到标志为True（标志初始时为False）。
**常用方法：**
- `is_set() -> bool`：返回内部标志
- `set() -> None`：将内部标志设置为True
- `clear() -> None`：将内部标志设置为False
- `wait(timeout: Optional[float]) -> bool`：阻塞线程直到内部变量为True（timeout可设置超时参数）

**例子：**
```python
import threading

def say1(eve):
    if eve.wait():
        print('小鸡炖蘑菇')

def say2(eve):
    print('天王盖地虎')
    eve.set()

if __name__ == '__main__':
    eve = threading.Event()
    t1 = threading.Thread(target=say1, args=(eve, ))
    t2 = threading.Thread(target=say2, args=(eve,))
    t1.start()
    t2.start()
```
### 7. 定时器对象（Timer）
此类表示一个操作应该在等待一定的时间之后运行——相当于一个定时器（Timer类继承自Thread类）。
**参数：**
- `interval: float`：等待时间
- `function: Callable[..., None]`：可调用对象，即在等待完成后需要执行的任务
- `args: Optional[Iterable[Any]]`：传递给可调用对象的参数
- `kwargs: Optional[Mapping[str, Any]]`：传递给可调用对象的关键字参数

**常用方法：**
`cancel() -> None`：取消定时器

**例子：**
```python
import threading

def say1():
    print('小鸡炖蘑菇')

def say2():
    print('天王盖地虎')

if __name__ == '__main__':
    t1 = threading.Thread(target=say2)
    t2 = threading.Timer(1, say1)
    t1.start()
    t2.start()

```