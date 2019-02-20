---
title: windows-server
date: 2018-11-02 13:28:14
tags:
---

# windows service


```cmd
sc create consulserver binPath= "D:\consul\consul.exe agent -config-file  D:\consul\conf\consul.json" DisplayName= "Consul Server" start= auto
```

- run with cmd  and administrator


vmware esxi 6 许可证

```
0U0QJ-FR1EP-KZQN9-J1C74-23P5R
```

## powershell 连接远程 windows
```ps1
$uname = "Administrator" #administrator为用户名
$passwd = ConvertTo-SecureString "abcdefg" -AsPlainText -Force; #abcdefg为密码
$cred = New-Object System.Management.Automation.PSCredential($uname, $passwd); #创建自动认证对象
$pcname = "127.0.0.1"

Enter-PSSession -ComputerName $pcname -Credential $cred #登录
```