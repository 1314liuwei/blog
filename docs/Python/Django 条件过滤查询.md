# Django 条件过滤查询

# 1. 条件选取 QuerySet

**filter表示 = ；exclude表示 !=；distinct表示去重复**

| 语法          | 功能                 |
| ------------- | -------------------- |
| __exact       | 精确查询             |
| __iexact      | 精确查询，忽略大小写 |
| __contains    | 包含                 |
| __icontains   | 包含，忽略大小写     |
| __gt          | 大于                 |
| __gte         | 大于等于             |
| __lt          | 小于                 |
| __lte         | 小于等于             |
| __in          | 存在于list中         |
| __startswith  | 开头包含             |
| __istartswith | 开头包含，忽略大小写 |
| __endswith    | 结尾包含             |
| __iendswith   | 结尾包含，忽略大小写 |
| __range       | 在范围里             |
| __year        | 日期字段查询年       |
| __month       | 日期字段查询月       |
| __day         | 日期字段查询日       |
| __isnull      | 字段为空             |

# 2. 多表查询
```python
# 模型
class A(models.Model):
    name = models.CharField(max_length=10）

class B(models.Model):
    a = models.ForeignKey(A)

# 查询语句
B.objects.filter(a__name__contains='XXXX')
# 作用：查询B表中外键aa所对应的表（即A表），表中字段 name 包含searchtitle的B表对象
```
# 3. 反向查询

```python
# 模型
class A(models.Model):
   name = models.CharField(max_length=10)
  
class B(models.Model):
   aa = models.ForeignKey(A, related_name="FAN")
   bb = models.CharField(max_length=10)

# 查询语句
A.objects.filter(FAN__bb='XXXX')
# 作用：B.aa=A 且 B.bb=XXXX


```