# Java学习之路——枚举类

## 概述

> 在数学和计算机科学理论中，一个集的枚举是列出某些有穷序列集的所有成员的程序，或者是一种特定类型对象的计数。这两种类型经常重叠。		——维基百科

枚举类型是 Java 5 中新增特性的一部分，它是一种特殊的数据类型。

其特殊之处在于它既**是一种类（class）类型**但是又比普通的类类型多了些特殊的约束，但是这些约束的存在也造就了枚举类型的简洁性、安全性以及便捷性。

枚举类有着以下特点：

- 定义的`enum`类型总是继承自`java.lang.Enum`，且无法被继承；
- 只能定义出`enum`的实例，而无法通过`new`操作符创建`enum`的实例；
- 定义的每个实例都是引用类型的唯一实例；
- 可以将`enum`类型用于`switch`语句。

## 一、创建枚举类

在 Java 程序中，枚举类使用 `enum` 关键字来定义，定义的各个常量之间使用逗号 **,** 来分割。

```java
public class Demo {
    public static void main(String[] args) {
        System.out.println(Weekday.SUN);
    }
}

enum Weekday {
    SUN, MON, TUE, WED, THU, FRI, SAT;
}
```

## 二、常用操作

### 1. `name()`方法

返回常量名的字符串形式。

```java
System.out.println(Weekday.SUN.name());  // SUN
```

### 2. `ordinal()`方法

返回常量的索引值。

在枚举类中，每个常量都像数组一样有着一个索引值，索引值和常量的位置有关。改变常量的的顺序其索引值也会变化。

```java
System.out.println(Weekday.SUN.ordinal());  // 0
```

### 3. `valueOf()`方法

返回指定字符串值的枚举常量。

```java
System.out.println(Weekday.valueOf("SUN"));  // SUN 
```

### 4. 遍历

我们可以实验 `for` 语句来遍历枚举类中的常量。

```java
for (Weekday var : Weekday.values()) {
	System.out.print(var + " ");
}  // SUN MON TUE WED THU FRI SAT
```

### 5. `switch` 语句中的使用

```java
Scanner scan = new Scanner(System.in);

Weekday day = Weekday.valueOf(scan.nextLine());
switch (day) {
    case SUN:
        System.out.println("SUN");
        break;
    case MON:
        System.out.println("MON");
        break;
    default:
    	System.out.println("Others");
}
```

## 三、进阶使用

枚举类中的常量是什么类型的呢？

在枚举类中的每一个常量事实上就是枚举类的实例。

```java
System.out.println(Weekday.SUN.getClass());  // class Weekday
```

既然每一个常量都是枚举类的实例，那么我们在枚举类中定义的方法和属性也应将会作用于每一个实例。

```java
public class Demo {
    public static void main(String[] args) {
        System.out.println(Weekday.SUN.getChinese());  // 星期天
    }
}

enum Weekday {
    SUN("星期天", 7), MON("星期一", 1), TUE("星期二", 2),
    WED("星期bai三", 3), THU("星期四", 4), FRI("星期五", 5),
    SAT("星期六", 6);

    private String chinese;
    private int day;

    Weekday(String name , int day) {
        this.chinese = name;
        this.day = day;
    }

    public String getChinese() {
        return chinese;
    }
}
```

事实证明果然是可行的，那么我们就可以通过在枚举类中添加属性和方法的方式对我们常量的使用方式进行扩充了！

