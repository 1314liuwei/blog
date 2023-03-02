# Java学习之路——集合

## 概述

### 集合的定义

什么是集合（Collection）？集合就是“由若干个确定的元素所构成的整体”。

从概念上来看集合和数组是十分相似的，那么为什么有了数组还要集合呢？

- 数组初始化后大小不可变；
- 数组只能按索引顺序存取；
- ......

正因为数组有着上述的缺点，因此在 Java 中又提供了集合来让我们使用。

### 集合的种类及特点

Java标准库自带的`java.util`包提供了集合类：`Collection`，它是除`Map`外所有其他集合类的根接口。Java 的`java.util`包主要提供了以下三种类型的集合：

- `List`：一种有序列表的集合；
- `Set`：一种保证没有重复元素的集合；
- `Map`：一种通过键值（key-value）查找的映射表集合。

Java 集合有以下特点：

- 接口和实现类相分离；
- 二是支持泛型，我们可以限制在一个集合中只能放入同一种数据类型的元素。

Java 访问集合是通过统一的方式——迭代器（Iterator）来实现，有了它我们就可以只关心上层使用而不用关心下层的集合类型。

## 一、`Collection`接口常用方法

### 1. 添加元素

- `add(int index，E element)`：向集合中添加一项；

  - `index`（可选参数）- 表示元素所插入处的索引值；

  - `element` - 要插入的元素；

  - 返回值：如果成功插入元素，返回 true；

    如果 index 超出范围，则该 add() 方法抛出 `IndexOutOfBoundsException` 异常。

- `addAll(int index, Collection c)`：

  - `index`（可选参数）- 表示元素所插入处的索引值；

  - c - 要插入的集合元素；

  - 返回值：如果成功插入元素，返回 true；

    如果给定的集合为 null，则超出 `NullPointerException` 异常；

    如果 index 超出范围，则该 add() 方法抛出 `IndexOutOfBoundsException` 异常。

### 2. 获取有效元素个数

- `size()`：返回数组中元素的个数。
  - 返回值：返回数组中元素的个数。

### 3. 清空集合

- `clear()`：删除动态集合中的所有元素。

### 4. 是否为空集

- `isEmpty()`：判断集合是否为空。

  - 返回值：如果数组中不存在任何元素，则返回 true；

    如果数组中存在元素，则返回 false。

### 5. 是否包含某个元素

- `contains(Object obj)`：用于判断元素是否在集合中；

  - `obj` - 要检测的元素；

  - 返回值：如果指定的元素存在于动态数组中，则返回 true；

    如果指定的元素不存在于动态数组中，则返回 false。

- `containsAll(Collection c)`：检测集合是否包含指定集合中的所有元素。

  - `collection` - 集合参数；
  - 返回值：如果动态数组中包含的集合中的所有元素，则返回 true；
  - 如果集合中存在的元素与指定 `Collection` 中的元素不兼容，则抛出 `ClassCastException`；
  - 如果 collection 中包含 null 元素，并且集合中不允许 null值，则抛出 `NullPointerException` 异常。

### 6. 删除元素

- `remove(Object obj / int index)`：删除集合里的单个元素；

  - obj - 要删除的元素，如果 obj 元素出现多次，则删除在数组中第一次出现的元素；

  - index - 要删除元素索引值；

  - 返回值：如果传入元素，删除成功，则返回 true；

    如果传入索引值，则返回删除的元素；

    如果指定的索引超出范围，则该方法将抛出 `IndexOutOfBoundsException` 异常。

- `removeAll(Collection c)`：删除存在于指定集合中的动态数组元素。

  - c - 动态数组列表中要删除的元素集合；

  - 返回值：如果从集合成功删除元素返回 true；

    如果集合中存在的元素类与指定 `Collection` 的元素类不兼容，则抛出 `ClassCastException` 异常；

    如果集合中包含 null 元素，并且指定 `Collection` 不允许 null 元素，则抛出 `NullPointerException` 异常。

### 7. 求交集

- `retainAll(Collection c)`：保留 `ArrayList`中在指定集合中也存在的那些元素。

  - collection - 集合参数；

  - 返回值：如果集合中删除了元素则返回 true；

    如果集合中存在的元素与指定 `Collection` 的类中元素不兼容，则抛出 `ClassCastException` 异常；

    如果集合包含 null 元素，并且指定 `Collection` 不允许 null 元素，则抛出 `NullPointerException`。

