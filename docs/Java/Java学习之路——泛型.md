# Java学习之路——泛型

## 概述

什么是泛型？Java 泛型（generics）是 JDK 5 中引入的一个新特性, 泛型提供了编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。

泛型的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数。

**泛型的本质是为了参数化类型（在不创建新的类型的情况下，通过泛型指定的不同类型来控制形参具体限制的类型）**。也就是说在泛型使用过程中，操作的数据类型被指定为一个参数，这种参数类型可以用在类、接口和方法中，分别被称为泛型类、泛型接口、泛型方法。

## 一、泛型方法

泛型方法可以在调用时可以接收不同类型的参数。编译器会根据传递给泛型方法的参数类型，适当地处理每一个方法调用。

定义泛型方法时要遵循如下规则：

- 泛型方法需要声明都有一个类型参数声明部分（由尖括号分隔），该类型参数声明部分在方法返回类型之前；
- 每一个类型参数声明部分包含一个或多个类型参数，参数间用逗号隔开。一个泛型参数，也被称为一个类型变量，是用于指定一个泛型类型名称的标识符；
- 类型参数能被用来声明返回值类型，并且能作为泛型方法得到的实际参数类型的占位符；
- 类型参数只能代表引用数据类型，不能用于基本数据类型；
- 泛型方法体的声明和其他方法一样。

示例：

```java
public class Demo {
    public static void main(String[] args) {
        Integer[] a1 = {1, 2, 3};
        Double[] a2 = {1.0, 2.0, 3.0};
        Character[] a3 = {'a', 'b', 'c'};

        Demo.print(a1);  // 1 2 3
        Demo.print(a2);  // 1.0 2.0 3.0 
        Demo.print(a3);  // a b c
    }

    public static <E> E[] print(E[] input) {
        for (E i : input) {
            System.out.print(i + " ");
        }
        System.out.println();
        return input;  // 返回值也为泛型
    }
}
```

## 二、泛型类

泛型类的类型参数声明部分也包含一个或多个类型参数，参数间用逗号隔开。

一个泛型参数，也被称为一个类型变量，是用于指定一个泛型类型名称的标识符。因为他们接受一个或多个参数，这些类被称为参数化的类或参数化的类型。

```java
import java.util.Arrays;

public class Demo {
    public static void main(String[] args) {
        Integer[] a1 = {1, 2, 3};
        Box<Integer[]> b1 = new Box<>(a1);
        System.out.println(Arrays.toString(b1.getT()));

        Character[] a2 = {'a', 'b', 'c'};
        Box<Character[]> b2 = new Box<>(a2);
        System.out.println(Arrays.toString(b2.getT()));
    }
}

class Box<T> {
    private final T t;

    public Box(T t) {
        this.t = t;
    }

    public T getT() {
        return t;
    }
}
```

## 三、泛型接口

实现泛型接口同样也只需在接口名后面加上 `<类型名>`就行。

但是实现接口的类就有两种方式了：

如果实现接口的子类不想使用泛型声明，则在实现接口的时候直接指定好其具体的操作类型即可。例如 `MyClass1`；

如果实现接口的子类想要使用泛型声明，则在实现接口的时候同样使用泛型。例如 `MyClass2`。

```java
public class Demo {
    public static void main(String[] args) {
        MyClass1 m1 = new MyClass1("Hello");
        System.out.println(m1.getValue());;

        MyClass2<Integer> m2 = new MyClass2<>(1);
        System.out.println(m2.getValue());;
    }
}

interface info<T> {
    T getValue();
}

// 指定具体的类
class MyClass1 implements info<String> {
    private final String value;

    public MyClass1(String value) {
        this.value = value;
    }

    @Override
    public String getValue() {
        return value;
    }
}

// 泛型类
class MyClass2<T> implements info<T> {
    private final T value;

    public MyClass2(T value) {
        this.value = value;
    }

    @Override
    public T getValue() {
        return value;
    }
}
```

## 四、通配符

我们在使用繁花时，由于等号左右的泛型需要一致，但你可能不知道等号右侧的泛型是什么。这个时候 Java 就为我们提供了泛型通配符，它等号左侧可以使用。

