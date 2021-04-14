---
title: MySQL开发规范
date: 2021-04-14 19:36:40
tags:
---
## MySQL开发规范 ##

## 一 表设计

### 1.1 命名

**库名、表名、字段名必须使用英文单词（单数）表示表的意义，一个单词不足以表示时两者之间使用”_”（表与字段）分割。 原则上不能超过20个字符**

- **table命名:(单数，多个单词，”_”分隔）**

 Bad Example: csw_creditcard_bills

 Good Example: csw_creditcard_bill

- **index命名:**

**一般索引（Btree）命名：**

Bad Example:   index_uid_accid_type(uid, type, acid)

Good Example:  idx_uid_type_acid(uid, type, acid)(索引表包含索引的所有信息，顺序一致，准确无误)。

**唯一键索引命名：**

Bad Example: bill_no (bill_no)

Good Example: uk_bill_no (bill_no)。

- **字段的命名:**

> 定义意义完整的单词或组合单词作为字段名,”_”分隔不同意义单词  

> Bad Example： 字段名：name

> Good Example： 字段名：xxx_name 因为名称可以有多个，昵称，登录名等等。

### 1.2 字段类型使用

**VARCHAR类型( 0-65535 Bytes)**

适用于动态长度字符串,尽量根据业务需求定义合适的字段长度，不要为了图省事，直接定义为varchar(1024)或更长等等。

**Char类型（字符数0-255）**

适合所有固定字符串，如UUID char(36).不要使用Varchar类型。

**Text 类型**

仅当字符数量可能超过 20000 个的时候，才可以使用 TEXT 类型来存放字符类数据 （原因在于varchar最多可存65535Bytes，utf8字符集下每字符占用3个字节，65535/3=20000+）所有使用 TEXT 类型的字段必须和原表进行分拆，与原表主键单独组成另外一个表进行存放.（原因在于，数据库按行扫描并获取数据，如果存在text字段，将大大增加行检索成本，分出去以后可按原表主键再获取text值。

**禁用VARBINARY、BLOB存储图片、文件等**

**Enum类型**

用 0， 1 ，2 等数字tinyint类型来代替Enum

**Date类型**

所有需要精确到时间（时分秒）的字段均使用TIMESTAMP

所有只需要精确到天的字段全部使用 DATE 类型，而不应该使用 TIMESTAMP 或者DATETIME 类型。

**Integer 类型**

所有整数类型的字段尽量使用合适的大小，且明确标识出为无符号型(UNSIGNED)，除非确实会出现负数，仅仅当该字段数字取值会超过22亿，才使用 BIGINT 类型
```
类型   	字节	最小值  	最大值
　	　	(带符号的/无符号的)	(带符号的/无符号的)
TINYINT	  1	   -128     	127
　	　	          0     	255
SMALLINT  2	-32768      	32767
　	　         	0       	65535
MEDIUMINT 3	-8388608    	8388607
　	　         	0       	16777215
INT	      4	-2147483648 	2147483647
　	              0　	 	4294967295
BIGINT	  8	-9223372036854770000 	9223372036854770000
　	　             0 	 	18446744073709500000
```
**浮点数类型**

存储精确浮点数必须使用DECIMAL替代FLOAT和DOUBLE或转为整形(推荐)字段


### 1.3 设计

+ 所有表必须包含三列，自增ID主键，unsigned数据类型,created_at(记录创建时间),updated_at(记录更新时间)

```
Example：
create table t1(
id  int unsigned NOT NULL AUTO_INCREMENT,
created_time     timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_time  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=InnoDB comment '表描述';

```
+ 尽量做好适当的字段冗余(例：uid)

```

Example:
create table t1 (
  id           int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  uid          int unsigned NOT NULL COMMENT '用户ID',
  created_time    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (id)
) ENGINE=InnoDB comment 'table描述';

```
MySQL5.6之后timestamp可以支持多列字段拥有自动插入时间和自动更新时间：DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

MySQL5.6之之前timestamp仅支持一列字段拥有自动插入时间和自动更新时间：DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP


+ 索引字段属性设置为not null default 值（不能索引Null值）

+ 添加字段时不可带after,before,新加字段在表末尾添加

+ 表字符集采用utf8，不区分大小写（不使用utf8-bin）

+ 表存储引擎Innodb

+ 表及字段必须使用中文注释，简洁明了

+ 线上涉及表结构变更需至少提前24小时通知dba，大表提前1周。（在开发阶段与dba讨论db设计)

