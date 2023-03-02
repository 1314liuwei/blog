# PyQt5——创建自己的第一个 GUI 程序

# 一、Qt

## 1. 关于Qt
> Qt 是一个1991年由Qt Company开发的跨平台C++图形用户界面应用程序开发框架。它既可以开发GUI程序，也可用于开发非GUI程序，比如控制台工具和服务器。

Qt 的许可证分为商业许可和开源许可，开源许可的 Qt 就已经包含非常丰富的功能模块，足够我们学习使用。
**点击进入：[Qt 官方网站](https://www.qt.io/)**
## 2. 关于 PyQt5
> PyQt 是Qt C++ 类库的 Python 绑定，PyQt5 对应 Qt5 类库。Qt 发行新版本后，PyQt5就会推出跟进的新版本。

使用 PyQt5 可以充分利用 Qt 的应用程序开发框架和功能丰富的类设计 GUI 程序。

安装 PyQt5 库:
```pip install PyQt5```
正确执行该命令后 Python 就会安装好 **PyQt5** ，并且会自动安装依赖的 **SIP** 包（SIP 包是一个将 C/C++ 库转换为 Python 绑定的工具）。

安装完成后，在 Python 安装目录下的 **D:\\Python\\Scripts\\** 文件夹内会增加 **pylupdate5.exe、pyrcc5.exe和pyuic5.exe** 这三个可执行文件，这三个可执行文件的作用分别如下：
- pyuic5.exe：将Qt Designer生成的可视化设计的界面文件(.ui文件)文件编译转换为 Python 程序文件(.py文件)
- pyrcc5.exe：将Qt Creator里设计的资源文件(.qrc文件)编译转换为 Python 程序文件(.py文件)
- pylupdate5.exe：这是多语言界面设计时编辑语言资源文件的工具软件

因为"D:\Python\Scripts\" 目录被添加到了 PATH环境变量 中，因此这三个可执行文件可以直接在 cmd 中运行。
**PyQt5 参考手册：[链接](https://www.riverbankcomputing.com/static/Docs/PyQt5/sip-classes.html)**
# 二、第一个 PyQt5 GUI 程序
话不多说，先上代码：

```python
import sys
import time
from PyQt5 import QtCore, QtGui, QtWidgets

app = QtWidgets.QApplication(sys.argv)    # 创建app, 用QApplication类
widgetHello = QtWidgets.QWidget()         # 创建窗体, 用QWidget类
widgetHello.resize(500, 150)              # 设置窗体的宽度和高度
widgetHello.setWindowTitle('Demo2_1')     # 设置窗体的标题文字

LabHello = QtWidgets.QLabel(widgetHello)  # 创建标签, 父容器为widgetHello
LabHello.setText('Hello World, PyQt5!')   # 设置标签文字

font = QtGui.QFont()          # 使用QFont类创建字体对象font
font.setPointSize(12)         # 设置字体大小
font.setBold(True)            # 设置为粗体

LabHello.setFont(font)        # 设置为标签LabHello的字体
size = LabHello.sizeHint()    # 获取LabHello的合适大小, 得到一个size对象
LabHello.setGeometry(70, 60, size.width(), size.height())

widgetHello.show()   # 显示对话框
sys.exit(app.exec_())  # 运行程序
```
观察程序，我们可以发现创建的这个 PyQt5 的 GUI 程序，经历了以下几个步骤：
1. 导入 PyQt5 的相应模块
2. 使用 **QApplication类** 创建了一个应用程序（QApplication是管理 GUI 应用程序的控制流程和设置的类）
3. 使用 **QWidget类** 创建了一个窗体对象 widgetHello。然后使用 resize() 方法更改窗体大小，调用 setWindowTitle() 方法
设置窗体标题（这两步都不是必须的）
4. 使用 **QLable类** 创建了一个标签对象，并将 widgetHello 对象传递给 QLabel 构造函数。这一步实际上是指定 widgeHello 成为 LabHello 的父容器，这样 LabHello 才能够显示在 widgetHello 上。后面使用 QLabel 对 Label 进行相应属性设置
5. 最后就开始显示窗体（即最后两行代码）

至此，我们就已经创建好一个 PyQt5 的 GUI 程序了！
都快去试试吧！
![在这里插入图片描述](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200324143827769.png)