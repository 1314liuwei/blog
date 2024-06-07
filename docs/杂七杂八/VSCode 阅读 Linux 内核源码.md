# VSCode 阅读 Linux 内核源码

## 最终效果

Windows 使用 VSCode 通过 SSH 远程阅读 Linux 内核源码。

## 搭建步骤

下载 Linux 源码，Linux 源码存放网站 https://cdn.kernel.org/pub/linux/kernel/:

```bash
curl -L https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.tar.xz  -o /root/linux-5.15.tar.xz

tar -xvf linux-5.15.tar.xz
```

从 VSCode 插件市场下载 Remote - SSH 插件：

![image-20240607125633514](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2024/06/07/20240607-125635.png)

