# Java学习之路——包装类

## 简介

Java 中的数据类型 int，double 等不是对象，无法通过向上转型获取到 Object 提供的方法。基本数据类型由于这样的特性，导致无法参与转型，泛型，反射等过程。为了弥补这个缺陷，Java 提供了包装类。

Java 中的 8 种基本数据类型都有与之对应的包装类：

| 基本数据类型 | 包装类    |
| ------------ | --------- |
| byte         | Byte      |
| short        | Short     |
| int          | Integer   |
| long         | Long      |
| float        | Float     |
| double       | Double    |
| char         | Character |
| boolean      | Boolean   |

## 一、基本数据类型和包装类的区别

1. 定义不同：包装类属于对象，基本数据类型不是；
2. 声明和使用方式不同：包装类使用new初始化，有些集合类的定义不能使用基本数据类型，例如 ArrayList<Integer>；
3. 初始值不同。包装类默认值为null，基本数据类型则不同的类型不一样（具体见上表）；
4. 存储方式和位置不同，从而性能不同。基本数据类型存储在栈（stack）中，包装类则分成引用和实例，引用在栈（stack）中，具体实例在堆（heap）中。

## 二、拆箱/装箱

拆箱/装箱实际上就是基本类型和包装类的相互转换。

- 由基本类型向对应的包装类转换称为装箱，例如把 int 包装成 Integer 类的对象：

  ```java
  Integer i = Integer.valueOf(1); //手动装箱
  Integer j = 1; //自动装箱
  ```

- 包装类向对应的基本类型转换称为拆箱，例如把 Integer 类的对象重新简化为 int：

  ```java
  Integer i0 = new Integer(1);
  int i1 = i0; //自动拆箱
  int i2 = i0.intValue(); //手动拆箱
  ```

## 三、基本数据类型、包装类与 String 相互转换

- 基本数据类型和包装类转字符串：

  ```java
  // 1. 连接运算
  String str1 = 1 + "";
  String str2 = new Integer(1) + "";
  // 2. 调用 String.valueOf()方法
  String str3 = String.valueOf(1);
  String str4 = String.valueOf(new Integer(1));
  ```

- 字符串转基本数据类型和包装类：

  ```java
  // 采用包装类的 parseXxx() 方法，返回值为基本类型
  int num1 = Integer.parseInt("123");
  // 如果字符串形式不对，运行时会发生 NumberFormatException 错误
  // 如：int num1 = Integer.parseInt("12a3");
  ```

## 四、自动装箱的内存复用

自动装箱时，对于Integer var = ？，如果var指向的对象在-128 至 127 范围内的赋值时，生成的Integer实例化对象是由 `IntegerCache.cache()` 方法产生，它会复用已有对象。和 String 的共享池操作是一个道理，cache() 方法会将位于-128~127范围内产生的 Integer 对象入池，下次使用的时候，从池中拿去，就不会在创建了。

```java
Integer a1 = 1;
Integer a2 = 1;
System.out.println(a1 == a2); // true

Integer b1 = 222;
Integer b2 = 222;
System.out.println(b1 == b2); // false
```

 所以，在这个数值区间内的 Integer 对象的栈指向(属性名) 可以直接使用==进行判断，因为值	相同，指向的就是同一片区域。但是这个区间之外的所有数据，自动装箱都会在堆上产生实例化，并不再复用已有对象，推荐使用 equals 方法进行Integer的判断。