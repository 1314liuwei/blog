# PyQt5 使用多个槽函数时程序卡死

# 问题

利用 PyQt5 制作窗体时，使用多个槽函数时程序出现卡死
# 异常信息
```python
TypeError: on_chkBoxBold_clicked() missing 1 required positional argument: 'checked'
```
# 原因
有两个不同类型参数的 **clicked** 信号时，**connectSlotsByName()** 函数进行信号与槽函数关联时会使用一个默认的信号。
这对于 QCheckBox 来说，**默认使用的是不带参数的 clicked() 信号**。但是 **on_chkBoxBold_clicked()** 是需要接收一个参数作布尔判断的，因此会出现上述错误。
# 解决办法
使用 **@pyqtSlot** 装饰器，这个装饰器会声明函数的参数类型，这样 **connectSlotsByName()函数** 就会自动和 **clicked(bool) 信号**关联，运行时就不会出现问题了。
# 代码
```python
from PyQt5.QtCore import pyqtSlo

@pyqtSlot(bool)
def on_checkBoxBold_clicked(checked):
	pass
```