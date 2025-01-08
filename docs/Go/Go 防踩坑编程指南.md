# Go 防踩坑编程指南

> 本指南指在记录自己平时写代码过程中踩过的坑

## 1. 不要使用 `init()` 函数

`init()` 函数是 Go 中提供默认函数，当 `init()` 函数所在模块被加载时，`init()` 函数会自动运行。

但是由于模块加载顺序和 `import` 中的顺序强相关，因此不同模块的 `init()` 函数执行顺序会不可控。当模块之间存在依赖时，`init()` 函数很大概率会由于执行顺序出现问题而造成出人意料的 Bug（特别是启用了`go fmt`功能！）。

因此在日常开发中不到万不得已不要使用 `init()` 函数，初始化逻辑直接显示调用。

 

## 2. 全局变量显示初始化

复杂的全局变量初始化时，应当显示进行初始化。原因和 `1. 不要使用 init() 函数` 类似。因为全局变量初始化顺序和模块加载顺序强相关。当全局变量初始化逻辑存在依赖时，可能会由于模块加载顺序改变而产生出人意料的 Bug。



## 3. 判断接口类型是否为 `nil`

在 Go 中，当对象值为空，但是接口类型不为空时，如果直接判断 `v != nil` 会返回 `true`。

在下面的代码中，`u != nil` 会判断为空，因为 `u` 的值虽然为 `nil`，但是 `u` 的类型为 `UserI`。

```go
package main

type UserI interface {
	String() string
}

type User struct {
	Id string
}

func (u *User) String() string {
	return u.Id
}

func GetUser() UserI {
	var u *User
	return u
}

func main() {
	u := GetUser()
	if u != nil {
		u.String()
	}
}
```

因此为了避免这种问题的出现，需要使用反射做更严格的判断：

```go
package main

import (
	"reflect"
)

type UserI interface {
	String() string
}

type User struct {
	Id string
}

func (u *User) String() string {
	return u.Id
}

func GetUser() UserI {
	var u *User
	return u
}

func IsNilPointer(i interface{}) bool {
	if i == nil {
		return true
	}
	v := reflect.ValueOf(i)
	return (v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface) && v.IsNil()
}

func main() {
	u := GetUser()
	if !IsNilPointer(u) {
		u.String()
	}
}
```

## 4. 考虑 data race

运行程序时，统一添加参数 `-race` 来检测是否存在 Data Race，防止后面的并发执行过程中出现问题。