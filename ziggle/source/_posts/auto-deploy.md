---
title: auto-deploy
date: 2017-12-25 21:46:41
tags:
    -devops
---
## systemd 守护进程

>node webhook进程 同步接受GitHub post请求
```ini
root@ziggle:~# cat /lib/systemd/system/nsync.service
[Unit]
Description=Sync blog node service

[Service]
ExecStart=-/usr/bin/node /root/wp/www/nsyncblog.js
ExecReload=-/bin/kill -HUP $MAINPID
TimeoutSec=10s
Type=simple
KillMode=process
Restart=on-failure
RestartSec=20s

[Install]
WantedBy=multi-user.target

```