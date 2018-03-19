---
title: jvm
date: 2018-02-24 18:51:17
tags:
    -jvm
---


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