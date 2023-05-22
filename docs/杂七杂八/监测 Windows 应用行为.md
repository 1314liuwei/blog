# 监测 Windows 应用行为

> 当我们安装、运行 Windows程序时，程序可能会包含创建文件夹、修改注册表等一系列行为。但是大部分应用程序的这些行为对于使用者来说都是不可见的。

当我们需要监控一个应用程序干了哪些事情，就可以使用工具： `Wise Installation System`。该应用程序通过拍摄快照、对比快照的方式可以来展示程序的行为。

安装：

![image-20220107144346050](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107144346050.png)

选择`SetupCapture`：

![image-20220107144410330](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107144410330.png)

勾选设置：

![image-20220107144424715](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107144424715.png)



对当前主机内容拍摄快照：

![image-20220107144918746](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107144918746.png)

执行需要观测的程序：

![image-20220107145012378](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107145012378.png)

执行操作后再观测当前主机状态：

![image-20220107145120954](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107145120954.png)

完成后就可以在此处看到这个过程中主机更改的信息了：

![image-20220107145209016](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/image-20220107145209016.png)