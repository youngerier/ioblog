---
title: bash
date: 2018-02-07 22:35:56
tags:
    -bash 
---

### bash 脚本 end of line sequence
在windows 中 要把bash脚本换行格式调账为 CRLF -> LF


### bash 变量类别

- 局部变量
    - 只在当前shell实例中有效，其他shell启动不能访问局部变量
- 环境变量
    - 所有的程序包括shell启动的程序都可以访问环境变量，shell也可以定义环境变量
- shell变量

### 单引号的限制
- 单引号的任何字符都会原样输出，单引号总的变量都是无效的
- 单引号中不能出现单引号，即使使用转义符

### 双引号的优点
- 双引号中可以有变量
- 双引号中可以出现转移字符

拼接字符串
```bash
name="ziggle"
greeting="hello ,"$name" ! "
greetin="hello , ${name} ! "

# 提取字符串长度
string="abcd"
echo ${#string} #输出 4

```
### bash 只支持一维数组
- 声明
``` bash
arr_name=(value0 value1 value2) # 或者 
arr_name=(
    value1
    value2
)
```
- 读取数组
${数组名[下标]}
value=${arr_name[n]}

```bash
#!/bin/bash
my_arr=(A B C "D")
echo "first ele ${my_arr[0]}"

```

### 传递参数

在执行脚本时，向脚本传递参数，脚本内获取参数的格式为:$n

> n 代表一个数字， 1 为执行脚本时传递的第一个参数 ...

|参数处理| 说明|
|:------|:------:|
|$#| 传递到脚本的参数个数|
|$*| 以一个但字符串显示所有向脚本传递的参数|
|$$| 脚本运行的当前进程ID号|
|$!| 后台运行的最后一个进程ID号|
|$@| 与$*相同，但是使用时加引号，并在引号中返回每个参数|
|$-| 显示shell使用的当前选项，与set 命令功能相同|
|$?| 显示最后命令的退出状态，0表示没错，其他值有错|
|$USER|运行脚本用户的用户名|
|$HOSTNAME|hostname|
|$SECONDS|脚本运行since开始 的时间长|
|$LINENO|当前脚本行号|


### bash中数学运算
使用 awk ,expr
expr是表达式计算工具
```bash
#!/bin/bash
val=`expr 2 + 2`
echo " value : $val "
```
> bash 使用let进行简单算术运算
```bash
#!/bin/bash
let a=5+4
echo $a #9

let "a = 5 + 4"
echo $a #9

let a++
echo $a #10

let "a = 4 * 5"
echo $a # 20
```
>使用双括号计算
```bash
#!/bin/bash
a=$(( 4 + 5 ))
echo $a #9

```
<!-- more -->
> 计算变量长度
```bash
#!/bin/bash

a='hello world'
echo ${#a} #11

b=1234
echo ${#b} #4
```
## bash 表达式
* 条件表达式要放在方括号中，并且要有空格，
> [ a==b ] 

```bash
#!/bin/bash
a=12
b=23
val=`expr $a + $b`

if [ $a == $b ]
then
    echo "a equals b"
fi
```
### if 测试
|操作符|说明|
|:------|:------|:------:|
|! expression| 表达式 is false|
|-n string| 字符串长度大于0|
|-z string| 字符串长度等于0|
|string1 = string2| 字符串相等|
|string1 != string2| 字符串不乡等|
|-d file| directory 存在且为文件夹|
|-e file|文件存在|
|-r file|文件存在且有读权限|
|-w file|文件存在且有写权限|
|-x file|文件存在且有执行权限|
|-s file|文件存在且文件大小大于0|

### 关系运算符

|运算符| 说明|举例|
|:------|:------|:------:|
|-eq|检测两个数是否相当，相等返回true|[ $a -eq $b ] 返回 false|
|-ne|检测两个数是否相当，不相等返回true|[ $a -ne $b ] 返回 true|
|-gt|检测左边是否大于右边，是返回true|[ $a -eq $b ] 返回 false|
|-lt|检测左边是否小于右边，是返回true|[ $a -eq $b ] 返回 true|
|-ge|检测左边的数是否大于等于右边，是返回true|[ $a -eq $b ] 返回 false|
|-le|检测左边的数是否小于等于右边，如果是返回true|[ $a -le $b ] 返回 true|


##### 例子
```bash
#!/bin/bash
# 文件可读 而且大于0
if [ -r $1 ] && [ -s $1 ]
then
    echo this file is useful
fi

# 
if [ $USER == 'nginx' ] || [ $USER == 'root' ]
then 
    ls -alh
else
    ls
fi
```

> case 语句
```bash
#!/bin/bash

case $1 in
    start)
        echo starting
        ;;
    stop)
        echo stoping
        ;;
    restart)
        echo restarting
        ;;
    *)
        echo dont\'t know
        ;;
esac

```
<!-- more -->

### loop 语句

* 
```bash
#!/bin/sh

counter=1
while [ $counter -le 10 ]
do
    echo $counter
    ((counter++))
done

echo all done

# Basic until loop
counter=1
until [ $counter -gt 10 ]
do
echo $counter
((counter++))
done
echo All done

# Basic for loop
names='Stan Kyle Cartman'
for name in $names
do
echo $name
done
echo All done
```
Range
```bash
# Basic range in for loop
for value in {1..5}
do
echo $value
done
echo All done

# Basic range with steps for loop
for value in {10..0..2}
do
echo $value
done
echo All done


# Make a backup set of files
for value in $1/*
do
used=$( df $1 | tail -1 | awk '{ print $5 }' | sed 's/%//' )
if [ $used -gt 90 ]
then
echo Low disk space 1>&2
break
fi
cp $value $1/backup/
done


# Make a backup set of files
for value in $1/*
do
if [ ! -r $value ]
then
echo $value not readable 1>&2
continue
fi
cp $value $1/backup/
done
```


### function

```bash
print_something(){
    echo hail hydra
}

print_something


# Passing argumentt to a func

print_something(){
    echo hail $1
}
print_something hydra
```

> 变量作用范围
```sh
#!/bin/sh
var_change(){
    
}
```

