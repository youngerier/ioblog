---
title: linux-basic
date: 2017-12-08 23:37:31
tags:
    -linux
---


# 重要文件以及位置
- /dev/null  # 输入流blackhole

## /etc/profile
- 系统环境变量,为每个用户设置环境信息,当用户登陆时执行,并从/etc/profile.d 目录的配置文件中搜集shell 的设置。

## /etc/bashrc
- 在执行完/etc/profile 之后如果用户是shell 运行的是bash,就会执行.可以用来设置
每次登陆的时候都会去获取这些新的环境变量或者做某些特殊的操作，但是仅仅在登陆时

## ~/.bashrc
该文件包含专用于单个人的bash shell 的bash 信息，当登录时以及每次打开一个新的shell 时, 该该文件被读取。单个用户此文件的修改会影响到他以后的每一次登陆系统和每一次新开一个bash 。因此，可以在这里设置单个用户的特殊的环境变量或者特殊的操作，那么每次它新登陆系统或者新开一个bash ，都会去获取相应的特殊的环境变量和特殊操作

## ~/.bash_logout
当每次退出系统( 退出bash shell) 时, 执行该文件

# shell 基本命令
查看shell变量
```nil
 root@ziggle:~# env
```
## set
设置bash变量
## unset
清楚 本地|系统变量

## exprot
用于把变量变成当前shell 和其子shell 的环境变量，存活期是当前的shell 及其子shell ，因此重新登陆以后，它所设定的环境变量就消失了
## source

<!-- more -->

# CentOS 升级python3.x
## 源码安装
注意
```
tar Jxvf Python-3.5.1.tar.xz
 cd Python-3.5.1
 ./configure --prefix=/usr/local/python3
 make && make install
```
## 
- 备份旧版本 Python 
```
mv /usr/bin/python /usr/bin/python2.7
```
- 新建指向新版本 Python 以及 pip 的软连接 
```
ln -s /usr/local/python3/bin/python3.5 /usr/bin/python 
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip
```
- 检验 Python 及 pip 版本 
```
python -V 
pip -V
```
> CentOS yum会使用python 更改错误文件python版本为老版本