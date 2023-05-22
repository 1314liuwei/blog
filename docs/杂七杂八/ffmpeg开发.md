# FFmpeg 开发

# nginx+RTMP安装配置

``` bash
# nginx源码下载
wget http://nginx.org/download/nginx-1.8.1.tar.gz
# rtmp模块下载
git clone https://github.com/arut/nginx-rtmp-module.git
tar -zxvf nginx-1.8.1.tar.gz
yum install gcc pcre-devel zlib-devel
./configure --add-module=/root/nginx-rtmp-module
make
make install

vim /usr/local/nginx/conf/nginx.conf

# RTMP server
rtmp {    
    
    server {    
    
        listen 1935;  #监听的端口  
    
        chunk_size 4000;    
             
        application videotest {  #rtmp推流请求路径  
            live on;      
        }    
    }    
}
```

# gstreamer安装
```bash
yum install gstreamer*
```
# ffmpeg安装
```bash
wget https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar -jxvf ffmpeg-snapshot.tar.bz2
yum install yasm
./configure --enable-shared --prefix=/usr/local/ffmpeg
make
make install 
```

# gstreamer使用
## 摄像头视频流格式
```bash
gst-launch-1.0 v4l2src ! 'video/x-raw,format=(string)YUY2' ! autovideosink
```
## rtmp推流（失真和延时十分严重）
```bash
gst-launch-1.0 v4l2src ! "video/x-raw,width=352,height=288" ! videoparse width=352 height=288 framerate=30/1 ! x264enc bitrate=1024 ref=4 key-int-max=20 ! video/x-h264,profile=main ! h264parse ! video/x-h264 ! flvmux name=mux ! rtmpsink location='rtmp://192.168.170.129:1935/videotest/test'
```

# FFmpeg参数参考

## FFplay参数表

| 名称            | 有参数 | 作用                                     |
| --------------- | ------ | ---------------------------------------- |
| x               | Y      | 强制屏幕宽度                             |
| y               | Y      | 强制屏幕高度                             |
| s               | Y      | 强制屏幕大小                             |
| fs              | N      | 全屏                                     |
| an              | N      | 关闭音频                                 |
| vn              | N      | 关闭视频                                 |
| ast             | Y      | 设置想播放的音频流（需要指定流ID）       |
| vst             | Y      | 设置想播放的视频流（需要指定流ID）       |
| sst             | Y      | 设置想播放的字幕流（需要指定流ID）       |
| ss              | Y      | 从指定位置开始播放，单位是秒             |
| t               | Y      | 播放指定时长的视频                       |
| nodisp          | N      | 无显示屏幕                               |
| f               | Y      | 强制封装格式                             |
| pix_fmt         | Y      | 指定像素格式                             |
| stats           | N      | 显示统计信息                             |
| idct            | Y      | IDCT算法                                 |
| ec              | Y      | 错误隐藏方法                             |
| sync            | Y      | 视音频同步方式（type=audio/video/ext）   |
| autoexit        | N      | 播放完成自动退出                         |
| exitonkeydown   | N      | 按下按键退出                             |
| exitonmousedown | N      | 按下鼠标退出                             |
| loop            | Y      | 指定循环次数                             |
| framedrop       | N      | CPU不够的时候丢帧                        |
| window_title    | Y      | 显示窗口的标题                           |
| rdftspeed       | Y      | Rdft速度                                 |
| showmode        | Y      | 显示方式(0 = video, 1 = waves, 2 = RDFT) |
| codec           | Y      | 强制解码器                               |

## FFplay播放时的快捷键

播放视音频文件的时候，可以通过下列按键控制视音频的播放

| 按键              |                       作用                       |
| ----------------- | :----------------------------------------------: |
| q, ESC            |                       退出                       |
| f                 |                       全屏                       |
| p, 空格           |                       暂停                       |
| w                 |                   显示音频波形                   |
| s                 |                     逐帧显示                     |
| 左方向键/右方向键 |                 向后10s/向前10s                  |
| 上方向键/下方向键 |                向后1min/向前1min                 |
| page down/page up |               向后10min/向前10min                |
| 鼠标点击屏幕      | 跳转到指定位置（根据鼠标位置相对屏幕的宽度计算） |

## FFmpeg参数详解

**a) 通用选项**

| 参数               |                             功能                             |
| ------------------ | :----------------------------------------------------------: |
| -L                 |                            许可证                            |
| -h                 |                             帮助                             |
| -fromats           |                        显示可用的格式                        |
| -f fmt             |                       强迫采用格式fmt                        |
| -i filename        |                           输入文件                           |
| -y                 |                         覆盖输出文件                         |
| -t duration        |       设置纪录时间 hh:mm:ss[.xxx]格式的记录时间也支持        |
| -ss position       |        搜索到指定的时间 [-]hh:mm:ss[.xxx]的格式也支持        |
| -title string      |                           设置标题                           |
| -author string     |                           设置作者                           |
| -copyright string  |                           设置版权                           |
| -comment string    |                           设置评论                           |
| -target type       | 设置目标文件类型(vcd,svcd,dvd) 所有的格式选项（比特率，编解码以及缓冲区大小）自动设置，只需要输入如下的就可以了：ffmpeg -i myfile.avi -target vcd /tmp/vcd.mpg |
| -hq                |                        激活高质量设置                        |
| -itsoffset  offset | 设置以秒为基准的时间偏移，该选项影响所有后面的输入文件。该偏移被加到输入文件的时戳，定义一个正偏移意味着相应的流被延迟了 offset秒。 [-]hh:mm:ss[.xxx]的格式也支持 |

