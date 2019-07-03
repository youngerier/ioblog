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
{% asset_img tcp_state.png tcp_state.png%}


### 以上设置都是临时性的


```
cat /proc/net/netstat  # tcp 统计信息
cat /proc/net/snmp     # 系统连接情况
netstat -s             # 网络统计信息
```


netstat属于net-tools工具集，而ss属于iproute。其命令对应如下，是时候和net-tools说Bye了。

用途	net-tools	iproute
统计	ifconfig	ss
地址	netstat	ip addr
路由	route	ip route
邻居	arp	ip neigh
VPN	iptunnel	ip tunnel
VLAN	vconfig	ip link
组播	ipmaddr	ip maddr


查看系统正在监听的tcp连接

ss -atr 
ss -atn #仅ip


查看系统中所有连接

ss -alt


查看监听444端口的进程pid

ss -ltp | grep 444


查看进程555占用了哪些端口

ss -ltp | grep 555


显示所有udp连接

ss -u -a
查看TCP sockets，使用-ta选项
查看UDP sockets，使用-ua选项
查看RAW sockets，使用-wa选项
查看UNIX sockets，使用-xa选项

显示所有的http连接

ss  dport = :http
查看连接本机最多的前10个ip地址

netstat -antp | awk '{print $4}' | cut -d ':' -f1 | sort | uniq -c  | sort -n -k1 -r | head -n 10


sysctl命令可以设置这些参数，如果想要重启生效的话，加入/etc/sysctl.conf文件中。

```conf
# 修改阈值
net.ipv4.tcp_max_tw_buckets = 50000 
# 表示开启TCP连接中TIME-WAIT sockets的快速回收
net.ipv4.tcp_tw_reuse = 1
#启用timewait 快速回收。这个一定要开启，默认是关闭的。
net.ipv4.tcp_tw_recycle= 1   
# 修改系統默认的TIMEOUT时间,默认是60s
net.ipv4.tcp_fin_timeout = 10
```