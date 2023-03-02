# Java学习之路——反射

## 概述

### 定义

反射（Reflection）被视为动态语言的关键，通过反射机制可以运行程序在***运行期间* 获取任何对象的所有信息**，并且能够直接操作对象的属性与方法。

Java 反射机制可以动态地创建对象并调用其属性，这样的对象的类型在编译期是未知的。所以我们可以通过反射机制直接创建对象，即使这个对象的类型在编译期是未知的。

反射的核心是 JVM 在运行时才动态加载类或调用方法/访问属性，它不需要事先（写代码的时候或编译期）知道运行对象是谁。

### 功能

Java 反射主要提供以下功能：

- 在运行时判断任意一个对象所属的类；
- 在运行时构造任意一个类的对象；
- 在运行时判断任意一个类所具有的成员变量和方法（通过反射甚至可以调用private方法）；
- 在运行时调用任意一个对象的方法和属性；
- 在运行时获取泛型的信息；
- 在运行时处理注解；
- 生成动态代理。

### 区别

通过反射构造对象与正常方式有着如下区别：

- 正常情况下：

  ```mermaid
  graph LR
  	A[引入需要的类] --> B[通过 new 实例化]
  	B --> C[获取实例对象]
  ```

- 反射机制下：

  ```mermaid
  graph LR
  	A[实例化对象] --> B[调用 getClass 方法]
  	B --> C[得到完整的类]
  	C --> D[构造进的实例对象]
  ```

## 一、Class 类

### 定义

在 Java 程序种除了八种基本类型外，其他类型全部都是`class`（包括`interface`）。而`class`是由JVM在执行过程中动态加载的。JVM在第一次读取到一种`class`类型时，将其加载进内存。

每加载一种`class`，JVM就为其创建一个`Class（名叫 Class 的 类）`类型的实例，并关联起来。

由于JVM为每个加载的`class`创建了对应的`Class`实例，并在实例中保存了该`class`的所有信息，包括类名、包名、父类、实现的接口、所有方法、字段等，因此，如果获取了某个`Class`实例，我们就可以通过这个`Class`实例获取到该实例对应的`class`的所有信息。

这种通过`Class`实例获取`class`信息的方法称为反射（Reflection）。

### 获取 Class 类

- 方式一：通过类的 `class` 属性获取

  ```java
  Class clazz = String.class;
  ```

- 方式二：过该实例变量提供的`getClass()`方法获取

  ```java
  String s = "Hello";
  Class clazz = s.getClass();
  ```

- 如果知道一个`class`的完整类名，可以通过静态方法`Class.forName()`获取

  ```java
  Class clazz = Class.forName("java.lang.String");
  ```

## 二、获取字段

`Class`类提供了以下几个方法来获取字段：

- `Field getField(name)`：根据字段名获取某个 public 的 field（包括父类）；
- `Field getDeclaredField(name)`：根据字段名获取当前类的某个 field（不包括父类）；
- `Field[] getFields()`：获取所有 public 的 field（包括父类）；
- `Field[] getDeclaredFields()`：获取当前类的所有 field（不包括父类）。

## 三、调用方法

`Class`类提供了以下几个方法来获取`Method`：

- `Method getMethod(name, Class...)`：获取某个`public`的`Method`（包括父类）；
- `Method getDeclaredMethod(name, Class...)`：获取当前类的某个`Method`（不包括父类）；
- `Method[] getMethods()`：获取所有`public`的`Method`（包括父类）；
- `Method[] getDeclaredMethods()`：获取当前类的所有`Method`（不包括父类）。

## 四、调用构造器

通过Class实例获取Constructor的方法如下：

- `getConstructor(Class...)`：获取某个`public`的`Constructor`；
- `getDeclaredConstructor(Class...)`：获取某个`Constructor`；
- `getConstructors()`：获取所有`public`的`Constructor`；
- `getDeclaredConstructors()`：获取所有`Constructor`。

## 五、获取继承关系

通过`Class`对象可以获取继承关系：

- `Class getSuperclass()`：获取父类类型；
- `Class[] getInterfaces()`：获取当前类实现的所有接口。

## 六、使用反射

```java
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class Demo {
    public static void main(String[] args) throws Exception {
        // 构建 Person 实例
        Person p1 = new Person( "小明",15,60);
        System.out.println(p1);

        // 获取 Person 类结构
        Class clazz = Person.class;

        // 获取类构造器
        Constructor constructor = clazz.getConstructor(String.class, int.class, int.class);
        // 构造一个新的实例对象
        Object p2 = constructor.newInstance("小刚", 18, 70);
        System.out.println(p2);

        // 获取属性
        Field name = clazz.getDeclaredField("name");
        // 修改对象属性值
        name.set(p1, "小红");
        System.out.println(p1.name);

        // 获取方法
        Method sayName = clazz.getDeclaredMethod("sayName");
        // 调用对象的方法
        sayName.invoke(p1);

        // 获取私有构造器
        Constructor cons = clazz.getDeclaredConstructor(int.class);、
        // 允许反射获取，获取私有结构时必须添加本行
        cons.setAccessible(true);
        Person p3 = (Person) cons.newInstance(50);
        System.out.println(p3);
    }
}


class Person {
    public String name;
    public int age;
    private final int weight;

    public Person(String name, int age, int weight) {
        this(weight);
        this.name = name;
        this.age = age;
    }

    private Person(int weight) {
        this.weight = weight;
    }

    public void sayName() {
        System.out.println(name);
    }

    public void setAge(int age) {
        this.age = age;
    }

    private void sayWeight() {
        System.out.println(weight);
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", weight=" + weight +
                '}';
    }
}
```

## 七、动态代理

我们知道，在 Java 程序中所有`interface`类型的变量总是通过向上转型并指向某个实例的。

那么有没有可能不编写实现类，直接在运行期创建某个`interface`的实例呢？

这是可能的，因为Java标准库提供了一种动态代理（Dynamic Proxy）的机制：可以在运行期动态创建某个`interface`的实例。

在运行期动态创建一个`interface`实例的方法如下：

1. 定义一个`InvocationHandler`实例，它负责实现接口的方法调用；
2. 通过`Proxy.newProxyInstance()`创建`interface`实例，它需要3个参数：
   1. 使用的`ClassLoader`，通常就是接口类的`ClassLoader`；
   2. 需要实现的接口数组，至少需要传入一个接口进去；
   3. 用来处理接口方法调用的`InvocationHandler`实例。
3. 将返回的`Object`强制转型为接口。

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;

public class Demo {
    public static void main(String[] args) throws Exception {
        InvocationHandler handler = (proxy , method , args1) -> {
            System.out.println(method);
            if (method.getName().equals("morning")) {
                System.out.println("Good morning, " + args1[0]);
            }
            return null;
        };

        Hello hello = (Hello) Proxy.newProxyInstance(
                Hello.class.getClassLoader(), // 传入ClassLoader
                new Class[] { Hello.class }, // 传入要实现的接口
                handler); // 传入处理调用方法的InvocationHandler
        hello.morning("Bob");
    }
}


interface Hello {
    void morning(String name);
}
```

