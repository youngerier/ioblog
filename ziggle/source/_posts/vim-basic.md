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
dw 删除当前光标下的单词/空格
dG 删除至文件尾
ddp 交换当前行和下一行
ctrl+ ww 切换窗口

guu 当前行转小写
gUU 当前行转大写
```
-- 替换

```
:%s/YouMeek/Judasn/g，把文件中所有 YouMeek 替换为：Judasn
:%s/YouMeek/Judasn/，把文件中所有行中第一个 YouMeek 替换为：Judasn
:s/YouMeek/Judasn/，把光标当前行第一个 YouMeek 替换为 Judasn
:s/YouMeek/Judasn/g，把光标当前行所有 YouMeek 替换为 Judasn
:s#YouMeek/#Judasn/#，除了使用斜杠作为分隔符之外，还可以使用 # 作为分隔符，此时中间出现的 / 不会作为分隔符，该命令表示：把光标当前行第一个 YouMeek/ 替换为 Judasn/
:10,31s/YouMeek/Judasn/g，把第 10 行到 31 行之间所有 YouMeek 替换为 Judasn
```

#### vim注释多行
```
1. 首先按esc进入命令行模式下，按下Ctrl + v，进入列（也叫区块）模式;
2. 在行首使用上下键选择需要注释的多行;
3. 按下键盘（大写）“I”键，进入插入模式；
4. 然后输入注释符（“//”、“#”等）;
5. 最后按下“Esc”键。
```