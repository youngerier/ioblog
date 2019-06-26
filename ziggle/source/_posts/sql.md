---
title: sql
date: 2017-12-23 00:44:02
tags:
    -sql
---

## sql 执行顺序

> from -> where -> group by -> having -> select -> order by
select子句可以识别 别名

- 使用cast函数转换数据类型
```sql
SELECT name + CAST(gender as VARCHAR(10) ) ,age
FROM dbo.student
```

- 使用* 查询结果
```sql
select bookname ,quantity,book_price ,quantity*book_price as total_price
from bookitem
order by bookname
```

- 使用case进行条件查询
```sql
select name,time,redit=
case
    when time>=40 then 5
    when time>=30 then 4
    when time>=20 then 3
    else 2
end
from course
order by redit
```
## sql函数

>字符串运算符

```nil
ASCII,CHAR,LOWER,UPPER,LTRIM,RTRIM,
LEFT,RIGHT,SUBSTRING,CHARINDEX,
REPLICATE,REVERSE,REPLACE
```

- 将结果转成大写
```sql
select upper(bookname) as name ,quantity,book_price
from bookitem
```

- 去空格
```sql
select rtrim(name) + rtrim(dname) as info ,age
from teacher
```

> 算术运算符 ABA,SIGN(调试参数的正负号),CEILING(最大),FLOOR
ROUND(四舍五入),COS,PI,RAND(0-1 之间浮点数)
```sql
select rand()
```

## 时间函数
> DAY,MONTH,YEAR,DATEADD,DATEDIFF,DATENAME,DATEPART,GETDATE
-CONVERT 函数转换日期时间
```sql
CONVERT (data_type [(length), expression,style)

select CONVERT(VARCHAR ,GETDATE(),8) AS now_time
```
<!-- more -->
## 聚合与分组
> SUM,MAX,MIN,AVG(忽略null),COUNT
聚合函数处理的是数据组


- 求和函数
只能对数字列进行求和
```sql
select sum(column_name)
from  table_name
```
- 计数函数
 * count(*) 计算表中行总是，即使为null，也计算在内
 * count(column) 计算column包含的行的数码，不含null行
```sql
select count(*) as totalcount
from table_name
```

- 求均值
```sql
select avg ([all/distinct] column_name)
from table_name
```


```sql
CREATE TABLE [dbo].[Learn_CouponSendJob] (
[Id] bigint NOT NULL  PRIMARY KEY ,
[UserId] bigint NULL ,
[NickName] varchar(255) COLLATE Chinese_PRC_CI_AS NULL ,
[AddTime] datetime2(7) NULL ,
[IsDeleted] bit NULL ,
[SendType] int NULL ,
[SendId] int NULL ,
[CouponId] int NOT NULL ,
[IsNotice] bit NULL 
)
```

union (会把相同记录合并)
去多个select 结果集的合并 union 中select 语句必须有相同数量的列,列的数据类型要相似(可以转换) 每条select 的列的顺序必须相同


```sql
-- 从已有表创建表结构
 select * into b  from person where 1<>1

-- 插入 数据
 insert into b select * from person
```

### mysql 默认事务隔离级别


|事务隔离级别	|脏读	|不可重复读|	幻读||
|------------|------------|------------|------------|------------|
|读未提交（read-uncommitted）|	是|	是|	是|
|不可重复读（read-committed）|	否|	是|	是|SQL server 默认级别|
|可重复读（repeatable-read）|	否|否|	是| mysql 默认级别
|串行化（serializable）|	否|	否	|否|

```cmd
mysql> select @@tx_isolation;
+-----------------+
| @@tx_isolation  |
+-----------------+
| REPEATABLE-READ |
+-----------------+
1 row in set (0.00 sec)

```

 - set session transaction isolation level read committed;

 - start transaction ;
 - commit;


 隔离级别越高，越能保证数据的完整性和一致性，但是对并发性能的影响也越大，鱼和熊掌不可兼得啊。对于多数应用程序，可以优先考虑把数据库系统的隔离级别设为Read Committed，它能够避免脏读取，而且具有较好的并发性能。尽管它会导致不可重复读、幻读这些并发问题，在可能出现这类问题的个别场合，可以由应用程序采用悲观锁或乐观锁来控制。


 ``` sql

CREATE PROCEDURE proc_test(
	@name VARCHAR(12),
	@money int output
)

AS
BEGIN
if(@name = '1')
	set @money=10000
ELSE	
	SET @money=2
END

DECLARE @m INT
PRINT( CAST( ISNULL(@m ,111) as VARCHAR) + ' a')
exec proc_test @name='1' ,@money=@m output
PRINT(CAST(@m as VARCHAR) + ' b')
```

