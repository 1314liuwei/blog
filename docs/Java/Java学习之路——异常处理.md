# Java学习之路——异常处理

## 概述

Java 程序运行是会可能会发生错误，但并不是所有的错误都是异常。

**一个健壮的程序必须能够处理各种各样的错误！**

Java 程序中的错误分为两种：

### ERROR

ERROR 是指 Java 虚拟机无法解决的严重的程序问题。例如：JVM 系统内部错误、资源耗尽型错误等。一般情况下，错误是没法通过针对型的代码进行解决的。

### Exception

Exception 指其它因为编程错误或者其它偶然因素导致的一般性问题，这些问题可以使用针对性的代码进行解决。

例如：

- 空指针访问
- 数组下标越界
- 网络错误
- ......

## 一、捕获异常

要想处理异常，首先要能够捕捉异常。

在 Java中，凡是可能抛出异常的语句，都可以用`try ... catch`捕获。把可能发生异常的语句放在`try { ... }`中，然后使用`catch`捕获对应的`Exception`及其子类。

一个 try 代码块后面可以跟随多个 catch 代码块进行多种异常的处理。JVM在捕获到异常后，会从上到下匹配`catch`语句，匹配到某个`catch`后，执行`catch`代码块，然后*不再*继续匹配。

`finally` 关键字用来创建在 `try` 代码块后面执行的代码块。无论是否发生异常，`finally` 代码块中的代码总会被执行。在 `finally` 代码块中，可以运行清理类型等收尾善后性质的语句。

```java
try {
   // 程序代码
} catch (异常类型1 异常的变量名1){
  // 程序代码
} catch (异常类型2 异常的变量名2){
  // 程序代码
} catch (异常类型3 异常的变量名3){
  // 程序代码
} finally {
  // 程序代码
}
```

示例

```java
import java.util.InputMismatchException;
import java.util.Scanner;

public class Demo {
    public static void main(String[] args)  {
        try {
            int res, divisor;
            Scanner scan = new Scanner(System.in);

            divisor = scan.nextInt();
            res = 10 / divisor;
        } catch (ArithmeticException e) {
            System.out.println(e);
            System.out.println("除数不能为0");
        } catch (InputMismatchException e1) {
            System.out.println(e1);
            System.out.println("输入出现问题");
        } finally {
            System.out.println("异常处理完毕");
        }
    }
}
```

## 二、抛出异常

当某个方法抛出了异常时，如果当前方法没有捕获异常，异常就会被抛到上层调用方法，直到遇到某个`try ... catch`被捕获为止，这就是异常的传播。

在 Java 程序中，可以使用 `throw` 关键字主动抛出异常，对于在方法中主动抛出的情况，一般情况下在函数声明中使用 `throws` 关键字明确写出可能抛出的异常。

```java
import java.util.InputMismatchException;
import java.util.Scanner;

public class Demo {
    public static int test(int dividend, int divisor) throws ArithmeticException {
        if (divisor == 0) {
            throw new ArithmeticException();
        } else {
            return dividend / divisor;
        }
    }

    public static void main(String[] args)  {
        try {
            int res;
            Scanner scan = new Scanner(System.in);

            res = Demo.test(scan.nextInt(), scan.nextInt());
            System.out.println(res);
        } catch (ArithmeticException e) {
            System.out.println(e);
            System.out.println("除数不能为0");
        } catch (InputMismatchException e1) {
            System.out.println(e1);
            System.out.println("输入出现问题");
        } finally {
            System.out.println("异常处理完毕");
        }
    }
}
```

## 三、自定义异常

Java标准库定义大量常见异常，但是有些时候 Java 标准库的异常不够我们使用，这个时候我们就可以选择自己定义异常来处理我们的实际业务需求。

自定义异常类是需要注意如下几点：

- 所有异常都必须是 `Throwable` 的子类；
- 如果希望写一个检查性异常类，则需要继承 `Exception` 类；
- 如果你想写一个运行时异常类，那么需要继承 `RuntimeException` 类。

示例

