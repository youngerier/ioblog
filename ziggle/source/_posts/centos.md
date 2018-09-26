---
title: centos
date: 2018-09-05 14:22:56
tags:
---

## CONFIG  STATIC IP

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

## yum install docker-ce

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

## nginx 静态文件代理服务器 403

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

## linux user

> useradd options username
- options
    - -c comment
    - -d 目录
    - -G 用户组指定用户所属的附加组
    - -g 永驻 指定用户所属的用户组
    - -s shell 文件 指定用户的登陆shell
    - -u 用户号
- 用户名
    - 指定新账号的登陆名

```
useradd -d /usr/ziggle -m ziggle

useradd -s /bin/sh -g group –G adm,root gem

此命令新建了一个用户gem，该用户的登录Shell是 /bin/sh，它属于group用户组，同时又属于adm和root用户组，其中group用户组是其主组。
```

userdel options username
```
userdel -r ziggle

此命令删除用户sam在系统文件中（主要是/etc/passwd, /etc/shadow, /etc/group等）的记录，同时删除用户的主目录。
```

## linux usergroup

> group add options usergroup

- options 
    - -g GID 组标识
    - -o 
  
> group del

```
groupdel group1
```

### 与用户账号有关的系统文件

```
[root@frpserver ~]# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:997:User for polkitd:/:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
nscd:x:28:28:NSCD Daemon:/:/sbin/nologin
```
从上面的例子我们可以看到，/etc/passwd中一行记录对应着一个用户，每行记录又被冒号(:)分隔为7个字段，其格式和具体含义如下：

用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell