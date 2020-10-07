---
title: netty-handler
date: 2019-08-28 21:35:24
tags:
---

#### `channel`的生命状态周期

|状态|说明|
|------------|------------|------------|
|channelUnregistered|说明|
|channelUnregistered|`channel`创建之后，还未注册到`EventLoop`
|channelRegistered|`channel`注册到了对应的`EventLoop`
|channelActive|`channel`处于活跃状态，活跃状态表示已经连接到了远程服务器，现在可以接收和发送数据
|channelInactive|`channel` 未连接到远程服务器
### 一个Channel正常的生命周期如下
channelRegistered -> channelActice -> channelInactive -> channelUnregistered

{% asset_img netty多路复用.png netty多路复用 %}


#### 零拷贝（DIRECT BUFFERS 使用堆外直接内存）

1. Netty 的接收和发送 ByteBuffer 采用 DIRECT BUFFERS，使用堆外直接内存进行 Socket 读写，
不需要进行字节缓冲区的二次拷贝。如果使用传统的堆内存（HEAP BUFFERS）进行 Socket 读写，
JVM 会将堆内存 Buffer 拷贝一份到直接内存中，然后才写入 Socket 中。相比于堆外直接内存，
消息在发送过程中多了一次缓冲区的内存拷贝。
2. Netty 提供了组合 Buffer 对象，可以聚合多个 ByteBuffer 对象，用户可以像操作一个 Buffer 那样
方便的对组合 Buffer 进行操作，避免了传统通过内存拷贝的方式将几个小 Buffer 合并成一个大的
Buffer。
3. Netty的文件传输采用了transferTo方法，它可以直接将文件缓冲区的数据发送到目标Channel，
避免了传统通过循环 write 方式导致的内存拷贝问题