---
title: docker
date: 2018-01-25 20:38:52
tags:
    - docker 
---
| 关键字|含义|
| :------- | --------: |
|FROM   |base image|
|RUN    | 执行命令|
|ADD     |添加文件|
|COPY    | 拷贝文件|
|CMD    | 执行命令|
|EXPOST | 暴露端口|
|WORKDIR | 指定路径|
|MAINTAINER|  维护者|
|ENV    | 设定环境变量|
|ENTRYPOINT|  容器入口|
|USER    | 指定用户|
|VOLUME | mount point|

## 最简实例
```DockerFile
FROM ubuntu
MAINTAINER z
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y nginx
COPY index.html /var/www/html
ENTRYPOINT ["/usr/sbin/nginx","-g","deamon off;"]
EXPOSE  80
```

```javascript
    const port = 9999;
    let http = require('http');
    let server = http.createServer((req, res) => {
        res.end("hail hydra\n");
    })
    server.listen(port,()=>{
        console.log(`listen at ${port}`)
    })
```


```Dockerfile
FROM  node
RUN mkdir -p /home/app
WORKDIR /home/app

COPY . /home/app
EXPOSE 9999
CMD ["node","./server.js"]
```

```bash 
# build 
docker build -t appname .
# run 
docker run -d -p 9999:9999 appname  

# run container 
docker start [container-id]
```


```bash
# docker run --detach \
# > --env GITLAB_OMNIBUS_CONFIG="gitlab_rails['lfs_enabled'] = true;" \
# > --publish 88:80 --publish 222:22 --publish 4433:443 \
# > --name gitlab \
# > --restart always \
# > --volume /root/home/gitlab/config:/etc/gitlab \
# > --volume /root/home/gitlab/logs:/var/log/gitlab \
# > --volume /root/home/gitlab/data:/var/opt/gitlab \
# > --name gitlab gitlab/gitlab-ce:latest
docker run --detach \
    --hostname 192.168.192.186 \
    --publish 4433:443 --publish 88:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /root/home/gitlab/config:/etc/gitlab \
    --volume /root/home/gitlab/logs:/var/log/gitlab \
    --volume /root/home/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```
