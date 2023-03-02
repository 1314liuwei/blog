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

