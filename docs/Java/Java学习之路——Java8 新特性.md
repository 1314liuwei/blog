# Java学习之路——Java8 新特性

## 概述

虽说 JDK 每个新版本相较于上一个版本都有一些新特性，但是因为 JDK8 是行业中使用最为广泛的版本，因此它的新特性是我们需要了解并使用的。这些新特性能够帮助我们更好的进行编程。

## 一、Lambda 表达式

Lambda 表达式，也可称为闭包，它允许把函数作为一个方法的参数（函数作为参数传递进方法中），能够使代码变的更加简洁紧凑。

### 语法

```java
(parameters) -> expression
// 或
(parameters) ->{ statements; }
```

### 特点

以下是lambda表达式的重要特征:

- **可选类型声明：**不需要声明参数类型，编译器可以统一识别参数值；
- **可选的参数圆括号：**一个参数无需定义圆括号，但多个参数需要定义圆括号；
- **可选的大括号：**如果主体包含了一个语句，就不需要使用大括号；
- **可选的返回关键字：**如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值；
- **变量作用域**：lambda 表达式只能引用标记了 final 的外层局部变量，这就是说不能在 lambda 内部修改定义在域外的局部变量，否则会编译错误；lambda 表达式的局部变量可以不用声明为 final，但是必须不可被后面的代码修改（即隐性的具有 final 的语义）。

### 示例

```java
public class Demo {
    public static void main(String[] args) throws Exception {
        Demo tester = new Demo();

        // 类型声明
        MathOperation addition = (int a, int b) -> a + b;

        // 不用类型声明
        MathOperation subtraction = (a, b) -> a - b;

        // 大括号中的返回语句
        MathOperation multiplication = (int a, int b) -> { return a * b; };

        // 没有大括号及返回语句
        MathOperation division = (int a, int b) -> a / b;

        System.out.println("10 + 5 = " + tester.operate(10, 5, addition));
        System.out.println("10 - 5 = " + tester.operate(10, 5, subtraction));
        System.out.println("10 x 5 = " + tester.operate(10, 5, multiplication));
        System.out.println("10 / 5 = " + tester.operate(10, 5, division));

        // 不用括号
        GreetingService greetService1 = message -> System.out.println("Hello " + message);

        // 用括号
        GreetingService greetService2 = (message) -> System.out.println("Hello " + message);

        greetService1.sayMessage("Runoob");
        greetService2.sayMessage("Google");
    }

    interface MathOperation {
        int operation(int a, int b);
    }

    interface GreetingService {
        void sayMessage(String message);
    }

    private int operate(int a, int b, MathOperation mathOperation){
        return mathOperation.operation(a, b);
    }
}
```

## 二、方法引用

有时候我们的 Lambda 表达式可能仅仅调用一个已存在的方法，而不做任何其它事。

对于这种情况，通过一个方法名字来引用这个已存在的方法会更加清晰，Java 8的方法引用允许我们这样做。方法引用是一个更加紧凑，易读的 Lambda 表达式。

方法引用是一个Lambda表达式，其中方法引用的操作符是双冒号 `::`。

方法引用主要有以下几种方式：

- **构造器引用：**语法为 `Class :: new`或`Class<T> :: new`；
- **静态方法引用：**语法为 `Class :: static_method`；
- **特定类的任意对象的方法引用：**语法为 `Class :: method`；
- **特定对象的方法引用：**语法为 `instance :: method`。

示例

```java
import java.util.ArrayList;
import java.util.List;

public class Demo {
    public static void main(String[] args) throws Exception {
        List<String> names = new ArrayList();

        names.add("Google");
        names.add("Runoob");
        names.add("Taobao");
        names.add("Baidu");
        names.add("Sina");

        names.forEach(System.out::println);
    }
}
```

## 三、函数式接口

函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。

当一个接口符合函数式接口定义（有且只有一个抽象方法），那么就可以通过 lambda 表达式、方法引用的方式来创建，无论该接口有没有加上 `@FunctionalInterface` 注解。即 **lambda表达式就是函数式接口的实现！**

### 示例

```java
public class Demo {
    public static void main(String[] args) {
        printString("函数式编程", System.out::println);
    }

    private static void printString(String text, MyFunction myFunction) {
        myFunction.print(text);
    }
}

@FunctionalInterface
interface MyFunction {
    void print(String s);
}
```

