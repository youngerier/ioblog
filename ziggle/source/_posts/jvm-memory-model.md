---
title: jvm
date: 2018-12-12 11:00:50
tags:
---

### `JVM` 内存模型

{% asset_img jvm-memory-model.png jvm-memory-model%}


### Eden 内存分配

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


### javac

 - 词法分析
 - 语法分析
 - 语义分析
 - 字节码生成器

 从源代码找出规范化的token流
 判断是否复合Java语言规范 形成抽象语法树
 将复杂语法转换为简单语法 语法糖处理
 生成字节码


### jvm 运行时数据区域

方法区
虚拟机栈
本地方法栈
程序计数器 -- 没有oom
堆
 
运行时常量区是方法区的一部分存放编译时生成的字面量和符号引用

### 对象的创建
 - 
虚拟机遇到一条new指令时，首先将去检查这个指令的参数是否能在常量池中定位到一 个类的符号引用，并且检查这个符号引用代表的类是否已被加载、解析和初始化过。如果没 有，那必须先执行相应的类加载过程


### 对象的内存布局
 - 示例数据
 - 对齐填充
 - 对象头 虚拟机要对对象进行必要的设置，例如这个对象是哪个类的实例、如何才能找 到类的元数据信息、对象的哈希码、对象的GC分代年龄等信息。这些信息存放在对象的对 象头(Object Header)之中。根据虚拟机当前的运行状态的不同，如是否启用偏向锁等，对 象头会有不同的设置方式

### 对象的访问定位

### 引用

 - `java 1.2` 如果reference类型的数据中存储的数值代表的是另外一块内存的起始地址，就称这块 内存代表着一个引用

### 回收方法区
- 判断是否是一个无用的类
 - 所有类的实例都已经被回收 , java堆中不存在类的任何实例
 - 加载该类的`ClassLoader`已经被回收
 - 该类对应的java.lang.Class对象没有在任何地方被引用，无法在任何地方通过反射访问该 类的方法

### CMS 收集器

- 初始标记(CMS initial mark)      - Stop The World
- 并发标记(CMS concurrent mark)   - 
- 重新标记(CMS remark)            - Stop The World   
- 并发清除(CMS concurrent sweep)  -  

### G1 
- 初始标记(Initial Marking)
- 并发标记(Concurrent Marking)
- 最终标记(Final Marking)
- 筛选回收(Live Data Counting and Evacuation)


#### 内存分配与回收策略

 对象主要分配在新生代的Eden区上 ,少数情况下也可能会直接分配在老年代中 其细节取决于当前使用的是哪一种垃圾收集器组合，还有虚拟 机中与内存相关的参数的设置

 - 对象优先在`Eden`分配 当`Eden`区没有足够空间进行分配时，虚拟 机将发起一次`Minor GC`
 - 