```java
import java.util.InputMismatchException;
import java.util.Scanner;

public class Demo {
    public static int test(int dividend, int divisor) throws ArithmeticException {
        if (divisor == 0) {
            throw new DivisorIsZero();
        } else {
            return dividend / divisor;
        }
    }

    public static void main(String[] args)  {
        try {
            int res;
            Scanner scan = new Scanner(System.in);

            res = Demo.test(scan.nextInt(), scan.nextInt());
            System.out.println(res);
        } catch (ArithmeticException e) {
            System.out.println(e);
            System.out.println("除数不能为0");
        } catch (InputMismatchException e1) {
            System.out.println(e1);
            System.out.println("输入出现问题");
        } finally {
            System.out.println("异常处理完毕");
        }
    }
}

class DivisorIsZero extends ArithmeticException {
    public DivisorIsZero() {
        System.out.println("除数为0");
    }
}
```

## 四、断言

断言（Assertion）是一种调试程序的方式。在Java中，使用`assert`关键字来实现断言。

断言失败时会抛出`AssertionError`，导致程序结束退出。因此，断言不能用于可恢复的程序错误，只应该用于开发和测试阶段。

注：在 IDEA 中是默认不开启断言的！需要我们手动开启断言！

```java
import java.util.Scanner;

public class Demo {
    public static void main(String[] args)  {
        try {
            int res, dividend, divisor;
            Scanner scan = new Scanner(System.in);

            dividend = scan.nextInt();
            divisor = scan.nextInt();

            assert divisor != 0 : "divisor must != 0";

            System.out.println("divisor");
            res = dividend / divisor;
            System.out.println(res);
        } catch (AssertionError e) {
            System.out.println("除数不能为0");
        } finally {
            System.out.println("异常处理完毕");
        }
    }
}
```

## 五、常见异常

Java标准库定义的常用异常包括：

```java
Exception
│
├─ RuntimeException
│  │
│  ├─ NullPointerException
│  │
│  ├─ IndexOutOfBoundsException
│  │
│  ├─ SecurityException
│  │
│  └─ IllegalArgumentException
│     │
│     └─ NumberFormatException
│
├─ IOException
│  │
│  ├─ UnsupportedCharsetException
│  │
│  ├─ FileNotFoundException
│  │
│  └─ SocketException
│
├─ ParseException
│
├─ GeneralSecurityException
│
├─ SQLException
│
└─ TimeoutException
```

| 异常类                            | 异常原因                                                     |
| --------------------------------- | ------------------------------------------------------------ |
| `ArithmeticException`             | 除数为0引起的异常                                            |
| `ArrayStoreException`             | 数组存储空间不够引起的异常                                   |
| `ClassCastException`              | 当把一个对象归为某个类，但实际上此对象并不是由这个类 创建的，也不是其子类创建的，则会引起异常 |
| `IllegalMonitorStateException`    | 监控器状态出错引起的异常                                     |
| `NegativeArraySizeException`      | 数组长度是负数，则产生异常                                   |
| `NullPointerException`            | 程序试图访问一个空的数组中的元素或访问空的对象中的 方法或变量时产生异常 |
| `SecurityException`               | 由于访问了不应访问的指针，使安全性出问题而引起异常           |
| `IndexOutOfBoundsExcention`       | 数组下标越界或字符串访问越界引起异常                         |
| `IOException`                     | 文件未找到、未打开或者I/O操作不能进行而引起异常              |
| `ClassNotFoundException`          | 未找到指定名字的类或接口引起异常                             |
| `CloneNotSupportedException`      | 程序中的一个对象引用Object类的clone方法，但 此对象并没有连接Cloneable接口，从而引起异常 |
| `InterruptedException`            | 当一个线程处于等待状态时，另一个线程中断此线程，从而引起异常 |
| `NoSuchMethodException`           | 所调用的方法未找到，引起异常                                 |
| `IllegalAccessExcePtion`          | 试图访问一个非public方法                                     |
| `StringIndexOutOfBoundsException` | 访问字符串序号越界，引起异常                                 |
| `ArrayIdexOutOfBoundsException`   | 访问数组元素下标越界，引起异常                               |
| `NumberFormatException`           | 字符的 utf-8 代码数据格式有错引起异常                        |
| `IllegalThreadException`          | 线程调用某个方法而所处状态不适当，引起异常                   |
| `FileNotFoundException`           | 未找到指定文件引起异常                                       |
| `EOFException`                    | 未完成输入操作即遇文件结束引起异常                           |