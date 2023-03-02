# WIndows 共享个人应用

> Windows Server版拥有发布本地的应用为Remote App的能力。用户可以在本机使用远程主机上的应用，除Server版以外的Windows版本都默认不支持该功能，但通过下列操作可以使普通Windows同样开启此能力。
>
> 
>
> 实验环境：
>
> Windows版本：Windows 10 Education 20H2
>
> 硬件平台：x64
>
> termsrv.dll版本：10.0.19041.84

## 一、Windows 开启多用户同时访问


> 在个人 Windows 版本中是不提供像Windows Server的多用户同时访问主机的功能。如果不开启多用户访问功能，Windows桌面只能被一个用户连接，其他用户访问主机时，当前占据桌面的用户会被挤掉。
>
>  可以通过 **hook Windows 提供远程服务的 `C:\Windows\System32\termsrv.dll` 库文件**、**修改相关注册表**并**提供依赖程序**的方式可以使个人版本的Windows 提供多人同时访问主机的功能。
>

### 多用户访问开启实现思路流程

通过修改注册表将原有的termsrv.dll文件入口重定向至hook程序的dll文件上（后称为A文件），A文件将自己伪装成termsrv.dll,并对外提供与原接口一致的API调用方法，A文件在runtime运行时的执行步骤如下：

* 加载原有的termsrv.dll文件至内存

* 根据预先调研好的设定配置位置及值，修改内存中termsrv.dll相对偏移位置的内存值，使其具备多用户远程登录能力

* A文件的对外API透传到修改后的termsrv.dll执行，使对外表现为开启多用户远程登陆特性，达成目的

  **优点**：不需要更改windows的原始dll文件，影响小，不具备破坏性。

### 思路流程拆解

本流程实现中可以拆解为4个比较关键的步骤，分为4个关键小节依次进行说明具体实现

* 修改注册表，将dll导流至hook.dll
* hook.dll加载termsrv.dll之内存后修改4个位置的内存值，使termsrv.dll开启多用户登录模式
* 在windows 注册表，配置正确的用户访问策略
* 检查有无远程访问所需的依赖程序及库文件，如果没有，提供并放至指定路径下

#### 1、修改注册表，引流服务至hook.dll

![image-20220104181500037](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371995287819000.png)

#### 2、hook termsrv.dll, 修改内存值，使其开启多用户模式

##### Hook 程序思路

* `termsrv.dll`暴露了两个函数接口：`ServiceMain`和`SvchostPushServiceGlobals`，Hook 程序同样也需要暴露这两个函数接口。

* 当系统调用 Hook 程序的这两个接口时，首先将 `termsrv.dll`动态库加载到内存，冻结进程和线程的状态。Hook 程序再根据偏移量找到对应的 `termsrv.dll` 在内存中需要 Patch 点的地址，对 Patch 点进行修改，再恢复进程和线程的状态，再去调用 `termsrv.dll`文件对应的函数接口。

###### 附：修改位置查找方法

需要使用 IDA 对 `termsrv.dll`文件进行分析，找到修改的位置和修改的内容。

使用 IDA 打开 `termsrv.dll`，<img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371996863698000.png" alt="image-20211231163539598" style="zoom:50%;" />，找到 Header 值位置 `180000000`。

------

###### ✨Hook程序修改位置1：LocalOnlyPatch

**函数**：`CEnforcementCore::GetInstanceOfTSLicense(_GUID &,ITSLicense * *)`

该函数主要会对本地的 License 进行判断，需要让该函数不进行判断直接进行跳转。

**修改内容**：

需要将该函数此处的**比较跳转（JZ）修改为直接跳转（JMP）**：

<img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1640940565444559900.png" alt="image-20211231164923727" style="zoom:50%;" /><img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371995832106600.png" alt="image-20211231165052140" style="zoom: 150%;" />

修改前：

```assembly
.text:0000000180087611                 jz      short loc_180087657	// 74 44
```

修改后：

```assembly
.text:0000000180087611                 jmp     short loc_180087657	// EB 44
```

**偏移量**：`180087611` - `180000000` = `87611`

------


###### ✨Hook程序修改位置2：SingleUserPatch

**函数**：`CSessionArbitrationHelperMgr::IsSingleSessionPerUserEnabled(int *)`

