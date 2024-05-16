# Java学习之路——多线程

## 概述

现代操作系统（Windows，macOS，Linux）都可以执行多任务。多任务就是一台计算机同时运行多个任务。

事实上 CPU 执行任务都是一条一条顺序执行的，但是“精明”的操作系统让每个任务都去 CPU 上执行一定的时间，然后立马就撤下来，只要每个任务之间的间隔时间足够短，那么我们就不会发现他们是一个一个执行的了。

### 进程

对于操作系统来说，一个任务就是一个进程（Process），比如打开一个浏览器就是启动一个浏览器进程，打开一个记事本就启动了一个记事本进程，打开两个记事本就启动了两个记事本进程，打开一个Word就启动了一个Word进程。

### 线程

> **线程是操作系统能够进行运算调度的最小单位**。大部分情况下，它被包含在进程之中，是进程中的实际运作单位。一条线程指的是进程中一个单一顺序的控制流，一个进程中可以并发多个线程，每条线程并行执行不同的任务。在 Unix System V 及 SunOS 中也被称为轻量进程，但轻量进程更多指内核线程，而把用户线程称为线程。
>
> ——维基百科

操作系统、进程、线程

```ascii
                        ┌──────────┐
                        │Process   │
                        │┌────────┐│
            ┌──────────┐││ Thread ││┌──────────┐
            │Process   ││└────────┘││Process   │
            │┌────────┐││┌────────┐││┌────────┐│
┌──────────┐││ Thread ││││ Thread ││││ Thread ││
│Process   ││└────────┘││└────────┘││└────────┘│
│┌────────┐││┌────────┐││┌────────┐││┌────────┐│
││ Thread ││││ Thread ││││ Thread ││││ Thread ││
│└────────┘││└────────┘││└────────┘││└────────┘│
└──────────┘└──────────┘└──────────┘└──────────┘
┌──────────────────────────────────────────────┐
│               Operating System               │
└──────────────────────────────────────────────┘
```

进程和线程是包含关系，但是多任务既可以由多进程实现，也可以由单进程内的多线程实现，还可以混合多进程＋多线程。

多线程与多进程的对比：

- **创建进程比创建线程开销大**，尤其是在Windows系统上；
- **进程间通信比线程间通信要慢**，因为线程间通信就是读写同一个变量，速度很快；
- **多进程稳定性比多线程高**。因为在多进程的情况下，一个进程崩溃不会影响其他进程；而在多线程的情况下，任何一个线程崩溃会直接导致整个进程崩溃。

## 一、创建线程

### 1. 创建线程

Java 语言中，JVM 允许多线程的存在。我们可以利用 `java.lang.Thread` 类来实现多线程。

Thread 类的特性：

- 每个线程都是调用的 `run()` 方法，`run()` 方法的主体就称为线程体；
- 通过调用 `Thread` 类实例的 `start()` 方法来启动这个线程。

示例1：

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread();  // 创建线程
        t1.start();  // 启动线程
    }
}
```

在示例1中，我们创建了一个子线程，并且启动了这个子线程。但是这个子线程什么也没干就结束了，实际开发中我们肯定不会这么无聊，我们需要像万恶的资本家一样压榨每一个线程。因此我们需要给这个线程分配一些任务才行！

### 2. 为线程添加任务

在 Java 程序为线程分配任务有如下几种方式可以实现：

方式一：继承 `Thread` 类，重写 `run()` 方法。

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new MyThread();
        t1.start();
    }
}

class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("A new thread was created!");
    }
}
```

方式二：创建`Thread`实例时，传入一个`Runnable`实例

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread(new MyRunnable());
        t1.start();
    }
}

class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("A new thread was created by implementation Runnable interface!");
    }
}
```

方式三：通过 Java8 的 `lambda` 语法传递方法

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            System.out.println("A new thread was created by lambda!");
        });
        t1.start();
    }
}
```

## 二、线程的常用一般方法

### 1. `run()` 方法

`run()` 方法是一个线程的线程体，线程运行的时候执行的就是 `run()` 方法。

