---
title: linux-tcp
date: 2019-06-25 15:50:13
tags:
---
## linux tcp 调优

### 端口范围
- 0-1024 端口受保护
- 当前主机可以使用的端口范围
```sh
[root@localhost logstash]# cat  /proc/sys/net/ipv4/ip_local_port_range 
32768	60999
```

### 大量并发请求时 大量请求等待建立连接 如果`TIME_WAIT` 很多的话

- 设置更小的`timeout` 快速释放请求
```sh
[root@localhost logstash]# cat  /proc/sys/net/ipv4/tcp_fin_timeout 
60
```

### 设置`time_wait`连接重用

```
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
```

### 设置`time_wait` 快速回收

```
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
```

{% asset_img tcp-config.png tcp-config.png%}
{% asset_img tcp-config1.png tcp-config1.png%}


### 以上设置都是临时性的


```
cat /proc/net/netstat  # tcp 统计信息
cat /proc/net/snmp     # 系统连接情况
netstat -s             # 网络统计信息
```