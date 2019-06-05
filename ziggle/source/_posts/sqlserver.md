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


## 查看sqlserver 索引碎片情况

```sql
SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent ,
'alter index  ' + ind.name + ' on ' + OBJECT_NAME(ind.OBJECT_ID)+ ' rebuild' as sql
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
ON ind.object_id = indexstats.object_id 
AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 50 
ORDER BY indexstats.avg_fragmentation_in_percent DESC
```

### 重建索引的方法3
```sql
ALTER INDEX [idx_name] ON [dbo].[table_name] REBUILD 
```

### dbcc
DBCC(`database console commands`)
如果表的当前标识值小于列中存储的最大标识值，则使用标识列中的最大值对其进行重置。
```sql
DBCC CHECKIDENT('[dbo].[data_module]', NORESEED)
```
 
重置identity种子

```tsql
create table #table_temp (item varchar(111))
insert into #table_temp (item)
select name from sysobjects  where type = 'u'
declare @count int 
select @count= count(1) from #table_temp
declare @i varchar(111)
while @count>0
begin  
	select @count= count(1) from #table_temp
	select top(1)@i= item from #table_temp
	DBCC CHECKIDENT( @i, RESEED) 
  -- DBCC CHECKIDENT ( table_name, RESEED, new_reseed_value )
  -- DBCC CHECKIDENT ( table_name, RESEED )
  -- DBCC CHECKIDENT ( table_name, NORESEED)

	delete from #table_temp where item = @i
end

```