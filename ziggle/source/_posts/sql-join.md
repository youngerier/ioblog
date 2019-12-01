---
title: sql-join
date: 2019-12-01 17:38:39
tags:
---



ref >> `https://blog.csdn.net/yu849893679/article/details/86487628`
对于SQL的Join，在学习起来可能是比较乱的。我们知道，SQL的Join语法有很多inner的，有outer的，有left的，有时候，对于Select出来的结果集是什么样子有点不是很清楚。Coding Horror上有一篇文章,通过韦恩图(Venn diagram,可用来表示多个集合之间的逻辑关系)。解释了SQL的Join。我觉得清楚易懂，转过来。

假设我们有两张表。Table A 是左边的表。Table B 是右边的表。其各有四条记录，其中有两条记录name是相同的，如下所示：让我们看看不同JOIN的不同

A表
id	name
1	Pirate
2	Monkey
3	Ninja
4	Spaghetti
B表
id	name
1	Rutabaga
2	Pirate
3	Darth Vade
4	Ninja
1.INNER JOIN

SELECT * FROM TableA INNER JOIN TableB ON TableA.name = TableB.name

结果集
(TableA.)	(TableB.)
id	name	id	name
1	Pirate	2	Pirate
3	Ninja	4	Ninja
 

Inner join 产生的结果集中，是A和B的交集。

<!-- more -->

2.FULL [OUTER] JOIN 

(1)

SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name 

结果集
(TableA.)	(TableB.)
id	name	id	name
1	Pirate	2	Pirate
2	Monkey	null	null
3	Ninja	4	Ninja
4	Spaghetti	null	null
null	null	1	Rutabaga
null	null	3	Darth Vade
Full outer join 产生A和B的并集。但是需要注意的是，对于没有匹配的记录，则会以null做为值。

可以使用IFNULL判断。



(2)

SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name
WHERE TableA.id IS null OR TableB.id IS null

结果集
(TableA.)	(TableB.)
id	name	id	name
2	Monkey	null	null
4	Spaghetti	null	null
null	null	1	Rutabaga
null	null	3	Darth Vade
产生A表和B表没有交集的数据集。



 

3.LEFT [OUTER] JOIN

(1)

SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name

结果集
(TableA.)	(TableB.)
id	name	id	name
1	Pirate	2	Pirate
2	Monkey	null	null
3	Ninja	4	Ninja
4	Spaghetti	null	null
Left outer join 产生表A的完全集，而B表中匹配的则有值，没有匹配的则以null值取代。



(2)

SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name WHERE TableB.id IS null

结果集
(TableA.)	(TableB.)
id	name	id	name
2	Monkey	null	null
4	Spaghetti	null	null
产生在A表中有而在B表中没有的集合。



4.RIGHT [OUTER] JOIN

RIGHT OUTER JOIN 是后面的表为基础，与LEFT OUTER JOIN用法类似。这里不介绍了。

5.UNION 与 UNION ALL

UNION 操作符用于合并两个或多个 SELECT 语句的结果集。
请注意，UNION 内部的 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每条 SELECT 语句中的列的顺序必须相同。UNION 只选取记录，而UNION ALL会列出所有记录。

(1)SELECT name FROM TableA UNION SELECT name FROM TableB

新结果集
name
Pirate
Monkey
Ninja
Spaghetti
Rutabaga
Darth Vade
选取不同值

(2)SELECT name FROM TableA UNION ALL SELECT name FROM TableB

新结果集
name
Pirate
Monkey
Ninja
Spaghetti
Rutabaga
Pirate
Darth Vade
Ninja
全部列出来

(3)注意:

SELECT * FROM TableA UNION SELECT * FROM TableB

新结果集
id	name
1	Pirate
2	Monkey
3	Ninja
4	Spaghetti
1	Rutabaga
2	Pirate
3	Darth Vade
4	Ninja
由于 id 1 Pirate   与 id 2 Pirate 并不相同，不合并

 

还需要注册的是我们还有一个是“交差集” cross join, 这种Join没有办法用文式图表示，因为其就是把表A和表B的数据进行一个N*M的组合，即笛卡尔积。表达式如下：SELECT * FROM TableA CROSS JOIN TableB

这个笛卡尔乘积会产生 4 x 4 = 16 条记录，一般来说，我们很少用到这个语法。但是我们得小心，如果不是使用嵌套的select语句，一般系统都会产生笛卡尔乘积然再做过滤。这是对于性能来说是非常危险的，尤其是表很大的时候。
————————————————
版权声明：本文为CSDN博主「蓝海丶丶」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yu849893679/article/details/86487628