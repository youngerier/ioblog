---
title: linux-basic
date: 2017-12-08 23:37:31
tags:
    -linux
---


# 重要文件以及位置
- /dev/null  # 输入流blackhole

## /etc/profile
- 系统环境变量,为每个用户设置环境信息,当用户登陆时执行,并从/etc/profile.d 目录的配置文件中搜集shell 的设置.

## /etc/bashrc
- 在执行完/etc/profile 之后如果用户是shell 运行的是bash,就会执行.可以用来设置
每次登陆的时候都会去获取这些新的环境变量或者做某些特殊的操作,但是仅仅在登陆时

## ~/.bashrc
该文件包含专用于单个人的bash shell 的bash 信息,当登录时以及每次打开一个新的shell 时, 该该文件被读取.单个用户此文件的修改会影响到他以后的每一次登陆系统和每一次新开一个bash .因此,可以在这里设置单个用户的特殊的环境变量或者特殊的操作,那么每次它新登陆系统或者新开一个bash ,都会去获取相应的特殊的环境变量和特殊操作

## ~/.bash_logout
当每次退出系统( 退出bash shell) 时, 执行该文件

# shell 基本命令
变量类型
运行shell时,会同时存在三种变量:
- 局部变量 局部变量在脚本或命令中定义,仅在当前shell实例中有效,其他shell启动的程序不能访问局部变量.

- 环境变量 所有的程序,包括shell启动的程序,都能访问环境变量,有些程序需要环境变量来保证其正常运行.必要的时候shell脚本也可以定义环境变量.

- shell变量 shell变量是由shell程序设置的特殊变量.shell变量中有一部分是环境变量,有一部分是局部变量,这些变量保证了shell的正常运行.

查看shell变量
```nil
 root@ziggle:~# env
```
## set

设置bash变量
## unset

清除 本地|系统变量

## exprot

用于把变量变成当前shell 和其子shell 的环境变量,存活期是当前的shell 及其子shell ,因此重新登陆以后,它所设定的环境变量就消失了
## source

<!-- more -->

## 特殊变量

|  变量 |含义   |
| ------------ | ------------ |
| $0  |当前脚本的名字   |
| $n  | 传递给脚本或函数的参数，n是一个数字，表示第几个参数，例如，第一个参数是$1，第二个参数是$2。  |
| $#  | 传递给脚本或函数的参数个数|
| $*  | 传递给脚本或函数的所有参数|
| $@  | 传递给脚本或函数的所有参数。被双引号(“ “)包含时，与 $* 稍有不同|
| $?  |上个命令的退出状态，或函数的返回值 |
| $$  | 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID|


## 转义字符

```
转义字符	含义
\\	反斜杠
\a	警报，响铃
\b	退格（删除键）
\f	换页(FF)，将当前位置移到下页开头
\n	换行
\r	回车
\t	水平制表符（tab键） 
\v	垂直制表符
```

## 命令替换
命令替换是指Shell可以先执行命令，将输出结果暂时保存，在适当的地方输出。
语法：
```nil
`command`
```ZZ
- eg: 
```bash
#!/bin/bash
DATA=`date`
echo "Date is ${$DATA}"
``` 

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

## 清空文件内容
> 方法1 

```bash
$ > access.log #or
$ true > access.log #or
$ cat /dev/null > access.log # or
$ cp /dev/null  access.log #or
$ echo > access.log
```
> 方法2
```bash
$ truncate -s 0 access.log
```


## source 
当修改 /etc/profile 文件时,立即生效文件
```sh
source filename # 或
. filename
```
source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录