**b) 视频选项**

-b bitrate 设置比特率，缺省200kb/s
-r fps 设置帧频 缺省25
-s size 设置帧大小 格式为WXH 缺省160X128.下面的简写也可以直接使用：
Sqcif 128X96 qcif 176X144 cif 252X288 4cif 704X576
-aspect aspect 设置横纵比 4:3 16:9 或 1.3333 1.7777
-croptop size 设置顶部切除带大小 像素单位
-cropbottom size –cropleft size –cropright size
-padtop size 设置顶部补齐的大小 像素单位
-padbottom size –padleft size –padright size –padcolor color 设置补齐条颜色(hex,6个16进制的数，红:绿:兰排列，比如 000000代表黑色)
-vn 不做视频记录
-bt tolerance 设置视频码率容忍度kbit/s
-maxrate bitrate设置最大视频码率容忍度
-minrate bitreate 设置最小视频码率容忍度
-bufsize size 设置码率控制缓冲区大小
-vcodec codec 强制使用codec编解码方式。如果用copy表示原始编解码数据必须被拷贝。
-sameq 使用同样视频质量作为源（VBR）
-pass n 选择处理遍数（1或者2）。两遍编码非常有用。第一遍生成统计信息，第二遍生成精确的请求的码率
-passlogfile file 选择两遍的纪录文件名为file

**c)高级视频选项**

-g gop_size 设置图像组大小
-intra 仅适用帧内编码
-qscale q 使用固定的视频量化标度(VBR)
-qmin q 最小视频量化标度(VBR)
-qmax q 最大视频量化标度(VBR)
-qdiff q 量化标度间最大偏差 (VBR)
-qblur blur 视频量化标度柔化(VBR)
-qcomp compression 视频量化标度压缩(VBR)
-rc_init_cplx complexity 一遍编码的初始复杂度
-b_qfactor factor 在p和b帧间的qp因子
-i_qfactor factor 在p和i帧间的qp因子
-b_qoffset offset 在p和b帧间的qp偏差
-i_qoffset offset 在p和i帧间的qp偏差
-rc_eq equation 设置码率控制方程 默认tex^qComp
-rc_override override 特定间隔下的速率控制重载
-me method 设置运动估计的方法 可用方法有 zero phods log x1 epzs(缺省) full
-dct_algo algo 设置dct的算法 可用的有 0 FF_DCT_AUTO 缺省的DCT 1 FF_DCT_FASTINT 2 FF_DCT_INT 3 FF_DCT_MMX 4 FF_DCT_MLIB 5 FF_DCT_ALTIVEC
-idct_algo algo 设置idct算法。可用的有 0 FF_IDCT_AUTO 缺省的IDCT 1 FF_IDCT_INT 2 FF_IDCT_SIMPLE 3 FF_IDCT_SIMPLEMMX 4 FF_IDCT_LIBMPEG2MMX 5 FF_IDCT_PS2 6 FF_IDCT_MLIB 7 FF_IDCT_ARM 8 FF_IDCT_ALTIVEC 9 FF_IDCT_SH4 10 FF_IDCT_SIMPLEARM
-er n 设置错误残留为n 1 FF_ER_CAREFULL 缺省 2 FF_ER_COMPLIANT 3 FF_ER_AGGRESSIVE 4 FF_ER_VERY_AGGRESSIVE
-ec bit_mask 设置错误掩蔽为bit_mask,该值为如下值的位掩码 1 FF_EC_GUESS_MVS (default=enabled) 2 FF_EC_DEBLOCK (default=enabled)
-bf frames 使用frames B 帧，支持mpeg1,mpeg2,mpeg4
-mbd mode 宏块决策 0 FF_MB_DECISION_SIMPLE 使用mb_cmp 1 FF_MB_DECISION_BITS 2 FF_MB_DECISION_RD
-4mv 使用4个运动矢量 仅用于mpeg4
-part 使用数据划分 仅用于mpeg4
-bug param 绕过没有被自动监测到编码器的问题
-strict strictness 跟标准的严格性
-aic 使能高级帧内编码 h263+
-umv 使能无限运动矢量 h263+
-deinterlace 不采用交织方法
-interlace 强迫交织法编码仅对mpeg2和mpeg4有效。当你的输入是交织的并且你想要保持交织以最小图像损失的时候采用该选项。可选的方法是不交织，但是损失更大
-psnr 计算压缩帧的psnr
-vstats 输出视频编码统计到vstats_hhmmss.log
-vhook module 插入视频处理模块 module 包括了模块名和参数，用空格分开

**D)音频选项**

