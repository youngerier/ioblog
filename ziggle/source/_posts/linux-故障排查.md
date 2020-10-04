---
title: linux-故障排查
date: 2019-06-27 11:05:03
tags:
- linux
---

#### 找到占用CPU最高的线程

- 通常的做法是：
➊ 在命令行输入top，然后shift+p查看占用CPU最高的进程，记下进程号
➋ 在命令行输入top -Hp 进程号，查看占用CPU最高的线程
➌ 使用printf 0x%x 线程号，得到其16进制线程号
➍ 使用jstack 进程号得到java执行栈，然后grep16进制找到相应的信息


- 这一行Shell的意思是，找到使用CPU最高的进程之使用CPU最高的线程的16进制号。

```
ps -eo %cpu,pid |sort -n -k1 -r | head -n 1 |  awk '{print $2}' |xargs  top -b -n1 -Hp | grep COMMAND -A1 | tail -n 1 | awk '{print $1}' | xargs printf 0x%x
```

先记住这些判断准则，我们在示例中再聊：
➊ 如果load超过了cpu核数，则负载过高
➋ 如果wa过高，可初步判断I/O有问题
➌ sy,si,hi,st，任何一个超过5%，都有问题
➍ 进程状态长时处于D、Z、T状态，提高注意度
➎ cpu不均衡，判断亲和性和优先级问题



CPU过高是表象。除了系统确实负载已经到了极限，其他的，都是由其他原因引起的，比如I/O；比如设备。这些我们放在其他章节进行讨论。

##### GC引起的CPU过高
接着我们最开始的例子来。通过查看jstack找到相应的16进制进程，结果发现是GC线程。

"VM Thread" prio=10 tid=0x00007f06d8089000 nid=0x58c7 runnable 

"GC task thread#0 (ParallelGC)" prio=10 tid=0x00007f06d801b800 nid=0x58d7 runnable
这种情况，一般都是JVM内存不够用了，疯狂GC，可能是socket/线程忘了关闭了，也可能是大对象没有回收。这种情况只能通过重启来解决了，记得重启之前，使用jmap dump一下堆栈哦。当然，你可能会得到jdk版本的问题。

st%占比过高
st过高一般是物理CPU资源不足所致，也就是只发生在虚拟机上。
如果你买的虚拟机st一直很高，那你的服务提供商可能在超卖，挤占你的资源。不信双11的时候看下你的虚拟机？

##### 网卡导致单cpu过高
业务方几台kafka，cpu使用处于正常水平，才10%左右，但有一核cpu，负载特别的高，si奇高。

mpstat -I SUM -P ALL 查看cpu使用情况，cpu0的中断确实比较多。

20:15:18  CPU    intr/s  
20:15:23  all  34234.20  
20:15:23    0   9566.20  
20:15:23    1      0.00
网卡需要cpu服务时，都会抛出一个中断，中断告诉cpu发生了什么事情，cpu就要停止目前的工作来处理这个中断。其实，默认所有的中断处理都集中在cpu0 上，导致服务器负载过高。cpu0 成了瓶颈，而其他cpu却还闲着。
➊ 解决方式1：使用CPU亲和性功能，kafka略过网卡所使用的CPU
➋ 解决方式2: 更换网卡
➌ 通常修改的方式还是有些复杂了，比如，修改

/proc/irq/{seq}/smp_affinity

我们可以直接安装irqbalance，然后执行就可以了。

yum install irqbalance -y 
service irqbalance start
cpu使用率低，但负载高
cpu id%高，也就是空闲，比如90%。但 load average非常高，比如4核达到10。

分析：load average高，说明其任务已经排队，许多任务正在等待。出现此种情况，可能存在大量不可中断的进程。

使用top或者ps可以看到进程相应的状态。

https://mp.weixin.qq.com/s/WTva_bvkIn7uTCxv0m2RiA

which woman love man

