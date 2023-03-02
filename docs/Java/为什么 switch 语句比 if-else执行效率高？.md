# 为什么 switch 语句执行效率比 if-else 语句高？

> 在我们学习流程控制语句时不难发现，很多情况下能使用 if-else 语句的地方我们都能够使用 switch 语句来代替。
>
> 有经验的开发者会建议我们，尽量使用 switch 语句来代替繁琐的 if-else。
>
> 这样做的原因：switch 语句的执行效率会比 if-else 语句高。

下面我们就写一个简单的程序来对其进行验证：

```java
public class Demo {
    public static void main(String[] args) {
        String aaa = "aaa";
        long t1 = System.nanoTime();
        if("a".equals(aaa)){
            System.out.println(aaa);
        } else if ("b".equals(aaa)) {
            System.out.println(aaa);
        } else if ("c".equals(aaa)) {
            System.out.println(aaa);
        } else if ("d".equals(aaa)) {
            System.out.println(aaa);
        } else if ("e".equals(aaa)) {
            System.out.println(aaa);
        } else if ("f".equals(aaa)) {
            System.out.println(aaa);
        } else if ("g".equals(aaa)) {
            System.out.println(aaa);
        } else if ("h".equals(aaa)) {
            System.out.println(aaa);
        } else if ("i".equals(aaa)) {
            System.out.println(aaa);
        } else if ("j".equals(aaa)) {
            System.out.println(aaa);
        } else if ("k".equals(aaa)) {
            System.out.println(aaa);
        } else if ("l".equals(aaa)) {
            System.out.println(aaa);
        } else if ("m".equals(aaa)) {
            System.out.println(aaa);
        } else if ("n".equals(aaa)) {
            System.out.println(aaa);
        } else {
            System.out.println(aaa);
        }
        long t2 = System.nanoTime();
        System.out.println("if 语句执行时间:　" + (t2 - t1));

        //switch语句测试代码：
        long tt1 = System.nanoTime();
        switch (aaa) {
            case "a":
                System.out.println(aaa);
                break;
            case "b":
                System.out.println(aaa);
                break;
            case "c":
                System.out.println(aaa);
                break;
            case "d":
                System.out.println(aaa);
                break;
            case "e":
                System.out.println(aaa);
                break;
            case "f":
                System.out.println(aaa);
                break;
            case "g":
                System.out.println(aaa);
                break;
            case "h":
                System.out.println(aaa);
                break;
            case "i":
                System.out.println(aaa);
                break;
            case "j":
                System.out.println(aaa);
                break;
            case "k":
                System.out.println(aaa);
                break;
            case "l":
                System.out.println(aaa);
                break;
            case "m":
                System.out.println(aaa);
                break;
            case "n":
                System.out.println(aaa);
                break;
            default:
                System.out.println(aaa);
                break;
        }
        long tt2 = System.nanoTime();
        System.out.println("switch 语句执行时间:　" + (tt2 - tt1));
    }
}
```

输出：

```
aaa
if 语句执行时间:　201300
aaa
switch 语句执行时间:　18200
```

我们可以发现在这个程序中，swicth 语句的执行时间仅仅只有 if-else 语句的二十分之一。

从这个程序就足以体现出 switch 语句的高效性。

那么为什么 switch 语句会比 if-else 语句高效的这么多呢？

这是因为编译器在处理 switch 语句时，会生成一个跳转表，然后根据值之间进行跳转。然而对于 if-else 语句，编译器需要一个一个进行比较，直到找到结果。

**从数据结构与算法的角度来看，switch 语句相当于一个数组，其查询时间复杂度为 O(1)；而 if-lese 语句相当于一个链表，其时间复杂度为 O(n)**。