-ab bitrate 设置音频码率
-ar freq 设置音频采样率
-ac channels 设置通道 缺省为1
-an 不使能音频纪录
-acodec codec 使用codec编解码

**E)音频/视频捕获选项**

-vd device 设置视频捕获设备。比如/dev/video0
-vc channel 设置视频捕获通道 DV1394专用
-tvstd standard 设置电视标准 NTSC PAL(SECAM)
-dv1394 设置DV1394捕获
-av device 设置音频设备 比如/dev/dsp

**F)高级选项**

-map file:stream 设置输入流映射
-debug 打印特定调试信息
-benchmark 为基准测试加入时间
-hex 倾倒每一个输入包
-bitexact 仅使用位精确算法 用于编解码测试
-ps size 设置包大小，以bits为单位
-re 以本地帧频读数据，主要用于模拟捕获设备
-loop 循环输入流（只工作于图像流，用于ffserver测试）

# 使用到的FFmpeg命令

## 查看视频信息

```bash
ffmpeg -i video
```

- HEVC/H.265
- AVC/H.264

## 播放摄像头视频
```bash
ffplay -f video4linux2 -framerate 30 -video_size hd720 /dev/video0
```
- -f：强制使用设定的格式解析
- video4linux2：（简称V4L2)，是Linux中关于视频设备的内核驱动
- -framerate：指定帧率播放
- -video_size：设定播放视频尺寸
- hd720：720P分辨率
- /dev/video0：摄像头，在Linux里允许像读取文件一样读取摄像头数据

## 将本地摄像头数据用RTMP推流

```bash
ffmpeg -i /dev/video0 -vcodec libx264 -f flv rtmp://...
```

- -i：输入
- -f：强迫采用格式fmt
- flv：被众多新一代视频分享网站所采用，是增长最快、最为广泛的视频传播格式

## 保存RTSP流到本地文件

```bash
ffmpeg -i "rtsp://..." -vcodec copy -acodec copy xxx.flv
```

- -vcodec copy：vcodec指定视频编码器，copy 指明只拷贝，不做编解码
- -acodec copy：acodec指定音频编码器，copy 指明只拷贝，不做编解码

## 播放RTSP流

```bash
ffplay -rtsp_transport -max_delay 5000000 tcp rtsp://...
```

- -rtsp_transport tcp：ffmpeg默认采用UDP协议。当RTSP采用的是TCP协议时，直接播放就会报错，我们就需要指定协议
- -max_delay 5000000：指定最大延时为5000000微秒

## RTSP流转RTMP流

```bash
ffmpeg -rtsp_transport tcp -i "rtsp://..." -vcodec copy -an -f flv rtmp://...
```

### Unknown input format: 'dshow'

```bash
ffmpeg -list_devices true -f dshow -i dummy
```

dshow是**Windows** DirectShow输入设备，linux无法使用

## 输出视频所有信息并以json形式展现

```bash
ffprobe -i 输入视频路径 -v quiet -print_format json -show_format -show_streams
```



# 音视频处理流程

```mermaid

```



# FFmpeg主要结构体

## 结构体之间的关系

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20130914204051125)

## 解协议

### AVOutputFormat

- 主要功能：保存了输出格式（MP4、flv等）的信息和一些常规设置。

- 主要信息：

```c++
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

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/20161021114952074)

### AVFormatContext

- 主要功能：描述了一个媒体文件或媒体流的构成和基本信息

- 主要信息：

  ```c++
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

  ## 解封装

  ### AVFormatContext

  - 主要功能：

  ## 解码

  ### AVStream

  - 主要功能：存储每一个视频/音频流信息
  - 主要信息：

  ```c++
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

  ```c++
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

  ```c++
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
  
  ```c++
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
  
  - 主要功能：解码后数据（YUV/RGB像素数据）。AVFrame必须由** av_frame_alloc()分配内存**，同时必须由**av_frame_free()释放**，分配内存后能够被**多次用来存储不同的数据**。
  - 主要信息：
  
  ```c++
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
  
  
  
  # 常用函数

## av_register_all()

**功能**：该函数在所有基于ffmpeg的应用程序中几乎都是第一个被调用的。只有调用了该函数，才能使用复用器，编码器等。

## avformat_network_init()

**功能**：使用ffmpeg类库进行开发时，打开流媒体（或本地文件）的函数是 **avformat_open_input()**；

其中打开网络流的话，需要在前面调用函数 **avformat_network_init()**。

## avformat_open_input()

**功能**：打开多媒体数据并且获得一些相关的信息

```c++
/**
 * Open an input stream and read the header. The codecs are not opened.
 * The stream must be closed with avformat_close_input().
 *
 * @param ps Pointer to user-supplied AVFormatContext (allocated by avformat_alloc_context).
 *           May be a pointer to NULL, in which case an AVFormatContext is allocated by this
 *           function and written into ps.
 *           Note that a user-supplied AVFormatContext will be freed on failure.
 * @param url URL of the stream to open.
 * @param fmt If non-NULL, this parameter forces a specific input format.
 *            Otherwise the format is autodetected.
 * @param options  A dictionary filled with AVFormatContext and demuxer-private options.
 *                 On return this parameter will be destroyed and replaced with a dict containing
 *                 options that were not found. May be NULL.
 *
 * @return 0 on success, a negative AVERROR on failure.
 *
 * @note If you want to use custom IO, preallocate the format context and set its pb field.
 */
