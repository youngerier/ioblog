---
title: differences_between_hashmap_and_hashtable
date: 2018-04-08 17:47:35
tags:
    - hashmap hashtable 的不同
---
> 线程
hashtable 是同步的 相反 hashmap并不是,
> null
hashtable 不允许有**null**key 或value ,hashmap 运行有一个null key 和任意个null value
> iterator
hashmap的子类linkedhashmap 迭代出的元素按插入顺序 可以有hashmap -> linkedhashmap 获取有序遍历


### 为什么使用char[] 保存password 而不是 String

string 类型是不可变类型,当创建String 实例对象,如果另一个进程dump 内存,是没法清除创建的string (在gc介入之前),如果用char[] 可以显式wrap数据
减少了password 被attack ....

### java concurrent 包实现
线程间通信有四种方式
A线程写volatile变量，随后B线程读这个volatile变量。
A线程写volatile变量，随后B线程用CAS更新这个volatile变量。
A线程用CAS更新一个volatile变量，随后B线程用CAS更新这个volatile变量。
A线程用CAS更新一个volatile变量，随后B线程读这个volatile变量。

volatile变量的读/写和CAS可以实现线程之间的通信 => **java concurrent包的基石** 

{% asset_img concurrent.png concurrent%}
