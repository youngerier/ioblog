---
title: linux-shell
date: 2019-07-03 16:16:56
tags:
---



### 更改字段分隔符
造成这个问题的原因是特殊的环境变量`IFS`，叫作内部字段分隔符（internal field separator）。
IFS环境变量定义了bash shell用作字段分隔符的一系列字符。默认情况下，bash shell会将下列字
符当作字段分隔符：
- 空格
- 制表符
- 换行符


```
IFS.OLD=$IFS 
 IFS=$'\n' 
 <在代码中使用新的IFS值> 
 IFS=$IFS.OLD
```

####  

```
trap "echo 'Sorry ! I have trapped Ctrl-C ' " SIGINT
```