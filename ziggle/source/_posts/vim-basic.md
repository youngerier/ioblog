---
title: vim-basic
date: 2017-12-12 21:59:18
tags:
    -vim 
---
- 全部格式化 
```nil
gg=G
```
- 格式化当前行
```nil
==
```
- 退出vim
```
1 esc
2 shift + zz
```

- 查找
```
/text 向后查
?text 向前查
yy 辅助
p 粘贴
dd 删除当前行
o 另开一行
u 撤销
{                         在第一列插入 { 来定义一个段落
[[                         回到段落的开头处
]]                         向前移到下一个段落的开头处

h <
l >
k ^
j v

d$ 删到最后
r 替换
n next
x 删除当前字符
3x 删除当前光标开始向后3
dh 删除前一个字符
dj 删除上一行
dk 删除下一行
ddp 交换当前行和下一行
ctrl+ ww 切换窗口

```
