---
title: CENTOS/RHEL 7 系统中设置SYSTEMD SERVICE的ULIMIT资源限制
date: 2019-09-18 16:16:07
tags:
---
在bash中，有个ulimit命令，提供了对shell及该shell启动的进程的可用资源控制。主要包括打开文件描述符数量、用户的最大进程数量、coredump文件的大小等。

在centos 5/6 等版本中，资源限制的配置可以在`/etc/security/limits.conf` 设置，针对root/user等各个用户或者*代表所有用户来设置。 当然，/etc/security/limits.d/ 中可以配置，系统是先加载limits.conf然后按照英文字母顺序加载limits.d目录下的配置文件，后加载配置覆盖之前的配置。 一个配置示例如下：

```conf
[root@ziggle-linux yum.repos.d]# cat /etc/security/limits.conf 
# /etc/security/limits.conf
#
#This file sets the resource limits for the users logged in via PAM.
#It does not affect resource limits of the system services.
#
#Also note that configuration files in /etc/security/limits.d directory,
#which are read in alphabetical order, override the settings in this
#file in case the domain is the same or more specific.
#That means for example that setting a limit for wildcard domain here
#can be overriden with a wildcard setting in a config file in the
#subdirectory, but a user specific setting here can be overriden only
#with a user specific setting in the subdirectory.

```

```conf
*     soft   nofile    100000
*     hard   nofile    100000
*     soft   nproc     100000
*     hard   nproc     100000
*     soft   core      100000
*     hard   core      100000
```
不过，在CentOS 7 / RHEL 7的系统中，使用Systemd替代了之前的SysV，因此 /etc/security/limits.conf 文件的配置作用域缩小了一些。limits.conf这里的配置，只适用于通过PAM认证登录用户的资源限制，它对systemd的service的资源限制不生效。登录用户的限制，与上面讲的一样，通过 /etc/security/limits.conf 和 limits.d 来配置即可。
对于systemd service的资源限制，如何配置呢？

全局的配置，放在文件 `/etc/systemd/system.conf` 和 `/etc/systemd/user.conf`。 同时，也会加载两个对应的目录中的所有.conf文件 `/etc/systemd/system.conf.d/*.conf` 和 `/etc/systemd/user.conf.d/*.conf`
其中，system.conf 是系统实例使用的，user.conf用户实例使用的。一般的sevice，使用system.conf中的配置即可。systemd.conf.d/*.conf中配置会覆盖system.conf。

```conf
DefaultLimitCORE=infinity
DefaultLimitNOFILE=100000
DefaultLimitNPROC=100000
```

注意：修改了system.conf后，需要重启系统才会生效。

针对单个Service，也可以设置，以nginx为例。
编辑 `/usr/lib/systemd/system/nginx.service` 文件，或者 `/usr/lib/systemd/system/nginx.service.d/my-limit.conf` 文件，做如下配置：

```conf
[Service]
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=100000
```

然后运行如下命令，才能生效。

```sh
sudo systemctl daemon-reload
sudo systemctl restart nginx.service
```
查看一个进程的limit设置：cat /proc/YOUR-PID/limits
例如我的一个nginx service的配置效果：

```bash
$cat /proc/$(cat /var/run/nginx.pid)/limits
Limit                     Soft Limit           Hard Limit           Units
Max cpu time              unlimited            unlimited            seconds
Max file size             unlimited            unlimited            bytes
Max data size             unlimited            unlimited            bytes
Max stack size            8388608              unlimited            bytes
Max core file size        unlimited            unlimited            bytes
Max resident set          unlimited            unlimited            bytes
Max processes             100000               100000               processes
Max open files            100000               100000               files
Max locked memory         65536                65536                bytes
Max address space         unlimited            unlimited            bytes
Max file locks            unlimited            unlimited            locks
Max pending signals       1030606              1030606              signals
Max msgqueue size         819200               819200               bytes
Max nice priority         0                    0
Max realtime priority     0                    0
Max realtime timeout      unlimited            unlimited            us
```
顺便提一下，我还被CentOS7自带的`/etc/security/limits.d/20-nproc.conf`文件坑过，里面默认设置了非root用户的最大进程数为4096，难怪我上次在limits.conf中设置了没啥效果，原来被limit.d目录中的配置覆盖了。