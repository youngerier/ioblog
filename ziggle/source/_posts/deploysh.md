---
title: deploysh
date: 2018-08-07 23:07:41
tags:
---

```sh 
#!/bin/sh

# 结束当前运行jar

killJarApp(){
        appPid=$(ps aux |grep java |grep -v grep |awk -e "{print \$2}")
        for id in $appPid
        do
            prefix='killing app .. pid : '
            echo $prefix$id
            kill -9 $id
        done
}
killJarApp

# 运行最新jar

runLatestJarFile(){
        latestJarFile=$(ls -lt |grep "data.*jar"| head -1|awk -e "{print \$9}")
        # echo -e 'latestJarFile to Run is : '
        prefix='latestJarFile to Run is : '
        echo $prefix$latestJarFile
        # nohup java -jar ./data-2018-08-07-06-04-22.jar --spring.profiles.active=prod --server.port=8081 &> 8081nohup.out&
        nohup java -jar $latestJarFile --spring.profiles.active=prod --server.port=8081 &> 8081nohup.out&
}
runLatestJarFile

```