+ 状态型及类型列使用tinyint即可，原则上不能建索引（如status，type）

+ 禁止使用force index 等加hint方式使用索引

## 二 索引设计

+  索引名称必须使用小写

+  非唯一索引必须按照“idx_字段名”进行命名

+  唯一索引必须按照“uk_字段名”进行命名

+  索引中的字段数建议不超过5个，单张表的索引数量控制在5个以内

+  ORDER BY，GROUP BY，DISTINCT的字段尽量使用索引

+  使用EXPLAIN判断SQL语句是否合理使用索引，尽量避免extra列出现：Using File Sort，Using Temporary

+  对长度过长的VARCHAR字段必须建立索引时，使用Hash字段建立索引或者使用前缀索引,例：(idx(clumn(8)))

+  合理创建联合索引，一定注意重复率低及高频查询字段作为前缀索引


**Bad Example：**

```
create table t1(
id              int unsigned NOT NULL AUTO_INCREMENT,
uid int unsigned NOT NULL comment '用户id'
status tinyint not null default 0 comment '状态描述',
type tinyint not null default 0 comment '字段类型',
created_time     NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_time  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`),
unique key uk_status_type_uid(status,type,uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment '表描述';
```

**Good Example:**
```
create table t1(
id              int unsigned NOT NULL AUTO_INCREMENT,
uid int unsigned NOT NULL comment '用户id'
status tinyint not null default 0 comment '状态描述',
type tinyint not null default 0 comment '字段类型',
created_time     timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_time  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`),z
unique key uk_uid_status_type(uid,status,type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment '表描述';
```

+  innodb 所有表必须建ID主键

+  索引设计尽可能够用就好，避免无效索引

##  三 SQL编写

+  WHERE条件中必须使用合适的数据类型，避免MySQL进行隐式类型转化

+  SELECT、INSERT语句必须显式的指明业务所需的字段名称，如果取值不是全表，希望指定列名，不允许select

+  避免复杂sql，降低业务耦合，方便之后的scale out 和sharding（如之后查询多个数据库等并发进行）

+  对于结果较多的分页查询


**Bad Example：**

```
SELECT * FROM relation where biz_type ='0' AND end_time >='2014-05-29' ORDER BY id asc LIMIT 149420 ,20;
```

**Good Example：**
```
SELECT a.* FROM relation a, (select id from relation where biz_type ='0' AND end_time >='2014-05-29' ORDER BY id asc LIMIT 149420 ,20 ) b where a.id=b.id;。
```

+  避免在SQL语句进行数学运算或者函数运算（应在程序端完成）

+  用in or join代替子查询，in包含的值不易超过2000(整形)

+  表连接规范避免使用JOIN


  所有非外连接的 SQL 不要使用 Join ... On ... 方式进行连接，而直接通过普通的 Where条件关联方式。外连接的 SQL 语句，可以使用 Left Join ... On 的 Join 方式，且所有外连接一律写成 Left Join，而不要使用 Right Join。


**Bad Example:**
```
select a.id,b.id from a join b on a.id = b.a_id where
```

**Good Example:**

```
select a.id,b.id from a,b where a.id = b.a_id and ...
```
+  禁止insert、update、delete中做跨库操作，例：insert ... wac.tbl_user

+  业务逻辑中禁止使用存储过程、触发器、函数、外键等

+  禁止使用order by rand()，now()函数

+  如要insert ... on duplicate key update需通知dba审核

+  禁止使用union，用union all代替

+  用union all 代替 or

+  以下查询不能索引(not,!=,<>,!<,!>,not exist,not in,not like)(%like)

+  可用explain观察sql执行计划，show profile 观察sql的性能损耗情况，目前我们环境中  5.6版本可对select，update，delete语句均支持执行计划

-------