---
title: redis
date: 2018-03-14 19:12:11
tags:
---

> 使用redis 保存文章信息
文章包括标题、作者、赞数等信息，在关系型数据库中很容易构建一张表来存储这些信息，在 Redis 中可以使用 HASH 来存储每种信息以及其对应的值的映射。

Redis 没有表的概念将同类型的数据存放在一起，而是使用命名空间的方式来实现这一功能。键名的前面部分存储命名空间，后面部分的内容存储 ID，通常使用 : 来进行分隔。例如下面的 HASH 的键名为 article:92617，其中 article 为命名空间，ID 为 92617。
{% asset_img redis-article.jpg redis-article%}


#### Redis UDS

Lettuce还支持使用`Unix Domain Sockets`, 这对程序和Redis在同一机器上的情况来说，是一大福音。平时我们连接应用和数据库如Mysql，都是基于TCP/IP套接字的方式，如127.0.0.1:3306，达到进程与进程之间的通信，Redis也不例外。但使用UDS传输不需要经过网络协议栈,不需要打包拆包等操作,只是数据的拷贝过程，也不会出现丢包的情况，更不需要三次握手，因此有比TCP/IP更快的连接与执行速度。当然，仅限Redis进程和程序进程在同一主机上，而且仅适用于Unix及其衍生系统。

```java
    private RedisURI createRedisURI() {
        Builder builder = null;
    // 判断是否有配置UDS信息，以及判断Redis是否有支持UDS连接方式，是则用UDS，否则用TCP
        if (StringUtils.isNotBlank(socket) && Files.exists(Paths.get(socket))) {
            builder = Builder.socket(socket);
            System.out.println("connect with Redis by Unix domain Socket");
            log.info("connect with Redis by Unix domain Socket");
        } else {
            builder = Builder.redis(hostName, port);
            System.out.println("connect with Redis by TCP Socket");
            log.info("connect with Redis by TCP Socket");
        }
        builder.withDatabase(dbIndex);
        if (StringUtils.isNotBlank(password)) {
            builder.withPassword(password);
        }
        return builder.build();
    }
```