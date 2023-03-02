# 私有相册 PhotoPrism 调研

## 安装

当前介绍方式为 docker-compose 安装:

```bash
mkdir PhotoPrism && cd PhotoPrism

# 下载docker-compose配置文件
wget https://dl.photoprism.org/docker/docker-compose.yml 

# 删除不需要的配置项
vim docker-compose.yml

security_opt: 
       - seccomp:unconfined 
       - apparmor:unconfined
       
```

