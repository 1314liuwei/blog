# FFmpeg 开发之时间基

## 前言

在了解FFmpeg中的时间基之前，我们需要了解一些基本概念。

只有掌握了这些基础概念，我们才能够理解FFmpeg中的时间基以及它们之间的转换。

## 基础知识

### I、P、B帧

视频压缩中，每帧都代表着一幅静止的图像。而在进行实际压缩时，会采取各种算法以减少数据的容量，其中 IPB 帧就是最常见的一种。

I 帧、P 帧、B 帧的区别在于：

- I 帧（Intra coded frames）：I 帧图像采用帧内编码方式，即**只利用了单帧图像内的空间相关性，而没有利用时间相关性，解码时只需要本帧数据就可以完成**。I 帧使用帧内压缩，不使用运动补偿，由于 I 帧不依赖其它帧，所以是随机存取的入点，同时**是解码的基准帧**。I 帧主要用于接收机的初始化和信道的获取，以及节目的切换和插入，I 帧图像的压缩倍数相对较低。I 帧图像是周期性出现在图像序列中的，出现频率可由编码器选择。
- P 帧（Predicted frames）：P 帧和 B 帧图像采用帧间编码方式，即同时利用了空间和时间上的相关性。**P 帧图像只采用前向时间预测，P帧没有完整画面数据，只有与前一帧的画面差别的数据**，可以提高压缩效率和图像质量。P 帧图像中可以包含帧内编码的部分，即 P 帧中的每一个宏块可以是前向预测，也可以是帧内编码。
- B 帧（Bi-directional predicted frames）：B 帧图像采用双向时间预测，即B帧记录的是本帧与前后帧的差别。B帧可以大大提高压缩倍数，但B 帧图像采用了未来帧作为参考，因此 MPEG-2 编码码流中图像帧的传输顺序和显示顺序是不同的。换言之，**要解码B帧，不仅要取得之前的缓存画面，还要解码之后的画面，通过前后画面的与本帧数据的叠加取得最终的画面**。

可想而知，解码时依赖其他帧的信息越多，说明当前帧的冗余越少，压缩率越高，一个简单的估算可以认为I帧、P帧、B帧的大小比例可达到9∶3∶1。

这就带来一个问题：在视频流中，先到来的 B 帧无法立即解码，需要等待它依赖的后面的 I、P 帧先解码完成，这样一来播放时间与解码时间不一致了，顺序打乱了，那这些帧该如何播放呢？

这时就需要我们来引另外两个概念：**DTS 和 PTS**

### DTS和PTS 

- DTS（Decoding Time Stamp）：**解码时间戳**，这个时间戳的意义在于告诉播放器该在什么时候解码这一帧的数据。
- PTS（Presentation Time Stamp）：**显示时间戳**，这个时间戳用来告诉播放器该在什么时候显示这一帧的数据。

注意：虽然 DTS、PTS 是用于指导播放端的行为，但它们是在编码的时候由编码器生成的。

当视频流中没有 B 帧时，通常 DTS 和 PTS 的顺序是一致的。但如果有 B 帧时，就回到了我们前面说的问题：解码顺序和播放顺序不一致了。

比如一个视频中，帧的顺序是：I B B P，我们在解码 B 帧需要知道 P 帧中信息，因此这几帧的解码顺序可能是：I P B B，这时候就体现出**每帧都有 DTS 和 PTS** 的作用了。DTS 告诉我们该按什么顺序解码这几帧图像，PTS 告诉我们该按什么顺序显示这几帧图像。例如：

```
实际应展示的顺序：I    B    B    P
  实际存放的顺序：I    P    B    B
按存放顺序号解码：1    4    2    3
按实际顺序号展示：1    2    3    4
```

### 音视频同步

在一个媒体流中，除了视频以外，通常还包括音频。

在音频中也有 DTS、PTS 的概念，但是音频没有类似视频中 B 帧，不需要双向预测，所以音频帧的 DTS、PTS 顺序是一致的。

音频视频混合在一起播放，就呈现了我们常常看到的广义的视频。在音视频一起播放的时候，我们通常需要面临一个问题：怎么去同步它们，以免出现画不对声的情况。

要实现音视频同步，通常需要选择一个参考时钟，参考时钟上的时间是线性递增的，编码音视频流时依据参考时钟上的时间给每帧数据打上时间戳。在播放时，读取数据帧上的时间戳，同时参考当前参考时钟上的时间来安排播放。这里的说的时间戳就是我们前面说的 PTS。

在项目实践中，我们可以选择：同步视频到音频、同步音频到视频、同步音频和视频到外部时钟。

## FFmpeg中涉及的时间基

基础了解完了，就需要回到我们的 FFmpeg 中来对上面的概念进行操作了。

### 音视频的时间基

我们在执行 ffmpeg/ffplay 命令时，可以通过控制台看到几个参数，分别是 tbr, tbn, tbc，这三个参数代表着不同的时间基：

- tbr：通常说的帧率。time base of rate
- tbn：视频流的时间基。 time base of stream
- tbc：视频解码的时间基。time base of codec

时间基实际上就是刻度。以帧率为例，如果帧率是 25帧/秒，那么它的时间基（时间刻度）就是 1/25。即两帧之间的时间为 1/25秒。

如过当前的时间是 100， 时间基是 1/25，那么转成秒的时间就是100 * 1/25 = 4秒。

### AVRational

- **主要功能：** 表示时间刻度
- **官方定义：**

```c++
/**
 * Rational number (pair of numerator and denominator).
 */
typedef struct AVRational{
    int num; ///< Numerator
    int den; ///< Denominator
} AVRational;// 标识一个分数，num为分数，den为分母
```

