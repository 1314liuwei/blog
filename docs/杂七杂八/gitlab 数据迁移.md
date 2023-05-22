# Gitlab 数据迁移

> 查看 gitlab 服务器版本：
>
> ```bash
>cat /opt/gitlab/embedded/service/gitlab-rails/VERSION
> ```

## 原始仓库

### 1. 代码仓库数据

```bash
// 1. gitlab 仓库的数据都在这个目录下，存储的方式是按照 Project ID 的hash值进行保存的
cd /var/opt/gitlab/git-data/repositories

tree -L 3
.
├── +gitaly
│   ├── state
│   │   └── @hashed
│   │       ├── 6b
│   │       └── d4
│   └── tmp
└── @hashed
    ├── 6b
    │   └── 86
    │       ├── 6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b.git
    │       └── 6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b.wiki.git
    └── d4
        └── 73
            ├── d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35.git
            └── d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35.wiki.git
```

这里就是仓库的 Project ID：

![image-20211223143443364](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1640241288123339000.png)

```bash
// 执行下面的命令查看 ID 的哈希值
echo -n 1 | sha256sum
6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b 
```

根据其哈希值可以判断是哪个仓库的数据。

### 2. 数据打包

```bash
// 2. 对需要的仓库数据进行打包
pwd 
/var/opt/gitlab/git-data/repositories

tar czvf data.tar.gz *

// 3. 发送到新仓库
scp data.tar.gz root@host:/var/opt/gitlab/git-data/
```

## 目标仓库

```bash
// 1. 进入仓库数据目录
cd /var/opt/gitlab/git-data

// 2. 解压原始仓库的数据
mkdir /var/opt/gitlab/git-data/repository-import/new -p
tar xf data.tar.gz -C /var/opt/gitlab/git-data/repository-import/new/

// 3. 更改目录归属者，设置归属者为git用户
chown -R git.git  /var/opt/gitlab/git-data/repository-import/

// 4. 迁移数据
gitlab-rake gitlab:import:repos['/var/opt/gitlab/git-data/repository-import/']
```

最后刷新 Web 端就可以看到迁移后的仓库了（登录 root 用户查看）。
