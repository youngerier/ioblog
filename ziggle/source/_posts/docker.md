---
title: docker
date: 2018-01-25 20:38:52
tags:
    - docker 
---

## `Dockerfile`关键字
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

命令行参数说明
|:------|------:|
|--detach|容器后台运行|
|--hostname|容器的 hostname|
|--publish|端口转发规则|
|--name|容器名称|
|--restart always|-|
|--volume|共享目录挂载|
|--e|配置运行时环境变量|
| --rm=false |指定容器停止后自动删除容器(不支持以docker run -d启动的容器)|
| --expose=[]  |指定容器暴露的端口，即修改镜像的暴露端口|
| --dns=[]   |指定容器的dns服务器|
| --dns-search=[]  |指定容器的dns搜索域名，写入到容器的/etc/resolv.conf文件|
| --entrypoint="" | 覆盖image的入口点|
| -m | 设置容器使用内存最大值 == --memory=""|
| --net="bridge" | 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；|

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
```
docker logs -f -t --since="2017-05-31" --tail=10 edu_web_1

--since : 此参数指定了输出日志开始日期，即只输出指定日期之后的日志。

-f : 查看实时日志

-t : 查看日志产生的日期

-tail=10 : 查看最后的10条日志。

edu_web_1 : 容器名称
```

<!-- more -->

### 三个基本概念
- `Image` 镜像
- `Container` 容器
- `Repository` 仓库


## 指定`endpoint` 运行某个镜像

```sh
 docker run -it --entrypoint /bin/bash example/redis
```



