# Kali 执行 apt-get upgrade 后无法打开终端

# 一、问题详情

安装完Kali虚拟机后，执行`apt-get upgrade`更新，更新完成后`reboot`重启，发现无法打开终端。
# 二、问题原因
由于最开始安装kali的时候是选择中文，在upgrade后，系统把语言设置回了英文，因而在终端因为乱码而无法打开。
# 三、解决方案
我们重新设置一下语言即可解决问题：
1. **进入命令行界面：**
**Alt+Ctrl +F6**
2. **依次输入：**
```bash
apt-get install --reinstall locales
# 将语言集设置成英文
export LANGUAGE="en_US.UTF-8"
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
```
3. **重启：**
```bash
reboot
```
4. **重新设置语言：**
在设置中将语言调整为中文