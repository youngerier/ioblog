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
