# 解决 "make: warning: Clock skew detected. Your build may be incomplete." 问题

执行 `make` 命令时出现`make: warning: Clock skew detected. Your build may be incomplete.`。

这是由于不同设备系统之间的时间上存在差距，`make` 命令检测到时钟偏差。

解决方案：

```bash
find ./ -type f |xargs touch
```

将所有文件都重新touch一遍，更新到本地系统的时间，再make就没问题了。