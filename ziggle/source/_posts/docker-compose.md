---
title: docker-compose
date: 2019-08-25 18:53:58
tags:
---


### 安装`docker-compose`

```bash
 curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
```

### docker-compose `volumes` 卷标

```sh
docker volume ls
```

#### mysql-配置

```yml
version: '3.3'
services:
  redis:
    # 指定镜像
    image: redis:4
    ports:
      # 端口映射
      - 6379:6379
    volumes:
      # 目录映射
      - "redis-db:/usr/local/etc/redis"
      - "redis-db:/data"
    command:
      # 执行的命令
      redis-server
  mysql:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: 'db'
      # So you don't have to use root, but you can if you like
      MYSQL_USER: 'root'
      # You can use whatever password you like
      MYSQL_PASSWORD: '123456'
      # Password for root access
      MYSQL_ROOT_PASSWORD: '123456'
    ports:
      # <Port exposed> : < MySQL Port running inside container>
      - '3306:3306'
    expose:
      # Opens port 3306 on the container
      - '3306'
      # Where our data will be persisted
    volumes:
      - my-db:/var/lib/mysql
      - my-db:/etc/my.cnf"
# Names our volume
volumes:
  my-db:
  redis-db:
```
