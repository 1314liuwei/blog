# Python 动态显示任务进度

# 一、print函数实现

#### flush参数：
在print函数的所有参数中，有一个关键字参数叫flush，这个参数为True时会将缓冲区的内容直接性输出。
#### \r转义字符：
转义字符\r会每次回到开头
我们可以巧妙利用flush参数和转义字符"\r"实现进度显示：
```python
for i in range(101):
	print("%d%"%i, end="", flush=True)
```
这样我们就可以实现从进度的展示了
![进度](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20191116222702358.gif)
# 二、tqdm模块
tqdm是 Python 进度条库，可以在 Python 长循环中添加一个进度提示信息用法：tqdm(iterator)。
## 安装
tqdm不是Python的官方自带库，需要用户自行安装。我们可以通过pip进行安装tqdm库：
```python
pip install tqdm
```
## 使用
#### 1. 进度条显示
tqdm()中需要传递一个可迭代对象；
 trange()是对range()函数的封装，相当于tqdm(range())，效果和上面相同
```python
import time
from tqdm import tqdm

for i in tqdm(range(10)):
    time.sleep(1)

效果：
100%|██████████| 10/10 [00:10<00:00,  1.00s/it]
```
#### 2. 进度条设置描述
```python
import time
from tqdm import tqdm

pbar = tqdm(["a", "b", "c", "d"])
for char in pbar:
    # 设置描述
    pbar.set_description("Processing")
    time.sleep(1)

效果：
Processing: 100%|██████████| 4/4 [00:04<00:00,  1.00s/it]
```
#### 3. 手动设置更新
```python
import time
from tqdm import tqdm

# 总数100，每次更新5，一共更新20次
# 方法一：
with tqdm(total=100) as pbar:
  for i in range(20):
    pbar.update(5) 
    time.sleep(1)

#方法二：
pbar = tqdm(total=200)  
for i in range(20):  
    pbar.update(5)
    time.sleep(1)
pbar.close()

效果：
100%|██████████| 100/100 [00:20<00:00,  5.00it/s]
```