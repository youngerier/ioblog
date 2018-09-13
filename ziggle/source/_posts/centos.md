---
title: centos
date: 2018-09-05 14:22:56
tags:
---

# CONFIG  STATIC IP

vim /etc/sysconfig/network-scripts/ifcfg-XXXX

```conf
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
IPADDR=192.168.2.81
NETMASK=255.255.0.0
GATEWAY=192.168.2.1

DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens192
UUID=965fd86f-b05a-4797-a851-2fd268affb03
DEVICE=ens192
ONBOOT=yes
DNS1=192.168.2.214
```

# yum install docker-ce

```sh
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

```sh
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

```sh
sudo yum install docker-ce -y
```

## centos docker-compose

```sh
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```

```sh
sudo chmod +x /usr/local/bin/docker-compose
```

## 加速器

```sh
sudo tee /etc/docker/daemon.json <<- 'EOF'
{
    "registry-mirrors":["https://registry.docker-cn.com"]
}
```

# nginx 静态文件代理服务器 403

> 权限不够


> selinux 需要关闭

临时

```sh
getenforce

setenforce 0
```

永久 vim /etc/sysconfig/selinux

```sh
SELINUX=disabled
```