该函数会判断当前主机是否只允许单用户进行会话连接，需要让该函数判断为允许多用户连接。

**修改内容**：

需要将此处传入值 1 修改为 0：

![image-20211231170503259](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641521828174369500.png)

![image-20220107101750144](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641521870209041400.png)  

修改前：

```assembly
.text:000000018000BFE0                 mov     dword ptr [rdx], 1		// C7 02 00 00 00 00
```

 修改后：

```assembly
.text:000000018000BFE0                 mov     dword ptr [rdx], 0		// C7 02 01 00 00 00
```

偏移量：`0BFE2`

------


###### ✨Hook程序修改位置3：DefPolicyPatch

**函数**：`CDefPolicy::Query(int *)`

该函数主要作用是设置最大远程连接数，这里让最大连接数设置为最大值（256）即可。

**修改内容**：

需要将**修改此处的比较、跳转语句修改为直接重设寄存器值语句**：

<img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1640941868379462900.png" alt="image-20211231171108299" style="zoom:50%;" /><img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371995833250000.png" alt="image-20211231171211874" style="zoom:80%;" />

修改前：

此处根据具体比较的寄存器和执行的跳转语句执行不同的预设语句

```assembly
.text:0000000180017ED5                 cmp     [rcx+63Ch], eax		\\ 39 81 3C 06 00 00
.text:0000000180017EDB                 jz      loc_18002D0BA		\\ 0F 84 D9	51 01 00
```

修改后：

```assembly
.text:0000000180017ED5                 mov     eax, 100h			\\ B8 00 01 00 00
.text:0000000180017EDA                 mov     [rcx+638h], eax		\\ 89 81 38 06 00 00
.text:0000000180017EE0                 nop							\\ 90
```

**偏移量**：`17ED5`

------


###### ✨Hook程序修改位置4：SLInitHook

函数：`CSLQuery::Initialize(void)`

修改内容：

通过全局关键字搜索找到该函数变量的存放区域：

![image-20211231173653900](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641523867678600600.png)

变量的值需要重设为：

```
bServerSku 			= 1
bRemoteConnAllowed 	= 1
bFUSEnabled 		= 1
bAppServerAllowed 	= 1
bMultimonAllowed 	= 1
lMaxUserSessions 	= 0
ulMaxDebugSessions 	= 0
bInitialized 		= 1
```

各变量的偏移量：

```
bInitialized.x64      =103FF8
bServerSku.x64        =103FFC
lMaxUserSessions.x64  =104000
bAppServerAllowed.x64 =104008
bRemoteConnAllowed.x64=104010
bMultimonAllowed.x64  =104014
ulMaxDebugSessions.x64=104018
bFUSEnabled.x64       =10401C
```

------


#### 3、配置windows 远程注册表配置项

##### 1. ServiceDll

服务端会根据该值查找处理 RDP 远程连接的 dll 库文件，我们需要将其替换为 Hook 的 dll 文件。

**位置**：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TermService\Parameters -> ServiceDll`

原始值：`%SystemRoot%\System32\termsrv.dll`

替换值：`{{rdpwrap.dll文件 所在路径}}`

##### 2. fDenyTSConnections

该值控制主机是否开启 Windows 远程桌面服务。`true`关闭远程服务，`false`开启远程服务。

位置：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server -> fDenyTSConnections`

##### 3. EnableConcurrentSessions

该值会管理主机是否允许多个用户远程登录并同时使用服务器。`true`开启并发会话，`false`关闭并发会话。

位置：

`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Licensing Core -> EnableConcurrentSessions`

##### 4. AllowMultipleTSSessions

该值控制主机是否允许多终端服务会话。`true`允许多用户，`false`不允许多用户。

位置：`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon -> AllowMultipleTSSessions`

##### 5. AddIns

位置：

配置剪贴板和客户端端口的重定向器。

**Clip Redirector**：

剪切板重定向器。

位置：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\AddIns\Clip Redirector`

![image-20220104155454043](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641282896195997800.png)

**DND Redirector**：

RDP 展示程序。

位置：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\AddIns\DND Redirector`

![image-20220104155511882](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371996462112500.png)

**Dynamic VC**：

Dynamic Virtual Channel。

