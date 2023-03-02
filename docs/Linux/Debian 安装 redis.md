# Debian 安装 Redis

1. 安装依赖项：

   ```shell
   apt-get install wget curl gnupg -y
   ```

2. 添加 GPG 密钥：

   ```shell
   curl https://packages.redis.io/gpg | apt-key add -
   ```

3. 添加 Redis 官方存储库：

   ```shell
   echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list
   ```

4. 更新存储库和安装 Redis：

   ```shell
   apt-get update -y 
   apt-get install redis-server -y
   ```

5. 验证 Redis 安装：

   ```shell
   apt-cache policy redis-server
   ```

6. 运行 Redis 服务：

   ```shell
   systemctl enable redis-server --now
   ```

7. 查看 Redis 服务运行状态：

   ```shell
   systemctl status redis-server
   ```

8. 连接 Redis：

   ```shell
   redis-cli
   ```





更改 Redis 服务配置：

```shell
vim /etc/redis/redis.conf
```

