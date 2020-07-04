---
title: java-gradle 编译问题记录
date: 2020-07-05 04:08:00
tags:
- java
- gradle
---


gradle tookchain => jdk14
gradle config targetCompatibility=1.8
gradle config sourceCompatibility=1.8

ByteBuffer
`NoSuchMethodError: java.nio.ByteBuffer.limit(I)Ljava/nio/ByteBuffer`

link[https://github.com/eclipse/jetty.project/issues/3244]

link[https://stackoverflow.com/questions/61267495/exception-in-thread-main-java-lang-nosuchmethoderror-java-nio-bytebuffer-flip]

### 构建工具 运行环境 配置jdk版本要一致啊。