### 2. `start()` 方法

启动当前线程，调用线程对象的 `run()` 方法。

### 3. `currentThread()` 方法

这是一个 Thread 类的静态方法，会返回当前程序的线程。

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            System.out.println("Thread：" + Thread.currentThread());
            System.out.println("A new thread was created by lambda!");
        });
        t1.start();
        System.out.println("main：" + Thread.currentThread());
    }
}

// main：Thread[main,5,main]
// Thread：Thread[Thread-0,5,main]
// A new thread was created by lambda!
```

### 4. `getName()` 方法

返回线程的名字。

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread();
        t1.start();
        System.out.println("main：" + t1.getName());
    }
}
```

### 5. `setName` 方法

设置线程的名字，与 `getName()` 方法类似。

### 6.`yield()` 方法

这是一个 Thread 类的静态方法，它会暂停当前正在执行的线程对象，并执行其他线程。在多线程的情况下，由CPU决定执行哪一个线程。

### 7. `sleep()` 方法

`sleep()` 方法会让当前线程沉睡一定时间（单位ms）。

```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread();
        t1.start();
        t1.sleep(10);  // 10ms
        System.out.println("The main thread has finished executing.");
    }
}
```

### 8. `join()` 方法

阻塞当前线程，直到调用线程运行结束。

```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            try {
                Thread.currentThread().sleep(1000);
                System.out.println("The child thread has finished executing.");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        t1.start();
        t1.join();
        System.out.println("The main thread has finished executing.");
    }
}
```

在上面的例程中，当程序运行到 `t1.join()` 是，会阻塞主线程，直到 t1 线程运行结束，因此输出结果为

```
The child thread has finished executing.
The main thread has finished executing.
```

如果注释掉 `t1.join()`，那么运行到此处时主线程不会阻塞，会继续运行下去。当主线程运行完时，如果 t1 线程还没有结束，那么 JVM 虚拟机会等待 t1 线程运行完毕再退出程序。因此其输出结果为

```
The main thread has finished executing.
The child thread has finished executing.
```

### 9. `isAlive()` 方法

判断当前线程是否还存活，是返回 `true` 否则返回 `false`。

### 10. `setDaemon()` 方法

在 Java 程序运行过程中，先由 JVM 启动`main`线程，`main`线程又可以启动其他线程。JVM 会等待所有线程全部运行结束后才会退出程序。

但是如果我们想要一个线程跟随其它线程一起退出程序，不管这个线程运行完成没有，只要其它线程都运行完了，那么这个线程就必须强行中止。

要实现这个功能，我们使用 `setDaemon()` 方法可以把这个线程设置为守护线程。

```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i=0 ; i<1000 ; i++) {
                try {
                    Thread.currentThread().sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("The child thread has ended.");
        });

        t1.setDaemon(true);
        t1.start();
        System.out.println("The main thread has ended.");
    }
}
```

在上面的程序中，我们将 t1 线程设置为了守护线程。当 `main` 线程运行结束时 ，子线程还没有运行完毕。但是因为 t1 线程是守护线程，它必须跟随主线程一起退出。因此其输出结果为 ：

```java
The main thread has ended.
```

如果说我们不将该线程设置为守护线程，那么输出结果为：

```java
The main thread has ended.
The child thread has ended.
```

注意：设置该线程为守护线程的操作必须在线程启动前设置。在**线程启动后是不能够设置为守护线程**的！

## 三、线程优先级

### 1. 优先级分类

在 Java 程序中，线程的优先级使用 1 ~ 10 的整数表示：

- 最低优先级 1：`Thread.MIN_PRIORITY`
- 普通优先级 5：`Thread.NORM_PRIORITY`
- 最高优先级 10：`Thread.MAX_PRIORITY`

### 2. 获取线程优先级