int avformat_open_input(AVFormatContext **ps, const char *url, ff_const59 AVInputFormat *fmt, AVDictionary **options);
```

> **参数**：
>
> ps：函数调用成功之后处理过的AVFormatContext结构体；
>
> url：打开的视音频流的URL；
>
> fmt：强制指定AVFormatContext中AVInputFormat的。这个参数一般情况下可以设置为NULL，这样FFmpeg可以自动检测AVInputFormat；
>
> options：附加的一些选项，一般情况下可以设置为NULL
>
> **返回值：**
>
> 执行成功的话，其返回值大于等于0

## avformat_find_stream_info()

**功能**：读取一部分视音频数据并且获得一些相关的信息

```c++
/**
 * Read packets of a media file to get stream information. This
 * is useful for file formats with no headers such as MPEG. This
 * function also computes the real framerate in case of MPEG-2 repeat
 * frame mode.
 * The logical file position is not changed by this function;
 * examined packets may be buffered for later processing.
 *
 * @param ic media file handle
 * @param options  If non-NULL, an ic.nb_streams long array of pointers to
 *                 dictionaries, where i-th member contains options for
 *                 codec corresponding to i-th stream.
 *                 On return each dictionary will be filled with options that were not found.
 * @return >=0 if OK, AVERROR_xxx on error
 *
 * @note this function isn't guaranteed to open all the codecs, so
 *       options being non-empty at return is a perfectly normal behavior.
 *
 * @todo Let the user decide somehow what information is needed so that
 *       we do not waste time getting stuff the user does not need.
 */
int avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options);
```

> **参数：**
>
> ic：输入的AVFormatContext；
>
> options：配置和定义播放器的参数
>
> 返回值：函数正常执行后返回值大于等于0

在一些格式当中没有头部信息(flv、h264)，此时调用avformat_open_input()在打开文件无法获取到里面的信息。此时就可以调用此函数，该函数会尝试去探测文件的格式，如果格式当中没有头部信息，它只能获取到编码、宽高等信息，无法获得总时长。如果无法获取到总时长，则需要把整个文件读一遍，计算一下它的总帧数：

```c++
if (avformat_find_stream_info(ic, 0) >=0 ) {
        LOGI("duration is: %lld, nb_stream is: %d", ic->duration, ic->nb_streams);
}
```

## av_dump_format()

**功能**：打印视频流的信息

```c++
/**
 * Print detailed information about the input or output format, such as
 * duration, bitrate, streams, container, programs, metadata, side data,
 * codec and time base.
 *
 * @param ic        the context to analyze
 * @param index     index of the stream to dump information about
 * @param url       the URL to print, such as source or destination file
 * @param is_output Select whether the specified context is an input(0) or output(1)
 */
void av_dump_format(AVFormatContext *ic, int index, const char *url, int is_output);
```

> **参数：**
>
> ic：要分析的上下文
>
> index：要转储有关信息的流的索引
>
> url：要打印的URL，例如源文件或目标文件
>
> is_output：选择指定的上下文是输入（0）还是输出（1）

## avformat_alloc_output_context2()

**功能：**初始化一个用于输出的AVFormatContext结构体

```c++
/**
 * Allocate an AVFormatContext for an output format.
 * avformat_free_context() can be used to free the context and
 * everything allocated by the framework within it.
 *
 * @param *ctx is set to the created format context, or to NULL in
 * case of failure
 * @param oformat format to use for allocating the context, if NULL
 * format_name and filename are used instead
 * @param format_name the name of output format to use for allocating the
 * context, if NULL filename is used instead
 * @param filename the name of the filename to use for allocating the
 * context, may be NULL
 * @return >= 0 in case of success, a negative AVERROR code in case of
 * failure
 */
int avformat_alloc_output_context2(AVFormatContext **ctx, ff_const59 AVOutputFormat *oformat,
                                   const char *format_name, const char *filename);
```

> 参数：
>
> ctx：函数调用成功之后创建的AVFormatContext结构体
>
> oformat：指定AVFormatContext中的AVOutputFormat，用于确定输出格式。如果指定为NULL，可以设定后两个参数（format_name或者filename）由FFmpeg猜测输出格式PS：使用该参数需要自己手动获AVOutputFormat，相对于使用后两个参数来说要麻烦一些
>
> format_name：指定输出格式的名称。根据格式名称，FFmpeg会推测输出格式。输出格式可以是“flv”，“mkv”等等
>
> filename：指定输出文件的名称。根据文件名称，FFmpeg会推测输出格式。文件名称可以是“xx.flv”，“yy.mkv”等等
>
> **返回值：**
>
> 函数执行成功的话，其返回值大于等于0

## avformat_new_stream()

**功能：**在 AVFormatContext 里创建 AVStream 通道，即为文件添加音视频流

```c++
/**
 * Add a new stream to a media file.
 *
 * When demuxing, it is called by the demuxer in read_header(). If the
 * flag AVFMTCTX_NOHEADER is set in s.ctx_flags, then it may also
 * be called in read_packet().
 *
 * When muxing, should be called by the user before avformat_write_header().
 *
 * User is required to call avcodec_close() and avformat_free_context() to
 * clean up the allocation by avformat_new_stream().
 *
 * @param s media file handle
 * @param c If non-NULL, the AVCodecContext corresponding to the new stream
 * will be initialized to use this codec. This is needed for e.g. codec-specific
 * defaults to be set, so codec should be provided if it is known.
 *
 * @return newly created stream or NULL on error.
 */
