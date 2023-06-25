# Go 学习——文件操作

## 一、读取文件

### 1. 按字节读取

```go
func main() {
	// 打开读取的文件
	file, err := os.Open("testFile")
	// return 之前记得关闭文件
	defer file.Close()
	if err != nil {
		fmt.Println(err)
		return
	}

	// 每次读取的内容缓存
	buf := make([]byte, 1024)
	// 文件的所有内容
	var context []byte
	for {
		// 读取文件内容
		count, err := file.Read(buf)
		// 判断是否读到文件尾部
		if err == io.EOF {
			break
		}
		curByte := buf[:count]
		// 追加内容
		context = append(context, curByte...)
	}
	// 打印文本信息
	fmt.Println(string(context))
}
```

### 2. 使用 ioutil 进行简化

```go
func main() {
	// 打开读取的文件
	file, err := os.Open("testFile")
	// return 之前记得关闭文件
	defer file.Close()
	if err != nil {
		fmt.Println(err)
		return
	}

	context, _ := ioutil.ReadAll(file)
	fmt.Println(string(context))
}
```

```go
func main() {
	context, _ := ioutil.ReadFile("testFile")
	fmt.Println(string(context))
}
```

### 3. 利用 Scanner  逐行读取

```go
func main() {
	file, _ := os.Open("testFile")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	count := 0
	for scanner.Scan() {
		count++
		line := scanner.Text()
		fmt.Printf("%d %s\n", count, line)
	}
}
```

## 二、写入文件

通过给 `os.OpenFile(name string, flag int, perm FileMode)` 指定额外的文件权限和读写方式可以实现对文件的写操作。

flag 有以下常用值：

- `os.O_CREATE: create if none exists` 不存在则创建
- `os.O_RDONLY: read-only` 只读
- `os.O_WRONLY: write-only` 只写
- `os.O_RDWR: read-write` 可读可写
- `os.O_TRUNC: truncate when opened` 文件长度截为0：即清空文件
- `os.O_APPEND: append` 追加新数据到文件

```go
func main() {
	file, _ := os.OpenFile("testFile", os.O_CREATE|os.O_RDWR, 0777)
	defer file.Close()

	// 写入 byte 数据
	data := []byte("Hello World!\n")
	_, err := file.Write(data)
	if err != nil {
		return
	}

	// 写入字符串
	_, err = file.WriteString("Hello World!\n")
	if err != nil {
		return
	}

	// 确保写入到磁盘
	err = file.Sync()
	if err != nil {
		return
	}
}
```

## 三、判断文件是否存在

```go
func main() {
	file := "testFile"
	_, err := os.Stat(file)
	fmt.Println(!os.IsNotExist(err))
}
```

## 四、文件拷贝

```go
func main() {
	srcFile, _ := os.Open("testFile")
	defer srcFile.Close()
	desFile, _ := os.OpenFile("copyFile", os.O_WRONLY|os.O_CREATE, os.ModePerm)
	defer desFile.Close()

	io.Copy(desFile, srcFile)
}
```

## 五、改变程序当前工作目录

```go
func main() {
	fmt.Println(os.Getwd())
	err := os.Chdir("..")
	if err != nil {
		return 
	}
	fmt.Println(os.Getwd())
}
```