通过调用 `getPriority()` 方法可以获取线程的优先级。

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread();
        t1.start();
        System.out.println("子线程优先级：" + t1.getPriority());  // // 子线程优先级：5
        System.out.println("主线程优先级：" + Thread.currentThread().getPriority());  // 主线程优先级：5
    }
}
```

### 3. 设置线程优先级

我们可以通过调用 `setPriority()` 方法来设置线程的优先级。

```java
public class Demo {
    public static void main(String[] args) {
        Thread t1 = new Thread();
        t1.start();
        Thread.currentThread().setPriority(Thread.MAX_PRIORITY);  // 设置主线程的线程优先级为最大
        t1.setPriority(Thread.NORM_PRIORITY);  // 设置子线程的线程优先级为普通
        
        System.out.println("子线程优先级：" + t1.getPriority());  // 子线程优先级：5
        System.out.println("主线程优先级：" + Thread.currentThread().getPriority());  // 主线程优先级：10
    }
}
```

### 4. 线程默认优先级

**Java 程序中子线程的默认线程优先级是跟随父线程的线程优先级的，而非普通优先级`Thread.NORM_PRIORITY。`**

```java
public class Demo {
    public static void main(String[] args) {
        Thread.currentThread().setPriority(Thread.MAX_PRIORITY);  // 指定父线程的线程优先级最大
        Thread t1 = new Thread();
        t1.start();
        System.out.println("子线程优先级：" + t1.getPriority());  // 子线程优先级：10
        System.out.println("主线程优先级：" + Thread.currentThread().getPriority());  // 主线程优先级：10
    }
}
```

在上面的例程中，由于我们最开始设置了父线程的线程优先级为最大，因此创建出的子线程的线程优先级也是最大的。

如果说我们不设置父线程的线程优先级，那么父线程的默认线程优先级为 `Thread.NORM_PRIORITY`，因此创建出来的子线程的默认线程优先级也为 `Thread.NORM_PRIORITY`。

### 5. 线程调度

高优先级的线程比低优先级的线程有**更高的几率得到执行**。

我们要注意，只是高优先级的线程只是比低优先级的线程有着更高的机率执行。但是具体谁先执行，什么时候执行就是由操作系统决定的了，我们编写代码的人是无法得知的。

## 四、线程的生命周期

![线程状态图（图片来自网络，侵删）](https://pic.try-hard.cn/blog/线程状态图.jpeg)

总的来说线程的状态有以下六种：

1. **初始(NEW)**：新创建了一个线程对象，但还没有开始运行（调用 `start()` 方法）；
2. **就绪(RUNNABLE)**：线程对象创建后并调用 `start()` 方法后，该线程不会立刻进入运行状态。它首先进入可运行线程池中，等待被线程调度选中，获取CPU的使用权；
3. **运行(RUNNING)**：当在线程池中的线程获取到 CPU 使用权后，就可以开始运行了；
4. **阻塞(BLOCKED)**：线程阻塞于锁；
5. **等待(WAITING)**：进入该状态的线程需要等待其他线程做出一些特定动作（通知或中断）；
6. **超时等待(TIMED_WAITING)**：该状态的线程也会进入等待状态，但是不会一直等待下去。该在等待指定的时间后自行返回；
7. **终止(TERMINATED)**：表示该线程已经执行完毕。

## 五、线程同步

### 1. 不安全的多线程

由于当多个线程同时运行时，线程的调度由操作系统决定，程序本身无法决定。因此，任何一个线程都有可能在任何指令处被操作系统暂停，然后在某个时间段后继续执行。

如果说多个线程之间操作的都是共享变量，那么就有可能出现数据不一致的问题。

```java
public class Demo {
    static int x = 100;

