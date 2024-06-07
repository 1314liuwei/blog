# VSCode 阅读 Linux 内核源码

## 最终效果

Windows 使用 VSCode 通过 SSH 远程阅读 Linux 内核源码。

## 搭建步骤

下载 Linux 源码，Linux 源码存放网站 https://cdn.kernel.org/pub/linux/kernel/:

```bash
curl -L https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.tar.xz  -o /root/linux-5.15.tar.xz

tar -xvf linux-5.15.tar.xz
```

在 Linux 主机上安装 `global`：

```bash
apt install global
```

从 VSCode 插件市场下载 Remote - SSH 插件：

![image-20240607125804485](http://pic.try-hard.cn/blog/2024/06/07/20240607-125805.png)

使用 Remote - SSH 连接到 Linux，打开一个新的窗口，然后在远程主机上安装 C/C++ 和 C/C++ GNU Global 插件：

![image-20240607134840641](http://pic.try-hard.cn/blog/2024/06/07/20240607-134841.png)

![image-20240607134857997](http://pic.try-hard.cn/blog/2024/06/07/20240607-134858.png)

在 Settings 中配置 `global` 的路径，注意 `gnuGlobal.objDirPrefix`要提前创建好文件夹：

```json
{
    "gnuGlobal.globalExecutable": "/usr/bin/global",
    "gnuGlobal.gtagsExecutable": "/usr/bin/gtags",
    "gnuGlobal.objDirPrefix": "/root/linux-5.15/.global"
}
```

然后再配置 `C/C++` include 路径：

```json
{
	...
    "C_Cpp.default.includePath": [
        ".",
        "./include"
    ]
}
```

再在 VSCode 中按 `Ctrl + Shift + P` 执行 `Global: Rebuild Gtags Database` 命令。当出现 `Build tag files successfully` 时代表符号已经解析完毕。

解析完毕后 `gnuGlobal.objDirPrefix` 路径下会生成如下文件：

```bash
root@ubuntu:~/linux-5.15/.global# tree
.
└── root
    └── linux-5.15
        ├── GPATH
        ├── GRTAGS
        └── GTAGS

2 directories, 3 files
```



上面步骤执行完毕后就可以使用 VSCode 进行愉快地查看 Linux 代码了！