AVStream *avformat_new_stream(AVFormatContext *s, const AVCodec *c);
```

> **参数：**
>
> s：视频流上下文
>
> c：如果非空，则与新流对应的AVCodecContext将被初始化以使用此编解码器。因此如果编解码器已知，则应提供编解码器。
>
> **返回值：**
>
> 正常执行则返回新创建的流，出错时返回空

## avcodec_copy_context()

**功能：**拷贝输入视频码流的AVCodecContex的数值到输出视频的AVCodecContext



```c++
/**
 * Copy the settings of the source AVCodecContext into the destination
 * AVCodecContext. The resulting destination codec context will be
 * unopened, i.e. you are required to call avcodec_open2() before you
 * can use this AVCodecContext to decode/encode video/audio data.
 *
 * @param dest target codec context, should be initialized with
 *             avcodec_alloc_context3(NULL), but otherwise uninitialized
 * @param src source codec context
 * @return AVERROR() on error (e.g. memory allocation error), 0 on success
 *
 * @deprecated The semantics of this function are ill-defined and it should not
 * be used. If you need to transfer the stream parameters from one codec context
 * to another, use an intermediate AVCodecParameters instance and the
 * avcodec_parameters_from_context() / avcodec_parameters_to_context()
 * functions.
 */
attribute_deprecated
int avcodec_copy_context(AVCodecContext *dest, const AVCodecContext *src);
```

> **参数：**
>
> dest：目标编解码器上下文
>
> src：源编解码器上下文
>
> **返回值：**
>
> 成功时返回0

新版本中FFmpeg的avcodec_copy_context被avcodec_parameters_to_context和avcodec_parameters_from_context所替代，因此需要将原本的写法修改一下：

**旧版API：**

```c++
ret = avcodec_copy_context(out_stream->codec, in_stream->codec);
if (ret < 0){
    printf("Failed to copy context from input to output stream codec context\n");
    goto end;
}
 
out_stream->codec->codec_tag = 0;
if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
    out_stream->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
```

**新版API：**

```c++
AVCodecContext *codec_ctx = avcodec_alloc_context3(in_codec);
ret = avcodec_parameters_to_context(codec_ctx, in_stream->codecpar);
if (ret < 0){
    printf("Failed to copy in_stream codecpar to codec context\n");
	goto end;
}
 
codec_ctx->codec_tag = 0;
if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
    codec_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
 
ret = avcodec_parameters_from_context(out_stream->codecpar, codec_ctx);
if (ret < 0){
	printf("Failed to copy codec context to out_stream codecpar context\n");
	goto end;
}
```

## avio_open()

**avio_open()**，是FFmepeg早期版本。avio_open()比avio_open2()少了最后2个参数。而它前面几个参数的含义和avio_open2()是一样的。从源代码中可以看出，avio_open()内部调用了avio_open2()，并且把avio_open2()的后2个参数设置成了NULL，因此它的功能实际上和avio_open2()**都是用于打开FFmpeg的输入输出文件的**。其源码如下所示：

```c++
int avio_open(AVIOContext **s, const char *filename, int flags)
{
    return avio_open2(s, filename, flags, NULL, NULL);
}
```

## avio_open2()

**功能：**打开FFmpeg的输入输出文件

```c++
/**
 * Create and initialize a AVIOContext for accessing the
 * resource indicated by url.
 * @note When the resource indicated by url has been opened in
 * read+write mode, the AVIOContext can be used only for writing.
 *
 * @param s Used to return the pointer to the created AVIOContext.
 * In case of failure the pointed to value is set to NULL.
 * @param url resource to access
 * @param flags flags which control how the resource indicated by url
 * is to be opened
 * @param int_cb an interrupt callback to be used at the protocols level
 * @param options  A dictionary filled with protocol-private options. On return
 * this parameter will be destroyed and replaced with a dict containing options
 * that were not found. May be NULL.
 * @return >= 0 in case of success, a negative value corresponding to an
 * AVERROR code in case of failure
 */
int avio_open2(AVIOContext **s, const char *url, int flags,
               const AVIOInterruptCB *int_cb, AVDictionary **options);
