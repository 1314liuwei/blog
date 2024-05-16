# Java学习之路——JUC

## 一、JUC 简介

在 Java 5.0 提供了 `java.util.concurrent`（简称 JUC ）包，在此包中增加了在并发编程中很常用 的实用工具类，用于定义类似于线程的自定义子 系统，包括线程池、异步 IO 和轻量级任务框架。 提供可调的、灵活的线程池。还提供了设计用于 多线程上下文中的 `Collection` 实现等。

## 二、volatile 关键字

> 内存可见性（Memory Visibility）是指当某个线程正在使用对象状态 而另一个线程在同时修改该状态，需要确保当一个线程修改了对象 状态后，其他线程能够看到发生的状态变化。

可见性错误是指当读操作与写操作在不同的线程中执行时，我们无法确保执行读操作的线程能适时地看到其他线程写入的值，有时甚至是根本不可能的事情。 

我们可以通过同步来保证对象被安全地发布。除此之外我们也可以使用一种更加轻量级的 `volatile` 变量。

`volatile` 关键字为域变量的访问提供了一种免锁机制，它保证了不同线程对这个变量进行操作时的可见性，即一个线程修改了某个变量的值，这新值对其他线程来说是立即可见的。

**示例**：

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

## 三、CAS算法和原子变量

### CAS 算法

> CAS (Compare-And-Swap) 是一种硬件对并发的支持，针对多处理器 操作而设计的处理器中的一种特殊指令，用于管理对共享数据的并 发访问。

CAS 是一种无锁的非阻塞算法的实现。 

CAS 包含了 3 个操作数： 

- 需要读写的内存值 V ；
- 进行比较的值 A ；
- 拟写入的新值 B 。

当且仅当 V 的值等于 A 时，CAS 通过原子方式用新值 B 来更新 V 的 值，否则不会执行任何操作。

### 原子变量

原子变量类 **比锁的粒度更细，更轻量级**，并且对于在多处理器系统上实现高性能的并发代码来说是非常关键的。原子变量将发生竞争的范围缩小到单个变量上。

原子变量类相当于一种泛化的 `volatile` 变量，能够**支持原子的、有条件的读/改/写操**作。

原子类在内部使用 CAS 指令（基于硬件的支持）来实现同步。这些指令通常比锁更快。

原子变量类可以分为 4 组：

- 基本类型
  - `AtomicBoolean`：布尔类型原子类
  - `AtomicInteger`：整型原子类
  - `AtomicLong`：长整型原子类
- 引用类型
  - `AtomicReference`：引用类型原子类
  - `AtomicMarkableReference`：带有标记位的引用类型原子类
  - `AtomicStampedReference`：带有版本号的引用类型原子类
- 数组类型
  - `AtomicIntegerArray`：整形数组原子类
  - `AtomicLongArray`：长整型数组原子类
  - `AtomicReferenceArray`：引用类型数组原子类
- 属性更新器类型
  - `AtomicIntegerFieldUpdater`：整型字段的原子更新器。
  - `AtomicLongFieldUpdater`：长整型字段的原子更新器。
  - `AtomicReferenceFieldUpdater`：原子更新引用类型里的字段。

**示例**：

```java
import java.util.concurrent.atomic.AtomicInteger;

public class DemoTest {
    public static void main(String[] args) {
        AtomicDemo ad = new AtomicDemo();
        for (int i=0 ; i<10 ; i++) {
            new Thread(ad).start();
        }
    }
}


class AtomicDemo implements Runnable {
    private AtomicInteger serialNumber = new AtomicInteger(1);

    @Override
    public void run() {
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(serialNumber.getAndIncrement());
    }
}
```

## 四、ConcurrentHashMap 锁分段机制

 Java 5.0 在 `java.util.concurrent` 包中提供了多种并发容器类来改进同步容器 的性能。 

ConcurrentHashMap 同步容器类是Java 5 增加的一个线程安全的哈希表。对与多线程的操作，介于 HashMap 与 Hashtable 之间。内部采用“锁分段” 机制替代 Hashtable 的独占锁。进而提高性能。 

此包还提供了设计用于多线程上下文中的 Collection 实现：`ConcurrentHashMap`、`ConcurrentSkipListMap`、`ConcurrentSkipListSet`、 `CopyOnWriteArrayList` 和 `CopyOnWriteArraySet`。

当期望许多线程访问一个给 定 collection 时，ConcurrentHashMap 通常优于同步的 HashMap， ConcurrentSkipListMap 通常优于同步的 TreeMap。当期望的读数和遍历远远 大于列表的更新数时，CopyOnWriteArrayList 优于同步的 ArrayList。

**ConcurrentHashMap 的结构**:

ConcurrentHashMap由Segment数组结构和HashEntry数组结构组成；Segment是一种**可重入锁（ReentrantLock）**，HashEntry用于存储键值对数据；一个ConcurrentHashMap包含一个由若干个Segment对象组成的数组，每个Segment对象守护整个散列映射表的**若干个桶**，每个桶是由若干个HashEntry对象链接起来的**链表**，table是一个由HashEntry对象组成的数组，table数组的每一个数组成员就是散列映射表的一个桶。

![img](https://pic.try-hard.cn/blog/170140029f05960d)

## 五、CountDownLatch 闭锁

Java 5.0 在 `java.util.concurrent` 包中提供了多种并发容器类来改进同步容器 的性能。 

CountDownLatch 一个同步辅助类，在完成一组正在其他线程中执行的操作 之前，它允许一个或多个线程一直等待。

 闭锁可以延迟线程的进度直到其到达终止状态，闭锁可以用来确保某些活动直到其他活动都完成才继续执行： 

- 确保某个计算在其需要的所有资源都被初始化之后才继续执行; 
- 确保某个服务在其依赖的所有其他服务都已经启动之后才启动; 
- 等待直到某个操作所有参与者都准备就绪再继续执行。

```java
import java.util.concurrent.CountDownLatch;

public class DemoTest {
    public static void main(String[] args) throws InterruptedException {
        long start = System.currentTimeMillis();

        CountDownLatch latch = new CountDownLatch(10);
        CountDownLatchDemo demo = new CountDownLatchDemo(latch);
        for (int i=0 ; i<10 ; i++) {
            new Thread(demo).start();
        }
        latch.await();
        long end = System.currentTimeMillis();
        System.out.println("运行时间：" + (end - start));
    }
}


class CountDownLatchDemo implements Runnable {
    private CountDownLatch latch;

    public CountDownLatchDemo(CountDownLatch latch) {
        this.latch = latch;
    }

    @Override
    public void run() {
        try {
            for (int i = 0; i < 1000; i++) {
                System.out.println(i);
            }
            latch.countDown();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## 六、Callable 接口

Java 5.0 在`java.util.concurrent`提供了一个新的创建执行 线程的方式：**Callable 接口** 。

Callable 接口类似于 Runnable，两者都是为那些其实例可 能被另一个线程执行的类设计的。但是 Runnable 不会返 回结果，并且无法抛出经过检查的异常。 Callable 需要依赖FutureTask ，FutureTask 也可以用作闭锁。

