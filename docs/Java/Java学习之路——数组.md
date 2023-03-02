# Java学习之路——数组

## 一、数组概述

- **数组**（Array）是有序的元素序列。数组是在程序设计中，把具有相同类型的若干元素按有序的形式组织起来的一种形式。 这些有序排列的同类数据元素的集合称为数组；

- 数组本身是引用类型，数组中的元素可以是任意类型的（包括基本数据类型和引用数据类型）；
- 数组的长度一旦确定就不能改变；
- 可以通过索引的方式访问数组元素。

## 二、初始化数组

### 1. 静态初始化

```java
public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[]{1001, 1002, 1003};;  // 数组的声明和赋值同时进行
    }
}
```

### 2. 动态初始化

```java
public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[3];  // 数组的声明和赋值分开进行，动态初始化时声明传递数组长度
		
        arr[0] = 1001;
        arr[1] = 1002;
        arr[2] = 1003;
    }
}
```

## 三、数组元素的遍历

### 1. 索引

可以直接通过索引的方式访问每一个数组元素，但是当数组长度较大时重复性工作太多。

```java
public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[]{1001, 1002, 1003, 1004};  // 声明一个数组变量

        System.out.println(arr[0]);
        System.out.println(arr[1]);
        System.out.println(arr[2]);
        System.out.println(arr[3]);
    }
}
```

### 2. 循环+索引

```java
public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[]{1001, 1002, 1003, 1004};  // 声明一个数组变量

        for (int i=0 ; i<arr.length ; i++) {
            System.out.println(arr[i]);
        }
    }
}
```

### 3. for each 循环

```java
public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[]{1001, 1002, 1003, 1004};  // 声明一个数组变量

        for (int i: arr) {
            System.out.println(i);
        }
    }
}
```

### 4. Arrays.toString() 方法

```java
import java.util.Arrays;

public class Demo {
    public static void main(String[] args) {
        int[] arr = new int[]{1001, 1002, 1003, 1004};  // 声明一个数组变量

        System.out.println(Arrays.toString(arr));
    }
}
```

## 四、数组初始值

数组在初始化时，数组内部会赋值一个初始值，不同类型的数组初始值不同：

```java
import java.util.Arrays;

public class Demo {
    public static void main(String[] args) {
        // 整型
        byte[] arr1 = new byte[3];
        short[] arr2 = new short[3];
        int[] arr3 = new int[3];
        long[] arr4 = new long[3];

        // 浮点型
        float[] arr5 = new float[3];
        double[] arr6 = new double[3];

        // 非数值型
        char[] arr7 = new char[3];
        boolean[] arr8 = new boolean[3];

        // 字符串
        String[] arr9 = new String[3];

        System.out.println(Arrays.toString(arr1));
        System.out.println(Arrays.toString(arr2));
        System.out.println(Arrays.toString(arr3));
        System.out.println(Arrays.toString(arr4));
        System.out.println(Arrays.toString(arr5));
        System.out.println(Arrays.toString(arr6));
        System.out.println(Arrays.toString(arr7));
        System.out.println(Arrays.toString(arr8));
        System.out.println(Arrays.toString(arr9));
    }
}
```

结果：

```java
[0, 0, 0]
[0, 0, 0]
[0, 0, 0]
[0, 0, 0]
[0.0, 0.0, 0.0]
[0.0, 0.0, 0.0]
[ ,  ,  ]
[false, false, false]
[null, null, null]
```

由输出结果可以发现：

- **byte、short、int、long** 这几个整型数组的初始值为 **0** ；
- **float、double** 这几个浮点型数组的初始值为 **0.0**；
- **char** 型数组的初始值为 **'\u0000'**（不是什么都没有）；
- **boolean** 型数组初始值为 **false**；
- **String** 型数组初始值为 **null**。

## 五、多维数组

### 1. 二维数组

```java
public class Demo {
    public static void main(String[] args) {
        // 初始化二维数组
        int[][] arr = new int[3][];  // 两个方括号中第一个方括号中必须指定数组长度
        arr[0] = new int[]{1001, 1002, 1003};
        arr[1] = new int[]{1004, 1005};
        arr[2] = new int[]{1006, 1007, 1008, 1009};

        // 遍历二维数组
        for(int i=0 ; i<arr.length ; i++) {
            for (int j=0; j<arr[i].length ; j++) {
                System.out.println(arr[i][j]);
            }
        }
    }
}
```

### 2. 多维数组

由二维数组推广即可。