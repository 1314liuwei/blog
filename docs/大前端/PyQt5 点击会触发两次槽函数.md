# PyQt5 点击会触发两次槽函数

# Bug

编写 PyQt5 GUI 程序时，定义了一个槽函数，在实际触发过程中会两次触发该槽函数，例子：
```python
import sys

from PyQt5.QtCore import pyqtSlot
from PyQt5.QtWidgets import QApplication, QMainWindow

from mainwindow import Ui_MainWindow


class QmyMainWindow(QMainWindow):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

    def on_action_triggered(self):
        print('triggered')

    def on_pushButton_clicked(self):
        print('clicked')
    
    def on_pushButton_pressed(self):
        print('pressed')
        

if __name__ == "__main__":
    app = QApplication(sys.argv)
    form = QmyMainWindow()
    form.show()
    sys.exit(app.exec_())
```
上面得例子中，无论是点击 pushButton 还是说点击 action ，结果都是会进行两次打印，但是点击 pushButton_2 时却只会触发一次槽函数。
# 出现原因
经过测试发现，会两次触发的都是拥有同名函数的槽函数，例如：**clicked 和 triggered**。由于该槽函数拥有两种信号，一种带参数一种不带参数。当不对槽函数进行限制时，不带参数的槽函数就会以为有两个信号，因此会触发两次。
# 解决办法
**对槽函数参数加上限制后，不带参数的槽函数只会接收不带参数的槽函数信号，则槽函数只会触发一次。**

*修改后代码：*
```python
import sys

from PyQt5.QtCore import pyqtSlot
from PyQt5.QtWidgets import QApplication, QMainWindow

from mainwindow import Ui_MainWindow


class QmyMainWindow(QMainWindow):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

    @pyqtSlot()
    def on_action_triggered(self):
        print('triggered')

    @pyqtSlot()
    def on_pushButton_clicked(self):
        print('clicked')
    
    def on_pushButton_2_pressed(self):
        print('pressed')

if __name__ == "__main__":
    app = QApplication(sys.argv)
    form = QmyMainWindow()
    form.show()
    sys.exit(app.exec_())

```
 **查看 pyqtSlot 的官方文档：[链接](https://www.riverbankcomputing.com/static/Docs/PyQt5/signals_slots.html#the-pyqtslot-decorator)**