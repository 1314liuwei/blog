# Docker 配置 PostgreSQL13 的主从环境

## 前言

> PostgreSQL 数据库支持多种复制解决方案，以构建高可用性，可伸缩，容错的应用程序，其中之一是`预写日志（WAL）传送`。该解决方案允许使用基于文件的日志传送或流复制，或者在可能的情况下，将两种方法结合使用来实现备用服务器。
>
> 默认情况下，流复制是异步的，其中在将事务提交到主服务器后将数据写入备用服务器。这意味着在主服务器中提交事务与更改在备用服务器中变得可见之间存在很小的延迟。这种方法的一个缺点是，如果主服务器崩溃，则可能无法复制任何未提交的事务，这可能导致数据丢失。

本次实验将要在 Docker 上安装 PostgreSQL13 并配置主从环境。为了简化演示环境，这里只用一台服务器来演示，通过不同端口来区分。

## 安装配置

### 1. 创建测试网络

创建一个 docker bridge 网络用于测试：

```bash
# 1. 创建测试网络
docker network create --subnet=172.18.0.0/24 dockernetwork

# 2. 查看网络
docker network ls

NETWORK ID     NAME            DRIVER    SCOPE
8c8a87e2c6e0   bridge          bridge    local
a8e4916d92c2   dockernetwork   bridge    local
92951335914e   host            host      local
2e991e7fd5a3   none            null      local
```

规划主从库IP端口如下：

**主库**：`172.18.0.101:5432`

**从库**：`172.18.0.102:5433`

### 2. 拉取 postgres13 镜像

```bash
docker pull postgres
```

### 3. 创建数据目录

```bash
mkdir -p /data/psql/master
mkdir -p /data/psql/slave
mkdir -p /data/psql/repl
chown 999:999 /data/psql/master
chown 999:999 /data/psql/slave
chown 999:999 /data/psql/repl
```

### 4. 运行 master 容器

```bash
docker run -d \
--network dockernetwork --ip 172.18.0.101 -p 5432:5432 \
--name master -h master \
-e "POSTGRES_DB=postgres" \
-e "POSTGRES_USER=postgres" \
-e "POSTGRES_PASSWORD=postgres" \
-v /data/psql/master:/var/lib/postgresql/data \
postgres
```

查看容器：

```bash
docker ps -a -f network=dockernetwork --format "table {{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"

NAMES     IMAGE      CREATED          STATUS          NETWORKS        PORTS
master    postgres   48 seconds ago   Up 46 seconds   dockernetwork   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
```

### 5. 创建主从流复制专用账号

```bash
# 1. 进入容器
docker exec -it master bash

# 2. 连接PostgreSQL
psql -U postgres

# 3. 创建用户规则
CREATE ROLE repuser WITH LOGIN REPLICATION CONNECTION LIMIT 5 PASSWORD '123456';
# 用户名 repuser；最大链接数：5；密码：123456

# 4. 查看规则
\du
```

```sql
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 repuser   | Replication                                               +| {}
           | 5 connections                                              |
```

### 6. 修改 master 配置文件

```bash
# 1. 进入 master 文件夹
cd /data/psql/master

# 2. 在末尾增加规则
echo "host replication repuser 172.18.0.102/24 md5" >> pg_hba.conf
```

修改 `postgresql.conf` 配置文件，找到以下几行，取消注释修改配置：

```bash
archive_mode = on				# 开启归档模式
archive_command = '/bin/date'	# 设置归档行为
# 从机连接到主机的并发连接数之总和
max_wal_senders = 10			
# 指定在后备服务器需要为流复制获取日志段文件的情况下, pg_wal目录下所能保留的过去日志文件段的最小尺寸	
wal_keep_size = 16		
# 指定一个支持同步复制的后备服务器的列表
synchronous_standby_names = '*'
```

