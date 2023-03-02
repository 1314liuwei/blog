# JetBrains系列Database报错：Can't find bundle for base name com.mysql.cj.LocalizedErrorMessages, locale zh_CN.

自己使用 Jetbrains 全家桶链接数据库时出现了`Can't find bundle for base name com.mysql.cj.LocalizedErrorMessages, locale zh_CN.`这个错误。

错误状态如图所示：

![案发现场](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20210122112318231.png)




这个错误的意思是说路径有问题，但是弄了很久都不知道是什么问题。

最好发现原来是驱动存放的路径问题：Database 模块下载的驱动是存放在 `C:\Users\用户名\AppData\Roaming\JetBrains\IntelliJIdea2020.3\jdbc-drivers\MySQL ConnectorJ\8.0.21`路径下的，自己之前取的用户名有问题，因此才会报出这个错误。

至于如何修改用户名大家就自行搜索一下吧，这里面坑太多了，大家要小心鉴别。我自己修改得教程也不放出来了，因为感觉还有点问题。。。。





这次的问题总结下来就是：**用户命名不规范，程序运行两行泪！**

给大家分享一下 Windows 命名的问题：

- 不要用中文！
- 不要有空格！！
- 不要有特殊字符！！！
- 命名就用纯粹的英文就行了！！！！