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


### bash中数学运算
使用 awk ,expr
expr是表达式计算工具
```bash
#!/bin/bash
val=`expr 2 + 2`
echo " value : $val "

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

### 关系运算符

|运算符| 说明|举例|
|:------|:------|:------:|
|-eq|检测两个数是否相当，相等返回true|[ $a -eq $b ] 返回 false|
|-ne|检测两个数是否相当，不相等返回true|[ $a -ne $b ] 返回 true|
|-gt|检测左边是否大于右边，是返回true|[ $a -eq $b ] 返回 false|
|-lt|检测左边是否小于右边，是返回true|[ $a -eq $b ] 返回 true|
|-ge|检测左边的数是否大于等于右边，是返回true|[ $a -eq $b ] 返回 false|
|-le|检测左边的数是否小于等于右边，如果是返回true|[ $a -le $b ] 返回 true|