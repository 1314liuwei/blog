

# Java学习之路——文件操作

## 概述

在计算机系统中，文件是非常重要的存储方式。在著名的操作系统 Linux 则更是“一切皆文件”，因此会操作文件我们需要掌握的基础本领之一。

## 一、`java.io.File `类

Java的标准库`java.io`提供了`File`对象来操作文件和目录。

`java.io.File`类用于描述文件系统中的一个文件或目录 该类可以：

- 1、访问文件或目录的属性信息 
- 2、访问一个目录中的所有子项
- 3、操作文件或目录（创建、删除）

但是，**`File` 类不能访问文件的具体内容**！例如读文件、写文件等操作就不能使用该类来完成。

### 构造文件对象

File 类有以下几种构造器：

- 通过给定的父抽象路径名和子路径名字符串构造文件对象；

```java
File(File parent, String child);
```

- 通过将给定路径名字符串转换成抽象路径名来构造文件对象；

```java
File(String pathname) 
```

- 根据 parent 路径名字符串和 child 路径名字符串构造文件对象；

```java
File(String parent, String child) 
```

- 通过将给定的 file: URI 转换成一个抽象路径名来构造文件对象。

```java
File(URI uri) 
```

示例

```java
import java.io.File;

public class Demo {
    public static void main(String[] args) {
        String dirname = "/java";
        File f1 = new File(dirname);
        if (f1.isDirectory()) {
            System.out.println("Directory of " + dirname);
            String s[] = f1.list();
            for (int i = 0; i < s.length; i++) {
                File f = new File(dirname + "/" + s[i]);
                if (f.isDirectory()) {
                    System.out.println(s[i] + " is a directory");
                } else {
                    System.out.println(s[i] + " is a file");
                }
            }
        } else {
            System.out.println(dirname + " is not a directory");
        }
    }
}
```

### 常用方法

| 方法                                                         | 功能                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `getName()`                                                  | 返回由此抽象路径名表示的文件或目录的名称；                   |
| `getParent()`                                                | 返回此抽象路径名的父路径名的路径名字符串，如果此路径名没有指定父目录，则返回 `null`； |
| `getParentFile()`                                            | 返回此抽象路径名的父路径名的抽象路径名，如果此路径名没有指定父目录，则返回 `null`； |
| `getPath()`                                                  | 将此抽象路径名转换为一个路径名字符串；                       |
| `isAbsolute()`                                               | 测试此抽象路径名是否为绝对路径名；                           |
| `getAbsolutePath()`                                          | 返回抽象路径名的绝对路径名字符串；                           |
| `canRead()`                                                  | 测试应用程序是否可以读取此抽象路径名表示的文件；             |
| `canWrite()`                                                 | 测试应用程序是否可以修改此抽象路径名表示的文件；             |
| `exists()`                                                   | 测试此抽象路径名表示的文件或目录是否存在；                   |
| `isDirectory()`                                              | 测试此抽象路径名表示的文件是否是一个目录；                   |
| `isFile()`                                                   | 测试此抽象路径名表示的文件是否是一个标准文件；               |
| `lastModified()`                                             | 返回此抽象路径名表示的文件最后一次被修改的时间；             |
| `length()`                                                   | 返回由此抽象路径名表示的文件的长度；                         |
| `createNewFile()`                                            | 当且仅当不存在具有此抽象路径名指定的名称的文件时，原子地创建由此抽象路径名指定的一个新的空文件； |
| `delete()`                                                   | 删除此抽象路径名表示的文件或目录；                           |
| `deleteOnExit()`                                             | 在虚拟机终止时，请求删除此抽象路径名表示的文件或目录；       |
| `list()`                                                     | 返回由此抽象路径名所表示的目录中的文件和目录的名称所组成字符串数组； |
| `list(FilenameFilter filter)`                                | 返回由包含在目录中的文件和目录的名称所组成的字符串数组，这一目录是通过满足指定过滤器的抽象路径名来表示的； |
| `listFiles()`                                                | 返回一个抽象路径名数组，这些路径名表示此抽象路径名所表示目录中的文件； |
| `listFiles(FileFilter filter)`                               | 返回表示此抽象路径名所表示目录中的文件和目录的抽象路径名数组，这些路径名满足特定过滤器； |
| `mkdir()`                                                    | 创建此抽象路径名指定的目录；                                 |
| `mkdirs()`                                                   | 创建此抽象路径名指定的目录，包括创建必需但不存在的父目录；   |
| `renameTo(File dest)`                                        | 重新命名此抽象路径名表示的文件；                             |
| `setLastModified(long time)`                                 | 设置由此抽象路径名所指定的文件或目录的最后一次修改时间；     |
| `setReadOnly()`                                              | 标记此抽象路径名指定的文件或目录，以便只可对其进行读操作；   |
| `createTempFile(String prefix, String suffix, File directory)` | 在指定目录中创建一个新的空文件，使用给定的前缀和后缀字符串生成其名称； |
| `createTempFile(String prefix, String suffix)`               | 在默认临时文件目录中创建一个空文件，使用给定前缀和后缀生成其名称； |
| `compareTo(File pathname)`                                   | 按字母顺序比较两个抽象路径名；                               |
| `compareTo(Object o)`                                        | 按字母顺序比较抽象路径名与给定对象；                         |
| `equals(Object obj)`                                         | 测试此抽象路径名与给定对象是否相等；                         |
| `toString()`                                                 | 返回此抽象路径名的路径名字符串。                             |

