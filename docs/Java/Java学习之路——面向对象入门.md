# Java学习之路——面向对象入门

## 一、面向对象的思想

- **面向对象** ：（Object Oriented，简称OOP）是一种程序设计思想，OOP思想把对象作为程序的基本单元，一个对象包含了数据和操作数据的函数。

- **面向过程** (Procedure Oriented) 是一种 以过程为中心 的编程思想。这些都是以什么正在发生为主要目标进行编程，不同于面向对象的是谁在受影响。与面向对象明显的不同就是 封装、继承、类。

Java语言就是一门典型的面向对象的编程语言。

## 二、面向对象基础知识

### 1. 类和对象

- **类**：类是对一类事物的描述，是抽象的、概念上的定义。它是一个定义包括在特定类型的对象中的方法和变量的软件模板，用于创建对象的蓝图。
- **对象**：对象是对客观事物的抽象，是实际存在的该类事物的每个个体，是对类的实例化。

### 2. 类的基本结构

一个类包含了两个要素：**特性和行为** => 同一类事物具有相同的特征和行为。

- **属性（property）**：类或者对象具有的特征在程序中称为**属性**；
- **方法（Method）**：类或者对象的行为称为**方法**。

### 3. 三大特征

- **封装**：即**把客观事物封装成抽象的类**， 并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行信息隐藏。**一个类就是一个封装了数据以及操作这些数据的代码的逻辑实体**。在一个对象内部，**某些代码或某些数据可以是私有的，不能被外界访问**。通过这种方式，对象对内部数据提供了不同级别的保护，以防止程序中无关的部分意外的改变或错误的使用了对象的私有部分。
- **继承**：指可以让**某个类型的对象获得另一个类型的对象的属性和方法**。它支持按级分类的概念。继承是指这样一种能力：**它可以使用现有类的所有功能**，并在无需重新编写原来的类的情况下对这些功能进行扩展。通过继承创建的新类称为“子类”或“派生类”，被继承的类称为“基类”、“父类”或“超类”。继承的过程，就是从一般到特殊的过程。要实现继承，可以通过**“继承”（Inheritance）和组合（Composition）**来实现。继承概念的实现方式有二类：**实现继承与接口继承**。实现继承是指直接使用基类的属性和方法而无需额外编码的能力；接口继承是指仅使用属性和方法的名称、但是子类必须提供实现的能力。
- 多态：是指**一个类实例的相同方法在不同情形有不同表现形式**。多态机制使具有不同内部结构的对象可以共享相同的外部接口。这意味着，虽然针对不同对象的具体操作不同，但通过一个公共的类，它们（那些操作）可以通过相同的方式予以调用（比如输入的形参可以不同等，去实现同一个方法从而得到不同的表现形式）。

### 4. 六大准则

- **单一职责原则 (SRP)**：**对一个类而言，应该仅有一个引起它变化的原因**。解释：一个类中是一组相关性和高的函数，一个类尽量只实现一个功能。
- **开闭原则 (OCP)**：**软件实体应该是可以扩展的，但是不可修改**。解释：当一个类实现了一个功能的时候，如果想要改变这个功能不是去修改代码，而是通过扩展的方式去实现。实现该类提供的接口方法，然后注入到该类中，通过这种方法去实现功能的改变。
- **里氏替换原则 (LSP)**：**子类型必须能够替换掉它们的基类型**。解释：只要父类能出现的地方子类就可以出现，替换为子类也不会产生任何的错误。开闭原则一般可以通过里氏替换实现对扩展开放，对修改关闭的效果。
- **依赖倒置原则 (DIP)**：**抽象不应依赖于细节，细节应该依赖于抽象**。解释：模块间的依赖通过抽象发生，实现类之间不发生直接的依赖关系，其依赖关系是通过接口或抽象类产生的。即依赖抽象，而不依赖具体的实现。
- **接口隔离原则 (ISP)**：**多个专用接口优于一个单一的通用接口**。解释：客户端不应该依赖它不需要的接口，其目的是解开系统的耦合，从而容易重构更改。
- **迪米特原则 (LOD)**：**一个对象应该对其他对象保持最少的了解**。解释：一个类应该对自己需要耦合或调用的类知道的越少越好，类的内部如何实现与调用者或依赖者没关系。

## 三、面向对象实现

### 1. 创建一个类

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();
    }
}

