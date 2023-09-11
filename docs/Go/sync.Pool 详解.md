# sync.Pool 详解

`sync.Pool`是 Go 官方提供的对象缓存池，能够帮助我们缓存暂时不用的对象，直到下次取出，避免重复创建对象。

## 结构

```go
type Pool struct {
	noCopy noCopy

	local     unsafe.Pointer // local fixed-size per-P pool, actual type is [P]poolLocal
	localSize uintptr        // size of the local array

	victim     unsafe.Pointer // local from previous cycle
	victimSize uintptr        // size of victims array

	// New optionally specifies a function to generate
	// a value when Get would otherwise return nil.
	// It may not be changed concurrently with calls to Get.
	New func() any
}

type poolLocal struct {
	poolLocalInternal

	// Prevents false sharing on widespread platforms with
	// 128 mod (cache line size) = 0 .
	pad [128 - unsafe.Sizeof(poolLocalInternal{})%128]byte
}

// Local per-P Pool appendix.
type poolLocalInternal struct {
	private any       // Can be used only by the respective P.
	shared  poolChain // Local P can pushHead/popHead; any P can popTail.
}
```

`Pool` 结构是主要结构体:

- `noCopy`：防止 Pool 被拷贝；
- `local`：poolLocal 数组指针，数组长度和 P 相关（即 GMP 模型中的 P）；
- `localSize`：local 数组的长度；
- `victim`：上一轮 GC 时 local 的值；
- `victimSize`：victim 数组的长度；
- `New`：当对象池种没有对象时，创建新对象的回调函数。

`poolLocal`结构主要用于对象缓存，是对 `poolLocalInternal`结构的封装：

- `pad`：填充数组，用于防止 false sharing，详情可见此文章：[What’s false sharing and how to solve it (using Golang as example)](https://medium.com/@genchilu/whats-false-sharing-and-how-to-solve-it-using-golang-as-example-ef978a305e10)；

`poolLocalInternal`对象存储主要实现：

- `private`：缓存对象，同时只能被一个 P 访问；
- `shared`：共享缓存对象，同时可以被多个 P 访问。

## `Put`方法

```go
func (p *Pool) Put(x any) {
    // 当放入的对象为 nil 时，函数直接返回，不执行放入对象池操作
	if x == nil {
		return
	}
    
    // race 相关代码是为了通过竞态检测，这里不用分析
	if race.Enabled {
		if fastrandn(4) == 0 {
			// Randomly drop x on floor.
			return
		}
		race.ReleaseMerge(poolRaceAddr(x))
		race.Disable()
	}
    
    // 返回一个 poolLocal 对象
	l, _ := p.pin()
    // 如果 poolLocal 的 private 为空，则直接将对象赋值给 private
	if l.private == nil {
		l.private = x
	} else {
        // 如果 poolLoca 的 private 不为空，则将对象放入共享队列
		l.shared.pushHead(x)
	}
    
    // 将当前 G 与 M 解锁
	runtime_procUnpin()
	if race.Enabled {
		race.Enable()
	}
}
```

```go
func (p *Pool) pin() (*poolLocal, int) {
    // 将当前 G 和 M 绑定，并获取目前 M 绑定的 P 的 ID
	pid := runtime_procPin()
    
	// In pinSlow we store to local and then to localSize, here we load in opposite order.
	// Since we've disabled preemption, GC cannot happen in between.
	// Thus here we must observe local at least as large localSize.
	// We can observe a newer/larger local, it is fine (we must observe its zero-initialized-ness).
    
    // 原子操作取出 localSize 
	s := runtime_LoadAcquintptr(&p.localSize) // load-acquire
    // 取出 local
	l := p.local                              // load-consume
    
    // 如果 pid 小于 s，则直接将 l 转换为 poolLocal
	if uintptr(pid) < s {
		return indexLocal(l, pid), pid
	}
    // 如果 pid 大于 s，则代表要么是还未进行初始化，要么是 runtime.GOMAXPROCS() 发生了变化，需要重新进行赋值
	return p.pinSlow()
}

// 类型转换
func indexLocal(l unsafe.Pointer, i int) *poolLocal {
	lp := unsafe.Pointer(uintptr(l) + uintptr(i)*unsafe.Sizeof(poolLocal{}))
	return (*poolLocal)(lp)
}
```

```go
func (p *Pool) pinSlow() (*poolLocal, int) {
	// Retry under the mutex.
	// Can not lock the mutex while pinned.
    // 解除绑定
    // 先解锁再加锁，避免出现死锁
	runtime_procUnpin()
    // 加上全局锁
	allPoolsMu.Lock()
	defer allPoolsMu.Unlock()
    // 重新绑定
	pid := runtime_procPin()
	// poolCleanup won't be called while we are pinned.
    // 重新进行判断
	s := p.localSize
	l := p.local
	if uintptr(pid) < s {
		return indexLocal(l, pid), pid
	}
	if p.local == nil {
		allPools = append(allPools, p)
	}
	// If GOMAXPROCS changes between GCs, we re-allocate the array and lose the old one.
	size := runtime.GOMAXPROCS(0)
	local := make([]poolLocal, size)
    // 原子操作更换 p.local 的值
	atomic.StorePointer(&p.local, unsafe.Pointer(&local[0])) // store-release
    // 原子操作存储 p.localSize 值
	runtime_StoreReluintptr(&p.localSize, uintptr(size))     // store-release
	return &local[pid], pid
}
```



## `Get`方法