### 8. 判断集合是否相等

- `eauqls(Collection c)`：判断两个集合是否相等。
  - collection - 集合参数；
  - 返回值：如果两个集合相等则返回 true。

### 9. 转换成数组

- `toArray(T[] arr)`：将集合对象转换为数组。

  - T [] arr（可选参数）- 用于存储数组元素的数组；

  - 返回值：如果参数 T[] arr 作为参数传入到方法，则返回 T 类型的数组；

    如果未传入参数，则返回 Object 类型的数组。

### 10. 获取集合对象的哈希值

- `hashCode()`：返回集合哈希值。

### 11. 遍历集合

- `iterator()`：返回 `Iterator` 接口的实例，用于遍历集合。

## 二、使用 `Iterator` 接口遍历集合

在 Java 程序中，`Iterator`（迭代器）不是一个集合，它是一种用于访问集合的方法。

GoF 对迭代器的定义为：提供一种方法访问一个容器（container）对象中的各个元素，而又不需要暴露该对象的内部细节。

### 1. 迭代器常用方法

- `next()`：返回迭代器的下一个元素，并且更新迭代器的状态；
- `hasNext()`：用于检测集合中是否还有元素。有则 true，没有则 false；
- `remove()`：将迭代器返回的元素删除。

### 2. 获取一个迭代器

想要使用迭代器对象遍历集合，那么首先就需要获取一个迭代器。可以调用集合的 `iterator()` 方法获取一个迭代器。

```java
// 创建集合
Collection collection = new ArrayList();

// 添加元素
collection.add(123);
collection.add("123");
collection.add(123L);
collection.add('A');

Iterator iterator = collection.iterator();
```

### 3. 遍历集合

使用迭代器遍历集合实质上就是不断调用 `next()` 方法的过程。当集合中的元素都已经遍历完后，此时再调用 `next()` 方法就会抛出 `NoSuchElementException`错误。

因此推介使用如下方式进行遍历：

```java
while (iterator.hasNext()) {
	System.out.println(iterator.next());
}
```

## 三、常用集合类

以下是我们日常开发中，使用较多的四种集合：

- `LinkedList`：该类实现了`List`接口，允许有 null（空）元素。主要用于创建链表数据结构，该类没有同步方法，如果多个线程同时访问一个`List`，则必须自己实现访问同步，解决方法就是在创建`List`时候构造一个同步的`List`；
- `ArrayList`：该类也是实现了`List`的接口，实现了可变大小的数组，随机访问和遍历元素时，提供更好的性能。该类也是非同步的，在多线程的情况下不要使用。其插入删除效率低；
- `HashSet`：该类实现了`Set`接口，不允许出现重复元素，不保证集合中元素的顺序，允许包含值为null的元素，但最多只能一个；
- `HashMap`：`HashMap` 是一个散列表，它存储的内容是键值对(key-value)映射。该类实现了`Map`接口，根据键的`HashCode` 值存储数据，具有很快的访问速度，最多允许一条记录的键为null，不支持线程同步。

### 1.  `LinkedList`

#### 示例

```java
import java.util.LinkedList;

public class Demo {
    public static void main(String[] args) {
        LinkedList<String> sites = new LinkedList<String>();
        sites.add("Google");
        sites.add("Runoob");
        sites.add("Taobao");
        sites.add("Weibo");
        System.out.println(sites);  // [Google, Runoob, Taobao, Weibo]
    }
}
```

#### 常用方法

