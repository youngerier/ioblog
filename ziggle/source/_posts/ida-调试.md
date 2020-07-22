---
title: ida-调试
date: 2020-07-22 18:12:06
tags:
---

###　adb 调试步骤

```shell

adb shell
su
cd /data/local/tmp
./android_server

# 
adb forward tcp:23946 tcp:23946
```