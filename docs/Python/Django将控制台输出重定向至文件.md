# Django 将控制台输出重定向至文件

```bash
python manage.py test > test.log 2>&1
```
使用该命令即可将在控制台的输出重定向至日志文件。