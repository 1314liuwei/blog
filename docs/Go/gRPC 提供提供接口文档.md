# gRPC 提供接口文档

在 RESULTful 接口服务中，我们可以使用 swagger 来展示当前服务接口列表，但是当我们的项目是使用的 gRPC 提供接口服务时，就没法使用 swagger 来做接口展示服务了。

为了解决这个问题，本文将介绍 `protoc-gen-doc` 加 `静态文件 Web 服务` 的方式来在线提供 gRPC 文档。

## 一、编写 gRPC 服务

在开始生成接口文档之前，我们先简单定义一个 gRPC 服务：

```protobuf
// pb/hello.proto
syntax = "proto3";
option go_package = "./;pb";
package pb;

service Greeter {
  // simple RPC
  rpc SimpleRPC(HelloRequest) returns (HelloResponse);

  // Bidirectional Streaming RPC
  rpc BidrectionalStreamingRPC(stream HelloRequest) returns (stream HelloResponse);

  // Repeated Test RPC
  rpc RepeatedTest(HelloRequest) returns (RepeatedResponse);

  // Map Test RPC
  rpc MapTest(HelloRequest) returns (MapResponse);
}

message HelloRequest {string name = 1;}

message HelloResponse {string reply = 1;}

message RepeatedResponse {
  message Result {
    string name = 1;
    int32 age = 2;
  }

  repeated Result results = 1;
}

message MapResponse {
  map<string,int64> dict = 1;
}
```



## 生成 gRPC 接口文档

首先需要安装 `protoc-gen-doc` 插件(默认已经安好 `protoc` 和 `Go`):

```bash
go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@latest
```

安装完成后生成文档（需要手动创建 `doc` 文件夹 ）：

```bash
protoc --doc_out=./doc --doc_opt=html,index.html  pb/*.proto
```

命令执行成功后，会在 `doc` 文件夹下面生成 index.html 文件。如果想要生成其他格式的文档，可以参看官方文档：[pseudomuto/protoc-gen-doc: Documentation generator plugin for Google Protocol Buffers (github.com)](https://github.com/pseudomuto/protoc-gen-doc#output-example)

浏览器打开 index.html 文件：

![image-20221107090636498](https://pic.try-hard.cn/blog/image-20221107090636498.png)

## 三、启动静态文件 Web 服务

由于 gRPC 是使用的 HTTP 2.0 协议，但是想要在网页端访问文件又需要 HTTP 1.1 协议，因此需要让当前服务能够根据 HTTP 协议版本分别提供 gRPC 服务和静态文件 Web 服务。

为了达成当前效果，我们需要借助一个 `cmux` 库，

> cmux是一个通用的Go库，用于根据负载对连接进行多路复用。使用cmux，可以在同一个TCP侦听器上提供gRPC、SSH、HTTPS、HTTP、Go-RPC和几乎任何其他协议。

下载该库：

```bash
go get -u github.com/soheilhy/cmux
```

编写服务端代码：

```go
func RunGrpcServer() *grpc.Server {
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	reflection.Register(s)

	return s
}

func RunHttpServer() *http.Server {
	serveMux := http.NewServeMux()
	// 处理静态资源
	serveMux.Handle("/doc/", http.FileServer(http.Dir(".")))

	return &http.Server{
		Addr:    ":5678",
		Handler: serveMux,
	}
}

func main() {
	l, err := net.Listen("tcp", ":5678")
	if err != nil {
		log.Fatalf("Run TCP Server err: %v", err)
	}
	
    // 创建一个多路复用器
	m := cmux.New(l)
    // 匹配 gRPC 应用
	grpcL := m.MatchWithWriters(cmux.HTTP2MatchHeaderFieldPrefixSendSettings("content-type", "application/grpc"))
	// 匹配 HTTP 1.1 应用
    httpL := m.Match(cmux.HTTP1Fast())

    // 处理 gRPC 服务
	grpcS := RunGrpcServer()
    // 处理 HTTP 服务
	httpS := RunHttpServer()
	go grpcS.Serve(grpcL)
	go httpS.Serve(httpL)

	err = m.Serve()
	if err != nil {
		log.Fatalf("Run Serve err: %v", err)
	}
}
```

运行服务，打开浏览器访问 [Protocol Documentation](http://127.0.0.1:5678/doc/index.html)，即可访问到我们之前生成的 gRPC 文档。
