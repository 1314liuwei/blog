# SingleFlight 解析

> "golang.org/x/sync/singleflight" 是一个 Go 官方提供的用于并发控制包。

## 使用场景

当需要去执行多次幂等操作时，就可以使用 SingleFlight 来进行优化。SingleFlight 会让多次操作合并为一次操作，避免频繁请求函数。

## 原理分析

源码：https://cs.opensource.google/go/x/sync/+/master:singleflight/singleflight.go

### 结构体

先看一下在 `singleflight.go` 中存在哪些结构体：

```go
// 函数执行过程中的堆栈错误信息
type panicError struct {
	value interface{}
	stack []byte
}

// 函数调用信息
type call struct {
	wg sync.WaitGroup
    // 函数返回值信息
	val interface{}
    // 函数返回错误
	err error
    // 记录这个 key 被分享了多少次
	dups  int
    // 返回值 channel，DoChan需要使用
	chans []chan<- Result
}

type Group struct {
	mu sync.Mutex    
    // 每次调用都会添加到 m 中，m 是懒加载的
	m  map[string]*call
}

// 函数返回值信息，DoChan使用
type Result struct {
	Val    interface{}
	Err    error
	Shared bool
}
```

### 方法

```go
func (g *Group) Do(key string, fn func() (interface{}, error)) (v interface{}, err error, shared bool) {
	g.mu.Lock()
    // 懒加载 m
	if g.m == nil {
		g.m = make(map[string]*call)
	}
    
    // 判断函数是否已经被调用过
	if c, ok := g.m[key]; ok {
		c.dups++
		g.mu.Unlock()
        // 调用过的话则等待函数执行完毕
		c.wg.Wait()

		if e, ok := c.err.(*panicError); ok {
			panic(e)
		} else if c.err == errGoexit {
			runtime.Goexit()
		}
		return c.val, c.err, true
	}
	c := new(call)
	c.wg.Add(1)
    // 将函数调用加入 map
	g.m[key] = c
	g.mu.Unlock()

    // 执行函数
	g.doCall(c, key, fn)
	return c.val, c.err, c.dups > 0
}

func (g *Group) DoChan(key string, fn func() (interface{}, error)) <-chan Result {
	ch := make(chan Result, 1)
	g.mu.Lock()
	if g.m == nil {
		g.m = make(map[string]*call)
	}
	if c, ok := g.m[key]; ok {
		c.dups++
		c.chans = append(c.chans, ch)
		g.mu.Unlock()
		return ch
	}
    // 创建 channel
	c := &call{chans: []chan<- Result{ch}}
	c.wg.Add(1)
	g.m[key] = c
	g.mu.Unlock()
	// 新开 goroutine 执行函数
	go g.doCall(c, key, fn)

	return ch
}


func (g *Group) doCall(c *call, key string, fn func() (interface{}, error)) {
    // 用于标记是否正常返回
	normalReturn := false
    // 用于标识是否触发了 recover
	recovered := false

	// use double-defer to distinguish panic from runtime.Goexit,
	// more details see https://golang.org/cl/134395
	defer func() {
        // 如果既没有正常执行完毕，又没有 recover ，则需要直接退出
		if !normalReturn && !recovered {
			c.err = errGoexit
		}

		g.mu.Lock()
		defer g.mu.Unlock()
		c.wg.Done()
        // 函数已经执行完毕了，call也就没用了
		if g.m[key] == c {
			delete(g.m, key)
		}

		if e, ok := c.err.(*panicError); ok {
			if len(c.chans) > 0 {
                // 如果返回的是 panic 错误，为了避免这个错误被上层 recover捕获而造成 channel 死锁，
                // 因此需要再开一个 goroutine 进行 panic 
				go panic(e)
                // 阻塞当前 goroutine 避免被垃圾回收
				select {} // Keep this goroutine around so that it will appear in the crash dump.
			} else {
				panic(e)
			}
		} else if c.err == errGoexit {
            // 当前 goroutine 已经退出，不需要再进行处理
		} else {
            // 返回结果到 chan
			for _, ch := range c.chans {
				ch <- Result{c.val, c.err, c.dups > 0}
			}
		}
	}()

    // 使用匿名函数的目的是为了在内部再使用一个 defer 用来捕获 panic
	func() {
		defer func() {
			if !normalReturn {
				if r := recover(); r != nil {
                    // 构建 panic 错误
					c.err = newPanicError(r)
				}
			}
		}()

        // 执行函数返回结果 
		c.val, c.err = fn()
		normalReturn = true
	}()

    // 判断是否 panic
	if !normalReturn {
		recovered = true
	}
}

func newPanicError(v interface{}) error {
    // 获取堆栈信息
	stack := debug.Stack()
	if line := bytes.IndexByte(stack[:], '\n'); line >= 0 {
		stack = stack[line+1:]
	}
	return &panicError{value: v, stack: stack}
}
```

在上面的代码中，可以发现 `doCall` 函数的设计是十分巧妙的，它通过两个 defer 巧妙的区分了到底是发生了 panic 还是用户主动调用了 runtime.Goexit。

同时在其中使用匿名函数来保证第二个 defer 能够在第一个 defer 之前执行。
