---
title: docker-apps
date: 2019-06-26 16:38:22
tags:
---

### docker 安装 nuxus

```
$ mkdir -p /lib/nexus/nexus-data && chown -R 200 /lib/nexus/nexus-data
$ docker run -d -p 8081:8081 --name nexus -v /lib/nexus/nexus-data:/nexus-data sonatype/nexus3
```

### docker-mysql

- step1
docker pull mysql/mysql-server:latest
- step2
docker run --name foo-mysql -e MYSQL_ROOT_PASSWORD=passwd -e MYSQL_ROOT_HOST=% -v /etc/mysql/my.conf:/etc/mysql/my.conf -p 3306:3306 -d mysql:latest

- step3
```
docker exec -it foo-mysql mysql -u root -p 
ALTER USER 'root'@'localhost' IDENTIFIED BY '<password>';
```




### docker rabbitmq

```bash
docker run -d --hostname some-rabbit --name some-rabbit --network some-network -e RABBITMQ_ERLANG_COOKIE='123456' rabbitmq:3
```