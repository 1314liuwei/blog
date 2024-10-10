在dockerfile中有命令
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
将其改为
RUN sed -i s@/archive.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list && apt-get update && apt-get upgrade -y && apt-get autoremove -y
换源后就成功了