### `java.util.function` 包

在 `java.util.function` 包下，定义了大量的函数式接口，每个接口都有且只有一个抽象方法，这些接口的区别在于其中的抽象方法的参数和返回值不同。

| 类型                      | 参数个数 | 参数类型      | 返回值类型 |
| ------------------------- | -------- | ------------- | ---------- |
| `Function<T,R>`           | 1        | T             | R          |
| `IntFunction<R>`          | 1        | int           | R          |
| `LongFunction<R>`         | 1        | long          | R          |
| `DoubleFunction<R>`       | 1        | double        | R          |
| `ToIntFunction<T>`        | 1        | T             | int        |
| `ToLongFunction<T>`       | 1        | T             | long       |
| `ToDoubleFunction<T>`     | 1        | T             | double     |
| `IntToLongFunction`       | 1        | int           | long       |
| `IntToDoubleFunction`     | 1        | int           | double     |
| `LongToIntFunction`       | 1        | long          | int        |
| `LongToDoubleFunction`    | 1        | long          | double     |
| `DoubleToIntFunction`     | 1        | double        | int        |
| `DoubleToLongFunction`    | 1        | double        | long       |
| `BiFunction<T,U,R>`       | 2        | T,U           | R          |
| `ToIntBiFunction<T,U>`    | 2        | T,U           | int        |
| `ToLongBiFunction<T,U>`   | 2        | T,U           | long       |
| `ToDoubleBiFunction<T,U>` | 2        | T,U           | double     |
| `UnaryOperator<T>`        | 1        | T             | T          |
| `IntUnaryOperator`        | 1        | int           | int        |
| `LongUnaryOperator`       | 1        | long          | long       |
| `DoubleUnaryOperator`     | 1        | double        | double     |
| `BinaryOperator<T>`       | 2        | T,T           | T          |
| `IntBinaryOperator`       | 2        | int,int       | int        |
| `LongBinaryOperator`      | 2        | long,long     | long       |
| `DoubleBinaryOperator`    | 2        | double,double | double     |
| `Consumer<T>`             | 1        | T             | void       |
| `IntConsumer`             | 1        | int           | void       |
| `LongConsumer`            | 1        | long          | void       |
| `DoubleConsumer`          | 1        | double        | void       |
| `BiConsumer<T,U>`         | 2        | T,U           | void       |
| `ObjIntConsumer<T>`       | 2        | T,int         | void       |
| `ObjLongConsumer<T>`      | 2        | T,long        | void       |
| `ObjDoubleConsumer<T>`    | 2        | T,double      | void       |
| `Supplier<T>`             | 0        | -             | T          |
| `BooleanSupplier`         | 0        | -             | boolean    |
| `IntSupplier`             | 0        | -             | int        |
| `LongSupplier`            | 0        | -             | long       |
| `DoubleSupplier`          | 0        | -             | double     |
| `Predicate<T>`            | 1        | T             | boolean    |
| `IntPredicate`            | 1        | int           | boolean    |
| `LongPredicate`           | 1        | long          | boolean    |
| `DoublePredicate`         | 1        | double        | boolean    |
| `BiPredicate<T,U>`        | 2        | T,U           | boolean    |

## 四、Stream

Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。

Stream API可以极大提高Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。

这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。

元素流在管道中经过中间操作（intermediate operation）的处理，最后由最终操作(terminal operation)得到前面处理的结果。

```
+--------------------+       +------+   +------+   +---+   +-------+
| stream of elements +-----> |filter+-> |sorted+-> |map+-> |collect|
+--------------------+       +------+   +------+   +---+   +-------+
```

以上的流程转换为 Java 代码为：

```java
List<Integer> transactionsIds = 
widgets.stream()
             .filter(b -> b.getColor() == RED)
             .sorted((x,y) -> x.getWeight() - y.getWeight())
             .mapToInt(Widget::getWeight)
             .sum();
```

### 生成流

在 Java 8 中, 集合接口有两个方法来生成流：

- **stream()** − 为集合创建串行流。
- **parallelStream()** − 为集合创建并行流。

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

### forEach