class Person {
    
}
```

实际上在我们写出并运行第一个 Java 程序时，我们就已经创建了一个类，这个类是公开的，是 Java 程序运行的入口，例如上面的 Demo 类。

在上面的程序中，我们又实现了一个 Person 类，并且实例化了一个 p 对象。

实例化对象时通过以下方式进行创建：

```java
类名称 对象名 = new 类名称();
```

### 2. 权限修饰符

Java有四种访问权限，其中三种有访问权限修饰符，分别为private、public、protected和default（缺省）：

- **private:** Java语言中对访问权限限制的最窄的修饰符，一般称之为“私有的”。被其修饰的类、属性以及方法只能被该类的对象访问，其子类不能访问，更不能允许跨包访问；
- **default：**即不加任何访问修饰符，通常称为“默认访问模式“。该模式下，只允许在同一个包中进行访问；
- **protect:** 介于 public 和 private 之间的一种访问修饰符，一般称之为“保护形”。被其修饰的类、属性以及方法只能被类本身的方法及子类访问，即使子类在不同的包中也可以访问；
- **public：** Java语言中访问限制最宽的修饰符，一般称之为“公共的”。被其修饰的类、属性以及方法不仅可以跨类访问，而且允许跨包（package）访问。

| 权限修饰符 | 同一个类 | 同一个包 | 不同包的子类 | 不同包的非子类 |
| ---------- | -------- | -------- | ------------ | -------------- |
| Private    | √        |          |              |                |
| Default    | √        | √        |              |                |
| Protected  | √        | √        | √            |                |
| Public     | √        | √        | √            | √              |

### 3. 定义方法与属性

- **属性**：权限修饰符 + 变量类型 + 变量名 + 赋值（可选）
- **方法**：权限修饰符 + 返回值类型 + 函数名 + ( + 形参列表 + ) + { }

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();  // 对 Person 类实例化
        p.name = "小明";
        p.talkName();
//        p.age = 18;  // 由于 age 是 private类型，因此外部没法访问
        p.talkAge();
    }
}

class Person {
    private int age;   // 定义了一个age属性
    public String name;

    public void talkAge() {  // 定义了一个方法
        System.out.println("My age is " + age);
    }

    void talkName() {
        System.out.println("My name is " + name);
    }
}
```

### 4. 方法的使用

#### Ⅰ、基本规则

- return 关键字作用于整个方法体中，其作用为结束方法的调用并返回值。返回值类型必须和声明中的一致，如果声明中返回值类型为 void，则方法中可以不使用 return 关键字；
- 在方法中可以调用自身；
- 方法中不可以定义另外一个方法。

#### Ⅱ、方法的重载

**方法重载**是一个类中定义了多个**方法**名相同，而他们的参数的数量不同或数量相同而类型和次序不同，则称为**方法**的**重载**(Overloading)。

在 Java 语言中，同一个类中允许存在一个或者多个名字相同的方法，只要它们的参数列表不同（形参个数、形参类型、形参顺序）：

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();
        p.talkName();
        p.talkName("小张");
    }
}

class Person {
    public void talkName() {
        System.out.println("My name is 小明");
    }

    public void talkName(String name) {
        System.out.println("My name is " + name);
    }
}
```

#### Ⅲ、可变参数形参

在 Java 5 中提供了变长参数，允许在调用方法时传入不定长度的参数。变长参数是 Java 的一个语法糖，本质上还是基于数组的实现。	

在定义方法时，在最后一个形参后加上三点 **…**，就表示该形参可以接受多个参数值，多个参数值被当成数组传入。上述定义有几个要点需要注意：

- 可变参数只能作为函数的最后一个参数，但其前面可以有也可以没有任何其他参数
- 由于可变参数必须是最后一个参数，所以一个函数最多只能有一个可变参数
- Java的可变参数，会被编译器转型为一个数组
- 变长参数在编译为字节码后，在方法签名中就是以数组形态出现的。这两个方法的签名是一致的，不能作为方法的重载。如果同时出现，是不能编译通过的。可变参数可以兼容数组，反之则不成立

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();
        p.talkName("小明", "小红", "小刚");
    }
}

class Person {
    public void talkName(String ... name) {
        for (int i=0 ; i<name.length ; i++) {
            System.out.println("My name is " + name[i]);
        }
    }
}
```

#### Ⅳ、方法中参数传递

在 Java程序中，向方法传递参数时有两种传递方式：

- **值传递**：方法调用时，实际参数把它的值传递给对应的形式参数，方法执行中形式参数值的改变不影响实际参数的值。**八种基本数据类型使用此种传递方式**。
- **引用传递**：也称为地址传递。方法调用时，实际参数的引用(地址，而不是参数的值)被传递给方法中相对应的形式参数，在方法执行中，对形式参数的操作实际上就是对实际参数的操作，方法执行中形式参数值的改变将会影响实际参数的值。**引用数据类型使用此种传递方式**。

