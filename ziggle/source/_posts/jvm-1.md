---
title: jvm
date: 2018-12-12 11:00:50
tags:
---

Eden 内存分配

为了方便垃圾回收 ,jvm 将对内存分为新生代,老生带
新生代分为 Eden ,from Survivor, to Survivor 区

其中Eden 和Survivor 区比例默认是 8:1:1 ,参数调整配置 -XX:SurvivorRatio=8
当在Eden区分配内存不足时,会发生minorGC 由于多数对象生命周期很短,minorGC发生频繁

当发生minorGC 时jvm 会根据复制算法 将存活的对象拷贝到另一个未使用的Survivor区如果Survovor 区内存不足
会使用分配担保策略将对象移动到老年代

谈到minorGC 相对的fullGC(majorGC) 是指发生在老年代的GC,不论是效率还是速度都比minorGC慢得多
回收时会发生stop the world 是程序发生停顿


### jvm config
https://docs.oracle.com/cd/E40972_01/doc.70/e40973/cnf_jvmgc.htm#autoId2

```
-server -Xms24G -Xmx24G -XX:PermSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=20 -XX:ConcGCThreads=5 -XX:InitiatingHeapOccupancyPercent=70

```