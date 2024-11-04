# 图片在 iOS 和其他平台显示不同

经过查询，发现这是 iOS 图片解码器并发解码图片时产生的数据竞争 Bug，在新版本的 iOS 系统中已经被修复。详情可见：https://github.com/DavidBuchanan314/ambiguous-png-packer