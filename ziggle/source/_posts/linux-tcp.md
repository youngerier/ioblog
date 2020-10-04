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

## linux net 相关
- netstat属于net-tools工具集，而ss属于iproute。其命令对应如下，是时候和net-tools说Bye了。

用途	net-tools	iproute
统计	ifconfig	ss
地址	netstat	ip addr
路由	route	ip route
邻居	arp	ip neigh
VPN	iptunnel	ip tunnel
VLAN	vconfig	ip link
组播	ipmaddr	ip maddr


- 查看系统正在监听的tcp连接

ss -atr 
ss -atn #仅ip


- 查看系统中所有连接

ss -alt


- 查看监听444端口的进程pid

ss -ltp | grep 444


- 查看进程555占用了哪些端口

ss -ltp | grep 555


- 显示所有udp连接

ss -u -a
查看TCP sockets，使用-ta选项
查看UDP sockets，使用-ua选项
查看RAW sockets，使用-wa选项
查看UNIX sockets，使用-xa选项

- 显示所有的http连接
ss  dport = :http

- 查看连接本机最多的前10个ip地址
netstat -antp | awk '{print $4}' | cut -d ':' -f1 | sort | uniq -c  | sort -n -k1 -r | head -n 10


- sysctl命令可以设置这些参数，如果想要重启生效的话，加入/etc/sysctl.conf文件中。

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


<!-- more -->

## tcp 状态

TCP(Transmission Control Protocol)传输控制协议

TCP是主机对主机层的传输控制协议，提供可靠的连接服务，采用三次握手确认建立一个连接：

位码即tcp标志位，有6种标示：SYN(synchronous建立联机) ACK(acknowledgement 确认) PSH(push传送) FIN(finish结束) RST(reset重置) URG(urgent紧急)Sequence number(顺序号码) Acknowledge number(确认号码)

第一次握手：主机A发送位码为syn＝1，随机产生seq number=1234567的数据包到服务器，主机B由SYN=1知道，A要求建立联机；

第二次握手：主机B收到请求后要确认联机信息，向A发送ack number=(主机A的seq+1)，syn=1，ack=1，随机产生seq=7654321的包；

第三次握手：主机A收到后检查ack number是否正确，即第一次发送的seq number+1，以及位码ack是否为1，若正确，主机A会再发送ack number=(主机B的seq+1)，ack=1，主机B收到后确认seq值与ack=1则连接建立成功。

FTP协议及时基于此协议


{% asset_img tcp.png tcp.png%}

> 三次握手
{% asset_img tcpconn.png tcp.png%}
> 四次挥手
{% asset_img tcpclose.png tcp.png%}
{% asset_img tcp_n.png tcp.png%}

> 状态解释
```
LISTEN：侦听来自远方的TCP端口的连接请求
SYN-SENT：再发送连接请求后等待匹配的连接请求（如果有大量这样的状态包，检查是否中招了）
SYN-RECEIVED：再收到和发送一个连接请求后等待对方对连接请求的确认（如有大量此状态估计被flood攻击了）
ESTABLISHED：代表一个打开的连接
FIN-WAIT-1：等待远程TCP连接中断请求，或先前的连接中断请求的确认
FIN-WAIT-2：从远程TCP等待连接中断请求
CLOSE-WAIT：等待从本地用户发来的连接中断请求
CLOSING：等待远程TCP对连接中断的确认
LAST-ACK：等待原来的发向远程TCP的连接中断请求的确认（不是什么好东西，此项出现，检查是否被攻击）
TIME-WAIT：等待足够的时间以确保远程TCP接收到连接中断请求的确认
CLOSED：没有任何连接状态
```