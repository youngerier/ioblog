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