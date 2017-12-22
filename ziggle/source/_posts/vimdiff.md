---
title: vimdiff
date: 2017-12-22 13:37:58
tags:
    -vim
---
## git 全局配置位置
{% asset_img gitconfig_location.png gitconfig_location%}

## 配置git diff 工具

> git config --global merge.tool

## 使用vim diff
> git mergetool

|位置|含义|代指|
|------------|------------|------------|
|↖| local 文件|LOCAL / LO|
|↑| base  基部文件||
|↗|remote   远程文件|REMOTE /RE|
|↓|显示merge的内容||


## 命令
```
[c  :转到上一个冲突
]a  :转到下一个冲突
:-qa :全部退出vim

:diffget LOCAL   接受本地修改
:diffget REMOTE  接受远程修改

```
- 使用:buffes 确定4个窗口编号
