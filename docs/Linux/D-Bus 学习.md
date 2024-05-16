# D-Bus 学习

## 一、背景知识

> D-Bus是一种高级的进程间通信机制（interprocess communication，IPC），它由freedesktop.org项目提供，使用GPL许可证发行。
>
> D-Bus最主要的用途是在 Linux 桌面环境为进程提供通信，同时能将 Linux 桌面环境和 Linux 内核事件作为消息传递到进程。D-Bus(其中D原先是代表桌面“Desktop” 的意思)，即：用于桌面操作系统的通信总线。现在逐渐被引入到嵌入式系统中，不过名字还是保留原先的叫法而已。
>
> D-Bus的主要概念为总线，注册后的进程可通过总线接收或传递消息，进程也可注册后等待内核事件响应，例如等待网络状态的转变或者计算机发出关机指令。

## 二、主要特性

### 1. 结构层次

DBUS 由如下三个层次构成：

- **libdbus**: 接口库，提供点对点通信和数据交换的能力；

- **守护进程**: 即dbus daemon进程，提供多对多的通信机制，进程与daemon建立dbus连接，由daemon进行消息的分发；
- **封装库**: DBUS 由如下三个层次构成，如[dbus-glib](http://dbus.freedesktop.org/doc/dbus-glib/index.html)/[GDBus](https://developer.gnome.org/gio/2.42/gdbus-lowlevel.html), [QtDBus](http://qt-project.org/doc/qt-5/qtdbus-module.html)。

DBus是低时延且低消耗的，为了最小化传送的往返时间，它被设计得小而高效。它的协议是二进制的，而不是文本的，这样就排除了费时的序列化过程。

### 2. 系统总线和会话总线

在一台机器上总线守护有多个实例(instance)。这些总线之间都是相互独立的。

- *一个持久的系统总线（system bus）*

  它在引导时就会启动。这个总线由操作系统和后台进程使用，安全性非常好，以使得任意的应用程序不能欺骗系统事件。 它是桌面会话和操作系统的通信，这里操作系统一般而言包括内核和系统守护进程。 这种通道的最常用的方面就是发送系统消息，比如：插入一个新的存储设备；有新的网络连接；等等。

- *还将有很多会话总线（session buses）*

  这些总线当用户登录后启动，属于那个用户私有。它是用户的应用程序用来通信的一个会话总线。 同一个桌面会话中两个桌面应用程序的通信，可使得桌面会话作为整体集成在一起以解决进程生命周期的相关问题。 这在GNOME和KDE桌面中大量使用。

  ### 3. 主要功能

D-Bus的主要目的是提供如下的一些更高层的功能：

- 结构化的名字空间；
- 独立于架构的数据格式；
- 支持消息中的大部分通用数据元素；
- 带有异常处理的通用远程调用接口；
- 支持广播类型的通信。

## 三、DBus 编程基础知识

### 1. 地址

连接建立需要有 server 和 client：点对点通信时就是一个 server 和 一个 client；在 bus daemon 通信时，应用就是client，bus daemon 是server。 

一个D-Bus的地址就是是指 server 用于监听，client 用于连接的地方，例如 `unix:path=/tmp/abcedf`标识server 将在路径 `/tmp/abcedf` 的 `UNIX domain socket` 监听。 地址可以是指定的TCP/IP socket 或者其他在或者将在D-Bus协议中定义的传输方式。

如果使用 bus daemon 通信，libdbus将通过读取环境变量自动获取 session bus damon 的地址，通过检查一个指定的 UNIX domain socket 路径获取 system bus 的地址；如果使用点对点通信，需要定义哪个应用是server，哪个应用是client，并定义一套机制是他们认可server的地址（通常不使用）。

### 2. Bus Names总线名字

当一个应用连接到 bus daemon，daemon 立即会分配一个名字给这个连接，称为 **Unique Connection Name**， 这个唯一标识的名字以冒号 **":"** 开头，例如 **:1.2**，这个名字在 daemon 的整个生命周期是唯一的。 

但是这种名字总是临时分配，无法确定的，也难以记忆，因此应用可以要求有另外一个公共名 **well-known name** 来对应这个唯一标识，就像我们使用域名来映射 IP地址一样。例如可以使用 **org.fmddlmyy.Test** 来映射 **:1.2**。这样我们就可以使用公共名连接到 DBus 服务。

当一个应用结束或者崩溃是，系统内核会关闭它的总线连接。总线会发送 Notification 消息告诉其他应用，当检测到这类 Notification 时，应用可以知道其他应用的生命周期。

### 3. 原生对象和对象路径

d-bus 的底层接口是没有这些对象的概念的，它提供的是一种叫对象路径（object path），用于让高层接口绑定到各个对象中去，允许远端应用程序指向它们。object path就像是一个文件路径，可以叫做 `/org/kde/kspread/sheets/3/cells/4/5` 等。

### 4. Proxies代理

代理对象用于模拟在另外的进程中的远端对象，代理对象像是一个正常的普通对象。

d-bus 的底层接口必须手动创建方法调用的消息，然后发送，同时必须手动接受和处理返回的消息。而高层接口可以使用代理来处理这些操作：当调用代理对象的方法时，代理内部会转换成 d-bus 的方法调用，并且自动等待消息返回，对返回结果解包， 返回给相应的方法。

### 3. 接口 Interface

接口是一组方法和信号，每一个对象支持一个或者多个接口，接口定义一个对象实体的类型。 D-Bus使用简单的命名空间字符串来表示接口，例如 `org.freedesktop.Introspectable`。

### 4. Methods 和 Signals

每一个对象有两类成员：**方法和信号**：

- 方法就是一个函数，具有有输入和输出；
- 信号会被广播，感兴趣的对象可以处理这个 信号，同时信号中也可以带有相关的数据。

在 D-BUS 中有四种类型的消息：方法调用（**method call**）、方法返回（**method return**）、信号（**signal**）和错误（**error**）。 

要执行D-BUS对象的方法，您需要向对象发送一个方法调用消息。 它将完成一些处理（就是执行了对象中的Method，Method是可以带有输入参数的。）并返回，返回消息或者错误消息。 信号的不同之处在于它们不返回任何内容：既没有“信号返回”消息，也没有任何类型的错误消息。

## 4. D-Bus 

### 1. D-Feet

> D-Feet是一个易于使用D-bus调试器，D-Feet用来检查D-bus接口的运行程序和调用接口的方法。可以显示service提供的所有对象、信号和方法，还可以通过它实现方法调用。

在有桌面环境的系统上安装 D-Feet，这里自己选择的是Ubuntu：

```bash
# 安装依赖
sudo apt-get install dbus
sudo apt-get install libgtk2.0-dev
sudo apt-get install libdbus-glib-1-dev

# 安装 D-Feet
sudo apt-get install d-feet
```

同时下载一个简单的 DBus 程序：[下载链接](http://www.fmddlmyy.cn/down2/hello-dbus3-0.1.tar.gz)，运行方法：

```bash
# 解压
tar -zxvf hello-dbus3-0.1.tar.gz

# 编译
cd hello-dbus3-0.1/
./autogen.sh
./configure
make

# 运行
cd src
./example-service
```

运行 d-feet，打开 Session bus，找到一个叫 “org.fmddlmyy.Test” 连接名，这个链接就是我们刚刚运行的一个D-Bus程序：

![image-20211012094923932](https://pic.try-hard.cn/blog/1634003366306114300.png)

在右侧展开栏我们会发现 `org.fmddlmyy.Test.Basic` 下有一个 Add 方法，我们点击它，输入 `1，2`，点击执行，可以看到给我们返回了结果：

![image-20211012095344567](https://pic.try-hard.cn/blog/1634003624795407200.png)

通过上面的操作我们通过 d-feet 发起了一次 d-bus 请求。

### 2. dbus-send 和 dbus-monitor

dbus提供了两个小工具：dbus-send和dbus-monitor。我们可以用dbus-send发送消息。用dbus-monitor监视总线上流动的消息。 让我们通过dbus-send发送消息来调用前面的Add方法，这时dbus-send充当了应用程序B。用dbus-monitor观察调用过程中的消息。

开启两个终端，一个终端运行 dbus-monitor，一个终端使用 dbus-send 发送消息：

```bash
dbus-send --session --type=method_call --print-reply --dest=org.fmddlmyy.Test /TestObj org.fmddlmyy.Test.Basic.Add int32:100 int32:999
```

在 dbus-monitor 中可以发现如下输出：

```bash
# 向 D-Bus Damon 发送Hello建立连接
method call time=1634008917.432651 sender=:1.123 -> destination=org.freedesktop.DBus serial=1 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=Hello
method return time=1634008917.432668 sender=org.freedesktop.DBus -> destination=:1.123 serial=1 reply_serial=1
   string ":1.123"
   
# 广播全局，指定名称的拥有者发生了变化   
signal time=1634008917.432674 sender=org.freedesktop.DBus -> destination=(null destination) serial=9 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=NameOwnerChanged
   string ":1.123"  # 名字
   string ""		# 拥有者原始名字
   string ":1.123"  # 拥有者现在名字
   
# 通知应用获得了指定名称的拥有权
signal time=1634008917.432681 sender=org.freedesktop.DBus -> destination=:1.123 serial=2 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=NameAcquired
   string ":1.123"
   
# 调用 Add 方法  
method call time=1634008917.433334 sender=:1.123 -> destination=org.fmddlmyy.Test serial=2 path=/TestObj; interface=org.fmddlmyy.Test.Basic; member=Add
   int32 100
   int32 999
# Add 方法返回结果
method return time=1634008917.434117 sender=:1.121 -> destination=:1.123 serial=6 reply_serial=2
   int32 1099

# 通知应用失去了指定名称的拥有权
signal time=1634008917.435946 sender=org.freedesktop.DBus -> destination=:1.123 serial=5 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=NameLost
   string ":1.123"2

# 广播全局，指定名称的拥有者发生了变化
signal time=1634008917.435978 sender=org.freedesktop.DBus -> destination=(null destination) serial=10 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=NameOwnerChanged
   string ":1.123" 
   string ":1.123"
   string ""
```

通过观察 dbus-monitor 我们了解了一次完整的 d-bus 通信的流程。

### 3. org.freedesktop.DBus

在上面的流程中出现的 org.freedesktop.DBus 就是 Bus Damon ，我们可以使用 `org.freedesktop.DBus.Introspectable.Introspect` 方法查看一个 Bus 对象支持的接口，这里我们使用它来查看 `org.freedesktop.DBus` 支持的接口：

```bash
dbus-send --session --type=method_call --print-reply --dest=org.freedesktop.DBus / org.freedesktop.DBus.Introspectable.Introspect
```

```xml
"http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
<node>
  <interface name="org.freedesktop.DBus">
    <method name="Hello">
      <arg direction="out" type="s"/>
    </method>
    <method name="RequestName">
      <arg direction="in" type="s"/>
      <arg direction="in" type="u"/>
      <arg direction="out" type="u"/>
    </method>
    <method name="ReleaseName">
      <arg direction="in" type="s"/>
      <arg direction="out" type="u"/>
    </method>
    <method name="StartServiceByName">
      <arg direction="in" type="s"/>
      <arg direction="in" type="u"/>
      <arg direction="out" type="u"/>
    </method>
    <method name="UpdateActivationEnvironment">
      <arg direction="in" type="a{ss}"/>
    </method>
    <method name="NameHasOwner">
      <arg direction="in" type="s"/>
      <arg direction="out" type="b"/>
    </method>
    <method name="ListNames">
      <arg direction="out" type="as"/>
    </method>
    <method name="ListActivatableNames">
      <arg direction="out" type="as"/>
    </method>
    <method name="AddMatch">
      <arg direction="in" type="s"/>
    </method>
    <method name="RemoveMatch">
      <arg direction="in" type="s"/>
    </method>
    <method name="GetNameOwner">
      <arg direction="in" type="s"/>
      <arg direction="out" type="s"/>
    </method>
    <method name="ListQueuedOwners">
      <arg direction="in" type="s"/>
      <arg direction="out" type="as"/>
    </method>
    <method name="GetConnectionUnixUser">
      <arg direction="in" type="s"/>
      <arg direction="out" type="u"/>
    </method>
    <method name="GetConnectionUnixProcessID">
      <arg direction="in" type="s"/>
      <arg direction="out" type="u"/>
    </method>
    <method name="GetAdtAuditSessionData">
      <arg direction="in" type="s"/>
      <arg direction="out" type="ay"/>
    </method>
    <method name="GetConnectionSELinuxSecurityContext">
      <arg direction="in" type="s"/>
      <arg direction="out" type="ay"/>
    </method>
    <method name="GetConnectionAppArmorSecurityContext">
      <arg direction="in" type="s"/>
      <arg direction="out" type="s"/>
    </method>
    <method name="ReloadConfig">
    </method>
    <method name="GetId">
      <arg direction="out" type="s"/>
    </method>
    <method name="GetConnectionCredentials">
      <arg direction="in" type="s"/>
      <arg direction="out" type="a{sv}"/>
    </method>
    <property name="Features" type="as" access="read">
      <annotation name="org.freedesktop.DBus.Property.EmitsChangedSignal" value="const"/>
    </property>
    <property name="Interfaces" type="as" access="read">
      <annotation name="org.freedesktop.DBus.Property.EmitsChangedSignal" value="const"/>
    </property>
    <signal name="NameOwnerChanged">
      <arg type="s"/>
      <arg type="s"/>
      <arg type="s"/>
    </signal>
    <signal name="NameLost">
      <arg type="s"/>
    </signal>
    <signal name="NameAcquired">
      <arg type="s"/>
    </signal>
  </interface>
  <interface name="org.freedesktop.DBus.Introspectable">
    <method name="Introspect">
      <arg direction="out" type="s"/>
    </method>
  </interface>
  <interface name="org.freedesktop.DBus.Peer">
    <method name="GetMachineId">
      <arg direction="out" type="s"/>
    </method>
    <method name="Ping">
    </method>
  </interface>
  <node name="org/freedesktop/DBus"/>
</node>
"
```

从输出可以看到会话总线对象支持标准接口“org.freedesktop.DBus.Introspectable”和接口“org.freedesktop.DBus”。 接口“org.freedesktop.DBus”有16个方法和3个信号。下表列出了“org.freedesktop.DBus”的12个方法的简要说明：

| 方法                                                         | 用途                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| org.freedesktop.DBus.RequestName (in STRING name, in UINT32 flags, out UINT32 reply) | 请求公众名。其中flag定义如下： <br />- DBUS_NAME_FLAG_ALLOW_REPLACEMENT 1 <br />- DBUS_NAME_FLAG_REPLACE_EXISTING 2 <br />- DBUS_NAME_FLAG_DO_NOT_QUEUE 4  <br />返回值reply定义如下：<br /> - DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER 1 <br />- DBUS_REQUEST_NAME_REPLY_IN_QUEUE 2 <br />- DBUS_REQUEST_NAME_REPLY_EXISTS 3 <br />- DBUS_REQUEST_NAME_REPLY_ALREADY_OWNER 4 |
| org.freedesktop.DBus.ReleaseName (in STRING name, out UINT32 reply) | 释放公众名。返回值reply定义如下： DBUS_RELEASE_NAME_REPLY_RELEASED 1 DBUS_RELEASE_NAME_REPLY_NON_EXISTENT 2 DBUS_RELEASE_NAME_REPLY_NOT_OWNER 3 |
| org.freedesktop.DBus.Hello (out STRING unique_name)          | 一个应用在通过消息总线向其它应用发消息前必须先调用Hello 获取自己这个连接的唯一名。返回值就是连接的唯一名。dbus没有定义专门的切断连接命令，关闭socket就是切断连接。 |
| org.freedesktop.DBus.ListNames (out ARRAY of STRING bus_names) | 返回消息总线上已连接的所有连接名，包括所有公共名和唯一名。例如连接 “org.fmddlmyy.Test” 同时有公共名 “org.fmddlmyy.Test” 和唯一名 “:1.123” ， 这两个名称都会被返回。 |
| org.freedesktop.DBus.ListActivatableNames (out ARRAY of STRING bus_names) | 返回所有可以启动的服务名。dbus支持按需启动服务，即根据应用程序的请求启动服务。 |
| org.freedesktop.DBus.NameHasOwner (in STRING name, out BOOLEAN has_owner) | 检查是否有连接拥有指定名称。                                 |
| org.freedesktop.DBus.StartServiceByName (in STRING name, in UINT32 flags, out UINT32 ret_val) | 按名称启动服务。参数flags暂未使用。返回值ret_val定义如下： <br />1 服务被成功启动 <br />2 已经有连接拥有要启动的服务名 |
| org.freedesktop.DBus.GetNameOwner (in STRING name, out STRING unique_connection_name) | 返回拥有指定公众名的连接的唯一名。                           |
| org.freedesktop.DBus.GetConnectionUnixUser (in STRING connection_name, out UINT32 unix_user_id) | 返回指定连接对应的服务器进程的Unix用户id。                   |
| org.freedesktop.DBus.AddMatch (in STRING rule)               | 为当前连接增加匹配规则。                                     |
| org.freedesktop.DBus.RemoveMatch (in STRING rule)            | 为当前连接去掉指定匹配规则。                                 |
| org.freedesktop.DBus.GetId (out STRING id)                   | 返回消息总线的ID。这个ID在消息总线的生命期内是唯一的。       |

接口 “org.freedesktop.DBus” 的3个信号是：

| 信号                                                         | 用途                             |
| ------------------------------------------------------------ | -------------------------------- |
| org.freedesktop.DBus.NameOwnerChanged (STRING name, STRING old_owner, STRING new_owner) | 指定名称的拥有者发生了变化。     |
| org.freedesktop.DBus.NameLost (STRING name)                  | 通知应用失去了指定名称的拥有权。 |
| org.freedesktop.DBus.NameAcquired (STRING name)              | 通知应用获得了指定名称的拥有权。 |

### 4. D-Bus Service

`org.freedesktop.DBus.ListActivatableNames` 接口可以返回所有可以启动的服务名：

```bash
dbus-send --session --type=method_call --print-reply --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListActivatableNames|sort
```

```bash
string "ca.desrt.dconf"
string "com.feralinteractive.GameMode"
string "io.snapcraft.Launcher"
string "io.snapcraft.Settings"
string "org.a11y.Bus"
string "org.bluez.obex"
string "org.fedoraproject.Config.Printing"
......
```

我们再使用下面的命令：

```bash
 cat /usr/share/dbus-1/services/* | grep Name= | sort
```

```bash
Name=ca.desrt.dconf
Name=com.feralinteractive.GameMode
Name=io.snapcraft.Launcher
Name=io.snapcraft.Settings
Name=org.a11y.Bus
Name=org.bluez.obex
Name=org.fedoraproject.Config.Printing
......
```

我们会发现上诉两个命令的输出内容是基本一致的（可能有些干扰数据），第二个命令实际上就是查看的 `/usr/share/dbus-1/services/` 文件夹下的内容，进入该文件夹下，我们会发现很多 service 文件，我们也可以添加自己 service 文件，将 `org.fmddlmyy.Test` 加入服务：

```bash
cat org.fmddlmyy.Test.service

[D-BUS Service]
Name=org.fmddlmyy.Test
Exec=/root/hello-dbus3-0.1/src/example-service
```

这时我们不去手动启动 example-service 文件，直接请求：

```bash
dbus-send --session --type=method_call --print-reply --dest=org.fmddlmyy.Test /TestObj org.fmddlmyy.Test.Basic.Add int32:100 int32:999
```

发现现在已经成功访问了该服务！

刚刚我们看的是 seesion bus 的 service，system bus 的 service 在 `/usr/share/dbus-1/system-services` 路径下，有兴趣的小伙伴可以去看看。

> 参考链接：
>
> - [我的随笔 (fmddlmyy.cn)](http://www.fmddlmyy.cn/mytext.html)
> - [DBus学习笔记 - 莫水千流 - 博客园 (cnblogs.com)](https://www.cnblogs.com/zhoug2020/p/4516144.html)
> - [4.1. D-Bus系列之入门 — big-doc 0.1 documentation (thebigdoc.readthedocs.io)](https://thebigdoc.readthedocs.io/en/latest/dbus/dbus.html)
> - [D-Bus Tutorial (dbus.freedesktop.org)](https://dbus.freedesktop.org/doc/dbus-tutorial.html)

