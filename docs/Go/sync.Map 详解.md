# sync.Map 详解

在 `src\sync\map.go`存放在 sync.Map 的所有代码。

## 结构

先看一下这里面有哪些结构体：

```go
type Map struct {
	mu Mutex
	read atomic.Pointer[readOnly]
	dirty map[any]*entry
	misses int
}

type readOnly struct {
	m       map[any]*entry
	amended bool 
}

type entry struct {
	p atomic.Pointer[any]
}
```

下面对每个结构体进行分析：

`Map` 结构：`Map` 结构是主要结构体，其中包含以下字段：

- 有一个 `Mutex` 互斥锁，用来保护 `read` 和 `dirty`的写操作；
- 一个 `read` 字段，为 `atomic.Pointer[readOnly]`类型，可以并发读，但是需要更新 read 时，需要进行加锁。对于 read 中的存储的 `entry`字段，可以被并发地被 CAS 更新；
- 一个 `dirty` 字段，为原始的 `map`类型，用来写入数据。包含完整的数据；
- `misses`字段用来统计 `read`未击中的次数，当次数达到 `dirty`字段的长度后，需要对 `read`字段进行替换。

`readOnly` 结构：`readOnly` 结构是 Map 中的 `read` 字段，主要用来并发读。在 `readOnly`中包含以下字段：

- `m` 字段：`m`是一个原始的 `map`结构，用来并发读；
- `amended`字段：判断 `read`和 `dirty`是否存在差别；

`entry`字段用来存储值，`entry`的`p`存在着三种状态：

- `nil`：说明这个键值对已被删除，并且 `m.dirty == nil`，或 `m.dirty[k]`指向该 `entry`；
- `expunged`：说明这条键值对已被删除，并且 `m.dirty != nil`，且 m.dirty 中没有这个 `key`；
- 正常值：`p` 指向一个正常的值，表示实际 `interface{}` 的地址，并且被记录在 `m.read.m[key]` 中。如果这时 `m.dirty` 不为 nil，那么它也被记录在 `m.dirty[key]` 中。两者实际上指向的是同一个指针。

下面将对每个步骤进行详细的分析。

### Store

```go
func (m *Map) Store(key, value any) {
	_, _ = m.Swap(key, value)
}

func (m *Map) Swap(key, value any) (previous any, loaded bool) {
    // 加载 read 中的 map
	read := m.loadReadOnly()
    // 判断 key 是否在 map 中
	if e, ok := read.m[key]; ok {
        // 如果存在 key，尝试更新值
		if v, ok := e.trySwap(&value); ok {
			if v == nil {
				return nil, false
			}
			return *v, true
		}
	}

    // 需要写入 dirty，因此需要进行加锁
	m.mu.Lock()
    // 再次对 read 进行判断，防止在加锁之前已经被其他 goroutine 更新
	read = m.loadReadOnly()
	if e, ok := read.m[key]; ok {
        // 如果 e 的值为expunged，则将 e 的值重置为 nil，并直接写入 dirty（因为如果为 expunged 则代表 dirty != nil）。
        // 如果已经重置过了，则不需要进行重置和写入 dirty
		if e.unexpungeLocked() {
			m.dirty[key] = e
		}
        // 存储值
		if v := e.swapLocked(&value); v != nil {
			loaded = true
			previous = *v
		}
	} else if e, ok := m.dirty[key]; ok {
        // 如果 dirty 中已经有值了，则直接存储值
		if v := e.swapLocked(&value); v != nil {
			loaded = true
			previous = *v
		}
	} else {
        // 更新 read 的 amended 字段	
		if !read.amended {
			m.dirtyLocked()
			m.read.Store(&readOnly{m: read.m, amended: true})
		}
        // 存储值
		m.dirty[key] = newEntry(value)
	}
	m.mu.Unlock()
	return previous, loaded
}

func (m *Map) loadReadOnly() readOnly {
	if p := m.read.Load(); p != nil {
		return *p
	}
	return readOnly{}
}

func (m *Map) dirtyLocked() {
	if m.dirty != nil {
		return
	}

	read := m.loadReadOnly()
    // 将 read 的中的有效值复制到 dirty 中
	m.dirty = make(map[any]*entry, len(read.m))
	for k, e := range read.m {
		if !e.tryExpungeLocked() {
			m.dirty[k] = e
		}
	}
}

func (e *entry) trySwap(i *any) (*any, bool) {
	for {
		p := e.p.Load()
        // 如果 p 为 expunged,那么说明这个 key 已经被删除，并且不在 dirty，不能直接更新
		if p == expunged {
			return nil, false
		}
		if e.p.CompareAndSwap(p, i) {
			return p, true
		}
	}
}

func (e *entry) unexpungeLocked() (wasExpunged bool) {
	return e.p.CompareAndSwap(expunged, nil)
}

func (e *entry) swapLocked(i *any) *any {
	return e.p.Swap(i)
}

func (e *entry) tryExpungeLocked() (isExpunged bool) {
	p := e.p.Load()
	for p == nil {
		if e.p.CompareAndSwap(nil, expunged) {
			return true
		}
		p = e.p.Load()
	}
	return p == expunged
}
```

