# Java学习之路——控制语句

## 一、条件语句

### 1. if ... else ...

**语法**

```java
if(布尔表达式)
{
   //如果布尔表达式为true将执行的语句
}
```

**例子**

```java
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.print("请输入一个整数：");
        int num = input.nextInt();

        if (num >= 0) {
            System.out.println("输入了一个非负数");
        } else {
            System.out.println("输入了一个负数");
        }
    }
}
```

### 2.  if ... else if ... else ...

**语法**

```java
if(布尔表达式 1){
   //如果布尔表达式 1的值为true执行代码
} else if(布尔表达式 2){
   //如果布尔表达式 2的值为true执行代码
} else {
   //如果以上布尔表达式都不为true执行代码
}
```

**例子**

```java
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.print("请输入一个整数：");
        int num = input.nextInt();

        if (num > 0) {
            System.out.println("输入了一个非负数");
        } else if (num < 0) {
            System.out.println("输入了一个负数");
        } else {
            System.out.println("输入了一个 0");
        }
    }
}
```

## 二、循环语句

### 1. for 循环

**语法**

```java
for(初始化; 布尔表达式; 更新) {
    //代码语句
}
```

**执行过程**

- 最先执行初始化步骤。可以声明一种类型，但可初始化一个或多个循环控制变量，也可以是空语句；
- 然后，检测布尔表达式的值。如果为 true，循环体被执行。如果为false，循环终止，开始执行循环体后面的语句；
- 执行一次循环后，更新循环控制变量；
- 再次检测布尔表达式，循环执行上面的过程。

**例子**

```java
public class Demo {
    public static void main(String[] args) {
        for (int i=0 ; i<10 ; i++) {
            System.out.println(i);
        }
    }
}
```

### 2. 增强 for 循环

**语法**

```java
for(声明语句 : 表达式)
{
   //代码句子
}
```

**声明语句：**声明新的局部变量，该变量的类型必须和数组元素的类型匹配。其作用域限定在循环语句块，其值与此时数组元素的值相等。

**表达式：**表达式是要访问的数组名，或者是返回值为数组的方法。

**例子**

```java
public class Demo {
    public static void main(String[] args) {
        int[] nums = {0, 1, 2, 3};

        for (int i:nums) {
            System.out.println(i);
        }
    }
}
```

### 3. while 循环

**语法**

```java
while( 布尔表达式 ) {
  //循环内容
}
```

**执行过程：**只要布尔表达式为 true，循环就会一直执行下去。

**例子**

```java
public class Demo {
    public static void main(String[] args) {
        int i = 0;

        while (i < 10) {
            System.out.println(i);
            i++;
        }
    }
}
```

### 4. do … while 循环

语法

```java
do {
       //代码语句
} while (布尔表达式);
```

**执行过程：**布尔表达式在循环体的后面，所以语句块在检测布尔表达式之前已经执行了。 如果布尔表达式的值为 true，则语句块一直执行，直到布尔表达式的值为 false。

**例子**

```java
public class Demo {
    public static void main(String[] args) {
        int i = 0;

        do {
            System.out.println(i);
            i++;
        } while (i < 10);
    }
}
```

### 5. break 与 continue

**用途**

- **break：** 主要用在循环语句或者 switch 语句中，用来跳出整个语句块。break 仅仅跳出最里层的循环，外层循环会继续执行。
- **continue：** 适用于任何循环控制结构中。作用是让程序立刻跳转到下一次循环的迭代。在 for 循环中，continue 语句使程序立即跳转到更新语句。在 while 或者 do…while 循环中，程序立即跳转到布尔表达式的判断语句。

**例子**

```java
public class Demo {
    public static void main(String[] args) {
        for (int i = 0 ; i<10 ; i++) {
            if (i % 2 == 0) {
                continue;
            }
            System.out.println(i);
            if (i == 9) {
                break;
            }
        }
    }
}
```

### 6. 带标签的 break 与 continue

break 语句和 continue 语句默认情况下会对最近的一个循环产生作用，如果我们要对指定的循环产生作用，可以通过加标签的方式实现效果。

```java
public class Demo {
    public static void main(String[] args) {
        label:for (int i=0 ; i<10 ; i++) {
            for (int j=0; j<10 ; j++) {
                if (j % 2 == 1) {
                    System.out.println(j);
                    continue label;
                }
            }
        }
    }
}
```

加了标签之后，break 语句和 continue 语句就能结束指定的循环语句了。

## 三、分支选择语句

switch case 语句判断一个变量与一系列值中某个值是否相等，每个值称为一个分支。

**语法**

```java
switch(expression){
    case value :
       //语句
       break; //可选
    case value :
       //语句
       break; //可选
    //你可以有任意数量的case语句
    default : //可选
       //语句
}
```

switch case 语句有如下规则：

- switch 语句中的变量类型可以是： byte、short、int 或者 char。从 Java SE 7 开始，switch 支持字符串 String 类型了，同时 case 标签必须为字符串常量或字面量。
- switch 语句可以拥有多个 case 语句。每个 case 后面跟一个要比较的值和冒号。
- case 语句中的值的数据类型必须与变量的数据类型相同，而且只能是常量或者字面常量。
- 当变量的值与 case 语句的值相等时，那么 case 语句之后的语句开始执行，直到 break 语句出现才会跳出 switch 语句。
- 当遇到 break 语句时，switch 语句终止。程序跳转到 switch 语句后面的语句执行。case 语句不必须要包含 break 语句。如果没有 break 语句出现，程序会继续执行下一条 case 语句，直到出现 break 语句。
- switch 语句可以包含一个 default 分支，该分支一般是 switch 语句的最后一个分支（可以在任何位置，但建议在最后一个）。default 在没有 case 语句的值和变量值相等的时候执行。default 分支不需要 break 语句。
- switch case 执行时，一定会先进行匹配，匹配成功返回当前 case 的值，再根据是否有 break，判断是否继续输出，或是跳出判断。
- 如果 case 语句块中没有 break 语句时，JVM 并不会顺序输出每一个 case 对应的返回值，而是继续匹配，匹配不成功则返回默认 case。
- 如果当前匹配成功的 case 语句块没有 break 语句，则从当前 case 开始，后续所有 case 的值都会输出，如果后续的 case 语句块有 break 语句则会跳出判断

例子

```java
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.print("请输入你的成绩：");
        int score = input.nextInt();

        switch (score % 10) {
            case 9:
                System.out.println("优异");
                break;
            case 8:
                System.out.println("良好");
                break;
            case 7:
                System.out.println("一般");
                break;
            case 6:
                System.out.println("及格");
                break;
            default:
                System.out.println("不及格");
        }
    }
}
```

