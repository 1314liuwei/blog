# Keras 中 model.evaluate 和 model.predict 的区别

## mode.evaluate

**官方声明：**[传送门](https://keras.io/api/models/model_training_apis/#evaluate-method)

**输入参数：**

```python
evaluate(x=None, y=None, batch_size=None, verbose=1, sample_weight=None, steps=None, callbacks=None, max_queue_size=10, workers=1, use_multiprocessing=False)
```

- x：输入数据
- y：输入标签
- batch_size：批次大小
- verbose：0不显示进度条，1为显示进度条
- sample_weight：测试样本的可选Numpy权重数组，用于对损失函数加权
- steps：样本批次
- callbacks：评估期间需要应用的回调列表
- max_queue_size：生成器队列的最大大小
- workers：执行期间使用的进程数
- use_multiprocessing：如果为`True`，则使用基于进程的线程

**返回值：**

- 损失值：网络在训练数据上的损失（预测值和实际值之间的差距），该值和编译模型时选择的损失有关
- 精度：准确率（成功数量与总数据量的比值）
- 返回格式：```['loss', 'accuracy']```

可以通过打印 model.metrics_names 来查看

## mode.predict

**官方文档：**[传送门](https://keras.io/api/models/model_training_apis/#predict-method)

**输入参数：**

```python
predict(x, batch_size=None, verbose=0, steps=None, callbacks=None, max_queue_size=10, workers=1, use_multiprocessing=False)
```

- x：输入数据
- others：同上

**返回值：**

- 输出输入数据的预测结果，需要自己手动比较