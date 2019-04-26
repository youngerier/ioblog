---
title: sql2elasticsearch
date: 2019-04-26 16:22:24
tags:
---
## 导出数据elasticsearch

logstash config

```conf
[root@localhost ~]# cat /srv/docker-elk/logstash/pipeline/sqlserver.conf 
input {
    jdbc {
        jdbc_driver_library => "/var/mssql-jdbc-7.2.2.jre8.jar"
        jdbc_driver_class => "com.microsoft.sqlserver.jdbc.SQLServerDriver"
        jdbc_connection_string => "jdbc:sqlserver://host:1433;databaseName=db"
        jdbc_user => "a"
        jdbc_password => "a"
        schedule => "* * * * *"
        jdbc_default_timezone => "Asia/Shanghai"
        statement => "SELECT * FROM [backup].[dbo].[data_task] WHERE task_id > :sql_last_value"
        use_column_value => true
        tracking_column => "id"
        type => "task_table"
    }
}

output {
	if [type] == "task_table" {
	    elasticsearch {
	        index => "tasks"
	        hosts => ["elasticsearch:9200"]
	    }
	}
}
```

其中 `sql_last_value` 计算查询条件的值
