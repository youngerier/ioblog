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


```