位置：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\AddIns\Dynamic VC`

![image-20220104155536954](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371996872038300.png)

#### 4、补全缺失的依赖程序

由于开启多用户能力后，相较于某些系统版本（家庭版），缺少部分远程桌面使用的文件，需要在对应的位置配置文件的拷贝，让远程桌面能力能完整对外服务

##### 1. rdpclip.exe

该程序用于剪切板重定向，用于同步客户端和服务端的剪切板。

位置：`%SystemRoot%\System32\rdpclip.exe`

##### 2. rfxvmt.dll

该动态库包含远程桌面服务端程序。

位置：`%SystemRoot%\System32\rfxvmt.dll`

### 操作流程总结

1. 提取所需文件，包括：`rdpclip.exe`(存在则不管)、`rfxvmt.dll`(存在则不管)和`rdpwrap.dll`(Hook 程序，必须放在系统级目录下，不可放在用户目录内，这里选择路径为`C:\Program Files\Test\rdpwrap.dll`)；

2. 修改 `ServiceDll`注册表的值，将其替换为 Hook 程序的路径(`C:\Program Files\Test\rdpwrap.dll`)；

3. 修改注册表的值，正确配置远程桌面服务；

4. 开启防火墙 3389 端口；

5. 杀死 `TermService` 服务的进程；

6. 启动 `TermService` 服务，服务启动后会根据 `ServiceDll`的值加载 `rdpwrap.dll`程序，`rdowrap.dll` 程序则会去 Hook `termsrv.dll`文件（如果在Windows 服务管理中 `TermService` 服务配置为自动，那么可以不用手动重启，Windows 会自动重启该服务

   ![image-20220104170954585](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641371995711388400.png))。

## 二、开启单用户多会话模式

> 通过上一个步骤已经实现了多用户同时访问，但是每一个用户都只能存在一个会话连接，后建立的会话连接会挤掉先建立的会话连接。如果需要将主机上的应用共享给多个用户使用则必须要新建多个用户。
>
> 当开启了单用户多会话模式后，单个用户就可以建立多个会话连接，多个使用者可以通过同一个用户身份进行访问应用。

通过修改下列注册表配置项可以开启单用户多会话模式。

**fSingleSessionPerUser**

开启单用户多会话模式。`true`代表关闭单用户多会话模式，`false`代表开启单用户多会话模式。

位置：`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server -> fSingleSessionPerUser`

C:\Windows\System32\lusrmgr.msc

## 三、发布Remote App 应用

> Windows 远程桌面支持发布单个应用。可以通过修改配置表的方式选择需要发布的应用。

按下 `Win + R` 键，输入 `regedit` 进入注册表编辑，找到 `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList`，新建项(K)`Applications`：

<img src="http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641375435987023300.png" alt="image-20211227111624640"  />

这个`Applications`就是我们允许远程访问 App 的白名单。

下面演示添加一个测试应用：

1. 在 `Applications` 下面新建一个项(K)，取名为 `Test`
2. 为该项添加一个 字符串值 ，名字为`Path`，其值为 `C:\Windows\explorer.exe`(Windows 资源管理器)：![image-20211227112558072](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641375435373788600.png)
2. 重启主机，使相关配置项生效。

Windows 服务端更多配置项可查看官方文档：[Search | Microsoft Docs](https://docs.microsoft.com/en-us/search/?terms=Microsoft-Windows-TerminalServices&scope=OEM)

## 四、新建远程访问用户

首先新建一个用户：`Settings -> Accounts -> Family & other users -> Add someone else to this PC`

然后为新建的用户添加远程桌面权限：`Settings -> System -> Remote Desktop -> User accounts -> Select users that can remotely access this PC`

## 五、客户端连接

#### 相关配置项分析

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

#### RDP 文件编写

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
```

保存该文本为 `TestApp.rdp`，更多配置项可查看官方文档：[Supported Remote Desktop RDP file settings | Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/rdp-files)

## 六、访问远程应用

将上一步中编写的 rdp 文件复制到客户端，如果是 Windows 客户端则可以直接双击打开，如果非 Windows 端需要安装 WIndows 远程桌面客户端。

双击打开，输入新建的用户名和密码，就可以使用服务端的远程应用了：

![image-20220106110655367](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1641438567590380700.png)

