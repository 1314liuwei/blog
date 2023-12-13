# QQ 音乐 P2P 缓存清理

```basic
@echo off
set "targetPath=C:\Users\lynx\AppData\Roaming\Tencent\QQMusic\QQMusicCache\downloadproxyNew\tp2p\.tpfs"
set "processName=QQMusic.exe"

echo Killing process: %processName%
taskkill /F /IM "%processName%"

if exist "%targetPath%" (
    echo Deleting directory: %targetPath%
    rmdir /s /q "%targetPath%"
    echo Directory deleted.
) else (
    echo Directory not found: %targetPath%
)
```

