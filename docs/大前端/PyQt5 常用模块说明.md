# PyQt5 常用模块说明

PyQt5 是Qt C++ 类库得一个 Python 绑定，它包含多种模块，在 PyQt5 库安装后，可以在 **"D:\Python\Lib\site-pakages\PyQt5"** 下看到所有模块的文件。

PyQt5 中常用模块：

|  **PyQt5 模块名**   |                         **主要功能**                         |                       **包含的类示例**                       |
| :-----------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|       QtCore        |       提供核心的非 GUI 功能的类，包括常用的名称空间Qt        | QFile、QDir、QTimer 等 Qt 中的非界面组件组件类；包含各种枚举类型的名称空间Qt；pyqtSlot、pyQtSignal 等在 PyQt5 中引入的函数 |
|        QtGui        |  提供 GUI 设计中用于窗口系统集成、事件处理、绘图等功能的类   | QIcon、QFont、QPixMap、QCloseEvent、QPalette、QPainter等底层实现类 |
|      QtWidgets      | 提供 GUI 设计中用于窗体显示的类，包括各种窗体、标准对话框、按钮、文本框等组件 | QMainWindow、QWidget、QDialog 等窗体；QColorDialog、QFileDialog等标准对话框 |
|    QtMultimedia     |                提供音频、视频、摄像头操作的类                |             QCamera、QAudioInput、QMedaiPlayer等             |
| QtMultimediaWidgets |                    提供多媒体窗体显示的类                    |              QCameraViewfinder、QVideoWidget等               |
|        QtSql        |           提供 SQL 数据库驱动、数据查询和操作的类            |            QSqlDatabase、QSqlQuery、QSqlRecord等             |

查询更多 PyQt5 模块的信息：[官网](https://www.riverbankcomputing.com/static/Docs/PyQt5/sip-classes.html)

