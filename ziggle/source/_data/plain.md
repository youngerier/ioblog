有时您可能需要在主题中使用某些资料，
而这些资料并不在文章内，并且是需要重复使用的，
那么您可以考虑使用 Hexo 3.0 新增的「数据文件」功能。
此功能会载入 source/_data 内的 YAML 或 JSON 文件，
如此一来您便能在网站中复用这些文件了。


举例来说，在 source/_data 文件夹中新建 menu.yml 文件：

Home: /
Gallery: /gallery/
Archives: /archives/
您就能在模板中使用这些资料：

<% for (var link in site.data.menu) { %>
  <a href="<%= site.data.menu[link] %>"> <%= link %> </a>
<% } %>
渲染结果如下 :

<a href="/"> Home </a>
<a href="/gallery/"> Gallery </a>
<a href="/archives/"> Archives </a>

引用图片的方式 当前目录 .  
![](../_images/save.png)

相对路径引用的标签插件
{% asset_path slug %}
{% asset_img slug [title] %}
{% asset_link slug [title] %}


- [论坛](https://github.com/52fhy/shell-book/issues)

- [01- Shell脚本学习--入门](chapter1.md)




> shadowsocks.service
```ini
[Service]
ExecStart=-/usr/local/bin/ssserver -c /etc/shadowsocks.json  start
ExecReload=-/bin/kill -HUP $MAINPID
TimeoutSec=10s
Type=simple
KillMode=process
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
```

>nsync.service
```ini
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

> ssserver.sh
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

> syncblog.py

```py
root@ziggle:~/wp# cat /root/wp/www/syncblog.py 
#!/usr/bin/env python
# coding=utf-8

import os

if __name__ == '__main__':
    os.chdir('/root/wp/www/public')
    #os.system('git reset --hard HEAD && git clean -f && git pull --all')
    #os.system('git clean -f')
    #os.system('git pull --all')
    os.system(' git fetch --all && git reset --hard origin/master')
```
>nsyncblog.js

```javascript
root@ziggle:~/wp# cat /root/wp/www/nsyncblog.js 
var http = require('http');
var exec = require('child_process').exec;


var server = http.createServer((req,res)=>{
    console.log(req.url);
    if(req.url==='/webhooks/push'){
        exec('/usr/bin/python  /root/wp/www/syncblog.py');
        console.log(req.url);
    }
    res.end()
})

server.listen(4001,()=>{
    console.log('listening at 4001')
})
```

>/etc/nginx/nginx.conf

```conf
root@ziggle:~/wp# cat /etc/nginx/nginx.conf 
user root;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
    # multi_accept on;
}

http {

    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    # server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    ##
    # Logging Settings
    ##

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";

    # gzip_vary on;
    # gzip_proxied any;
    # gzip_comp_level 6;
    # gzip_buffers 16 8k;
    # gzip_http_version 1.1;
    # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Virtual Host Configs
    ##

    #include /etc/nginx/conf.d/*.conf;
    #include /etc/nginx/sites-enabled/*;
    server{
        location / {
        root /root/wp/www/public;
        #proxy_pass http://localhost:8080;
    }
    location ^~/proxy/bing/ {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Cache-Control' 'public, max-age=604800';
        add_header 'Access-Control-Allow-Credentials' 'true';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';

        rewrite ^/proxy/bing/(.*)$/$1 break;
        proxy_pass https://cn.bing.com/;
    }
    error_page 404 /404.html;
        location = /404.html {
            root /root/wp/www/;
            internal;
        }
    }
}


#mail {
#	# See sample authentication script at:
    #	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
    # 
    #	# auth_http localhost/auth.php;
    #	# pop3_capabilities "TOP" "USER";
    #	# imap_capabilities "IMAP4rev1" "UIDPLUS";
    # 
    #	server {
        #		listen     localhost:110;
        #		protocol   pop3;
        #		proxy      on;
        #	}
    # 
    #	server {
        #		listen     localhost:143;
        #		protocol   imap;
        #		proxy      on;
        #	}
    #}

```
> index.html

> /etc/apt/source.list
```conf

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial universe
# deb-src http://archive.ubuntu.com/ubuntu/ xenial universe
deb http://archive.ubuntu.com/ubuntu/ xenial-updates universe
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu/ xenial multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu xenial partner
# deb-src http://archive.canonical.com/ubuntu xenial partner

deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security main restricted
deb http://security.ubuntu.com/ubuntu/ xenial-security universe
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe
deb http://security.ubuntu.com/ubuntu/ xenial-security multiverse
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security multiverse

```



```json
{
  "frameworks": {
    "net451": {
      "frameworkAssemblies": {
        
      }
    }
  }
}
```