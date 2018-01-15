---
title: dotnetcore
date: 2018-01-02 13:05:22
tags:
    - dotnetcore
---


## dotent  Deployment


### self-contained deployment (SCD) 
* 生成是带有运行时
 dotnet publish -c Release --self-contained -r linux-x64
* 宿主带有运行时
 dotnet publish -c Release 