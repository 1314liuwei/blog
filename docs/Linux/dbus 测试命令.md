# DBUS 测试命令

```bash
# 修改时区为 Asia/Shanghai
dbus-send --system --type=method_call --print-reply --dest=org.freedesktop.timedate1 /org/freedesktop/timedate1 org.freedesktop.timedate1.SetTimezone string:Asia/Shanghai boolean:true

# 修改时区为 U
dbus-send --system --type=method_call --print-reply --dest=org.freedesktop.timedate1 /org/freedesktop/timedate1 org.freedesktop.timedate1.SetTimezone string:UTC boolean:true
```
