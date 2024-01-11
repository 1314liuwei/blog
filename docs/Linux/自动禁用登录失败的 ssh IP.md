# 自动禁用登录失败的 ssh IP

自动禁用登录失败的 IP 脚本：

```shell
#!/bin/bash

journalctl -u sshd.service | awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /root/black.list
while IFS= read -r line
do
  IP=$(echo "$line" | awk -F= '{print $1}')
  NUM=$(echo "$line" | awk -F= '{print $2}')
  # 失败次数大于 3 则禁用 IP
  if [ "$NUM" -ge 3 ]; then
    grep "$IP" /etc/hosts.deny > /dev/null
    if [ $? -gt 0 ]; then
      echo "sshd:$IP:deny" >> /etc/hosts.deny
    fi
  fi
done < /root/black.list
```

将脚本加入定时任务：

```bash
crontab -e

# 每分钟执行一次脚本
*/1 * * * *  sh /root/ssh_deny.sh
```

