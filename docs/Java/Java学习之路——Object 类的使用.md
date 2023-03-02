# Java学习之路——Object 类的使用

## 简介

> 在 Java 程序中，如果我们没有明确指定类的父类，那么所有的类都继承自 Object 类（class java.lang.Object）。

我们可以用下面的程序验证是否继承自 Object 类：

```java
public class Demo {
    public static void main(String[] args) {
        Person p = new Person();
        System.out.println(p.getClass().getSuperclass());
    }
}

class Person {
}
```

[Object 类的官方文档](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html)

## 1. clone() 

作用：Creates and returns a copy of this object.

例子：