```java
public class Demo {
    public void changeValue(int arg) {
        arg = 100;
    }

    public void changeValue(int[] args) {
        args[0] = 100;
    }

    public static void main(String[] args) {
        int i=10;
        int[] arr = new int[]{10, 20, 30};

        // 基本数据类型
        System.out.println(i);
        new Demo().changeValue(i);
        System.out.println(i);

        // 引用数据类型
        System.out.println(arr[0]);
        new Demo().changeValue(arr);
        System.out.println(arr[0]);
    }
}
```

#### Ⅴ、递归调用

递归是指在函数的定义中使用函数自身的方法。

下面这个例子就是使用递归思想求取斐波那契数列：

```java
public class Demo {
    // 输出斐波那契数列第n项对应的数字
    public int fibonacciSequence(int count) {
        if (count == 1 || count == 2) {
            return 1;
        } else {
            return fibonacciSequence(count - 1) + fibonacciSequence(count - 2);
        }
    }

    public static void main(String[] args) {
        int res = new Demo().fibonacciSequence(6);
        System.out.println(res);
    }
}
```

### 5. 匿名对象

经过前面的学习，我们知道创建对象时每次 new 都相当于开辟了一个新的对象，并开辟了一个新的物理内存空间。如果一个对象只需要使用唯一的一次，就可以使用匿名对象，匿名对象还可以作为实际参数传递。

匿名对象就是没有明确的给出名字的对象，是对象的一种简写形式。一般匿名对象只使用一次，而且匿名对象只在堆内存中开辟空间，而不存在栈内存的引用。

```java
public class Demo {
    public static void main(String[] args) {
        new Person().talkName();
    }
}

class Person {
    void talkName() {
        System.out.println("My name is 小明");
    }
}
```

### 6. 构造器

构造函数（构造器）是一种特殊的函数。其主要功能是用来在创建对象时初始化对象， 即为对象成员变量赋初始值，总与new运算符一起使用在创建对象的语句中。构造函数与类名相同，可重载多个不同的构造函数。

#### 构造函数格式

```java
修饰符 class_name(类名) (参数列表){
	逻辑代码
}
```

#### 构造器特性

- 如果我们的类当中没有定义任何构造器，系统会给我们默认提供一个无参的构造器。
- 如果我们的类当中定义了构造器，那么系统就不会再给我们提供默认的无参构造器，如果需要无参构造器则必须显式的写出来。

**作用**：构建创造一个对象。同时可以给我们的属性做一个初始化操作。

#### 构造器与普通方法的区别

|   主题   |                            构造器                            |                  方法                  |
| :------: | :----------------------------------------------------------: | :------------------------------------: |
|   功能   |                       建立一个类的实例                       |              java功能语句              |
|   修饰   | 不能用`bstract`, `final`, `native`, `static`, or `synchronized` |                   能                   |
| 返回类型 |                     没有返回值，没有void                     |           有返回值，或者void           |
|   命名   |               和类名相同；通常为名词，大写开头               |    通常代表一个动词的意思，小写开头    |
|  `this`  |            指向同一个类中另外一个构造器，在第一行            | 指向当前类的一个实例，不能用于静态方法 |
| `super`  |                  调用父类的构造器，在第一行                  |        调用父类中一个重载的方法        |
|   继承   |                       构造器不能被继承                       |             方法可以被继承             |

#### 示例

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person(15);
        p.getAge();
    }
}

class Person {
    private int age;

    public Person(int age) {
        this.age = age;
    }

    public void getAge() {
        System.out.println("My age is " + age);
    }
}
```

### 7.this 关键字

在 Java中，`this`关键字是一个引用当前对象的引用变量，它有多种用法：

- `this`关键字可用来引用当前类的实例变量；
- `this`关键字可用于调用当前类方法(隐式)；
- `this()`可以用来调用当前类的构造函数；
- `this`关键字可作为调用方法中的参数传递；
- `this`关键字可作为参数在构造函数调用中传递；
- `this`关键字可用于从方法返回当前类的实例。

通常情况下我们都选择省略 `this` 关键字。但是当方法的形参名和类的属性名相同时，必须通过 `this` 关键字来区分形参和属性。

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person("小明", 15);
    }
}

class Person {
    private int age;
    private String name;

    public Person() {
    }

    public Person(String name) {
        this();
        this.name = name;
    }

    public Person(String name, int age) {
        this(name);
        this.age = age;
    }
}
```

### 8.JavaBean

JavaBean 是特殊的 Java 类，使用 Java 语言书写，并且遵守 JavaBean API 规范。它相比于其它 Java 类有着以下特征：

