---
title: android-magisk
date: 2020-07-23 19:04:12
tags: magisk
---
magisk 获取root流程
- 解锁bootloader或者通过特殊方式绕过AVB校验。
    - 解锁bootloader方法
        - 进入开发者模式，选择允许OEM解锁
        - 重启进入fastboot，执行fastboot flashing unlock ,解锁后在启动过程如果出现镜像校验失败也会继续启动，因此就可以刷入非官方镜像
- 从官方的update包中提取boot.img, 通过magisk工具对boot.img打补丁，在ramdisk中植入新的init程序，使用改init引导系统启动。
- 将boot.img刷入手机中，即完成root，可以通过magisk APK管理root授权