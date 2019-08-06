---
title: linux-awk
date: 2019-08-06 17:41:10
tags:
---


### 打印某一列

```awk
awk '{print $1}' file
```

```
awk  -F ","   '{print $1,$2}'   file
     |参数 |    |操作|

awk -F "," '/^a/ {print $3}' file
```