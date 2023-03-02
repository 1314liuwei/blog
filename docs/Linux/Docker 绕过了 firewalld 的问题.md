# Docker 绕过了 firewalld 的问题

## 前言

我们的 `firewalld` 上没有开放该端口，但是在使用 Docker 的端口映射后我们就能够通过外网访问到该端口。

## 原因

默认情况下当Docker启动容器映射端口时，会直接在`iptables`添加规则开启添加端口。而 `firewalld` 实际上也是在`iptables`写入规则。因此 `firewalld`和`docker`属于是同级的应用，但是`firewalld`不会去检测 docker 写入的规则，就会导致 docker 可以开启`firewalld`没有允许的端口：

```bash
# 首先关闭 docker 和防火墙
systemctl stop docker
systemctl stop firewalld

# 查看 iptables
iptables --list

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

# 打开 docker
systemctl start docker
iptables --list
# 我们会发现在 iptables 里增加了许多 docker 的规则

# 我们启动一个容器并开启端口映射
docker run -dit -p 80:80 nginx
iptables --list

# 我们发现在 iptables 里增加了一条规则
# 它将 80(http) 端口的流量转发到了 172.17.0.2(我们开启的容器的地址)
...
Chain DOCKER (1 references)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             172.17.0.2           tcp dpt:http
...
```

通过上面的分析我们就知道了 docker 是通过在 iptables 中添加规则实现的端口映射。

那这个时候我们再开启防火墙，看看防火墙是如何修改的 iptables：

```bash
# 开启防火墙观察 iptables 的变化
systemctl start firewalld
iptables --list

...
Chain IN_public_allow (1 references)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssh ctstate NEW,UNTRACKED
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssh ctstate NEW,UNTRACKED
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:postgres ctstate NEW,UNTRACKED
...
```

开启防火墙后我们果然发现了我们通过 `firewalld`开启的端口规则。这下子我们终于弄懂了 docker 和 firewalld 之间的关系。

**等等！！！**

我们之前看到的 docker 的规则呢？

开启防火墙后我们发现在上面添加的 docker 的 iptables 的规则已经不见了，这个时候从外网访问 80 端口也被拒绝了！这又是怎么一回事呢？

原来 `firewalld`在开启时会自动刷新覆盖掉原来的 `iptables` 规则，这就导致了 docker 的规则被丢失。

因此 `firewalld`重启后需要再重启 `docker`的服务才能使 docker 正常启动。 

## 使 docker 在防火墙规则下工作

由于 docker 这种脱离防火墙控制的行为具有一定危险性，并且为运维带来一定难度，因此我们需要让 docker 接受防火墙的管理。

既然 docker 是修改的 iptables 脱离的防火墙控制，那我们让他不修改 iptables 就可以解决问题了：

```bash
# 添加规则
vim /etc/docker/daemon.json

{
...
"experimental" : true,
"iptables": false
}

# 重启 docker
systemctl daemon-reload
systemctl restart docker

# 启动一个容器检验
docker run -d -p 80:80 nginx
iptables --list
# 发现 docker 没有添加规则
```

