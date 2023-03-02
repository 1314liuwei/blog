# Docker 基础使用

## 一、获取镜像

`docker pull`命令可以从镜像仓库上拉取仓库：

```bash
docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
```

- Docker 镜像仓库地址：地址的格式一般是 `<域名/IP>[:端口号]`。默认地址是 Docker Hub(`docker.io`)；
- 仓库名：如之前所说，这里的仓库名是两段式名称，即 `<用户名>/<软件名>`。对于 Docker Hub，如果不给出用户名，则默认为 `library`，也就是官方镜像。

 *Docker Hub 下载镜像非常缓慢，通过配置加速器来实现提速。*

示例（拉取 nginx）镜像：

```bash
# 搜索 nginx 镜像
$ docker search nginx 

# 拉取镜像
$ docker pull nginx

# 查看本地镜像
$ docker images
```

## 二、启动容器

有了镜像后，我们就能够用 `docker run` 命令以这个镜像为基础启动并运行一个容器。

以上面的 `nginx` 为例，如果我们打算启动里面的 nginx 并且进行交互式操作的话，可以执行下面的命令：

```bash
$ docker run -d -p 80:80 nginx
```

此时访问服务器地址就可以看到 nginx 的欢迎界面了。

参数详解：

- `-d`：后台运行容器，并返回容器ID；
- `-i`：以交互模式运行容器，通常与 -t 同时使用；
- `-t`：为容器重新分配一个伪输入终端，通常与 -i 同时使用。

## 三、进入容器

假如说我们这个时候想修改nginx 的欢迎页面，那么我们需要使用 `docker exec`（不推介 `docker attach`）进入容器内部进行修改。

```bash
# 列出运行的容器
docker container ls

# 根据容器 ID 进入容器内部
docker exec -it 8d1 bash
root@8d188247eafc:/# echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
root@8d188247eafc:/# exit
exit
```

此时再访问服务器，我们就发现 nginx 的欢迎界面已经发生改变了。

参数详解：

`docker exec` 后边只用 `-i` 参数时，由于没有分配伪终端，界面没有我们熟悉的 Linux 命令提示符，但命令执行结果仍然可以返回。当 `-i` `-t` 参数一起使用时，则可以看到我们熟悉的 Linux 命令提示符。

如果从这个 stdin 中 exit，不会导致容器的停止。这就是为什么推荐大家使用 `docker exec` 的原因。

## 四、定制镜像

在上面的流程中，我们先启动了一个镜像，再进入命令行内部修改 nginx 的欢迎页。如果我们后续还会在其他地方运行 nginx 并修改欢迎页，如果还是采取上面的方式就会显得太繁琐了。

这个时候我们可以选择使用 `Dockerfile` 来定制一个属于我们的镜像：

新建 `Dockerfile` 文件，输入以下内容：

```dockerfile
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

这个 Dockerfile 很简单，一共就两行。涉及到了两条指令，`FROM` 和 `RUN`：

- `FROM`: 所谓定制镜像，那一定是以一个镜像为基础，在其上进行定制。就像我们之前运行了一个 `nginx` 镜像的容器，再进行修改一样，基础镜像是必须指定的。而 `FROM` 就是指定 **基础镜像**，因此一个 `Dockerfile` 中 `FROM` 是必备的指令，并且必须是第一条指令。
  除了选择现有镜像为基础镜像外，Docker 还存在一个特殊的镜像，名为 `scratch`。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。

- `RUN`：`RUN` 指令是用来执行命令行命令的。由于命令行的强大能力，`RUN` 指令在定制镜像时是最常用的指令之一。其格式有两种：

  - *shell* 格式：`RUN <命令>`，就像直接在命令行中输入的命令一样。刚才写的 Dockerfile 中的 `RUN` 指令就是这种格式；

  ```docker
  RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
  ```

  - *exec* 格式：`RUN ["可执行文件", "参数1", "参数2"]`，这更像是函数调用中的格式。

  **注意：**Dockerfile 中每一个指令都会建立一层，`RUN` 也不例外。每一个 `RUN` 的行为，就和刚才我们手工建立镜像的过程一样：新建立一层，在其上执行这些命令，执行结束后，`commit` 这一层的修改，构成新的镜像。因此我们在构建时不要写过多的 `RUN`，避免其构建多层镜像造成冗余。

`Dockerfile` 文件书写完成后就可以使用`docker build`命令进行构建了：

```bash
# 构建镜像，别忘了命令最后面有一个点
docker build -t nginx:v3 .

# 查看所有镜像
docker images
```

构建好镜像之后我们就可以启动容器了：

```bash
# 将端口映射到 81 端口
docker run -d -p 81:80 nginx:v3
```

此时访问服务器的 81 端口就可以看到修改后的 nginx 欢迎页面了。

## 五、终止容器

现在我们需要终止上面流程运行的容器，此时我们可以使用`docker container stop`命令终止容器：

```bash
# 查看运行的容器
docker container ls

# 根据 id 终止容器
docker container stop id

# 查看所有容器，包括已经终止的容器
docker container ls -a
```

## 六、删除容器

我们可以用`docker container rm`来删除**已经被终止的容器**，如果要删除一个运行中的容器，可以添加 `-f` 参数。Docker 会发送 `SIGKILL` 信号给容器。

如果需要删除的容器较多，我们可以使用`docker container prune`命令删除所有已经被终止的容器。