## 二、`java.io.RandomAccessFile` 类

`java.io.RandomAccessFile`类用于读写文件数据。其基于指针对文件进行读写。

由于是基于指针，以字节为单位的读写，其效率较低。

创建 `RandomAccessFile`有两种方式：

- 1：`r`：只读模式，仅仅对文件数据进行读取；
- 2：`rw`：读写模式，对文件数据可以编辑。

在计算机中，类似文件、网络端口这些资源，都是由操作系统统一管理的。

应用程序在运行的过程中，如果打开了一个文件进行读写，完成后要及时地关闭，以便让操作系统把资源释放掉，否则，应用程序占用的资源会越来越多，不但白白占用内存，还会影响其他应用程序的运行。

因此，我们需要用`try ... finally`来保证`InputStream`在无论是否发生IO错误的时候都能够正确地关闭。

示例

```java
import java.io.IOException;
import java.io.RandomAccessFile;

public class Demo {
    public static void main(String[] args) throws IOException {
        RandomAccessFile raf = new RandomAccessFile("demo.txt" , "rw");
        try {
            /*
             * void write(int d)
             * 写入1个字节，写出的是该整数d对应的2进制中的低八位(一个字节8个位)
             * 00000001
             */
            int a = 1;
            raf.write(a);   //硬盘中存的是二进制   如果文件已经存在，在首次运行时覆盖原有内容，后面的不覆盖
            a = 98;
            raf.write(a);
            System.out.println("写入硬盘完毕");
        } finally {
            // 读写完毕后，关闭；防止内存泄漏
            raf.close();
        }
    }
}
```

用`try ... finally`来编写上述代码会感觉比较复杂，更好的写法是利用Java 7引入的新的`try(resource)`的语法，只需要编写`try`语句，让编译器自动为我们关闭资源。

示例

```java
import java.io.IOException;
import java.io.RandomAccessFile;

public class Demo {
    public static void main(String[] args) throws IOException {
        try (RandomAccessFile raf = new RandomAccessFile("demo.txt" , "rw")) {
            int a = 1;
            raf.write(a);   
            a = 98;
            raf.write(a);
            System.out.println("写入硬盘完毕");
        }
    }
}
```

### 常用方法

