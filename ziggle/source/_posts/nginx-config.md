---
title: nginx-config
date: 2017-12-08 12:52:36
tags: 
    - nginx
    - bash
---

# Nginx settings

```yml
user www-data;
# 与cpu核心数一致
worker_processes 1;
pid /run/nginx.pid;

events {
    use epoll;
    worker_connections 768;
}

http {
    # 开启gzip
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    # websocket 配置
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }


    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    server {
        # 监听端口
        listem 80;
        # 域名
        server_name ziggle.com www.ziggle.com;
        # 站点目录
        root /root/ziggle;
        location / {
            index index.html;
        }
        # 正则匹配路径, 用~开头
        location ~* \.(gif|jpg|png)$ {
            expires 10d;
        }

        # websocket conf 
         location /chat/ {
            # 默认websocket超时时间是 60s
            proxy_read_timeout 3600s;
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_disable "msie6";

# 包含配置
  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}

mail {

}

```

<!-- more -->

包含文件的例子

- rails.conf

```yml


```


# shadowsocks进程检测 

- 1  添加cron 任务

```bash
crontab -e
```

- 2

编辑crontab

```bash
* * * * *  /bin/sh /root/wp/ssscript.sh
```

- 3 编辑ssscript.sh 并且 chmod 775 ./ssscript.sh

```bash
 #!/bin/sh
ps -fe|grep /usr/local/bin/ssserver|grep -v grep
if [ $? -ne 0 ]
then
    /usr/local/bin/ssserver -c /etc/shadowsocks.json -d start
    echo `date "+%Y-%m-%d %H:%M:%S"beenfunked` >> /root/wp/ss.log
else
    echo `date "+%Y-%m-%d %H:%M:%S"OK` >> /root/wp/ss.log
fi
```

- python 调用系统命令

```python
#!/bin/python

import os
if __name__ == "__main__":
    # os.chdir('/root/www/blog/')
    os.system('git pull origin master')

    # os.chdir('/root/www/resource/')
    os.system('git pull origin master')
```