| 方法                                             | 描述                                                         |
| :----------------------------------------------- | :----------------------------------------------------------- |
| `public boolean add(E e)`                        | 链表末尾添加元素，返回是否成功，成功为 true，失败为 false。  |
| `public void add(int index, E element)`          | 向指定位置插入元素。                                         |
| `public boolean addAll(Collection c)`            | 将一个集合的所有元素添加到链表后面，返回是否成功，成功为 true，失败为 false。 |
| `public boolean addAll(int index, Collection c)` | 将一个集合的所有元素添加到链表的指定位置后面，返回是否成功，成功为 true，失败为 false。 |
| `public void addFirst(E e)`                      | 元素添加到头部。                                             |
| `public void addLast(E e)`                       | 元素添加到尾部。                                             |
| `public boolean offer(E e)`                      | 向链表末尾添加元素，返回是否成功，成功为 true，失败为 false。 |
| `public boolean offerFirst(E e)`                 | 头部插入元素，返回是否成功，成功为 true，失败为 false。      |
| `public boolean offerLast(E e)`                  | 尾部插入元素，返回是否成功，成功为 true，失败为 false。      |
| `public void clear()`                            | 清空链表。                                                   |
| `public E removeFirst()`                         | 删除并返回第一个元素。                                       |
| `public E removeLast()`                          | 删除并返回最后一个元素。                                     |
| `public boolean remove(Object o)`                | 删除某一元素，返回是否成功，成功为 true，失败为 false。      |
| `public E remove(int index)`                     | 删除指定位置的元素。                                         |
| `public E poll()`                                | 删除并返回第一个元素。                                       |
| `public E remove()`                              | 删除并返回第一个元素。                                       |
| `public boolean contains(Object o)`              | 判断是否含有某一元素。                                       |
| `public E get(int index)`                        | 返回指定位置的元素。                                         |
| `public E getFirst()`                            | 返回第一个元素。                                             |
| `public E getLast()`                             | 返回最后一个元素。                                           |
| `public int indexOf(Object o)`                   | 查找指定元素从前往后第一次出现的索引。                       |
| `public int lastIndexOf(Object o)`               | 查找指定元素最后一次出现的索引。                             |
| `public E peek()`                                | 返回第一个元素。                                             |
| `public E element()`                             | 返回第一个元素。                                             |
| `public E peekFirst()`                           | 返回头部元素。                                               |
| `public E peekLast()`                            | 返回尾部元素。                                               |
| `public E set(int index, E element)`             | 设置指定位置的元素。                                         |
| `public Object clone()`                          | 克隆该列表。                                                 |
| `public Iterator descendingIterator()`           | 返回倒序迭代器。                                             |
| `public int size()`                              | 返回链表元素个数。                                           |
| `public ListIterator listIterator(int index)`    | 返回从指定位置开始到末尾的迭代器。                           |
| `public Object[] toArray()`                      | 返回一个由链表元素组成的数组。                               |
| `public T[] toArray(T[] a)`                      | 返回一个由链表元素转换类型而成的数组。                       |

### 2. `ArrayList`

#### 示例

```java
import java.util.ArrayList;

public class Demo {
    public static void main(String[] args) {
        ArrayList<String> sites = new ArrayList<String>();
        sites.add("Google");
        sites.add("Runoob");
        sites.add("Taobao");
        sites.add("Weibo");
        System.out.println(sites);  // [Google, Runoob, Taobao, Weibo]
    }
}
```

#### 常用方法

| 方法               | 描述                                           |
| :----------------- | :--------------------------------------------- |
| `add()`            | 将元素插入到指定位置的 `ArrayList`中           |
| `addAll()`         | 添加集合中的所有元素到 `ArrayList`中           |
| `clear()`          | 删除 `ArrayList`中的所有元素                   |
| `clone()`          | 复制一份 `ArrayList`                           |
| `contains()`       | 判断元素是否在 `ArrayList`                     |
| `get()`            | 通过索引值获取 `ArrayList`中的元素             |
| `indexOf()`        | 返回 `ArrayList`中元素的索引值                 |
| `removeAll()`      | 删除存在于指定集合中的 `ArrayList`里的所有元素 |
| `remove()`         | 删除 `ArrayList`里的单个元素                   |
| `size()`           | 返回 `ArrayList`里元素数量                     |
| `isEmpty()`        | 判断 `ArrayList`是否为空                       |
| `subList()`        | 截取部分 `ArrayList`的元素                     |
| `set()`            | 替换 `ArrayList`中指定索引的元素               |
| `sort()`           | 对 `ArrayList`元素进行排序                     |
| `toArray()`        | 将 `ArrayList`转换为数组                       |
| `toString()`       | 将 `ArrayList`转换为字符串                     |
| `ensureCapacity()` | 设置指定容量大小的 `ArrayList`                 |
| `lastIndexOf()`    | 返回指定元素在 `ArrayList`中最后一次出现的位置 |
| `retainAll()`      | 保留 `ArrayList`中在指定集合中也存在的那些元素 |
| `containsAll()`    | 查看 `ArrayList`是否包含指定集合中的所有元素   |
| `trimToSize()`     | 将 `ArrayList`中的容量调整为数组中的元素个数   |
| `removeRange()`    | 删除 `ArrayList`中指定索引之间存在的元素       |
| `replaceAll()`     | 将给定的操作内容替换掉数组中每一个元素         |
| `removeIf()`       | 删除所有满足特定条件的 `ArrayList`元素         |
| `forEach()`        | 遍历 `ArrayList`中每一个元素并执行特定操作     |