| 方法                                   | 功能                                                         |
| -------------------------------------- | ------------------------------------------------------------ |
| `close()`                              | 关闭此随机访问文件流并释放与该流关联的所有系统资源           |
| `getChannel()`                         | 返回与此文件关联的唯一`FileChannel`对象，NIO用到             |
| `getFilePointer()`                     | 返回此文件中的当前偏移量                                     |
| `length()`                             | 返回此文件的长度                                             |
| `read()`                               | 从此文件中读取一个数据字节                                   |
| `read(byte[] b)`                       | 将最多 b.length 个数据字节从此文件读入byte数组，返回读入的总字节数，如果由于已经达到文件末尾而不再有数据，则返回-1。在至少一个输入字节可用前，此方法一直阻塞 |
| `read(byte[] b, int off, int length)`  | 将最多 length 个数据字节从此文件的指定初始偏移量off读入byte数组 |
| `readBoolean()`                        | 从此文件读取一个boolean，与 readByte()、readChar()、readDouble()等类似 |
| `readLine()`                           | 从此文件读取文本的下一行                                     |
| `seek(long pos)`                       | 重要，设置到此文件开头测量到的文件指针偏移量，在该位置发生下一个读取或写入操作 |
| `skipBytes(int n)`                     | 重要，尝试跳过输入的n个字节以丢弃跳过的字节，返回跳过的字节数 |
| `write(byte[] b)`                      | 将 b.length 个字节从指定byte数组写入到此文件中               |
| `write(byte[] b, int off, int length)` | 将 length 个字节从指定byte数组写入到此文件，并从偏移量off处开始 |
| `write(int b)`                         | 向此文件写入指定的字节                                       |
| `writeBoolean(boolean v)`              | 按单字节值将boolean写入该文件，与 writeByte(int v)、writeBytes(String s)、writeChar(int v)等方法类似 |

## 三、`java.io.FileInputStream`和`java.io.FileOutputStream`

输入流都有一个抽象父类：`java.io.InputStream`，他是所有字节输入流的父类。`FileInputStream`是`InputStream`的子类，是文件字节输入流，是一个低级流（节点流），其使用方式和`RandomAccessFile`一致。**`InputStream`及其子类只负责读文件，不负责写文件**。

输出流都有一个抽象父类：`java.io.OutputStream`，他是所有字节输出流的父类。`FileOutputStream`是`OutputStream`的子类，是文件字节输出流，是一个低级流（节点流），其使用方式和`RandomAccessFile`一致。**`OutputStream`及其子类只负责写文件，不负责读文件**。

```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Demo {
    public static void main(String[] args) throws IOException {
        try (FileInputStream fis = new FileInputStream("demo.txt");  // 输入文件
             FileOutputStream fos = new FileOutputStream("demo-copy.txt" , true)) {  // 输出文件
            byte[] data = new byte[100];
            int len = fis.read(data);  // 读取输入文件
            String inputData = new String(data , 0 , len);
            System.out.println(inputData);
            String outData = inputData + "-copy";
            fos.write(outData.getBytes());  // 输出至文件
        }
    }
}
```

### 常用方法

| **序号**          | **方法及描述**                                               | 所属对象           |
| :---------------- | :----------------------------------------------------------- | ------------------ |
| `close()`         | 关闭此文件输入流并释放与此流有关的所有系统资源。抛出`IOException`异常。 | 通用               |
| `finalize()`      | 这个方法清除与该文件的连接。确保在不再引用文件输入流时调用其 close 方法。抛出`IOException`异常。 | 通用               |
| `read(int r)`     | 这个方法从 `InputStream` 对象读取指定字节的数据。返回为整数值。返回下一字节数据，如果已经到结尾则返回 -1。 | `FileInputStream`  |
| `read(byte[] r)`  | 这个方法从输入流读取`r.length`长度的字节。返回读取的字节数。如果是文件结尾则返回-1。 | `FileInputStream`  |
| `available()`     | 返回下一次对此输入流调用的方法可以不受阻塞地从此输入流读取的字节数。返回一个整数值。 | `FileInputStream`  |
| `write(int w)`    | 这个方法把指定的字节写到输出流中。                           | `FileOutputStream` |
| `write(byte[] w)` | 把指定数组中 `w.length` 长度的字节写到`OutputStream`中。     | `FileOutputStream` |

## 四、`java.io.BufferedInputStream`和`java.io.BufferedOutputStream`

`BufferedInputStream`和`BufferedOutputStream`是一对缓冲流，属于高级流（处理流），用于处理低级流（节点流）的数据，使用它们可以提高读写的效率（先将数据写入缓冲区，在写入硬盘，减少了读写次数）。缓冲流单独存在没意义，必须和低级流一起使用。

### 文件复制