```

> **参数：**
>
> s：函数调用成功之后创建的AVIOContext结构体
>
> url：输入输出协议的地址
>
> flags：打开地址的方式。可以选择只读，只写，或者读写，取值如下
>
> - AVIO_FLAG_READ：只读
> - AVIO_FLAG_WRITE：只写
> - AVIO_FLAG_READ_WRITE：读写
>
> int_cb：在协议级使用的中断回调
>
> options：设置
>
> **返回值：**
>
> 成功时返回值大于等于0，出错时对应AVERROR代码

## avformat_write_header()

> avformat_write_header()，av_write_frame()以及av_write_trailer()这三个函数一般是配套使用，其中av_write_frame()用于写视频数据（，avformat_write_header()用于写视频文件头，而av_write_trailer()用于写视频文件尾

**功能：**写视频文件头

```c++
/**
 * Allocate the stream private data and write the stream header to
 * an output media file.
 *
 * @param s Media file handle, must be allocated with avformat_alloc_context().
 *          Its oformat field must be set to the desired output format;
 *          Its pb field must be set to an already opened AVIOContext.
 * @param options  An AVDictionary filled with AVFormatContext and muxer-private options.
 *                 On return this parameter will be destroyed and replaced with a dict containing
 *                 options that were not found. May be NULL.
 *
 * @return AVSTREAM_INIT_IN_WRITE_HEADER on success if the codec had not already been fully initialized in avformat_init,
 *         AVSTREAM_INIT_IN_INIT_OUTPUT  on success if the codec had already been fully initialized in avformat_init,
 *         negative AVERROR on failure.
 *
 * @see av_opt_find, av_dict_set, avio_open, av_oformat_next, avformat_init_output.
 */
av_warn_unused_result
int avformat_write_header(AVFormatContext *s, AVDictionary **options);
```

> **参数：**
>
> s：用于输出的AVFormatContext
>
> options：额外的选项，一般为NULL
>
> **返回值：**
>
> 函数正常执行后返回值等于0

## av_interleaved_write_frame()

**功能：**将数据包写入输出媒体文件，以确保正确的交织。

```c++
/**
 * Write a packet to an output media file ensuring correct interleaving.
 *
 * This function will buffer the packets internally as needed to make sure the
 * packets in the output file are properly interleaved in the order of
 * increasing dts. Callers doing their own interleaving should call
 * av_write_frame() instead of this function.
 *
 * Using this function instead of av_write_frame() can give muxers advance
 * knowledge of future packets, improving e.g. the behaviour of the mp4
 * muxer for VFR content in fragmenting mode.
 *
 * @param s media file handle
 * @param pkt The packet containing the data to be written.
 *            If the packet is reference-counted, this function will take
 *            ownership of this reference and unreference it later when it sees
 *            fit.
 *            The caller must not access the data through this reference after
 *            this function returns. If the packet is not reference-counted,
 *            libavformat will make a copy.
 *            This parameter can be NULL (at any time, not just at the end), to
 *            flush the interleaving queues.
 *            Packet's @ref AVPacket.stream_index "stream_index" field must be
 *            set to the index of the corresponding stream in @ref
 *            AVFormatContext.streams "s->streams".
 *            The timestamps (@ref AVPacket.pts "pts", @ref AVPacket.dts "dts")
 *            must be set to correct values in the stream's timebase (unless the
 *            output format is flagged with the AVFMT_NOTIMESTAMPS flag, then
 *            they can be set to AV_NOPTS_VALUE).
 *            The dts for subsequent packets in one stream must be strictly
 *            increasing (unless the output format is flagged with the
 *            AVFMT_TS_NONSTRICT, then they merely have to be nondecreasing).
 *            @ref AVPacket.duration "duration") should also be set if known.
 *
 * @return 0 on success, a negative AVERROR on error. Libavformat will always
 *         take care of freeing the packet, even if this function fails.
 *
 * @see av_write_frame(), AVFormatContext.max_interleave_delta
 */
int av_interleaved_write_frame(AVFormatContext *s, AVPacket *pkt);
```

> **参数：**
>
> s：用于输出的AVFormatContext
>
> pkt：包含要写入的数据的包
>
> **返回值：**
>
> 函数正常执行后返回值等于0

## av_write_frame()

**功能：**输出一帧视音频数据

```c++
/**
 * Write a packet to an output media file.
 *
 * This function passes the packet directly to the muxer, without any buffering
 * or reordering. The caller is responsible for correctly interleaving the
 * packets if the format requires it. Callers that want libavformat to handle
 * the interleaving should call av_interleaved_write_frame() instead of this
 * function.
 *
 * @param s media file handle
 * @param pkt The packet containing the data to be written. Note that unlike
 *            av_interleaved_write_frame(), this function does not take
 *            ownership of the packet passed to it (though some muxers may make
 *            an internal reference to the input packet).
 *            <br>
 *            This parameter can be NULL (at any time, not just at the end), in
 *            order to immediately flush data buffered within the muxer, for
 *            muxers that buffer up data internally before writing it to the
 *            output.
 *            <br>
 *            Packet's @ref AVPacket.stream_index "stream_index" field must be
 *            set to the index of the corresponding stream in @ref
 *            AVFormatContext.streams "s->streams".
 *            <br>
 *            The timestamps (@ref AVPacket.pts "pts", @ref AVPacket.dts "dts")
 *            must be set to correct values in the stream's timebase (unless the
 *            output format is flagged with the AVFMT_NOTIMESTAMPS flag, then
 *            they can be set to AV_NOPTS_VALUE).
 *            The dts for subsequent packets passed to this function must be strictly
 *            increasing when compared in their respective timebases (unless the
 *            output format is flagged with the AVFMT_TS_NONSTRICT, then they
 *            merely have to be nondecreasing).  @ref AVPacket.duration
 *            "duration") should also be set if known.
 * @return < 0 on error, = 0 if OK, 1 if flushed and there is no more data to flush
 *
 * @see av_interleaved_write_frame()
 */
