# Debian 配置 Avahi

```bash
# 安装 守护进程
apt install avahi-daemon

# 安装工具
apt install avahi-utils

# 启动 avahi
systemctl start avahi-daemon

# 查看服务状态
systemctl status avahi-daemon

```

avahi 提供的服务配置示例：

```bash
ls /usr/share/doc/avahi-daemon/examples/

example.service  sftp-ssh.service  ssh.service
```

发布 ssh 服务：

```bash
# 拷贝服务配置
cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services/

# 修改对外暴露的主机名，默认采用的主机名，当局域网内有相同主机名时可能产生冲突
vim /etc/avahi/avahi-daemon.conf

[server]
host-name=avahi

# 重启 avahi 
systemctl restart avahi-daemon
```

测试 mDNS 服务：

```
ping avahi.local

ssh root@avahi.local
```



测试 samba 服务：

```bash
# 安装 samba

```