```java
import java.io.*;

public class Demo {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("demo.txt");       //低级输入流
        BufferedInputStream bis = new BufferedInputStream(fis);     //将低级输入流接到高级输入流上

        FileOutputStream fos = new FileOutputStream("demo-copy.txt");   //低级输出流
        BufferedOutputStream bos = new BufferedOutputStream(fos);    //将低级输出流接到高级输出流上​
        try {
            int len = -1;
            /*
             * 缓冲流内部维护了一个缓冲区，当我们调用下面的read（）方法读取一个字节时，
             * 实际上缓冲流会让FileInputStream读取一组字节并存入到缓冲流自身内部的字节数组中，然后将第一个字节返回。
             * 当我们再次调用read()方法读取一个字节时，缓冲流会直接将数组中的第二个字节返回，以此类推，直到该数组中所有字节都被读取
             * 过后才会再次读取一组字节。所以实际上还是通过提高每次读取数据的数量减少读取的次数来提高读取效率。
             */
            while((len = bis.read()) != -1){
                /*
                 * 缓冲输出流也是类似的
                 */
                bos.write(len);
            }
            System.out.println("复制完成");
        } finally {
            bis.close();  //只需要关高级流（内部会先关闭低级流）
            bos.close();
        }
        
    }
}
```

### 手动将缓存中的数据刷到磁盘

```java
import java.io.*;

public class Demo {
    public static void main(String[] args) throws IOException {
        FileOutputStream fos = new FileOutputStream("demo.txt");
        try (BufferedOutputStream bos = new BufferedOutputStream(fos)) {
            /*
             * 通过缓冲输出流写出的字节不会立即被写入硬盘，会先存在内存的字节数组，直到该数组满了，才会一次性写出所有的数据。
             * 这样做等同于提高了一次性的写入数据量，减少了写的次数，提高效率
             */
            bos.write("手动将缓存中的数据刷到磁盘".getBytes());   //不会及时写入硬盘，在内存中。如果不加colse()，最终被GC干掉，不会写入文件
            /*
             * flush方法强制将缓冲区的数据一次性输出。提高了及时性，但是频繁操作会降低操作效率。
             */
            bos.flush();//强制及时写入内存，不会等到缓冲区满。 执行次数越多，效率越低
            System.out.println("完成");
        }
    }
}
```

## 五、`java.io.ObjectInputStream`和`java.io.ObjectOutputStream`

`ObjectInputStream`和`ObjectOutputStream`是一对对象流，属于高级流，`ObjectInputStream`可以读取一组字节转化为 Java 对象，而`ObjectOutputStream`的作用是可以直接将 Java 中的一个对象转化为一组字节后输出。这其实就是 Java 对象的序列化和反序列化，因此Java 对象必须要实现序列化接口。

### 1. 定义一个对象

```java
class Person implements Serializable{
    /**
     * 1.实现Serializable接口。该接口中没有方法，不需要重写方法，这样的接口也叫签名接口。
     *
     * 2.需要有serialVersionUID,序列化的版本号（影响反序列化能否成功）。
     * 当一个类实现了Serializable接口后，该类会有一个常量表示这个类的版本号，版本号影响这个对象反序列化的结果。
     * 不显式定义serialVersionUID，会默认随机产生一个（根据类的结构由算法产生的，类只要改过，随机产生的就会变化）
     * 建议自行维护版本号（自定义该常量并给定值）。若不指定，编译器会根据当前类的结构产生一个版本号，类的结构不变则版本号不变，但是结构变了（属性类型、名字变化等），都会导致版本号改变。
     * 序列化时，这个版本号会存入到文件中。
     * 反序列化对象时，会检查该对象的版本号与当前类现在的版本号是否一致，一致则可以还原，不一致则反序列化失败。
     * 版本号一致时，就算反序列化的对象与当前类的结构有出入，也会采取兼容模式，即：任然有的属性就进行还原，没有的属性则被忽略。
     */
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;
    /*
     * 3.transient关键字的作用是修饰一个属性。那么当这个类的实例进行序列化时，该属性不会被包含在序列化后的字节中，从而达到了“瘦身”的目的
     * 反序列化后是该类型的默认值。引用类型默认是null,其他类型默认是0。如果是静态变量，则映射为内存中的该变量的值。
     */
    private transient List<String> otherInfo;

    public void setName(String 诸葛小猿) {
    }

    public void setAge(int i) {
    }

    public void setOtherInfo(List<String> otherInfo) {
    }
}
```

