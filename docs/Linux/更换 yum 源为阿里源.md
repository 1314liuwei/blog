# 更换 yum 源为阿里源

> 目标：更换 yum 源为阿里源
>
> 系统：Centos 7.9

## 步骤

### 1. 备份旧的配置文件

```bash
cd /etc/yum.repos.d/  						# 进入文件夹
mv CentOS-Base.repo CentOS-Base.repo_back	# 备份原始配置文件
```

### 2. 下载阿里源的文件

```bash
wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# 若没有 wget 可使用 curl
curl -o CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

### 3. 安装 epel repo 源

```bash
wget -O epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 若没有 wget 可使用 curl
curl -o epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

### 4. 清理缓存

```bash
yum clean all
```

### 5. 重新生成缓存

```bash
yum makecache
```

### 6. 更新

```bash
yum -y update
```

