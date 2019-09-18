---
title: linux server 计算PI
date: 2019-09-18 16:24:44
tags:
---

#### 测试一下单核CPU的计算能力

```sh
time echo "scale=10000; 4*a(1)" | bc -l
```