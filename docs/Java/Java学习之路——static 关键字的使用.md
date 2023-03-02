# Java学习之路——static 关键字的使用

## 概述

`static` 是 Java 程序种的静态修饰符，什么叫静态修饰符呢？

大家都知道，在程序中任何变量或者代码都是在编译时由系统自动分配内存来存储的，而所谓静态就是指在编译后所分配的内存会一直存在，直到程序运行结束退出内存才会释放这个空间。也就是只要程序在运行，那么这块内存就会一直存在。

`static` 表示“全局”或者“静态”的意思，用来修饰成员变量和成员方法，也可以形成静态static代码块，但是Java语言中没有全局变量的概念。

## 一、static 属性

按照是否静态的对类成员变量进行分类可分两种：

- 一种是被static修饰的变量，叫静态变量或类变量；
- 另一种是没有被static修饰的变量，叫实例变量。

两者的区别有：

- JVM只为静态分配一次内存，静态变量在内存中只有一个拷贝（节省内存）；
- 在加载类的过程中完成静态变量的内存分配；
- 静态变量的加载先于实例的加载；
- 每创建一个实例，就会为实例变量分配一次内存，实例之间实例变量互不影响；

**使用时机**：一般情况下，我们将从属于一个类，不会随着实例对象改变的变量设置为静态变量。

**访问权限**

| 调用对象 | 类属性 | 实例属性 |
| :------: | :----: | :------: |
|    类    |   ✓    |    ✘     |
| 实例对象 |   ✓    |    ✓     |

```java
public class Demo {
    public static void main(String[] args) {
//        直接通过 Man 类调用 gender 属性
        System.out.println(Man.gender);

//        实例属性
        Man m1 = new Man();
        m1.name = "张三";
        Man m2 = new Man();
        m2.name = "李四";
        System.out.println(m1.name);
        System.out.println(m2.name);
//        通过实例对象调用 gender 属性
        System.out.println(m1.gender);

//        通过 m1 修改了类属性，那么 m2 输出的类属性也会变化
        m1.gender = "女";
        System.out.println(m2.gender);
    }
}

class Man {
    String name;
    static String gender="男";
}
```

## 二、static 方法

静态方法可以直接通过类名调用，任何的实例也都可以调用。

因此**静态方法中不能用 this 和 super 关键字**，不能直接访问所属类的实例变量和实例方法(就是不带static的成员变量和成员成员方法)，只能访问所属类的静态成员变量和成员方法。因为实例成员与特定的对象关联！

因为static方法独立于任何实例，因此static方法必须被实现，而不能是抽象的abstract。 

**使用时机**：一般情况下，我们将修改类属性的方法和工具类的方法设置为类方法。

**调用权限**

| 调用对象 | 类方法 | 实例方法 |
| :------: | :----: | :------: |
|    类    |   ✓    |    ✘     |
| 实例对象 |   ✓    |    ✓     |

## 三、static 代码块

static 代码块也叫静态代码块，是在类中独立于类成员的static语句块，可以有多个，位置可以随便放，它不在任何的方法体内。普通的代码块是创建实例时运行的，在里面可以访问类属性和方法，也可以访问实例属性与方法。

JVM加载类时会执行这些静态的代码块，如果 static 代码块有多个，JVM将按照它们在类中出现的先后顺序依次执行它们，每个代码块只会被执行一次。

|     对象      | 访问类属性和类方法 | 访问实例属性和实例方法 |
| :-----------: | :----------------: | :--------------------: |
| static 代码块 |         ✓          |           ✘            |
|  普通代码块   |         ✓          |           ✓            |

```java
public class Demo {
    static {
        System.out.println("Hello!");
    }

    public static void main(String[] args) {
        System.out.println(new Man());;
    }

    static {
        System.out.println("Bye!");
    }
}

class Man {
    {
        System.out.println("Nice to meet you.");
        System.out.println(this.getClass());
    }
}
// Hello!
// Bye!
// Nice to meet you.
// class Man
```

通过上面的例子我们可以发现 static 代码块是按照顺序最先自动执行的。

如果需要通过计算来初始化 static 变量，我们可以通过声明一个 static 代码块进行处理，static 块仅在该类被加载时执行一次。如果我们需要在创建实例时对实例对象进行操作，那么我们可以用普通代码块。