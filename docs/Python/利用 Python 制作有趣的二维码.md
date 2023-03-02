# 利用Python制作有趣的二维码

# 一、效果图

![CSDN](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20191001231547317.gif)
# 二、程序分析
近年来二维码已经在我们的生活中普及，并且在日常生活中扮演着重要角色。大家在日常生活中见到的二维码都是怎样的呢？我相信大家看到的大部分都是黑白的，今天我就来教大家怎样用Python来制作属于我们自己的二维码！
我们今天制作二维码用到的是一个第三方库：myqr
我们在这里通过pip的方法安装这个库，打开我们的命令提示符窗口，输入:`pip install myqr`然后回车就可以进行库的安装了（注意pip的方法需要连接网络）。
在我们的Python代码第一行依然是导入库：
```python
from MyQR import myqr
```
然后就要开始写我们的代码了，myqr这个库里面只有一个函数：myqr.run()
在里面传递不同的参数就可以实现不同的功能，下面这段代码就会生成一个黑白的二维码，扫描二维码就会出现“Life is short I use Python!”的字样(注意！这个库只能接收英文字符）：
```python
myqr.run(words="Life is short I use Python!")
```
# 三、源代码
```python
from MyQR import myqr
myqr.run(words="Life is short I use Python!")
'''
其他参数及其作用:
名字			  功能 			   传递值
words        二维码包含的内容    str
version      边长              int（1~40）
level        纠错等级           str(L,M,Q,H)
picture      结合图片地址        str
colorized    颜色               True为彩色
contrast     对比度             float(1.0代表原始图片)
brightness   亮度               float(1.0代表原始值)
save_name    输出名字           str(默认"qrcode.jpg")
save_dir     输出路径           str(默认在当前路径)
'''
```
今天的代码分析就到这里了，小伙伴们快去试一下吧！