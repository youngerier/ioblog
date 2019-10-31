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