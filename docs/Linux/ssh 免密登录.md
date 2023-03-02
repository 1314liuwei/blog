# SSH 免密登录

## 前言

> 目标：Win10 免密登录 Centos
>
> Ps：在配置 ssh 免密登录前首先要保证客户机和服务器之间能够互相 ping，并且开放客户机和服务器的 22 端口（也可以设置端口转发），先尝试一下使用 ssh 是否能够登录，再来配置 ssh 免密登录。

## Windows

打开 cmd，输入 `ssh-keygen`配置好信息，系统会自动为我们生成公钥和私钥。文件位于 `C: \Users\(User)\.ssh`目录下，后续我们需要将`id_rsa.pub`文件上传至上传至服务器。

## Linux

同样是运行 `ssh-keygen`命令，并配置好信息，系统会为我们自动生成公钥和私钥。文件位于 `/user/.ssh/` 文件夹下。

## 配置文件

打开 Win10 的 cmd，利用 `scp` 命令将 `id_rsa.pub` 文件拷贝至 Linux 下，为了避免重名，我们将文件重命名一下：

```bash
scp id_rsa.pub root@192.168.153.134:/root/.ssh/id_rsa.pub.win
```

进入 Linux 终端，进入 `/root/.ssh/`目录下，将`id_rsa.pub.win`文件写入 `authorized_keys`，如果文件夹下没有 `authorized_keys`文件，则自行创建：

```bash
touch authorized_keys 					# 若没有文件则创建一个
cat id_rsa.pub.win >> authorized_keys 	# 追加内容到 authorized_keys 文件
```

此时再次打开 cmd，尝试 ssh 登录，发现此时已经不需要密码了。