---
title: sqlserver 配置
date: 2020-01-10 17:53:07
tags:
---

```sql
use master
go
-- 读取配置 
EXEC sp_configure @configname='remote query timeout';
```


```
name    minimum	maximum config_value    run_value
remote query timeout (s)    0   2147483647  600 600
```

```sql
-- 配置
EXEC sp_configure 'remote query timeout', 300 ;  
GO  
RECONFIGURE ;  
```


https://docs.microsoft.com/zh-cn/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-ver15