### AV_TIME_BASE

**定义：** 这FFmpeg 中的内部计时单位（时间基），FFmepg 中的所有时间都是于它为一个单位，比如 AVStream 中的 duration 即以为着这个流的长度为 duration个 AV_TIME_BASE。AV_TIME_BASE 定义为：

```c++
/**
 * Internal time base represented as integer
 */

#define AV_TIME_BASE            1000000
```

### AV_TIME_BASE_Q

FFmepg 内部时间基的分数表示，实际上它是 AV_TIME_BASE 的倒数。从它的定义能很清楚的看到这点：

```c++
/**
 * Internal time base represented as fractional value
 */

#define AV_TIME_BASE_Q          (AVRational){1, AV_TIME_BASE}
```

### AVRounding

```c++
enum AVRounding {
    AV_ROUND_ZERO     = 0, ///< Round toward zero.
    AV_ROUND_INF      = 1, ///< Round away from zero.
    AV_ROUND_DOWN     = 2, ///< Round toward -infinity.
    AV_ROUND_UP       = 3, ///< Round toward +infinity.
    AV_ROUND_NEAR_INF = 5, ///< Round to nearest and halfway cases away from zero.
    /**
     * Flag telling rescaling functions to pass `INT64_MIN`/`MAX` through
     * unchanged, avoiding special cases for #AV_NOPTS_VALUE.
     *
     * Unlike other values of the enumeration AVRounding, this value is a
     * bitmask that must be used in conjunction with another value of the
     * enumeration through a bitwise OR, in order to set behavior for normal
     * cases.
     *
     * @code{.c}
     * av_rescale_rnd(3, 1, 2, AV_ROUND_UP | AV_ROUND_PASS_MINMAX);
     * // Rescaling 3:
     * //     Calculating 3 * 1 / 2
     * //     3 / 2 is rounded up to 2
     * //     => 2
     *
     * av_rescale_rnd(AV_NOPTS_VALUE, 1, 2, AV_ROUND_UP | AV_ROUND_PASS_MINMAX);
     * // Rescaling AV_NOPTS_VALUE:
     * //     AV_NOPTS_VALUE == INT64_MIN
     * //     AV_NOPTS_VALUE is passed through
     * //     => AV_NOPTS_VALUE
     * @endcode
     */
    AV_ROUND_PASS_MINMAX = 8192,
};
```

> AV_ROUND_ZERO     = 0, // Round toward zero.      趋近于0
> AV_ROUND_INF      = 1, // Round away from zero.   趋远于0
> AV_ROUND_DOWN     = 2, // Round toward -infinity. 趋于更小的整数
> AV_ROUND_UP       = 3, // Round toward +infinity. 趋于更大的整数
> AV_ROUND_NEAR_INF = 5, // Round to nearest and halfway cases away from zero. 四舍五入,小于0.5取值趋向0,大于0.5取值趋远于0

### av_rescale_q(int64_t a, AVRational bq, AVRational cq)

- 功能：计算 a*bq / cq来把时间戳从一个时间基调整到另外一个时间基。在进行时间基转换的时候，应该首先这个函数，因为它可以避免溢出的情况发生。

### av_rescale_q_rnd(int64_t a, AVRational bq, AVRational cq, enum AVRounding rnd)

- **功能：**将以 时间基c 表示的 数值a 转换成以 时间基b 来表示。
- **定义：**

```c++
/**
 * Rescale a 64-bit integer by 2 rational numbers with specified rounding.
 *
 * The operation is mathematically equivalent to `a * bq / cq`.
 *
 * @see av_rescale(), av_rescale_rnd(), av_rescale_q()
 */
int64_t av_rescale_q_rnd(int64_t a, AVRational bq, AVRational cq,
                         enum AVRounding rnd) av_const;
```

### av_q2d(AVRational a)

- **功能：**将AVRatioal结构转换成double
- **定义：**

```c++
/**
 * Convert an AVRational to a `double`.
 * @param a AVRational to convert
 * @return `a` in floating-point form
 * @see av_d2q()
 */
static inline double av_q2d(AVRational a){
    return a.num / (double) a.den;
}
```

### 示例

```c++
if (pkt.pts == AV_NOPTS_VALUE)  //判断有无PTS值
{
    AVRational time_basel = ifmt_ctx->streams[videoindex]->time_base;  //获取视频文件的时间基
    int64_t calc_duration = (double)AV_TIME_BASE / av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
    pkt.pts = (double) (frame_index*calc_duration) / (double)(av_q2d(time_basel)*AV_TIME_BASE);
    pkt.dts = pkt.pts;
    pkt.duration = (double)calc_duration / (double)(av_q2d(time_basel)*AV_TIME_BASE);
}

if (pkt.stream_index == videoindex) {  //判断帧位置
    AVRational time_base = ifmt_ctx->streams[videoindex]->time_base;
    AVRational time_base_q = {1, AV_TIME_BASE};
    int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
    int64_t now_time = av_gettime() - start_time;
    if (pts_time > now_time) // 判断当前时间是否为该帧的放映时间
    {
        av_usleep(pts_time - now_time);//延时
    }
}
```

## 参考：

[FFmpeg 入门(5)：视频同步](http://www.samirchen.com/ffmpeg-tutorial-5/)

[ffmpeg中的时间戳与时间基](https://www.imooc.com/article/91381)

[最简单的基于FFmpeg的推流器（以推送RTMP为例）](https://blog.csdn.net/leixiaohua1020/article/details/39803457)