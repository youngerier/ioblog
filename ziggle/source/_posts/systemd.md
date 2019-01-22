---
title: systemd
date: 2018-12-06 17:00:27
tags:
---


Created symlink /etc/systemd/system/redis.service → /lib/systemd/system/redis-server.service


## the environment file 

```conf
APP_ROOT=/srv/app/api
BINARY="api.jar"
PORT="1998"
USER="user"
JAVA_OPTS="-Xmx128m"
CONFIG_SERVER="-Dspring.cloud.config.uri=http://api:10000"
LOGGING="-Dlogging.config=/etc/logback-spring.xml -Dlogging.path=/opt/chuck/chuck-api/logs"
```


## the systemd unit file

```conf

[Unit]
Description=chuck-api
After=syslog.target

[Service]
EnvironmentFile=-/etc/default/chuck-api
WorkingDirectory=/opt/chuck/chuck-api/current
User=chuck
ExecStart=/usr/bin/java -Duser.timezone=UTC $LOGGING $CONFIG_SERVER $JAVA_OPTS -Dserver.port=${PORT} -jar $BINARY
StandardOutput=journal
StandardError=journal
SyslogIdentifier=chuck-api
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

其中: 
    - `WorkingDirectory` : app运行目录
    - `SyslogIdentifier` : syslog 前缀
    - `SuccessExitStatus` : JVM 成功推出码 `143` 
    - `WorkingDirectory` and `User` 不能用环境变量