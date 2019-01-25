---
title: sqlserver
date: 2018-12-14 11:01:59
tags:
---



### coursor 使用
```sql

PRINT OBJECT_ID('[dbo].[PROC_checkPlan]');

DECLARE @name VARCHAR(50) -- database name 
DECLARE @path VARCHAR(256) -- path for backup files 
DECLARE @fileName VARCHAR(256) -- filename for backup 
DECLARE @fileDate VARCHAR(20) -- used for file name 

SET @path = 'C:\sqlbackup\' 

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb','backup') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      SET @fileName = @path + @name + '_' + @fileDate + '.BAK' 
      BACKUP DATABASE @name TO DISK = @fileName 

      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor
```


## sqlserver 添加执行权限到用户

/* CREATE A NEW ROLE */
CREATE ROLE db_executor

/* GRANT EXECUTE TO THE ROLE */
GRANT EXECUTE TO db_executor



## 修改表结构 / 添加默认值
```sql
update data_terminal set message_center_password = '' where message_center_password is null 

alter table data_terminal
alter column [message_center_password] varchar(255)  not null  


ALTER TABLE data_terminal
ADD CONSTRAINT default_terminal 
DEFAULT '' FOR [message_center_password];
```


##  Deleting all duplicate rows but keeping one

```
WITH cte AS (
  SELECT[foo], [bar], 
     row_number() OVER(PARTITION BY foo, bar ORDER BY baz) AS [rn]
  FROM TABLE
)
DELETE cte WHERE [rn] > 1
```