### 获取今天 开始/结束时间
```sql
SELECT
	COUNT (1)
FROM
	learn_cutdownlog WITH (nolock)
WHERE
	iscaptain = 0
AND userid = 307
AND addtime >CONVERT(DATETIME,CONVERT(CHAR(10), DATEADD(DAY,-0,GETDATE()),120) + ' 00:00:00',120)
AND CONVERT(DATETIME,CONVERT(CHAR(10), GETDATE(),120) + ' 23:59:59',120) > addtime


SELECT  CONVERT(DATETIME,CONVERT(CHAR(10), DATEADD(DAY,-0,GETDATE()),120) + ' 00:00:00',120);
SELECT  CONVERT(DATETIME,CONVERT(CHAR(10), GETDATE(),120) + ' 23:59:59',120);
```


### 删除sql server 数据库

```sql
use master
GO
alter database test set single_user with rollback immediate
GO
DROP DATABASE test
GO
```



# csql bulkcopy
```csharp
  static void Main()
        {
         
            string connectionString = GetConnectionString();
            // Open a sourceConnection to the AdventureWorks database.
            using (SqlConnection sourceConnection =
                new SqlConnection(connectionString))
            {
                var sw = new Stopwatch();
                sw.Start();
                sourceConnection.Open();

                // Perform an initial count on the destination table.
                SqlCommand commandRowCount = new SqlCommand($@"SELECT
			                                                    count(1)
		                                                    FROM
			                                                    Learn_User u WITH (NOLOCK)
		                                                    WHERE
			                                                    u.PayCnt = 0", sourceConnection);
                long countStart = System.Convert.ToInt32(
                    commandRowCount.ExecuteScalar());
                Console.WriteLine("Starting row count = {0}", countStart);

                // Get data from the source table as a SqlDataReader.
                SqlCommand commandSourceData = new SqlCommand($@"SELECT
			                                                u.Id AS UserId,
			                                                NickName,
			                                                80 AS SendId,
			                                                3 AS CouponId,
			                                                1 AS IsNotice ,
                                                            GETDATE() AS SendTime,
                                                            1 AS SendStatus ,
			                                                GetDate() AS AddTime,
			                                                0 AS IsDeleted,
			                                                - 1 AS SendToId
		                                                FROM
			                                                Learn_User u WITH (NOLOCK)
		                                                WHERE
			                                                u.PayCnt = 0", sourceConnection);
                SqlDataReader reader =
                    commandSourceData.ExecuteReader();

                // Open the destination connection. In the real world you would 
                // not use SqlBulkCopy to move data from one table to the other 
                // in the same database. This is for demonstration purposes only.
                using (SqlConnection destinationConnection =
                    new SqlConnection(connectionString))
                {
                    destinationConnection.Open();

                    // Set up the bulk copy object. 
                    // Note that the column positions in the source
                    // data reader match the column positions in 
                    // the destination table so there is no need to
                    // map columns.
                    using (SqlBulkCopy bulkCopy =
                        new SqlBulkCopy(destinationConnection))
                    {
                        bulkCopy.DestinationTableName ="dbo.Learn_CouponSendJob";
                        bulkCopy.ColumnMappings.Add(0, 1);
                        bulkCopy.ColumnMappings.Add(1, 2);
                        bulkCopy.ColumnMappings.Add(2, 3);
                        bulkCopy.ColumnMappings.Add(3, 4);
                        bulkCopy.ColumnMappings.Add(4, 5);
                        bulkCopy.ColumnMappings.Add(5, 6);
                        bulkCopy.ColumnMappings.Add(6, 7);
                        bulkCopy.ColumnMappings.Add(7, 8);
                        bulkCopy.ColumnMappings.Add(8, 9);
                        bulkCopy.ColumnMappings.Add(9, 10);
                        bulkCopy.BulkCopyTimeout = 30 * 10;
                        try
                        {
                            // Write from the source to the destination.
                            bulkCopy.WriteToServer(reader);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                        }
                        finally
                        {
                            // Close the SqlDataReader. The SqlBulkCopy
                            // object is automatically closed at the end
                            // of the using block.
                            reader.Close();
                        }
                    }
                    sw.Stop();
                    Console.WriteLine(" elaps :     " + sw.ElapsedMilliseconds/100 + " s");
                    // Perform a final count on the destination 
                    // table to see how many rows were added.
                    long countEnd = System.Convert.ToInt32(
                        commandRowCount.ExecuteScalar());
                    Console.WriteLine("Ending row count = {0}", countEnd);
                    Console.WriteLine("{0} rows were added.", countEnd - countStart);
                    Console.WriteLine("Press Enter to finish.");
                    Console.ReadLine();
                }
            }
        }

        private static string GetConnectionString()
            // To avoid storing the sourceConnection string in your code, 
            // you can retrieve it from a configuration file. 
        {
            return
                $@"Server=d01.xueanquan.cc;Database=LearnOnline;User Id=dev;Password=0F29FF9D-9D91-4420-B2F6-1BFC4B01D6BF;MultipleActiveResultSets=true;";
        }
```



