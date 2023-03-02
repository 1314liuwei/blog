# Java学习之路——final 关键字的使用

## 概述

> 在Java中，final关键字可以用来修饰类、方法和变量（包括成员变量和局部变量）。
>
> final 代表着最终的，在 Java程序中加了 final 的类、方法和变量就有着无法修改的意思。

## 一、final 修饰类

当用 final 修饰一个类时，表明这个类不能被继承。

也就是说，我们希望一个类不能被继承，就可以用 final 进行修饰，在 Java 中的 String、System等类就是 final 修饰的类。

final类中的成员变量可以根据需要设为 final，但是要注意 final 类中的所有成员方法都会被隐式地指定为 final 方法。

```java
final class Person {
    
}
```

## 二、final 修饰方法

> 使用 final 方法的原因有两个。第一个原因是把方法锁定，以防任何继承类修改它的含义；第二个原因是效率。在早期的 Java 实现版本中，会将 final 方法转为内嵌调用。但是如果方法过于庞大，可能看不到内嵌调用带来的任何性能提升。在最近的 Java 版本中，不需要使用 final 方法进行这些优化了。 ——《Java编程思想》

被 final 修饰的方法不能够被子类所重写。 比如在 Object 中，getClass() 方法就是 final 的，我们就不能重写该方法， 但是 hashCode() 方法就不是被 final 所修饰的，我们就可以重写 hashCode() 方法。

```java
class Person {
    final public void say() {
        System.out.println("Hello, world!");
    }
}
```

## 三、final 修饰变量

final 修饰的变量，如果是基本数据类型，那么它的值不能修改；如果是引用对象类型，那么它的引用地址是不能修改的。

注意事项：

- final 修饰的属性，其属性赋值位置可以有显示初始化、代码块中初始化、构造器中初始化，不能在方法中赋值；
- final 修饰的形参变量，在方法中只能使用不能修改；
- 可以使用 static final 来修饰类全局常量。

```java
public class Demo {
    public static void main(String[] args)  {
        final Person p = new Person();
        p.age = 15;
        System.out.println(p.age);

        final int age = 18;
//        Cannot assign a value to final variable 'age'
//        age = 15;
    }
}

class Person {
    int age = 18;
}
```