## 排查内存的一些命令
内存分两部分，物理内存和swap。物理内存问题主要是内存泄漏，而swap的问题主要是用了swap～，我们先上一点命令。

### 物理内存
- 根据使用量排序查看RES
top -> shift + m
- 查看进程使用的物理内存
ps -p 75 -o rss,vsz
- 显示内存的使用情况
free -h 
- 使用sar查看内存信息
sar -r
- 显示内存每个区的详情
cat /proc/meminfo 
- 查看slab区使用情况
slabtop
通常，通过查看物理内存的占用，你发现不了多少问题，顶多发现那个进程占用内存高（比如vim等旁路应用）。meminfo和slabtop对系统的全局判断帮助很大，但掌握这两点坡度陡峭。

### swap
- 查看si,so是否异常
vmstat 1 
- 使用sar查看swap
sar -W
- 禁用swap
swapoff 
- 查询swap优先级
sysctl -q vm.swappiness
- 设置swap优先级
sysctl vm.swappiness=10
建议关注非0 swap的所有问题，即使你用了ssd。swap用的多，通常伴随着I/O升高，服务卡顿。swap一点都不好玩，不信搜一下《swap罪与罚》这篇文章看下，千万不要更晕哦。

<!-- more -->


### JVM
- 查看系统级别的故障和问题
dmesg
- 统计实例最多的类前十位 
jmap -histo pid | sort -n -r -k 2 | head -10
- 统计容量前十的类 
jmap -histo pid | sort -n -r -k 3 | head -10
以上命令是看堆内的，能够找到一些滥用集合的问题。堆外内存，依然推荐
《Java堆外内存排查小结》

### 其他
- 释放内存
echo 3 > /proc/sys/vm/drop_caches
- 查看进程物理内存分布
pmap -x 75  | sort -n -k3
- dump内存内容
gdb --batch --pid 75 -ex "dump memory a.dump 0x7f2bceda1000 0x7f2bcef2b000"

## 内存模型
二王的问题表象都是CPU问题，CPU都间歇性的增高，那是因为Linux的内存管理机制引起的。你去监控Linux的内存使用率，大概率是没什么用的。因为经过一段时间，剩余的内存都会被各种缓存迅速占满。一个比较典型的例子是ElasticSearch，分一半内存给JVM，剩下的一半会迅速被Lucene索引占满。

如果你的App进程启动后，经过两层缓冲后还不能落地，迎接它的，将会是oom killer。

接下来的知识有些烧脑，但有些名词，可能是你已经听过多次的了。

操作系统视角


我们来解释一下上图，第一部分是逻辑内存和物理内存的关系；第二部分是top命令展示的一个结果，详细的列出了每一个进程的内存使用情况；第三部分是free命令展示的结果，它的关系比较乱，所以给加上了箭头来作说明。

学过计算机组成结构的都知道，程序编译后的地址是逻辑内存，需要经过翻译才能映射到物理内存。这个管翻译的硬件，就叫MMU；TLB就是存放这些映射的小缓存。内存特别大的时候，会涉及到hugepage，在某些时候，是进行性能优化的杀手锏，比如优化redis (THP，注意理解透彻前不要妄动)

物理内存的可用空间是有限的，所以逻辑内存映射一部分地址到硬盘上，以便获取更大的物理内存地址，这就是swap分区。swap是很多性能场景的万恶之源，建议禁用

像top展示的字段，RES才是真正的物理内存占用（不包括swap，ps命令里叫RSS)。在java中，代表了堆内+堆外内存的总和。而VIRT、SHR等，几乎没有判断价值(某些场景除外)

系统的可用内存，包括：free + buffers + cached，因为后两者可以自动释放。但不要迷信，有很大一部分，你是释放不了的

slab区，是内核的缓存文件句柄等信息等的特殊区域，slabtop命令可以看到具体使用

更详细的，从/proc/meminfo文件中可以看到具体的逻辑内存块的大小。有多达40项的内存信息，这些信息都可以通过/proc一些文件的遍历获取，本文只挑重点说明。

