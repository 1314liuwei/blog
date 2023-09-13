# Zstandard 压缩算法

## 简介

Zstandard 是 Facebook 在 2016年开源的无损压缩算法，优点是压缩率和解压缩性能都很好。官方库地址：https://github.com/facebook/zstd

Linux内核、HTTP协议、以及一系列的大数据工具（包括Hadoop 3.0.0，HBase 2.0.0，Spark 2.3.0，Kafka 2.1.0）等都已经加入了对zstd的支持。

## 使用

在 Go 中使用 zstd，有两个库推介：

- github.com/klauspost/compress/zstd：这是一个纯 Go 实现的 zstd 算法；
- github.com/valyala/gozstd：这是一个基于 CGO 实现的 zstd 算法。