---
title: java-arthas
date: 2019-07-03 15:22:05
tags:
---


> 原文连接 
- `https://alibaba.github.io/arthas/arthas-tutorials?language=cn&id=arthas-advanced `

###  使用`arthas`
- 搜索jvm加载的lei

```
sc -d `全类名`
```

- watch

```
watch com.oucloud.data.service.impl.TaskServiceImpl  getTaskStringFromCache   "{params,returnObj}" -x 2 -b
watch com.oucloud.data.component.JobsOps  schedule   "{params,returnObj}" -x 2 -b
```



