# Go 检查结构体是否实现接口

## 编译时检查

```go
var _ MyInterface = new(MyStruct)
```

## 运行时检查

```go
var _ MyInterface = (*MyStruct)(nil)
```

