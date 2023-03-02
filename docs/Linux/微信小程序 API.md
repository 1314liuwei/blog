# 微信小程序API

## 概要

- **请求方式都为 POST！**
- **HTTP 请求码为 400 时代表输入有误！**
- **HTTP 请求码为为 200 时代表请求成功！**

## 1. 表达式转LaTex

**url**: https://try-hard.cn/generate_latex

```json
{
    "exp": "x^2"  // 表达式
}
```

**返回结果**：

![x^2](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20x%5E%7B2%7D)

## 2. 表达式计算

**url**: https://try-hard.cn/simple

```json
{
    "exp": "1+10",  // 表达式
    "args": "",  // 暂不使用
    "retain": "2"  // 结果保留位数
}
```

**返回结果**：

![1+10](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cmathtt%7B%5Ctext%7B11.00%7D%7D)

## 3. 函数求导

**url**: https://try-hard.cn/derivative

```json
{
    "exp": "x^2",  // 求导表达式
    "var": "x",  // 被求导变量
    "order": "1"  // 阶数
}
```

**返回结果**：

![x^2](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%202%20x)

## 4. 积分求解

**url**: https://try-hard.cn/integral

**定积分**

```json
{
    "exp": "x^2*(1-x^2)^(1/2)",  // 被积表达式
    "vars": "x",  // 积分变量
    "upper": "1",  // 积分上限
    "lower": "-1"  // 积分下限
}
```

**返回结果**：

![x^2*(1-x^2)^(1/2)](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cfrac%7B%5Cpi%7D%7B8%7D)

**不定积分**

```json
{
    'exp': 'x^k',
 	'vars': 'x'
}
```

**返回结果：**

![x^k](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cbegin%7Bcases%7D%20%5Cfrac%7Bx%5E%7Bk%20%2B%201%7D%7D%7Bk%20%2B%201%7D%20%26%20%5Ctext%7Bfor%7D%5C%3A%20k%20%5Cneq%20-1%20%5C%5C%5Clog%7B%5Cleft%28x%20%5Cright%29%7D%20%26%20%5Ctext%7Botherwise%7D%20%5Cend%7Bcases%7D)

## 5. 极限求取

**url**: https://try-hard.cn/limit

```json
{
    "exp": "(asin(x)-atan(x))/(sin(x)-tan(x))",  // 求极限的式子
    "var": "x",  // 变量
    "value": 0,  // 极限点
    "symbol": ""  // 左侧逼近则为 -；右侧逼近则为 +；两侧逼近则为 空
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20-1)

## 6. 解方程

**url**: https://try-hard.cn/solve

```json
{
    "exps": ["x+1=y", "x+2=5"],  // 方程组
    "vars": ["x", "y"]  // 未知数
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cleft%5C%7B%5Cbegin%7Bmatrix%7Dx%20%3D%203%5C%5Cy%20%3D%204%5Cend%7Bmatrix%7D%5Cright.)

## 7. 反函数求取

**url**: https://try-hard.cn/inverse

```json
{
    "exp": "y=sin(x)",  // 函数表达式
    "var": "x"  // 变量
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cleft%5C%7B%5Cbegin%7Bmatrix%7Dx%20%3D%20%5Cpi%20-%20%5Coperatorname%7Basin%7D%7B%5Cleft%28y%20%5Cright%29%7D%5C%5Cx%20%3D%20%5Coperatorname%7Basin%7D%7B%5Cleft%28y%20%5Cright%29%7D%5Cend%7Bmatrix%7D%5Cright.)

## 8. 泰勒级数展开

**url**: https://try-hard.cn/series

```json
{
    "exp": "atan(x)",  // 函数
    "var": "x",  // 自变量
    "point": 0,  // 展开点
    "power": 7  // 幂
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20x%20-%20%5Cfrac%7Bx%5E%7B3%7D%7D%7B3%7D%20%2B%20%5Cfrac%7Bx%5E%7B5%7D%7D%7B5%7D%20-%20%5Cfrac%7Bx%5E%7B7%7D%7D%7B7%7D%20%2B%20O%5Cleft%28x%5E%7B8%7D%5Cright%29)

## 9. 因式分解

**url**: https://try-hard.cn/factor

```json
{
    "exp": "x**3 - x**2 + x - 1"  // 被分解的式子
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cleft%28x%20-%201%5Cright%29%20%5Cleft%28x%5E%7B2%7D%20%2B%201%5Cright%29)

## 10. 多项式展开

**url**: https://try-hard.cn/expand

```json
{
    "exp": "(x + 1)**2"  // 被展开的式子
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20x%5E%7B2%7D%20%2B%202%20x%20%2B%201)

## 11. 合并同类项

**url**: https://try-hard.cn/collect

```json
{
    "exp": "x*y + x - 3 + 2*x**2 - z*x**2 + x**3",  // 表达式
    "var": "x"  // 要合并的自变量
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20x%5E%7B3%7D%20%2B%20x%5E%7B2%7D%20%5Cleft%282%20-%20z%5Cright%29%20%2B%20x%20%5Cleft%28y%20%2B%201%5Cright%29%20-%203)

## 12. 有理分式化简

**url**: https://try-hard.cn/cancel

```json
{
    "exp": "(x**2 + 2*x + 1)/(x**2 + x)"  // 表达式
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cfrac%7Bx%20%2B%201%7D%7Bx%7D)

## 13. 部分分式展开

**url**: https://try-hard.cn/apart

```json
{
    "exp": "(4*x**3 + 21*x**2 + 10*x + 12)/(x**4 + 5*x**3 + 5*x**2 + 4*x)"  // 表达式
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%20%5Cfrac%7B2%20x%20-%201%7D%7Bx%5E%7B2%7D%20%2B%20x%20%2B%201%7D%20-%20%5Cfrac%7B1%7D%7Bx%20%2B%204%7D%20%2B%20%5Cfrac%7B3%7D%7Bx%7D)

## 14. 阶乘计算

**url**: https://try-hard.cn/factorial

```json
{
    "num": 4  // 阶数
}
```

**返回结果**：

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%2024)

## 15. 求和式计算

**url：**https://try-hard.cn/summation

```json
{
    "exp": "1/2^i",  // 表达式
    "var": "i",  // 自变量
    "start": "0",  // 起始值
    "end": "oo"  // 结束值
}
```

**返回结果：**

![](https://latex.codecogs.com/png.latex?%5Cinline%20%5Cdpi%7B300%7D%20%5Cbg_white%20%5Chuge%202)