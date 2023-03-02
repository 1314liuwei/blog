## 安装配置 samba

安装 samba 服务：

```bash
apt install samba, smbclient(smb客户端，用于连接smb)
```

创建共享文件夹 :

```bash
mkdir /samba
chmod 777 /samba
```

配置 samba：

```bash
vim /etc/samba/smb.conf

# 在配置文件末尾追加

[share]
comment = share
path = /samba
browsable = yes
guest ok = yes  # 配置访客访问
```

启动 samba 服务：

```bash
systemctl start smbd  # 启动 smbd
systemctl enable smbd # 加入开机自启动
systemctl status smbd # 查看服务状态

● smbd.service - Samba SMB Daemon
     Loaded: loaded (/lib/systemd/system/smbd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-12-13 11:18:32 CST; 4min 54s ago
       Docs: man:smbd(8)
             man:samba(7)
             man:smb.conf(5)
    Process: 12185 ExecStartPre=/usr/share/samba/update-apparmor-samba-profile (code=exited, status=0/SUCCESS)
   Main PID: 12194 (smbd)
     Status: "smbd: ready to serve connections..."
      Tasks: 5 (limit: 18857)
     Memory: 7.8M
        CPU: 469ms
     CGroup: /system.slice/smbd.service
             ├─12194 /usr/sbin/smbd --foreground --no-process-group
             ├─12196 /usr/sbin/smbd --foreground --no-process-group
             ├─12197 /usr/sbin/smbd --foreground --no-process-group
             ├─12199 /usr/sbin/smbd --foreground --no-process-group
             └─12201 /usr/sbin/smbd --foreground --no-process-group

Dec 13 11:18:32 debian11 systemd[1]: Starting Samba SMB Daemon...
Dec 13 11:18:32 debian11 systemd[1]: Started Samba SMB Daemon.
```

本地连接 samba:

```bash
# 首先需要添加系统用户
useradd -G samba debian11 echo 'Password' |passwd --stdin debian11
# 添加 samba 用户
smbpasswd -a debian11

# 连接samba
smbclient -L 127.0.0.1 -U debian11
```

## 配置苹果和Windows的网络发现

```bash
# 安装 avahi，avahi是zeroconfig协议的一个实现，苹果的bonjour是zeroconfig的另外一个实现
# 安装了 avahi 后，苹果设备就能发现 linux 上的 samba 服务
apt install avahi-daemon  

# wsdd 实现了 WS-Discover 协议，Windows 可以通过此协议发现网络设备
apt install wsdd		  
```

启动服务：

```bash
# 不需要在avahi的services中配置smb服务，因为smb默认会借助avahi进行服务暴露
systemctl start avahi-daemon

systemctl start wsdd
```

