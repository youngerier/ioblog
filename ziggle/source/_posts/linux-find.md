---
title: linux-find
date: 2018-05-29 00:42:39
tags:
    - linux
---


### 
```sh
# find path -option [ -print] [ -exec -ok  command] {} 

root@ziggle:~$ find / -name *.conf -type f -print
```
> 参数说明
参数说明 :

find 根据下列规则判断 path 和 expression，在命令列上第一个 - ( ) , ! 之前的部份为 path，之后的是 expression。如果 path 是空字串则使用目前路径，如果 expression 是空字串则使用 -print 为预设 expression。

expression 中可使用的选项有二三十个之多，在此只介绍最常用的部份。

-mount, -xdev : 只检查和指定目录在同一个文件系统下的文件，避免列出其它文件系统中的文件

-amin n : 在过去 n 分钟内被读取过

-anewer file : 比文件 file 更晚被读取过的文件

-atime n : 在过去 n 天过读取过的文件

-cmin n : 在过去 n 分钟内被修改过

-cnewer file :比文件 file 更新的文件

-ctime n : 在过去 n 天过修改过的文件

-empty : 空的文件-gid n or -group name : gid 是 n 或是 group 名称是 name

-ipath p, -path p : 路径名称符合 p 的文件，ipath 会忽略大小写

-name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写

-size n : 文件大小 是 n 单位，b 代表 512 位元组的区块，c 表示字元数，k 表示 kilo bytes，w 是二个位元组。-type c : 文件类型是 c 的文件。

d: 目录

c: 字型装置文件

b: 区块装置文件

p: 具名贮列

f: 一般文件

l: 符号连结

s: socket

-pid n : process id 是 n 的文件

你可以使用 ( ) 将运算式分隔，并使用下列运算。

exp1 -and exp2

! expr

-not expr

exp1 -or exp2

exp1, exp2
-----
-print :将查找到的文件输出到标准输出
-exec command {} \; -- 将查到的文件执行command操作,{} 和 \;之间有空格
-ok 和-exec相同，只不过在操作前要询用户
> 实例

- 找到当前目录下及子目录拓展名为 *c* 的文件
```
find . -name "*.c"
```
- 目录里找类型
```
find . -type f
```
- 目录找最近天数修改的文件
```
find . -ctime -20
```

- 查找前目录中文件属主具有读、写权限，并且文件所属组的用户和其他用户具有读权限的文件：
```
 find . -type f -perm 644 -exec ls -l {} \;
```