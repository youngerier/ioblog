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
每个数据中心DataCenter 的server推荐3到5 ,所有的server都采用raft一致性算法来确保事务的一致性和线性化,事务修改了集群的状态，且集群的状态保存在每一台server上保证可用性
集群配置 一个client 两个server


{% asset_img consul_startup.png consul_startup %}


<!-- more -->

常用命令command:
- agent 运行consul agent
- join  将agent加入consul cluster
- members 列出consul cluster 集群中的members

agent 配置选项
- -data-dir
指定agent储存状态数据目录

- -config-dir

- -config-file
指定service配置文件所在位置 配置文件为json文件

- -dev 
开发调试使用不会持久化数据

- -bootstrap-expect
该命令通知consul server我们现在准备加入的server节点个数，该参数是为了延迟日志复制的启动直到我们指定数量的server节点成功的加入后启动

- -node
指定节点在集群中的名称
在cluster中唯一,使用机器IP地址

- -server
指定节点为server

- -client 
指定节点为client
如果不指定为server 默认为-client

- -join
加入node 进cluster


- -datacenter
指定dc 名默认dc1

- -http-addr
指定用户接口 包括 http,dns 接口 默认是localhost ,使用


```yml
spring:
  cloud:
    consul:
      host: localhost
      port: 8500
      discovery:
        instance-id: ${spring.application.name}
        health-check-path: /health-check
        health-check-interval: 10s
        tags: foo=bar,baz
      config:
        enabled: true
        fail-fast: true
        prefix: config #consul 自定义配置的文件夹的前缀 默认为config  service/"服务名"/"服务tag"/config
        data-key: configuration  # 指定consul配置的配置文件为configuration
        default-context: ${spring.application.name} # consul配置的配置文件父路径
        format: properties
        acl-token: 59ac2b0e-c500-4c38-8df8-dadfc4505edf

  application:
    name: myconfigapp
```

{% asset_img consulconfig.png consulconfig.png %}

<!-- more -->


- consul 单节点配置

```json
[root@java-web-ci data]# cat /etc/consul/conf/consul.json 
{
    "datacenter": "dc-1",
    "data_dir": "./data",
    "log_level": "INFO",
    "node_name": "n01",
    "server": true,
    "ui": true,
    "bind_addr": "0.0.0.0",
    "client_addr": "0.0.0.0",
    "bootstrap_expect": 1,
    "retry_interval": "3s",
    "raft_protocol": 3,
    "enable_debug": false,
    "rejoin_after_leave": true,
    "enable_syslog": false
}

```


- acl.json
```json
[root@java-web-ci data]# cat /etc/consul/conf/acl.json 
{
    "acl_datacenter": "dc-1",
    "acl_default_policy": "deny",
    "acl_down_policy": "deny",
    "acl_master_token": "TnS03PiBEmvAALZ1fFRW7g=="
  }
```

- consul systemd

```conf
[root@java-web-ci data]# cat /etc/systemd/system/consul.service 
[Unit]
Description=Consul Service
After=network.target

[Service]
Type=simple
# Another Type option: forking
User=root
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul/conf/
Restart=always
RestartSec=1
# Other Restart options: or always, on-abort, etc

[Install]
WantedBy=multi-user.target
```
{% asset_img consul_env.png consul_env.png %}



#### 清理不活动的service

 - 依赖库
```cmd
npm i request
```
 - 执行脚本
```js
var request = require('request');

request.get({
    url: `http://xxx:8500/v1/health/state/critical`,
    headers: { 'X-Consul-Token': 'hidden' }
}, function (e, r, b) {
    cb(JSON.parse(b))
})



function cb(servicesList) {
    servicesList.forEach(i => {
        request.put({
            url: `http://xxx:8500/v1/agent/service/deregister/${i.ServiceID}`,
            method: 'put',
            headers: {
                'X-Consul-Token': 'hidden'
            }
        },
            function (e, r, bodby) {
                console.log('error:', e); // Print the error if one occurred
                console.log('statusCode:', r && r.statusCode); // Print the response status code if a response was received
            });
    })

}
```