### 2. 对象序列化

```java
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        Person p = new Person();
        p.setName("ObjectOutputStream");
        p.setAge(30);
        List<String> otherInfo = new ArrayList<String>();
        otherInfo.add("对象序列化");
        p.setOtherInfo(otherInfo);
        System.out.println(p);
        FileOutputStream fos = new FileOutputStream("demo.obj");
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        /*
         * ObjectOutputStream的writeObject方法的作用：将给定的java对象转换为一组字节后写到硬盘上，
         * 这里由于ObjectOutputStream是装在FileOutputStream上的,所以转换的这组字节最终通过FOS写入到文件中。
         *
         * 若希望该对象可以被写出，那么前提是该对象所属的类必须实现Serializable接口
         * 实际数据写入文件的信息比对象本身信息多，因为保存了对象的结构信息
         *
         * 该方法涉及到两个操作：
         * 1：将对象转换为一组字节（称为：对象序列化（编码））
         * 2：将该字节写入到文件中（硬盘上）（称为：数据持久化）
         */
        oos.writeObject(p);

        System.out.println("成功");
        oos.close();
    }
}
```

### 3. 对象反序列化

```java
import java.io.*;
import java.util.List;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream("demo.obj");
        ObjectInputStream ois = new ObjectInputStream(fis);
        /*
         * 将一组字节还原为对象的过程称为:对象的反序列化
         *
         * 反序列化时，demo.obj文件中的serialVersionUID要和Person类中的serialVersionUID一致才能成功
         *
         * readObject() 返回的是Object
         */
        Person p = (Person) ois.readObject();
        System.out.println(p);
        ois.close();
    }
}
```

## 六、`java.io.InputStreamReader`和`java.io.OutputStreamWriter`

Java 根据读写数据单位不同，将流分为：字节流与字符流。

字节流的最小读写单位是一个字节，前面介绍的`InputStream`和`OutputStream`都属于这一类。

字符流的最小读写单位是一个字符，字符流虽然是以字符为单位读写数据，其底层实际上还是要以字节的形式读写，所以字符流天生就具备将字节转换为字符或字符转换成字节的能力，所以所有的字符流都是高级流，方便我们读写字符数据，无需再关心字符与字节的相互转换。字符流的父类`java.io.Reader`和`java.io.Writer`，他们是以char为单位读写，转换为Unicode，他们规定了字符流的基本方法。这里介绍两个常用的字符流`java.io.InputStreamReader`和`java.io.OutputStreamWriter`的使用。字符是高级流，也需要和低级流联合使用。

除了`InputStreamReader`与`OutputStreamWriter`之外的字符流，大部分都只处理其他字符流。但是低级流都是字节流，这时若希望用一个字符流来处理一个字节流就会产生冲突。所以可以通过创建`InputStreamReader`与`OutputStreamWriter`来处理字节流，而`InputStreamReader`与`OutputStreamWriter`本身是字符流，所以可以使得其他字符流得以处理该流。这样，`InputStreamReader`与`OutputStreamWriter`相当于联系字节流和字符流的纽带，类似转化器的效果，因此这两个流也叫转换流。

### 1. `OutputStreamWriter`写文件

```java
import java.io.*;
import java.nio.charset.StandardCharsets;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileOutputStream fos = new FileOutputStream("demo.txt");
        try (OutputStreamWriter osw = new OutputStreamWriter(fos , StandardCharsets.UTF_8)) {
            /*
             * OutputStreamWriter的常用构造方法：
             * 1.OutputStreamWriter(OutputStream out)
             *
             * 2.OutputStreamWriter(outputStream out, String csn)
             * 将给定的字节输出流转换为字节流的同时，指定通过当前字符流写出的字符数据以何种字符集转换为字节。
             */
 
            osw.write("OutputStreamWriter");
            osw.write("写文件");
 
            char[] buf = "Hello World!".toCharArray();
            osw.write(buf , 0 , buf.length);
 
            System.out.println("成功");
        }
    }
}
```

