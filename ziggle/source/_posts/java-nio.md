---
title: java-nio
date: 2020-10-07 22:06:16
tags:
---

### NIO 的非阻塞

IO 的各种流是阻塞的。这意味着，当一个线程调用 read() 或 write()时，该线程被阻塞，直到有
一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了。 NIO 的非阻塞模式，
使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据，如果目前没有数据可
用时，就什么都不会获取。而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以
继续做其他的事情。 非阻塞写也是如此。一个线程请求写入一些数据到某通道，但不需要等待它
完全写入，这个线程同时可以去做别的事情。 线程通常将非阻塞 IO 的空闲时间用于在其它通道上
执行 IO 操作，所以一个单独的线程现在可以管理多个输入和输出通道（channel）。

#### Selector

Selector 能够检测多个注册的通道上是否有事件发生,如果事件发生,便获取事件然后针对每个事件进行相应的相应处理
这样一个单线程就可以处理多个通道,也就是管理多个连接,