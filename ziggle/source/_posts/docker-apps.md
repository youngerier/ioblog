---
title: docker-apps
date: 2019-06-26 16:38:22
tags:
---

### docker 安装nuxus

```
$ mkdir -p /lib/nexus/nexus-data && chown -R 200 /lib/nexus/nexus-data
$ docker run -d -p 8081:8081 --name nexus -v /lib/nexus/nexus-data:/nexus-data sonatype/nexus3
```