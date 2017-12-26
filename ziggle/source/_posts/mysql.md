---
title: mysql
date: 2017-12-25 23:45:14
tags:
    -mysql
---

## 修改表
```sql
create table emp(
    name varchar(10),
    hiredate date,
    sal decimal(10,2),
    deptno int(2)
)

desc emp

alter table emp add column age int(3);

alter table emp drop column age;

alter table emp change age age1 int(4)

alter table emp modify age int(8);

alter table emp rename empp;


--dml

insert into emp(name,hiredate,sal,deptno)values ('ziggle','2000-01-01','100',2);


insert into emp (name ,sal) values('foo',99);

update emp set sal=199 where name='ziggle';

delete from emp where name ='ziggle'

select count(1) from emp

-- 统计各部门的人士
select deptno,count(1) from emp group by deptno;
-- 统计各部门的人数，统计总人数
select deptno ,count(1) from emp group by deptno with roll up;

-- 统计人数大于1的部门 
select deptno,count(1) from emp group by deptno having count(1) >1

select sum(sal) ,max(sal),man(sal) from emp;


create table dept (
    deptno int(10),
    deptname varchar(50)
)

select name ,deptname from emp ,dept where emp.deptno = dep.deptno

-- 左连接 ：包含所有左边的记录甚至是右边表中没有和它匹配的几率
-- 右连接
select name ,deptname from dept right join emp on dept.deptno=emp.deptno


--子查询当我们查询的时候，需要的条件是另外一个 select 语句的结果，这个时候，就要用到子查询。用于子查询的关键字主要包括 in、not in、=、!=、exists、not exists 等
 
select * from emp where deptno in (select deptno from dept)


select * from emp where deptno = (select deptno from dept limit 1)

-- 把子查询转为表连接

select * from emp where deptno in (select deptno from dept)

select emp.* from emp,dept where emp.deptnp =dept.deptno



select * from dept
union all
select * from emp
--去重

select * from dept
union
select * from emp

```
