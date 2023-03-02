

## 1. 比较运算符

| 符号 | 函数                         | 含义                                 |
| ---- | ---------------------------- | ------------------------------------ |
| >    | np.greater(arr1, arr2)       | 判断 arr1 的元素是否大于 arr2 的     |
| >=   | np.greater_equal(arr1, arr2) | 判断 arr1 的元素是否大于等于 arr2 的 |
| <    | np.less(arr1, arr2)          | 判断 arr1 的元素是否小于 arr2 的     |
| <=   | np.less_equal(arr1, arr2)    | 判断 arr1 的元素是否小于等于 arr2 的 |
| ==   | bp.equal(arr1, arr2)         | 判断 arr1 的元素是否等于 arr2 的     |
| !=   | np.not_equal(arr1, arr2)     | 判断 arr1 的元素是否不等于 arr2 的   |

## 2. 常用数学函数

| 函数                | 函数说明                       |
| ------------------- | ------------------------------ |
| np.pi               | 常数Π                          |
| np.e                | 常数e                          |
| np.fabs(arr)        | 计算各元素的浮点型绝对值       |
| np.ceil(arr)        | 对各元素向上取整               |
| np.floor(arr)       | 对各元素向下取整               |
| np.round(arr)       | 对各元素四舍五入               |
| np.fmod(arr1, arr2) | 计算 arr1 / arr2 的余数        |
| np.modf(arr)        | 返回数组元素小数部分和整数部分 |
| np.sqrt(arr)        | 计算各元素的算术平方根         |
| np.square(arr)      | 计算各元素的平方根             |
| np.exp(arr)         | 计算以 e 为底的指数            |
| np.power(arr, α)    | 计算各元素的指数               |
| np.log2(arr)        | 计算以 2 为底各元素的对数      |
| np.log10(arr)       | 计算以 10 为底各元素的对数     |
| np.log(arr)         | 计算以 e 为底各元素的对数      |

## 3. 统计函数

| 函数                  | 函数说明                         |
| --------------------- | -------------------------------- |
| np.min(arr, axis)     | 按照轴的方向计算最小值           |
| np.max(arr, axis)     | 按照轴的方向计算最大值           |
| np.mean(arr, axis)    | 按照轴的方向计算均值             |
| np.median(arr, axis)  | 按照轴的方向计算中位数           |
| np.sum(arr, axis)     | 按照轴的方向计算和               |
| np.std(arr, axis)     | 按照轴的方向计算标准差           |
| np.var(arr, axis)     | 按照轴的方向计算方差             |
| np.cumsum(arr, axis)  | 按照轴的方向计算累计和           |
| np.cumprod(arr, axis) | 按照轴的方向计算累计乘积         |
| np.argmin(arr, axis)  | 按照轴的方向计算最小值所在的位置 |
| np.argmax(arr, axis)  | 按照轴的方向计算最大值所在的位置 |
| np.corrcoef(arr)      | 计算皮尔逊相关系数               |
| np.cov(arr)           | 计算协方差矩阵                   |

**注：axis=1时按水平方向计算，为0时按垂直方向计算**

## 4. 线性代数相关计算

| 函数              | 函数说明                       |
| ----------------- | ------------------------------ |
| np.zeros          | 生成零矩阵                     |
| np.eye            | 生成单位矩阵                   |
| np.dot            | 计算两个数组的点积             |
| np.diag           | 矩阵主对角线与一维数组间的转换 |
| np.ones           | 生成所有元素为 1 的矩阵        |
| po.transpose      | 矩阵转置                       |
| np.inner          | 计算两个数组的内积             |
| np.trace          | 矩阵主对角线元素的和           |
| np.linalg.det     | 计算矩阵行列式                 |
| np.linalg.eigvals | 计算方阵特征根                 |
| np.linalg.pinv    | 计算方阵的 Moore-Penrose 伪逆  |
| np.linalg.lstsq   | 计算 Ax=b 的最小二乘解         |
| np.linalg.svd     | 计算奇异值分解                 |
| np.linalg.eig     | 计算矩阵特征根与特征向量       |
| np.linalg.inv     | 计算方阵的逆                   |
| np.linalg.solve   | 计算 Ax=b 的线性方程组解       |
| np.linalg.qr      | 计算 QR 分解                   |
| np.linalg.norm    | 计算向量或矩阵的范数           |

## 5. 伪随机数的生成

| 函数                                            | 函数说明                              |
| ----------------------------------------------- | ------------------------------------- |
| seed(n)                                         | 设置随机数种子                        |
| beta(a, b, size=None)                           | 生成 β 分布随机数                     |
| chisquare(df, size=None)                        | 生成卡方分布随机数                    |
| choice(a, size=None, replace=True, p=None)      | 从 a 中有放回地随机挑选指定数量地样本 |
| exponential(scale=1.0, size=None)               | 生成指数分布随机数                    |
| f(dfnum, dfden, size=None)                      | 生成 F 分布随机数                     |
| gamma(shape, scale=1.0, size=None)              | 生成 Γ 分布随机数                     |
| geometric(p, size=None)                         | 生成几何分布随机数                    |
| hypergeometric(ngood, nbad, nsample, size=None) | 生成超几何分布随机数                  |
| laplace(loc=0.0, scale=1.0, size=None)          | 生成拉普拉斯分布随机数                |
| logistic(loc=0.0, scale=1.0, size=None)         | 生成 Logistic 分布随机数              |
| lognormal(mean=0.0, sigma=1.0, size=None)       | 生成对数正态分布随机数                |
| negative_binomial(n, p, size=None)              | 生成负二项分布随机数                  |
| multinomial(n, pvals, size=None)                | 生成多项分布随机数                    |
| multivariate_normal(mean, cov[, size])          | 生成多元正态分布随机数                |
| normal(loc=0.0, scale=1.0, size=None)           | 生成正态分布随机数                    |
| pareto(a, size=None)                            | 生成帕累托分布随机数                  |
| poisson(lam=1.0, size=None)                     | 生成泊松分布随机数                    |
| rand(d0, d1, .., dn)                            | 生成 n 维的均匀分布随机数             |
| randn(d0, d1, ..., dn)                          | 生成 n 维的标准正态分布随机数         |
| randint(low, high=None, size=None, dtype='1')   | 生成指定范围的随机整数                |
| random_sample(size=None)                        | 生成 [0, 1) 的随机数                  |
| standard_t(df, size=None)                       | 生成标准的 t 分布随机数               |
| uniform(low=0.0, high=1.0, size=None)           | 生成指定范围的均匀分布随机数          |
| wald(mean, scale, size=None)                    | 生成 Wald 分布随机数                  |
| weibull(a, size=None)                           | 生成 Weibull 分布随机数               |

**注：以上随机数生成函数位于 numpy 模块的 random 子模块**

## 6. 其它常用函数

| 函数                 | 函数说明                       |
| -------------------- | ------------------------------ |
| arange               | 类似于 Python 的内建函数 range |
| array                | 构造数组对象                   |
| ix_                  | 构造数组索引                   |
| genfromtxt           | 读取文本文件数据的函数         |
| shape                | 返回数组形状                   |
| ndim                 | 返回数组维数                   |
| size                 | 返回数组元素个数               |
| dtype                | 返回数组数据类型               |
| reshape              | 重塑数组形状                   |
| resize               | 重塑数组形状                   |
| flatten              | 将多维数组降为一维数组         |
| ravel                | 将多维数组降为一维数组         |
| vstack、row_stack    | 数组的垂直堆叠函数             |
| hstack、column_stack | 数组的水平合并函数             |
| where                | 类似于 Excel 的 if 函数        |

