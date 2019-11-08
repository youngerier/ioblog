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


### sqlserver 添加执行权限到用户

/* CREATE A NEW ROLE */
CREATE ROLE db_executor

/* GRANT EXECUTE TO THE ROLE */
GRANT EXECUTE TO db_executor



### 修改表结构 / 添加默认值
```sql
update data_terminal set message_center_password = '' where message_center_password is null 

alter table data_terminal
alter column [message_center_password] varchar(255)  not null  


ALTER TABLE data_terminal
ADD CONSTRAINT default_terminal 
DEFAULT '' FOR [message_center_password];
```


###  Deleting all duplicate rows but keeping one

```
WITH cte AS (
  SELECT[foo], [bar], 
     row_number() OVER(PARTITION BY foo, bar ORDER BY baz) AS [rn]
  FROM TABLE
)
DELETE cte WHERE [rn] > 1
```


### 查看sqlserver 索引碎片情况

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
 
### 重置identity种子

```sql
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


<!-- more -->

### 统计数据库表行数

```sql
SELECT t.name, s.row_count from sys.tables t
JOIN sys.dm_db_partition_stats s
ON t.object_id = s.object_id
AND t.type_desc = 'USER_TABLE'
AND t.name not like '%dss%'
AND s.index_id IN (0,1)
order by row_count desc 
```



###  批量插入数据时 获取新主键列表

```sql
CREATE TABLE MyTable
(
    MyPK INT IDENTITY(1,1) NOT NULL,
    MyColumn NVARCHAR(1000)
)

DECLARE @myNewPKTable TABLE (myNewPK INT,myColumn varchar(1111))

INSERT INTO 
    MyTable
(
    MyColumn
)
OUTPUT INSERTED.MyPK ,inserted.MyColumn INTO @myNewPKTable(myNewPK ,myColumn)
SELECT
    sysobjects.name
FROM
    sysobjects

SELECT * FROM @myNewPKTable
```


### 批量插入数据 并获取插入后表数据

```sql
begin transaction;
	-- 新增联系人
	insert wx_contact(
				big_head ,
				*
			)  output inserted.wx_contact_id, inserted.wx_username 
			into @TVP(contactId ,wxusername)
	select t.bighead,*
	 from 
	@TVP t 
	left join wx_contact c on t.wxusername =c.wx_username
	where c.wx_username is null and t.userState = 0
commit;
```


###  sqlserver 监控视图

- dm_db_*：数据库和数据库对象
- dm_exec_*：执行用户代码和关联的连接
- dm_os_*：内存、锁定和时间安排
- dm_tran_*：事务和隔离
- dm_io_*：网络和磁盘的输入/输出

显示缓冲计划所占用的cpu使用率

```sql
SELECT 
      total_cpu_time, 
      total_execution_count,
      number_of_statements,
      s2.text
FROM 
      (SELECT TOP 50 
            SUM(qs.total_worker_time) AS total_cpu_time, 
            SUM(qs.execution_count) AS total_execution_count,
            COUNT(*) AS  number_of_statements, 
            qs.sql_handle --,
            --MIN(statement_start_offset) AS statement_start_offset, 
            --MAX(statement_end_offset) AS statement_end_offset
      FROM 
            sys.dm_exec_query_stats AS qs
      GROUP BY qs.sql_handle
      ORDER BY SUM(qs.total_worker_time) DESC) AS stats
      CROSS APPLY sys.dm_exec_sql_text(stats.sql_handle) AS s2
	  order by total_execution_count desc 
```


### sql join/where 执行顺序

`https://docs.microsoft.com/zh-cn/sql/t-sql/queries/select-transact-sql?view=sql-server-2017`

```sql
1. FROM
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. WITH CUBE or WITH ROLLUP
7. HAVING
8. SELECT
9. DISTINCT
10. ORDER BY
11. TOP
```

### 创建链接服务器

```sql
/* 创建链接服务器 */
exec sp_addlinkedserver 'srv_lnk','','sqloledb','条码数据库IP地址'
exec sp_addlinkedsrvlogin 'srv_lnk','false',null,'用户名','密码'
go

/* 查询示例 */
SELECT A.ListCode
FROM srv_lnk.条码数据库名.dbo.ME_ListCode A, IM_BarLend B
WHERE A.ListCode=B.ListCode
go

/* 删除链接服务器 */
exec sp_dropserver 'srv_lnk','droplogins'

```

#### sys.sysprocesses 说明
```sql
SELECT 
spid, -- sql session id
kpid, -- windows thread id
blocked,  -- 值大于0表示阻塞,  值为本身进程ID表示io操作
loginame,
cmd,       -- 当前正在执行的命令。
open_tran, -- 进程的打开事务数
status,
program_name,
waittime, -- (ms)
db_name(dbid),
uid,
cpu,
physical_io,
memusage,
login_time,
last_batch,
ecid,
hostname,
hostprocess,
lastwaittype,
waitresource,
net_address,
net_library,
stmt_start,
stmt_end,
request_id
FROM sys.sysprocesses WHERE  spid > 50
```

#### sqlserver schema

```sql
-- 完全限定的对象名称现在包含四部分：server.database.schema.object

use test 
go

drop schema myschema
go

create schema myschema
go

alter schema myschema transfer dbo.Mytable

create table myschema.TestTb(
    id bigint not null identity(1,1) ,
    customer_name varchar(255) not null default(''),
    created_time datetime not null default getdate()
)


Select * From master.sys.sysprocesses Where Blocked <> 0

```