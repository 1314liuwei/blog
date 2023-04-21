# php 数组溢出

## 题目

```php
if($array[++$c]=1){
	if($array[]=1){
		echo "nonono";
	}
	else{
		require_once 'flag.php';
		echo $flag;
	}
}
```

## 解析

本题重点在此行：

```php
$array[]=1
```

此语句正常赋值时，返回结果一定是为 1 的，要想跳出这个判断语句，必须让它赋值出问题。

查阅资料后发现：

> 作为PHP最重要的数据类型HashTable其key值是有一定的范围的，如果设置的key值过大就会出现溢出的问题，临界点是`9223372036854775807`这个数字。
>
> ——参考来源：[PHP数组的key溢出问题 | oohcode | $\bigodot\bigodot^H \rightarrow CODE$ (two.github.io)](https://two.github.io/2015/09/15/PHP-array-hash-key-overflow/)

解决此题只需要给 $c 赋值 `9223372036854775806`，那么就能跳出语句判断。

