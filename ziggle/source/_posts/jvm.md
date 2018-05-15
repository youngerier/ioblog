---
title: jvm
date: 2018-02-24 18:51:17
tags:
    -jvm
---
## JVM小工具
在${JAVA_HOME}/bin/目录下Sun/Oracle给我们提供了一些处理应用程序性能问题、定位故障的工具, 包含

|bin	|描述|	功能|
| :------- | --------: | :---: |
|jps	|打印Hotspot VM进程	|VMID、JVM参数、main()函数参数、主类名/Jar路径
|jstat	|查看Hotspot VM 运行时信息|	类加载、内存、GC[可分代查看]、JIT编译
|jinfo	|查看和修改虚拟机各项配置|	-flag name=value
|jmap	|heapdump: 生成VM堆转储快照、查询finalize执行队列、Java堆和永久代详细信息|	jmap -dump:live,ormat=b,file=heap.bin [VMID]
|jstack	|查看VM当前时刻的线程快照: 当前VM内每一条线程正在执行的方法堆栈集合	|Thread.getAllStackTraces()提供了类似的功能
|javap	|查看经javac之后产生的JVM字节码代码 |  自动解析.class文件, 避免了去理解class文件格式以及手动解析 class文件内容
|jcmd	|一个多功能工具, 可以用来导出堆, 查看Java进程、导出线程信息、 执行GC、查看性能相关数据等|	几乎集合了jps、jstat、jinfo、jmap、jstack所有功能
|jconsole|	基于JMX的可视化监视、管理工具	|可以查看内存、线程、类、CPU信息, 以及对JMX MBean进行管理
|jvisualvm|	JDK中最强大运行监视和故障处理工具|	可以监控内存泄露、跟踪垃圾回收、执行时内存分析、CPU分析、线程分析…



## VM常用参数整理
|参数	|描述|
| :------- | :---: |
|-Xms	|最小堆大小|
|-Xmx	|最大堆大小|
|-Xmn	|新生代大小|
|-XX:PermSize	|永久代大小|
|-XX:MaxPermSize|	永久代最大大小|
|-XX:+PrintGC	|输出GC日志|
|-verbose:gc	|-|
|-XX:+PrintGCDetails	|输出GC的详细日志|
|-XX:+PrintGCTimeStamps	|输出GC时间戳(以基准时间的形式)|
|-XX:+PrintHeapAtGC|	在进行GC的前后打印出堆的信息|
|-Xloggc:/path/gc.log|	日志文件的输出路径|
|-XX:+PrintGCApplicationStoppedTime|	打印由GC产生的停顿时间|

# 对内存分区情况截图

{% asset_img edenspace.png eden-space %} 

{% asset_img survivorspace.png survivor-space %} 

{% asset_img oldgen.png old-gen %} 



- 生产故障JVM 进程cpu 占用率一直100%
解决办法
(
    首先找出问题进程内CPU占用率高的线程
    再通过线程栈信息找出该线程当时在运行的问题代码段
)
 jvm负载一直居高不下，先使用了 top -c 查看当前进程详情
使用

遍历树时递归结构栈溢出

jvm 参数要修改 -Xss 
classpath :   String path = this.getClass().getResource("").getPath();

Class.forName(xxx.xx.xxx) 返回一个类
作用时要求jvm查找并加载指定的类，*也就是说JVM会执行该类的静态代码段*。

