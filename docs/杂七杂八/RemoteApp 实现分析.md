# RemoteApp  实现分析

> 以下所说步骤都是基于 Windows 10 Education English 版本，不同 Windows 版本的操作可能会有一定差异！

## 一、原理分析

> Remote APP 是 Windows 的 RDP 功能原生支持的。通过配置服务端注册表相关配置项以及客户端 RDP 配置文件则可以实现发布应用发布。
>

当客户端与服务端建立远程连接时，客户端的`remoteapplicationprogram:s`可以传递别名或者绝对路径。

**别名**

当客户端传递别名时，服务端会去`Applications`去匹配别名，匹配失败则拒绝建立连接；匹配成功会根据匹配的项的 `Path`项的路径去打开指定文件，打开成功则建立连接，打开失败则拒绝建立连接。

**绝对路径**

当客户端传递的是绝对路径时，服务端会首先检查`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList` 的 `fDisabledAllowList`字段，该字段的值有以下两种：

| Value | Description                                                  |
| ----- | ------------------------------------------------------------ |
| 0     | Specifies that the Allow list is checked and enforced. This is the default setting. |
| 1     | Specifies that the Allow list is not checked and enforced.   |

当`fDisabledAllowList`值为1时，服务端会直接根据客户端传递的绝对路径尝试打开应用建立连接；

为 0 时，客户端进行远程连接时，服务端将客户端传递的绝对路径与 `Applications`目录下的项的`Path`匹配，如果匹配成功，则允许进行访问；如果不成功，则禁止访问。

| 客户端rdpfile --> remoteapplicationprogram | remote server reg --> TSAppAllowList               | fDisabledAllowList | 连通结果 |
| ------------------------------------------ | -------------------------------------------------- | ------------------ | -------- |
| 别名A                                      | 有配置为别名A的启动路径                            | 1                  | ok       |
| 别名A                                      | 有配置为别名A的启动路径                            | 0                  | ok       |
| 别名A                                      | 无配置为别名A的启动路径                            | 1                  | failed   |
| 别名A                                      | 无配置为别名A的启动路径                            | 0                  | failed   |
| 指定程序绝对路径                           | 所有配置项中 包含 客户端rdp file钟指定的启动路径   | 0                  | ok       |
| 指定程序绝对路径                           | 所有配置项中 包含 客户端rdp file钟指定的启动路径   | 1                  | ok       |
| 指定程序绝对路径                           | 所有配置项中 不包含 客户端rdp file钟指定的启动路径 | 1                  | ok       |
| 指定程序绝对路径                           | 所有配置项中 不包含 客户端rdp file钟指定的启动路径 | 0                  | failed   |

客户端 RDP 配置文件中的 `disableremoteappcapscheck`在置为1时，会在建立连接之前检查服务端是否对当前应用进行禁用；当值为 0 时会在建立连接之后再进行检查（一般情况下为 1 时的用户体验要好很多）。

## 二、原理验证

### 服务端

#### 1. 开启远程桌面

首先要在 Windows 设置中开启远程桌面服务：`Settings -> System -> Remote Desktop -> Enable Remote Desktop`

以下版本支持 WIndows 远程桌面：

| Windows 版本   | 支持的版本                                    | 不支持的版本                |
| :------------- | --------------------------------------------- | --------------------------- |
| Windows XP     | Professional                                  | Home                        |
| Windows 7      | Ultimate、Enterprise、Education               | Professional、Home、Starter |
| Windows 8      | Ultimate、Enterprise、Education               | Professional、Home、Starter |
| Windows 10     | Ultimate、Enterprise、Education、Professional | Home、Starter               |
| Windows Server | 2008、2012、2016、2019                        | 2003                        |

#### 2. 添加远程访问权限

首先新建一个用户：`Settings -> Accounts -> Family & other users -> Add someone else to this PC`

然后为新建的用户添加远程桌面权限：`Settings -> System -> Remote Desktop -> User accounts -> Select users that can remotely access this PC`

#### 3. 修改注册表

按下 `Win + R` 键，输入 `regedit` 进入注册表编辑，找到 `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList`，新建项(K)`Applications`：

![image-20220107145404436](https://pic.try-hard.cn/blog/image-20220107145404436.png)

这个`Applications`就是我们允许远程访问 App 的白名单。

下面演示添加一个测试应用：

1. 在 `Applications` 下面新建一个项(K)，取名为 `Test`

2. 为该项添加一个 字符串值 ，名字为`Path`，其值为 `C:\Windows\explorer.exe`(Windows 资源管理器)：

   ![image-20220107145416291](https://pic.try-hard.cn/blog/image-20220107145416291.png)

Windows 服务端更多配置项可查看官方文档：[Search | Microsoft Docs](https://docs.microsoft.com/en-us/search/?terms=Microsoft-Windows-TerminalServices&scope=OEM)

### 客户端

新建一个文本，写入以下配置文件：

```
allow desktop composition:i:1
allow font smoothing:i:1	
alternate full address:s:DESKTOP  		// 指定远程计算机的备用名称或IP地址
alternate shell:s:rdpinit.exe
devicestoredirect:s:*					// 确定本地计算机上的哪些设备将被重定向并在远程会话中可用; * 代表重定向所有受支持的设备，包括稍后连接的设备
disableremoteappcapscheck:i:1			// 提前检查远程 APP在服务端是否允许访问
drivestoredirect:s:*
full address:s:10.0.*.*					// 指定要连接到的远程计算机的名称或IP地址
prompt for credentials on client:i:1
promptcredentialonce:i:0
redirectcomports:i:1
redirectdrives:i:1
remoteapplicationmode:i:1				// 连接是否作为RemoteApp会话启动
remoteapplicationname:s:Test			// 客户端界面中指定RemoteApp的名称
remoteapplicationprogram:s:||Test		// RemoteApp的别名或绝对路径(加||代表使用别名)。别名指的是 Applications 下的项名
span monitors:i:1
use multimon:i:1
```

保存该文本为 `TestApp.rdp`，Windows 端可以直接双击打开，如果非 Windows 端需要安装 WIndows 远程桌面客户端。

双击打开，输入允许远程访问的用户名和密码，就可以使用服务端的远程应用了：

![image-20220107145430149](https://pic.try-hard.cn/blog/image-20220107145430149.png)

更多配置项可查看官方文档：[Supported Remote Desktop RDP file settings | Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/rdp-files)