    public static void main(String[] args) throws InterruptedException {
        // 创建两个线程，都对 x 进行操作
        Thread t1 = new Thread(() -> {
            for(int i=0 ; i<1000 ; i++) {
                try {
                    Thread.currentThread().sleep(2);
                    Demo.x += 1;
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        Thread t2 = new Thread(() -> {
            for(int i=0 ; i<1000 ; i++) {
                try {
                    Thread.currentThread().sleep(1);
                    Demo.x -= 1;
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        t1.start();
        t2.start();
        t2.join();
        System.out.println(Demo.x);
    }
}
```

在上面的例程中，由于操作系统、运行环境等各个方面的问题，会导致程序每次运行的结果都有可能不一致。

这种不确定性是我们不希望看到的，因为它的不可控会导致程序会出现各种情况。因此我们需要想办法解决多线程操作共享变量时不可控的问题。

### 2. synchronized 关键字

在 Java 程序中同步机制可以使用 **synchronized关键字** 实现。

**在 Java 程序中的每个对象都有一个内置锁**，当用此 synchronized 关键字修饰方法时，内置锁会保护整个方法。在调用该方法前，需要获得内置锁，否则就处于阻塞状态；用 synchronized 关键字修饰代码块时，被该关键字修饰的语句块会自动被加上内置锁，从而实现同步。

#### Ⅰ、同步方法

**模板**

```java
权限修饰符 synchronized 返回值 方法名(形参列表) {
	方法体
}
```

**示例**

```java
public class Demo {
    public static void main(String[] args) {
        // 创建两个线程，都对 x 进行操作
        MyThreadA t1 = new MyThreadA();
        MyThreadB t2 = new MyThreadB();

        t1.start();
        t2.start();
        t2.join();
        System.out.println(Counter.x);
    }
}

class Counter {
    private static int count = 100;

    public static synchronized void addition() {
        count += 1;
    }
}

class MyThreadA extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.addition();
        }
    }
}

class MyThreadB extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.addition();
        }
    }
}
```

#### Ⅱ、同步代码块

**模板**

```java
synchronized(object对象) {
	代码块
}
```

**示例**

```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        // 创建两个线程，都对 x 进行操作
        Counter counter = new Counter();
        Thread t1 = new Thread(() -> {
            for (int i=0 ; i<1000 ; i++) {
                synchronized (counter) {
                    counter.count += 1;
                }
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i=0 ; i<1000 ; i++) {
                synchronized (counter) {
                    counter.count -= 1;
                }
            }
        });

        t1.start();
        t2.start();
        t2.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    public static int count = 100;
}
```

Ⅲ、`wait()` / `notify()`

- `wait()`：使当前线程进入阻塞状态，并释放同步监视锁。可以传入数字参数，传入数字参数后就变成了超时等待状态；
- `notify()`：唤醒进入等待（wait）状态的一个线程，如果有多个线程进入等待状态，则唤醒优先级最高的线程；
- `notifyAll()`：唤醒所有进入等待状态的线程，这些被唤醒的线程开始竞争锁，但只有一个线程能抢到，这个线程执行完后，其他线程又会有一个幸运儿脱颖而出得到锁。

```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        // 创建两个线程，都对 x 进行操作
        Counter counter = new Counter();
        Thread t1 = new Thread(() -> {
            for (int i=0 ; i<100 ; i++) {
                synchronized (counter) {
                    try {
                        counter.wait();
                        System.out.println("wait......");

                        counter.count += 1;

                        counter.notify();
                        System.out.println("notify!");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i=0 ; i<100 ; i++) {
                synchronized (counter) {
                    try {
                        counter.notify();
                        System.out.println("wait......");

                        counter.count -= 1;

                        counter.wait();
                        System.out.println("notify!");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        t1.start();
        t2.start();
        t2.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    public static int count = 100;
}
```

### 3. `volatile` 关键字

`volatile` 关键字 在 Java 程序中有着如下作用：

`volatile` 关键字为域变量的访问提供了一种免锁机制，它保证了不同线程对这个变量进行操作时的可见性，即一个线程修改了某个变量的值，这新值对其他线程来说是立即可见的。

示例：

```java
public class Demo {
    public static void main(String[] args) {
        // 创建两个线程，都对 x 进行操作
        MyThread1 t1 = new MyThread1();
        MyThread2 t2 = new MyThread2();

        t1.start();
        t2.start();
        t1.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    // volatile 修饰 count 属性
    static volatile int count = 0;

    public static void add() {
        count += 1;
    }
}

class MyThread1 extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.add();
        }
    }
}

class MyThread2 extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.add();
        }
    }
}
```

### 4. 可重入锁 (`ReentrantLock`)

`ReentrantLock` 又称为可重入锁，它是可重入、互斥、实现了Lock接口的锁，它与使用synchronized方法和快具有相同的基本行为和语义，并且扩展了其能力。

 ReenreantLock 类的常用方法：

- `lock()`：获得锁
- `unlock()`：释放锁

示例：

```java
import java.util.concurrent.locks.ReentrantLock;

public class Demo {
    public static void main(String[] args) {
        // 创建两个线程，都对 x 进行操作
        MyThreadA t1 = new MyThreadA();
        MyThreadB t2 = new MyThreadB();

        t1.start();
        t2.start();
        t2.join();
        System.out.println(Counter.count);
    }
}

class Counter {
    public static int count = 0;
    private static ReentrantLock lock = new ReentrantLock();

    public static void addition() {
        lock.lock();
        count += 1;
        lock.unlock();
    }
}

class MyThreadA extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.addition();
        }
    }
}

