# Tailscale 安装

```bash
# 1. 下载安装包
wget https://pkgs.tailscale.com/stable/tailscale_1.34.2_amd64.tgz

# 2. 解压
tar zxvf tailscale_1.34.2_amd64.tgz

output:
tailscale_1.34.2_amd64/
tailscale_1.34.2_amd64/tailscale
tailscale_1.34.2_amd64/tailscaled
tailscale_1.34.2_amd64/systemd/
tailscale_1.34.2_amd64/systemd/tailscaled.defaults
tailscale_1.34.2_amd64/systemd/tailscaled.service

# 3. 拷贝程序
cp tailscale_1.34.2_amd64/tailscale /usr/bin/tailscale
cp tailscale_1.34.2_amd64/tailscaled /usr/sbin/tailscaled

# 4. 拷贝 service 程序
cp tailscale_1.34.2_amd64/systemd/tailscaled.service  /lib/systemd/system/tailscaled.service

# 5. 将环境变量配置文件复制到系统路径下
cp tailscale_1.34.2_amd64/systemd/tailscaled.defaults /etc/default/tailscaled

# 5. 启动 tailscaled.service 并设置开机自启
systemctl enable --now tailscaled

# 6. 查看服务状态
systemctl status tailscaled.service
```

