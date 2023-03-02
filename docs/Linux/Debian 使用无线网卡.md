# Debian 使用无线网卡

## 依赖安装

```bash
# wpa_supplicant 和 wpa_cli
apt install wpasupplicant

# iwconfig 
apt install iw
```

## 服务启动

```bash
# 启动无线网卡
iwconfig wlo1 power on

# 写入配置文件
vim /etc/wpa_supplicant.conf

ctrl_interface=/var/run/wpa_supplicant 
update_config=1

# 启动守护进程
wpa_supplicant -Dnl80211 -iwlo1 -c/etc/wpa_supplicant.conf -B
```

## 扫描

```bash
# wpa_cli -i wlo1
wpa_cli v2.9
Copyright (c) 2004-2019, Jouni Malinen <j@w1.fi> and contributors

This software may be distributed under the terms of the BSD license.
See README for more details.



Interactive mode

> scan 
OK
<3>CTRL-EVENT-SCAN-STARTED 
> scan_results
bssid / frequency / signal level / flags / ssid
bc:22:47:a1:dd:c0       5220    -89     [WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][ESS]    example
```

## 连接 wifi （通过配置文件）

```bash
vim /etc/wpa_supplicant/wpa_supplicant-wlo1.conf

network={
    ssid="{ssid}"
    key_mgmt=WPA-PSK WPA-PSK-SHA256
    psk="{password}"
}

systemctl restart wpa_supplicant@wlo1.service
```