int av_write_frame(AVFormatContext *s, AVPacket *pkt);
```

> **参数：**
>
> s：用于输出的AVFormatContext
>
> pkt：等待输出的AVPacket
>
> **返回值：**
>
> 函数正常执行后返回值等于0

## av_write_trailer()

**功能：**输出文件尾

```c++
/**
 * Write the stream trailer to an output media file and free the
 * file private data.
 *
 * May only be called after a successful call to avformat_write_header.
 *
 * @param s media file handle
 * @return 0 if OK, AVERROR_xxx on error
 */
int av_write_trailer(AVFormatContext *s);
```

> **参数：**
>
> s：用于输出的AVFormatContext
>
> **返回值：**
>
> 函数正常执行后返回值等于0

## av_read_frame()

功能：读取码流中的音频若干帧或者视频一帧

```c++
/**
 * Return the next frame of a stream.
 * This function returns what is stored in the file, and does not validate
 * that what is there are valid frames for the decoder. It will split what is
 * stored in the file into frames and return one for each call. It will not
 * omit invalid data between valid frames so as to give the decoder the maximum
 * information possible for decoding.
 *
 * On success, the returned packet is reference-counted (pkt->buf is set) and
 * valid indefinitely. The packet must be freed with av_packet_unref() when
 * it is no longer needed. For video, the packet contains exactly one frame.
 * For audio, it contains an integer number of frames if each frame has
 * a known fixed size (e.g. PCM or ADPCM data). If the audio frames have
 * a variable size (e.g. MPEG audio), then it contains one frame.
 *
 * pkt->pts, pkt->dts and pkt->duration are always set to correct
 * values in AVStream.time_base units (and guessed if the format cannot
 * provide them). pkt->pts can be AV_NOPTS_VALUE if the video format
 * has B-frames, so it is better to rely on pkt->dts if you do not
 * decompress the payload.
 *
 * @return 0 if OK, < 0 on error or end of file. On error, pkt will be blank
 *         (as if it came from av_packet_alloc()).
 *
 * @note pkt will be initialized, so it may be uninitialized, but it must not
 *       contain data that needs to be freed.
 */
int av_read_frame(AVFormatContext *s, AVPacket *pkt);
```

> **参数：**
>
> s：输入的AVFormatContext
>
> pkt：输出的AVPacket
>
> **返回值：**
>
> 成功返回0

## av_free_packet()

功能：释放 packet 占用的资源

```c++
/**
 * Free a packet.
 *
 * @deprecated Use av_packet_unref
 *
 * @param pkt packet to free
 */
attribute_deprecated
void av_free_packet(AVPacket *pkt);
```

> **参数：**
>
> packet：需要是释放的packet

**新的API：**

```c++
/**
 * Convenience function to free all the side data stored.
 * All the other fields stay untouched.
 *
 * @param pkt packet
 */
void av_packet_free_side_data(AVPacket *pkt);
```

## avformat_close_input()

**功能**：关闭一个AVFormatContext，一般和 **avformat_open_input()** 成对出现

```c++
/**
 * Close an opened input AVFormatContext. Free it and all its contents
 * and set *s to NULL.
 */
void avformat_close_input(AVFormatContext **s);
```

## avio_close()

**功能：**关闭AVIOContext访问的资源并释放（只能用于被 **avio_open()** 打开的）

```c++
/**
 * Close the resource accessed by the AVIOContext s and free it.
 * This function can only be used if s was opened by avio_open().
 *
 * The internal buffer is automatically flushed before closing the
 * resource.
 *
 * @return 0 on success, an AVERROR < 0 on error.
 * @see avio_closep
 */
