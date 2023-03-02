利用Python脚本一次性更新所有的库
```python
from subprocess import call
from pip._internal.utils.misc import get_installed_distributions

total = len(get_installed_distributions()) # 获取库的数量
for dist,count in zip(get_installed_distributions(), range(1, total + 1)):
  call("pip install --upgrade " + dist.project_name, shell=True) # 执行pip更新命令
  print("总计{}个库，正在更新第{}个库，还剩{}库待更新，请耐心等待…".format(total, count, total-count)) # 显示信息

print("更新完毕！")
```