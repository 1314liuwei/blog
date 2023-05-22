# 类型概览

## 前言

> 为了更好的理解 gin 的工作流程，自己决定先熟悉 gin 中暴露的结构体来熟悉大体的工作流，再结合具体示例来深入了解整个工作流程。

## 一、Accounts

[gin/auth.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/auth.go#L20)

```go
type Accounts map[string]string
```

`Accounts` 是一个 map 表的别名，可以配合`gin.BasicAuth()`中间件进行简单的权限认证。

## 二、Context

[gin/context.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/context.go#L46)

```go
type Context struct {
	writermem responseWriter
	Request   *http.Request
	Writer    ResponseWriter

	Params   Params
	handlers HandlersChain
	index    int8
	fullPath string

	engine       *Engine
	params       *Params
	skippedNodes *[]skippedNode
	mu sync.RWMutex
	Keys map[string]interface{}
	Errors errorMsgs
	Accepted []string
	queryCache url.Values
	formCache url.Values
	sameSite http.SameSite
}
```

`Context` 是`gin`框架中最重要的组成部分，整个 Web 应用都是基于`Context`的来的。`Context`就像是一个故事的主线，串联起了整个 Web 请求的故事。从请求开始，到中间经历的重重中间件再到具体的路由函数，再到请求结束，都和`Context`息息相关。

## 三、Engine

[gin/gin.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/gin.go#L57)

```go
type Engine struct {
	RouterGroup

	RedirectTrailingSlash bool
	RedirectFixedPath bool

	HandleMethodNotAllowed bool

	ForwardedByClientIP bool

	AppEngine bool
	UseRawPath bool

	UnescapePathValues bool
	RemoveExtraSlash bool
	RemoteIPHeaders []string

	TrustedPlatform string

	MaxMultipartMemory int64

	delims           render.Delims
	secureJSONPrefix string
	HTMLRender       render.HTMLRender
	FuncMap          template.FuncMap
	allNoRoute       HandlersChain
	allNoMethod      HandlersChain
	noRoute          HandlersChain
	noMethod         HandlersChain
	pool             sync.Pool
	trees            methodTrees
	maxParams        uint16
	maxSections      uint16
	trustedProxies   []string
	trustedCIDRs     []*net.IPNet
}
```

`Engine`中包含了作用于整个工程的中间件以及配置文件。在有HTTP访问来临时，`Engine`会找到匹配的路由，然后新建一个`Context`，对请求进行分发。

## 四、Error

[gin/errors.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/errors.go#L34)

```go
type Error struct {
	Err  error
	Type ErrorType
	Meta interface{}
}
```

`Error`是gin中用于处理错误的结构体，用于处理在框架处理服务过程中出现的错误。

## 五、ErrorType

[gin/errors.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/errors.go#L16)

```go
type ErrorType uint64
```

`ErrorType`用于定义错误类型，在使用中配合`Error`类型使用。

## 六、H

[gin/utils.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/utils.go#L53)

```go
type H map[string]interface{}
```

返回响应时将参数传递给`H`，框架会自动帮我们转换成想要的格式，如`json`、`xml`等。

## 七、HandlerFunc

[gin/gin.go at v1.7.4 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.4/gin.go#L31)

```go
type cc func(*Context)
```

`HandlerFunc`是一种函数类型，中间件以及路由处理都是这种类型的函数。

## 八、HandlersChain

[gin/gin.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/gin.go#L34)

```go
type HandlersChain []HandlerFunc
```

`HandlersChain`是一个存放`HandlerFunc`的数组，`gin`通过直接遍历处理这些函数。

## 九、IRouter

[gin/routergroup.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/routergroup.go#L15)

```go
type IRouter interface {
	IRoutes
	Group(string, ...HandlerFunc) *RouterGroup
}
```

`IRouter`是路由组接口，在对路由进行分组处理时便会使用到该接口。

## 十、IRoutes

[gin/routergroup.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/routergroup.go#L21)

```go
type IRoutes interface {
	Use(...HandlerFunc) IRoutes

	Handle(string, string, ...HandlerFunc) IRoutes
	Any(string, ...HandlerFunc) IRoutes
	GET(string, ...HandlerFunc) IRoutes
	POST(string, ...HandlerFunc) IRoutes
	DELETE(string, ...HandlerFunc) IRoutes
	PATCH(string, ...HandlerFunc) IRoutes
	PUT(string, ...HandlerFunc) IRoutes
	OPTIONS(string, ...HandlerFunc) IRoutes
	HEAD(string, ...HandlerFunc) IRoutes

	StaticFile(string, string) IRoutes
	Static(string, string) IRoutes
	StaticFS(string, http.FileSystem) IRoutes
}
```

`IRoutes`是单路由处理接口。

## 十一、LogFormatter

[gin/logger.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/logger.go#L53)

```go
type LogFormatter func(params LogFormatterParams) string
```

`LogFormatter`定义了处理日志的函数类型。

## 十二、LogFormatterParams

[gin/logger.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/logger.go#L56)

```go
type LogFormatterParams struct {
	Request *http.Request

	TimeStamp time.Time
	StatusCode int
	Latency time.Duration
	ClientIP string
	Method string
	Path string
	ErrorMessage string
	isTerm bool
	BodySize int
	Keys map[string]interface{}
}
```

`LogFormatterParams`定义了日志格式化时候使用的参数类型。

## 十三、LoggerConfig

[gin/logger.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/logger.go#L39)

```go
type LoggerConfig struct {
	Formatter LogFormatter

	Output io.Writer
	SkipPaths []string
}
```

`LoggerConfig`用于管理日志配置。

## 十四、Negotiate

[gin/context.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/context.go#L1074)

```go
type Negotiate struct {
	Offered  []string
	HTMLName string
	HTMLData interface{}
	JSONData interface{}
	XMLData  interface{}
	YAMLData interface{}
	Data     interface{}
}
```

`Negotiate`根据客户端的请求返回不同的响应类型。

## 十五、Param

[gin/tree.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/tree.go#L23)

```go
type Param struct {
	Key   string
	Value string
}
```

`Param`用于存储 url 中的单个查询参数。

## 十六、Params

[gin/tree.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/tree.go#L31)

```go
type Params []Param
```

`Params`用于存储 url 中的所有查询参数。

## 十七、RecoveryFunc

[gin/recovery.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/recovery.go#L30)

```go
type RecoveryFunc func(c *Context, err interface{})
```

`RecoveryFunc`定义可传递给`CustomRecovery`的函数，用于自定义捕获运行过程中出现的错误。

## 十八、ResponseWriter

[gin/response_writer.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/response_writer.go#L20)

```go
type ResponseWriter interface {
	http.ResponseWriter
	http.Hijacker
	http.Flusher
	http.CloseNotifier

	Status() int
	Size() int
	WriteString(string) (int, error)
	Written() bool
	WriteHeaderNow()
	Pusher() http.Pusher
}
```

`ResponseWriter`响应返回数据的接口，用于处理 http 响应。

## 十九、RouteInfo

[gin/gin.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/gin.go#L45)

```go
type RouteInfo struct {
	Method      string
	Path        string
	Handler     string
	HandlerFunc HandlerFunc
}
```

`RouteInfo`用于记录 gin 中对路由处理的信息，包括请求方法、请求路径、处理请求的函数名字以及具体的处理函数。

## 二十、RouterGroup

[gin/routergroup.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/routergroup.go#L41)

```go
type RouterGroup struct {
	Handlers HandlersChain
	basePath string
	engine   *Engine
	root     bool
}
```

`RouterGroup`用于分组路由处理。

## 二十一、RoutesInfo

[gin/gin.go at v1.7.6 · gin-gonic/gin (github.com)](https://github.com/gin-gonic/gin/blob/v1.7.6/gin.go#L53)

```go
type RoutesInfo []RouteInfo
```

`RoutesInfo`储存整个服务的路由处理信息。

## 总计

概览所有类型，我们可以对所有类型进行一个简单得分类：

```
                +---------+ +---------+
                |  Engine | | Context |  +----------------+
                +---------+ +---------+  | ResponseWriter |
                   +---------------+     | H              |
+-------------+    | HandlerFunc   |     | Negotiate      |
| IRouter     |    | HandlersChain |     +----------------+
| IRoutes     |    +---------------+     +--------------------+
| RouterInfo  | +-----------+ +--------+ | LogConfig          |
| RoutesInfo  | | Error     | | Param  | | LogFormatterParams |
| RouterGroup | | ErrorType | | Params | | LogFormatter       |
+-------------+ +-----------+ +--------+ +--------------------+
```

对这些结构体的大体功能划分清楚后我们就明白了 gin 工作的大体流程，后面再对结合示例对工作细节进行探究学习。









































