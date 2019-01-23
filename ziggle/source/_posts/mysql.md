---
title: mysql
date: 2017-12-25 23:45:14
tags:
    -mysql
---

## 开启远程连接(raspberry pi ,ubuntu )
- 第一步
```bash 
root@rasp:~# vim /etc/mysql/mariadb.conf.d/50-server.cnf
# bind-address = 127.0.0.1
```
- 第二步
进入MySQL 
```sql
grant all privileges on *.* to root@"%" identified by "password" with grant option;
flush privileges;
```
>第一行命令解释如下，.：第一个代表数据库名；第二个代表表名。这里的意思是所有数据库里的所有表都授权给用户。root：授予root账号。“%”：表示授权的用户IP可以指定，这里代表任意的IP地址都能访问MySQL数据库。“password”：分配账号对应的密码，这里密码自己替换成你的mysql root帐号密码。
第二行命令是刷新权限信息，也即是让我们所作的设置马上生效。

## 完全卸载mysql(Ver 15.1 Distrib 10.1.23-MariaDB)

```sh
sudo apt purge mysql-*
sudo rm -rf /etc/mysql/ /var/lib/mysql
sudo apt autoremove
sudo apt autoclean
```
## 修改表
```sql
create table if not exists emp(
    name varchar(10),
    hiredate date,
    sal decimal(10,2),
    deptno int(2),
    primary key(name)
)
# 创建简单索引
create  INDEX  index_name on table_name (column_name)

# 创建唯一索引
create unique index index_name on table_name (colum_name)

# 创建复合索引
create index pIndex on persons (lastname, firstname)

#删除索引
drop index index_name on table_name

desc emp

alter table emp add column age int(3);

alter table emp drop column age;

alter table emp change age age1 int(4)

alter table emp modify age int(8);

alter table emp rename empp;

alter table persons alter city set default 'beijing'




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

sql create view 
```sql
create view view_name as 
select column_name (s)
from table_name 
where condition
```


<!-- more -->

## create user
首先需要先创建用户, then 添加权限 到指定dbs/tables
```sql
create user 'user'@'localhost' identified by 'password' -- connect from localhost
create user 'user'@'%' identified by 'password'  -- connect from local machine only 
```

## add privileges

```sql
grant select ,insert ,update on dabasename.* to 'username'@'localhost' 
grant all on *.* to 'userName'@'localhost' with grant option
```

## insert on duplicate key update
插入唯一key更新
```sql
CREATE TABLE iodku (
 id INT AUTO_INCREMENT NOT NULL,
 name VARCHAR(99) NOT NULL,
 misc INT NOT NULL,
 PRIMARY KEY(id),
 UNIQUE(name)
) ENGINE=InnoDB;
INSERT INTO iodku (name, misc)
 VALUES
 ('Leslie', 123),
 ('Sally', 456);
 
 INSERT INTO iodku (name, misc)
 VALUES
 ('Sally', 3333) -- should update
 ON DUPLICATE KEY UPDATE -- `name` will trigger "duplicate key"
 id = LAST_INSERT_ID(id),
 misc = VALUES(misc);
SELECT LAST_INSERT_ID(); -- picking up existing value

```

## insert ignore existing rows
插入忽略已经存在的行
```sql
insert ignore into `people` (`id`, `name`)values('1','anni'),('2','anna');
```


```sql
CREATE TABLE iodku (
 id INT AUTO_INCREMENT NOT NULL,
 name VARCHAR(99) NOT NULL,
 misc INT NOT NULL,
 PRIMARY KEY(id),
 UNIQUE(name)
) ENGINE=InnoDB;

INSERT INTO iodku (name, misc)
 VALUES
 ('Leslie', 123),
 ('Sally', 456);
```

## insert select 
```sql
INSERT INTO `tableA` (`field_one`, `field_two`)
 SELECT `tableB`.`field_one`, `tableB`.`field_two`
 FROM `tableB`
 WHERE `tableB`.clmn <> 'someValue'
 ORDER BY `tableB`.`sorting_clmn`;

```


## delete vs Truncate 
`truncate` 会重置 `AUTO_INCREMENT` index 它比delete from 快在处理大量数据


## any_value()
```sql
SELECT item.item_id, ANY_VALUE(uses.tag) tag,
 COUNT(*) number_of_uses
 FROM item
 JOIN uses ON item.item_id, uses.item_id
GROUP BY item.item_id

select username ,any_value(password) from stack GROUP BY username
```

## sql join 
{% asset_img sql_join.png sql_join%}
z