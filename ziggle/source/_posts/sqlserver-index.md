---
title: sqlserver-index
date: 2019-10-30 18:05:06
tags:
---



#### 获取数据库表所占空间大小(包含索引)

```sql
-- Get Sizes of All Tables and Indexes in a Database Size of each Table (Including Indexes) 
SELECT
    t.[Name] AS TableName,
    p.[rows] AS [RowCount],
    SUM(a.total_pages) * 8 AS TotalSpaceKB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0 AND i.OBJECT_ID > 255
GROUP BY t.[Name], p.[Rows]
ORDER BY  UsedSpaceKB desc 
```


#### 获取数据库索引所占空间大小
- 方法1
```sql
--Size of each Index 
SELECT
    i.[name] AS IndexName,
    t.[name] AS TableName,
    SUM(s.[used_page_count]) * 8 AS IndexSizeKB
FROM sys.dm_db_partition_stats AS s
INNER JOIN sys.indexes AS i ON s.[object_id] = i.[object_id] 
    AND s.[index_id] = i.[index_id]
INNER JOIN sys.tables t ON t.OBJECT_ID = i.object_id
GROUP BY i.[name], t.[name]
ORDER BY IndexSizeKB desc , i.[name], t.[name]
```

- 方法2
```sql
SELECT
OBJECT_SCHEMA_NAME(i.OBJECT_ID) AS SchemaName,
OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
8 * SUM(a.used_pages) AS 'Indexsize(KB)'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
GROUP BY i.OBJECT_ID,i.index_id,i.name
ORDER BY OBJECT_NAME(i.OBJECT_ID),i.index_id
```

#### 索引碎片检查

- 查找 `AdventureWorks2016` 数据库中 `HumanResources.Employee` 表内所有索引的平均碎片百分比
```sql
SELECT a.object_id, object_name(a.object_id) AS TableName,
      a.index_id, name AS IndedxName, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats
    (DB_ID (N'AdventureWorks2016_EXT')
        , OBJECT_ID(N'HumanResources.Employee')
        , NULL
        , NULL
        , NULL) AS a
INNER JOIN sys.indexes AS b
    ON a.object_id = b.object_id
    AND a.index_id = b.index_id;
GO
```
### 未使用的索引

```sql
SELECT TOP 25
o.name AS ObjectName
, i.name AS IndexName
, i.index_id AS IndexID
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(s.name) + '.'
+ QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id 
AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = 'nonclustered'
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
GO
```
### 索引空间占用
```sql
SELECT COUNT (1) * 8 / 1024 AS MBUsed, 
    OBJECT_SCHEMA_NAME(object_id) SchemaName, 
    name AS TableName, index_id   
FROM sys.dm_os_buffer_descriptors AS bd   
    INNER JOIN  
    (  
        SELECT object_name(object_id) AS name  
            ,index_id ,allocation_unit_id, object_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.hobt_id   
                    AND (au.type = 1 OR au.type = 3)  
        UNION ALL 
        SELECT object_name(object_id) AS name    
            ,index_id, allocation_unit_id, object_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.partition_id   
                    AND au.type = 2  
    ) AS obj   
        ON bd.allocation_unit_id = obj.allocation_unit_id  
WHERE database_id = DB_ID()  
GROUP BY OBJECT_SCHEMA_NAME(object_id), name, index_id   
ORDER BY COUNT (*) * 8 / 1024 DESC
GO
```
### 列出所有会话

exec sp_who

### 执行时间长最消耗资源session
```sql
SELECT TOP(50) qs.execution_count AS [Execution Count],
(qs.total_logical_reads)*8/1024.0 AS [Total Logical Reads (MB)],
(qs.total_logical_reads/qs.execution_count)*8/1024.0 AS [Avg Logical Reads (MB)],
(qs.total_worker_time)/1000.0 AS [Total Worker Time (ms)],
(qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time (ms)],
(qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time (ms)],
(qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time (ms)],
qs.creation_time AS [Creation Time]
,t.text AS [Complete Query Text], qp.query_plan AS [Query Plan]
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE t.dbid = DB_ID()
ORDER BY qs.execution_count DESC OPTION (RECOMPILE);-- frequently ran query
-- ORDER BY [Total Logical Reads (MB)] DESC OPTION (RECOMPILE);-- High Disk Reading query
-- ORDER BY [Avg Worker Time (ms)] DESC OPTION (RECOMPILE);-- High CPU query
-- ORDER BY [Avg Elapsed Time (ms)] DESC OPTION (RECOMPILE);-- Long Running query
```

### 加速索引重建
- 使用 `SORT_IN_TEMPDB` 加速重建索引,tempdb 与userdatabase 不在相同磁盘上有效
```sql
ALTER INDEX [NameOfTheIndex] ON [SchemaName].[TableName]
REBUILD PARTITION = ALL WITH (SORT_IN_TEMPDB = ON)
GO
```

### 优化索引方向
`谓词 == 筛选条件`

SQL Server 查询优化器是基于成本的查询优化器。 也就是说，它选择估计处理成本最低的查询计划。 查询优化器基于以下两个主要因素来确定执行查询计划的开销：
- 查询计划每个级别上处理的总行数，称为该计划的基数。
- 由查询中所使用的运算符规定的算法的开销模式。


第一个因素（基数）用作第二个因素（开销模式）的输入参数。 因此，增大基数将减少估计开销，从而加快执行计划。
SQL Server 中的基数估计 (CE)主 要派生自创建索引或统计信息时所创建的直方图（以手动或自动方式）。 有时，SQL Server 还使用查询的约束信息和逻辑重写来确定基数。
在下列情况下，SQL Server 无法精确计算基数。 这会导致成本计算不准确，进而可能导致查询计划欠佳。 避免在查询中使用这些构造可以提高查询性能。 有时，使用查询表达式或其他措施也可以提高查询性能，如下所述：
- 带谓词的查询，这些查询在同一表的不同列之间使用比较运算符。
- 带谓词的查询，这些查询使用运算符且下列任何一种情况为 True：
- 运算符两侧所涉及的列中没有统计信息。
- 统计信息中值的分布不均匀，但查询将查找高选择性的值集。 特别是，当运算符是除相等 (=) 运算符以外的任何其他运算符时，这种情况可能为 True。
- 谓词使用不等于 (!=) 比较运算符或 NOT 逻辑运算符。
- 使用任意 SQL Server 内置函数或标量值用户定义函数（其参数不是常量值）的查询。
- 包含通过算术或字符串串联运算符联接的列的查询。
- 比较在编译或优化查询时其值未知的变量的查询。