int avio_close(AVIOContext *s);
```

## av_gettime()

**功能：**以微秒为单位获取当前时间。

由于int64_t最大为9,223,372,036,854,775,807，因此会发生溢出的情况，得到的时间戳有正有负

# 音视频基础知识

# FFmpeg中的时间处理

## I、P、B 帧

I 帧、P 帧、B 帧的区别在于：

- I 帧（Intra coded frames）：I 帧图像采用帧内编码方式，即只利用了单帧图像内的空间相关性，而没有利用时间相关性。I 帧使用帧内压缩，不使用运动补偿，由于 I 帧不依赖其它帧，所以是随机存取的入点，同时是解码的基准帧。I 帧主要用于接收机的初始化和信道的获取，以及节目的切换和插入，I 帧图像的压缩倍数相对较低。I 帧图像是周期性出现在图像序列中的，出现频率可由编码器选择。
- P 帧（Predicted frames）：P 帧和 B 帧图像采用帧间编码方式，即同时利用了空间和时间上的相关性。P 帧图像只采用前向时间预测，可以提高压缩效率和图像质量。P 帧图像中可以包含帧内编码的部分，即 P 帧中的每一个宏块可以是前向预测，也可以是帧内编码。
- B 帧（Bi-directional predicted frames）：B 帧图像采用双向时间预测，可以大大提高压缩倍数。值得注意的是，由于 B 帧图像采用了未来帧作为参考，因此 MPEG-2 编码码流中图像帧的传输顺序和显示顺序是不同的。

也就是说，一个 I 帧可以不依赖其他帧就解码出一幅完整的图像，而 P 帧、B 帧不行。P 帧需要依赖视频流中排在它前面的帧才能解码出图像。B 帧则需要依赖视频流中排在它前面或后面的帧才能解码出图像。

这就带来一个问题：在视频流中，先到来的 B 帧无法立即解码，需要等待它依赖的后面的 I、P 帧先解码完成，这样一来播放时间与解码时间不一致了，顺序打乱了，那这些帧该如何播放呢？这时就需要我们来了解另外两个概念：DTS 和 PTS

## DTS、PTS 的概念

DTS、PTS 的概念如下所述：

- DTS（Decoding Time Stamp）：即解码时间戳，这个时间戳的意义在于告诉播放器该在什么时候解码这一帧的数据。
- PTS（Presentation Time Stamp）：即显示时间戳，这个时间戳用来告诉播放器该在什么时候显示这一帧的数据。

需要注意的是：虽然 DTS、PTS 是用于指导播放端的行为，但它们是在编码的时候由编码器生成的。

当视频流中没有 B 帧时，通常 DTS 和 PTS 的顺序是一致的。但如果有 B 帧时，就回到了我们前面说的问题：解码顺序和播放顺序不一致了。

比如一个视频中，帧的显示顺序是：I B B P，现在我们需要在解码 B 帧时知道 P 帧中信息，因此这几帧在视频流中的顺序可能是：I P B B，这时候就体现出每帧都有 DTS 和 PTS 的作用了。DTS 告诉我们该按什么顺序解码这几帧图像，PTS 告诉我们该按什么顺序显示这几帧图像。顺序大概如下：

```
   PTS: 1 4 2 3
   DTS: 1 2 3 4
Stream: I P B B
```

## AVRational

- 主要功能：表示时间刻度
- 主要信息：

```c++
/**
 * Rational number (pair of numerator and denominator).
 */
typedef struct AVRational{
    int num; ///< Numerator
    int den; ///< Denominator
} AVRational;// 标识一个分数，num为分数，den为分母。例如（1,25）表示1s25帧
```

## 时间单位

### AV_TIME_BASE

ffmpeg中的内部计时单位（时间基），ffmepg中的所有时间都是于它为一个单位，比如AVStream中的duration即以为着这个流的长度为duration个AV_TIME_BASE。AV_TIME_BASE定义为：

```c++
/**
 * Internal time base represented as integer
 */

#define AV_TIME_BASE            1000000
```

### AV_TIME_BASE_Q

ffmpeg内部时间基的分数表示，实际上它是AV_TIME_BASE的倒数。从它的定义能很清楚的看到这点：

```c++
/**
 * Internal time base represented as fractional value
 */

#define AV_TIME_BASE_Q          (AVRational){1, AV_TIME_BASE}
```

### av_rescale_q(int64_t a, AVRational bq, AVRational cq)
功能：计算a*bq / cq来把时间戳从一个时间基调整到另外一个时间基。在进行时间基转换的时候，应该首先这个函数，因为它可以避免溢出的情况发生。

### av_rescale_q_rnd(int64_t a, AVRational bq, AVRational cq, enum AVRounding rnd)

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

功能：将以 "时钟基c" 表示的 数值a 转换成以 "时钟基b" 来表示。

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

### av_q2d()

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

**功能：**将AVRatioal结构转换成double

## av_usleep()

```c++
/**
 * Sleep for a period of time.  Although the duration is expressed in
 * microseconds, the actual delay may be rounded to the precision of the
 * system timer.
 *
 * @param  usec Number of microseconds to sleep.
 * @return zero on success or (negative) error code.
 */
int av_usleep(unsigned usec);
```

功能：发送流媒体的数据的时候需要延时。不然的话，FFmpeg处理数据速度很快，瞬间就能把所有的数据发送出去，流媒体服务器是接受不了的。因此需要按照视频实际的帧率发送数据。本文记录的推流器在视频帧与帧之间采用了av_usleep()函数休眠的方式来延迟发送。这样就可以按照视频的帧率发送数据了。

### 根据PTS计算一帧在整个视频中的位置

```c++
timestamp(秒) = pts * av_q2d(st->time_base);//st是AVStream的指针，即一帧视频
```

### 计算视频长度的方法

```c++
time(秒) = st->duration * av_q2d(st->time_base);
```

### 时间基转换公式

- timestamp(ffmpeg内部时间戳) = AV_TIME_BASE * time(秒)
- time(秒) = AV_TIME_BASE_Q * timestamp(ffmpeg内部时间戳)













































# FFmpeg