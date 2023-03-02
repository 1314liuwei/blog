# Python 学习之路——协程

# 一、协程

协程（Coroutine），又称微线程，纤程。
协程由多个子函数构成。执行过程中，在子函数内部可中断，然后转而执行别的子函数，在适当的时候再返回来接着执行子函数。
# 二、生成器实现
**子函数运行到一定程度时暂停，等待下一次启动**
根据协程的特性我们不难发现我们的生成器函数就可以实现这个特性。
```python
import time
import asyncio

def Producer(generator):
    for i in range(1000):
        time.sleep(1)
        generator.send(i)


def Consumer():
     while True:
         a = yield 
         print(a)

if __name__ == '__main__':
    s = Consumer()
    next(s)
    b = Producer(s)
```
在上面的代码里我们就利用生成器实现了一个简单的协程。因此在Python中的协程就是利用生成器实现的。
# 三、asyncio库
### 1. async和await
asyncio库是在Python 3.4版本引入的标准库，在这个库里直接内置了对异步IO的支持。
asyncio的编程模型就是一个消息循环。
我们之间从asyncio模块中直接获取一个EventLoop的引用，然后把需要执行的协程扔到EventLoop中执行，就实现了异步IO。
```python
import asyncio

@asyncio.coroutine  # 把generator标记为coroutine类型
def hello():
    print("Hello world!")
    yield from asyncio.sleep(1)  # 调用另外一个generator
    print("The end!")

if __name__ == '__main__':
    loop = asyncio.get_event_loop()  # 将协程添加进事件循环
    loop.run_until_complete(hello())  # 运行事件循环
    loop.close()
```
在Python3.5的版本中，开始引入了新的语法——**async和await**关键字。
这两个关键字的引入让coroutine语法更简洁，它们是针对coroutine的新语法，只需要把 **@asyncio.coroutine替换为async、yield from替换为await** 即可实现协程函数。
```python
import asyncio

async def hello():
    print("Hello world!")
    await asyncio.sleep(1)
    print("The end!")

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(hello())
    loop.close()
```
### 2. 基本概念
##### 可等待对象
如果一个对象可以在 await 语句中使用，那么它就是 可等待 对象。许多 asyncio API 都被设计为接受可等待对象。
可等待对象有三种主要类型：**协程, 任务 和 Future.**
##### Python中的协程
Python 协程属于可等待 对象，因此可以在其他协程中被等待:
- 协程函数: 定义形式为 async def 的函数;
- 协程对象: 调用 协程函数 所返回的对象。
##### 运行协程
要真正运行一个协程，asyncio 提供了三种主要机制：
- asyncio.run() 函数用来运行最高层级的入口点
- 等待一个协程
- asyncio.create_task() 函数用来并发运行作为 asyncio 任务的**多个协程**
### 3. asyncio详解
在asyncio库中分为高级API和底层API：
**高层级API：**
- 并发地运行Python协程并完全控制其执行过程；
- 执行网络IO和IPC；
- 控制子进程；
- 通过队列实现分布式任务；
- 同步并发代码。

**低层级API：**
- 用以支持开发异步库和框架
- 创建和管理事件循环（event loop），提供异步的API用于网络，- 运行子进程，处理操作系统信号等；
- 通过transports实现高效率协议；
- 通过async/await 语法桥架基于回调的库和代码。
##### 高级API
[官方文档](https://docs.python.org/zh-cn/3.7/library/asyncio-api-index.html)
##### 低级API
[官方文档](https://docs.python.org/zh-cn/3.7/library/asyncio-llapi-index.html)