在理解通配符之前，我们首先要理解 Java 的引用和实例之间的关系：

> 在 Java 中，引用就相当于一个容器，而实例就相当于容器里的水。正常情况下，水只能往和自己体积相等或者比自己体积大的容器里面装（向上转型：子类的实例装入父类的容器）。但是也可以往比自己小的容器里面装（向下转型：父类的实例装入子类的容器），但是这一步就十分凶险，会有众多的限制条件。而**泛型就是为了解决不安全的向下转型问题**。

下面我们就用水果盘和水果的关系来讲解通配符：

首先创建一个盘子类：

```java
// 水果盘类
class Plate<T> {
    private T item;
    public Plate(T item) {
        this.item = item;
    }
    public void set(T item) {
        this.item = item;
    }
    public T get(){
        return item;
    }
}
```

然后再创建一点水果：

```java
// 水果类
class Fruit {}

// 具体的水果
class Apple extends Fruit {}
class Banana extends Fruit {}
```

### 无边界通配符

使用无边界通配符可以让泛型接收任意类型的数据。相当于 `<? extends Object>`，可以匹配一切类。

```java
Plate<?> p1 = new Plate<>(new Fruit());
// p1.set(new Fruit());
// p1.set(new Apple());
Object p11 = p1.get();
// Fruit p12 = p1.get();
// Apple p13 = p1.get();

Plate<?> p2 = new Plate<>(new Apple());
// p2.set(new Fruit());
// p2.set(new Apple());
Object p21 = p1.get();
// Fruit p22 = p1.get();
// Apple p23 = p1.get();
```

**无边界通配符匹配任意类**。

它既不能使用 `set` 方法。因为不知道盘子里面的容器有多大，如果盘子里面的容器比较小，你放进入一个大的东西就会出问题，或者说盘子里面的容器根本就和你要放的东西没有关系，那就更会出问题了；

也不能将取出的结果放入任 Object 类以外的任何类。因为你不知道盘子里面的东西有多大，你如果拿的容器和放里面的东西没有任何关系，或者尺寸比里面的小了，那么都会出问题。调用 `Object` 来接收就没问题，因为它就是最大的容器了，不管你里面放的是什么，都可以接得住。

总结而言就是：**不能往里存，也不能往外取。**

### 上边界通配符

使用固定上边界的通配符的泛型可以接收指定类型及其所有子类类型的数据，这里的指定类型可以是类也可以是接口。

```java
Plate<? extends Fruit> p3 = new Plate<>(new Fruit());
// p3.set(new Fruit());
// p3.set(new Apple());
Fruit p31 = p3.get();
Object p32 = p3.get();
// Apple p33 = p3.get();
```

**上边界边界符可以匹配一切以该类为父类的派生类或者类本身**。

它不能调用 `set` 方法。因为虚拟机只知道它放进入的是父类的派生类或者父类，具体哪一个类不知道，如果初始是子类，放的时候放父类，那么就会存在问题，因此它不能调用 `set` 方法；

但是它可以调用 `get` 方法，因为知道容器内部的都是父类或者父类的派生类，因此取的时候只要找一个大于等于父类的容器就绝对可以装的下。

总结而言就是：**不能往里存，只能往外取。**

### 下边界通配符

所有固定下边界的通配符的泛型可以接收指定类型及其所有超类类型的数据。

```java
Plate<? super Fruit> p4 = new Plate<>(new Fruit());
p4.set(new Fruit());
p4.set(new Apple());
// Fruit p41 = p4.get();
Object p42 = p4.get();
// Apple p43 = p4.get();
```

它可以调用 `set` 方法。因为虚拟机知道，盘子里的容器最小也是 `Fruit` 类这么大，那么我放东西的时候，只要放的东西是小于或者等于 `Fruit` 类大小的，那就不会出问题；

但是它不能调用 `get` 方法，因为虚拟机不知道里面的东西有多大，如果你接的容器比里面的小了就会出问题，但是如果拿 `Object` 接就不会有问题，因为 `Object` 就是最大的状态了。

### PECS原则

**PECS（Producer Extends Consumer Super）原则**：

- **频繁往外读取内容的，适合用上界Extends**。
- **经常往里插入的，适合用下界Super。**