```ps1
# 查看运行的进程
jconsole


# 查看java堆配置
# jmap -heap <pid>

> jmap -heap 79376
Attaching to process ID 79376, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 25.144-b01

using thread-local object allocation.
Parallel GC with 4 thread(s)

Heap Configuration:
   MinHeapFreeRatio         = 0
   MaxHeapFreeRatio         = 100
   MaxHeapSize              = 2105540608 (2008.0MB)
   NewSize                  = 44040192 (42.0MB)
   MaxNewSize               = 701497344 (669.0MB)
   OldSize                  = 88080384 (84.0MB)
   NewRatio                 = 2
   SurvivorRatio            = 8
   MetaspaceSize            = 21807104 (20.796875MB)
   CompressedClassSpaceSize = 1073741824 (1024.0MB)
   MaxMetaspaceSize         = 17592186044415 MB
   G1HeapRegionSize         = 0 (0.0MB)

Heap Usage:
PS Young Generation
Eden Space:
   capacity = 408420352 (389.5MB)
   used     = 57457288 (54.79553985595703MB)
   free     = 350963064 (334.70446014404297MB)
   14.068174545816953% used
From Space:
   capacity = 17301504 (16.5MB)
   used     = 0 (0.0MB)
   free     = 17301504 (16.5MB)
   0.0% used
To Space:
   capacity = 18350080 (17.5MB)
   used     = 0 (0.0MB)
   free     = 18350080 (17.5MB)
   0.0% used
PS Old Generation
   capacity = 116391936 (111.0MB)
   used     = 40436112 (38.56288146972656MB)
   free     = 75955824 (72.43711853027344MB)
   34.741334657411315% used

33782 interned Strings occupying 3796288 bytes.


# java dump jvm堆内存使用情况 记录内存信息
> jmap -dump:format=b,file=dump.bin 79376
Dumping heap to E:\Doc\GitRepo\hydra\dump.bin ...
Heap dump file created


#如果我们只需要将dump中存活的对象导出，那么可以使用:live参数

>jmap -dump:live,format=b,file=heapLive.hprof 2576   


# thread dump
jstack 79376 > thread.txt

```
**heap dump**
  heap dump文件是一个二进制文件，它保存了某一时刻JVM堆中对象使用情况。HeapDump文件是指定时刻的Java堆栈的快照，是一种镜像文件。Heap Analyzer工具通过分析HeapDump文件，哪些对象占用了太多的堆栈空间，来发现导致内存泄露或者可能引起内存泄露的对象。
**thread dump**
 thread dump文件主要保存的是java应用中各线程在某一时刻的运行的位置，即执行到哪一个类的哪一个方法哪一个行上。thread dump是一个文本文件，打开后可以看到每一个线程的执行栈，以stacktrace的方式显示。通过对thread dump的分析可以得到应用是否“卡”在某一点上，即在某一点运行的时间太长，如数据库查询，长期得不到响应，最终导致系统崩溃。单个的thread dump文件一般来说是没有什么用处的，因为它只是记录了某一个绝对时间点的情况。比较有用的是，线程在一个时间段内的执行情况。

两个thread dump文件在分析时特别有效，困为它可以看出在先后两个时间点上，线程执行的位置，如果发现先后两组数据中同一线程都执行在同一位置，则说明此处可能有问题，因为程序运行是极快的，如果两次均在某一点上，说明这一点的耗时是很大的。通过对这两个文件进行分析，查出原因，进而解决问题。


>可视化查看 jvm 内存dump

>jhat -port 5000 dump.bin
<!-- more -->
## java 自带内存/cpu(线程)分析工具

> jps -vl

展示操作系统里面的java应用 显示pid
```cmd
E:\Doc\GitRepo\ioblog\ziggle [master ≡ +0 ~1 -0 !]> jps
112292 Launcher
48872
115272 Jps229016 Main
37292 DemoApplication
```
> jinfo -flags PID
显示 System.getProperties()
```
E:\Doc\GitRepo\ioblog\ziggle [master ≡ +0 ~1 -0 !]> jinfo -sysprops 37292
Attaching to process ID 37292, please wait...
Debugger attached successfully.
Server compiler detected.
java.vm.specification.name = Java Virtual Machine Specification
PID = 37292
java.runtime.version = 1.8.0_144-b01
........ 
```


> jstat -gc PID
显示JVM的各个内存区使用情况（容量和使用量），GC的次数和耗时。可以通过命令jstat -class PID查看class的加载情况。
```
E:\Doc\GitRepo\ioblog\ziggle [master ≡ +0 ~1 -0 !]> jstat -gc 37292 
S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT
16384.0 17408.0  0.0    0.0   245760.0 205516.6  138752.0   37613.3   59096.0 58195.3 7640.0 7388.5     13    0.192   3      0.502    0.695
```
> jstack PID
查看线程运行情况，检测是否有死锁。

> jconsole
JDK提供的一个可视化资源查看，监控工具。

> jvisualvm
JDK提供的另外一个一站式资源查看，监控，管理工具。支持插件机制，可以自己安装插件，定制jvisualvm。常用的是Visual GC插件。也可以通过该工具dump JVM的堆。也可以导入已经dump出来的堆信息进行分析

### 动态开启jvm gc 日志

```
jinfo  -flag +PrintGCDetails <pid>

jstat -gcutil <pid> 1000
```