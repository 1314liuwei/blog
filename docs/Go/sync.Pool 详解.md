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

```go
func (p *Pool) Get() any {
	if race.Enabled {
		race.Disable()
	}
    // 返回当前 M 绑定的 P 的ID号以及所对应的 poolLocal
	l, pid := p.pin()
    // 获取 poolLocal 上的 private，然后将其置空
	x := l.private
	l.private = nil
    
	if x == nil {
		// Try to pop the head of the local shard. We prefer
		// the head over the tail for temporal locality of
		// reuse.
        // 如果变量为空，则尝试从自身共享 shared 上拿去一个
		x, _ = l.shared.popHead()
        
        // 如果依然为空，则尝试从其他 P 的 poolLocal 中拿取一个
		if x == nil {
			x = p.getSlow(pid)
		}
	}
    
    // 解绑 P
	runtime_procUnpin()
	if race.Enabled {
		race.Enable()
		if x != nil {
			race.Acquire(poolRaceAddr(x))
		}
	}
    
    // 如果整个对象池中都不存在数据，则尝试调用 New 方法创建一个
	if x == nil && p.New != nil {
		x = p.New()
	}
	return x
}
```

```go
func (p *Pool) getSlow(pid int) any {
	// See the comment in pin regarding ordering of the loads.
    // 加载 local 和 size
	size := runtime_LoadAcquintptr(&p.localSize) // load-acquire
	locals := p.local                            // load-consume
    
	// Try to steal one element from other procs.
    // 从其他 P 对应的 poolLocal 的共享对象中尝试拿去一个
	for i := 0; i < int(size); i++ {
		l := indexLocal(locals, (pid+i+1)%int(size))
		if x, _ := l.shared.popTail(); x != nil {
			return x
		}
	}

	// Try the victim cache. We do this after attempting to steal
	// from all primary caches because we want objects in the
	// victim cache to age out if at all possible.
    // 如果从当前 local 拿不到数据，则从老的 victim 中尝试拿数据
	size = atomic.LoadUintptr(&p.victimSize)
	if uintptr(pid) >= size {
		return nil
	}
	locals = p.victim
	l := indexLocal(locals, pid)
	if x := l.private; x != nil {
		l.private = nil
		return x
	}
	for i := 0; i < int(size); i++ {
		l := indexLocal(locals, (pid+i)%int(size))
		if x, _ := l.shared.popTail(); x != nil {
			return x
		}
	}

	// Mark the victim cache as empty for future gets don't bother
	// with it.
    // 如果从老的数据中依然取不到数据，则下次将 victimSize 置空，避免下次再尝试从 victim 中取数据
	atomic.StoreUintptr(&p.victimSize, 0)

	return nil
}
```



## poolChain

`poolChain`是一个链头非并发安全，链尾并发安全的链表。

### 结构

```go
type poolChain struct {
	head *poolChainElt
	tail *poolChainElt
}

type poolChainElt struct {
	poolDequeue
	next, prev *poolChainElt
}

type poolDequeue struct {
	headTail uint64
	vals []eface
}

type eface struct {
	typ, val unsafe.Pointer
}
```



## Other Method

```go
func init() {
	// 将 poolCleanup 注册到 runtime, 该函数会在 GC 执行前执行
    runtime_registerPoolCleanup(poolCleanup)
}

// poolCleanup 用于清理缓存对象，避免缓存对象一直不过期
// 缓存对象会在第二个 GC 到来前被清理
func poolCleanup() {
    // 由于在执行 poolCleanup 时，已经进入了 STW 状态，因此不能执行 runtime 相关函数以及新对象的创建
	// This function is called with the world stopped, at the beginning of a garbage collection.
	// It must not allocate and probably should not call any runtime functions.

	// Because the world is stopped, no pool user can be in a
	// pinned section (in effect, this has all Ps pinned).

	// Drop victim caches from all pools.
    // 将老的 pool 的 victim 全部清空 
	for _, p := range oldPools {
		p.victim = nil
		p.victimSize = 0
	}

	// Move primary cache to victim cache.
    // 将 poolLocal 的当前 local 移动到 victim
	for _, p := range allPools {
		p.victim = p.local
		p.victimSize = p.localSize
		p.local = nil
		p.localSize = 0
	}

	// The pools with non-empty primary caches now have non-empty
	// victim caches and no pools have primary caches.
    // 将现在的 pools 标记为老的
	oldPools, allPools = allPools, nil
}

var (
	allPoolsMu Mutex
	allPools []*Pool
	oldPools []*Pool
)

// Implemented in runtime.
func runtime_registerPoolCleanup(cleanup func())
func runtime_procPin() int
func runtime_procUnpin()

// The below are implemented in runtime/internal/atomic and the
// compiler also knows to intrinsify the symbol we linkname into this
// package.

//go:linkname runtime_LoadAcquintptr runtime/internal/atomic.LoadAcquintptr
func runtime_LoadAcquintptr(ptr *uintptr) uintptr

//go:linkname runtime_StoreReluintptr runtime/internal/atomic.StoreReluintptr
func runtime_StoreReluintptr(ptr *uintptr, val uintptr) uintptr
```

```go
// src/runtime/mgc.go

//go:linkname sync_runtime_registerPoolCleanup sync.runtime_registerPoolCleanup
func sync_runtime_registerPoolCleanup(f func()) {
	poolcleanup = f
}

func clearpools() {
	// clear sync.Pools
	if poolcleanup != nil {
		poolcleanup()
	}
    ......
}

func gcStart(trigger gcTrigger) {
    ......
    // clearpools before we start the GC. If we wait they memory will not be
	// reclaimed until the next GC cycle.
	clearpools()
    ......
}
```

## 总结

通过代码分析发现 `sync.Pool`有以下特性：

- 为每个 P 绑定一个 `poolLocal` 对象，每个 `poolLocal` 中有一个 `private`对象。`private`对象只能被对应的 P 访问，因此访问 `private`时不需要进行加锁；
- `poolLocal`中的`shared`是一个无锁、并发安全的环形链表。能够同时被不同的 P 访问；
- 对象池中的对象在遇到的第二个 GC 时会被删除。

