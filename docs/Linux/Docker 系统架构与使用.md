# Docker 系统架构与使用

## 一、整体架构

通过下图可以发现，Docker 系统主要包含客户端、服务端和仓库三大部分。

`Docker` 在运行时分为 `Docker 引擎（服务端守护进程）` 和 `客户端工具`，我们日常使用各种 `docker 命令`，其实就是在使用 `客户端工具` 与 `Docker 引擎` 进行交互：

![img](https://cdn.jsdelivr.net/gh/1314liuwei/figureBed/1631179825421890600.jpg)

## 二、Client

Docker 是一个客户端-服务器（C/S）架构程序。Docker 客户端只需要向 Docker 服务器或者守护进程发出请求，服务器或者守护进程将完成所有工作并返回结果。

Client 能够帮助我们使用命令行与 Docker 服务端进行交互，包括本地服务端和**远程服务端**：

通过`-H`参数可以指定客户端连接的服务端。

```bash
docker -H host
```

## 三、服务端（Docker 引擎）

服务端会启动一个守护进程，通过 `socket` 或者 `RESTful API` 接收来自客户端的请求，并且处理这些请求，实现对镜像和容器的操作。

### 镜像

**Docker 镜像** 是一个特殊的文件系统，它除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。

镜像 **不包含** 任何动态数据，其内容在构建之后也不会被改变。

因为镜像包含了完整的 root 文件系统，因此其体积往往是巨大的。为了解决这个问题，采用了 [Union FS (opens new window)](https://en.wikipedia.org/wiki/Union_mount)的技术，将其设计为分层存储的架构，由多层文件系统联合组成：

![img](https://pic.try-hard.cn/blog/1631179816285823100.png)

### 容器

镜像`Image`和容器`Container`的关系，就像是面向对象程序设计中的 `类` 和 `实例` 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的命名空间。因此容器可以拥有自己的 `root` 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。这种特性使得容器封装的应用比直接在宿主运行更加安全。

容器与镜像层一样也是分层结构的。每一个容器运行时，都是是以镜像为基础层，在其上创建一个当前容器的存储层，我们可以称这个为容器运行时读写而准备的存储层为 **容器存储层**。

容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失。容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。

所有的文件写入操作，都应该使用 **数据卷（Volume）**、或者 **绑定宿主目录**，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。

### 开放远程 API 接口

我们知道客户端是调用服务端的 API 接口实现对镜像和容器的管理。Docker 可以监听并处理 3 种 socket 形式的 API 请求，分别是`unix`（unix 域协议）、`tcp`（tcp 协议）和`fd`。

一般来说，在安装好 docker 后，默认就已经开启了`unix` socket，并且我们在执行需要有`root`权限或者`docker`用户组成员才有权限访问。

下面是通过 socket 文件与服务端通信：

```bash
curl --unix-socket /var/run/docker.sock  http://docker/version
```

输出：

```json
{
    "Platform":{
        "Name":"Docker Engine - Community"
    },
    "Components":[
        {
            "Name":"Engine",
            "Version":"20.10.8",
            "Details":{
                "ApiVersion":"1.41",
                "Arch":"amd64",
                "BuildTime":"2021-07-30T19:54:13.000000000+00:00",
                "Experimental":"true",
                "GitCommit":"75249d8",
                "GoVersion":"go1.16.6",
                "KernelVersion":"3.10.0-1160.41.1.el7.x86_64",
                "MinAPIVersion":"1.12",
                "Os":"linux"
            }
        },
        {
            "Name":"containerd",
            "Version":"1.4.9",
            "Details":{
                "GitCommit":"e25210fe30a0a703442421b0f60afac609f950a3"
            }
        },
        {
            "Name":"runc",
            "Version":"1.0.1",
            "Details":{
                "GitCommit":"v1.0.1-0-g4144b63"
            }
        },
        {
            "Name":"docker-init",
            "Version":"0.19.0",
            "Details":{
                "GitCommit":"de40ad0"
            }
        }
    ],
    "Version":"20.10.8",
    "ApiVersion":"1.41",
    "MinAPIVersion":"1.12",
    "GitCommit":"75249d8",
    "GoVersion":"go1.16.6",
    "Os":"linux",
    "Arch":"amd64",
    "KernelVersion":"3.10.0-1160.41.1.el7.x86_64",
    "Experimental":true,
    "BuildTime":"2021-07-30T19:54:13.000000000+00:00"
}
```

**开放远程 API** 

修改 docker 守护进程的配置文件`/lib/systemd/system/docker.service`

对下面这行进行修改：

```
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

修改为：

```
ExecStart=/usr/bin/dockerd -H unix://var/run/docker.sock -H tcp://0.0.0.0:2375
```

修改完成后重新加载：

```bash
# 重载 docker 服务
systemctl daemon-reload           # 重新加载守护进程配置
systemctl restart docker.service  # 重启 docker 服务

# 查看 docker 进程
ps -ef|grep docker

output:
root       3701      1  0 01:07 ?        00:00:00 /usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock
root       3834   2449  0 01:11 pts/0    00:00:00 grep --color=auto docker

# 开放防火墙2375端口
firewall-cmd --zone=public --add-port=2375/tcp --permanent	# 开放2375端口
firewall-cmd --reload	# 重载防火墙
firewall-cmd --list-all	# 查看开放端口

# 访问
curl http://{{ip}}:2375/version
```

### 数据管理

在上面的学习中我们了解到容器中的数据会随着容器生命周期的结束而消失。如果我们希望保存数据，那么就需要使用 **数据卷（Volume）**、或者 **绑定宿主目录**，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。

**数据卷（Volume）**

数据卷是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：

- 数据卷可以在容器之间共享和重用；
- 对数据卷的修改会立马生效；
- 对数据卷的更新，不会影响镜像；
- 数据卷默认会一直存在，即使容器被删除。

```bash
# 创建一个数据卷
docker volume create my-vol

# 查看所有数据卷
docker volume ls
DRIVER    VOLUME NAME
local     my-vol

# 查看数据卷的详细信息
docker volume inspect my-vol
[
    {
        "CreatedAt": "2021-09-09T02:04:14+08:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]
```

在用 `docker run` 命令的时候，使用 `--mount` 标记来将 `数据卷` 挂载到容器里。在一次 `docker run` 中可以挂载多个 `数据卷`。下面创建一个名为 `web` 的容器，并加载一个 `数据卷` 到容器的 `/usr/share/nginx/html` 目录：

```bash
# 拉取nginx的镜像
docker pull nginx

# 启动容器加载数据卷
docker run -d -p 80:80  --name web --mount source=my-vol,target=/usr/share/nginx/html nginx
```

在主机里使用以下命令可以查看 `web` 容器的信息：

```bash
docker inspect web

...
"Mounts": [
	{
		"Type": "volume",
		"Name": "my-vol",
		"Source": "/var/lib/docker/volumes/my-vol/_data",
		"Destination": "/usr/share/nginx/html",
		"Driver": "local",
		"Mode": "z",
		"RW": true,
		"Propagation": ""
	}
],
...
```

对容器内指定目录进行文件写入操作：

```bash
# 查看容器
docker container ls

# 进入容器
docker exec -it {{ID}} bash
# 写入文件
echo Hello World!>/usr/share/nginx/html/testFile
# 退出容器
exit

# 根据docker inspect web查询到的路径在主机查看文件
cat /var/lib/docker/volumes/my-vol/_data/testFile
Hello World
```

由于数据卷是被设计用来持久化数据的，它的生命周期独立于容器，因此 Docker 不会在容器被删除后自动删除数据卷，并且也不存在垃圾回收这样的机制来处理没有任何容器引用的数据。

使用下面命令删除数据卷：

```bash
# 删除指定数据卷
docker volume rm my-vol

# 清理无主数据卷
docker volume prune
```

**挂载主机目录**

为了使数据持久化，我们也可以选择将主机目录挂载到容器内。使用 `--mount` 标记可以指定挂载一个本地主机的目录到容器中去。

Docker 挂载主机目录的默认权限是 `读写`，用户也可以通过增加 `readonly` 指定为 `只读`，加了 `readonly` 之后，就挂载为 `只读` 了：

```bash
docker run -d -P --name web --mount type=bind,source=/src/webapp,target=/usr/share/nginx/html,readonly nginx
```

`--mount` 标记也可以从主机挂载单个文件到容器中。

### 四、Registry 仓库

镜像构建完成后，可以很容易的在当前宿主机上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，Docker Registry 就是这样的服务。

Docker 用 Registry 来保存用户构建的镜像。Registry 分为**公共**和**私有**两种。一个 **Docker Registry** 中可以包含多个 **仓库**（`Repository`）；每个仓库可以包含多个 **标签**（`Tag`）；每个标签对应一个镜像。Docker 公司运营公共的 Registry 叫做 Docker Hub。用户可以在 Docker Hub 注册账号，分享并保存自己的镜像。



> 参考资料：
>
> - [Docker 架构及工作原理 - 哈喽沃德先生 - 博客园 (cnblogs.com)](https://www.cnblogs.com/mrhelloworld/p/docker2.html#:~:text=Docker 是一个客户端-服务器（C%2FS）架构程序。. Docker 客户端只需要向 Docker 服务器或者守护进程发出请求，服务器或者守护进程将完成所有工作并返回结果。. Docker 提供了一个命令行工具,API。. 你可以在同一台宿主机上运行 Docker 守护进程和客户端，也可以从本地的 Docker 客户端连接到运行在另一台宿主机上的远程 Docker 守护进程。.)
> - [Docker — 从入门到实践 | Docker 从入门到实践 (docker-practice.com)](https://vuepress.mirror.docker-practice.com/)

