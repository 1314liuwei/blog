# 通过 Go 学习 TDD

## 一、了解 TDD

> TDD （**Test Driven Development**）是敏捷开发中的一项核心实践和技术，也是一种设计方法论。
>
> TDD的核心思想是在开发功能代码之前，先编写单元测试用例代码，测试代码确定需要编写什么产品代码。

### TDD 工作流程

- 先分解任务，分离关注点（后面有演示），用实例化需求，澄清需求细节
- 只关注需求，程序的输入输出，不关心中间过程，写测试
- 用最简单的方式满足当前这个小需求即可
- 重构，提高代码健壮性
- 再次测试，补重用例，修复 Bug
- 提交

流程如图所示：

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/TDD.jpg)

### TDD 的三条规则

1. 除非是为了使一个失败的 unit test 通过，否则不允许编写任何产品代码
2. 在一个单元测试中，只允许编写刚好能够导致失败的内容（编译错误也算失败）
3. 只允许编写刚好能够使一个失败的 unit test 通过的产品代码

### TDD 的难点

TDD 说起来十分简单，但是在落地的时候很多团队都失败了。TDD 的主要难点在以下方面：

- **不会合理拆分需求**
- **不会写有效的单元测试**
- **不会写刚好的实现**
- **不会重构**

想要最大化利用好 TDD 开发的优势，那么就必须解决好上诉问题。

## 二、Go 的 Test 入门使用

Go 语言推荐测试文件和源代码文件放在一块，测试文件以 `_test.go` 结尾。比如，当前 package 有 `calc.go` 一个文件，我们想测试 `calc.go` 中的 `Add` 和 `Mul` 函数，那么应该新建 `calc_test.go` 作为测试文件。

```
example/
   |--calc.go
   |--calc_test.go
```

假使`calc.go` 的代码如下：

```go
package main

func Add(a int, b int) int {
    return a + b
}

func Mul(a int, b int) int {
    return a * b
}
```

那么测试代码 `calc_test.go`可以书写如下代码：

```go
package examples

import "testing"


// 测试用例名称一般命名为 Test 加上待测试的方法名
// 测试用的参数有且只有一个，在这里是 t *testing.T
func TestAdd(t *testing.T) {
	if ans := Add(1, 2); ans != 3 {
		t.Errorf("1 + 2 expected be 3, but %d got", ans)
	}

	if ans := Add(-10, -20); ans != -30 {
		t.Errorf("-10 + -20 expected be -30, but %d got", ans)
	}
}


func TestMul(t *testing.T) {
	if ans := Mul(1, 2); ans != 2 {
		t.Errorf("1 * 2 expected be 2, but %d got", ans)
	}

	if ans := Mul(-10, -20); ans != 200 {
		t.Errorf("-10 * -20 expected be 200, but %d got", ans)
	}
}
```

然后在命令行执行 `go test`：

```
➜  examples go test
PASS
ok      examples        0.100s
```

Tops：在 `go test`后面加`-v`可以会显示每个用例的测试结果；加`-cover`可以查看覆盖率！

## 三、TDD 开发示例

> 任务：统计字符串中各个字母出现的次数
>
> 为了简化任务，我们规定字符串中只有小写字母
>
> 
>
> 目标输入1：abcdaaf
>
> 目标输出1：a=3;b=1;c=1;d=1;f=1;
>
> 
>
> 目标输入2：aabbccdd
>
> 目标输出2：a=2;b=2;c=2;d=2;

### 1. 需求拆分

由于任务需求比较简单，我们可以不进行拆分。

### 2. 编写测试代码

根据需求我们可以编写测试代码：

