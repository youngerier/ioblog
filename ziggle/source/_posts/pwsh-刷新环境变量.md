---
title: pwsh-刷新环境变量
date: 2020-12-11 09:30:00
tags:
---

#### 刷新环境变量

`code $profile`

```
function RefreshEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    Write-host('RefreshEnv')
}```