- 提供一个默认的无参构造函数；
- 类是公共的；
- 需要被序列化并且实现了 Serializable 接口；
- 可能有一系列可读写属性；
- 可能有一系列的 **getter** 或 **setter** 方法。

**JavaBean 程序示例**

```java
package com.demo;

public class StudentsBean implements java.io.Serializable
{
   private String firstName = null;
   private String lastName = null;
   private int age = 0;

   public StudentsBean() {
   }
    
   public String getFirstName(){
      return firstName;
   }
   public String getLastName(){
      return lastName;
   }
   public int getAge(){
      return age;
   }

   public void setFirstName(String firstName){
      this.firstName = firstName;
   }
   public void setLastName(String lastName){
      this.lastName = lastName;
   }
   public void setAge(int age) {
      this.age = age;
   }
}
```

### 9. 封装

**封装**：是指隐藏对象的属性和实现细节，仅对外提供公共访问方式。

封装有着众多好处，它能将变化隔离、便于使用、提高重用性、提高安全性，是面向对象编程的重要部分。

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();

        p.setAge(10);
        p.getAge();

        p.setAge(-5);
    }
}

class Person {
    private int age;
	
    // 对输入数据进行判决
    public void setAge(int age) {
        if (age > 100 || age < 0) {
            System.out.println("年龄超出范围");
        } else {
            this.age = age;
        }
    }

    public void getAge() {
        System.out.println("My age is " + age);
    }
}
```

### 10.继承

继承就是子类继承父类的特征和行为，使得子类对象（实例）具有父类的实例域和方法，或子类从父类继承方法，使得子类具有父类相同的行为。

继承是所有OOP语言不可缺少的部分，在 Java 中使用 `extends` 关键字来表示继承关系。当创建一个类时，总是在继承，如果没有明确指出要继承的类，就总是隐式地从根类Object进行继承。

#### 继承的规则

- 能够继承父类的 public 和 protected 成员变量和成员方法；不能够继承父类的 private 成员变量和成员方法；
- 对于父类的包访问权限成员变量和成员方法，如果子类和父类在同一个包下，则子类能够继承；否则，子类不能够继承；
- 对于子类可以继承的父类成员变量，如果在子类中出现了同名称的成员变量，则会发生**隐藏**现象，即子类的成员变量会屏蔽掉父类的同名成员变量。如果要在子类中访问父类中同名成员变量，需要使用super关键字来进行引用；
- 对于子类可以继承的父类成员方法，如果在子类中出现了同名称的成员方法，则称为**覆盖**，即子类的成员方法会覆盖掉父类的同名成员方法。如果要在子类中访问父类中同名成员方法，需要使用super关键字来进行引用（隐藏是针对成员变量和静态方法的，而覆盖是针对普通方法的）；
- 子类是不能够继承父类的构造器，但是要注意的是，如果父类的构造器都是带有参数的，则必须在子类的构造器中显示地通过 super 关键字调用父类的构造器并配以适当的参数列表。如果父类有无参构造器，则在子类的构造器中用 super 关键字调用父类构造器不是必须的，如果没有使用 super 关键字，系统会自动调用父类的无参构造器。

#### 继承的格式

```java
class 父类 {
}
 
class 子类 extends 父类 {
}
```

#### **重写的规则：**

- 子类重写的方法的方法名和形参列表与父类被重写的方法名和形参列表相同；
- 子类重写的方法的权限修饰符不小于父类被重写的方法权限修饰符（子类不能重写 `private` 权限的方法）；
- 重写的方法的返回值可以为被重写的方法的返回值的子类；若被重写方法返回值为基本类型，则重写方法返回值也必须为基本类型。

#### 例子

```java
class Person {
    private int age;
    private String name;

    public Person(int age, String name) {
        this.age = age;
        this.name = name;
    }

    public void talk() {
        System.out.println("My name is " + name + ", my age is " + age);
    }
}

class Students extends Person {
    private String major;

    public Students(int age , String name, String major) {
        super(age , name);
        this.major = major;
    }
	