## 如何解决`sqlserver`数据库cpu突然上涨

 - 找到当前数据库正在执行的query
```sql
SELECT sqltext.TEXT,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
order by  req.cpu_time desc 
```
 - 结束正在执行的占用CPU时间长的query

```
kill [session_id]
```



## `sqlserver` 诊断`cpu` 相关sql


```sql
--CPU相关视图  
SELECT * FROM sys.dm_os_sys_info  
SELECT * FROM sys.dm_exec_sessions  
SELECT * FROM sys.sysprocesses  
SELECT * FROM sys.dm_os_tasks  
SELECT * FROM sys.dm_os_workers  
SELECT * FROM sys.dm_os_threads  
SELECT * FROM sys.dm_os_schedulers  
SELECT * FROM sys.dm_os_memory_objects  
SELECT * FROM sys.dm_os_nodes  
SELECT * FROM sys.dm_os_memory_nodes  
  
exec sp_configure 'max degree of parallelism'--系统默认并行度  
exec sp_configure 'cost threshold for parallelism' --并发阈值  
exec sp_configure 'max worker threads'--系统最大工作线程数  
exec sp_configure 'affinity mask' --CPU关联  
  
--数据库系统 cpu，线程 数量  
select max_workers_count,scheduler_count,cpu_count,hyperthread_ratio  
,(hyperthread_ratio/cpu_count) AS physical_cpu_count  
,(max_workers_count/scheduler_count) AS workers_per_scheduler_limit  
from sys.dm_os_sys_info  
  
  
--执行的线程所遇到的所有等待的相关信息  
SELECT TOP 10 wait_type,waiting_tasks_count,signal_wait_time_ms   
FROM sys.dm_os_wait_stats ORDER BY signal_wait_time_ms DESC  
  
--正在等待某些资源的任务的等待队列的信息  
SELECT TOP 10 wait_type,wait_duration_ms,session_id,blocking_session_id   
FROM sys.dm_os_waiting_tasks ORDER BY wait_duration_ms DESC  
  
  
--CPU或调度器当前分配的工作情况  
SELECT scheduler_id,cpu_id,status,is_idle  
,current_tasks_count AS 当前任务数           --在等待或运行的任务  
,runnable_tasks_count AS 等待调度线程数        --已分配任务并且正在可运行队列中  
,current_workers_count AS 当前线程数     --相关或未分配任何任务的工作线程  
,active_workers_count AS 活动线程数          --在运行、可运行或挂起  
,work_queue_count AS 挂起任务数              --等待工作线程执行  
FROM sys.dm_os_schedulers  
WHERE scheduler_id < 255  
  
  
--当前线程数  
select COUNT(*) as 当前线程数 from sys.dm_os_workers  
  
--非SQL server create的threads  
select * from sys.dm_os_threads where started_by_sqlservr=0 --即scheduler_id > 255  
  
--有task 等待worker去执行  
select * from sys.dm_os_tasks where task_state='PENDING'  
  
--计数器  
select * from  sys.dm_os_performance_counters where object_name='SQLServer:SQL Statistics'  
select * from  sys.dm_os_performance_counters where object_name='SQLServer:Plan Cache'  
  
  
  
-----------------------------------------------------------------------------  
-----------------------------------------------------------------------------  
  
--1. 实例累积的信号（线程/CPU）等待比例是否严重  
SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2))  AS [%signal (cpu) waits],    
CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS  NUMERIC(20,2)) AS [%resource waits]    
FROM sys.dm_os_wait_stats WITH (NOLOCK) OPTION (RECOMPILE);   
  
  
--2. SqlServer各等待类型的线程等待信息  
SELECT TOP 20   
wait_type,waiting_tasks_count ,wait_time_ms,signal_wait_time_ms   
,wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms   
,CONVERT(NUMERIC(14,2),100.0 * wait_time_ms /SUM (wait_time_ms ) OVER( )) AS percent_total_waits   
,CONVERT(NUMERIC(14,2),100.0 * signal_wait_time_ms /SUM (signal_wait_time_ms) OVER( )) AS percent_total_signal_waits   
,CONVERT(NUMERIC(14,2),100.0 * ( wait_time_ms - signal_wait_time_ms )/SUM (wait_time_ms ) OVER( )) AS percent_total_resource_waits   
FROM sys .dm_os_wait_stats  
WHERE wait_time_ms > 0  
ORDER BY percent_total_signal_waits DESC  
  
  
--3. 闩锁(latch)等待的信息  
select top 20 latch_class,waiting_requests_count,wait_time_ms,max_wait_time_ms  
from sys.dm_os_latch_stats  
order by wait_time_ms desc  
  
  
--使用最多处理器时间的用户数据库  
;WITH DB_CPU_Stats AS  (  
    SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName],    
    SUM(total_worker_time) AS [CPU_Time_Ms]    
    FROM sys.dm_exec_query_stats AS qs    
    CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID]    
    FROM sys.dm_exec_plan_attributes(qs.plan_handle)    
    WHERE attribute = N'dbid') AS F_DB    
    GROUP BY DatabaseID)    
SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num], DatabaseName  
, [CPU_Time_Ms], CAST([CPU_Time_Ms] * 1.0   
    / SUM([CPU_Time_Ms])OVER() * 100.0 AS DECIMAL(5,2)) AS [CPUPercent]    
FROM DB_CPU_Stats    
WHERE DatabaseID > 4 -- system databases    
AND DatabaseID <> 32767 -- ResourceDB    
ORDER BY row_num OPTION (RECOMPILE);  
  
  
--缓存中最耗CPU的语句  
select total_cpu_time,total_execution_count,number_of_statements,[text]   
from (  
    select top 20    
    sum(qs.total_worker_time) as total_cpu_time,    
    sum(qs.execution_count) as total_execution_count,   
    count(*) as  number_of_statements,    
    qs.plan_handle    
    from sys.dm_exec_query_stats qs   
    group by qs.plan_handle   
    order by total_cpu_time desc  
) eqs cross apply sys.dm_exec_sql_text(eqs.plan_handle) as est  
order by total_cpu_time desc  
  
  
  
  
  
/*【ask 让出scheduler ：worker yielding】  
1. worker读数据页超过4ms  
2. 64k结果集排序  
3. compile或recompile（常有）  
4. 客户端不能及时取走结果集  
5. batch 的每个操作完整  
*/  
  
  
--当前正在执行的语句  
SELECT   
der.[session_id],der.[blocking_session_id],  
sp.lastwaittype,sp.hostname,sp.program_name,sp.loginame,  
der.[start_time] AS '开始时间',  
der.[status] AS '状态',  
der.[command] AS '命令',  
dest.[text] AS 'sql语句',   
DB_NAME(der.[database_id]) AS '数据库名',  
der.[wait_type] AS '等待资源类型',  
der.[wait_time] AS '等待时间',  
der.[wait_resource] AS '等待的资源',  
der.[reads] AS '物理读次数',  
der.[writes] AS '写次数',  
der.[logical_reads] AS '逻辑读次数',  
der.[row_count] AS '返回结果行数'  
FROM sys.[dm_exec_requests] AS der   
INNER JOIN master.dbo.sysprocesses AS sp on der.session_id=sp.spid  
CROSS APPLY  sys.[dm_exec_sql_text](der.[sql_handle]) AS dest   
WHERE [session_id]>50 AND session_id<>@@SPID AND DB_NAME(der.[database_id])='platform'    
ORDER BY [cpu_time] DESC  
  
  
  
--实例级最大的瓶颈  
WITH Waits AS   
(   
    SELECT wait_type , wait_time_ms / 1000. AS wait_time_s , 100.* wait_time_ms / SUM(wait_time_ms) OVER ( ) AS pct ,  
    ROW_NUMBER() OVER ( ORDER BY wait_time_ms DESC ) AS rn   
    FROM sys.dm_os_wait_stats   
    WHERE   
    wait_type NOT IN ( 'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',   
    'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT',  
    'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN' )   
)  
SELECT W1.wait_type , CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s ,   
CAST(W1.pct AS DECIMAL(12, 2)) AS pct ,CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct   
FROM Waits AS W1   
INNER JOIN Waits AS W2 ON W2.rn <= W1.rn   
GROUP BY W1.rn , W1.wait_type , W1.wait_time_s , W1.pct   
HAVING SUM(W2.pct) - W1.pct < 95 ; -- percentage threshold
```


