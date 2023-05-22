# 解决 hexo init 失败问题

## 问题描述

准备使用 hexo 搭建个人博客，执行 hexo init 后失败，错误内容为：

```
A:\桌面\hexo>hexo init try-hard.cn
INFO  Cloning hexo-starter https://github.com/hexojs/hexo-starter.git
error: RPC failed; curl 28 OpenSSL SSL_read: Connection was reset, errno 10054
fatal: expected flush after ref listing
WARN  git clone failed. Copying data instead
FATAL {
  err: [Error: ENOENT: no such file or directory, scandir 'C:\Users\Blogger\AppData\Roaming\npm\node_modules\hexo-cli\assets'] {
    errno: -4058,
    code: 'ENOENT',
    syscall: 'scandir',
    path: 'C:\\Users\\Blogger\\AppData\\Roaming\\npm\\node_modules\\hexo-cli\\assets'
  }
} Something's wrong. Maybe you can find the solution here: %s http://hexo.io/docs/troubleshooting.html
```

根据错误，大概率是因为 GitHub 被墙导致网络连接失败。

网上搜索了一下，大家的解决办法大多都是挂梯子，对于我这种没有梯子的人来说就有点绝望了。。。

## 解决办法：替换 GitHub 链接

对于国内无法正常克隆 GitHub 仓库，可以通过替换 GitHub 链接来解决。不知道的朋友可以参看我的这篇博文：[GitHub 克隆加速](https://blog.csdn.net/qq_43580193/article/details/117341242)。

那么我们只要替换掉 hexo 的 GitHub 链接就可以正常运行 hexo 了。

经过查找，发现 hexo 的 npm 模块在 Windows 环境下是在这个路径下：C:\Users\Blogger\AppData\Roaming\npm\node_modules\hexo-cli\lib\console

在这个文件夹下有一个 init.js 文件，打开文件

```js
将 
const GIT_REPO_URL = 'https://github.com/hexojs/hexo-starter.git';
替换为：
const GIT_REPO_URL = 'https://github.com.cnpmjs.org/hexojs/hexo-starter.git';
```

再次运行 hexo init ，成功！