通过代码分析可以发现，在存储值时首先会去  `read`查找 key 是否存在，如果能找到，那么通过改变 `entry`的指针来改变值，这个过程是 lock-free 的。

如果在 read 中查找不到或存在过但是未及时清理的，那么会去更新 `dirty` ，这个过程是需要加锁的。

## Load

```go
func (m *Map) Load(key any) (value any, ok bool) {
    // 读取 read 字段中的值
	read := m.loadReadOnly()
	e, ok := read.m[key]
    // 如果read中不存在，并且dirty和read没有保持一致，则尝试去 dirty 取值
	if !ok && read.amended {
		m.mu.Lock()
        // 重复尝试，防止数据read被更改
		read = m.loadReadOnly()
		e, ok = read.m[key]
		if !ok && read.amended {
            // 从 dirty 查值
			e, ok = m.dirty[key]
            // 判断是否需要更新 read 和 dirty
			m.missLocked()
		}
		m.mu.Unlock()
	}
    // 判断是否取到了值
	if !ok {
		return nil, false
	}
	return e.load()
}

func (m *Map) missLocked() {
    // 增加 misses 次数
	m.misses++
    // 如果 miss 次数大于了 dirty 的长度，就把 dirty的值赋值给 read，并把 dirty 清空
	if m.misses < len(m.dirty) {
		return
	}
	m.read.Store(&readOnly{m: m.dirty})
	m.dirty = nil
	m.misses = 0
}

func (e *entry) load() (value any, ok bool) {
	p := e.p.Load()
    // 判断值是否有效
	if p == nil || p == expunged {
		return nil, false
	}
	return *p, true
}
```

通过代码分析可以发现，`sync.Map` 在 `Load` 值的过程依然是先从 `read`中取值（lock-free的）；`read`中取不到值再尝试从`dirty`中取值（需要加锁）。

并且在取值的过程中，如果多次未击中`read`，那么则会将 `dirty`中的值拷贝到`read`中，这样能够保证及时将最新的值写入到`read`中。

## Delete

```go
func (m *Map) Delete(key any) {
	m.LoadAndDelete(key)
}

func (m *Map) LoadAndDelete(key any) (value any, loaded bool) {
	read := m.loadReadOnly()
	e, ok := read.m[key]
    // 如果 read 中没有 key，且read和dirty有差别，则尝试从dirty取值
	if !ok && read.amended {
		m.mu.Lock()
		read = m.loadReadOnly()
		e, ok = read.m[key]
		if !ok && read.amended {
			e, ok = m.dirty[key]
            // 从 dirty 中实际删除值
			delete(m.dirty, key)
			// 判断是否需要更新 read 
			m.missLocked()
		}
		m.mu.Unlock()
	}
	if ok {
		return e.delete()
	}
	return nil, false
}

func (e *entry) delete() (value any, ok bool) {
	for {
		p := e.p.Load()
		if p == nil || p == expunged {
			return nil, false
		}
		if e.p.CompareAndSwap(p, nil) {
			return *p, true
		}
	}
}
```

通过代码分析可以发现，`sync.Map` 在 `Delete` 值的过程依然是先从 `read`中取值（lock-free的）；`read`中取不到值再尝试从`dirty`中取值（需要加锁），如果在`dirty`中取到了值，那么会直接从`dirty`中删除这个值。

在取到值后，会将这个值置为 `nil`。