[xjj@localhost ~]$ cat /proc/meminfo
MemTotal:        3881692 kB
MemFree:          249248 kB
MemAvailable:    1510048 kB
Buffers:           92384 kB
Cached:          1340716 kB
40+ more ...
oom-killer
以下问题已经不止一个小伙伴问了：我的java进程没了，什么都没留下，就像个屁一样蒸发不见了
why？是因为对象太多了么？
执行dmesg命令，大概率会看到你的进程崩溃信息躺尸在那里。

为了能看到发生的时间，我们习惯性加上参数T

dmesg -T
由于linux系统采用的是虚拟内存，进程的代码，库，堆和栈的使用都会消耗内存，但是申请出来的内存，只要没真正access过，是不算的，因为没有真正为之分配物理页面。

第一层防护墙就是swap；当swap也用的差不多了，会尝试释放cache；当这两者资源都耗尽，杀手就出现了。oom killer会在系统内存耗尽的情况下跳出来，选择性的干掉一些进程以求释放一点内存。2.4内核杀新进程；2.6杀用的最多的那个。所以，买内存吧。

这个oom和jvm的oom可不是一个概念。顺便，瞧一下我们的JVM堆在什么位置。


### 例子
#### jvm内存溢出排查
应用程序发布后，jvm持续增长。使用jstat命令，可以看到old区一直在增长。

jstat  -gcutil 28266 1000
在jvm参数中，加入-XX:+HeapDumpOnOutOfMemoryError，在jvm oom的时候，生成hprof快照。然后，使用Jprofile、VisualVM、Mat等打开dump文件进行分析。

你要是个急性子，可以使用jmap立马dump一份

jmap -heap:format=b pid
最终发现，有一个全局的Cache对象，不是guava的，也不是commons包的，是一个简单的ConcurrentHashMap，结果越积累越多，最终导致溢出。

溢出的情况也有多种区别，这里总结如下：

关键字	原因
Java.lang.OutOfMemoryError: Java heap space	堆内存不够了，或者存在内存溢出
java.lang.OutOfMemoryError: PermGen space	Perm区不够了，可能使用了大量动态加载的类，比如cglib
java.lang.OutOfMemoryError: Direct buffer memory	堆外内存、操作系统没内存了，比较严重的情况
java.lang.StackOverflowError	调用或者递归层次太深，修正即可
java.lang.OutOfMemoryError: unable to create new native thread	无法创建线程，操作系统内存没有了，一定要预留一部分给操作系统，不要都给jvm
java.lang.OutOfMemoryError: Out of swap space	同样没有内存资源了，swap都用光了
jvm程序内存问题，除了真正的内存泄漏，大多数都是由于太贪心引起的。一个4GB的内存，有同学就把jvm设置成了3840M，只给操作系统256M，不死才怪。

另外一个问题就是swap了，当你的应用真正的高并发了，swap绝对能让你体验到它魔鬼性的一面：进程倒是死不了了，但GC时间长的无法忍受。

#### 我的ES性能低
业务方的ES集群宿主机是32GB的内存，随着数据量和访问量增加，决定对其进行扩容=>内存改成了64GB。

内存升级后，发现ES的性能没什么变化，某些时候，反而更低了。

通过查看配置，发现有两个问题引起。
一、64GB的机器分配给jvm的有60G，预留给文件缓存的只有4GB，造成了文件缓存和硬盘的频繁交换，比较低效。
二、JVM大小超过了32GB，内存对象的指针无法启用压缩，造成了大量的内存浪费。由于ES的对象特别多，所以留给真正缓存对象内容的内存反而减少了。

解决方式：给jvm的内存30GB即可。

#### 其他
基本上了解了内存模型，上手几次内存溢出排查，内存问题就算掌握了。但还有更多，这条知识系统可以深挖下去。

