---
title: netty-handler
date: 2019-08-28 21:35:24
tags:
---

### `channel`的生命状态周期

|状态|说明|
|------------|------------|------------|
|channelUnregistered|说明|
|channelUnregistered|`channel`创建之后，还未注册到`EventLoop`
|channelRegistered|`channel`注册到了对应的`EventLoop`
|channelActive|`channel`处于活跃状态，活跃状态表示已经连接到了远程服务器，现在可以接收和发送数据
|channelInactive|`channel` 未连接到远程服务器
### 一个Channel正常的生命周期如下
channelRegistered -> channelActice -> channelInactive -> channelUnregistered