### 
```sql
---SQL 3:获取数据库服务器CPU核数(适用于所有版本)

CREATE TABLE #TempTable
  (
   [Index] VARCHAR(2000) ,
   [Name] VARCHAR(2000) ,
   [Internal_Value] VARCHAR(2000) ,
   [Character_Value] VARCHAR(2000)
  );
INSERT INTO #TempTable
    EXEC xp_msver;
SELECT Internal_Value AS VirtualCPUCount
FROM  #TempTable
WHERE  Name = 'ProcessorCount';
DROP TABLE #TempTable;
GO
```

### 获取数据库服务器磁盘详情

```sql

DECLARE @Result   INT;
DECLARE @objectInfo   INT;
DECLARE @DriveInfo   CHAR(1);
DECLARE @TotalSize   VARCHAR(20);
DECLARE @OutDrive   INT;
DECLARE @UnitMB   BIGINT;
DECLARE @FreeRat   FLOAT;
SET @UnitMB = 1048576;
--创建临时表保存服务器磁盘容量信息
CREATE TABLE #DiskCapacity
(
[DiskCD]   CHAR(1) ,
FreeSize   INT   ,
TotalSize   INT  
);
INSERT #DiskCapacity([DiskCD], FreeSize ) 
EXEC master.dbo.xp_fixeddrives;
EXEC sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE;
EXEC sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE WITH OVERRIDE;
EXEC @Result = master.sys.sp_OACreate 'scripting.FileSystemObject',@objectInfo OUT;
DECLARE CR_DiskInfo CURSOR LOCAL FAST_FORWARD
FOR 
SELECT DiskCD FROM #DiskCapacity
ORDER by DiskCD
OPEN CR_DiskInfo;
FETCH NEXT FROM CR_DiskInfo INTO @DriveInfo
WHILE @@FETCH_STATUS=0
BEGIN
EXEC @Result = sp_OAMethod @objectInfo,'GetDrive', @OutDrive OUT, @DriveInfo
EXEC @Result = sp_OAGetProperty @OutDrive,'TotalSize', @TotalSize OUT
UPDATE #DiskCapacity
SET TotalSize=@TotalSize/@UnitMB
WHERE DiskCD=@DriveInfo
FETCH NEXT FROM CR_DiskInfo INTO @DriveInfo
END
CLOSE CR_DiskInfo
DEALLOCATE CR_DiskInfo;
EXEC @Result=sp_OADestroy @objectInfo
EXEC sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE;
EXEC sp_configure 'Ole Automation Procedures', 0;
RECONFIGURE WITH OVERRIDE;
EXEC sp_configure 'show advanced options', 0
RECONFIGURE WITH OVERRIDE;
SELECT DiskCD   AS [Drive CD]   , 
  STR(TotalSize*1.0/1024,6,2)   AS [Total Size(GB)] ,
  STR((TotalSize - FreeSize)*1.0/1024,6,2)   AS [Used Space(GB)] ,
  STR(FreeSize*1.0/1024,6,2)   AS [Free Space(GB)] ,
  STR(( TotalSize - FreeSize)*1.0/(TotalSize)* 100.0,6,2) AS [Used Rate(%)]  ,
  STR(( FreeSize * 1.0/ ( TotalSize ) ) * 100.0,6,2)    AS [Free Rate(%)]
FROM #DiskCapacity;
DROP TABLE #DiskCapacity;
```

### 常用sys_procedure


{% asset_img sys_proc.png sys_proc %} 


### sp_who (需要 View server status ) 
-  结束正在指定语句
sp_who 'active'
kill {SPID value}

### 常见问题的解法

```
https://docs.microsoft.com/zh-cn/sql/relational-databases/system-catalog-views/querying-the-sql-server-system-catalog-faq?view=sql-server-2017#_FAQ6
```


## 重命名表属性

```sql
EXEC sp_rename 'Sales.SalesTerritory.TerritoryID', 'TerrID', 'COLUMN'; 
-- EXEC sp_rename 'table.column', 'expect column name', 'COLUMN'; 
```



## grant 存储过程权限

```sql
GRANT EXECUTE ON dbo.procname TO username;
select 'GRANT EXECUTE ON '+name+' TO wangping;' from sys.procedures
```