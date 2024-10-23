在在 `Dockerfile` 中执行命令

```dockerfile
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
```

时出现 `Hash Sum mismatch` 问题。

此时需要进行换源，当前我换为中科大源：

```dockerfile
RUN sed -i s@/archive.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list && apt-get update
```

换源之后问题解决。
