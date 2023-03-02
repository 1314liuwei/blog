当我们在使用ls命令列出文件夹下内容时，我们会发现有一个total行，在total后面还有一个数字。
```bash
[GNU@ecs-x ~]$ ls -li
total 44
926532 drwxr-xr-x 2 GNU GNU 4096 Feb 25 09:56 Desktop
926536 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Documents
926533 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Downloads
926537 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Music
926538 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Pictures
926535 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Public
926534 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Templates
925774 -rw-rw-r-- 1 GNU GNU  127 Feb 26 18:09 test.py
925571 -rw-rw-r-- 1 GNU GNU    7 Feb 25 17:41 test.txt
926479 drwxr-xr-t 2 GNU GNU 4096 Feb 23 19:10 thinclient_drives
926539 drwxr-xr-x 2 GNU GNU 4096 Feb 23 19:10 Videos
```
那么这个total代表的是什么呢？
事实上这个total后的数字是代表着该目录下的所有项目占据的总内存空间。在ls命令后面加上 **-h** 可以更清楚的看到这个效果。
```bash
[GNU@ecs-x ~]$ ls -lih
total 44K
926532 drwxr-xr-x 2 GNU GNU 4.0K Feb 25 09:56 Desktop
926536 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Documents
926533 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Downloads
926537 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Music
926538 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Pictures
926535 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Public
926534 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Templates
925774 -rw-rw-r-- 1 GNU GNU  127 Feb 26 18:09 test.py
925571 -rw-rw-r-- 1 GNU GNU    7 Feb 25 17:41 test.txt
926479 drwxr-xr-t 2 GNU GNU 4.0K Feb 23 19:10 thinclient_drives
926539 drwxr-xr-x 2 GNU GNU 4.0K Feb 23 19:10 Videos
```