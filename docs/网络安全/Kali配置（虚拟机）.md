# Kali 配置（虚拟机）

# 一、安装VMWare Tools

为了能够实现主机和虚拟机之间的**直接复制粘贴**和**文件传输**，我们需要**安装VMWare Tools**来帮助我们解决这个问题。
1. **找到VMWare Tools**：
![点击虚拟机](https://pic.try-hard.cn/blog/20200207110450982.png)
2. **找到VMWare Tools安装文件：**
![文件](https://pic.try-hard.cn/blog/20200207110717331.png)
3. **文件拷贝：**
将文件放到主目录下，
![在这里插入图片描述](https://pic.try-hard.cn/blog/20200207110818445.png)
4. **安装：**
依次输入下面命令安装VMWare Tools，
```bash
tar zxf VMwareTools-10.0.5-3228253.tar.gz
cd vmware-tools-distrib/
sudo ./vmware-install.pl
```
输入命令后一直敲**Enter**键即可。
5. **安装完成：**
当出现下图语句时即完成VMWare Tools的安装。
![安装完成效果图描述](https://pic.try-hard.cn/blog/20200207111210194.png)
# 二、修改分辨率
### 当前修改
终端输入下列命令：
```bash
xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode Virtual1 1920x1080
xrandr --output Virtual1 --mode 1920x1080
```
### 永久修改（推荐）
1. **查看分辨率：**
终端输入：**1920x1080_60.00**对应的是所需修改的分辨率的信息，后续会用到。
```bash
~$ cvt 1920 1080
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```
2. **查看显示器名称：**
```bash
    ~$ xrandr

    Screen 0: minimum 1 x 1, current 1920 x 1080, maximum 8192 x 8192

    Virtual1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 0mm x 0mm

      800x600      60.00 +  60.32 

      2560x1600    59.99 

      1920x1440    60.00 

      1856x1392    60.00 

      1792x1344    60.00 

      1920x1200    59.88 

      1600x1200    60.00 

      1680x1050    59.95 

      1400x1050    59.98 

      1280x1024    60.02 

      1440x900      59.89 

      1280x960      60.00 

      1360x768      60.02 

      1280x800      59.81 

      1152x864      75.00 

      1280x768      59.87 

      1024x768      60.00 

      640x480      59.94 

      1920x1080_60.00  59.96*

    Virtual2 disconnected (normal left inverted right x axis y axis)

    Virtual3 disconnected (normal left inverted right x axis y axis)

    Virtual4 disconnected (normal left inverted right x axis y axis)

    Virtual5 disconnected (normal left inverted right x axis y axis)

    Virtual6 disconnected (normal left inverted right x axis y axis)

    Virtual7 disconnected (normal left inverted right x axis y axis)

    Virtual8 disconnected (normal left inverted right x axis y axis)
```
**Virtual1**即为显示器名称，后续也会用到。
3. **修改分辨率：**
以管理员身份进入**profile**文件，
```bash
~$ sudo vim /etc/profile
```
按**i**进入insert模式修改文件，在文件末尾追加
```bash
    xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
    xrandr --addmode Virtual1 "1920x1080_60.00"
```
**注意："1920x1080_60.00"和Virtual1**是在查看得到的数据。
按ESC退出insert模式，输入**:wq**保存，并退出。
4. **重载配置文件：**
终端输入下列命令重载配置文件。
```bash
~$ source /etc/profile
```
5. **修改分辨率：**
通过 settings->displays->resolution中找到刚才添加的分辨率了，修改分辨率后即可永久修改。
![进入设置](https://pic.try-hard.cn/blog/20200207105005779.png)
![更换](https://pic.try-hard.cn/blog/20200207110036620.png)
# 三、修改图标和字体大小
1. “设置” --> "通用辅助功能" --> "大号字体"
2. 在终端中输入 “gnome-tweaks” 打开 优化 --> 扩展  --> dash to dock --> 点击齿轮按钮，可以设置图标大小，
3. gnome-tweaks 中可设置字体大小
# 四、更新换源
因为kali是国外的，所以一些软件你要下载的话得从国外的网站下载，就会很慢。国内一些公司或者学校提供了国内的下载地址，通过国内下载的话速度将会大大提高，所以我们需要更换更新源。
1. **终端输入：**
```bash
 leafpad /etc/apt/sources.list
```
2. **换源：**
```bash
#阿里云
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib

#清华大学
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

#浙江大学
deb http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free
deb-src http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free
```
3. **重载：**
```bash
apt-get clean && apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
```
命令讲解：
```bash
apt-get clean //清除缓存索引
apt-get update //更新索引文件
apt-get upgrade //更新实际的软件包文件
apt-get dist-upgrade //根据依赖关系更新
```