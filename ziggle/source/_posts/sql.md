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

>字符串运算符 ASCII,CHAR,LOWER,UPPER,LTRIM,RTRIM,LEFT,RIGHT,SUBSTRING,CHARINDEX,REPLICATE,REVERSE,REPLACE

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