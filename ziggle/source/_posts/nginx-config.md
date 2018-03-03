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
# 所有的动态页面交给tomcat 等处理
```nil

location ~ .(jsp|jspx|do)?$ {  
    proxy_set_header Host $host;  
    proxy_set_header X-Real-IP $remote_addr;  
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
    proxy_pass http://127.0.0.1:8080;  
}  
```
# 所有静态文件由nginx直接读取
```nil
location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt  
                |pdf|xls|mp3|wma)$ {   
    expires 15d;   # 静态文件缓存时间 
}  
location ~ .*.(js|css)?$ {   
    expires 1h;   
}  
```

# nginx 中upstream轮询机制
- 轮询 后端服务器down掉,可以自动删除
```
upstream bakend {  
    server 192.168.1.10;  
    server 192.168.1.11;  
}  
```
- weight 
```
upstream bakend {  
    server 192.168.1.10 weight=1;  
    server 192.168.1.11 weight=2;  
}  
```
- ip_hash 每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session不能跨服务器的问题。 
如果后端服务器down掉，要手工down掉
```

upstream resinserver{  
    ip_hash;  
    server 192.168.1.10:8080;  
    server 192.168.1.11:8080;  
}  
```

- fair (插件) 根据相应时间有限分配
```
upstream resinserver{  
    server 192.168.1.10:8080;  
    server 192.168.1.11:8080;  
    fair;  
}  
```
# 定义错误页面
```
error_page   500 502 503 504 /50x.html;  
location = /50x.html {  
} 
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


### nginx 配置ssl 
```conf

	upstream consul {
		server 127.0.0.1:8500;
	}
    # https 监听80端口可以让http重定向到https端口上。
	server {
		# listen at port 80
		listen 80;
         # server_name www.example.com;
        rewrite ^(.*) https://$host$1 permanent;  # 不用  $server_name ,使用$host 变量
        
#       location / {
#	        	root /root/wp/www/public;
#        	}
#	    location /consul/ {
#	        	proxy_pass http://consul/;
#       	}
		error_page 404 /404.html;
		location = /404.html {
			root /root/wp/www/;
			internal;
		}
	}

server {
            listen 443 ssl;
            ssl on;
            ssl_session_timeout 5m;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;     #指定SSL服务器端支持 协议版本
            ssl_ciphers  HIGH:!aNULL:!MD5;
            ssl_certificate /root/sslcert/ssl/certificate.crt;
            ssl_certificate_key /root/sslcert/ssl/private.key;
            ssl_prefer_server_ciphers on;

                
           	location / {
	        	root /root/wp/www/public;
        	}
	        location /consul/ {
	        	proxy_pass http://consul/;
           	}
            error_page 404 /404.html;
            location = /404.html {
                root /root/wp/www/;
                internal;
            }
        }

```