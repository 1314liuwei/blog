# runtime 包

## 属性值

- `runtime.Version()`：Go 版本号；
- `runtime.GOARCH`：当前运行环境架构；
- `runtime.GOOS`：当前运行的操作系统；
- `runtime.GOROOT()`：获取 GOROOT 路径；
- `runtime.NumCgoCall() `：获取当前进程调用 CGO 次数；
- `runtime.NumGoroutine()`：获取当前程序启动的 Goroutine 数量；
- `runtime.NumCPU()`：返回当前环境逻辑 CPU 数量；

## 方法

- `runtime.GOMAXPROCS(int)`：设置可同时执行的最大CPU数，并返回先前的设置；
- `runtime.GC()`：手动触发 GC。在程序中执行一些占用大量内存的操作后，手动触发 GC 可以让内存回收更加及时，避免出现内存不足等问题。需要注意的是，`runtime.gc()` 不会立即触发垃圾回收，而是将垃圾回收的操作标记为“可执行”，等待下一次垃圾回收周期到来时再进行回收操作。因此，如果需要及时地释放内存，还需要手动调用 `runtime.Gosched()` 或者 `runtime.LockOSThread()` 等函数让垃圾回收线程尽快执行；
- `runtime.SetFinalizer(obj any, finalizer any)`：Go提供对象被GC回收时的一个注册函数，可以在对象被回收的时候回调函数。`finalizer` 函数必须接受一个指向对象的指针作为参数，在`finalizer` 中的`panic`无法被`recover`。对象被垃圾回收时，finalizer 函数的调用是异步的，也就是说不能保证 finalizer 函数会在对象被回收之前执行；
- `runtime.KeepAlive()`：用于防止一个对象被提前回收。注意，`KeepAlive`仅在需要保证对象存活的场景中使用，否则可能会影响垃圾回收器的正常工作。`KeepAlive()` 的调用必须在对象的最后一次使用之后，否则可能会产生不必要的开销；
- `runtime.Goexit()`：用于立即终止当前 goroutine 的执行。在调用 `runtime.Goexit()` 函数时，当前 goroutine 会立即终止执行，并且不会执行当前 goroutine 中未被执行的 defer 语句；
- `runtime.Gosched()`：用于让出当前 goroutine 的执行权，让其他 goroutine 有机会执行。在某些情况下，一个 goroutine 可能会长时间占用 CPU 资源，导致其他 goroutine 无法执行。`runtime.Gosched()` 函数可以解决这个问题，让其他 goroutine 有机会执行。在调用 `runtime.Gosched()` 函数时，当前 goroutine 会让出执行权，让其他 goroutine 有机会执行。当其他 goroutine 执行完毕后，当前 goroutine 会继续执行；
- `runtime.LockOSThread()`：用于将当前 goroutine 锁定到当前操作系统线程上。在多线程编程中，有时我们需要将某个 goroutine 锁定到特定的线程上，以保证线程安全。在调用 `runtime.LockOSThread()` 函数时，当前 goroutine 会被锁定到当前操作系统线程上。在锁定之后，这个 goroutine 只会在这个线程上执行，直到调用 `runtime.UnlockOSThread()` 函数释放锁定；
- `runtime.UnlockOSThread()`：用于释放当前 goroutine 锁定的操作系统线程。