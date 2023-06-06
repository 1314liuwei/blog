# Debian 使用蓝牙

## 安装配置蓝牙服务

## 1.  bluetooth 服务

```bash
apt install bluetooth
systemctl start bluetooth
```

## 2. 电源管理

```apt
rfkill list
rfkill unblock all
```

## 3. firmware-iwlwifi

```bash
apt update && apt install firmware-iwlwifi
```

### 4. bluetooth 配置

```
vim /etc/dbus-1/system.d/bluetooth.conf

add to config: 
<policy group="bluetooth"> 
	<allow send_destination="org.bluez"/>
</policy>

usermod -a -G bluetooth root
reboot
```



## 使用蓝牙服务

```bash
# 启动蓝牙网卡
hciconfig hci0 up

# 扫描
bluetoothctl scan on

# 配对
bluetoothctl pair {addr}

# 信任设备
bluetoothctl trust {addr}

# 连接设备
bluetoothctl connect {addr}

# 安装 pulseaudio 用以连接蓝牙音箱设备
apt install pulseaudio-module-bluetooth
pulseaudio --start -D
pactl load-module module-bluetooth-discover
```

## 安装 pybluez 库包

```
apt-get install python3-dev
apt-get install libbluetooth-dev
pip install git+https://github.com/pybluez/pybluez.git#egg=pybluez

# 设备服务查看命令
sdptool 
```

## windows 蓝牙抓包

```
# 命令行管理员执行
# 开始抓包
logman create trace "bth_hci" -ow -o C:\bth_hci.etl -p {8a1f9517-3a8c-4a9e-a018-4f17a200f277} 0xffffffffffffffff 0xff -nb 16 16 -bs 1024 -mode Circular -f bincirc -max 4096 -ets

# 结束抓包
logman stop "bth_hci" -ets

# 下载转换工具
https://download.microsoft.com/download/e/e/e/eeed3cd5-bdbd-47db-9b8e-ca9d2df2cd29/BluetoothTestPlatformPack-1.8.0.msi

# 下载后BTETLParse.exe目录
C:\BTP\v1.8.0\x64

# 转换
BTETLParse.exe bth_hci_phone.etl
```

## hciconfig 使用问题

```
# hciconfig hci0 up
Can't init device hci0: No such file or directory (2)
```

查看系统日志发现有如下报错：

```bash
hci0: firmware: failed to load intel/ibt-0040-2120.sfi (-2)
hci0: firmware: failed to load intel/ibt-0040-2120.ddc (-2)
```

这是由于没有加载对应的固件包导致，解决方案：

```bash
# apt安装固件包
apt update && apt install firmware-iwlwifi

# 如果安装了固件包依然存在这种问题，去查看一下对应的固件包是否已经安装
cd /usr/lib/firmware	# 在这个文件夹下查看是否有对应的固件包

# 如果没有对应的固件包，则可能是由于固件比较新没有包含在 firmware-iwlwifi 中
# 去 https://anduin.linuxfromscratch.org/sources/linux-firmware/ 下载所需的固件包，放到对应的路径下
# 更新所有已安装内核的 initramfs
update-initramfs -kall -u
```

## bluetoothctl 使用问题

```bash
# bluetoothctl scan on
No default controller available
```