class MyThreadB extends Thread {
    @Override
    public void run() {
        for (int i=0 ; i<1000 ; i++) {
            Counter.addition();
        }
    }
}
```

## 六、线程池

Java 语言中虽然内置了多线程支持，启动一个新线程非常方便。但是，创建线程需要操作系统资源（线程资源，栈空间等），频繁创建和销毁大量线程需要消耗大量时间。

那么我们就可以把很多小任务让一组线程来执行，而不是一个任务对应一个新线程。这种能接收大量小任务并进行分发处理的就是**线程池**。

### 1. 线程池种类

`ExecutorService`只是接口，Java标准库提供的几个常用实现类有：

- `FixedThreadPool`：线程数固定的线程池；
- `CachedThreadPool`：线程数根据任务动态调整的线程池；
- `SingleThreadExecutor`：仅单线程执行的线程池。

### 2. 提交任务

线程池常用方法：

- `execute()`：用于提交不需要返回结果的任务；
- `submit()`：用于提交一个需要返回果的任务。该方法返回一个`Future`对象，通过调用这个对象的`get()`方法，我们就能获得返回结果。`get()`方法会一直阻塞，直到返回结果返回。

### 3. 关闭线程池

关闭线程池有两种方法：

- `shutdown()`：该方法会将线程池状态置为`SHUTDOWN`，使线程池不再接受新的任务，同时会等待线程池中已有的任务执行完成再结束；
- `shutdownNow()`：该方法会将线程池状态置为`SHUTDOWN`，并对所有线程执行`interrupt()`操作，清空任务队列，并将队列中的任务返回回来；
- `isShutdown()`和`isTerminated`：分别表示线程池是否关闭和是否终止。

### 4. 线程池监控

- `getTaskCount()`：该方法返回已经执行或正在执行的任务数；
- `getCompletedTaskCount()`：该方法返回已经执行的任务数；
- `getLargestPoolSize()`：该方法返回线程池曾经创建过的最大线程数。我们可以使用这个方法知道线程池是否满过，从而考虑是否要扩大线程池容量；
- `getPoolSize()`：该方法返回线程池线程数；
- `getActiveCount()`：该方法返回活跃线程数（即线程池中正在执行任务的线程数）。

`ThreadPoolExecutor`中还有三个可重写的方法：

1. `beforeExecute(Thread t, Runnable r)`：任务执行前被调用；
2. `afterExecute(Runnable r, Throwable t)`：任务执行后被调用；
3. `terminated()`：线程池结束后被调用。

### 5. 示例

```java
import java.lang.reflect.Executable;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Demo {
    public static void main(String[] args) {
        ExecutorService pool = Executors.newFixedThreadPool(5);

        for (int i=0 ; i<10 ; i++) {
            pool.execute(new Counter(i));
        }
        pool.shutdown();
    }
}

class Counter implements Runnable {
    private int name;

    public Counter(int name) {
        this.name = name;
    }

    @Override
    public void run() {
        System.out.println("Thread-" + this.name);
    }
}
```