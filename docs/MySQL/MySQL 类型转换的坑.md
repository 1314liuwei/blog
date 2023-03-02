# MySQL 类型转换的坑

# 一、BUG复现

## 1. 表字段
| 字段名 | 类型    | 长度 | 主键  | 非空 |
| ------ | ------- | ---- | ----- | ---- |
| id     | int     | 2    | True  | True |
| name   | varchar | 255  | False | True |
## 2. 表记录
| id   | name |
| ---- | ---- |
| 0    | 张三 |
| 1    | 李四 |
| 2    | 王五 |
## 3. sql语句

```sql
select * from demo where id=0;
Result:
+----+----------+
| id |   name   |
+----+----------+
| 0  |   张三   |
+----+----------+

select * from demo where id='0';
Result:
+----+----------+
| id |   name   |
+----+----------+
| 0  |   张三   |
+----+----------+

select * from demo where id='hhh';
Result:
+----+----------+
| id |   name   |
+----+----------+
| 0  |   张三   |
+----+----------+

select * from demo where id='1';
Result:
+----+----------+
| id |   name   |
+----+----------+
| 1  |   李四   |
+----+----------+

select * from demo where id='1hhh';
Result:
+----+----------+
| id |   name   |
+----+----------+
| 1  |   李四   |
+----+----------+

select * from demo where id='hhh1';
Result:
+----+----------+
| id |   name   |
+----+----------+
| 0  |   张三   |
+----+----------+
```
# 二、问题原因
查阅 MySQL [官方文档](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html)后发现 文档中有这样一句话：

> Comparison operations result in a value of 1 (TRUE), 0 (FALSE), or NULL. These operations work for both numbers and strings. Strings are automatically converted to numbers and numbers to strings as necessary.

 意思是在做两个值的比较时，比较运算的结果是1 （TRUE），0 （FALSE）或NULL。这些操作适用于数字和字符串。字符串会自动转换为数字，数字会根据需要转换为字符串。

**在 sql语句中，如果字符串开头是数字，则将字符串转化为开头的数字；对于非开头的 sql语句，字符串默认转换为 0** 。

# 三、解决办法
## 注意书写格式
既然 MySQL 的类型转换有这么多的坑，那我们在书写 sql语句时首先要**明确字段的类型**，使用相同类型的数据做判断。