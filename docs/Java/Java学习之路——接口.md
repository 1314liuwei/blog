# Java学习之路——接口

## 概述

> 总所周知，我们是父母的孩子。我们的身上既继承了爸爸的基因也继承了妈妈的基因。这就是多继承。
>
> 然而在 Java 程序中，是不支持多继承的。Java 仅仅支持单继承。但是接口为我们提供了一种实现多继承的可能性！

**接口**（英文：Interface）：在JAVA编程语言中接口是一个抽象类型，是抽象方法的集合，接口通常以 `interface` 来声明。一个类通过继承接口的方式，从而来继承接口的抽象方法。

我们要明确，**接口并不是类！接口和类是并列的结构！**只是编写接口的方式和类很相似，但是它们属于不同的概念。类描述对象的属性和方法。接口则包含类要实现的方法。

除非实现接口的类是抽象类，否则该类要定义接口中的所有方法。

接口无法被实例化，但是可以被实现。一个实现接口的类，必须实现接口内所描述的所有方法，否则就必须声明为抽象类。另外，在 Java 中，接口类型可用来声明一个变量，他们可以成为一个空指针，或是被绑定在一个以此接口实现的对象。

## 一、接口的定义及实现

JDK7以前，接口中只能定义全局常量和抽象方法；JDK8后，接口中除了可以定义全局常量和抽象方法之外，还可以定义静态方法，默认方法等。

实现接口的类必须实现接口所有的抽象方法，而静态方法，默认方法等不需要实现。接口中的静态方法，默认方法等只能通过接口调用。

```java
// 定义一个接口
interface Flyable {
    // 全局常量
    // 两种方式效果相同，一般书写时省略前面的 public static final
    public static final int MAX_SPEED = 7900;
    int MIN_SPEED = 0;

    // 抽象方法
    // 两种方式效果相同，一般书写时省略前面的 public abstract
    public abstract void fly();
    void stop();
}

class Bird implements Flyable {
    @Override
    public void fly() {
        System.out.println("I can fly.");
    }

    @Override
    public void stop() {
    }
}
```

## 二、接口的继承

一个接口能继承另一个接口，和类之间的继承方式比较相似。接口的继承使用extends关键字，子接口继承父接口的方法。

实现的类必须实现所有的接口（包括接口继承的接口）才能进行实例化。

### 单继承

```java
// 定义一个接口
interface Flyable {
    public abstract void fly();
    void stop();
}

// 继承一个接口
interface Bird extends Flyable {
    void eatBug();
}

// 实现接口
class Sparrow implements Bird {
    @Override
    public void fly() {
    }

    @Override
    public void stop() {
    }

    @Override
    public void eatBug() {
    }
}
```

### 多继承

在Java中，类的多继承是不合法，但接口允许多继承。在接口的多继承中 extends 关键字只需要使用一次，在其后跟着继承接口即可实现多继承。

通过接口的多继承，即可实现类的多继承。

```java
// 定义一个接口
interface Flyable {
    void fly();
}

interface Reproduction {
    void breedingOffspring();
}

// 继承一个接口
interface Bird extends Flyable, Reproduction {
    void eatBug();
}

// 实现接口
class Sparrow implements Bird {
    @Override
    public void fly() {
    }

    @Override
    public void eatBug() {
    }

    @Override
    public void breedingOffspring() {
    }
}
```

## 三、标记接口

标记接口有时也叫标签接口（Tag interface），即接口不包含任何方法。

在Java里很容易找到标记接口的例子，比如 JDK 里的 `Serializable` 接口就是一个标记接口。

标记接口是没有任何方法和属性的接口.它仅仅表明它的类属于一个特定的类型,供其他代码来测试允许做一些事情。

标记接口作用：简单形象的说就是给某个对象打个标（盖个戳），使对象拥有某个或某些特权。

```java
public interface Flyable {
    
}
```

## 四、接口与类的比较

- 接口不能用于实例化对象，对象可以；
- 接口没有构造方法，类有构造方法
- 接口中所有的方法必须是抽象方法，类中所有方法都不能是抽象方法；
- 接口不能包含成员变量，除了 static 和 final 变量，类中可以有成员变量；
- 接口不是被类继承了，而是要被类实现；
- 接口支持多继承，类只支持单继承。

## 五、接口默认方法冲突

如果先在一个接口中将一个方法定义为默认方法，然后又在超类或另一个接口中定义了同样的方法，就会产生一个二义性错误。

对于解决这个问题，Java 如下规则.

1. **超类优先：**如果超类提供了一个具体方法，同名并且有相同参数的默认方法会被忽略；
2. **接口冲突：**如果一个接口提供了一个默认方法，另一个接口提供了一个同名而且参数类型相同的方法。则实现类必须覆盖这个方法来解决冲突。