Stream 提供了新的方法 `forEach`来迭代流中的每个数据。以下代码片段使用`forEach` 输出了10个随机数：

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### map

map 方法用于映射每个元素到对应的结果，以下代码片段使用 map 输出了元素对应的平方数：

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取对应的平方数
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
```

### filter

filter 方法用于通过设置的条件过滤出元素。以下代码片段使用 filter 方法过滤出空字符串：

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
long count = strings.stream().filter(string -> string.isEmpty()).count();
```

### limit

limit 方法用于获取指定数量的流。 以下代码片段使用 limit 方法打印出 10 条数据：

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### sorted

sorted 方法用于对流进行排序。以下代码片段使用 sorted 方法对输出的 10 个随机数进行排序：

```java
Random random = new Random();
random.ints().limit(10).sorted().forEach(System.out::println);
```

### 并行（parallel）程序

`parallelStream` 是流并行处理程序的代替方法。以下实例我们使用 `parallelStream` 来输出空字符串的数量：

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
long count = strings.parallelStream().filter(string -> string.isEmpty()).count();
```

### Collectors

Collectors 类实现了很多归约操作，例如将流转换成集合和聚合元素。Collectors 可用于返回列表或字符串：

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
 
System.out.println("筛选列表: " + filtered);
String mergedString = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.joining(", "));
System.out.println("合并字符串: " + mergedString);
```

### 统计

另外，一些产生统计结果的收集器也非常有用。它们主要用于int、double、long等基本类型上，它们可以用来产生类似如下的统计结果。

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
 
IntSummaryStatistics stats = numbers.stream().mapToInt((x) -> x).summaryStatistics();
 
System.out.println("列表中最大的数 : " + stats.getMax());
System.out.println("列表中最小的数 : " + stats.getMin());
System.out.println("所有数之和 : " + stats.getSum());
System.out.println("平均数 : " + stats.getAverage());
```

## 五、Optional 类

Optional 类是一个可以为null的容器对象。如果值存在则`isPresent()`方法会返回true，调用get()方法会返回该对象；

Optional 是个容器：它可以保存类型T的值，或者仅仅保存null。`Optional`提供很多有用的方法，这样我们就不用显式进行空值检测；

Optional 类的引入很好的解决空指针异常。

常用方法：

| 方法                                                         | 功能描述                                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `static <T> Optional<T> empty()`                             | 返回空的 Optional 实例；                                     |
| `equals(Object obj)`                                         | 判断其他对象是否等于 Optional；                              |
| `Optional<T> filter(Predicate<? super <T> predicate)`        | 如果值存在，并且这个值匹配给定的 predicate，返回一个Optional用以描述这个值，否则返回一个空的Optional； |
| `<U> Optional<U> flatMap(Function<? super T,Optional<U>> mapper)` | 如果值存在，返回基于Optional包含的映射方法的值，否则返回一个空的Optional； |
| `T get()`                                                    | 如果在这个`Optional`中包含这个值，返回值，否则抛出异常`NoSuchElementException`； |
| `hashCode()`                                                 | 返回存在值的哈希码，如果值不存在 返回 0；                    |
| `ifPresent(Consumer<? super T> consumer)`                    | 如果值存在则使用该值调用 consumer , 否则不做任何事情；       |
| `isPresent()`                                                | 如果值存在则方法会返回true，否则返回 false；                 |
| `<U>Optional<U> map(Function<? super T,? extends U> mapper)` | 如果有值，则对其执行调用映射函数得到返回值。如果返回值不为 null，则创建包含映射返回值的Optional作为map方法返回值，否则返回空Optional； |
| `<T> Optional<T> of(T value)`                                | 返回一个指定非null值的Optional；                             |
| `<T> Optional<T> ofNullable(T value)`                        | 如果为非空，返回 Optional 描述的指定值，否则返回空的 Optional； |
| `T orElse(T other)`                                          | 如果存在该值，返回值， 否则返回 other；                      |
| `T orElseGet(Supplier<? extends T> other)`                   | 如果存在该值，返回值， 否则触发 other，并返回 other 调用的结果； |
| `<X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier)` | 如果存在该值，返回包含的值，否则抛出由 Supplier 继承的异常； |
| `String toString()`                                          | 返回一个Optional的非空字符串，用来调试。                     |