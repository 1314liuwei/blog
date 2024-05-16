# Python 利用whl文件安装外部模块

由于pip下载的时候容易遇墙而导致下载失败，这个时候我们可以预先下载好whl包，用whl包进行安装。
whl后缀的压缩包和普通的压缩包没什么区别，只是方便Python使用pip方式安装。

 - [ ] 下面安装环境为win10，Python版本3.7

 首先把whl文件放到**D:\python3.7\Lib\site-packages**下，然后切换盘符到当前文件夹，然后输入
 `pip install 安装包名字.whl`
当出现Sucessfully时则表明安装成功。

> 安装时的一个小技巧：输入安装包的首字母再按Tab键文件名就会自动补全
> ![在这里插入图片描述](https://pic.try-hard.cn/blog/20191114001506717.png)