### 2. `InputStreamReader`读文件

```java
import java.io.*;
import java.nio.charset.StandardCharsets;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream("demo.txt");
        /*
         * 也可以使用一个参数的构造，不加字符集
         */
        InputStreamReader isr = new InputStreamReader(fis, StandardCharsets.UTF_8);
        int len = -1;

        /*
         * int read();
         * 一次读取一个字符，返回一个该字符编码的int值，若返回值为-1则表示读到末尾
         */
        while((len = isr.read()) != -1){
            // 强转，取低16位
            char d = (char) len;
            System.out.print(d);
        }
    }
}

```

## 七、`java.io.BufferedReader`和`java.io.BufferedWriter`

`BufferedWriter` 和`BufferedRead`是缓冲字节流，属于高级流，按行读取字符串。由于这两个字符流不能直接处理字节流，所以需要`InputStreamReader`和`OutputStreamWriter`这两个转换流做纽带，将低级字节流和`BufferedReader`、`BufferedWriter`关联起来。

虽然这两个流读写的速度快，但是没有太多的方法可以使用，所有使用的较少。下面只测试一下`java.io.BUfferedReader`。

```java
import java.io.*;
import java.nio.charset.StandardCharsets;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream("demo.txt");

        //转换流InputStreamReader可以指定字符集
        BufferedReader br = new BufferedReader(new InputStreamReader(fis, StandardCharsets.UTF_8));

        /*
         * String readLine()
         * 连续读取若干字符，直到遇到换行符为止，将换行符之前的所有字符以一个字符串返回（不包括换行符）
         * 若该方法返回值为null，则表示读取到了末尾（如果一行为空，返回空串“”）
         * 注意，返回的字符串不包含最后的换行符
         */
        String line = null;
        while((line = br.readLine()) != null){
            //line中不包含\n
            System.out.println(line);
        }
        br.close();
    }
}
```

## 八、`java.io.PrintWriter`

​	缓冲字节流 `java.io.PrintWriter`，是一种比较常用的输出流。其内部维护了一个缓冲区（字节数组），按行写字符串，写字符效率高。内部自动处理`BufferedWriter`来完成缓冲操作， 并且`PrintWriter`具有自动行刷新功能。

### 1. `PrintWriter`写文件

```java
import java.io.*;
import java.nio.charset.StandardCharsets;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        /**
         * PrintWriter提供了丰富的构造方法
         * 其中提供了可以针对文件写出操作的构造方法：
         * PrintWriter(String path)
         * PrintWriter(File file)
         * 是个高级流，不用对接低级流，源码已经使用了低级流，可以不加字符集
         */
        try (PrintWriter pw = new PrintWriter("demo.txt" , "utf-8")) {
            pw.println("`PrintWriter`写文件");

            System.out.println("finished!");
        }
        // 最终的文件大小大于所有的字符之和，因为有换行符
    }
}
```

### 2. `PrintWriter`处理其他流

```java
import java.io.*;
import java.nio.charset.StandardCharsets;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileOutputStream fos = new FileOutputStream("demo.txt");

        /*
         * PrintWriter构造传入字节流，不能指定字符集: PrintWriter pw = new PrintWriter(fos);
         * 若希望指定字符集，需要在中间使用转换流OutputStreamWriter
         */
        OutputStreamWriter osw =  new OutputStreamWriter(fos, StandardCharsets.UTF_8);
        try (PrintWriter pw = new PrintWriter(osw)) {
            pw.println("PrintWriter处理其他流");
            System.out.println("成功");
        }
    }
}
```

### 3. `PrintWriter`自动行刷新

```java
import java.io.*;
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        //true是自动刷新，可以只用一个参数
        try (PrintWriter pw = new PrintWriter(new OutputStreamWriter(new FileOutputStream("demo.txt")) , true)) {
            System.out.println("请输入文件内容:");
            Scanner sc = new Scanner(System.in);

            while (true) {
                String str = sc.nextLine();
                if ("exit".equals(str)) {
                    System.out.println("结束");
                    break;
                }

                //具有自动行刷新的pw在使用println方法是会自动flush
                pw.println(str);
            }
        }
    }
}
```

