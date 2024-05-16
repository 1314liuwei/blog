# FFmpeg 中常用结构体

> 本文参考了雷神的讲解，再加上一些自己的查找。总结了一下自己开发时常用的结构体的属性及用途，方便自己后面查询使用。由于自己使用的FFmpeg版本为 **4.3.1**，因此可能会和雷神的有一些出入，具体细节大家可以参看官方文档。
>
> 雷神的原文：[FFMPEG中最关键的结构体之间的关系](https://blog.csdn.net/leixiaohua1020/article/details/11693997)

## 结构体之间的关系

![img](https://pic.try-hard.cn/blog/20130914204051125)

## 解封装

### AVOutputFormat

- 主要功能：保存了输出格式（MP4、flv等）的信息和一些常规设置。

- 主要信息：

```cpp
const char *name;
const char *long_name;//格式的描述性名称，易于阅读。
enum AVCodecID audio_codec; //默认的音频编解码器
enum AVCodecID video_codec; //默认的视频编解码器
enum AVCodecID subtitle_codec; //默认的字幕编解码器
struct AVOutputFormat *next;
int (*write_header)(struct AVFormatContext *);
int (*write_packet)(struct AVFormatContext *, AVPacket *pkt);//写一个数据包。 如果在标志中设置AVFMT_ALLOW_FLUSH，则pkt可以为NULL。
int (*write_trailer)(struct AVFormatContext *);
int (*interleave_packet)(struct AVFormatContext *, AVPacket *out, AVPacket *in, int flush);
int (*control_message)(struct AVFormatContext *s, int type, void *data, size_t data_size);//允许从应用程序向设备发送消息。
int (*write_uncoded_frame)(struct AVFormatContext *, int stream_index,   AVFrame **frame, unsigned flags);//写一个未编码的AVFrame。
int (*init)(struct AVFormatContext *);//初始化格式。 可以在此处分配数据，并设置在发送数据包之前需要设置的任何AVFormatContext或AVStream参数。
void (*deinit)(struct AVFormatContext *);//取消初始化格式。
int (*check_bitstream)(struct AVFormatContext *, const AVPacket *pkt);//设置任何必要的比特流过滤，并提取全局头部所需的任何额外数据。
```

![img](https://pic.try-hard.cn/blog/20161021114952074)

### AVFormatContext

- 主要功能：描述了一个媒体文件或媒体流的构成和基本信息

- 主要信息：

  ```cpp
  struct AVInputFormat *iformat;//输入数据的封装格式。仅解封装用，由avformat_open_input()设置
  struct AVOutputFormat *oformat;//输出数据的封装格式。仅封装用，调用者在avformat_write_header()之前设置
  AVIOContext *pb;  // I/O上下文
  // 解封装：由用户在avformat_open_input()之前设置（然后用户必须手动关闭它）或通过avformat_open_input()设置
  // 封装：由用户在avformat_write_header()之前设置。 调用者必须注意关闭/释放IO上下文
  unsigned int nb_streams;//AVFormatContext.streams中元素的个数
  AVStream **streams;//文件中所有流的列表
  char filename[1024];//输入输出文件名
  int64_t start_time;//第一帧的位置
  int64_t duration;//流的持续时间
  int64_t bit_rate;//总流比特率（bit / s），如果不可用则为0。
  int64_t probesize;//从输入读取的用于确定输入容器格式的数据的最大大小。仅封装用，由调用者在avformat_open_input()之前设置。
  AVDictionary *metadata;//元数据
  AVCodec *video_codec;//视频编解码器
  AVCodec *audio_codec;//音频编解码器
  AVCodec *subtitle_codec;//字母编解码器
  AVCodec *data_codec;//数据编解码器
  int (*io_open)(struct AVFormatContext *s, AVIOContext **pb, const char *url, int flags, AVDictionary **options);//打开IO stream的回调函数。
  void (*io_close)(struct AVFormatContext *s, AVIOContext *pb);//关闭使用AVFormatContext.io_open()打开的流的回调函数
  ```

  ## 解码

  ### AVStream

  - 主要功能：存储每一个视频/音频流信息
  - 主要信息：

  ```cpp
  int index; //在AVFormatContext中的索引，这个数字是自动生成的，可以通过这个数字从AVFormatContext::streams表中索引到该流。
  int id;//流的标识，依赖于具体的容器格式。解码：由libavformat设置。编码：由用户设置，如果未设置则由libavformat替换。
  AVCodecContext *codec;//指向该流对应的AVCodecContext结构，调用avformat_open_input时生成。
  AVRational time_base;//这是表示帧时间戳的基本时间单位（以秒为单位）。该流中媒体数据的pts和dts都将以这个时间基准为粒度。
  int64_t start_time;//流的起始时间，以流的时间基准为单位。如需设置，100％确保你设置它的值真的是第一帧的pts。
  int64_t duration;//解码：流的持续时间。如果源文件未指定持续时间，但指定了比特率，则将根据比特率和文件大小估计该值。
  int64_t nb_frames; //此流中的帧数（如果已知）或0。
  enum AVDiscard discard;//选择哪些数据包可以随意丢弃，不需要去demux。
  AVRational sample_aspect_ratio;//样本长宽比（如果未知，则为0）。
  AVDictionary *metadata;//元数据信息。
  AVRational avg_frame_rate;//平均帧速率。解封装：可以在创建流时设置为libavformat，也可以在avformat_find_stream_info（）中设置。封装：可以由调用者在avformat_write_header（）之前设置。
  AVPacket attached_pic;//附带的图片。比如说一些MP3，AAC音频文件附带的专辑封面。
  int probe_packets;//编解码器用于probe的包的个数。
  int codec_info_nb_frames;//在av_find_stream_info（）期间已经解封装的帧数。
  int request_probe;//流探测状态，1表示探测完成，0表示没有探测请求，rest 执行探测。
  int skip_to_keyframe;//表示应丢弃直到下一个关键帧的所有内容。
  int skip_samples;//在从下一个数据包解码的帧开始时要跳过的采样数。
  int64_t start_skip_samples;//如果不是0，则应该从流的开始跳过的采样的数目。
  int64_t first_discard_sample;//如果不是0，则应该从流中丢弃第一个音频样本。
  
  int64_t pts_reorder_error[MAX_REORDER_DELAY+1];
  uint8_t pts_reorder_error_count[MAX_REORDER_DELAY+1];//内部数据，从pts生成dts。
  
  int64_t last_dts_for_order_check;
  uint8_t dts_ordered;
  uint8_t dts_misordered;//内部数据，用于分析dts和检测故障mpeg流。
  AVRational display_aspect_ratio;//显示宽高比。
  ```

  ### AVCodecContext

  - 主要功能：存储该视频/音频流使用解码方式的相关数据
  - 主要信息：

  ```cpp
  enum AVMediaType codec_type; //编解码器的类型（视频，音频...）。
  const struct AVCodec  *codec; //采用的解码器AVCodec（H.264,MPEG2...）。
  int64_t bit_rate;//平均比特率。
  uint8_t *extradata;//针对特定编码器包含的附加信息（例如对于H.264解码器来说，存储SPS，PPS等）。
  int extradata_size;
  AVRational time_base;//时间的基准单位，根据该参数，可以把PTS转化为实际的时间（单位为秒s）。
  编解码延迟。
  int delay;//编码：从编码器输入到解码器输出的帧延迟数。解码：除了规范中规定的标准解码器外产生的帧延迟数。
  int width, height;//代表宽和高（仅视频）。
  int refs;//运动估计参考帧的个数（H.264的话会有多帧，MPEG2这类的一般就没有了）。
  int sample_rate; //采样率（仅音频）。
  int channels; //声道数（仅音频）。
  enum AVSampleFormat sample_fmt;  //音频采样格式，编码：由用户设置。解码：由libavcodec设置。
  int frame_size;//音频帧中每个声道的采样数。编码：由libavcodec在avcodec_open2（）中设置。 解码：可以由一些解码器设置以指示恒定的帧大小.
  int frame_number;//帧计数器，由libavcodec设置。解码：从解码器返回的帧的总数。编码：到目前为止传递给编码器的帧的总数。
  uint64_t channel_layout;//音频声道布局。编码：由用户设置。解码：由用户设置，可能被libavcodec覆盖。
  enum AVAudioServiceType audio_service_type;//音频流传输的服务类型。编码：由用户设置。解码：由libavcodec设置。
  ```

  ### AVCodec

  - 主要功能：存储编解码器信息
  - 主要信息：

  ```cpp
  const char *name;//编解码器的名字，比较短。在编码器和解码器之间是全局唯一的。 这是用户查找编解码器的主要方式
  const char *long_name;//编解码器的名字，全称，比较长
  enum AVMediaType type;//指明了类型，是视频，音频，还是字幕
  enum AVCodecID id;
  const AVRational *supported_framerates;//支持的帧率（仅视频）
  const enum AVPixelFormat *pix_fmts;//支持的像素格式（仅视频）
  const int *supported_samplerates;//支持的采样率（仅音频）
  const enum AVSampleFormat *sample_fmts;//支持的采样格式（仅音频）
  const uint64_t *channel_layouts;//支持的声道数（仅音频）
  int priv_data_size;//私有数据的大小
  void (*init_static_data)(struct AVCodec *codec);//初始化编解码器静态数据，从avcodec_register（）调用
  int (*encode2)(AVCodecContext *avctx, AVPacket *avpkt, const AVFrame *frame, int *got_packet_ptr);//将数据编码到AVPacket
  int (*decode)(AVCodecContext *, void *outdata, int *outdata_size, AVPacket *avpkt);//解码数据到AVPacket
  int (*close)(AVCodecContext *);//关闭编解码器。
  void (*flush)(AVCodecContext *);//刷新缓冲区。当seek时会被调用
  ```

  ### 关系

  ```mermaid
  graph TD
  	A[AVStream] --> B[AVCodecContext]
  B --> C[AVCodec]
  ```

  

  ## 存数据

  ### AVPacket

  - 主要功能：存储压缩编码数据相关信息，即解码前数据（例如H.264码流）
  - 主要信息：

  ```cpp
  int64_t pts;// 显示时间，结合AVStream->time_base转换成时间戳
  int64_t dts;// 解码时间，结合AVStream->time_base转换成时间戳
  int   size;//data的大小
  int   stream_index;//packet在stream的index位置
  int   flags;//标示，结合AV_PKT_FLAG使用，其中最低为1表示该数据是一个关键帧。
  #define AV_PKT_FLAG_KEY    0x0001 //关键帧
  #define AV_PKT_FLAG_CORRUPT 0x0002 //损坏的数据
  #define AV_PKT_FLAG_DISCARD  0x0004 //丢弃的数据
  int side_data_elems;//边缘数据元数个数
  int64_t duration;//数据的时长，以所属媒体流的时间基准为单位，未知则值为默认值0
  int64_t pos;//数据在流媒体中的位置，未知则值为默认值-1
  uint8_t *data;//指向保存压缩数据的指针，这就是AVPacket的实际数据。
  AVPacketSideData *side_data;//容器提供的一些附加数据
  AVBufferRef *buf;//用来管理data指针引用的数据缓存
  ```

  ### AVFrame

  - 主要功能：解码后数据（YUV/RGB像素数据）。AVFrame必须由 **av_frame_alloc()分配内存** ，同时必须由**av_frame_free()释放**，分配内存后能够被**多次用来存储不同的数据**。
  - 主要信息：

  ```cpp
  uint8_t *   data [AV_NUM_DATA_POINTERS];//解码后原始数据（对视频来说是YUV，RGB，对音频来说是PCM）。
  int linesize[AV_NUM_DATA_POINTERS];//在视频中，表示图片一行数据的大小。
  uint8_t **extended_data;//指向数据平面/通道。
  int width, height;//一个视频帧的宽度和高度。
  int nb_samples;//这个AVFrame中的每个音频通道中包含的音频帧个数。
  int format;//表示解码后的数据类型或格式，-1表示未被设置或不能识别的类型。
  int key_frame;//是否为关键帧。
  enum AVPictureType pict_type;//帧的类型。
  AVRational sample_aspect_ratio;//视频帧的宽高比，0表示未知。
  int64_t pts;//显示时间戳，表示该什么时候被显示。
  int64_t pkt_dts;//从AVPacket中拷贝的值。
  int coded_picture_number;//编码帧序号。
  int display_picture_number;//显示帧需要。
  void *opaque;//用户私有信息。
  int repeat_pict;//解码时，每帧图片延迟的时间，extra_delay = repeat_pict / (2*fps)。
  int interlaced_frame;//是否是隔行扫描
  int sample_rate;//音频的采样率。
  uint64_t channel_layout;//音频的布局方式。
  ```