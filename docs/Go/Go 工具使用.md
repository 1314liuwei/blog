# Go 工具使用

## 查看可执行文件信息

```bash
go version -m .\app.exe
```

## 反汇编

```bash
# 查看所有代码 
go tool objdump -S .\app.exe

# 查看单个包
go tool objdump -s "main" .\app.exe

# 查看单个函数
go tool objdump -s "main.main" .\app.exe
```

