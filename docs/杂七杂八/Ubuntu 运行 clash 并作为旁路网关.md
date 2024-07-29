# Ubuntu 运行 clash 并作为旁路网关

## 开启网络转发

```bash
# 开启 ip_forward 转发
sysctl net.ipv4.ip_forward=1

# 保存设置
sysctl -p
```



# 安装 clash(mihomo)

去 Github 下载 mihomo 二进制文件：https://github.com/MetaCubeX/mihomo/releases

将二进制文件重命名为 `mihomo`

```bash
# 赋予 mihomo 执行权限
chmod +x mihomo

# 将 mihomo 放置到 /usr/local/bin 下
cp mihomo /usr/local/bin

# 创建运行目录
mkdir /etc/mihomo -p

# 将自己的配置文件复制到 /etc/mihomo
cp config.yaml /etc/mihomo
```

在以服务形式执行之前，先尝试手动运行：

```bash
/usr/local/bin/mihomo -d /etc/mihomo
```

如果手动运行没有问题，则可以创建系统服务。创建 systemd 配置文件 `/etc/systemd/system/mihomo.service`:

```bash
[Unit]
Description=mihomo Daemon, Another Clash Kernel.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
```

再执行以下命令保存 systemd 文件：

```bash
# 重新加载 systemd
systemctl daemon-reload

# 配置开机自启动 mihomo 服务
systemctl enable mihomo

# 立即启动 mihomo
systemctl start mihomo

# 查看 mihomo 日志
journalctl -f -u mihomo.service
```



## 流量转发

为了方便引流，选择通过开启 `TUN`模式接管本机所有流量的方式实现。

在配置文件中添加 `TUN` 模式，配置文件模板参考：https://wiki.metacubex.one/config/inbound/tun/

下面是我个人使用的 `TUN` 配置：

```yaml
tun:
  stack: mixed
  device: Meta
  auto-route: true
  auto-detect-interface: true
  dns-hijack:
  - any:53
  strict-route: false
  mtu: 1500
  enable: true
```



## 添加 Web UI

在配置文件中添加：

```Yaml
external-controller: 0.0.0.0:9090 # 如果需要本地访问则指定为 127.0.0.1
external-ui: ui
external-ui-url: "https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip"
```

添加配置之后即可在网页端通过 http://127.0.0.1:9090/ui 访问控制界面。