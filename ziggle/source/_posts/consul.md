---
title: consul
date: 2017-12-31 16:49:55
tags:
    - consul 
---

### consul 启动配置
> 配置


```json
root@ziggle:~# cat  /etc/consul.d/consul.json 
{
	"datacenter":"ziggle-dc",
	"log_level":"INFO",
	"server":true,
	"data_dir":"/opt/consul",
	"bind_addr":"107.182.183.107",
	"ui":true
}	
```
> 启动命令


```bash
/usr/local/bin/consul agent -config-file /etc/consul.d/consul.json -client=107.107.107.107
```

> 管理页面


{% asset_img consul_startup.png consul_startup %}

