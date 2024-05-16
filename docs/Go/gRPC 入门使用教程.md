# gRPC 入门使用教程

## 一、gRPC 介绍

> 在 gRPC 里客户端应用可以像调用本地对象一样直接调用另一台不同的机器上服务端应用的方法，使得您能够更容易地创建分布式应用和服务。与许多 RPC 系统类似，gRPC 也是基于以下理念：定义一个服务，指定其能够被远程调用的方法（包含参数和返回类型）。在服务端实现这个接口，并运行一个 gRPC 服务器来处理客户端调用。在客户端拥有一个存根能够像服务端一样的方法。

![图1](https://pic.try-hard.cn/blog/grpc_concept_diagram_00.png)

## 二、安装与使用

安装 **protoc** 程序：

从 https://github.com/google/protobuf/releases下载适合你平台的预编译好的二进制文件（`protoc-<version>-<platform>.zip`），然后将压缩包内的 **/bin/protoc** 文件添加到环境变量即可：

```bash
# 下载压缩包
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protoc-21.9-linux-x86_64.zip

# 解压
unzip -d ./protoc protoc-21.9-linux-x86_64.zip

# 移动到 /usr/local/bin 下面
mv ./protoc/bin/protoc /usr/local/bin
```

首先需要确保将 GOBIN 添加进了环境变量，如果没有添加使用的时候会无法找到路径。Linux 环境下可通过以下指令添加：

```bash
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
```

安装 **protoc-gen-go** 和 **protoc-gen-go-grpc** 插件：

```bash
# protoc-gen-go 插件主要用于将 *.proto 文件生成一个后缀为 *.pb.go 的文件。生成文件中包含所有 .proto 文件中定义的类型及其序列化方法
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# protoc-gen-go-grpc 插件主要用于生成 gRPC 服务端需要实现的接口和客户端调用的接口
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

测试环境安装是否成功：

```bash
> protoc --version
libprotoc 3.21.9

> protoc-gen-go --version
protoc-gen-go v1.28.1

> protoc-gen-go-grpc --version
protoc-gen-go-grpc 1.2.0
```

## 三、protobuff 语法

proto 文件主要包含 proto 基本信息以及 RPC 服务定义。

进行一次 RPC 调用需要注意两个点：**方法**和**参数**。在 porro 文件中，方法用 **Service** 定义，参数用 **Message** 定义。

### 1. 基本信息

```protobuf
// 版本声明，使用Protocol Buffers v3版本
syntax = "proto3";

// package 是 proto 的包名,一个文件就是一个 package,用于 import 时解析(与 go 的包管理类似)
package pb;

// option go_package = "path;name";
// path 表示生成的go文件的存放地址，会自动生成目录的。
// name 表示生成的go文件所属的包名
option go_package = "./;pb";
```

### 2. message 

一个 Message 中主要包含：**字段编号**和**字段类型**；

**字段编号**

消息定义中的每个字段都有一个**唯一的编号**。这些字段编号用来在消息二进制格式中标识字段，在消息类型使用后就不能再更改。

注意，**范围1到15中的字段编号需要一个字节**进行编码，包括字段编号和字段类型。**范围16到2047的字段编号采用两个字节**。因此，应该为经常使用的消息元素保留数字1到15的编号。切记为将来可能添加的经常使用的元素留出一些编号。

**字段类型**

字段类型包含**标量类型**、**组合类型**、**枚举类型**、**数组类型**、**map 类型**和**嵌套消息**；

##### 2.1 标量类型

下表中列举了 protobuff 中的类型与常见编程语言中类型的对应关系：

|          |                            Notes                             |  C++   |    Java/Kotlin    |             Python              |   Go    |
| :------: | :----------------------------------------------------------: | :----: | :---------------: | :-----------------------------: | :-----: |
|  double  |                                                              | double |      double       |              float              | float64 |
|  float   |                                                              | float  |       float       |              float              | float32 |
|  int32   | 使用可变长度编码。编码负数效率低下——如果你的字段可能有负值，则使用 sint32代替。 | int32  |        int        |               int               |  int32  |
|  int64   | 使用可变长度编码。编码负数效率低下——如果你的字段可能有负值，则使用 sint64代替。 | int64  |       long        |           int/long[4]           |  int64  |
|  uint32  |                        使用变长编码。                        | uint32 |      int[2]       |           int/long[4]           | uint32  |
|  uint64  |                        使用变长编码。                        | uint64 |      long[2]      |           int/long[4]           | uint64  |
|  sint32  | 使用可变长度编码。带符号的 int 值。这些编码比普通的 int32更有效地编码负数。 | int32  |        int        |               int               |  int32  |
|  sint64  | 使用可变长度编码。带符号的 int 值。这些编码比普通的 int64更有效地编码负数。 | int64  |       long        |           int/long[4]           |  int64  |
| fixed32  |    总是四个字节。如果值经常大于228，则比 uint32更有效率。    | uint32 |      int[2]       |           int/long[4]           | uint32  |
| fixed64  |     总是8字节。如果值经常大于256，则比 uint64更有效率。      | uint64 | integer/string[6] |                                 |         |
| sfixed32 |                        总是四个字节。                        | int32  |        int        |               int               |  int32  |
| sfixed64 |                        总是八个字节。                        | int64  | integer/string[6] |                                 |         |
|   bool   |                                                              |  bool  |      boolean      |              bool               |  bool   |
|  string  | 字符串必须始终包含 UTF-8编码的或7位 ASCII 文本，且不能长于232。 | string |      String       |         str/unicode[5]          | string  |
|  bytes   |          可以包含任何不超过232字节的任意字节序列。           | string |    ByteString     | str (Python 2) bytes (Python 3) | []byte  |



examples：

```protobuf
message HelloRequest {
	string name = 1;
	int64 age = 2;
	bool man = 3;
}
```

##### 2.2 枚举类型

当需要定义一个消息类型的时候，可能想为一个字段指定 “预定义值序列” 中的一个值，这时候可以通过枚举实现。

```protobuf
enum PhoneType // 枚举消息类型，使用 enum 关键词定义
{
    MOBILE = 0; // proto3 版本中，枚举类型首成员必须为0，成员不应有相同的值
    HOME = 1;
    WORK = 2;
}

// 定义一个电话消息
message PhoneNumber
{
    string number = 1;
    PhoneType type = 2; 
}
```

##### 2.3 数组类型

在 protobuf 消息中定义数组类型，是通过在字段前面增加 repeated 关键词实现，标记当前字段是一个数组。

```protobuf
message Msg {
	repeated int32 arrays = 1;
	repeated string strings = 2;
}
```

##### 2.4 map 类型

map 类型的定于语法为：

```protobuf
map<key_type, value_type> map_field = N;
```

`key_type`可以是任何整数或字符串类型（除浮点类型和字节之外的任何标量类型）。请注意，枚举不是有效的`key_type`。

示例：

```protobuf
message Msg {
	map<string, int> dictA = 1;
	map<string, string> dictB = 2;
}
```

##### 2.5 嵌套类型

我们在各种语言开发中类的定义是可以互相嵌套的，也可以使用其他类作为自己的成员属性类型。

在 protobuf 中同样支持消息嵌套，可以在一个消息中嵌套另外一个消息，字段类型可以是另外一个消息类型。

**引用其他消息类型**

```protobuf
message Msg1 {
	string name = 1;
	int32 age = 2;
}

message Msg2 {
	string describe = 1;
	Msg1 msg = 2;
}
```

**消息嵌套**

```protobuf
message Msg1 {
	message Msg2 {
		string name = 1;
		string age = 2;
	}
	Msg2 msg = 1;
}
```

**import 导入其他 proto 文件定义的消息**

`msg1.proto`:

```protobuf
syntax = "proto3";

package msg1;

message Msg1 {
	string name = 1;
	string age = 2;
}
```

`msg2.proto`:

```protobuf
syntax = "proto3";

import "msg1.proto";

package msg2;

message Msg2 {
	msg1.Msg1 msg = 1;
}
```

### 3. Service

在 gRPC 中，可以定义四种类型的服务方法：

- 简单RPC (*simple RPC*)：客户端向服务器发送一个请求，然后得到一个响应，就像普通的函数调用一样：

  ```protobuf
  rpc SimpleRPC(HelloRequest) returns (HelloResponse);
  ```

- 服务端流式RPC (*server-side streaming RPC*)：客户端向服务端发送一个请求，服务端返回客户端一个流。客户端可以从这个流中读取，直到服务端关闭这个流：

  ```protobuf
  rpc ServerSideStreamingRPC(HelloRequest) returns (stream HelloResponse);
  ```

- 客户端流式RPC (*client-side streaming RPC*)：客户端向服务端发起一个流式请求。客户端可以向流中多次写入数据，服务端从流中多次取出数据，直到客户端关闭流。服务端接收完所有数据后，向客户端返回一个普通响应：

  ```protobuf
  rpc ClientSideStreamingRPC(stream HelloRequest) returns (HelloResponse);
  ```

- 双向流式RPC (*bidirectional streaming RPC*)：客户端向服务端发起一个流式请求，服务端向客户端返回一个流式响应。两个流之间相互独立，互不影响：

  ```protobuf
  rpc BidrectionalStreamingRPC(stream HelloRequest) returns (stream HelloResponse);
  ```

将需要定义的 RPC 调用写入 Service 字段：

```protobuf
service Greeter {
  rpc SimpleRPC(HelloRequest) returns (HelloResponse);

  rpc ServerSideStreamingRPC(HelloRequest) returns (stream HelloResponse);

  rpc ClientSideStreamingRPC(stream HelloRequest) returns (HelloResponse);

  rpc BidrectionalStreamingRPC(stream HelloRequest) returns (stream HelloResponse);
}
```

## 四、gRPC 示例

首先建一个 Go 的工程：

```go
go mod init grpcDemo
```

然后导入 gRPC 包：

```go
go get google.golang.org/grpc@latest
```

当前目录结构为：

```bash
.
├── go.mod
└── go.sum
```

### 1. 编写 protobuff 代码

新建一个 `pb` 目录，编写 `demo.proto` 文件：

```protobuf
syntax = "proto3";

option go_package = "./;pb";
package pb;

service Greeter {
  // 简单 RPC
  rpc SimpleRPC(HelloRequest) returns (HelloResponse);

  // 服务端流式 RPC
  rpc ServerSideStreamingRPC(HelloRequest) returns (stream HelloResponse);

  // 客户端流式 RPC
  rpc ClientSideStreamingRPC(stream HelloRequest) returns (HelloResponse);

  // 双端流式 RPC
  rpc BidrectionalStreamingRPC(stream HelloRequest) returns (stream HelloResponse);
}

message HelloRequest {string name = 1;}

message HelloResponse {string reply = 1;}
```

当前目录结构为：

```bash
.
├── go.mod
├── go.sum
└── pb
    └── demo.proto
```

通过以下命令将 `.proto` 文件生成 `.go` 文件：

```bash
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative pb/demo.proto
```

执行命令后会在当前文件夹下生成两个 `.go` 文件：

```bash
.
├── go.mod
├── go.sum
└── pb
    ├── demo.pb.go
    ├── demo.proto
    └── demo_grpc.pb.go
```

### 2. 编写 Go 代码

新建一个 `server`和`client` 目录，创建 `server.go`和`client.go` 文件进行服务端和客户端代码编写。

#### 2.1 Simple RPC

**服务端**

```go
package main

import (
	"context"
	"grpcDemo/pb"
	"log"
	"net"

	"google.golang.org/grpc"
)

type server struct {
    // 继承 protoc-gen-go-grpc 生成的服务端代码
	pb.UnimplementedGreeterServer
}

// SimplePRC 服务端代码
func (s *server) SimpleRPC(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
	log.Println("client call simpleRPC...")

	log.Println(in)
	return &pb.HelloResponse{Reply: "Hello " + in.Name}, nil
}

func main() {
    // 监听本地 5678 端口
	listen, err := net.Listen("tcp", ":5678")
	if err != nil {
		log.Fatal(err)
		return
	}

    // 创建 gRPC 服务器
	s := grpc.NewServer()
    // 将实现的接口注册进 gRPC 服务器
	pb.RegisterGreeterServer(s, &server{})
	log.Println("gRPC server starts running...")
    // 启动 gRPC 服务器
	err = s.Serve(listen)
	if err != nil {
		log.Fatal(err)
		return
	}
}
```

**客户端**

```go
package main

import (
	"context"
	"grpcDemo/pb"
	"io"
	"log"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func simpleRPC(c pb.GreeterClient) {
	ctx := context.Background()
    // 调用服务端 SimpleRPC 并获取响应
	reply, err := c.SimpleRPC(ctx, &pb.HelloRequest{Name: "simpleRPC"})
	if err != nil {
		log.Fatal(err)
	}
	log.Println(reply.GetReply())
}

func main() {
    // 连接服务端，因为我们没有SSL证书，因此这里需要禁用安全传输
	dial, err := grpc.Dial("127.0.0.1:5678", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatal(err)
		return
	}
	defer dial.Close()
	
	conn := pb.NewGreeterClient(dial)
	simpleRPC(conn)
}
```

当前目录结构：

```
.
├── client
│   └── client.go
├── go.mod
├── go.sum
├── pb
│   ├── demo.pb.go
│   ├── demo.proto
│   └── demo_grpc.pb.go
└── server
    └── server.go
```

分别使用两个终端运行服务端和客户端的代码:

```go
> go run server/server.go 
2022/10/27 08:55:59 gRPC server starts running...
2022/10/27 08:56:41 client call simpleRPC...
2022/10/27 08:56:41 name:"simpleRPC"

> go run client/client.go 
2022/10/27 08:56:41 Hello simpleRPC
```

#### 2.2  服务端流式 RPC

```go
// server.go
func (s *server) ServerSideStreamingRPC(in *pb.HelloRequest, stream pb.Greeter_ServerSideStreamingRPCServer) error {
	log.Println("client call ServerSideStreamingRPC...")
	words := []string{
		"你好",
		"hello",
		"こんにちは",
		"안녕하세요",
	}

	for _, word := range words {
		data := &pb.HelloResponse{
			Reply: word + " " + in.Name,
		}
		
        // 向流中不断写入数据
		if err := stream.SendMsg(data); err != nil {
			return err
		}
	}
	return nil
}
```

```go
// client.go
func serverSideStreamRPC(c pb.GreeterClient) {
	ctx := context.Background()
    // 调用服务端方法
	stream, err := c.ServerSideStreamingRPC(ctx, &pb.HelloRequest{Name: "gRPC!"})
	if err != nil {
		log.Fatal(err)
	}
	for {
		// 接收服务端返回的流式数据，当收到io.EOF或错误时退出
		res, err := stream.Recv()
        // 判断流是否关闭
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("got reply: %q\n", res.GetReply())
	}
}
```

分别使用两个终端运行服务端和客户端的代码:

```go
> go run server/server.go 
2022/10/27 09:02:59 gRPC server starts running...
2022/10/27 09:03:23 client call ServerSideStreamingRPC...

> go run client/client.go 
2022/10/27 09:03:23 got reply: "你好 gRPC!"
2022/10/27 09:03:23 got reply: "hello gRPC!"
2022/10/27 09:03:23 got reply: "こんにちは gRPC!"
2022/10/27 09:03:23 got reply: "안녕하세요 gRPC!"
```

#### 2.3 客户端流式 RPC

```go
// server.go
func (s *server) ClientSideStreamingRPC(stream pb.Greeter_ClientSideStreamingRPCServer) error {
	log.Println("client call ClientSideStreamingRPC...")
	reply := "Hello: "
	for {
        // 从流中接收客户端发送的数据
		res, err := stream.Recv()
        // 判断流是否关闭
		if err == io.EOF {
			return stream.SendAndClose(&pb.HelloResponse{Reply: reply})
		}

		if err != nil {
			return err
		}

		reply += ", " + res.GetName()
	}
}
```

```go
// client.go
func clientSideStreamRPC(c pb.GreeterClient) {
	ctx := context.Background()
    // 调用服务端方法
	stream, err := c.ClientSideStreamingRPC(ctx)
	if err != nil {
		log.Fatal(err)
	}

	names := []string{"a1", "a2", "a3", "a4"}
	for _, name := range names {
        // 向流中不断写入数据
		err := stream.Send(&pb.HelloRequest{Name: name})
		if err != nil {
			log.Fatal(err)
		}
	}

    // 向服务端发送关闭流的信号，并接收数据
	res, err := stream.CloseAndRecv()
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Reply)
}
```

分别使用两个终端运行服务端和客户端的代码:

```go
> go run server/server.go 
2022/10/27 09:17:04 gRPC server starts running...
2022/10/27 09:17:11 client call ClientSideStreamingRPC...

> go run client/client.go 
2022/10/27 09:17:11 Hello: , a1, a2, a3, a4
```

#### 2.4 双端流式 RPC

```go
// server.go
func (s *server) BidrectionalStreamingRPC(stream pb.Greeter_BidrectionalStreamingRPCServer) error {
	log.Println("client call BidrectionalStreamingRPC...")
	for {
        // 接收来自客户端的数据
		res, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}

		reply := "Hello " + res.GetName()
        // 向客户端发送数据
		if err := stream.Send(&pb.HelloResponse{Reply: reply}); err != nil {
			return err
		}
	}
}
```

```go
// client.go
func bidStreamRPC(c pb.GreeterClient) {
    // 调用服务端方法
	stream, err := c.BidrectionalStreamingRPC(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	names := []string{"a1", "a2", "a3", "a4"}
	for _, name := range names {
        // 向服务端发送数据
		err := stream.Send(&pb.HelloRequest{Name: name})
		if err != nil {
			log.Fatal(err)
		}

        // 从客户端接收数据
		reply, err := stream.Recv()
		if err != nil {
			log.Fatal(err)
		}
		log.Println(reply.GetReply())
	}

    // 关闭流
	err = stream.CloseSend()
	if err != nil {
		log.Fatal(err)
	}
}
```

分别使用两个终端运行服务端和客户端的代码:

```go
> go run server/server.go 
2022/10/27 09:20:51 gRPC server starts running...
2022/10/27 09:26:26 client call BidrectionalStreamingRPC...

> go run client/client.go 
2022/10/27 09:26:26 Hello a1
2022/10/27 09:26:26 Hello a2
2022/10/27 09:26:26 Hello a3
2022/10/27 09:26:26 Hello a4
```

### 3. gRPC 使用 Unix Socket 通信

gRPC 默认使用的是 TCP 通信。但是如果想仅仅在本机进行进程间通信，就没必要过一层网络接口了，直接使用 unix socket 即可。

```go
// server.go
package main
  
import (
        "context"
        "grpcDemo/pb"
        "log"
        "net"
        "os"

        "google.golang.org/grpc"
)

type server struct {
        pb.UnimplementedGreeterServer
}

// 实现 SimpleRPC 方法
func (s *server) SimpleRPC(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
        log.Println("client call simpleRPC...")
        log.Println(in)
        return &pb.HelloResponse{Reply: "Hello " + in.Name}, nil
}

// 移除存在的 unix socket 文件
func removeExistedSock(file string) {
        stat, err := os.Stat(file)
        if err == nil {
                if stat.Mode().Type() == os.ModeSocket {
                        err := os.Remove(file)
                        if err != nil {
                                log.Fatal(err)
                        }
                }
        }
}

func main() {
        removeExistedSock("/tmp/default.sock")
    	// 解析 unix socket 地址
        addr, err := net.ResolveUnixAddr("unix", "/tmp/default.sock")
        if err != nil {
                log.Fatal(err)
                return
        }
    	// 监听 unix socket 文件
        unix, err := net.ListenUnix("unix", addr)
        if err != nil {
                log.Fatal(err)
                return
        }

        s := grpc.NewServer()
    	// 绑定 unix socket 连接
        pb.RegisterGreeterServer(s, &server{})
    	log.Println("gRPC server starts running...")
    	// 启动服务
        err = s.Serve(unix)
        if err != nil {
                log.Fatal(err)
                return
        }
}
```

```go
package main
  
import (
        "context"
        "grpcDemo/pb"
        "log"
        "net"

        "google.golang.org/grpc"
        "google.golang.org/grpc/credentials/insecure"
)


func simpleRPC(c pb.GreeterClient) {
        ctx := context.Background()
        reply, err := c.SimpleRPC(ctx, &pb.HelloRequest{Name: "simpleRPC"})
        if err != nil {
                log.Fatal(err)
        }
        log.Println(reply.GetReply())
}

// 被 gRPC 框架调用，创建 unix socket 连接
func UnixConnect(ctx context.Context, addrs string) (net.Conn, error) {
        addr, err := net.ResolveUnixAddr("unix", addrs)
        if err != nil {
                return nil, err
        }
        conn, err := net.DialUnix("unix", nil, addr)
        if err != nil {
                return nil, err
        }
        return conn, nil
}

func main() {
    	// 创建 gRPC 连接客户端
        conn, err := grpc.Dial("/tmp/default.sock", grpc.WithTransportCredentials(insecure.NewCredentials()), grpc.WithContextDialer(UnixConnect))
        if err != nil {
                log.Fatal(err)
                return
        }
		
    	// 创建当前 protobuff 的客户端对象
        client := pb.NewGreeterClient(conn)
        simpleRPC(client)
}
```

分别使用两个终端运行服务端和客户端的代码:

```go
> go run server1/server.go 
2022/10/27 09:59:16 gRPC server starts running...
2022/10/27 10:01:47 client call simpleRPC...
2022/10/27 10:01:47 name:"simpleRPC"

> go run client1/client.go 
2022/10/27 10:01:47 Hello simpleRPC
```