更多参数详解可参考：[19.6. 复制 (postgres.cn)](http://www.postgres.cn/docs/13/runtime-config-replication.html#RUNTIME-CONFIG-REPLICATION-SENDER)

### 7. 重启 master 容器

```bash
#使用 pg_ctl stop 安全停止数据库
docker exec -it -u postgres master pg_ctl stop
docker start master
```

### 8. 创建 slave 容器

```bash
docker run -d \
--network dockernetwork --ip 172.18.0.102 -p 5433:5432 \
--name slave -h slave \
-e "POSTGRES_DB=postgres" \
-e "POSTGRES_USER=postgres" \
-e "POSTGRES_PASSWORD=postgres" \
-v /data/psql/slave:/var/lib/postgresql/data \
-v /data/psql/repl:/var/lib/postgresql/repl \
postgres
```

```bash
# 查看容器
docker ps -a -f network=dockernetwork --format "table {{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"

NAMES     IMAGE      CREATED          STATUS          NETWORKS        PORTS
slave     postgres   18 seconds ago   Up 15 seconds   dockernetwork   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp
master    postgres   2 hours ago      Up 2 hours      dockernetwork   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
```

### 9. 同步数据

```bash
# 1. 进入容器
docker exec -it -u postgres slave /bin/bash

# 2. 备份主机数据到 repl 文件夹，此处输入在上面设置的密码：123456
pg_basebackup -R -D /var/lib/postgresql/repl -Fp -Xs -v -P -h 172.18.0.101 -p 5432 -U repuser

pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/2000028 on timeline 1
pg_basebackup: starting background WAL receiver
pg_basebackup: created temporary replication slot "pg_basebackup_154"
24264/24264 kB (100%), 1/1 tablespace
pg_basebackup: write-ahead log end point: 0/2000138
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: syncing data to disk ...
pg_basebackup: renaming backup_manifest.tmp to backup_manifest
pg_basebackup: base backup completed

# 3. 备份完成退出容器
exit
```

### 10. 重建 slave 容器

通过上一步的初始备份，现在可以使用 `/data/psql/repl` 里的数据重建 slave容器了。首先删除slave目录，然后将 `repl` 目录改为 `slave`，这个目录就是从库的数据目录了：

```bash
# 1. 删除容器
docker rm -f slave
# 2. 删除原有文件夹，将 repl 重命名为 slave
cd /data/psql/
rm -rf slave
mv repl slave
cd /data/psql/slave
# 3. 查看配置信息
# postgresql.auto.conf 将含有复制所需信息
cat postgresql.auto.conf

primary_conninfo = 'user=repuser password=123456 channel_binding=prefer host=172.18.0.101 port=5432 sslmode=prefer sslcompression=0 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres target_session_attrs=any'
```

重建 slave 容器：

```bash
docker run -d \
--network dockernetwork --ip 172.18.0.102 -p 5433:5432 \
--name slave -h slave \
-e "POSTGRES_DB=postgres" \
-e "POSTGRES_USER=postgres" \
-e "POSTGRES_PASSWORD=postgres" \
-v /data/psql/slave:/var/lib/postgresql/data \
postgres
```

```bash
# 查看容器
docker ps -a -f network=dockernetwork --format "table {{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"

NAMES     IMAGE      CREATED          STATUS          NETWORKS        PORTS
slave     postgres   23 seconds ago   Up 21 seconds   dockernetwork   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp
master    postgres   2 hours ago      Up 2 hours      dockernetwork   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
```

### 11. 查看主从复制信息

```bash
ps -aux | grep postgres

主库进程：
postgres: walsender repuser 172.18.0.1(52678) streaming 0/3000148
从库进程：
postgres: walreceiver streaming 0/3000148
```

## 验证主从配置

### 主机生成数据

```bash
# 进入 master 容器，切换到postgres用户
docker exec -it master bash
psql -U postgres
```

```sql
-- 查询复制信息
select * from pg_stat_replication;

pid | usesysid | usename | application_name | client_addr | client_hostname...
170	16384	repuser	walreceiver	172.18.0.1		52678	2021-09-29 05:57:30.471391+00...
```

```sql
-- 创建测试数据库
CREATE DATABASE test;
-- 查看所有数据库
\list

                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

```sql
-- 切换数据库
\c test
-- 创建测试表
CREATE TABLE test (
  "id" int4 NOT NULL,
  "value" varchar(255),
  PRIMARY KEY ("id")
);
-- 查看创建的表
\dt

        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+----------
 public | test | table | postgres
(1 row)
```

```sql
-- 向表中插入十条数据
insert into test select generate_series(1,10),md5(random());

-- 查看所有数据
select * from test;

 id |              value
----+----------------------------------
  1 | cfcd208495d565ef66e7dff9f98764da
  2 | cfcd208495d565ef66e7dff9f98764da
  3 | cfcd208495d565ef66e7dff9f98764da
  4 | cfcd208495d565ef66e7dff9f98764da
  5 | cfcd208495d565ef66e7dff9f98764da
  6 | cfcd208495d565ef66e7dff9f98764da
  7 | cfcd208495d565ef66e7dff9f98764da
  8 | cfcd208495d565ef66e7dff9f98764da
  9 | cfcd208495d565ef66e7dff9f98764da
 10 | cfcd208495d565ef66e7dff9f98764da
(10 rows)
```

### 从机查看数据

```bash
# 进入从机容器
docker exec -it slave bash
psql -U postgres
```

```sql
-- 查看数据库
\d

                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

```sql
-- 查看表
\c test

        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+----------
 public | test | table | postgres
(1 row)
```

```sql
-- 查看所有数据
select * from test;

 id |              value
----+----------------------------------
  1 | cfcd208495d565ef66e7dff9f98764da
  2 | cfcd208495d565ef66e7dff9f98764da
  3 | cfcd208495d565ef66e7dff9f98764da
  4 | cfcd208495d565ef66e7dff9f98764da
  5 | cfcd208495d565ef66e7dff9f98764da
  6 | cfcd208495d565ef66e7dff9f98764da
  7 | cfcd208495d565ef66e7dff9f98764da
  8 | cfcd208495d565ef66e7dff9f98764da
  9 | cfcd208495d565ef66e7dff9f98764da
 10 | cfcd208495d565ef66e7dff9f98764da
(10 rows)
```

可以发现主从数据一直，代表我们主从配置成功！