JMM
还是拿java来说。java中有一个经典的内存模型，一般面试到volitile关键字的时候，都会问到。其根本原因，就是由于线程引起的。
当两个线程同时访问一个变量的时候，就需要加所谓的锁了。由于锁有读写，所以java的同步方式非常多样。wait,notify、lock、cas、volitile、synchronized等，我们仅放上volitile的读可见性图作下示例。


线程对共享变量会拷贝一份到工作区。线程1修改了变量以后，其他线程读这个变量的时候，都从主存里刷新一份，此所谓读可见。

JMM问题是纯粹的内存问题，也是高级java必备的知识点。

CacheLine & False Sharing
是的，内存的工艺制造还是跟不上CPU的速度，于是聪明的硬件工程师们，就又给加了一个缓存（哦不，是多个）。而Cache Line为CPU Cache中的最小缓存单位。



这个缓存是每个核的，而且大小固定。如果存在这样的场景，有多个线程操作不同的成员变量，但是相同的缓存行，这个时候会发生什么？。没错，伪共享（False Sharing）问题就发生了！

伪共享也是高级java的必备技能（虽然几乎用不到），赶紧去探索吧。

HugePage
回头看我们最长的那副图，上面有一个TLB，这个东西速度虽然高，但容量也是有限的。当访问频繁的时候，它会成为瓶颈。
TLB是存放Virtual Address和Physical Address的映射的。如图，把映射阔上一些，甚至阔上几百上千倍，TLB就能容纳更多地址了。像这种将Page Size加大的技术就是Huge Page。



HugePage有一些副作用，比如竞争加剧（比如redis： https://redis.io/topics/latency ）。但在大内存的现代，开启后会一定程度上增加性能（比如oracle： https://docs.oracle.com/cd/E11882_01/server.112/e10839/appi_vlm.htm )。

Numa
本来想将Numa放在cpu篇，结果发现numa改的其实是内存控制器。这个东西，将内存分段，分别”绑定”在不同的CPU上。也就是说，你的某核CPU，访问一部分内存速度贼快，但访问另外一些内存，就慢一些。

所以，Linux识别到NUMA架构后，默认的内存分配方案就是：优先尝试在请求线程当前所处的CPU的内存上分配空间。如果绑定的内存不足，先去释放绑定的内存。

以下命令可以看到当前是否是NUMA架构的硬件。

numactl --hardware
NUMA也是由于内存速度跟不上给加的折衷方案。Swap一些难搞的问题，大多是由于NUMA引起的。

#### **分析工具**
> cpu
| 工具     | 描述                           |
| -------- | ------------------------------ |
| uptime/w | 查看服务器运行时间、平均负载   |
| top      | 监控每个进程的CPU用量分解      |
| vmstat   | 系统的CPU平均负载情况          |
| mpstat   | 查看多核CPU信息                |
| sar -u   | 查看CPU过去或未来时点CPU利用率 |
| pidstat  | 查看每个进程的用量分解         |

>内存
| 工具    | 描述                           |
| ------- | ------------------------------ |
| free    | 查看内存的使用情况             |
| top     | 监控每个进程的内存使用情况     |
| vmstat  | 虚拟内存统计信息               |
| sar -r  | 查看内存                       |
| sar     | 查看CPU过去或未来时点CPU利用率 |
| pidstat | 查看每个进程的内存使用情况     |

> 磁盘
| 工具    | 描述                         |
| ------- | ---------------------------- |
| iostat  | 磁盘详细统计信息             |
| iotop   | 按进程查看磁盘IO统计信息     |
| pidstat | 查看每个进程的磁盘IO使用情况 |

>网络
| -------- | ---------------------------- |
| ping     | 测试网络的连通性             |
| netstat  | 检验本机各端口的网络连接情况 |
| hostname | 查看主机和域名               |


统计机器中网络连接各个状态个数

`netstat` `-an | ``awk` `'/^tcp/ {++S[$NF]} END {for (a in S) print a,S[a]} '`