### 3. `HashSet`

#### 示例

```java
import java.util.HashSet;

public class Demo {
    public static void main(String[] args) {
        HashSet<String> sites = new HashSet<String>();
        sites.add("Google");
        sites.add("Runoob");
        sites.add("Taobao");
        sites.add("Zhihu");
        sites.add("Runoob");     // 重复的元素不会被添加
        sites.remove("Taobao");  // 删除元素，删除成功返回 true，否则为 false
        System.out.println(sites);  // [Google, Runoob, Zhihu]
    }
}
```

#### 常用方法

| 方法         | 描述               |
| :----------- | :----------------- |
| `add()`      | 添加元素           |
| `remove()`   | 删除元素           |
| `clear()`    | 删除所有元素       |
| `contains()` | 是否包含指定元素   |
| `isEmpty()`  | 判断是否为空       |
| `size()`     | 获取集合中元素个数 |

### 4. `HashMap`

#### 示例

```java
import java.util.HashMap;

public class Demo {
    public static void main(String[] args) {
        // 创建 HashMap 对象 Sites
        HashMap<Integer, String> Sites = new HashMap<Integer, String>();
        // 添加键值对
        Sites.put(1, "Google");
        Sites.put(2, "Runoob");
        Sites.put(3, "Taobao");
        Sites.put(4, "Zhihu");
        System.out.println(Sites);  // {1=Google, 2=Runoob, 3=Taobao, 4=Zhihu}
    }
}
```

#### 常用方法

| 方法                 | 描述                                                         |
| :------------------- | :----------------------------------------------------------- |
| `clear()`            | 删除 `HashMap` 中的所有键/值对                               |
| clone()              | 复制一份 `HashMap`                                           |
| `isEmpty()`          | 判断 `HashMap`是否为空                                       |
| `size()`             | 计算 `HashMap`中键/值对的数量                                |
| `put()`              | 将键/值对添加到 `HashMap`中                                  |
| `putAll()`           | 将所有键/值对添加到 `HashMap`中                              |
| `putIfAbsent()`      | 如果 `HashMap`中不存在指定的键，则将指定的键/值对插入到 `HashMap`中。 |
| `remove()`           | 删除 `HashMap`中指定键 key 的映射关系                        |
| `containsKey()`      | 检查 `HashMap`中是否存在指定的 key 对应的映射关系。          |
| `containsValue()`    | 检查 `HashMap`中是否存在指定的 value 对应的映射关系。        |
| `replace()`          | 替换 `HashMap`中是指定的 key 对应的 value。                  |
| `replaceAll()`       | 将 `HashMap`中的所有映射关系替换成给定的函数所执行的结果。   |
| `get()`              | 获取指定 key 对应对 value                                    |
| `getOrDefault()`     | 获取指定 key 对应对 value，如果找不到 key ，则返回设置的默认值 |
| `forEach()`          | 对 `HashMap`中的每个映射执行指定的操作。                     |
| `entrySet()`         | 返回 `HashMap`中所有映射项的集合集合视图。                   |
| `keySet()`           | 返回 `HashMap`中所有 key 组成的集合视图。                    |
| `values()`           | 返回 `HashMap`中存在的所有 value 值。                        |
| `merge()`            | 添加键值对到 `HashMap`中                                     |
| `compute()`          | 对 `HashMap`中指定 key 的值进行重新计算                      |
| `computeIfAbsent()`  | 对 `HashMap`中指定 key 的值进行重新计算，如果不存在这个 key，则添加到 `HashMap`中 |
| `computeIfPresent()` | 对 `HashMap`中指定 key 的值进行重新计算，前提是该 key 存在于 `HashMap`中。 |