# Go 编译优化

## 前言

减小编译后的二进制的体积，能够加快程序的发布和安装过程。

接下来我们将通过 go 编译选项和第三方工具学习如何减少编译后二进制的体积。

## 一、添加编译选项

Go 编译器默认编译出来的程序会带有符号表和调试信息，一般来说 release 版本可以去除调试信息以减小二进制体积：

```bash
go build -ldflags="-s -w" -o main main.go
```

参数详解：

- `-s`: 忽略符号表和调试信息；
- `-w`: 忽略DWARFv3调试信息，使用该选项后将无法使用 `gdb` 进行调试。

## 二、使用 upx 减小体积

[upx](https://github.com/upx/upx) 是一个常用的压缩动态库和可执行文件的工具，支持 Windows 和 Linux，通常可减少 50-70% 的体积。

Centos安装方法：

```bash
# 1. 安装 ucl
wget -c http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el7/en/x86_64/rpmforge/RPMS/ucl-1.03-2.el7.rf.x86_64.rpm
rpm -Uvh ucl-1.03-2.el7.rf.x86_64.rpm
yum install ucl

# 2. 安装 upx
wget -c http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el7/en/x86_64/rpmforge/RPMS/upx-3.91-1.el7.rf.x86_64.rpm
rpm -Uvh upx-3.91-1.el7.rf.x86_64.rpm
yum install upx
```

upx 有很多参数，最重要的则是压缩率，`1-9`，`1` 代表最低压缩率，`9` 代表最高压缩率。我们可以先添加编译选项优化再使用 upx 进行压缩：

```bash
go build -ldflags="-s -w" -o main main.go && upx -9 main
```

> 参考：
>
> [减小 Go 代码编译后的二进制体积 | Go 语言高性能编程 | 极客兔兔 (geektutu.com)](https://geektutu.com/post/hpg-reduce-size.html)