    // 子类重写父类方法时，添加 @Override 标识该方法是重写的方法（无实际意义）
    @Override
    public void talk() {
        super.talk();
        System.out.println("My major is " + major);
    }
}
```

### 11. 多态

#### 多态的定义

多态是同一个行为具有多个不同表现形式或形态的能力，就是同一个接口，使用不同的实例而执行不同操作。

#### 多态的优点

- 消除类型之间的耦合关系
- 可替换性
- 可扩充性
- 接口性
- 灵活性
- 简化性

#### 多态存在的三个必要条件

- 继承
- 重写
- 父类引用指向子类对象：**Parent p = new Child();**

#### 多态的使用

当调用父类同名同参的方法时，实际上调用的是子类重写的方法，即**虚拟方法调用**。

有了多态，程序在编译期间运行的是父类的方法，但是在运行期间运行的是子类的方法。

注意：多态性不适用于属性（编译和运行时期都是调用的父类的属性）！

#### 多态的实现方式

- 重写
- 接口
- 抽象类和抽象方法

**例子：**

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Students();
        p.talk();
//        p.run();  // 调用子类特有的方法（父类没有）时会报错
    }
}

class Person {

    public void talk() {
        System.out.println("I'm a person.");
    }
}

class Students extends Person {

    @Override
    public void talk() {
        System.out.println("I'm a students.");
    }

    public void run() {
        System.out.println("I'm running.");
    }
}
```

### 12. 转型

在 Java 中有着两种转型，分别为向上转型和向下转型，下面用一个简单的例子来演示两种转型：

注：Son 类为 Father 类的子类

```java
Father f1 = new Son();  // 向上转型
Son s1 = (Son)f1;	    // 向下转型
```

#### 向上转型

向上转型是多态的应用之一，它的优点可以通过下面这个例子体现出来：

```java
public class Demo {
    public static void main(String[] args) {
        Demo.doTalk(new Person());
        Demo.doTalk(new Students());
        Demo.doTalk(new Teacher());
    }

    public static void doTalk(Person p) {
        p.talk();
    }
}

class Person {
    public void talk() {
        System.out.println("I'm a person.");
    }
}

class Students extends Person {
    @Override
    public void talk() {
        System.out.println("I'm a student.");
    }
}

class Teacher extends Person {
    @Override
    public void talk() {
        System.out.println("I'm a teacher.");
    }
}
```

在上面的代码中，如果不用向上转型则必须写三个 doTalk 方法，一个传递 Person 类对象，一个传递 Students 类对象，再来一个传递 Teacher 类对象。如果没有向上转型，则每个子类都要写相对应的方法，造成重复。可以看出向上转型很好的体现了类的多态性，增强了程序的间接性以及提高了代码的可扩展性。当需要用到子类特有的方法时可以向上转型，这也就是为什么要向下转型。

#### 向下转型

我们知道，在向上转型之后，引用对象是没法调用子类特有的方法的。那么如何才能调用子类特有的方法呢？这就需要用到向下转型。

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Students();
        p.talk();
//        p.run();
        Students st = (Students) p;
        st.run();
    }
}

class Person {
    public void talk() {
        System.out.println("I'm a person.");
    }
}

class Students extends Person {
    @Override
    public void talk() {
        System.out.println("I'm a student.");
    }

    public void run() {
        System.out.println("The students are running.");
    }
}
```

#### instanceof 关键字

试一下下面的代码，看看会发生什么问题：

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Man();
        Woman wm = (Woman) p;
    }
}

class Person {
}

class Man extends Person {
}

class Woman extends Person {
}
```

运行后发现抛出了 `ClassCastException` 错误。

这是因为虽然 p 是 Person 类的引用对象，但是实例却是 Man 类的，而 Man 类和 Woman 类是没有继承关系的，因此在向下转型时就会发生错误。

因此我们在使用向下转型之前必须要判断实例对象是否是我们需要转型的类的子类，instanceof 关键字的作用便是如此。

**用法**

```java
实例对象 instanceof 类
```

如果实例对象是这个类的实例，则返回 True；反之返回 Fasle。

加了判断之后就不会再发生  `ClassCastException` 错误了。

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Man();
        if (p instanceof Woman) {
            Woman wm = (Woman) p;
        }
    }
}

class Person {
}

class Man extends Person {
}

class Woman extends Person {
}
```

#### 小结

1. 把子类对象直接赋给父类引用是向上转型，向上转型自动转换；
2. 向上转型时会优先使用子类中重写父类的方法；
3. 向上转型不能使用子类特有的属性和方法，只能引用父类的属性和方法，但是子类重写父类的方法是有效的；
4. 向上转型可以将父类作为参数，其作用是**减少重复代码**，使代码变得简洁，也更好的体现了多态；
5. 指向子类对象的父类引用赋给子类引用是向下转型，要强制转换。使用向下转型，必须先向上转型；
6. 向下转型可以**让父类引用使用子类的新增方法**。
7. 向下转型时，为了安全可以用 instanceof 运算符判断；
8. ***无论向上转型还是向下转型，程序编译时检查的是左边，运行看右边。***



