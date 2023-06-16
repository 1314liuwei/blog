# Go 切片的深拷贝和浅拷贝

切片(Slice)的底层数据结构如下所示：

```go
// src/runtime/slice.go
type slice struct {
	array unsafe.Pointer	// 数组指针
	len   int				// 切片长度
	cap   int				// 切片容量
}
```

## 浅拷贝

切片进行浅拷贝时，会 new 一个新的切片结构体，重设切片容量和长度，但是**新切片和老切片指向的底层数组指针为同一个数组指针**。

浅拷贝过程如图所示：

![image-20230616155254072](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/06/16/20230616-155255.png)

因此，**当新切片中对应位置的数据发生改变时，老切片的数据也会发生改变**。

```go
package main

import (
	"fmt"
	"reflect"
	"unsafe"
)

func main() {
	a1 := []int{1, 2, 3, 4, 5, 6}
	fmt.Println(a1, len(a1), cap(a1))	// [1 2 3 4 5 6] 6 6

	a2 := a1[2:4]
	fmt.Println(a2, len(a2), cap(a2))	// [3 4] 2 4

	a2[1] = 888
	fmt.Println(a1, a2)	// [1 2 3 888 5 6] [3 888]

	a1Addr := (*reflect.SliceHeader)(unsafe.Pointer(&a1)).Data
	a2Addr := (*reflect.SliceHeader)(unsafe.Pointer(&a2)).Data
	fmt.Println("切片a1指向的底层数组地址:", a1Addr)	// 切片a1指向的底层数组地址: 824633770848
	fmt.Println("切片a2指向的底层数组地址:", a2Addr)	// 切片a2指向的底层数组地址: 824633770864
	fmt.Println("偏移量:", (a2Addr-a1Addr)/unsafe.Sizeof(int(1)))	// 偏移量: 2
}
```

## 深拷贝

浅拷贝时，切片指向的底层数组指针是相同的，可能会出现新老切片相互影响的问题。当需要两个指向底层数组不同的切片时，就需要深拷贝。

深拷贝时，老切片指向的底层数组也会进行拷贝，因此新老切片的数据是完全隔离的。

```go
package main

import (
	"fmt"
	"reflect"
	"unsafe"
)

func main() {
	a1 := []int{1, 2, 3, 4, 5, 6}
	fmt.Println(a1, len(a1), cap(a1))	// [1 2 3 4 5 6] 6 6

	a2 := make([]int, len(a1))
	copy(a2, a1)
	fmt.Println(a2, len(a2), cap(a2))	// [1 2 3 4 5 6] 6 6

	a2[1] = 888
	fmt.Println(a1, a2)	// [1 2 3 4 5 6] [1 888 3 4 5 6]

	a1Addr := (*reflect.SliceHeader)(unsafe.Pointer(&a1)).Data
	a2Addr := (*reflect.SliceHeader)(unsafe.Pointer(&a2)).Data
	fmt.Println("切片a1指向的底层数组地址:", a1Addr)	// 切片a1指向的底层数组地址: 824633770848
	fmt.Println("切片a2指向的底层数组地址:", a2Addr)	// 切片a2指向的底层数组地址: 824633770944
}
```

