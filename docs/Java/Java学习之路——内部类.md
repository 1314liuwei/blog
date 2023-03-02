# Java学习之路——内部类

## 概述

在Java中，可以将一个类定义在另一个类里面或者一个方法里面，这样的类称为内部类。

广泛意义上的内部类一般来说包括这四种：成员内部类、局部内部类、匿名内部类和静态内部类。

## 一、成员内部类

在类A中定义一个B类，那么A类就叫外部类，而B类就叫做成员内部类。

成员内部类可以无条件访问外部类的所有成员属性和成员方法（包括private成员和静态成员），但是外部类想访问成员内部类的成员就必须先创建一个成员内部类的对象，再通过指向这个对象的引用来访问内部类的属性。

```java
public class Demo {
    public static void main(String[] args)  {
        A a1 = new A();
        a1.testA();
    }
}

class A {
    private int x = 0;
    
    // 内部类B
    class B {
        int y=1;
        
        // 访问外部类的属性
        public void testB() {
            System.out.println(x);
        }
    }

    public void testA() {
        B b1 = new B();
        b1.testB();
        // 访问内部类的属性
        System.out.println(b1.y);
    }
}
```

当成员内部类拥有和外部类同名的成员变量或者方法时，会发生隐藏现象，即默认情况下访问的是成员内部类的成员。如果要访问外部类的同名成员，需要以下面的形式进行访问：

```java
外部类.this.成员变量
外部类.this.成员方法
```

示例

```java
public class Demo {
    public static void main(String[] args)  {
        A a1 = new A();
        a1.testA();
    }
}

class A {
    String name = "外部类";

    // 内部类B
    class B {
        String name = "内部类";

        // 访问外部类的属性
        public void test() {
            System.out.println(name);
            System.out.println(A.this.name);
        }
    }

    void testA() {
        B b1 = new B();
        b1.test();
    }
}
```

成员内部类是依附外部类而存在的，也就是说，如果要创建成员内部类的对象，前提是必须存在一个外部类的对象。

```java
public class Demo {
    public static void main(String[] args)  {
        // 初始化一个 A 对象
        A a1 = new A();

        // 方式1
        A.B b1 = a1.new B();

        // 方式2
        A.B b2 = a1.getBInstance();
    }
}

class A {
    private B b = null;

    public B getBInstance() {
        if(b == null)
            b = new B();
        return b;
    }

    // 内部类B
    class B {
        String name = "内部类";
    }
}
```

## 二、局部内部类

局部内部类是定义在一个方法或者一个作用域里面的类。局部内部类的访问仅限于方法内或者该作用域内。

局部内部类和局部变量类似，不能有 public、protected、private 以及 static 修饰符。

```java
public class Demo {
    public static void main(String[] args)  {
        class A {
            String name = "局部内部类";
        }

        A a1 = new A();
        System.out.println(a1.name);
    }
}
```

## 三、匿名内部类

只要一个类是抽象的或是一个接口，那么其子类中的方法都可以使用匿名内部类来实现。

匿名内部类是唯一一种没有构造器的类。因为其没有构造器，因此匿名内部类的使用范围是有限的。一般来说，匿名内部类用于继承其他类或是实现接口。

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person() {
            public void run() {
                System.out.println("Eating");
            }
        };
        p.run();
    }
}

abstract class Person {
    public abstract void run();
}
```

## 四、静态内部类

静态内部类也是定义在另一个类里面的类，这个类是一个静态类，不需要依靠外部类的实例化来进行调用。

```java
public class Demo {
    public static void main(String[] args)  {
        A.B b1 = new A.B();
        b1.testB();
    }
}

class A {
    // 内部类B
    static class B {
        String name = "静态内部类";

        // 访问外部类的属性
        public void testB() {
            System.out.println(name);
        }
    }
}
```

