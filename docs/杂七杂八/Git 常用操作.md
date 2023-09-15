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

## 3. 统计提交历史

```bash
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
```

## 4. 凭证存储，避免重复输入验证

```bash
git config --global credential.helper store
```

## 5. 版本重置到指定提交

```bash
# 1. 查询提交历史版本
git log 

commit ef42757aa711f4716f8609e46c5618ee4f924dba (HEAD -> dev, origin/dev)
......

# 2. 重置到指定版本
# 移动 Head 并重置暂存区和工作区
git reset --hard ef42757aa711f4716f8609e46c5618ee4f924dba

# 移动 Head 但不重置暂存区和工作区
git reset --soft ef42757aa711f4716f8609e46c5618ee4f924dba
```

## 6. 强制将本地分支覆盖远程分支

```bash
git push origin <name> --force
```

