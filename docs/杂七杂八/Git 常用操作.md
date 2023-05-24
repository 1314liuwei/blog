# Git 常用操作

## 1. 强制 pull 覆盖本地

```bash
# 1. 下载远程库的所有内容，但不与本地做任何合并git
git fetch --all

# 2. 撤销工作区中所有未提交的修改内容，将暂存区与工作区都回到远程仓库最新版本
git reset --hard origin/master

# 3. 再更新一次（可用可不用，因为第二次已经更新了）
git pull
```

## 2. 新建分支并同步到远程

```bash
# 1. 新建本地 develop 分支并切换
git checkout -b develop

# 2. 同步到远程分支
git push origin develop:develop
```