```go
package examples

import (
	"reflect"
	"testing"
)

func TestCount(t *testing.T) {
	cases := []struct {
		input, except string
	}{
		{"abcdaaf", "a=3;b=1;c=1;d=1;f=1;"},
		{"aabbccdd", "a=2;b=2;c=2;d=2;"},
	}

	for _, c := range cases {
		t.Run(c.input, func(t *testing.T) {
			if output := Count(c.input); !reflect.DeepEqual(output, c.except) {
				t.Fatalf("'%s' expected '%s', but '%s' got",
					c.input, c.except, output)
			}
		})
	}
}
```

### 3. 运行测试得到失败的结果

由于没有定义 Count 函数，因此此时运行测试会报错，运行测试结果如下：

```
➜  examples go test
# examples [examples.test]
.\char_count_test.go:18:17: undefined: Count
FAIL    examples [build failed]
```

### 4. 编写可以编译的实现

严格遵守 TDD 方法的步骤与原则，现在只需让代码可编译，这样你就可以检查测试用例能否通过。
在 `char_count.go` 文件下编写代码如下：

```go
package examples

func Count(input string) string {
	return ""
}
```

### 5. 运行测试得到失败的结果

在此已经定义了 Count 函数，接下来就可以进一步执行测试代码里面的具体内容，但是运行测试的结果也会错误，这是因为 Count 函数定义的问题。运行测试结果如下：

```
➜  examples go test
--- FAIL: TestCount (0.00s)
    --- FAIL: TestCount/abcdaaf (0.00s)
        char_count_test.go:19: 'abcdaaf' expected 'a=3;b=1;c=1;d=1;f=1;', but '' got
    --- FAIL: TestCount/aabbccdd (0.00s)
        char_count_test.go:19: 'aabbccdd' expected 'a=2;b=2;c=2;d=2;', but '' got
FAIL
exit status 1
FAIL    examples        0.101s
```

### 6. 编写可以通过测试的实现

```go
package examples

import "fmt"

func Count(input string) string {
	count := make([]int, 26)

	for _, v := range input {
		count[v-96]++
	}

	output := ""
	for i, v := range count {
		if v != 0 {
			output += fmt.Sprintf("%s=%d;", string(rune(i+96)), v)
		}
	}
	return output
}
```

### 7. 运行测试得到成功的结果

```
➜  examples go test
PASS
ok      examples        0.103s
```

### 8. 重构

虽然代码已经通过了测试，但是其代码的规范性和简洁性还是存在很多问题，所以需要我们对代码进行重构。

重构代码要求在不改变代码的逻辑和功能的前提下，尽可能的简化代码。简化的目的有增强代码的可读性、加快代码的执行速度等等。

常见的简化方法就是重用代码（将频繁使用的变量、常量以及函数另外定义出来，这样就可以在各个地方调用此变量、常量、函数即可）。

重构后的代码如下所示：

```go
package examples

import "fmt"

func Count(input string) string {
	count := make([]int, 26)

	for _, v := range input {
		count[v-'a']++
	}

	output := ""
	for i, v := range count {
		if v != 0 {
			output += fmt.Sprintf("%s=%d;", string(rune(i+'a')), v)
		}
	}
	return output
}
```

### 9. 基准测试（benchmarks）

基于TDD周期具体完成“迭代”章节的例子之后，还可以在此基础上编写基准测试。

在 Go 中编写基准测试（benchmarks）是该语言的另一个一级特性，它与在TDD中的编写测试步骤非常相似。

基准测试代码如下：

```go
func BenchmarkCount(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Count("abcdaaf")
	}
}
```

基准测试运行时，代码会运行 b.N 次，并测量需要多长时间。代码运行的次数不会对你产生影响，测试框架会选择一个它所认为的最佳值，以便让你获得更合理的结果。

编写完测试代码后，用 `go test -bench=.`命令进行测试：

```
➜  examples go test -bench=.
goos: windows
goarch: amd64
pkg: examples
cpu: Intel(R) Core(TM) i5-7300HQ CPU @ 2.50GHz
BenchmarkCount-4          799131              1272 ns/op
PASS
ok      examples        1.136s
```



